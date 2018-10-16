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
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт

	ПользовательскиеНастройкиЭлементы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;	
	ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы);
	
КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПользовательскиеНастройкиЭлементы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;	
	ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы);
	
КонецПроцедуры

Процедура ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы)
	
	Для каждого Элемент Из ПользовательскиеНастройкиЭлементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если (Строка(Элемент.Параметр) = "УчитыватьПланГрафикиППР"
				И Не ПолучитьЗначениеФО("торо_ИспользоватьППР"))Тогда
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьРегламентныеМероприятия"
				И Не ПолучитьЗначениеФО("торо_ИспользоватьРегламентныеМероприятия")) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьСметыПоДефектам"
				И (Не ПолучитьЗначениеФО("торо_УчетВыявленныхДефектовОборудования")
				ИЛИ Не ПолучитьЗначениеФО("торо_ИспользоватьСметыРемонта")) ) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьСметыПоВнешнимОснованиям"
				И (Не ПолучитьЗначениеФО("торо_ИспользоватьВнешниеОснованияДляРабот")
				ИЛИ Не ПолучитьЗначениеФО("торо_ИспользоватьСметыРемонта")) ) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь; 
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
	Если Найти(Форма.ИмяФормы,"НастройкиОтчета") > 0  Тогда
		
		ЭлементыФормы = Форма.Элементы;
		ЭлементГруппаГлавное = ЭлементыФормы.Найти("ОбычныеОтборы");
		Если Не ЭлементГруппаГлавное = Неопределено Тогда
			ЭлементГруппаГлавное.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры

Функция ПолучитьЗначениеФО(ТекущаяОпция) Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию(ТекущаяОпция);
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	ИспользоватьОтборПоПериоду = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодВыполнения")).ИдентификаторПользовательскойНастройки).Использование;
	Если ИспользоватьОтборПоПериоду Тогда
		ПареметрДатаНачала = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНачала"));
		ПареметрДатаНачала.Использование = Истина;
		ПараметрДатаОкончания = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОкончания"));
		ПараметрДатаОкончания.Использование = Истина;
	Иначе
		ПареметрДатаНачала = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНачала"));
		ПареметрДатаНачала.Использование = Ложь;
		ПараметрДатаОкончания = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОкончания"));
		ПараметрДатаОкончания.Использование = Ложь;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Результат, КлючСхемы, КлючВарианта, НастройкиКД, ПользовательскиеНастройкиКД) Экспорт
	
	Если НастройкиКД = Неопределено Тогда Возврат; КонецЕсли;
	Если ПользовательскиеНастройкиКД = Неопределено Тогда Возврат; КонецЕсли;
	
	Элем = НастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидДокумента")).ИдентификаторПользовательскойНастройки;
	НайЭл = ПользовательскиеНастройкиКД.Элементы.Найти(элем);
	Если НайЭл = Неопределено Тогда Возврат; КонецЕсли; 
	
	нИспользование = НайЭл.Использование; 
	нВидДокумента = ?(нИспользование, ПользовательскиеНастройкиКД.Элементы.Найти(элем).Значение, Ложь);
	
	Для каждого текНастройка из НастройкиКД.Структура Цикл
		Если ТипЗнч(текНастройка) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Для каждого ТекКолонка из текНастройка.Колонки Цикл
				Если ТекКолонка.имя = "ВидДокумента" Тогда
					ТекКолонка.Использование = нВидДокумента;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли