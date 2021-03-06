
#Область ПрограммныйИнтерфейс

#Область ПолученияСтруктурКэшируемыхЗначений

// Функция - Получить структуру кэшируемые значения
// Возвращаемое значение:
//  Структура - Ключ: "КоэффициентыУпаковок" (Новый Соответствие).
Функция ПолучитьСтруктуруКэшируемыеЗначения() Экспорт
	
	КэшированныеЗначения = Новый Структура;
	КэшированныеЗначения.Вставить("КоэффициентыУпаковок",	Новый Соответствие);	
	Возврат КэшированныеЗначения;
	
КонецФункции // ПолучитьСтруктуруКэшируемыеЗначения()

// Функция - Получить структуру кэшируемые значения услуг
// Возвращаемое значение:
//  Структура - Ключи
//		ПроцентыСтавокНДС - Новый Соответствие,
//		ШтрихКоды - Новый Соответствие,
//		ИспользоватьРучныеСкидкиВПродажах - Неопределено,
//		ИспользоватьАвтоматическиеСкидкиВПродажах - Неопределено,
//		ИспользоватьРучныеСкидкиВЗакупках - Неопределено.
Функция ПолучитьСтруктуруКэшируемыеЗначенияУслуг() Экспорт
	
	КэшированныеЗначения = Новый Структура;
	КэшированныеЗначения.Вставить("ПроцентыСтавокНДС",    Новый Соответствие);
	КэшированныеЗначения.Вставить("Штрихкоды",            Новый Соответствие);
	КэшированныеЗначения.Вставить("ИспользоватьРучныеСкидкиВПродажах",         Неопределено);
	КэшированныеЗначения.Вставить("ИспользоватьАвтоматическиеСкидкиВПродажах", Неопределено);
	КэшированныеЗначения.Вставить("ИспользоватьРучныеСкидкиВЗакупках",         Неопределено);
	
	Возврат КэшированныеЗначения;
	
КонецФункции // ПолучитьСтруктуруКэшируемыеЗначенияУслуг()

#КонецОбласти

#Область ПолучениеСтруктурПараметровДляОбработкиТабличнойЧастиТовары

// Функция - Получить структуру заполнения цены в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключи: "Дата" (Объект.Дата), "Валюта" (Объект.Валюта).
Функция ПолучитьСтруктуруЗаполненияЦеныВСтрокеТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("Дата",   Объект.Дата);
	СтруктураЗаполненияЦены.Вставить("Валюта", Объект.Валюта);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру пересчета суммы НДС в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключ: "ЦенаВключаетНДС" (Объект.ЦенаВключаетНДС).
Функция ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру заполнения цены закупки в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.  
// Возвращаемое значение:
//  Структура - Ключи: "Дата" (Объект.Дата), "Валюта" (Объект.Валюта).
Функция ПолучитьСтруктуруЗаполненияЦеныЗакупкиВСтрокеТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("Дата",       Объект.Дата);
	СтруктураЗаполненияЦены.Вставить("Валюта",     Объект.Валюта);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру заполнения условий продаж в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключи
//		"Дата" (Объект.Дата),
//		"Валюта" (Объект.Валюта),
//		"Соглашение" (Объект.Соглашение),
//		"Ссылка" (Объект.Ссылка).
Функция ПолучитьСтруктуруЗаполненияУсловийПродажВСтрокеТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("Дата",       Объект.Дата);
	СтруктураЗаполненияЦены.Вставить("Валюта",     Объект.Валюта);
	СтруктураЗаполненияЦены.Вставить("Соглашение", Объект.Соглашение);
	СтруктураЗаполненияЦены.Вставить("Ссылка",     Объект.Ссылка);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру заполнения цены розница в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключи
//		"Дата" (Объект.Дата),
//		"Валюта" (Объект.Валюта),
//		"ВидЦены" (Объект.ВидЦены).
Функция ПолучитьСтруктуруЗаполненияЦеныРозницаВСтрокеТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("Дата",    Объект.Дата);
	СтруктураЗаполненияЦены.Вставить("Валюта",  Объект.Валюта);
	СтруктураЗаполненияЦены.Вставить("ВидЦены", Объект.ВидЦены);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру заполнения цены по ассортименту в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключи
//		"Дата" (Объект.Дата),
//		"Валюта" (Объект.Валюта),
//		"Склад" (Объект.Склад).
Функция ПолучитьСтруктуруЗаполненияЦеныПоАссортиментуВСтрокеТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("Дата",    Объект.Дата);
	СтруктураЗаполненияЦены.Вставить("Валюта",  Объект.Валюта);
	СтруктураЗаполненияЦены.Вставить("Склад", 	Объект.Склад);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру пересчета цены скидки в продажах в ТЧ
//
// Параметры:
//  Объект - Объект - объект.	 
//  ПередачаНаКомиссию - Булево - передача на комиссию.
//  ИмяКоличества - Строка - Имя количества.
// Возвращаемое значение:
//  Структура - Ключи
//		"ИмяКоличества" (из параметра функции ИмяКоличества),
//		В случае если не передача на комиссию тогда добавляются ключи
//		"ИспользоватьРучныеСкидки" и "ИспользоватьАвтоматическиеСкидки".
Функция ПолучитьСтруктуруПересчетаЦеныСкидкиВПродажахВТЧ(Объект, ПередачаНаКомиссию = Ложь, ИмяКоличества = "КоличествоУпаковок") Экспорт

	СтруктураЗаполненияЦены = Новый Структура;
	
	Если Не ПередачаНаКомиссию Тогда
		СтруктураЗаполненияЦены.Вставить("ИспользоватьРучныеСкидки");
		СтруктураЗаполненияЦены.Вставить("ИспользоватьАвтоматическиеСкидки");
	КонецЕсли;
	
	СтруктураЗаполненияЦены.Вставить("ИмяКоличества", ИмяКоличества);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру пересчета цены скидки в закупках ВТЧ
//
// Параметры:
//  Объект - Объект - объект.			  
//  ПриемНаКомиссию - Булево - Осуществляется ли прием на комиссию.
// Возвращаемое значение:
//  Структура - Структура заполнения цены. Если ПриемНаКомиссию - истина, тогда структура пустая,
//													иначе есть ключ "ИспользоватьРучныеСкидки".
Функция ПолучитьСтруктуруПересчетаЦеныСкидкиВЗакупкахВТЧ(Объект, ПриемНаКомиссию) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	
	Если Не ПриемНаКомиссию Тогда
		СтруктураЗаполненияЦены.Вставить("ИспользоватьРучныеСкидки");
	КонецЕсли;
	
	Возврат СтруктураЗаполненияЦены;

КонецФункции

// Функция - Получить структуру проверки сопоставленной номенклатуры поставщика в строке ТЧ.
//
// Параметры:
//  Объект - Объект - объект.
//  НеВыполнятьПроверкуДляПользователя	 - Булево - не выполнять проверку для пользователя.
// Возвращаемое значение:
//  Структура  - ключи: "Ссылка", "Партнер" и "НеВыполнятьПроверкуДляПользователя".
Функция ПолучитьСтруктуруПроверкиСопоставленнойНоменклатурыПоставщикаВСтрокеТЧ(Объект, НеВыполнятьПроверкуДляПользователя) Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ссылка",                             Объект.Ссылка);
	СтруктураПараметров.Вставить("Партнер",                            Объект.Партнер);
	СтруктураПараметров.Вставить("НеВыполнятьПроверкуДляПользователя", НеВыполнятьПроверкуДляПользователя);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Функция - Получить структуру заполнения склада в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.		  
//  СкладГруппа - СправочникСсылка.Склады - Группа склада
// Возвращаемое значение:
//  Структура - С ключами "Склад" (Объект.Склад) и "СкладГруппа" (СкладГруппа).
Функция ПолучитьСтруктуруЗаполненияСкладаВСтрокеТЧ(Объект, СкладГруппа) Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склад",       Объект.Склад);
	СтруктураПараметров.Вставить("СкладГруппа", СкладГруппа);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Функция - Получить структуру заполнения содержания услуги в строке ТЧ
//
// Параметры:
//  Объект - Объект - объект.					  
//  ЗаполнятьДляВсехУслуг - Булево - заполнять для всех услуг.
// Возвращаемое значение:
//  Структура - структура для заполнения содержания.
Функция ПолучитьСтруктуруЗаполненияСодержанияУслугиВСтрокеТЧ(Объект, ЗаполнятьДляВсехУслуг) Экспорт
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ЗаполнятьДляВсехУслуг", ЗаполнятьДляВсехУслуг);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Функция - Получить структуру пересчета суммы НДСВТЧ
//
// Параметры:
//  Объект - Объект - объект.	 
// Возвращаемое значение:
//  Структура - С ключем "ЦенаВключаетНДС" - Объект.ЦенаВключаетНДС.
Функция ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(Объект) Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС);
	
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

// Функция - Получить структуру заполнения ставки НДС
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключи: "Дата" (Объект.Дата), "Организация" (Объект.Организация).
Функция ПолучитьСтруктуруЗаполненияСтавкиНДС(Объект) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Дата"       , Объект.Дата);
	Результат.Вставить("Организация", Объект.Организация);
	
	Возврат Результат;
	
КонецФункции

// Функция - Получить структуру заполнения признака без возвратной тары
//
// Параметры:
//  Объект - Объект - объект.	  
// Возвращаемое значение:
//  Структура - Ключ: "ВернутьМногооборотнуюТару" (Объект.ВернутьМногооборотнуюТару).
Функция ПолучитьСтруктуруЗаполненияПризнакаБезВозвратнойТары(Объект) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВернутьМногооборотнуюТару" , Объект.ВернутьМногооборотнуюТару);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыПересчетаИЗаполненияКлиентСервер

// Процедура - Заполнить признак наличия комментария приемка
//
// Параметры:
//  ТекущаяСтрока - СтрокаТаблицыЗначений - Поля
//		ЕстьКомментарийКлиента,
//		ЕстьКомментарийМенеджера,
//		КомментарийКлиента,
//		КомментарийМенеджера.
//  СтруктураДействий - Структура - Если отсутствует ключ "ПризнакНаличиеКомментарияПриемка"
//										то ничего не делать.
Процедура ЗаполнитьПризнакНаличияКомментарияПриемка(ТекущаяСтрока, СтруктураДействий) Экспорт

	Если НЕ СтруктураДействий.Свойство("ПризнакНаличиеКомментарияПриемка") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекущаяСтрока.ЕстьКомментарийКлиента = НЕ ПустаяСтрока(ТекущаяСтрока.КомментарийКлиента);
	ТекущаяСтрока.ЕстьКомментарийМенеджера = НЕ ПустаяСтрока(ТекущаяСтрока.КомментарийМенеджера);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
