#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.
Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если СтоимостьЧаса.Количество() = 0 Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена табличная часть стоимостей часа. Проведение невозможно!'"));
		Отказ = истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполненно значение поля ""Организация""!'"), СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Движения.торо_СтоимостьЧасаКвалификации.Записывать = Истина;
	Движения.торо_СтоимостьЧасаКвалификации.Очистить();
	Для Каждого ТекСтрокаСтоимость Из СтоимостьЧаса Цикл
		Движение = Движения.торо_СтоимостьЧасаКвалификации.Добавить();
		Движение.Период = Дата;
		Движение.Валюта = ТекСтрокаСтоимость.Валюта;
		Движение.Стоимость = ТекСтрокаСтоимость.СтоимостьНормочаса;
		Движение.Квалификация = ТекСтрокаСтоимость.Квалификация;
	КонецЦикла;


КонецПроцедуры
#КонецОбласти

#КонецЕсли