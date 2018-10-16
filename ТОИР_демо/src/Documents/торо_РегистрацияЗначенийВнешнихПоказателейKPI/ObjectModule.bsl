
#Область ОбработчикиСобытий

перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиТОиР", "ОсновнойОтветственный");
	Если НЕ ЗначениеЗаполнено(Ответственный) тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонСообщения = НСтр("ru='Не заполнена колонка ""%2"" в строке %1 списка ""Значения показателей""'");
	
	Для каждого СтрокаЗначения из ЗначенияПоказателей Цикл
		ОбязательноПодразделение = Ложь;
		ОбязательноОР = Ложь;
		Если СтрокаЗначения.Показатель.ТипПоказателя = Перечисления.торо_ТипыПоказателейKPI.ПоказательОбъектаРемонта Тогда
			ОбязательноПодразделение = Истина;
			ОбязательноОР = Истина;
		ИначеЕсли СтрокаЗначения.Показатель.ТипПоказателя = Перечисления.торо_ТипыПоказателейKPI.ПоказательПодразделения Тогда
			ОбязательноПодразделение = Истина;
		КонецЕсли;
		
		ИндексСтроки = СтрокаЗначения.НомерСтроки - 1;
		Если ОбязательноПодразделение И НЕ ЗначениеЗаполнено(СтрокаЗначения.Подразделение) Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщения, СтрокаЗначения.НомерСтроки, НСтр("ru='Подразделение'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ЗначенияПоказателей["+ИндексСтроки+"].Подразделение",,Отказ);
		КонецЕсли;
		Если ОбязательноОР И НЕ ЗначениеЗаполнено(СтрокаЗначения.ОбъектРемонта) Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщения, СтрокаЗначения.НомерСтроки, НСтр("ru='Объект ремонта'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ЗначенияПоказателей["+ИндексСтроки+"].ОбъектРемонта",,Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр торо_ЗначенияВнешнихПоказателейKPI
	Движения.торо_ЗначенияВнешнихПоказателейKPI.Записывать = Истина;
	Движения.торо_ЗначенияВнешнихПоказателейKPI.Очистить();
	Для Каждого ТекСтрокаЗначенияПоказателей Из ЗначенияПоказателей Цикл
		Движение = Движения.торо_ЗначенияВнешнихПоказателейKPI.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Организация = Организация;
		ЗаполнитьЗначенияСвойств(Движение, ТекСтрокаЗначенияПоказателей);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти