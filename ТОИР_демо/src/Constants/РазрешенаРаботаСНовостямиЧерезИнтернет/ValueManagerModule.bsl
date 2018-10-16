////////////////////////////////////////////////////////////////////////////////
// Константа.РазрешенаРаботаСНовостямиЧерезИнтернет: Модуль менеджера.
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ)

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить("ЗначениеПередЗаписью", Константы.РазрешенаРаботаСНовостямиЧерезИнтернет.Получить());
	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Получение функциональных опций "Новости_РазрешенаРаботаСНовостями"
	//  и "Новости_РазрешенаРаботаСНовостямиЧерезИнтернет" осуществляется через
	//  общий модуль "ОбработкаНовостейПовтИсп", поэтому после установки
	//  константы необходимо сбросить кэш.
	ОбновитьПовторноИспользуемыеЗначения();

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда

		#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
			ОбъектМетаданных = Неопределено;
		#Иначе
			ОбъектМетаданных = Метаданные.Константы.РазрешенаРаботаСНовостямиЧерезИнтернет;
		#КонецЕсли

		// Запись в журнал регистрации
		ТекстСообщения = НСтр("ru='Записана константа РазрешенаРаботаСНовостямиЧерезИнтернет
			|Предыдущее значение: %ПредыдущееЗначение%
			|Новое значение: %НовоеЗначение%'");
		Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ЗначениеПередЗаписью") Тогда
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредыдущееЗначение%", ЭтотОбъект.ДополнительныеСвойства.ЗначениеПередЗаписью);
		Иначе
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредыдущееЗначение%", "Неопределено");
		КонецЕсли;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НовоеЗначение%", ЭтотОбъект.Значение);
		// Запись в журнал регистрации
		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Изменение данных'"), // ИмяСобытия
			НСтр("ru='Новости. Изменение данных. Константы. РазрешенаРаботаСНовостямиЧерезИнтернет'"), // ИдентификаторШага
			"Информация", // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
