#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Открытие = Истина;
	
	Для каждого ЭлемСписка ИЗ СписокИерархий Цикл
		Если ЭлемСписка.Пометка Тогда
			Элементы.СписокИерархий.ТекущаяСтрока = СписокИерархий.Индекс(ЭлемСписка);
			ЭлемСписка.Картинка = БиблиотекаКартинок.торо_ЗначениеВыбрано;
		Иначе
			ЭлемСписка.Картинка = БиблиотекаКартинок.торо_ЗначениеНеВыбрано;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("СписокИерархийОР")
		И ЗначениеЗаполнено(Параметры.СписокИерархийОР)Тогда
		СписокИерархий = Параметры.СписокИерархийОР;
		ЗаполнитьПараметрыИерархий(СписокИерархий);
		Если Параметры.Свойство("ТекСтруктураИерархии") Тогда
			ТекИерархия = СписокИерархий.НайтиПоЗначению(Параметры.ТекСтруктураИерархии);
			Если ТекИерархия = Неопределено Тогда
				СписокИерархий[0].Пометка = Истина;
			Иначе
				ТекИерархия.Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура СписокИерархийПриАктивизацииСтроки(Элемент)
	
	Если Открытие Тогда
		
		Открытие = Ложь;
		
		Для Каждого ЭлементСписка Из СписокИерархий Цикл 	
			Если ЭлементСписка.Пометка Тогда
				Элементы.СписокИерархий.ТекущаяСтрока = СписокИерархий.Индекс(ЭлементСписка);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		ТекДанные = Элемент.ТекущиеДанные;
	
		Для Каждого ЭлементСписка Из СписокИерархий Цикл 	
			ЭлементСписка.Пометка = (ЭлементСписка.Значение = ТекДанные.Значение);
			Если ЭлементСписка.Пометка Тогда
				ЭлементСписка.Картинка = БиблиотекаКартинок.торо_ЗначениеВыбрано;
			Иначе
				ЭлементСписка.Картинка = БиблиотекаКартинок.торо_ЗначениеНеВыбрано;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;		
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ОК(Команда)
	
	Перем ЗначениеИерархии;
	
	Для каждого ЭлементСписка Из СписокИерархий Цикл
		
		Если ЭлементСписка.Пометка Тогда
			ЗначениеИерархии = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура("СтруктураИерархии,ИзменяетсяДокументами,РазрешенВводНовыхОР,СтроитсяАвтоматически,РеквизитОР,ТипРеквизитаОР,ИерархическийСправочник");
	ЗаполнитьЗначенияСвойств(СтруктураВозврата,ПараметрыИерархий.НайтиСтроки(Новый Структура("СтруктураИерархии",ЗначениеИерархии))[0]);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьПараметрыИерархий(СписокИерархий)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	торо_СтруктурыОР.Ссылка КАК СтруктураИерархии,
	               |	торо_СтруктурыОР.ИзменяетсяДокументами,
	               |	торо_СтруктурыОР.РазрешенВводНовыхОР,
	               |	торо_СтруктурыОР.СтроитсяАвтоматически,
				   |	торо_СтруктурыОР.РеквизитОР,
				   |	торо_СтруктурыОР.ТипРеквизитаОР
	               |ИЗ
	               |	Справочник.торо_СтруктурыОР КАК торо_СтруктурыОР
	               |ГДЕ
	               |	торо_СтруктурыОР.Ссылка В(&СписокИерархий)";
	Запрос.УстановитьПараметр("СписокИерархий",СписокИерархий);
	Результат = Запрос.Выполнить();
	ПараметрыИерархий.Загрузить(Запрос.Выполнить().Выгрузить());
	Для Каждого Иерархия Из ПараметрыИерархий Цикл
		Если Иерархия.СтроитсяАвтоматически И Иерархия.ТипРеквизитаОР <> "" Тогда
			Иерархия.ИерархическийСправочник = Метаданные.Справочники[Иерархия.ТипРеквизитаОР].Иерархический;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти