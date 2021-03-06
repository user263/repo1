#Область ПрограммныйИнтерфейс

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП.
//	Возвращаемое значение:
//		Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ТипНоменклатуры");
	Результат.Добавить("ИспользованиеХарактеристик");
	Результат.Добавить("ИспользоватьХарактеристики");
	Результат.Добавить("ИспользоватьСерии");
	Результат.Добавить("НастройкаИспользованияСерий");
	
	Возврат Результат;

КонецФункции

#КонецОбласти