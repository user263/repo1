#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
//
// Параметры:
// КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
	
КонецПроцедуры

Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
	
	Реквизиты.Добавить("ИзМобильного");
		
КонецПроцедуры


#КонецОбласти