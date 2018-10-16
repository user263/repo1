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
				И Не ПолучитьЗначениеФО("торо_УчетВыявленныхДефектовОборудования")) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьСметыПоВнешнимОснованиям"
				И Не ПолучитьЗначениеФО("торо_ИспользоватьВнешниеОснованияДляРабот")) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь; 
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
КонецПроцедуры

Функция ПолучитьЗначениеФО(ТекущаяОпция) Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию(ТекущаяОпция);
	
КонецФункции

#КонецОбласти

#КонецЕсли