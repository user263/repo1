
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа Тогда
		
		Если ВариантЗаполнения = Перечисления.торо_ВариантыЗаполненияПоказателяKPI.Формула Тогда
			ПроверяемыеРеквизиты.Добавить("ТекстФормулы");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИдентификаторДляФормул) Тогда
			ЗапрещенныеСимволы = торо_ПоказателиKPIКлиентСервер.ПолучитьЗапрещенныеСимволыДляФормул();
			
			Для каждого ЗапрещенныйСимвол из ЗапрещенныеСимволы Цикл
				Если СтрНайти(ИдентификаторДляФормул, ЗапрещенныйСимвол) > 0 Тогда
					ТекстСообщения = НСтр("ru='Представление для формул не может содержать пробелы и специальные символы, кроме подчеркивания.'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ИдентификаторДляФормул",,Отказ);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИДПоставляемойМодели = "";
	
КонецПроцедуры

#КонецОбласти