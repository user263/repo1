
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтруктуруДанныхДоРедактирования(СтруктураДанных,МассивТаблиц) Экспорт
	
	СтруктураДанных = Новый Структура;
	Для Каждого ИмяТаблицы Из МассивТаблиц Цикл
		СтруктураДанных.Вставить(ИмяТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриНачалеРедактирования(ТаблицаФормы,СтруктураДанныхДоРедактирования,ДанныеСтроки) Экспорт
	
	СтруктураКолонок = Новый Структура;
	ДлинаИмениТаблицы = СтрДлина(ТаблицаФормы.Имя)+1;
	ЗаполнитьСтруктуруДанныхСтроки(ТаблицаФормы.ПодчиненныеЭлементы,СтруктураКолонок,ДанныеСтроки,ДлинаИмениТаблицы);
	СтруктураДанныхДоРедактирования.Вставить(ТаблицаФормы.Имя,СтруктураКолонок);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруДанныхСтроки(ПодчиненныеЭлементы,СтруктураКолонок,ДанныеСтроки,ДлинаИмениТаблицы)
	
	Для Каждого Колонка Из ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Колонка) = Тип("ГруппаФормы") Тогда
			ЗаполнитьСтруктуруДанныхСтроки(Колонка.ПодчиненныеЭлементы,СтруктураКолонок,ДанныеСтроки,ДлинаИмениТаблицы);
			Продолжить;
		КонецЕсли;
		ИмяКолонки = Сред(Колонка.Имя,ДлинаИмениТаблицы);
		СтруктураКолонок.Вставить(ИмяКолонки,ДанныеСтроки[ИмяКолонки]);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
