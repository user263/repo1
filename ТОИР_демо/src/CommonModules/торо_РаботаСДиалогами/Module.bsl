////////////////////////////////////////////////////////////////////////////////
// торо_РаботаСДиалогами: методы, для работы с диалогами
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Формирует и устанавливает текст заголовка формы документа.
//
// Параметры:
//  СтрокаВидаОперации - Строка - строка вида операции документа, 
//  ДокументОбъект     - ДокументОбъект - объект документа, 
//  ФормаДокумента     - УправляемаяФорма - форма документа.
//
Процедура УстановитьЗаголовокФормыДокумента(СтрокаВидаОперации = "", ДокументОбъект, ФормаДокумента) Экспорт

	Если ПустаяСтрока(СтрокаВидаОперации) Тогда
		Заголовок = ДокументОбъект.Метаданные().Синоним + "";
	Иначе
		Заголовок = ДокументОбъект.Метаданные().Синоним + " [" + СтрокаВидаОперации + "]";
	КонецЕсли;
		
	Если ДокументОбъект.ЭтоНовый() Тогда  
		Заголовок = Заголовок + НСтр("ru = '. Новый'");
	Иначе
		Заголовок = Заголовок + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ' №%1 от %2. '"),ДокументОбъект.Номер,ДокументОбъект.Дата);
		Если ДокументОбъект.Проведен Тогда
			Заголовок = Заголовок + НСтр("ru = 'Проведен'");
		ИначеЕсли ДокументОбъект.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
			Заголовок = Заголовок + НСтр("ru = 'Не проведен'");
		Иначе
			Заголовок = Заголовок + НСтр("ru = 'Записан'");
		КонецЕсли;
	КонецЕсли;
	
	// Добавления в заголовок статуса
	ФОИспользоватьСтатусыДокументов = ПолучитьФункциональнуюОпцию("торо_ИспользоватьСтатусыДокументовТОиР");
	Если ФОИспользоватьСтатусыДокументов Тогда
		Заголовок = торо_РаботаСоСтатусамиДокументовСервер.ДобавитьСтатусВЗаголовокФормы(Заголовок, ФормаДокумента);
	КонецЕсли;
		
	ФормаДокумента.Заголовок = Заголовок;

КонецПроцедуры 

// Функция возвращает список структур иерархии объектов рем. работ.
//
// Параметры:
//		ТекСтруктураИерархии - СправочникСсылка.торо_СтруктурыОР - текущая структура иерархии.
//		БезТекИерархии - Булево - пропускать текущую структуру.
//
//	Возвращаемое значение:
//		СписокЗначений - список структур иерархий.
Функция ЗаполнитьСписокСтруктур(ТекСтруктураИерархии, БезТекИерархии = Ложь) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_СтруктурыОР.Ссылка,
	|	торо_СтруктурыОР.Наименование
	|ИЗ
	|	Справочник.торо_СтруктурыОР КАК торо_СтруктурыОР
	|ГДЕ
	|	торо_СтруктурыОР.ПометкаУдаления = ЛОЖЬ
	|	И торо_СтруктурыОР.СтроитсяАвтоматически = ЛОЖЬ";
	
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

#КонецОбласти
