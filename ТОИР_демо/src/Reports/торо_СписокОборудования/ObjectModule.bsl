

#Область ОбработчикиСобытий
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Идентификатор = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИерархияТип")).ИдентификаторПользовательскойНастройки;
	СтрокаПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор);
	
	Если СтрокаПараметр.Значение.СтроитсяАвтоматически Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Объекты.Запрос = "ВЫБРАТЬ
			|	торо_ОбъектыРемонта.Ссылка КАК ОбъектРемонта,
			|	торо_ОбъектыРемонта." + СтрокаПараметр.Значение.РеквизитОР + "  КАК ОбъектИерархии,
            |	торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию,
            |	торо_ОбъектыРемонта.СрокПолезногоИспользования,
            |	ВЫБОР
            |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
            |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
            |			ТОГДА 0
            |		ИНАЧЕ РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ) / торо_ОбъектыРемонта.СрокПолезногоИспользования * 100
            |	КОНЕЦ КАК ПроцентИспользования,
            |	ВЫБОР
            |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
            |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
            |			ТОГДА 0
            |		ИНАЧЕ торо_ОбъектыРемонта.СрокПолезногоИспользования - РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ)
            |	КОНЕЦ КАК ОстаточныйСрокПолезногоИспользования
			|ПОМЕСТИТЬ ВТ_ОР
			|ИЗ
			|	Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
			|ГДЕ НЕ торо_ОбъектыРемонта.ЭтоГруппа;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ_ОР.ОбъектРемонта,
			|	ВТ_ОР.ОбъектИерархии,
			|	ВТ_ОР.ДатаВводаВЭксплуатацию,
			|	ВТ_ОР.СрокПолезногоИспользования,
			|	ВТ_ОР.ПроцентИспользования,
			|	ВТ_ОР.ОстаточныйСрокПолезногоИспользования,
			|	ВЫБОР
			|		КОГДА ВТ_ОР.ПроцентИспользования <= 20
			|			ТОГДА ""Износ менее 20%""
			|		КОГДА ВТ_ОР.ПроцентИспользования > 20
			|				И ВТ_ОР.ПроцентИспользования <= 40
			|			ТОГДА ""Износ от 20% до 40%""
			|		КОГДА ВТ_ОР.ПроцентИспользования > 40
			|				И ВТ_ОР.ПроцентИспользования <= 60
			|			ТОГДА ""Износ от 40% до 60%""
			|		КОГДА ВТ_ОР.ПроцентИспользования > 60
			|				И ВТ_ОР.ПроцентИспользования <= 80
			|			ТОГДА ""Износ от 60% до 80%""
			|		ИНАЧЕ ""Износ более 80%""
			|	КОНЕЦ КАК ИзносОбъектаРемонта
			|ИЗ
			|	ВТ_ОР КАК ВТ_ОР";

			
		Если Метаданные.Справочники[СтрокаПараметр.Значение.ТипРеквизитаОР].Иерархический Тогда
			
			СхемаКомпоновкиДанных.НаборыДанных.Иерархия.Запрос = "ВЫБРАТЬ
			|	СправочникСсылка.Ссылка КАК ОбъектИерархии,
			|	СправочникСсылка.Родитель КАК РодительИерархии
			|ИЗ
			|	Справочник." + СтрокаПараметр.Значение.ТипРеквизитаОР + " КАК СправочникСсылка
			|ГДЕ
			|	СправочникСсылка.Ссылка В (&Элемент)";
			
			СхемаКомпоновкиДанных.НаборыДанных.Контроль.Запрос = "ВЫБРАТЬ
			|	СправочникСсылка.Ссылка КАК ЭлементКонтроль,
			|	СправочникСсылка.Родитель КАК РодительКонтроль
			|ИЗ
			|	Справочник." + СтрокаПараметр.Значение.ТипРеквизитаОР + " КАК СправочникСсылка
			|ГДЕ
			|	СправочникСсылка.Родитель В(&Родитель)";
			
			
		Иначе
			
			
			СхемаКомпоновкиДанных.НаборыДанных.Иерархия.Запрос = "ВЫБРАТЬ
			|	СправочникСсылка.Ссылка КАК ОбъектИерархии,
			|	Значение(Справочник." + СтрокаПараметр.Значение.ТипРеквизитаОР + ".ПустаяСсылка) КАК РодительИерархии
			|ИЗ
			|	Справочник." + СтрокаПараметр.Значение.ТипРеквизитаОР + " КАК СправочникСсылка"; 
			
			СхемаКомпоновкиДанных.НаборыДанных.Контроль.Запрос = "ВЫБРАТЬ
			|	СправочникСсылка.Ссылка КАК ЭлементКонтроль,
			|	Значение(Справочник." + СтрокаПараметр.Значение.ТипРеквизитаОР + ".ПустаяСсылка) КАК РодительКонтроль
			|ИЗ
			|	Справочник." + СтрокаПараметр.Значение.ТипРеквизитаОР + " КАК СправочникСсылка"; 
			
			
						
		КонецЕсли;
		ПолеИерархия = СхемаКомпоновкиДанных.НаборыДанных.Объекты.Поля.Найти("ОбъектИерархии");
		ПолеИерархия.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка."+СтрокаПараметр.Значение.ТипРеквизитаОР);
	Иначе
		

		Если СтрокаПараметр.Значение.ИзменяетсяДокументами Тогда
			СхемаКомпоновкиДанных.НаборыДанных.Объекты.Запрос = "ВЫБРАТЬ
                |	Документами.ОбъектИерархии КАК ОбъектРемонта,
                |	Документами.РодительИерархии КАК ОбъектИерархии,
                |	торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию КАК ДатаВводаВЭксплуатацию,
                |	торо_ОбъектыРемонта.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
                |	ВЫБОР
                |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
                |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
                |			ТОГДА 0
                |		ИНАЧЕ РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ) / торо_ОбъектыРемонта.СрокПолезногоИспользования * 100
                |	КОНЕЦ КАК ПроцентИспользования,
                |	ВЫБОР
                |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
                |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
                |			ТОГДА 0
                |		ИНАЧЕ торо_ОбъектыРемонта.СрокПолезногоИспользования - РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ)
                |	КОНЕЦ КАК ОстаточныйСрокПолезногоИспользования
                |ПОМЕСТИТЬ ВТ_ОР
                |ИЗ
                |	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(&Дата, СтруктураИерархии = &ИерархияТип) КАК Документами
                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ОбъектыРемонтаГруппы КАК торо_ОбъектыРемонтаГруппы
                |		ПО Документами.ОбъектИерархии = торо_ОбъектыРемонтаГруппы.ОбъектИерархии
                |			И Документами.СтруктураИерархии = торо_ОбъектыРемонтаГруппы.СтруктураИерархии
                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
                |		ПО Документами.ОбъектИерархии = торо_ОбъектыРемонта.Ссылка
                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(&Дата, СтруктураИерархии = &ИерархияТип) КАК торо_РасположениеОРВСтруктуреИерархии
                |		ПО Документами.ОбъектИерархии = торо_РасположениеОРВСтруктуреИерархии.РодительИерархии
                |
                |СГРУППИРОВАТЬ ПО
                |	Документами.ОбъектИерархии,
                |	Документами.РодительИерархии,
                |	торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию,
                |	торо_ОбъектыРемонта.СрокПолезногоИспользования,
                |	ВЫБОР
                |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
                |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
                |			ТОГДА 0
                |		ИНАЧЕ РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ) / торо_ОбъектыРемонта.СрокПолезногоИспользования * 100
                |	КОНЕЦ,
                |	ВЫБОР
                |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
                |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
                |			ТОГДА 0
                |		ИНАЧЕ торо_ОбъектыРемонта.СрокПолезногоИспользования - РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ)
                |	КОНЕЦ
                |
                |ИМЕЮЩИЕ
                |	КОЛИЧЕСТВО(торо_РасположениеОРВСтруктуреИерархии.ОбъектИерархии) = 0
                |;
                |
                |////////////////////////////////////////////////////////////////////////////////
                |ВЫБРАТЬ
                |	ВТ_ОР.ОбъектРемонта,
                |	ВТ_ОР.ОбъектИерархии,
                |	ВТ_ОР.ДатаВводаВЭксплуатацию,
                |	ВТ_ОР.СрокПолезногоИспользования,
                |	ВТ_ОР.ПроцентИспользования,
                |	ВТ_ОР.ОстаточныйСрокПолезногоИспользования,
                |	ВЫБОР
                |		КОГДА ВТ_ОР.ПроцентИспользования <= 20
                |			ТОГДА ""Износ менее 20%""
                |		КОГДА ВТ_ОР.ПроцентИспользования > 20
                |				И ВТ_ОР.ПроцентИспользования <= 40
                |			ТОГДА ""Износ от 20% до 40%""
                |		КОГДА ВТ_ОР.ПроцентИспользования > 40
                |				И ВТ_ОР.ПроцентИспользования <= 60
                |			ТОГДА ""Износ от 40% до 60%""
                |		КОГДА ВТ_ОР.ПроцентИспользования > 60
                |				И ВТ_ОР.ПроцентИспользования <= 80
                |			ТОГДА ""Износ от 60% до 80%""
                |		ИНАЧЕ ""Износ более 80%""
                |	КОНЕЦ КАК ИзносОбъектаРемонта
                |ИЗ
                |	ВТ_ОР КАК ВТ_ОР";
			
			СхемаКомпоновкиДанных.НаборыДанных.Иерархия.Запрос = "ВЫБРАТЬ
				|	Документами.ОбъектИерархии КАК ОбъектИерархии,
				|	Документами.РодительИерархии КАК РодительИерархии
				|ИЗ
				|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии КАК Документами
				|ГДЕ
				|	Документами.СтруктураИерархии = &ИерархияТип
				|	И Документами.ОбъектИерархии В(&Элемент)";
			
			СхемаКомпоновкиДанных.НаборыДанных.Контроль.Запрос = "ВЫБРАТЬ
				|	Документами.ОбъектИерархии КАК ЭлементКонтроль,
				|	Документами.РодительИерархии КАК РодительКонтроль
				|ИЗ
				|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии КАК Документами
				|ГДЕ
				|	Документами.СтруктураИерархии = &ИерархияТип
				|	И Документами.РодительИерархии В(&Родитель)";
			
		Иначе
			СхемаКомпоновкиДанных.НаборыДанных.Объекты.Запрос = "ВЫБРАТЬ
                |	БезДокументов.ОбъектИерархии КАК ОбъектРемонта,
                |	БезДокументов.РодительИерархии КАК ОбъектИерархии,
                |	торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию,
                |	торо_ОбъектыРемонта.СрокПолезногоИспользования,
                |	ВЫБОР
                |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
                |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
                |			ТОГДА 0
                |		ИНАЧЕ РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ) / торо_ОбъектыРемонта.СрокПолезногоИспользования * 100
                |	КОНЕЦ КАК ПроцентИспользования,
                |	ВЫБОР
                |		КОГДА торо_ОбъектыРемонта.СрокПолезногоИспользования ЕСТЬ NULL 
                |				ИЛИ торо_ОбъектыРемонта.СрокПолезногоИспользования = 0
                |			ТОГДА 0
                |		ИНАЧЕ торо_ОбъектыРемонта.СрокПолезногоИспользования - РАЗНОСТЬДАТ(торо_ОбъектыРемонта.ДатаВводаВЭксплуатацию, &Дата, МЕСЯЦ)
                |	КОНЕЦ КАК ОстаточныйСрокПолезногоИспользования
				|ПОМЕСТИТЬ ВТ_ОР
                |ИЗ
                |	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК БезДокументов
                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
                |		ПО БезДокументов.ОбъектИерархии = торо_ОбъектыРемонта.Ссылка
                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ОбъектыРемонтаГруппы КАК торо_ОбъектыРемонтаГруппы
                |		ПО БезДокументов.ОбъектИерархии = торо_ОбъектыРемонтаГруппы.ОбъектИерархии
                |			И БезДокументов.СтруктураИерархии = торо_ОбъектыРемонтаГруппы.СтруктураИерархии
                |ГДЕ
                |	БезДокументов.СтруктураИерархии = &ИерархияТип
                |	И НЕ ЕСТЬNULL(торо_ОбъектыРемонтаГруппы.ОбъектГруппа,ЛОЖЬ);
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_ОР.ОбъектРемонта,
				|	ВТ_ОР.ОбъектИерархии,
				|	ВТ_ОР.ДатаВводаВЭксплуатацию,
				|	ВТ_ОР.СрокПолезногоИспользования,
				|	ВТ_ОР.ПроцентИспользования,
				|	ВТ_ОР.ОстаточныйСрокПолезногоИспользования,
				|	ВЫБОР
				|		КОГДА ВТ_ОР.ПроцентИспользования <= 20
				|			ТОГДА ""Износ менее 20%""
				|		КОГДА ВТ_ОР.ПроцентИспользования > 20
				|				И ВТ_ОР.ПроцентИспользования <= 40
				|			ТОГДА ""Износ от 20% до 40%""
				|		КОГДА ВТ_ОР.ПроцентИспользования > 40
				|				И ВТ_ОР.ПроцентИспользования <= 60
				|			ТОГДА ""Износ от 40% до 60%""
				|		КОГДА ВТ_ОР.ПроцентИспользования > 60
				|				И ВТ_ОР.ПроцентИспользования <= 80
				|			ТОГДА ""Износ от 60% до 80%""
				|		ИНАЧЕ ""Износ более 80%""
				|	КОНЕЦ КАК ИзносОбъектаРемонта
				|ИЗ
				|	ВТ_ОР КАК ВТ_ОР";
			
			СхемаКомпоновкиДанных.НаборыДанных.Иерархия.Запрос = "ВЫБРАТЬ
				|	БезДокументов.ОбъектИерархии КАК ОбъектИерархии,
				|	БезДокументов.РодительИерархии КАК РодительИерархии
				|ИЗ
				|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК БезДокументов
				|ГДЕ
				|	БезДокументов.СтруктураИерархии = &ИерархияТип
				|	И БезДокументов.ОбъектИерархии В(&Элемент)";
				
			СхемаКомпоновкиДанных.НаборыДанных.Контроль.Запрос = "ВЫБРАТЬ
				|	БезДокументов.ОбъектИерархии КАК ЭлементКонтроль,
				|	БезДокументов.РодительИерархии КАК РодительКонтроль
				|ИЗ
				|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК БезДокументов
				|ГДЕ
				|	БезДокументов.СтруктураИерархии = &ИерархияТип
				|	И БезДокументов.РодительИерархии В(&Родитель)";
				
		КонецЕсли;
		ПолеИерархия = СхемаКомпоновкиДанных.НаборыДанных.Объекты.Поля.Найти("ОбъектИерархии");
		ПолеИерархия.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта");
		
		
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.ВыводитьСуммуВыделенныхЯчеек = Ложь;
	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
КонецПроцедуры

Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
	ПараметрыФормы = Форма.Параметры;
	
	ЭлементыНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	
	Параметр = Неопределено;
	
	Для каждого Элемент Из ЭлементыНастроек Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(Элемент.Параметр) = "ИерархияТип" Тогда
				Параметр = Элемент;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Параметр <> Неопределено
		И ПараметрыФормы.Свойство("ИерархияТип") 
		И ЗначениеЗаполнено(ПараметрыФормы.ИерархияТип) Тогда
		
		Параметр.Значение = ПараметрыФормы.ИерархияТип;
		Параметр.Использование = Истина;
			
	КонецЕсли;
	
	Если Не Параметр = Неопределено
		И Не ЗначениеЗаполнено(Параметр.Значение) Тогда
		
		ТекСтруктураИерархии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиТОиР",
		"ОсновнаяСтруктураИерархии",
		Справочники.торо_СтруктурыОР.ПустаяСсылка());
		Если не ТекСтруктураИерархии = Неопределено Тогда
			Параметр.Значение = ТекСтруктураИерархии;
			параметр.Использование = Истина;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли