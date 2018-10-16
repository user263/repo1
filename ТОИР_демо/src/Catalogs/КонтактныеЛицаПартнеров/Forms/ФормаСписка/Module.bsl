
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокСправочника" 
		И Параметр.Свойство("Отбор") И Параметр.Отбор.Свойство("Владелец")
		И ТипЗнч(Параметр.Отбор.Владелец) = Тип("СправочникСсылка.Партнеры") Тогда
		
			ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
				ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список), "Владелец");
			Если ЭлементыОтбора.Количество() > 0 
				И ЭлементыОтбора[0].ПравоеЗначение = Параметр.Отбор.Владелец Тогда
					Возврат;
			КонецЕсли;
		
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец",
			                         Параметр.Отбор.Владелец, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы


#КонецОбласти

