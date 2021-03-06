#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекСтруктураИерархии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
															"НастройкиТОиР",
															"ОсновнаяСтруктураИерархии",
															Справочники.торо_СтруктурыОР.ПустаяСсылка());

	ЗаполнитьДатуВводаВЭксплуатацию();													
	
	// Заголовок формы++
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	// Заголовок формы--	

	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	
	УстановитьУсловноеОформление();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Параметры.Свойство("ОбъектРемонта") И ЗначениеЗаполнено(Параметры.ОбъектРемонта) Тогда
			
			ОбъектДокумент = РеквизитФормыВЗначение("Объект");
			ОбъектДокумент.Заполнить(Параметры.ОбъектРемонта);
			ЗначениеВРеквизитФормы(ОбъектДокумент,"Объект");
			
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			
			Объект.Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновнаяОрганизация",
			Истина);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
			
			Объект.Подразделение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновноеПодразделение",
			Истина);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
			
			Объект.Ответственный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновнойОтветственный",
			Справочники.Пользователи.ПустаяСсылка());
			
		КонецЕсли;
		
		СлужебныеРеквизитыЗаполнитьНаСервере();
		
	КонецЕсли;

		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	СлужебныеРеквизитыЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьУсловноеОформление();
	
	Если ЗначениеЗаполнено(Объект.ОбъектРемонта) Тогда
		ОбъектРемонтаПриИзменении(Истина);
	КонецЕсли;
	Элементы.ИзменитьИерархию.Заголовок = ТекСтруктураИерархии;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЭтаФорма.ВладелецФормы = Неопределено
		И ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		ПараметрыЗаписи.Вставить("ОткрытИзОР", Истина);
		ПараметрыЗаписи.Вставить("ОРВладелецОткрытойФормы", ЭтаФорма.ВладелецФормы.Объект.Ссылка);
	Иначе		
		ПараметрыЗаписи.Вставить("ОткрытИзОР", Ложь);
		ПараметрыЗаписи.Вставить("ОРВладелецОткрытойФормы", ПредопределенноеЗначение("Справочник.торо_ОбъектыРемонта.ПустаяСсылка"));
	КонецЕсли; 
	
	Отказ = НЕ ПроверитьЗаполнение();
	
	Если ЗначениеЗаполнено(Объект.ОбъектРемонта) и ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		СписокПодчиненных = ПолучитьСписокПодчиненных(Объект.ОбъектРемонта);
		Если СписокПодчиненных.Количество() > 0 Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораПользователяОСнятииСучетаПодчиненных",ЭтаФорма,Новый Структура("СписокПодчиненных, ПараметрыЗаписи",СписокПодчиненных, ПараметрыЗаписи));
			Отказ = Истина;
			ПоказатьВопрос(ОписаниеОповещения,НСтр("ru = 'У объекта ремонта имеются подчиненные объекты, принятые к учету. Снять их с учета?'"),РежимДиалогаВопрос.ДаНет,,,НСтр("ru = 'Снятие подчиненных с учета'"));
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ТекущийОбъект.ОткрытИзФормыОР = ПараметрыЗаписи.ОткрытИзОР;
	ТекущийОбъект.ОРВладелец      = ПараметрыЗаписи.ОРВладелецОткрытойФормы;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	
	// Заголовок формы++
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	// Заголовок формы--	

	СлужебныеРеквизитыЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("СОЗДАН_ДОКУМЕНТ_СНЯТИЕ_С_УЧЕТА",Объект.ОбъектРемонта,ЭтаФорма.ВладелецФормы);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектРемонтаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ОбъектРемонта) Тогда
		ЗаполнитьДатуВводаВЭксплуатацию();
		ЗаполнитьДанныеОТекущемПоложенииНаСервере();
		ЗаполнитьВходилВСоставПоТекущейИерархии();
	КонецЕсли; 

КонецПроцедуры  

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	ОповещениеПользователя = Новый ОписаниеОповещения("ОбработкаВыбораПользователя", ЭтаФорма, Новый Структура ("Склад",Объект.Склад));
	ПоказатьВопрос(ОповещениеПользователя,НСтр("ru = 'Заполнить поле <Склад> в табличной части <Номенклатура>?'"),РежимДиалогаВопрос.ДаНет,,,НСтр("ru = 'Указать склад'"));
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНоменклатура
&НаКлиенте
Процедура НоменклатураНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ТекДанные = Элементы.Номенклатура.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		
		СтрокиСВыбраннойНоменклатурой = Объект.Номенклатура.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры",ВыбранноеЗначение, ТекДанные.ХарактеристикаНоменклатуры));
		Если СтрокиСВыбраннойНоменклатурой.Количество() > 0 Тогда
			СтандартнаяОбработка = Ложь;
			ТекДанные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выбранная номенклатура с характеристикой уже имеется.'"));
			Возврат;
		КонецЕсли;			
		
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураХарактеристикаНоменклатурыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Номенклатура.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		
		СтрокиСВыбраннойНоменклатурой = Объект.Номенклатура.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры", ТекДанные.Номенклатура,ВыбранноеЗначение));
		Если СтрокиСВыбраннойНоменклатурой.Количество() > 0 Тогда
			СтандартнаяОбработка = Ложь;
			ТекДанные.ХарактеристикаНоменклатуры = ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выбранная номенклатура с характеристикой уже имеется.'"));
			Возврат;
		КонецЕсли;			
		
	КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура НоменклатураНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Номенклатура.ТекущиеДанные;
	
	ТекущаяСтрока.ХарактеристикиИспользуются = ПолучитьХарактеристикиИспользуются(ТекущаяСтрока.Номенклатура);
	
	Если Не ТекущаяСтрока.ХарактеристикиИспользуются Тогда
		ТекущаяСтрока.ХарактеристикаНоменклатуры = Неопределено;
	КонецЕсли;


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
    УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ИзменитьИерархию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораИерахии", ЭтаФорма);
	ПараметрыФормыИерархии = Новый Структура("СписокИерархийОР", ЗаполнитьСписокСтруктурНаСервере(ТекСтруктураИерархии));
	ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаНастройкиВидаИерархии",ПараметрыФормыИерархии,ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОбъектРемонтаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СписокДоступныхСтатусов = ПолучитьСписокСтатусовНаСервере();
	
	ПараметрыОтбора = Новый Структура("СписокСтатусов", СписокДоступныхСтатусов);
	ПараметрыОтбора.Вставить("СтруктураИерархии",       ТекСтруктураИерархии);
	
	ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаВыбора",ПараметрыОтбора,Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Функция ПолучитьХарактеристикиИспользуются(Номенклатура)
	
	Возврат НЕ Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать = Номенклатура.ИспользованиеХарактеристик;
	
КонецФункции

&НаСервере
Процедура СлужебныеРеквизитыЗаполнитьНаСервере()

	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Номенклатура,
		Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются")));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НоменклатураХарактеристикаНоменклатуры.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Номенклатура.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.НейтральноСерый);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<характеристики не используются>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного",Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность",Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораИерахии(Результат, Параметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		ТекСтруктураИерархии = Результат.СтруктураИерархии;
		Элементы.ИзменитьИерархию.Заголовок = ТекСтруктураИерархии;
		ЗаполнитьВходилВСоставПоТекущейИерархии();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОТекущемПоложенииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	торо_СтруктурыОР.Ссылка,
	|	торо_СтруктурыОР.ИзменяетсяДокументами,
	|	торо_СтруктурыОР.СтроитсяАвтоматически,
	|	торо_СтруктурыОР.РеквизитОР,
	|	торо_СтруктурыОР.ТипРеквизитаОР
	|ИЗ
	|	Справочник.торо_СтруктурыОР КАК торо_СтруктурыОР";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СписокИерархий.Очистить();
	ТаблицаТекущихПоложений.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		СписокИерархий.Добавить(Выборка.Ссылка);
		
		НС = ТаблицаТекущихПоложений.Добавить();
		НС.СтруктураИерархии = Выборка.Ссылка;
		
		СписокРодителей = Новый ТаблицаЗначений;
		СписокРодителей.Колонки.Добавить("Номер");
		СписокРодителей.Колонки.Добавить("ТекстовоеОписание");
		
		Если Выборка.СтроитсяАвтоматически Тогда
			
			РеквизитСправочник = Метаданные.Справочники.Найти(Выборка.ТипРеквизитаОР);
			
			Если Не РеквизитСправочник = Неопределено Тогда
				
				ЭлементСправочника = Объект.ОбъектРемонта[Выборка.РеквизитОР];
				
				
				ЗаполнитьЗначенияСвойств(СписокРодителей.Добавить(), Новый Структура("Номер,ТекстовоеОписание",0,ЭлементСправочника));
				
				ЗаполнитьРодителей(ЭлементСправочника, СписокРодителей, 0);
				СписокРодителей.Сортировать("Номер Убыв");
			Иначе
				
				ЭлементСправочника = Объект.ОбъектРемонта[Выборка.РеквизитОР];
				НС.ТекстовоеОписаниеПоложения = ЭлементСправочника;
				Продолжить;
			КонецЕсли; 
			
		Иначе
			Запрос = Новый Запрос;
			Если Выборка.ИзменяетсяДокументами Тогда
				Запрос.Текст = "ВЫБРАТЬ
				|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.ОбъектИерархии КАК ОбъектРемонта,
				|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии КАК Родитель
				|ИЗ
				|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(, СтруктураИерархии = &СтруктураИерархии) КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних";
			Иначе
				
				Запрос.Текст = "ВЫБРАТЬ
				|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии КАК ОбъектРемонта,
				|	торо_ИерархическиеСтруктурыОР.РодительИерархии КАК Родитель
				|ИЗ
				|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
				|ГДЕ
				|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии";
				
			КонецЕсли; 
			
			Запрос.УстановитьПараметр("СтруктураИерархии", Выборка.Ссылка);
			
			ТаблицаИерархии = Запрос.Выполнить().Выгрузить();
			ЗаполнитьСписокРодителейПоИерархии(Объект.ОбъектРемонта,СписокРодителей, ТаблицаИерархии,0);
			
			СписокРодителей.Сортировать("Номер Убыв");
			
		КонецЕсли;
		
		
		ТекстовоеОписаниеПоложения = "";
		
		КолТабов = 0;
		
		Для каждого Строка Из СписокРодителей Цикл
			
			КолОтступов = КолТабов;
			СтрокаОтступа = "";
			
			Пока Не КолОтступов = 0 Цикл
				СтрокаОтступа = СтрокаОтступа + "ˡ-->";
				КолОтступов = КолОтступов -1;
			КонецЦикла;
			
			Если КолТабов = 0 Тогда
				
				ТекстовоеОписаниеПоложения = СтрокаОтступа + Строка(Строка.ТекстовоеОписание);
				
			Иначе
				
				ТекстовоеОписаниеПоложения = ТекстовоеОписаниеПоложения + Символы.ПС + СтрокаОтступа + Строка(Строка.ТекстовоеОписание);
				
			КонецЕсли;
			
			КолТабов = КолТабов + 1;
			
		КонецЦикла;
		
		НС.ТекстовоеОписаниеПоложения = ТекстовоеОписаниеПоложения;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьРодителей(ЭлементСправочника, СписокРодителей, Уровень)
	
	Если ЗначениеЗаполнено(ЭлементСправочника.Родитель) Тогда
		
		ЗаполнитьЗначенияСвойств(СписокРодителей.Добавить(), Новый Структура("Номер,ТекстовоеОписание",Уровень + 1,ЭлементСправочника.Родитель));
		ЗаполнитьРодителей(ЭлементСправочника.Родитель, СписокРодителей, Уровень + 1)
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВходилВСоставПоТекущейИерархии()
	МассивСтрок = ТаблицаТекущихПоложений.НайтиСтроки(Новый Структура("СтруктураИерархии", ТекСтруктураИерархии));
	
	Если МассивСтрок.Количество() > 0 Тогда
		ВходилВСостав = МассивСтрок[0].ТекстовоеОписаниеПоложения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРодителейПоИерархии(ОбъектРемонта,СписокРодителей, ТаблицаИерархии,Уровень)
	
	СтрокиСРодителем = ТаблицаИерархии.НайтиСтроки(Новый Структура("ОбъектРемонта",ОбъектРемонта));
	
	Если СтрокиСРодителем.Количество() > 0 Тогда
		Родитель = СтрокиСРодителем[0].Родитель;
		Если Не ЗначениеЗаполнено(Родитель) Тогда
			Возврат;
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(СписокРодителей.Добавить(), Новый Структура("Номер,ТекстовоеОписание",Уровень + 1,Родитель));
		ЗаполнитьСписокРодителейПоИерархии(Родитель,СписокРодителей, ТаблицаИерархии,Уровень + 1);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатуВводаВЭксплуатацию()
	
	Если ЗначениеЗаполнено(Объект.ОбъектРемонта) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	МАКСИМУМ(торо_СтатусыОбъектовРемонтаВУчетеСрезПоследних.Период) КАК ДатаВводаВЭксплуатацию
		|ИЗ
		|	РегистрСведений.торо_СтатусыОбъектовРемонтаВУчете.СрезПоследних КАК торо_СтатусыОбъектовРемонтаВУчетеСрезПоследних
		|ГДЕ
		|	торо_СтатусыОбъектовРемонтаВУчетеСрезПоследних.СтатусОР = ЗНАЧЕНИЕ(Перечисление.торо_СтатусыОРВУчете.ПринятоКУчету)
		|	И торо_СтатусыОбъектовРемонтаВУчетеСрезПоследних.ОбъектРемонта = &ОбъектРемонта";
		
		Запрос.УстановитьПараметр("ОбъектРемонта",Объект.ОбъектРемонта);
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ДатаВводаВЭксплуатацию = Выборка.ДатаВводаВЭксплуатацию;														
		КонецЕсли;
		
	КонецЕсли;														
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСтатусовНаСервере()
	
	СписокЗн = Новый СписокЗначений;
	
	СписокЗн.Добавить(Перечисления.торо_СтатусыОРВУчете.ПринятоКУчету);
	
	Возврат СписокЗн;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьСписокСтруктурНаСервере(ТекСтруктураИерархии, БезТекИерархии = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_СтруктурыОР.Ссылка,
	|	торо_СтруктурыОР.Наименование
	|ИЗ
	|	Справочник.торо_СтруктурыОР КАК торо_СтруктурыОР
	|ГДЕ
	|	торо_СтруктурыОР.ПометкаУдаления = ЛОЖЬ";
	
	Если БезТекИерархии Тогда
		
		Запрос.Текст = Запрос.Текст + " И торо_СтруктурыОР.Ссылка <> &СтруктураИерархии";
		Запрос.УстановитьПараметр("СтруктураИерархии", ТекСтруктураИерархии);
		
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СписокСтруктурОР = Новый СписокЗначений;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СписокСтруктурОР.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Наименование);
		
	КонецЦикла;
	
	Если БезТекИерархии Тогда
		
		СписокСтруктурОР[0].Пометка = Истина;
	Иначе
		
		Для каждого ЭлементСписка Из СписокСтруктурОР Цикл
			
			ЭлементСписка.Пометка = ЭлементСписка.Значение = ТекСтруктураИерархии;	
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокСтруктурОР;

КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораПользователя(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТЧНаСервере(ДопПараметры.Склад);
	КонецЕсли; 
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЧНаСервере(Склад)
	Для каждого Строка Из Объект.Номенклатура Цикл
		Строка.Склад = Склад;
	КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПользователяОСнятииСучетаПодчиненных(Результат, ПараметрыВыбора) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для каждого Элемент Из ПараметрыВыбора.СписокПодчиненных Цикл
			НС = Объект.СписокПодчиненныхСнятыхСУчета.Добавить();
			НС.ОбъектРемонта = Элемент.Значение;
			
		КонецЦикла;
		ЗаписатьНаСервере(ПараметрыВыбора.ПараметрыЗаписи);
	Иначе
		Объект.СписокПодчиненныхСнятыхСУчета.Очистить();
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Переместите подчиненные объекты ремонта в другое место.'"));
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере(ПараметрыЗаписи)
	Записать(ПараметрыЗаписи);
КонецПроцедуры
 
&НаСервере
Функция ПолучитьСписокПодчиненных(ОР)
	
	Иерархия = Константы.торо_ИерархияДляВводаНовыхОР.Получить();
	
	// Проверка на наличие подчиненных
	Запрос = Новый Запрос;
		
	Если ТекСтруктураИерархии.ИзменяетсяДокументами Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.ОбъектИерархии КАК ОбъектРемонта,
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии
		|ПОМЕСТИТЬ СписокОбъектовРемонта
		|ИЗ
		|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних
		|ГДЕ
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.СтруктураИерархии = &СтруктураИерархии";
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии КАК ОбъектРемонта,
		|	торо_ИерархическиеСтруктурыОР.РодительИерархии
		|ПОМЕСТИТЬ СписокОбъектовРемонта
		
		|ИЗ
		|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
		|ГДЕ
		|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии"; 
	КонецЕсли; 
	
	Запрос.Текст = Запрос.Текст + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокОбъектовРемонта.ОбъектРемонта,
	|	СписокОбъектовРемонта.ОбъектРемонта.ЭтоГруппа КАК ЭтоГруппа,
	|	СписокОбъектовРемонта.РодительИерархии,
	|	ЕСТЬNULL(торо_СтатусыОбъектовРемонтаВУчете.СтатусОР, ЗНАЧЕНИЕ(Перечисление.торо_СтатусыОРВУчете.НеПринятоКУчету)) КАК СтатусВУчете
	|ИЗ
	|	СписокОбъектовРемонта КАК СписокОбъектовРемонта
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			торо_СтатусыОбъектовРемонтаВУчете.ОбъектРемонта КАК ОбъектРемонта,
	|			МАКСИМУМ(торо_СтатусыОбъектовРемонтаВУчете.Период) КАК Период
	|		ИЗ
	|			РегистрСведений.торо_СтатусыОбъектовРемонтаВУчете КАК торо_СтатусыОбъектовРемонтаВУчете
	|		ГДЕ
	|			торо_СтатусыОбъектовРемонтаВУчете.ОбъектРемонта В
	|					(ВЫБРАТЬ
	|						СписокОбъектовРемонта.ОбъектРемонта КАК ОбъектРемонта
	|					ИЗ
	|						СписокОбъектовРемонта КАК СписокОбъектовРемонта)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			торо_СтатусыОбъектовРемонтаВУчете.ОбъектРемонта) КАК ВложенныйЗапрос
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_СтатусыОбъектовРемонтаВУчете КАК торо_СтатусыОбъектовРемонтаВУчете
	|			ПО ВложенныйЗапрос.ОбъектРемонта = торо_СтатусыОбъектовРемонтаВУчете.ОбъектРемонта
	|				И ВложенныйЗапрос.Период = торо_СтатусыОбъектовРемонтаВУчете.Период
	|		ПО СписокОбъектовРемонта.ОбъектРемонта = ВложенныйЗапрос.ОбъектРемонта";
	
	Запрос.УстановитьПараметр("СтруктураИерархии",             Иерархия);
	
	СписокЗначений = Новый СписокЗначений;
	Результат = Запрос.Выполнить();
	
	ТаблицаИерархии = Результат.Выгрузить();
	НеобходимыйСтатус = Перечисления.торо_СтатусыОРВУчете.ПринятоКУчету;
	
	ЗаполнитьСписокПодчиненныхНаСервере(СписокЗначений, ТаблицаИерархии, ОР, НеобходимыйСтатус);
		
	Возврат СписокЗначений;
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокПодчиненныхНаСервере(СписокЗначений, ТаблицаИерархии, ТекущийРодитель, НеобходимыйСтатус)

	МассивПодчиненных = ТаблицаИерархии.НайтиСтроки(Новый Структура("РодительИерархии", ТекущийРодитель));
	Для каждого Строка Из МассивПодчиненных Цикл
		Если Строка.СтатусВУчете = НеобходимыйСтатус
			И Не Строка.ЭтоГруппа Тогда
			СписокЗначений.Добавить(Строка.ОбъектРемонта);
		КонецЕсли; 
		ЗаполнитьСписокПодчиненныхНаСервере(СписокЗначений,ТаблицаИерархии, Строка.ОбъектРемонта,НеобходимыйСтатус);
	КонецЦикла;  
КонецПроцедуры 

&НаКлиенте
Процедура НоменклатураХарактеристикаНоменклатурыСоздание(Элемент, СтандартнаяОбработка)
	Если Элементы.Номенклатура.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Номенклатура.ТекущиеДанные.Номенклатура) Тогда	
		Вид = торо_ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Элементы.Номенклатура.ТекущиеДанные.Номенклатура, "ВидНоменклатуры");
		СтруктураПараметров = Новый Структура("ВидНоменклатуры, Владелец", Вид, Элементы.Номенклатура.ТекущиеДанные.Номенклатура);
		ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.Форма.ФормаЭлемента", СтруктураПараметров);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

