////////////////////////////////////////////////////////////////////////////////
// СотрудникиФормыРасширенный: методы, обслуживающие работу формы сотрудника
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы Сотрудника

Процедура СотрудникиПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СотрудникиФормыБазовый.СотрудникиПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);

	Если Форма.Параметры.Свойство("РежимОткрытияОкна") 
		И ЗначениеЗаполнено(Форма.Параметры.РежимОткрытияОкна) Тогда
		Форма.РежимОткрытияОкна = Форма.Параметры.РежимОткрытияОкна;
	КонецЕсли;
	Если Форма.Параметры.Ключ.Пустая() И НЕ ЗначениеЗаполнено(Форма.Сотрудник.ГоловнаяОрганизация) Тогда
		Форма.Сотрудник.ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Параметры.Организация, "Ссылка");
	КонецЕсли;
	
КонецПроцедуры

Процедура СотрудникиПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СотрудникиФормыБазовый.СотрудникиПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

Процедура СотрудникиПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормыБазовый.СотрудникиПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
		
КонецПроцедуры

Процедура СотрудникиОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	СотрудникиФормыБазовый.СотрудникиОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты);
	
	Если НЕ ЗначениеЗаполнено(Форма.Сотрудник.ГоловнаяОрганизация) Тогда
		ТекстСообщения = НСтр("ru='Не заполнена Организация'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Сотрудник.ГоловнаяОрганизация",
			,
			Отказ);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы Физического лица

Процедура ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	МассивРеквизитов = Новый Массив;
		
	РеквизитРольФизическогоЛицаПриСоздании = Новый РеквизитФормы("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	МассивРеквизитов.Добавить(РеквизитРольФизическогоЛицаПриСоздании);
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
				
		Если Форма.Параметры.Свойство("Организация") Тогда
			Форма.Организация = Форма.Параметры.Организация;
		КонецЕсли;
		
	КонецЕсли; 
	
	СотрудникиФормыБазовый.ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
	Если Форма.Параметры.Свойство("РежимОткрытияОкна") 
		И ЗначениеЗаполнено(Форма.Параметры.РежимОткрытияОкна) Тогда
		Форма.РежимОткрытияОкна = Форма.Параметры.РежимОткрытияОкна;
	КонецЕсли; 
	
	Форма.Заголовок = СотрудникиКлиентСервер.ЗаголовокФормыФизическогоЛица(Форма);
	
КонецПроцедуры

Процедура ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СотрудникиФормыБазовый.ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

Процедура ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормыБазовый.ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
		
КонецПроцедуры

Процедура ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормыБазовый.ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Функция ДругиеРабочиеМеста(ФизическоеЛицоСсылка, СотрудникИсключение) Экспорт
	
	ТаблицаРаботников = Новый ТаблицаЗначений;
	ТаблицаРаботников.Колонки.Добавить("Организация");
	
	Возврат ТаблицаРаботников;
		
КонецФункции

Функция ЗаголовокКнопкиОткрытияСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений, ВыводитьПодробнуюИнформацию = Ложь) Экспорт
	
	Если ДанныеСотрудника.Договорник = Истина Тогда
		
		Если ВыводитьПодробнуюИнформацию Тогда
			
			Возврат НСтр("ru = 'Подробнее...'");
			
		Иначе
			
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСТр("ru='%1 с %2'"),
				ДанныеСотрудника.ТипДоговора,
				Формат(ДанныеСотрудника.ДатаДоговора, "ДФ=дд.ММ.гггг"));
			
		
		КонецЕсли;
		
	Иначе
		
		Возврат СотрудникиФормыБазовый.ЗаголовокКнопкиОткрытияСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений, ВыводитьПодробнуюИнформацию);
		
	КонецЕсли;
	
КонецФункции

Функция ПоясняющаяНадписьКМестуРаботыСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений) Экспорт
	
	Если ДанныеСотрудника.Договорник = Ложь Тогда
		
		Возврат СотрудникиФормыБазовый.ПоясняющаяНадписьКМестуРаботыСотрудника(ДанныеСотрудника, РеквизитыОрганизации, ДатаСведений);
		
	Иначе
		
		СтрокаПериодРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСТр("ru='%1 с %2'"),
			ДанныеСотрудника.ТипДоговора,
			Формат(ДанныеСотрудника.ДатаДоговора, "ДФ=дд.ММ.гггг"));
		
		Результат = Новый Структура;
		Результат.Вставить("ИнфоНадписьПериодРаботы", СтрокаПериодРаботы);
		Результат.Вставить("ИнфоНадписьОрганизация", ?(ЗначениеЗаполнено(РеквизитыОрганизации.Наименование), РеквизитыОрганизации.Наименование,  НСТР("ru = 'не указана'")));
		Результат.Вставить("ИнфоНадписьДолжность", "");
		Результат.Вставить("ИнфоНадписьОклад", "");
		Возврат Результат;
		
	КонецЕсли; 
	
КонецФункции

Процедура УстановитьВидимостьЭлементовФормыМестаРаботы(Форма, НомерСотрудника, ДанныеСотрудника) Экспорт
	
	ВидимостьЭлементов = (ДанныеСотрудника.Договорник <> Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ИнфоНадписьДолжность" + НомерСотрудника,
		"Видимость",
		ВидимостьЭлементов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ИнфоНадписьОклад" + НомерСотрудника,
		"Видимость",
		ВидимостьЭлементов);
		
КонецПроцедуры

Процедура ФизическиеЛицаОбновитьЭлементыФормы(Форма) Экспорт
	
	СотрудникиФормыБазовый.ФизическиеЛицаОбновитьЭлементыФормы(Форма);
	
КонецПроцедуры

Процедура СотрудникиОбновитьЭлементыФормы(Форма) Экспорт
	
	СотрудникиФормыБазовый.СотрудникиОбновитьЭлементыФормы(Форма);
	
	СостояниеИРолиСотрудника = СостояниеИРолиСотрудника(Форма.СотрудникСсылка);
		
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		РольСотрудникаПриСоздании = Неопределено;
		Форма.Параметры.Свойство("РольСотрудника", РольСотрудникаПриСоздании);
		Если НЕ ЗначениеЗаполнено(РольСотрудникаПриСоздании) 
			И Форма.Параметры.Свойство("ЗначенияЗаполнения") Тогда
			Форма.Параметры.ЗначенияЗаполнения.Свойство("РольСотрудника", РольСотрудникаПриСоздании);
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(РольСотрудникаПриСоздании) Тогда
			Форма.РольСотрудникаПриСоздании = РольСотрудникаПриСоздании;
			Если Форма.Параметры.Свойство("ГоловнаяОрганизация") Тогда
				Форма.Сотрудник.ГоловнаяОрганизация = Форма.Параметры.ГоловнаяОрганизация;
			КонецЕсли; 
		КонецЕсли; 
		
	КонецЕсли; 
		
	УстановитьПривилегированныйРежим(Истина);
	КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Форма.СотрудникСсылка, "Организация,ГрафикРаботы", ТекущаяДатаСеанса());
	Если КадровыеДанныеСотрудника.Количество() > 0 Тогда
		Форма.ТекущийГрафикРаботы = КадровыеДанныеСотрудника[0].ГрафикРаботы;
	КонецЕсли; 
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция БанковскийСчетИнформацияОПричинахНедоступности() Экспорт
	
	Возврат НСтр("ru = 'Для ввода лицевого счета, необходимо оформить прием на работу'");
	
КонецФункции

Процедура ЛичныеДанныеФизическихЛицОбработкаПроверкиЗаполненияВФорме(Форма, ФизическоеЛицоСсылка, Отказ) Экспорт
	
	СотрудникиФормыБазовый.ЛичныеДанныеФизическихЛицОбработкаПроверкиЗаполненияВФорме(Форма, ФизическоеЛицоСсылка, Отказ);
	ПроверитьУникальностьФизическогоЛицаВФорме(Форма, Отказ);
	
КонецПроцедуры

Процедура ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация) Экспорт
	
	СотрудникиФормыБазовый.ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация);
	
КонецПроцедуры

Функция РезультатыПроверкиУникальностиФизическогоЛица(ФизическоеЛицоСсылка, ИНН, СтраховойНомерПФР, ДокументВид = "", ДокументСерия = "", ДокументНомер = "") Экспорт
	
	СтруктураВозврат = Новый Структура("ФизическоеЛицоУникально,СообщенияПроверки", Истина, Новый Массив);
	
	ТаблицаСовпадений = ТаблицаСовпаденийФизическихЛицПоИННСНИЛСДокументаУдостоверяющегоЛичность(
							ФизическоеЛицоСсылка,
							ИНН,
							СтраховойНомерПФР,
							ДокументВид,
							ДокументСерия,
							ДокументНомер);
							
	Если ТаблицаСовпадений.Количество() > 0 Тогда
		
		СтруктураВозврат.ФизическоеЛицоУникально = Ложь;
		
		МассивФизическихЛиц = ТаблицаСовпадений.ВыгрузитьКолонку("ФизическоеЛицо");
		
		ЗаполнитьДанныеФизическиеЛиц(СтруктураВозврат, МассивФизическихЛиц);
		
		Если ЗначениеЗаполнено(ИНН) Тогда
			СтрокиСИНН = ТаблицаСовпадений.НайтиСтроки(Новый Структура("ИНН", ИНН));
			Если СтрокиСИНН.Количество() > 0 Тогда
				СтруктураСообщения = Новый Структура("ИмяПоля,ИмяОбъекта,ТекстСообщенияОбОшибке", "ИНН", "ФизическоеЛицо", "");
				СтруктураСообщения.ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Найдена запись о человеке, имеющем такой же ИНН (%1)'"),
					ИНН);
				СтруктураВозврат.СообщенияПроверки.Добавить(СтруктураСообщения);
			КонецЕсли;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(СтраховойНомерПФР) Тогда
			СтрокиССтраховойНомерПФР = ТаблицаСовпадений.НайтиСтроки(Новый Структура("СтраховойНомерПФР", СтраховойНомерПФР));
			Если СтрокиССтраховойНомерПФР.Количество() > 0 Тогда
				СтруктураСообщения = Новый Структура("ИмяПоля,ИмяОбъекта,ТекстСообщенияОбОшибке", "СтраховойНомерПФР", "ФизическоеЛицо", "");
				СтруктураСообщения.ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Найдена запись о человеке, имеющем такой же СНИЛС (%1)'"),
					СтраховойНомерПФР);
				СтруктураВозврат.СообщенияПроверки.Добавить(СтруктураСообщения);
			КонецЕсли;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДокументВид) Тогда
			СтрокиСДокументом = ТаблицаСовпадений.НайтиСтроки(Новый Структура("ДокументВид,ДокументСерия,ДокументНомер", 
				ДокументВид,
				ДокументСерия,
				ДокументНомер));
			Если СтрокиСДокументом.Количество() > 0 Тогда
				СтруктураСообщения = Новый Структура("ИмяПоля,ИмяОбъекта,ТекстСообщенияОбОшибке", "Документ", "ДокументыФизическихЛиц", "");
				СтруктураСообщения.ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Найдена запись о человеке, имеющем такой же документ, удостоверяющий личность (%1 №%2 %3)'"),
					ДокументВид,
					?(ПустаяСтрока(ДокументСерия), "", " " + ДокументСерия),
					ДокументНомер);
				СтруктураВозврат.СообщенияПроверки.Добавить(СтруктураСообщения);
			КонецЕсли;
		КонецЕсли; 
		
		СтруктураВозврат.Вставить("ДоступнаРольСохранениеДанныхЗадвоенныхФизическихЛиц", Пользователи.РолиДоступны("СохранениеДанныхЗадвоенныхФизическихЛиц"));
	
	КонецЕсли;
	
	Возврат СтруктураВозврат;
	
КонецФункции

Процедура ПрочитатьДанныеСвязанныеССотрудником(Форма) Экспорт
	
	СотрудникиФормыБазовый.ПрочитатьДанныеСвязанныеССотрудником(Форма);
	
КонецПроцедуры

Процедура ПрочитатьДанныеСвязанныеСФизлицом(Форма, ДоступенПросмотрДанныхФизическихЛиц, Организация, ИзФормыСотрудника) Экспорт
	
	СотрудникиФормыБазовый.ПрочитатьДанныеСвязанныеСФизлицом(Форма, ДоступенПросмотрДанныхФизическихЛиц, Организация, ИзФормыСотрудника);
	
КонецПроцедуры

Функция КлючиСтруктурыТекущихКадровыхДанныхСотрудника() Экспорт
	
	КлючиСтруктурыТекущихКадровыхДанныхСотрудника = СотрудникиФормыБазовый.КлючиСтруктурыТекущихКадровыхДанныхСотрудника();
		
	Возврат КлючиСтруктурыТекущихКадровыхДанныхСотрудника; 
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Механизм встраивания форм

Процедура ПрочитатьНаборЗаписей(Форма, ИмяРегистра) Экспорт
	
	ТаблицаЗаписей = ТаблицаЗаписейРегистра(ИмяРегистра, Форма.ФизическоеЛицоСсылка);
	Форма[ИмяРегистра].Загрузить(ТаблицаЗаписей);
	
КонецПроцедуры

Процедура СохранитьНаборЗаписей(Форма, ИмяРегистра, ИсключаемыеИменаКолонок = "") Экспорт
	
	ТаблицаЗаписейФормы = Форма[ИмяРегистра].Выгрузить();
	ТаблицаЗаписейФормы.Колонки.Удалить("ИсходныйНомерСтроки");
	
	Если НЕ ПустаяСтрока(ИсключаемыеИменаКолонок) Тогда
		
		ИменаКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИсключаемыеИменаКолонок);
		Для каждого ИмяКолонки Из ИменаКолонок Цикл
			Если ТаблицаЗаписейФормы.Колонки.Найти(ИмяКолонки) <> Неопределено Тогда
				ТаблицаЗаписейФормы.Колонки.Удалить(ИмяКолонки);
			КонецЕсли; 
		КонецЦикла;
		
	КонецЕсли; 
	
	Если Метаданные.РегистрыСведений[ИмяРегистра].Измерения.Найти("НомерПоПорядку") <> Неопределено Тогда
		НомерПоПорядку = 1;
		Для каждого СтрокаТаблицаЗаписейФормы Из ТаблицаЗаписейФормы Цикл
			
			СтрокаТаблицаЗаписейФормы.НомерПоПорядку = НомерПоПорядку;
			НомерПоПорядку = НомерПоПорядку + 1;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаЗаписейБазыДанных = ТаблицаЗаписейРегистра(ИмяРегистра, Форма.ФизическоеЛицоСсылка);
	
	Если НЕ ОбщегоНазначения.КоллекцииИдентичны(ТаблицаЗаписейФормы, ТаблицаЗаписейБазыДанных) Тогда
		
		НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ФизическоеЛицо.Значение = Форма.ФизическоеЛицоСсылка;
		НаборЗаписей.Отбор.ФизическоеЛицо.Использование = Истина;
		
		НаборЗаписей.Загрузить(ТаблицаЗаписейФормы);
		
		НаборЗаписей.Записать();
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаЗаписейРегистра(ИмяРегистра, ФизическоеЛицоСсылка)
	
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ФизическоеЛицо.Значение = ФизическоеЛицоСсылка;
	НаборЗаписей.Отбор.ФизическоеЛицо.Использование = Истина;
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Выгрузить();
	
КонецФункции

Функция ТаблицаСовпаденийФизическихЛицПоИННСНИЛСДокументаУдостоверяющегоЛичность(ФизическоеЛицоСсылка, ИНН, СтраховойНомерПФР, ДокументВид, ДокументСерия, ДокументНомер)
	
	ТаблицаСовпадений = Новый ТаблицаЗначений;
	
	Запрос = Новый Запрос;
		
	ТекстЗапросаВТСовпадения = ""; 

	Если НЕ ПустаяСтрока(ТекстЗапросаВТСовпадения) Тогда
		
		Запрос.Текст = ТекстЗапросаВТСовпадения + "
		|;
		|
		|//////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТСовпадения.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТСовпадения.ФизическоеЛицо.ИНН КАК ИНН,
		|	ВТСовпадения.ФизическоеЛицо.СтраховойНомерПФР КАК СтраховойНомерПФР,
		|	ВТСовпадения.ФизическоеЛицо.ДатаРождения КАК ДатаРождения,
		|	ВТСовпадения.ФизическоеЛицо.Пол КАК Пол,
		|	ДокументыФизическихЛиц.ВидДокумента КАК ДокументВид,
		|	ДокументыФизическихЛиц.Серия КАК ДокументСерия,
		|	ДокументыФизическихЛиц.Номер КАК ДокументНомер,
		|	ДокументыФизическихЛиц.Представление КАК ДокументПредставление
		|ИЗ
		|	ВТСовпадения КАК ВТСовпадения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|		ПО ВТСовпадения.ФизическоеЛицо = ДокументыФизическихЛиц.Физлицо
		|			И (ДокументыФизическихЛиц.ВидДокумента = &ВидДокумента)
		|			И (ДокументыФизическихЛиц.Серия = &Серия)
		|			И (ДокументыФизическихЛиц.Номер = &Номер)";
		
		Запрос.УстановитьПараметр("ФизическоеЛицоСсылка", 	ФизическоеЛицоСсылка);
		Запрос.УстановитьПараметр("ВидДокумента", 			ДокументВид);
		Запрос.УстановитьПараметр("Серия", 					ДокументСерия);
		Запрос.УстановитьПараметр("Номер", 					ДокументНомер);
		
		УстановитьПривилегированныйРежим(Истина);
	
		ТаблицаСовпадений = Запрос.Выполнить().Выгрузить();;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Возврат ТаблицаСовпадений;
	
КонецФункции

Функция СостояниеИРолиСотрудника(СотрудникСсылка)
		
КонецФункции

Процедура ПроверитьУникальностьФизическогоЛицаВФорме(Форма, Отказ)
	
	Если Форма.ДокументыФизическихЛиц = Неопределено Тогда
		
	МенеджерЗаписиДокументыФизическихЛиц = СотрудникиФормыБазовый.МенеджерПоследнейЗаписиДокументовФизическихЛиц(Форма.ФизическоеЛицоСсылка);
		
	Форма.ДокументыФизическихЛиц = Новый ФиксированнаяСтруктура(
		ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписиДокументыФизическихЛиц, Метаданные.РегистрыСведений.ДокументыФизическихЛиц));
		
	КонецЕсли;
	
	РезультатПроверки = РезультатыПроверкиУникальностиФизическогоЛица(
							Форма.ФизическоеЛицоСсылка,
							"","","","", "");
		
	Если НЕ РезультатПроверки.ФизическоеЛицоУникально 
		И (Форма.Параметры.Ключ.Пустая()
			ИЛИ НЕ РезультатПроверки.ДоступнаРольСохранениеДанныхЗадвоенныхФизическихЛиц) Тогда
		
		Для каждого СообщениеПроверки Из РезультатПроверки.СообщенияПроверки Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПроверки.ТекстСообщенияОбОшибке, , СообщениеПроверки.ИмяПоля, СообщениеПроверки.ИмяОбъекта, Отказ);
		КонецЦикла;
		
		Если НЕ РезультатПроверки.ДоступнаРольСохранениеДанныхЗадвоенныхФизическихЛиц Тогда
			ТекстСообщения = НСтр("ru = 'Запись невозможна! Для разрешения конфликтов, обратитесь к администратору информационной системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		ИначеЕсли Форма.Параметры.Ключ.Пустая() Тогда
			ТекстСообщения = НСтр("ru = 'Запись данных нового человека невозможна!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьДанныеФизическиеЛиц(СтруктураВозврат, МассивФизическихЛиц)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка В(&МассивФизическихЛиц)";
	
	Запрос.УстановитьПараметр("МассивФизическихЛиц", МассивФизическихЛиц);
	
	МассивДоступныхФизическихЛиц = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
	Если МассивДоступныхФизическихЛиц.Количество() = МассивФизическихЛиц.Количество() Тогда
		
		СтруктураВозврат.Вставить("ДанныеФизическихЛицДоступны", Истина);
		
		ДанныеФизическихЛиц = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина, 
			МассивФизическихЛиц, 
			"ФИОПолные,ДатаРождения,ИНН,СтраховойНомерПФР,ДокументПредставление", 
			ТекущаяДатаСеанса());
		
		СтруктураВозврат.Вставить("ДанныеФизическихЛиц", ОбщегоНазначения.ТаблицаЗначенийВМассив(ДанныеФизическихЛиц));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти