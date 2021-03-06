
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ВосстановитьПоставляемуюМодельПоказателей(Команда)
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВосстановитьПоставляемуюМодельПоказателейЗавершение", ЭтаФорма), 
		НСтр("ru= 'Настройки поставляемых показателей KPI и вариантов анализа будут сброшены.
		|Продолжить с потерей настроек поставляемой модели показателей?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте 
Процедура ВосстановитьПоставляемуюМодельПоказателейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		ВосстановитьПоставляемуюМодельПоказателейНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста 
Процедура ВосстановитьПоставляемуюМодельПоказателейНаСервере()
	торо_ПоказателиKPI.ВосстановитьПоставляемуюМодельПоказателей();
КонецПроцедуры

#КонецОбласти