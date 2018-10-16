#Область СлужебныйПрограммныйИнтерфейс

// Процедура - Сформировать кадровые движения
//
// Параметры:
//  РегистраторОбъект	 - ДокументОбъект.Увольнение,ДокументОбъект.ПриемНаРаботу,ДокументОбъект.КадровыйПеревод	 - 
//							Документ по которому формируются движения.
//  Движения			 - КоллекцияДвижений	 - Коллекция движений, в которой необходимо заполнить кадровые движения.
//  КадровыеДвижения	 - ТаблицаЗначений	 - Таблица значений с полями:
//		ДатаСобытия
//		ВидСобытия - Перечисление.ВидыКадровыхСобытий
//		ДействуетДо (не обязательно)
//		Сотрудник
//		Позиция (не обязательно)
//		Подразделение (не обязательно)
//		Должность (не обязательно)
// 		КоличествоСтавок (не обязательно).
Процедура СформироватьКадровыеДвижения(РегистраторОбъект, Движения, КадровыеДвижения) Экспорт
	
	КадровыйУчетРасширенный.СформироватьКадровыеДвижения(РегистраторОбъект, Движения, КадровыеДвижения);

КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////////
// Формирование временных таблиц с кадровыми данными

Функция НеобходимыКадровыеДанныеФизическогоЛица(ИмяПоля) Экспорт
	
	Возврат КадровыйУчетРасширенный.НеобходимыКадровыеДанныеФизическогоЛица(ИмяПоля);
	
КонецФункции

// Функция формирует временную таблицу с кадровыми данными. 
// Параметры:
//         ТолькоРазрешенные - Булево
//         ИмяВТКадровыеДанныеФизическихЛиц - строка
//         ИмяВременнойТаблицыОтборовФизическихЛиц - строка
//		   КадровыеДанные - см. описание к функции КадровыеДанныеФизическихЛиц 
//         ПоляОтбораФизическихЛиц  - структура
//         ПоляОтбораПериодическихДанных -  см. описание к функции КадровыеДанныеФизическихЛиц.
//
// Возвращаемое значение:
//	Запрос - подготовленный запрос.
//
Функция ЗапросВТКадровыеДанныеФизическихЛиц(ТолькоРазрешенные, ИмяВТКадровыеДанныеФизическихЛиц, ИмяВременнойТаблицыОтборовФизическихЛиц, ПоляОтбораФизическихЛиц, КадровыеДанные, ПоляОтбораПериодическихДанных) Экспорт
	
	Возврат КадровыйУчетРасширенный.ЗапросВТКадровыеДанныеФизическихЛиц(ТолькоРазрешенные, ИмяВТКадровыеДанныеФизическихЛиц, ИмяВременнойТаблицыОтборовФизическихЛиц, ПоляОтбораФизическихЛиц, КадровыеДанные, ПоляОтбораПериодическихДанных);
	
КонецФункции

// Осуществляет запрос во временную таблицу кадровых данных о сотрудниках.
// Параметры:
// 		ТолькоРазрешенные - Булево
//			ИмяВТКадровыеДанныеСотрудников - строка
//       ИмяВременнойТаблицыОтборовСотрудников - строка
//       ПоляОтбораСотрудников - структура
//       КадровыеДанные - структура
//       ПоляОтбораПериодическихДанных  - структура.
//
// Возвращаемое значение:
//	Запрос - подготовленный запрос.
//
Функция ЗапросВТКадровыеДанныеСотрудников(ТолькоРазрешенные, ИмяВТКадровыеДанныеСотрудников, ИмяВременнойТаблицыОтборовСотрудников, ПоляОтбораСотрудников, КадровыеДанные, ПоляОтбораПериодическихДанных) Экспорт
	
	Возврат КадровыйУчетРасширенный.ЗапросВТКадровыеДанныеСотрудников(ТолькоРазрешенные, ИмяВТКадровыеДанныеСотрудников, ИмяВременнойТаблицыОтборовСотрудников, ПоляОтбораСотрудников, КадровыеДанные, ПоляОтбораПериодическихДанных);
	
КонецФункции

Функция ЗапросВТСотрудникиОрганизации(ТолькоРазрешенные, ИмяВТСотрудникиОрганизации, Параметры) Экспорт
	
	Возврат КадровыйУчетРасширенный.ЗапросВТСотрудникиОрганизации(ТолькоРазрешенные, ИмяВТСотрудникиОрганизации, Параметры);
	
КонецФункции

Функция ДополнительныеСведенияУнифицированнойФормыТ2(СтрокиДанных, ДатаОтчета) Экспорт
	
	Возврат КадровыйУчетРасширенный.ДополнительныеСведенияУнифицированнойФормыТ2(СтрокиДанных, ДатаОтчета);
	
КонецФункции

Функция ОтчетВидаКарточкаСотрудника(КлючВарианта) Экспорт
	
	Возврат КадровыйУчетРасширенный.ОтчетВидаКарточкаСотрудника(КлючВарианта);
	
КонецФункции

Процедура ВывестиМакетыОтчетовПоСотрудникам(КлючВарианта, ДокументРезультат, Данные, Группировки, Период, СоответствиеПользовательскихПолей) Экспорт
	
	КадровыйУчетРасширенный.ВывестиМакетыОтчетовПоСотрудникам(КлючВарианта, ДокументРезультат, Данные, Группировки, Период, СоответствиеПользовательскихПолей);
	
КонецПроцедуры

Процедура СоздатьВТДанныеДокументовКадровыхПеремещений(МенеджерВременныхТаблиц, МассивОбъектов) Экспорт
	
	КадровыйУчетРасширенный.СоздатьВТДанныеДокументовКадровыхПеремещений(МенеджерВременныхТаблиц, МассивОбъектов);
	
КонецПроцедуры

Процедура СоздатьВТДанныеДокументовПриемНаРаботу(МенеджерВременныхТаблиц, МассивОбъектов) Экспорт
	
	КадровыйУчетРасширенный.СоздатьВТДанныеДокументовПриемНаРаботу(МенеджерВременныхТаблиц, МассивОбъектов);
	
КонецПроцедуры

Процедура СоздатьВТДанныеДокументовУвольнение(МенеджерВременныхТаблиц, МассивОбъектов) Экспорт
	
	КадровыйУчетРасширенный.СоздатьВТДанныеДокументовУвольнение(МенеджерВременныхТаблиц, МассивОбъектов);
	
КонецПроцедуры

Функция КадровыеДанныеДляПечатиКадровыхПриказов() Экспорт
	
	Возврат КадровыйУчетРасширенный.КадровыеДанныеДляПечатиКадровыхПриказов();
	
КонецФункции

Процедура ОбновитьВидыКонтактнойИнформацииФизическогоЛица() Экспорт
	
	КадровыйУчетРасширенный.ОбновитьВидыКонтактнойИнформацииФизическогоЛица();
	
КонецПроцедуры

// Возвращает временную таблицу тарифных ставок сотрудников.
// Параметры:
//         ТолькоРазрешенные - Булево
//         ИмяВТТарифныеСтавкиСотрудников - строка
//         ИмяВременнойТаблицыОтборовСотрудников - строка
//         ПоляОтбораСотрудников  - структура
//         ПоляОтбораПериодическихДанных -  см. описание к функции КадровыеДанныеФизическихЛиц.
//
// Возвращаемое значение:
//		Запрос - подготовленный запрос.
//
Функция ЗапросВТТарифныеСтавкиСотрудников(ТолькоРазрешенные, ИмяВТТарифныеСтавкиСотрудников, ИмяВременнойТаблицыОтборовСотрудников, ПоляОтбораСотрудников, ПоляОтбораПериодическихДанных) Экспорт
	
	Возврат КадровыйУчетРасширенный.ЗапросВТТарифныеСтавкиСотрудников(ТолькоРазрешенные, ИмяВТТарифныеСтавкиСотрудников, ИмяВременнойТаблицыОтборовСотрудников, ПоляОтбораСотрудников, ПоляОтбораПериодическихДанных);
	
КонецФункции

Функция НеобходимыТекущиеДанныеСотрудника(ИмяПоля) Экспорт
	
	Возврат КадровыйУчетБазовый.НеобходимыТекущиеДанныеСотрудника(ИмяПоля);
	
КонецФункции

Функция ПутьКДаннымПоИмениЗапрашиваемыхТекущихДанныхСотрудника(ИмяПоля) Экспорт
	
	Возврат КадровыйУчетБазовый.ПутьКДаннымПоИмениЗапрашиваемыхТекущихДанныхСотрудника(ИмяПоля);
	
КонецФункции

Функция ПутьКДаннымПоИмениЗапрашиваемойТекущейТарифнойСтавкиСотрудника(ИмяПоля) Экспорт
	
	Возврат КадровыйУчетРасширенный.ПутьКДаннымПоИмениЗапрашиваемойТекущейТарифнойСтавкиСотрудника(ИмяПоля);
	
КонецФункции

Функция ПутиКДаннымПоИменамЗапрашиваемыхДанныхДолжности() Экспорт
	
	Возврат КадровыйУчетРасширенный.ПутиКДаннымПоИменамЗапрашиваемыхДанныхДолжности();
	
КонецФункции

Процедура ОбновитьТекущиеКадровыеДанныеСотрудников(Запрос) Экспорт
	
	КадровыйУчетРасширенный.ОбновитьТекущиеКадровыеДанныеСотрудников(Запрос);
	
КонецПроцедуры

Процедура ПеренестиТекущиеКадровыеДанныеСотрудниковИзСправочникаВРегистры() Экспорт
	
	// В этой конфигурации не вызываем обработчик обновления
	
КонецПроцедуры

Процедура ПроверитьТекущуюТарифнуюСтавку(Источник, Отказ, Замещение) Экспорт
	
	// В этой конфигурации, ничего не делаем
	
КонецПроцедуры

Процедура УстановитьТекущуюТарифнуюСтавку(Источник, Отказ, Замещение) Экспорт
	
	// В этой конфигурации, ничего не делаем
	
КонецПроцедуры

Функция НеобходимыСведенияПриказаОПриеме(Знач ИмяПоля) Экспорт
	
	Возврат КадровыйУчетРасширенный.НеобходимыСведенияПриказаОПриеме(ИмяПоля);
	
КонецФункции

Функция ПутьКДаннымПоИмениДанныхПриказаОПриеме(ИмяПоля) Экспорт
	
	Возврат КадровыйУчетРасширенный.ПутьКДаннымПоИмениДанныхПриказаОПриеме(ИмяПоля)
	
КонецФункции

Функция ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц() Экспорт
		
	Возврат КадровыйУчетРасширенный.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	
КонецФункции

Функция ПараметрыПолученияСотрудниковОрганизацийПоВременнойТаблице() Экспорт

	Возврат КадровыйУчетРасширенный.ПараметрыПолученияСотрудниковОрганизацийПоВременнойТаблице();
	
КонецФункции

Функция ОписанияСоставаНачисленийПоВременнойТаблице(МенеджерВременныхТаблиц, ИмяВТСотрудникиПериоды, ИмяПоляПериод, ИмяПоляСотрудник) Экспорт
	
	Возврат КадровыйУчетРасширенный.ОписанияСоставаНачисленийПоВременнойТаблице(МенеджерВременныхТаблиц, ИмяВТСотрудникиПериоды, ИмяПоляПериод, ИмяПоляСотрудник);
	
КонецФункции

#КонецОбласти
