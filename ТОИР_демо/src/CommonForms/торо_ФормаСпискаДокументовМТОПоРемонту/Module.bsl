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
		
		Если Параметры.Свойство("Дата") Тогда
			Дата = Параметры.Дата;
		КонецЕсли;
		
		Если Параметры.Свойство("ТабЧасть") Тогда
			Для каждого Стр Из Документ[Параметры.ТабЧасть] Цикл
				НС = СписокID.Добавить();
				НС.ОР = Стр[ОР];
				НС.ID = Стр.ID;
				
				Если ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ВыявленныеДефекты") Тогда 
					НС.ВидРемонтов = Константы.торо_ВидРемонтаПриВводеНаОснованииВыявленныхДефектов.Получить();
					НС.Дата = Документ[Дата];
				Иначе
					НС.ВидРемонтов = Стр[ВР];
					НС.Дата = Стр[Дата];
				КонецЕсли;
			КонецЦикла;
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
	ПолеУслОформления.Поле = Новый ПолеКомпоновкиДанных("СписокДокументовДеревоДокумент");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РазвернутьВсеСтроки(Команды.Найти("РазвернутьВсеСтроки"));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументовДерево

&НаКлиенте
Процедура СписокДокументовДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.СписокДокументовДерево.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, ТекДанные.Документ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
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
		Элементы.СписокДокументовДерево.Развернуть(ТекСтрока.ПолучитьИдентификатор(), Истина);
	КонецЦикла
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсеСтроки(Команда)
	
	Для каждого Стр Из СписокДокументовДерево.ПолучитьЭлементы() Цикл
		
		СвернутьПодчиненные(Стр);
		Элементы.СписокДокументовДерево.Свернуть(Стр.ПолучитьИдентификатор());
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ПостроитьДеревоДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СписокID.ID,
	|	СписокID.ОР КАК ОбъектРемонта,
	|	СписокID.ВидРемонтов,
	|	СписокID.Дата
	|ПОМЕСТИТЬ СписокID
	|ИЗ
	|	&СписокID КАК СписокID
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	торо_Ремонты.Регистратор,
	|	торо_Ремонты.ID
	|ПОМЕСТИТЬ ВсеДокументыПоРемонтам
	|ИЗ
	|	РегистрСведений.торо_Ремонты КАК торо_Ремонты
	|ГДЕ
	|	торо_Ремонты.ID В
	|			(ВЫБРАТЬ
	|				СписокID.ID
	|			ИЗ
	|				СписокID КАК СписокID)
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	торо_ИнтеграцияДокументов.ДокументЕРП КАК Документ,
	|	торо_ИнтеграцияДокументов.ДокументЕРП.Проведен КАК Проведен,
	|	торо_ИнтеграцияДокументов.ДокументЕРП.ПометкаУдаления КАК ПометкаУдаления,
	|	ВнутреннееПотреблениеТоваров.Ссылка КАК ПотреблениеНаОсновании,
	|	ВнутреннееПотреблениеТоваров.ПометкаУдаления КАК ПотреблениеНаОснованииПометкаУдаления,
	|	ВнутреннееПотреблениеТоваров.Проведен КАК ПотреблениеНаОснованииПроведен,
	|	СписокID.ОбъектРемонта КАК ОбъектРемонта,
	|	СписокID.ВидРемонтов КАК ВидРемонтов,
	|	СписокID.Дата КАК Дата,
	|	СписокID.ID
	|ИЗ
	|	СписокID КАК СписокID
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ИнтеграцияДокументов КАК торо_ИнтеграцияДокументов
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|			ПО торо_ИнтеграцияДокументов.ДокументЕРП = ВнутреннееПотреблениеТоваров.ЗаказНаВнутреннееПотребление
	|		ПО СписокID.ID = торо_ИнтеграцияДокументов.ID
	|
	|СГРУППИРОВАТЬ ПО
	|	торо_ИнтеграцияДокументов.ДокументЕРП,
	|	торо_ИнтеграцияДокументов.ДокументЕРП.Проведен,
	|	торо_ИнтеграцияДокументов.ДокументЕРП.ПометкаУдаления,
	|	ВнутреннееПотреблениеТоваров.Ссылка,
	|	ВнутреннееПотреблениеТоваров.ПометкаУдаления,
	|	ВнутреннееПотреблениеТоваров.Проведен,
	|	СписокID.ID,
	|	СписокID.ОбъектРемонта,
	|	СписокID.Дата,
	|	СписокID.ВидРемонтов
	|ИТОГИ
	|	МАКСИМУМ(Дата)
	|ПО
	|	СписокID.ID,
	|	ОбъектРемонта,
	|	ВидРемонтов,
	|	Документ,
	|	ПотреблениеНаОсновании";
	
	Запрос.УстановитьПараметр("СписокID",СписокID.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	СписокДокументов = РеквизитФормыВЗначение("СписокДокументовДерево");
	
	Пока Выборка.Следующий() Цикл
		ВыборкаОбъектыРемонта = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОбъектыРемонта.Следующий() Цикл
			ДобавляемаяСтрокаОбъект = СписокДокументов.Строки.Добавить();
			ДобавляемаяСтрокаОбъект.Документ = ВыборкаОбъектыРемонта.ОбъектРемонта;
			ДобавляемаяСтрокаОбъект.Картинка = 6;
			ДобавляемаяСтрокаОбъект.ДокументТекст = ДобавляемаяСтрокаОбъект.Документ;
			
			ВыборкаВидыРемонтов = ВыборкаОбъектыРемонта.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаВидыРемонтов.Следующий() Цикл
				ДобавляемаяСтрокаВидРемонта = ДобавляемаяСтрокаОбъект.Строки.Добавить();
				ДобавляемаяСтрокаВидРемонта.Документ = ВыборкаВидыРемонтов.ВидРемонтов;
				ДобавляемаяСтрокаВидРемонта.Картинка = 7;
				ДобавляемаяСтрокаВидРемонта.ДокументТекст = Строка(ДобавляемаяСтрокаВидРемонта.Документ) + " : " + Формат(ВыборкаВидыРемонтов.Дата,"ДФ=dd.MM.yyyy");
				
				ВыборкаДокументы = ВыборкаВидыРемонтов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаДокументы.Следующий() И ЗначениеЗаполнено(ВыборкаДокументы.Документ) Цикл
					ДобавляемаяСтрокаДокумент = ДобавляемаяСтрокаВидРемонта.Строки.Добавить();
					ДобавляемаяСтрокаДокумент.Документ = ВыборкаДокументы.Документ;
					ДобавляемаяСтрокаДокумент.ПометкаУдаления = ВыборкаДокументы.ПометкаУдаления;
					ДобавляемаяСтрокаДокумент.Проведен = ВыборкаДокументы.Проведен;
					ДобавляемаяСтрокаДокумент.Картинка = ПолучитьИндексКартинкиВКоллекции(ДобавляемаяСтрокаДокумент);
					ДобавляемаяСтрокаДокумент.ДокументТекст = ДобавляемаяСтрокаДокумент.Документ;
					
					ВыборкаПотребленияНаОсновании = ВыборкаДокументы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаПотребленияНаОсновании.Следующий() И ЗначениеЗаполнено(ВыборкаПотребленияНаОсновании.ПотреблениеНаОсновании) Цикл
						ДобавляемаяСтрокаПотреблениеНаОсновании = ДобавляемаяСтрокаДокумент.Строки.Добавить();
						ДобавляемаяСтрокаПотреблениеНаОсновании.Документ = ВыборкаПотребленияНаОсновании.ПотреблениеНаОсновании;
						ДобавляемаяСтрокаПотреблениеНаОсновании.ПометкаУдаления = ВыборкаПотребленияНаОсновании.ПотреблениеНаОснованииПометкаУдаления;
						ДобавляемаяСтрокаПотреблениеНаОсновании.Проведен = ВыборкаПотребленияНаОсновании.ПотреблениеНаОснованииПроведен;
						ДобавляемаяСтрокаПотреблениеНаОсновании.Картинка = ПолучитьИндексКартинкиВКоллекции(ДобавляемаяСтрокаПотреблениеНаОсновании);
						ДобавляемаяСтрокаПотреблениеНаОсновании.ДокументТекст = ДобавляемаяСтрокаПотреблениеНаОсновании.Документ;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	ЗначениеВРеквизитФормы(СписокДокументов,"СписокДокументовДерево");
	
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

&НаКлиенте
Процедура СвернутьПодчиненные(Строка)
	
	Для каждого Стр Из Строка.ПолучитьЭлементы() Цикл
		
		СвернутьПодчиненные(Стр);
		Элементы.СписокДокументовДерево.Свернуть(Стр.ПолучитьИдентификатор());
		
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьСостояниеДерева()
	
	Если Элементы.СписокДокументовДерево.ТекущиеДанные <> Неопределено Тогда
		ТекущийДокумент = Элементы.СписокДокументовДерево.ТекущиеДанные.ДокументТекст;
	КонецЕсли;

	Для Каждого СтрокаДерева Из СписокДокументовДерево.ПолучитьЭлементы() Цикл
		ПолучитьМассивРазвернутыхЭлементов(МассивРазвернутыхЭлементов,СтрокаДерева);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьМассивРазвернутыхЭлементов(МассивРазвернутыхЭлементов,Строка)
	     
	Если Элементы.СписокДокументовДерево.Развернут(Строка.ПолучитьИдентификатор()) Тогда
		МассивРазвернутыхЭлементов.Добавить(Строка.ДокументТекст);
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
	
	Элементы.СписокДокументовДерево.ТекущаяСтрока = ИдентификаторТекущего;
	
	МассивРазвернутыхЭлементов.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВетвиДерева(МассивРазвернутыхЭлементов,СтрокаДерева)
	
	Если СтрокаДерева.ДокументТекст = ТекущийДокумент Тогда
		ИдентификаторТекущего = СтрокаДерева.ПолучитьИдентификатор();
	КонецЕсли;
		
	Если МассивРазвернутыхЭлементов.Найти(СтрокаДерева.ДокументТекст) <> Неопределено Тогда
		
		Элементы.СписокДокументовДерево.Развернуть(СтрокаДерева.ПолучитьИдентификатор());
		Для Каждого СтрокаДереваПодчиненная Из СтрокаДерева.ПолучитьЭлементы() Цикл
		
			РазвернутьВетвиДерева(МассивРазвернутыхЭлементов,СтрокаДереваПодчиненная);
						
		КонецЦикла;
	Иначе
		Элементы.СписокДокументовДерево.Свернуть(СтрокаДерева.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

МассивРазвернутыхЭлементов = Новый Массив;
#КонецОбласти

