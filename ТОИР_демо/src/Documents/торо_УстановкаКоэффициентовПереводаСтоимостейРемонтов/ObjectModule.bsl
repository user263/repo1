#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.
Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если ВидОперации = Перечисления.торо_ВидыДокументаВводНачДанных.ПоОбъектуРемонта Тогда
		Если КоэффициентыПеревода.Количество() = 0 Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена ни одна табличная часть. Проведение невозможно!'"));
			Отказ = истина;
			Возврат;
		КонецЕсли;
	Иначе
		Если КоэффициентыПереводаСписковОбъектов.Количество() = 0 Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена ни одна табличная часть. Проведение невозможно!'"));
			Отказ = истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполненно значение поля ""Организация""!'"), СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	
	Если ВидОперации = Перечисления.торо_ВидыДокументаВводНачДанных.ПоОбъектуРемонта Тогда
		
		// регистр торо_КоэффициентыПереводаБазовыхЦенВТекущие
		Движения.торо_КоэффициентыПереводаБазовыхЦенВТекущие.Записывать = Истина;
		Движения.торо_КоэффициентыПереводаБазовыхЦенВТекущие.Очистить();
		
		Для Каждого ТекСтрокаКоэффициентыПеревода Из КоэффициентыПеревода Цикл
			Движение = Движения.торо_КоэффициентыПереводаБазовыхЦенВТекущие.Добавить();
			Движение.Период = Дата;
			Движение.Организация = ТекСтрокаКоэффициентыПеревода.Организация;
			Движение.Подразделение = ТекСтрокаКоэффициентыПеревода.Подразделение;
			Движение.Направления = ТекСтрокаКоэффициентыПеревода.Направления;
			Движение.ОбъектРемонта = ТекСтрокаКоэффициентыПеревода.ОбъектРемонта;
			Движение.КлассификаторРемонтов = ТекСтрокаКоэффициентыПеревода.КлассификаторРемонтов;
			Движение.Коэффициент = ТекСтрокаКоэффициентыПеревода.Коэффициент;
			Движение.ПоказательКоэффициента = ТекСтрокаКоэффициентыПеревода.ПоказательКоэффициента;
		КонецЦикла;
	Иначе 
		
		// регистр торо_КоэффициентыПереводаБазовыхЦенВТекущие
		Движения.торо_КоэффициентыПереводаБазовыхЦенВТекущиеРегл.Записывать = Истина;
		Движения.торо_КоэффициентыПереводаБазовыхЦенВТекущиеРегл.Очистить();

		Для Каждого ТекСтрокаКоэффициентыПеревода Из КоэффициентыПереводаСписковОбъектов Цикл
			Движение = Движения.торо_КоэффициентыПереводаБазовыхЦенВТекущиеРегл.Добавить();
			Движение.Период = Дата;
			Движение.СписокОбъектов = ТекСтрокаКоэффициентыПеревода.СписокОбъектов;
			Движение.КлассификаторРемонтов = ТекСтрокаКоэффициентыПеревода.КлассификаторРемонтов;
			Движение.Коэффициент = ТекСтрокаКоэффициентыПеревода.Коэффициент;
			Движение.ПоказательКоэффициента = ТекСтрокаКоэффициентыПеревода.ПоказательКоэффициента;
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли