#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокВариантов.ЗагрузитьЗначения(Параметры.СписокЗначений.ВыгрузитьЗначения());
	Если Параметры.Свойство("ОбъектНастройки") Тогда
	    ОбъектНастройки = Параметры.ОбъектНастройки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(СписокВариантов);
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("ТочноНеЗакрыватьПриВыборе", Истина);
	
	ФормаВыбора = ПолучитьФорму("Справочник." + ОбъектНастройки + ".ФормаВыбора", ПараметрыФормы, Элементы.СписокВариантов);

	ФормаВыбора.Открыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВариантовЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ФормаВыбора = ПолучитьФорму("Справочник." + ОбъектНастройки + ".ФормаВыбора", ПараметрыФормы, Элемент);
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВариантовЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) И СписокВариантов.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данное значение уже добавлено.");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВариантовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) И СписокВариантов.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данное значение уже добавлено.");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
