#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	// СтандартныеПодсистемы.Свойства
	Если НЕ ЭтоГруппа Тогда
		УправлениеСвойствами.ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_торо_ОбъектыРемонта", "НаборСвойств"); 
	КонецЕсли;		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения <> Неопределено Тогда
		Если ДанныеЗаполнения.Свойство("Основание") Тогда ТиповойОР = ДанныеЗаполнения.Основание; КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Направление") Тогда Направление = ДанныеЗаполнения.Направление; КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Изготовитель") Тогда Изготовитель = ДанныеЗаполнения.Изготовитель; КонецЕсли;
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("торо_ИспользоватьДокументыПринятияИСписанияОборудования") И НЕ ЭтоГруппа Тогда
		ЗначениеПеречисления = Перечисления.торо_СтатусыОРВУчете.НеПринятоКУчету;
		Структура = РегистрыСведений.торо_НастройкиДоступностиОбъектовРемонта.Получить(Новый Структура("СтатусОРВУчете",ЗначениеПеречисления));
		
		Если Не Структура = Неопределено Тогда
			НеУчаствуетВПланировании = Структура.ЗначениеПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НеПроверяемыеРеквизиты = Новый Массив;
	
	Если не ЭтоГруппа Тогда
		Если ВнешнийОбъект Тогда
			НеПроверяемыеРеквизиты.Добавить("Организация");
		Иначе 
			НеПроверяемыеРеквизиты.Добавить("Контрагент");
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НеПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли