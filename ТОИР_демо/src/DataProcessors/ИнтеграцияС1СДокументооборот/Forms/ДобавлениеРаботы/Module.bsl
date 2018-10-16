
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОтображатьИсточник", ОтображатьИсточник);
	
	Если Параметры.Свойство("ИсточникID") Тогда
		Источник = Параметры.Источник;
		ИсточникID = Параметры.ИсточникID;
		ИсточникТип = Параметры.ИсточникТип;
	КонецЕсли;
	
	Элементы.Источник.Видимость = ОтображатьИсточник;
	
	ЗначениеПеречисленияДлительность = "Длительность";
	ЗначениеПеречисленияВремяНачала  = "ВремяНачала";
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();

	Если ЗначениеЗаполнено(ИсточникID) Тогда
		
		// Получим данные хронометража
		Если Найти(ИсточникТип, "Document") Или Найти(ИсточникТип, "Task") Тогда
			
			Пакет = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMBatchRequest");
			
			Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetNewObjectRequest");
			Запрос.type = "DMActualWork";
			
			Пакет.requests.Добавить(Запрос);
			
			Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetChronometrationSettingsRequest");
			ОбъектID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ИсточникID, ИсточникТип);
			Запрос.objects.Добавить(ОбъектID);
			
			Пакет.requests.Добавить(Запрос);
			
			Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRetrieveRequest");
			ОбъектID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ИсточникID, ИсточникТип); 
			Запрос.objectIds.Добавить(ОбъектID);
			Запрос.columnSet.Добавить("project");
			Если Найти(ИсточникТип, "Task") Тогда
				Запрос.columnSet.Добавить("projectTask");
			КонецЕсли;
			
			Пакет.requests.Добавить(Запрос);
			
			Результаты = Прокси.execute(Пакет);
			
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результаты);
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результаты.responses[0]);
			
			ЗаполнитьФормуОбъекта(Результаты.responses[0]);
			
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результаты.responses[1]);
			
			ПараметрыХронометража = Результаты.responses[1].settings[0];
			
			Если ПараметрыХронометража.Установлено("beginDate") И ЗначениеЗаполнено(ПараметрыХронометража.beginDate) Тогда
				Начало = ПараметрыХронометража.beginDate;
			КонецЕсли;
			Если ПараметрыХронометража.Установлено("timeInputMethod") Тогда
				Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ПараметрыХронометража.timeInputMethod,"СпособУказанияВремени", Ложь);
			КонецЕсли;
			Если ПараметрыХронометража.Установлено("workType") Тогда
				Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ПараметрыХронометража.workType, "ВидРабот", Ложь);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Начало) И ЗначениеЗаполнено(Окончание) Тогда
				Длительность = Окончание - Начало;
				ДлительностьСтр = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(Длительность);
			КонецЕсли;
			
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результаты.responses[2]);
			ОбъектОснование = Результаты.responses[2].objects[0];
			Если ОбъектОснование.Установлено("project") Тогда
				Проект = ОбъектОснование.project.name;
				ПроектID = ОбъектОснование.project.objectId.id;
				Если ОбъектОснование.Свойства().Получить("projectTask") <> Неопределено
					и ОбъектОснование.Установлено("projectTask") Тогда
					ПроектнаяЗадача = ОбъектОснование.projectTask.name;
					ПроектнаяЗадачаID = ОбъектОснование.projectTask.objectId.id;
					ПроектнаяЗадачаТип = ОбъектОснование.projectTask.objectId.type;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetNewObjectRequest");
		Запрос.type = "DMActualWork";
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		ОбъектXDTO = Результат;
		
		ЗаполнитьФормуОбъекта(ОбъектXDTO);
	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОписаниеРаботы) Тогда
		
		Если ЗначениеЗаполнено(ВнешнийОбъект) Тогда
			
			ОбъектМетаданных = Параметры.ВнешнийОбъект.Метаданные();
			
			Если Метаданные.Справочники.Содержит(ОбъектМетаданных) 
			 Или Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных) Тогда
				СтрокаПодстановки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1 (%2)", Строка(Параметры.ВнешнийОбъект), Строка(ОбъектМетаданных.ПредставлениеОбъекта));
			Иначе
				СтрокаПодстановки = Строка(Параметры.ВнешнийОбъект);
			КонецЕсли; 
			
			ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Работа над ""%1""'"), СтрокаПодстановки);
		Иначе
			ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Работа над ""%1""'"), Источник);
		КонецЕсли;
			
	КонецЕсли;
		
	ДлительностьРаботы = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(Длительность);
	ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Проект, ПроектнаяЗадача);
	
	Если Не ЗначениеЗаполнено(СпособУказанияВремениID) Тогда
		СпособУказанияВремениID = ЗначениеПеречисленияДлительность;
	КонецЕсли;
	
	Если СпособУказанияВремени = ЗначениеПеречисленияДлительность Тогда 
		Элементы.ДлительностьРаботы.Видимость = Истина;
		Элементы.Начало.Видимость = Ложь;
		Элементы.Окончание.Видимость = Ложь;
	Иначе
		Элементы.ДлительностьРаботы.Видимость = Ложь;
		Элементы.Начало.Видимость = Истина;
		Элементы.Окончание.Видимость = Истина;
	КонецЕсли;
	
	// хронометраж и проекты
	Если Не ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP") Тогда
		Элементы.ПроектЗадача.Видимость = Ложь;
		Элементы.Окончание.Видимость = Ложь;
		Элементы.ДатаДобавления.ТолькоПросмотр = Истина;
		Элементы.ДатаДобавления.Заголовок = НСтр("ru='Добавить в отчет за'");
		Элементы.Начало.Заголовок = НСтр("ru='Время начала работы'");
	Иначе
		ДоступенФункционалХронометраж = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Документооборот_ВыбратьЗначениеИзСпискаЗавершение" И Источник = ЭтаФорма Тогда
		Если Параметр = "Проект" Тогда
			ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Проект, ПроектнаяЗадача);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Пользователь", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Пользователь", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Пользователь", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРаботНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка(
		"DMWorkType", "ВидРабот", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРаботАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMWorkType", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРаботОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMWorkType", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ВидРабот", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Ложь, Элемент);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРаботОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ВидРабот", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма, Ложь, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMProject", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Проект", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Ложь, Элемент);
				
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMProject", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Проект", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Ложь, Элемент);
				
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMProject", "Проект", ЭтаФорма);
		
	ПроектнаяЗадача = "";
	ПроектнаяЗадачаID = "";
	ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Проект, ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Проект", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма, Ложь, Элемент);
		
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение.type = "DMProject" Тогда
		ПроектнаяЗадача = "";
		ПроектнаяЗадачаID = "";
	КонецЕсли;
	
	ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Проект, ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПроектЗадача) Тогда 
		Проект = "";
		ПроектID = "";
		ПроектнаяЗадача = "";
		ПроектнаяЗадачаID = "";
	КонецЕсли;	
	
	ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Проект, ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОчистка(Элемент, СтандартнаяОбработка)
	
	Проект = "";
	ПроектID = "";
	ПроектнаяЗадача = "";
	ПроектнаяЗадачаID = "";
	
	ПроектЗадача = ИнтеграцияС1СДокументооборотКлиентСервер.ПредставлениеПроектаЗадачи(Проект, ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьРаботыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокВыбора = СписокВыбораВремени();
	
	Оповещение = Новый ОписаниеОповещения("ДлительностьРаботыНачалоВыбораЗавершение", ЭтаФорма);
	ПоказатьВыборИзСписка(Оповещение, СписокВыбора, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Источник) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ИсточникТип, ИсточникID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(СпособУказанияВремениID) Тогда
		СпособУказанияВремениID =ЗначениеПеречисленияДлительность;
	КонецЕсли;
	
	Если СпособУказанияВремениID = ЗначениеПеречисленияДлительность Тогда 
		Если Не ЗначениеЗаполнено(ДлительностьРаботы) Или ДлительностьРаботы = "00:00" Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Длительность'")),,
				"ДлительностьРаботы",, 
				Отказ);
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Начало) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Начало'")),,
				"Начало",, 
				Отказ);
		КонецЕсли;
		
		Если ДоступенФункционалХронометраж Тогда
			Если Не ЗначениеЗаполнено(Окончание) Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Окончание'")),,
					"Окончание",, 
					Отказ);
			КонецЕсли;
				
			Если ЗначениеЗаполнено(Начало) И ЗначениеЗаполнено(Окончание) И Начало > Окончание Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Время окончания меньше, чем время начала'"),,
					"Окончание",, 
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Если СпособУказанияВремениID = ЗначениеПеречисленияДлительность Тогда 
		Длительность = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоИзСтроки(ДлительностьРаботы);
	ИначеЕсли ЗначениеЗаполнено(Начало) И ЗначениеЗаполнено(Окончание) Тогда 
		Длительность = Окончание - Начало;
	КонецЕсли;
	
	ЗаписатьДанные();
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("name", Источник);
	ПараметрыОповещения.Вставить("id", ИсточникID);
	ПараметрыОповещения.Вставить("type", ИсточникТип);
	
	Оповестить("Запись_ДокументооборотТрудозатраты", ПараметрыОповещения, ИсточникID);
	
	Закрыть(Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура НеДобавлять(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
Процедура ДлительностьРаботыНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДлительностьРаботы = Результат.Значение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанные()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMActualWork");
	
	СоответствиеРеквизитов = Новый Соответствие;
	СоответствиеРеквизитов.Вставить("ДатаДобавления",  "addDate");
	СоответствиеРеквизитов.Вставить("Начало",          "begin");
	СоответствиеРеквизитов.Вставить("Окончание",       "end");
	СоответствиеРеквизитов.Вставить("ОписаниеРаботы",  "description");
	СоответствиеРеквизитов.Вставить("Длительность",    "duration");
	СоответствиеРеквизитов.Вставить("ВидРабот",        "workType");
	СоответствиеРеквизитов.Вставить("Проект",          "project");
	СоответствиеРеквизитов.Вставить("ПроектнаяЗадача", "projectTask");
	СоответствиеРеквизитов.Вставить("Источник",        "source");
	
	Для Каждого СтрокаСоответствия Из СоответствиеРеквизитов Цикл
		
		ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
			Прокси,
			ОбъектXDTO,
			СтрокаСоответствия.Значение,
			ЭтаФорма,
			СтрокаСоответствия.Ключ);
			
	КонецЦикла;
		
	Если ЗначениеЗаполнено(ВнешнийОбъект) Тогда
		
		ExternalObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
		ExternalObject.id = Строка(ВнешнийОбъект.УникальныйИдентификатор());
		ExternalObject.type = ВнешнийОбъект.Метаданные().ПолноеИмя();
		ExternalObject.name = Строка(ВнешнийОбъект);
		
		ОбъектXDTO.externalSource = ExternalObject;
		
	КонецЕсли;
		
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMCreateRequest");
	Запрос.object = ОбъектXDTO;

	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуОбъекта(ОбъектXDTO)
	
	ДатаДобавления = ОбъектXDTO.addDate;
	Начало = ОбъектXDTO.begin;
	Окончание = ОбъектXDTO.end;
	ОписаниеРаботы = ОбъектXDTO.description;
	Длительность = ОбъектXDTO.duration;
	ДлительностьСтр = ИнтеграцияС1СДокументооборотКлиентСервер.ЧислоВСтроку(Длительность);
	ВестиУчетПоПроектам = ОбъектXDTO.projectsEnabled;
		
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.workType, "ВидРабот", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.project,"Проект", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.projectTask,"ПроектнаяЗадача", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.source, "Источник", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.timeInputMethod,"СпособУказанияВремени", Ложь);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.user, "Пользователь", Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокВыбораВремени()
	
	СписокВыбора = Новый СписокЗначений;
	
	СписокВыбора.Добавить("00:15");
	СписокВыбора.Добавить("00:30");
	СписокВыбора.Добавить("00:45");
	СписокВыбора.Добавить("01:00");
	СписокВыбора.Добавить("01:30");
	СписокВыбора.Добавить("02:00");
	СписокВыбора.Добавить("03:00");
	СписокВыбора.Добавить("04:00");
	СписокВыбора.Добавить("05:00");
	
	Возврат СписокВыбора;
	
КонецФункции

#КонецОбласти
