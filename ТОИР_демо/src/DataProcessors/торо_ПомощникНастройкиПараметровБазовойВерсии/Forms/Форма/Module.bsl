
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Отказ = Истина;
	торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru= 'Помощник настройки базовой версии предназначен только для первоначального заполнения информационной базы при первом запуске.'"));
	Возврат;
КонецПроцедуры

#КонецОбласти