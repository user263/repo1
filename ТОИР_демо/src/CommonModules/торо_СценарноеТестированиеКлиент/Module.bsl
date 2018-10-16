
#Область СлужебныеПроцедурыИФункции

Функция СтрокаЗапускаПриложения(НомерПорта) Экспорт
	
	ПутьЗапуска1с = """C:\Program Files (x86)\1cv8\common\1cestart.exe"" enterprise";
	
	Соединение = СтрокаСоединенияИнформационнойБазы(); 
	Параметры = торо_СценарноеТестированиеКлиентСервер.ПолучитьПараметрыПодключения(Соединение);
	
	Если Параметры.Свойство("ИмяСервера") Тогда
		СтрокаПараметровБазы = " /S """ + торо_СценарноеТестированиеКлиентСервер.УдалитьКавычки(Параметры.ИмяСервера) + ":"
		    + Формат(Параметры.ПортКластера, "ЧГ=0") + "\"
		    + торо_СценарноеТестированиеКлиентСервер.УдалитьКавычки(Параметры.Ref)+"""";
			 
	//ИначеЕсли Параметры.Свойство("ws") Тогда
	//	Имя = ТЦОбщий.УдалитьКавычки(Параметры.ws);
	Иначе
		СтрокаПараметровБазы = " /F """ + торо_СценарноеТестированиеКлиентСервер.УдалитьКавычки(Параметры.file)+"""";
	КонецЕсли;

	СтрокаЗапуска = ПутьЗапуска1с 
						+ СтрокаПараметровБазы 
						+ " /N """ + ИмяПользователя()+""""
						+ " /TestClient -TPort " + Формат(НомерПорта, "ЧГ=0");
						
	Возврат СтрокаЗапуска;
	
КонецФункции


Функция ПолучитьГлавноеОкноПриложения(ТестовоеПриложение) Экспорт
	
	ГлавноеОкноТестКлиента = Неопределено;
	ОкнаПриложения = ТестовоеПриложение.НайтиОбъекты(Тип("ТестируемоеОкноКлиентскогоПриложения"),"*");
	Для каждого ОкноПриложения из ОкнаПриложения Цикл
		Если ОкноПриложения.Основное Тогда
			ГлавноеОкноТестКлиента = ОкноПриложения;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат ГлавноеОкноТестКлиента;
	
КонецФункции

Процедура ЗакрытьПриложение(ТестовоеПриложение) Экспорт
	
	Попытка
		ГлавноеОкноТестКлиента = торо_СценарноеТестированиеКлиент.ПолучитьГлавноеОкноПриложения(ТестовоеПриложение);
		ГлавноеОкноТестКлиента.Закрыть();
		
		ОкноПредупреждения = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"Завершение работы*",,10);
		Если ОкноПредупреждения <> Неопределено Тогда
			ФормаПредупреждения = ОкноПредупреждения.НайтиОбъект(Тип("ТестируемаяФорма"),"Завершение работы*");
			КнопкаЗавершить = ФормаПредупреждения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Завершить");
			Если КнопкаЗавершить <> Неопределено Тогда
				КнопкаЗавершить.Нажать();
			КонецЕсли;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	ТестовоеПриложение.РазорватьСоединение();
	
КонецПроцедуры

Процедура ЗакрытьПредупреждениеОНесколькихСеансахПользователя(ТестовоеПриложение) Экспорт
	
	ОкноПредупреждения = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"1С:Предприятие",,5);
	Если ОкноПредупреждения <> Неопределено Тогда
		ФормаПредупреждения = ОкноПредупреждения.НайтиОбъект(Тип("ТестируемаяФорма"),"1С:Предприятие");
		КнопкаОК = ФормаПредупреждения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "OK");
		Если КнопкаОК <> Неопределено Тогда
			КнопкаОК.Нажать();
		КонецЕсли;
	Иначе
		ОкноПредупреждения = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"1C:Enterprise",,5);	
		Если ОкноПредупреждения <> Неопределено Тогда
			ФормаПредупреждения = ОкноПредупреждения.НайтиОбъект(Тип("ТестируемаяФорма"),"1C:Enterprise");
			КнопкаОК = ФормаПредупреждения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "OK");
			Если КнопкаОК <> Неопределено Тогда
				КнопкаОК.Нажать();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗакрытьВсеОкнаДокументов(ТестовоеПриложение) Экспорт
	
	ОкнаПриложения = ТестовоеПриложение.НайтиОбъекты(Тип("ТестируемоеОкноКлиентскогоПриложения"),"*");
	Для каждого ОкноПриложения из ОкнаПриложения Цикл
		Если НЕ ОкноПриложения.Основное Тогда
			Попытка
				ОкноПриложения.Закрыть();
			Исключение
				ЗакрытьВопросОФактическомПростое(ТестовоеПриложение);
			КонецПопытки;
		КонецЕсли;
		ЗакрытьВопросОФактическомПростое(ТестовоеПриложение);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗакрытьВопросОФактическомПростое(ТестовоеПриложение)
	
	ОкноПредупреждения = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"1С:Предприятие",,2);
	Если ОкноПредупреждения <> Неопределено Тогда
		ФормаПредупреждения = ОкноПредупреждения.НайтиОбъект(Тип("ТестируемаяФорма"),"1С:Предприятие");
		КнопкаНет = ФормаПредупреждения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Нет");
		КнопкаНет.Нажать();
		
	Иначе
		ОкноПредупреждения = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"1C:Enterprise",,2);
		Если ОкноПредупреждения <> Неопределено Тогда
			ФормаПредупреждения = ОкноПредупреждения.НайтиОбъект(Тип("ТестируемаяФорма"),"1C:Enterprise");
			КнопкаНет = ФормаПредупреждения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "No");
			КнопкаНет.Нажать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


Процедура ЗаполнитьОрганизацию(ТестовоеПриложение, ПолеОрганизация, НаименованиеОрганизации) Экспорт
	
	ПолеОрганизация.Активизировать();
	ПолеОрганизация.Выбрать();
	
	ОкноПриложенияОрганизации = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Организации", , 30);
	ОкноПриложенияОрганизацииФормаОрганизации = ОкноПриложенияОрганизации.НайтиОбъект(Тип("ТестируемаяФорма"), "Организации");
	ОкноПриложенияОрганизацииФормаОрганизацииТаблицаСписок = ОкноПриложенияОрганизацииФормаОрганизации.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Список");
	ОписаниеСтроки = Новый Соответствие();
	ОписаниеСтроки.Вставить("Наименование", НаименованиеОрганизации);
	торо_СценарноеТестированиеКлиент.ПерейтиКСтроке(ОкноПриложенияОрганизацииФормаОрганизацииТаблицаСписок, ОписаниеСтроки);
	
	ОкноПриложенияОрганизацииФормаОрганизацииКнопкаВыбрать = ОкноПриложенияОрганизацииФормаОрганизации.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Выбрать");
	Если ОкноПриложенияОрганизацииФормаОрганизацииКнопкаВыбрать = Неопределено Тогда
		ОкноПриложенияОрганизацииФормаОрганизацииКнопкаВыбрать = ОкноПриложенияОрганизацииФормаОрганизации.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Select");
	КонецЕсли;
	ОкноПриложенияОрганизацииФормаОрганизацииКнопкаВыбрать.Нажать();

КонецПроцедуры

Процедура ЗаполнитьПодразделение(ТестовоеПриложение, ПолеПодразделение, НаименованиеПодразделения) Экспорт
	
	ПолеПодразделение.Активизировать();
	ПолеПодразделение.Выбрать();
	
	ОкноПриложенияСтруктураПредприятия = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Структура предприятия", , 30);
	ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятия = ОкноПриложенияСтруктураПредприятия.НайтиОбъект(Тип("ТестируемаяФорма"), "Структура предприятия");
	ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятияТаблицаСписок = ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятия.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Список");
	ОписаниеСтроки = Новый Соответствие();
	ОписаниеСтроки.Вставить("Наименование", НаименованиеПодразделения);
	торо_СценарноеТестированиеКлиент.ПерейтиКСтроке(ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятияТаблицаСписок, ОписаниеСтроки);

	ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятияКнопкаВыбрать = ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятия.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Выбрать");
	Если ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятияКнопкаВыбрать = Неопределено Тогда
		ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятияКнопкаВыбрать = ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятия.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Select");
	КонецЕсли;
	ОкноПриложенияСтруктураПредприятияФормаСтруктураПредприятияКнопкаВыбрать.Нажать();
	
КонецПроцедуры

Процедура ВыбратьОбъектРемонта(ТестовоеПриложение, ПолеОбъектРемонта, НаименованиеОР, НаименованиеОрганизации, НаименованиеПодразделения) Экспорт
		
	// вариант с текстом ++
	СсылкаНаОР = торо_СценарноеТестированиеСервер.НайтиЭлементСправочникаПоНаименованию("торо_ОбъектыРемонта", НаименованиеОР);
	КодОР = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОР, "Код");
	
	ПолеОбъектРемонта.Активизировать();
	ПолеОбъектРемонта.ВвестиТекст(НаименованиеОР);
		
	Попытка
		ПолеОбъектРемонта.ОжидатьФормированияВыпадающегоСписка();
	Исключение
	КонецПопытки;
	
	//ПолеОбъектРемонта.ВыполнитьВыборИзВыпадающегоСписка(НаименованиеОР);
	ПолеОбъектРемонта.ВыполнитьВыборИзСпискаВыбора(НаименованиеОР+" ("+КодОР+")");
	// вариант с текстом --
	
	//// вариант с формой ++
	//ПолеОбъектРемонта.Выбрать();
	//
	//ОкноПриложенияОбъектыРемонта = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Объекты ремонта", , 30);
	//ОкноПриложенияОбъектыРемонтаФормаОбъектыРемонта = ОкноПриложенияОбъектыРемонта.НайтиОбъект(Тип("ТестируемаяФорма"), "Объекты ремонта");
	//ТаблицаДерево = ОкноПриложенияОбъектыРемонтаФормаОбъектыРемонта.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Дерево");
	//
	//ТаблицаСписокОбъектов = ОкноПриложенияОбъектыРемонтаФормаОбъектыРемонта.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "СписокОбъектов");
	//ТаблицаСписокОбъектов.Активизировать();
	//
	//ОписаниеСтроки = Новый Соответствие();
	//ОписаниеСтроки.Вставить("Наименование", НаименованиеОрганизации);
	//торо_СценарноеТестированиеКлиент.ПерейтиКСтроке(ТаблицаСписокОбъектов, ОписаниеСтроки, НаправлениеПереходаКСтроке.Вниз);
	//ТаблицаСписокОбъектов.Выбрать();
	//
	//ОписаниеСтроки = Новый Соответствие();
	//ОписаниеСтроки.Вставить("Наименование", НаименованиеПодразделения);
	//торо_СценарноеТестированиеКлиент.ПерейтиКСтроке(ТаблицаСписокОбъектов, ОписаниеСтроки, НаправлениеПереходаКСтроке.Вниз);
	//ТаблицаСписокОбъектов.Выбрать();
	//
	//ОписаниеСтроки = Новый Соответствие();
	//ОписаниеСтроки.Вставить("Наименование", НаименованиеОР);
	//торо_СценарноеТестированиеКлиент.ПерейтиКСтроке(ТаблицаСписокОбъектов, ОписаниеСтроки, НаправлениеПереходаКСтроке.Вниз);
	//
	//КнопкаВыбрать = ОкноПриложенияОбъектыРемонтаФормаОбъектыРемонта.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Выбрать");
	//Если КнопкаВыбрать = Неопределено Тогда
	//	КнопкаВыбрать = ОкноПриложенияОбъектыРемонтаФормаОбъектыРемонта.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Select");
	//КонецЕсли;
	//КнопкаВыбрать.Нажать();
	//// вариант с формой --
	
КонецПроцедуры

Процедура ВыбратьТехКарту(ТестовоеПриложение, ОкноПриложенияТехнологическиеКартыРемонтовФорма, НаименованиеКартыРемонта) Экспорт
	
	ТаблицаСписок = ОкноПриложенияТехнологическиеКартыРемонтовФорма.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), "Список");
	
	КнопкаПоиск = ОкноПриложенияТехнологическиеКартыРемонтовФорма.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Расширенный поиск");
	Если КнопкаПоиск = Неопределено Тогда
		КнопкаПоиск = ОкноПриложенияТехнологическиеКартыРемонтовФорма.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Advanced search");
	КонецЕсли;
	КнопкаПоиск.Нажать();
	
	ОкноПриложенияНайти = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Найти", , 5);
	Если ОкноПриложенияНайти <> Неопределено Тогда
		ОкноПриложенияНайтиФормаНайти = ОкноПриложенияНайти.НайтиОбъект(Тип("ТестируемаяФорма"), "Найти");
		ОкноПриложенияНайтиФормаНайтиПолеЧтоИскать = ОкноПриложенияНайтиФормаНайти.НайтиОбъект(Тип("ТестируемоеПолеФормы"), "&Что искать");
		ОкноПриложенияНайтиФормаНайтиПолеЧтоИскать.ВвестиТекст(НаименованиеКартыРемонта);
		
		ОкноПриложенияНайтиФормаНайтиКнопкаНайти = ОкноПриложенияНайтиФормаНайти.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "&Найти");
		ОкноПриложенияНайтиФормаНайтиКнопкаНайти.Нажать();
	Иначе
		ОкноПриложенияНайти = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), "Find", , 5);
		ОкноПриложенияНайтиФормаНайти = ОкноПриложенияНайти.НайтиОбъект(Тип("ТестируемаяФорма"), "Find");
		ОкноПриложенияНайтиФормаНайтиПолеЧтоИскать = ОкноПриложенияНайтиФормаНайти.НайтиОбъект(Тип("ТестируемоеПолеФормы"), "&Find");
		ОкноПриложенияНайтиФормаНайтиПолеЧтоИскать.ВвестиТекст(НаименованиеКартыРемонта);
		
		ОкноПриложенияНайтиФормаНайтиКнопкаНайти = ОкноПриложенияНайтиФормаНайти.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "F&ind");
		ОкноПриложенияНайтиФормаНайтиКнопкаНайти.Нажать();
	КонецЕсли;
	
	ОписаниеСтроки = Новый Соответствие();
	ОписаниеСтроки.Вставить("Наименование", НаименованиеКартыРемонта);
	торо_СценарноеТестированиеКлиент.ПерейтиКСтроке(ТаблицаСписок, ОписаниеСтроки);
	
	КнопкаВыбрать = ОкноПриложенияТехнологическиеКартыРемонтовФорма.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Выбрать");
	Если КнопкаВыбрать = Неопределено Тогда
		КнопкаВыбрать = ОкноПриложенияТехнологическиеКартыРемонтовФорма.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), "Select");
	КонецЕсли;
	КнопкаВыбрать.Нажать();
	
КонецПроцедуры


Процедура ОчиститьТаблицуТрудозатратВАктеОВыполненииЭтапаРабот(ТестовоеПриложение, ФормаДокумента, НачальныйНомерОРПользователя, КоличествоВыбранныхОР) Экспорт
	
	СтраницаИсполнители = ФормаДокумента.НайтиОбъект(Тип("ТестируемаяГруппаФормы"),,"СтраницаИсполнителей");
	СтраницаИсполнители.Активизировать();
	
	// очистка ++
	//ТаблицаРемонтыОборудования = ФормаДокумента.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"),,"РемонтыОборудования");
	//ТаблицаТрудозатраты = ФормаДокумента.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"),,"ТрудовыеЗатраты");
	//
	//Для НомерОР = НачальныйНомерОРПользователя по НачальныйНомерОРПользователя + КоличествоВыбранныхОР-1 Цикл
	//	
	//	НаименованиеОР = торо_СценарноеТестированиеКлиентСервер.ПолучитьНаименованиеЭлементаОР(НомерОР);
	//	ОписаниеСтроки = Новый Соответствие;
	//	ОписаниеСтроки.Вставить("Объект ремонта", НаименованиеОР);
	//	
	//	ТаблицаРемонтыОборудования.Активизировать();
	//	ТаблицаРемонтыОборудования.ПерейтиКСтроке(ОписаниеСтроки);
	//	
	//	ТаблицаТрудозатраты.Активизировать();
	//	
	//	ВсеОчищено = Ложь;
	//	ОписаниеСтроки = Новый Соответствие;
	//	ОписаниеСтроки.Вставить("Сотрудник", "");
	//	
	//	Пока НЕ ВсеОчищено Цикл
	//		
	//		Попытка
	//			ТаблицаТрудозатраты.ПерейтиКПервойСтроке();
	//			ТаблицаТрудозатраты.ПерейтиКСтроке(ОписаниеСтроки, НаправлениеПереходаКСтроке.Вниз);
	//			ТаблицаТрудозатраты.УдалитьСтроку();
	//		Исключение
	//			ВсеОчищено = Истина;
	//		КонецПопытки;
	//		
	//	КонецЦикла;
	//КонецЦикла;
	// очистка --
	
	// заполнение ++
	КомандаЗаполнитьИсполнителей = ФормаДокумента.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"),,"ТрудовыеЗатратыЗаполнитьИсполнителей");
	КомандаЗаполнитьИсполнителей.Нажать();
	
	ОкноЗаполнения = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"Заполнить исполнителей");
	ФормаЗаполнения = ОкноЗаполнения.НайтиОбъект(Тип("ТестируемаяФорма"),"Заполнить исполнителей");
	
	ПолеСотрудник = ФормаЗаполнения.НайтиОбъект(Тип("ТестируемоеПолеФормы"), "Сотрудник");
	//ПолеСотрудник.Активизировать();
	ПолеСотрудник.Выбрать();
	
	ОкноСотрудников = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"),"Сотрудники");
	ФормаСотрудников = ОкноСотрудников.НайтиОбъект(Тип("ТестируемаяФорма"),"Сотрудники");
	
	СписокСотрудников = ФормаСотрудников.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"),,"Список");
	СписокСотрудников.Активизировать();
	СписокСотрудников.Выбрать();
	
	КнопкаВыделитьВсе = ФормаЗаполнения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"),,"ДеревоИсполнителейВыделитьВсе");
	КнопкаВыделитьВсе.Нажать();
	
	КнопкаЗаполнить = ФормаЗаполнения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"),,"ДеревоИсполнителейЗаполнить");
	КнопкаЗаполнить.Нажать(); 
	
	КнопкаПеренестиВДокумент = ФормаЗаполнения.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"),"Перенести в документ");
	КнопкаПеренестиВДокумент.Нажать(); 
	// заполнение --
	
КонецПроцедуры


Процедура ПерейтиКСтроке(Список, ОписаниеСтроки, НаправлениеПерехода = Неопределено) Экспорт
	
	СоответствиеРеквизитов = Новый Соответствие;
	СоответствиеРеквизитов.Вставить("Наименование", "Description");
	
	Попытка
		Список.ПерейтиКСтроке(ОписаниеСтроки);
	Исключение
		ОписаниеСтрокиАнгл = Новый Соответствие();
		Для каждого КлючИЗначение из ОписаниеСтроки Цикл
			АнглНазвание = СоответствиеРеквизитов[КлючИЗначение.Ключ];
			Если НЕ ЗначениеЗаполнено(АнглНазвание) Тогда
				АнглНазвание = КлючИЗначение.Ключ;
			КонецЕсли;
			ОписаниеСтрокиАнгл.Вставить(АнглНазвание, КлючИЗначение.Значение);
		КонецЦикла;
		Список.ПерейтиКСтроке(ОписаниеСтрокиАнгл);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
