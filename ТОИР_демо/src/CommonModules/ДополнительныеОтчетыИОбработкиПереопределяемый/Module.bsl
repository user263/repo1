////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных обработок.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов,
//   в которых размещены команды вызова.
//
//   Для рабочего стола вместо Метаданных необходимо добавлять.
//   ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.торо_УчетОборудованияИНормативов);
	Разделы.Добавить(Метаданные.Подсистемы.торо_МТО);
	Разделы.Добавить(Метаданные.Подсистемы.торо_НастройкаИАдминистрирование);
	Разделы.Добавить(Метаданные.Подсистемы.торо_НормативноСправочнаяИнформация);
	Разделы.Добавить(Метаданные.Подсистемы.торо_ПланированиеТОиР);
	Разделы.Добавить(Метаданные.Подсистемы.торо_УчетПоказателейЭксплуатации);
	Разделы.Добавить(Метаданные.Подсистемы.торо_УправлениеНарядамиИРаботами);
	Разделы.Добавить(ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола());
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных отчетов.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов, 
//   в которых размещены команды вызова.
//
//   Для рабочего стола вместо Метаданных необходимо добавлять.
//   ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.торо_УчетОборудованияИНормативов);
	Разделы.Добавить(Метаданные.Подсистемы.торо_МТО);
	Разделы.Добавить(Метаданные.Подсистемы.торо_НастройкаИАдминистрирование);
	Разделы.Добавить(Метаданные.Подсистемы.торо_НормативноСправочнаяИнформация);
	Разделы.Добавить(Метаданные.Подсистемы.торо_ПланированиеТОиР);
	Разделы.Добавить(Метаданные.Подсистемы.торо_УчетПоказателейЭксплуатации);
	Разделы.Добавить(Метаданные.Подсистемы.торо_УправлениеНарядамиИРаботами);
	Разделы.Добавить(ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола());
	
КонецПроцедуры

#КонецОбласти
