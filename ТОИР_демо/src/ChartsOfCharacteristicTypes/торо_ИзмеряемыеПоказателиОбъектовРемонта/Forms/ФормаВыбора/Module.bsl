#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		Если Параметры.КлючНазначенияИспользования = "УчетКонтролируемыхПоказателей" И Параметры.Свойство("СписокОтбора") Тогда
			
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));										 
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
			ЭлементОтбора.ПравоеЗначение = Параметры.СписокОтбора;
			ЭлементОтбора.Использование = Истина;
			
			// СТ>>>
		ИначеЕсли Параметры.КлючНазначенияИспользования = "ОбъектыРемонта" И Параметры.Свойство("СписокОтбора") Тогда
			
			ЭлементОтбора = Список.Отбор.Элементы.Добавить( Тип("ЭлементОтбораКомпоновкиДанных"));										 
			ЭлементОтбора.ВидСравнения = ?(Параметры.Свойство("ВидСравнения"), Параметры.ВидСравнения, ВидСравненияКомпоновкиДанных.НеВСписке);
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
			ЭлементОтбора.ПравоеЗначение = Параметры.СписокОтбора;
			ЭлементОтбора.Использование = Истина;

		// СТ<<
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти