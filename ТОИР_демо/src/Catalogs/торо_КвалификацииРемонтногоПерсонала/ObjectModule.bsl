
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Найти(Наименование, "№") Тогда
		ТекстСообщения = НСтр("ru = 'В наименовании квалификации запрещено использовать символ ""№"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.Наименование",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти