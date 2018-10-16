#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

Перем ИспользоватьРегламентныеМероприятия;
Перем ИспользоватьППР;                    
Перем ИспользоватьДефекты;               
Перем ИспользоватьВнешниеОснования;       
Перем ИспользоватьСметы;                  

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
			Если (Строка(Элемент.Параметр) = "УчитыватьППР"
				И Не ИспользоватьППР)Тогда
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьРегламентныеМероприятия"
				И Не ИспользоватьРегламентныеМероприятия) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьСметыПоДефектам"
				И Не ИспользоватьДефекты
				И Не ИспользоватьСметы ) Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				Продолжить;
			ИначеЕсли (Строка(Элемент.Параметр) = "УчитыватьСметыПоВнешнимОснованиям"
				И Не ИспользоватьВнешниеОснования
				И Не ИспользоватьСметы ) Тогда 
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

Функция ПолучитьЗначениеФО(НаименованиеФО) Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию(НаименованиеФО);
	
КонецФункции

ИспользоватьРегламентныеМероприятия = ПолучитьЗначениеФО("торо_ИспользоватьРегламентныеМероприятия");
ИспользоватьППР                     = ПолучитьЗначениеФО("торо_ИспользоватьППР");
ИспользоватьДефекты                 = ПолучитьЗначениеФО("торо_УчетВыявленныхДефектовОборудования");
ИспользоватьВнешниеОснования        = ПолучитьЗначениеФО("торо_ИспользоватьВнешниеОснованияДляРабот");
ИспользоватьСметы                   = ПолучитьЗначениеФО("торо_ИспользоватьСметыРемонта");


#КонецОбласти

#КонецЕсли