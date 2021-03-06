////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

// Переменные для сохранения и восстановления состояния дерева
&НаКлиенте
Перем МассивРазвернутыхЭлементов;
&НаКлиенте
Перем ТекущийДокумент;
&НаКлиенте
Перем ИдентификаторТекущего;

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документ") Тогда
		Документ = Параметры.Документ;
		
		Если Параметры.Свойство("ОР") Тогда
			ОР = Параметры.ОР;
		КонецЕсли;
		
		Если Параметры.Свойство("ВР") Тогда
			ВР = Параметры.ВР;
		КонецЕсли;
		
		Если Параметры.Свойство("ТабЧасть") Тогда
			Для каждого Стр Из Документ[Параметры.ТабЧасть] Цикл
				НС = СписокID.Добавить();
				НС.ОР = Стр[ОР];
				НС.ID = Стр.ID;
				Если ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ВыявленныеДефекты") 
					ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ВнешнееОснованиеДляРабот") Тогда 
					НС.ВидРемонтов = Константы.торо_ВидРемонтаПриВводеНаОснованииВыявленныхДефектов.Получить();
				Иначе
					НС.ВидРемонтов = Стр[ВР];
				КонецЕсли;
			КонецЦикла;
			Если ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ОстановочныеРемонты") Тогда
				НС = СписокID.Добавить();
				НС.ОР = Документ.ОбъектРемонта;
				НС.ВидРемонтов = Документ.ВидРемонта;
				НС.ID = Документ.IDОсновногоРемонта;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПостроитьДеревоДокументов();
	
	УсловноеОформление.Элементы.Очистить();
	ЭлемУслОформ = УсловноеОформление.Элементы.Добавить();
	ЭлемУслОформ.Использование = Истина;
	
	ОтборУслОформления = ЭлемУслОформ.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборУслОформления.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборУслОформления.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументовДерево.Документ");
	ОтборУслОформления.ПравоеЗначение = Документ;
	ОтборУслОформления.Использование = Истина;
	
	ОформлениеУслОформления = ЭлемУслОформ.Оформление.Элементы[5];
	ОформлениеУслОформления.Использование = Истина;
	ОформлениеУслОформления.Значение = Новый Шрифт(,,Истина);
	
	ПолеУслОформления = ЭлемУслОформ.Поля.Элементы.Добавить();
	ПолеУслОформления.Использование = Истина;
	ПолеУслОформления.Поле = Новый ПолеКомпоновкиДанных("СписокДокументовДокументТекст");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов
&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, ТекДанные.Документ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	// Проверяем, если в выбранной строке документ
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные <> Неопределено И ТекДанные.ЯвляетсяДокументом Тогда
		Если ТекДанные.Проведен Тогда
			Элементы.ФормаПровести.Доступность = Ложь;
			Элементы.ФормаОтменаПроведения.Доступность = Истина;
		Иначе
			Элементы.ФормаПровести.Доступность = Истина;
			Элементы.ФормаОтменаПроведения.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ФормаПровести.Доступность = Ложь;
		Элементы.ФормаОтменаПроведения.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Провести(Команда)
	
	ЗаписатьСостояниеДерева();
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТекДанные.ПометкаУдаления Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Помеченный на удаление документ не может быть проведен!'"));
		Возврат;
	ИначеЕсли ПолучитьДатуДокумента(ТекДанные.Документ) > КонецДня(ТекущаяДата()) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нельзя проводить документы будущей датой!'"));
		Возврат;
	КонецЕсли;
	
	Попытка
		ЗаписатьВыбранныйДокумент(РежимЗаписиДокумента.Проведение, ТекДанные.Документ);
		Элементы.ФормаПровести.Доступность = Ложь;
		Элементы.ФормаОтменаПроведения.Доступность = Истина;
	Исключение
	КонецПопытки;
	ВосстановитьСостояниеДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменаПроведения(Команда)
	
	ЗаписатьСостояниеДерева();
	ТекДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ТекДанные.Проведен Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Документ не проведен.'"));
		Возврат;
	КонецЕсли;
	Попытка
		ЗаписатьВыбранныйДокумент(РежимЗаписиДокумента.ОтменаПроведения, ТекДанные.Документ);
		Элементы.ФормаПровести.Доступность = Истина;
		Элементы.ФормаОтменаПроведения.Доступность = Ложь;
	Исключение
	КонецПопытки;
	ВосстановитьСостояниеДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаписатьСостояниеДерева();
	СписокДокументовДерево.ПолучитьЭлементы().Очистить();
	ПостроитьДеревоДокументов();
	ВосстановитьСостояниеДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсеСтроки(Команда)
	
	Для Каждого ТекСтрока Из СписокДокументовДерево.ПолучитьЭлементы() Цикл
		Элементы.СписокДокументов.Развернуть(ТекСтрока.ПолучитьИдентификатор(), Истина);
	КонецЦикла
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсеСтроки(Команда)
	
	Для каждого Стр Из СписокДокументовДерево.ПолучитьЭлементы() Цикл
		
		СвернутьПодчиненные(Стр);
		Элементы.СписокДокументов.Свернуть(Стр.ПолучитьИдентификатор());
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ПостроитьДеревоДокументов()
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	торо_АктОВыполненииЭтапаРаботРемонтыОборудования.ДокументИсточник КАК ДокументИсточник,
	               |	торо_АктОВыполненииЭтапаРабот.Ссылка КАК Ссылка,
	               |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК Дата,
				   |	торо_АктОВыполненииЭтапаРабот.Проведен КАК Проведен,
				   |	торо_АктОВыполненииЭтапаРабот.ПометкаУдаления КАК ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_АктОВыполненииЭтапаРабот.РемонтыОборудования КАК торо_АктОВыполненииЭтапаРаботРемонтыОборудования
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_АктОВыполненииЭтапаРабот КАК торо_АктОВыполненииЭтапаРабот
	               |		ПО торо_АктОВыполненииЭтапаРаботРемонтыОборудования.Ссылка = торо_АктОВыполненииЭтапаРабот.Ссылка
	               |ГДЕ
	               |	торо_АктОВыполненииЭтапаРаботРемонтыОборудования.ID = &ID
	               |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
	               |	торо_АктПриемкиОборудованияРемонтыОборудования.ДокументИсточник КАК ДокументИсточник,
	               |	торо_АктПриемкиОборудования.Ссылка КАК Ссылка,
	               |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК Дата,
				   |	торо_АктПриемкиОборудования.Проведен КАК Проведен,
				   |	торо_АктПриемкиОборудования.ПометкаУдаления КАК ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_АктПриемкиОборудования.РемонтыОборудования КАК торо_АктПриемкиОборудованияРемонтыОборудования
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_АктПриемкиОборудования КАК торо_АктПриемкиОборудования
	               |		ПО торо_АктПриемкиОборудованияРемонтыОборудования.Ссылка = торо_АктПриемкиОборудования.Ссылка
	               |ГДЕ
	               |	торо_АктПриемкиОборудованияРемонтыОборудования.ID = &ID
				   // регламентные мероприятия +
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
	               |	торо_АктОВыполненииЭтапаРаботРемонтыОборудования.ДокументИсточник КАК ДокументИсточник,
	               |	торо_АктОВыполненииЭтапаРабот.Ссылка КАК Ссылка,
	               |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК Дата,
				   |	торо_АктОВыполненииЭтапаРабот.Проведен КАК Проведен,
				   |	торо_АктОВыполненииЭтапаРабот.ПометкаУдаления КАК ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_АктОВыполненииРегламентногоМероприятия.Мероприятия КАК торо_АктОВыполненииЭтапаРаботРемонтыОборудования
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_АктОВыполненииРегламентногоМероприятия КАК торо_АктОВыполненииЭтапаРабот
	               |		ПО торо_АктОВыполненииЭтапаРаботРемонтыОборудования.Ссылка = торо_АктОВыполненииЭтапаРабот.Ссылка
	               |ГДЕ
	               |	торо_АктОВыполненииЭтапаРаботРемонтыОборудования.ID = &ID
				   // регламентные мероприятия -
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ВЫБОР КОГДА торо_ВыявленныеДефектыСписокДефектов.ЗакрываетПредписание ТОГДА торо_ВыявленныеДефектыСписокДефектов.ДокументИсточник ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ,
	               |	торо_ВыявленныеДефекты.Ссылка,
	               |	торо_ВыявленныеДефекты.ДатаОбнаружения,
				   |	торо_ВыявленныеДефекты.Проведен,
				   |	торо_ВыявленныеДефекты.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_ВыявленныеДефекты.СписокДефектов КАК торо_ВыявленныеДефектыСписокДефектов
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_ВыявленныеДефекты КАК торо_ВыявленныеДефекты
	               |		ПО торо_ВыявленныеДефектыСписокДефектов.Ссылка = торо_ВыявленныеДефекты.Ссылка
	               |ГДЕ
	               |	торо_ВыявленныеДефектыСписокДефектов.ID = &ID
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	торо_ЗаявкаНаРемонтРемонтыОборудования.ДокументИсточник,
	               |	торо_ЗаявкаНаРемонт.Ссылка,
	               |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0),
				   |	торо_ЗаявкаНаРемонт.Проведен,
				   |	торо_ЗаявкаНаРемонт.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_ЗаявкаНаРемонт.РемонтыОборудования КАК торо_ЗаявкаНаРемонтРемонтыОборудования
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_ЗаявкаНаРемонт КАК торо_ЗаявкаНаРемонт
	               |		ПО торо_ЗаявкаНаРемонтРемонтыОборудования.Ссылка = торо_ЗаявкаНаРемонт.Ссылка 
	               |ГДЕ
	               |	торо_ЗаявкаНаРемонтРемонтыОборудования.ID = &ID
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.ДокументИсточник,
	               |	торо_НарядНаВыполнениеРемонтныхРабот.Ссылка,
	               |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0),
				   |	торо_НарядНаВыполнениеРемонтныхРабот.Проведен,
				   |	торо_НарядНаВыполнениеРемонтныхРабот.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_НарядНаВыполнениеРемонтныхРабот.РемонтыОборудования КАК торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_НарядНаВыполнениеРемонтныхРабот КАК торо_НарядНаВыполнениеРемонтныхРабот
	               |		ПО торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.Ссылка = торо_НарядНаВыполнениеРемонтныхРабот.Ссылка 
	               |ГДЕ
	               |	торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.ID = &ID
	               |
				   // регламентные мероприятия +
				   |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.ДокументИсточник,
	               |	торо_НарядНаВыполнениеРемонтныхРабот.Ссылка,
	               |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0),
				   |	торо_НарядНаВыполнениеРемонтныхРабот.Проведен,
				   |	торо_НарядНаВыполнениеРемонтныхРабот.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_НарядНаРегламентноеМероприятие.РегламентныеМероприятия КАК торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_НарядНаРегламентноеМероприятие КАК торо_НарядНаВыполнениеРемонтныхРабот
	               |		ПО торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.Ссылка = торо_НарядНаВыполнениеРемонтныхРабот.Ссылка 
	               |ГДЕ
	               |	торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.ID = &ID
				   // регламентные мероприятия -
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	НЕОПРЕДЕЛЕНО,
	               |	торо_ПланГрафикРемонта.Ссылка,
	               |	торо_ПланГрафикРемонтаПланРемонтов.ДатаНач,
				   |	торо_ПланГрафикРемонта.Проведен,
				   |	торо_ПланГрафикРемонта.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_ПланГрафикРемонта.ПланРемонтов КАК торо_ПланГрафикРемонтаПланРемонтов
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_ПланГрафикРемонта КАК торо_ПланГрафикРемонта
	               |		ПО торо_ПланГрафикРемонтаПланРемонтов.Ссылка = торо_ПланГрафикРемонта.Ссылка
	               |ГДЕ
	               |	торо_ПланГрафикРемонтаПланРемонтов.ID = &ID
	               |
				   // регламентные мероприятия +
				   |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	НЕОПРЕДЕЛЕНО,
	               |	торо_ПланГрафикРемонта.Ссылка,
	               |	торо_ПланГрафикРемонтаПланРемонтов.ДатаНач,
				   |	торо_ПланГрафикРемонта.Проведен,
				   |	торо_ПланГрафикРемонта.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_ГрафикРегламентныхМероприятийТОиР.ПланРемонтов КАК торо_ПланГрафикРемонтаПланРемонтов
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_ГрафикРегламентныхМероприятийТОиР КАК торо_ПланГрафикРемонта
	               |		ПО торо_ПланГрафикРемонтаПланРемонтов.Ссылка = торо_ПланГрафикРемонта.Ссылка
	               |ГДЕ
	               |	торо_ПланГрафикРемонтаПланРемонтов.ID = &ID
				   |
				   // регламентные мероприятия -	
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	НЕОПРЕДЕЛЕНО,
	               |	торо_Предписание.Ссылка,
	               |	торо_ПредписанияОбследованноеОборудование.ПлановаяДатаРемонта,
				   |	торо_Предписание.Проведен,
				   |	торо_Предписание.ПометкаУдаления
	               |ИЗ
	               |	Документ.торо_ВнешнееОснованиеДляРабот.ОбследованноеОборудование КАК торо_ПредписанияОбследованноеОборудование
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_ВнешнееОснованиеДляРабот КАК торо_Предписание
	               |		ПО торо_ПредписанияОбследованноеОборудование.Ссылка = торо_Предписание.Ссылка
	               |ГДЕ
	               |	торо_ПредписанияОбследованноеОборудование.ID = &ID
				   |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	ВЫБОР
				   |		КОГДА торо_ОстановочныеРемонты.КорректируемыйДокумент = ЗНАЧЕНИЕ(Документ.торо_ОстановочныеРемонты.ПустаяСсылка)
				   |			ТОГДА торо_ОстановочныеРемонты.ДокументОснование
			   	   |		ИНАЧЕ торо_ОстановочныеРемонты.КорректируемыйДокумент
				   |	КОНЕЦ,
				   |	торо_ОстановочныеРемонты.Ссылка,
				   |	торо_ОстановочныеРемонты.ДатаНачалаРемонта,
				   |	торо_ОстановочныеРемонты.Проведен,
				   |	торо_ОстановочныеРемонты.ПометкаУдаления
				   |ИЗ
				   |	Документ.торо_ОстановочныеРемонты КАК торо_ОстановочныеРемонты
				   |ГДЕ
				   |	торо_ОстановочныеРемонты.IDОсновногоРемонта = &ID
				   |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	торо_ОстановочныеРемонтыСвязанныеРемонты.ДокументИсточник,
				   |	торо_ОстановочныеРемонтыСвязанныеРемонты.Ссылка,
				   |	торо_ОстановочныеРемонтыСвязанныеРемонты.ДатаНачалаРемонта,
				   |	торо_ОстановочныеРемонты.Проведен,
				   |	торо_ОстановочныеРемонты.ПометкаУдаления
				   |ИЗ
				   |	Документ.торо_ОстановочныеРемонты.СвязанныеРемонты КАК торо_ОстановочныеРемонтыСвязанныеРемонты
				   |	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.торо_ОстановочныеРемонты КАК торо_ОстановочныеРемонты
				   |		ПО торо_ОстановочныеРемонтыСвязанныеРемонты.Ссылка = торо_ОстановочныеРемонты.Ссылка
				   |ГДЕ
				   |	торо_ОстановочныеРемонтыСвязанныеРемонты.ID = &ID
	               |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	ЕСТЬNULL(торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеЗаявки.Заявка, НЕОПРЕДЕЛЕНО),
				   |	торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеРемонты.Ссылка,
				   |	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0),
				   |	торо_ЗакрытиеЗаявокИРемонтов.Проведен,
				   |	торо_ЗакрытиеЗаявокИРемонтов.ПометкаУдаления
				   |ИЗ
				   |	Документ.торо_ЗакрытиеЗаявокИРемонтов.ЗакрываемыеРемонты КАК торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеРемонты
				   |	ЛЕВОЕ СОЕДИНЕНИЕ Документ.торо_ЗакрытиеЗаявокИРемонтов КАК торо_ЗакрытиеЗаявокИРемонтов
				   |		ПО (торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеРемонты.Ссылка = торо_ЗакрытиеЗаявокИРемонтов.Ссылка)
				   |	ЛЕВОЕ СОЕДИНЕНИЕ Документ.торо_ЗакрытиеЗаявокИРемонтов.ЗакрываемыеЗаявки КАК торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеЗаявки
				   |		ПО (торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеРемонты.Ссылка = торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеЗаявки.Ссылка)
				   |
				   |ГДЕ
				   |	торо_ЗакрытиеЗаявокИРемонтовЗакрываемыеРемонты.ID = &ID
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДокументИсточник,
	               |	Дата УБЫВ";
				   
				   
	СписокДокументов = РеквизитФормыВЗначение("СписокДокументовДерево");
	//
	ТаблицаОбъектов = СписокID.Выгрузить(, "ОР");
	ТаблицаОбъектов.Свернуть("ОР");
	Для Каждого СтрокаС_ID Из ТаблицаОбъектов Цикл
		ДобавляемаяСтрокаОбъект = СписокДокументов.Строки.Добавить();
		ДобавляемаяСтрокаОбъект.Документ = СтрокаС_ID.ОР;
		ДобавляемаяСтрокаОбъект.Картинка = 6;
		ДобавляемаяСтрокаОбъект.ДокументТекст = ДобавляемаяСтрокаОбъект.Документ;
		ТаблицаРемонтов = СписокID.НайтиСтроки(Новый Структура("ОР",СтрокаС_ID.ОР));
		Для Каждого СтрокаСРемонтом Из ТаблицаРемонтов Цикл
			ДобавляемаяСтрокаРемонт = ДобавляемаяСтрокаОбъект.Строки.Добавить();
			ДобавляемаяСтрокаРемонт.Документ = СтрокаСРемонтом.ВидРемонтов;
			ДобавляемаяСтрокаРемонт.Картинка = 7;
			
			Запрос.УстановитьПараметр("ID",СтрокаСРемонтом.ID);   
			ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
			
			ПостроитьВетвьДереваПодчиненныхДокументов(ТаблицаДокументов, ДобавляемаяСтрокаРемонт, Неопределено);
			
			МассивДляДобавления = ТаблицаДокументов.НайтиСтроки(Новый Структура("ДокументИсточник", Неопределено));
			Если ДобавляемаяСтрокаРемонт.Строки.Количество() > 0 Тогда
				ДобавляемаяСтрокаРемонт.ДатаТОиР = МассивДляДобавления[0].Дата;
			КонецЕсли;
			
			ДобавляемаяСтрокаРемонт.ДокументТекст = "" + ДобавляемаяСтрокаРемонт.Документ + ": " + Формат(ДобавляемаяСтрокаРемонт.ДатаТОиР,"ДФ=dd.MM.yyyy");
			
			Если ID_Ремонта = СтрокаСРемонтом.ID Тогда
				Элементы.СписокДокументов.Развернуть(ДобавляемаяСтрокаРемонт,Истина);
				
				Элементы.СписокДокументов.ТекущаяСтрока = ДобавляемаяСтрокаРемонт;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(СписокДокументов, "СписокДокументовДерево");
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьВетвьДереваПодчиненныхДокументов(ТаблицаДокументов, КореньПоддерева, ЗначениеОтбора)
	МассивДляДобавления = ТаблицаДокументов.НайтиСтроки(Новый Структура("ДокументИсточник", ЗначениеОтбора));
	Для Каждого СтрокаДляДобавления Из МассивДляДобавления Цикл
		ДобавляемаяСтрокаДерева = КореньПоддерева.Строки.Добавить();
		
		ДобавляемаяСтрокаДерева.Документ 		= СтрокаДляДобавления.Ссылка;
		ДобавляемаяСтрокаДерева.Проведен 		= СтрокаДляДобавления.Проведен;
		ДобавляемаяСтрокаДерева.ПометкаУдаления = СтрокаДляДобавления.ПометкаУдаления;
		ДобавляемаяСтрокаДерева.ЯвляетсяДокументом = Истина;
		ДобавляемаяСтрокаДерева.Картинка = ПолучитьИндексКартинкиВКоллекции(ДобавляемаяСтрокаДерева.Документ);
		ДобавляемаяСтрокаДерева.ДокументТекст = ДобавляемаяСтрокаДерева.Документ;
		
		ПостроитьВетвьДереваПодчиненныхДокументов(ТаблицаДокументов, ДобавляемаяСтрокаДерева, СтрокаДляДобавления.Ссылка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьИндексКартинкиВКоллекции(ДокументСтрока)
	
	Если ДокументСтрока.Проведен Тогда
		
		Возврат 1;
		
	ИначеЕсли ДокументСтрока.ПометкаУдаления Тогда
		
		Возврат 2;
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаписатьВыбранныйДокумент(РежимЗаписи, ДокументСсылка)
	Если ДокументСсылка = Неопределено Тогда
		Возврат
	КонецЕсли;
	ДокОбъект = ДокументСсылка.ПолучитьОбъект();
	ДокОбъект.Записать(РежимЗаписи);
	ДеревоОбъект = РеквизитФормыВЗначение("СписокДокументовДерево");
	СтрокаДЗ = ДеревоОбъект.Строки.Найти(ДокументСсылка, "Документ", Истина);
	Если СтрокаДЗ <> Неопределено Тогда
		СтрокаДЗ.Проведен = ?(РежимЗаписи = РежимЗаписиДокумента.Проведение, Истина, Ложь);
		СтрокаДЗ.Картинка = ПолучитьИндексКартинкиВКоллекции(ДокументСсылка);
	КонецЕсли;
	ЗначениеВРеквизитФормы(ДеревоОбъект, "СписокДокументовДерево");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДатуДокумента(ДокументСтрока)
	
	Возврат ДокументСтрока.Дата;

КонецФункции

&НаКлиенте
Процедура СвернутьПодчиненные(Строка)
	
	Для каждого Стр Из Строка.ПолучитьЭлементы() Цикл
		
		СвернутьПодчиненные(Стр);
		Элементы.СписокДокументов.Свернуть(Стр.ПолучитьИдентификатор());
		
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьСостояниеДерева()
	
	Если Элементы.СписокДокументов.ТекущиеДанные <> Неопределено Тогда
		ТекущийДокумент = Элементы.СписокДокументов.ТекущиеДанные.ДокументТекст;
	КонецЕсли;

	Для Каждого СтрокаДерева Из СписокДокументовДерево.ПолучитьЭлементы() Цикл
		ПолучитьМассивРазвернутыхЭлементов(МассивРазвернутыхЭлементов,СтрокаДерева);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьМассивРазвернутыхЭлементов(МассивРазвернутыхЭлементов,Строка)
	     
	Если Элементы.СписокДокументов.Развернут(Строка.ПолучитьИдентификатор()) Тогда
		МассивРазвернутыхЭлементов.Добавить(Строка.Документ);
		Для Каждого СтрокаПодчиненная Из Строка.ПолучитьЭлементы() Цикл
			ПолучитьМассивРазвернутыхЭлементов(МассивРазвернутыхЭлементов,СтрокаПодчиненная);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьСостояниеДерева()
	
	Для Каждого Строка Из СписокДокументовДерево.ПолучитьЭлементы() Цикл
		
		РазвернутьВетвиДерева(МассивРазвернутыхЭлементов,Строка);
				
	КонецЦикла;
	Элементы.СписокДокументов.ТекущаяСтрока = ИдентификаторТекущего;
	МассивРазвернутыхЭлементов.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВетвиДерева(МассивРазвернутыхЭлементов,СтрокаДерева)
	
	Если МассивРазвернутыхЭлементов.Найти(СтрокаДерева.Документ) <> Неопределено Тогда
		
		Элементы.СписокДокументов.Развернуть(СтрокаДерева.ПолучитьИдентификатор());
		Для Каждого СтрокаДереваПодчиненная Из СтрокаДерева.ПолучитьЭлементы() Цикл
		
			РазвернутьВетвиДерева(МассивРазвернутыхЭлементов,СтрокаДереваПодчиненная);
		
		КонецЦикла;
	КонецЕсли;
	
	Если СтрокаДерева.ДокументТекст = ТекущийДокумент Тогда
		ИдентификаторТекущего = СтрокаДерева.ПолучитьИдентификатор();
	КонецЕсли;
		
	
	
КонецПроцедуры

МассивРазвернутыхЭлементов = Новый Массив;
#КонецОбласти

