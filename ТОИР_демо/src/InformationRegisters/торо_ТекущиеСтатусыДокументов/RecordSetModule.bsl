
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Запись из ЭтотОбъект Цикл 
		СтарыйСтатус = торо_Согласования.ПолучитьТекущийСтатусСогласованияДокумента(Запись.Документ);
		ИзмененСтатус = СтарыйСтатус <> Запись.СтатусДокумента;
		
		Если ИзмененСтатус Тогда
			СтруктураДанных = Новый Структура;
			СтруктураДанных.Вставить("ПредыдущийСтатусДокумента", СтарыйСтатус);
			СтруктураДанных.Вставить("СтатусДокумента", Запись.СтатусДокумента);
			СтруктураДанных.Вставить("ИспользоватьСогласование", Истина);
			торо_РаботаСУведомлениями.ЗаполнитьСтруктуруДанныхДокумента(СтруктураДанных, Запись.Документ);
			СтруктураДанных.Вставить("ВидДокумента",СокрЛП(Запись.Документ.Метаданные().Имя));
			торо_РаботаСУведомлениями.ЗаписатьНеобходимыеУведомленияВРегистры(СтруктураДанных, Запись.Документ, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
