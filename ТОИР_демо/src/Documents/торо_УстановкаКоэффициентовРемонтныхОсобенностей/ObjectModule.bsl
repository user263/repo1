#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.
Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если КоэффициентыРемонтныхОсобенностей.Количество() = 0 Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена табличная часть коэффициентов ремонтных особенностей. Проведение невозможно!'"));
		Отказ = истина;
		Возврат;
	КонецЕсли;	
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = Строка(Ссылка);
	
	Если НЕ Константы.торо_ИспользоватьКоэффициентыРемонтныхОсобенностей.Получить() Тогда
		Отказ = Истина;
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Проведение невозможно. Отключена настройка ""Использовать коэффициенты ремонтных особенностей"" (Настройка и администрирование -> Панель администрирования ТОиР).'"));
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	         |	торо_УстановкаКоэффициентовРемонтныхОсобенностейКоэффициентыРемонтныхОсобенностей.ВидКоэффициента КАК ВидКоэффициента,
	         |	торо_УстановкаКоэффициентовРемонтныхОсобенностейКоэффициентыРемонтныхОсобенностей.ОбъектРемонта КАК ОбъектРемонта,
	         |	НАЧАЛОПЕРИОДА(торо_УстановкаКоэффициентовРемонтныхОсобенностейКоэффициентыРемонтныхОсобенностей.ДатаНачалаИспользования, ДЕНЬ) КАК Период
	         |ПОМЕСТИТЬ ДокТЧ
	         |ИЗ
	         |	Документ.торо_УстановкаКоэффициентовРемонтныхОсобенностей.КоэффициентыРемонтныхОсобенностей КАК торо_УстановкаКоэффициентовРемонтныхОсобенностейКоэффициентыРемонтныхОсобенностей
	         |ГДЕ
	         |	торо_УстановкаКоэффициентовРемонтныхОсобенностейКоэффициентыРемонтныхОсобенностей.Ссылка = &Ссылка
	         |
	         |ИНДЕКСИРОВАТЬ ПО
	         |	ОбъектРемонта,
	         |	ВидКоэффициента,
	         |	Период
	         |;
	         |
	         |////////////////////////////////////////////////////////////////////////////////
	         |ВЫБРАТЬ
	         |	НАЧАЛОПЕРИОДА(торо_ЗначенияКоэффициентовРемонтныхОсобенностей.Период, ДЕНЬ) КАК Период,
	         |	торо_ЗначенияКоэффициентовРемонтныхОсобенностей.ВидКоэффициента КАК ВидКоэффициента,
	         |	торо_ЗначенияКоэффициентовРемонтныхОсобенностей.ОбъектРемонта КАК ОбъектРемонта
	         |ПОМЕСТИТЬ Регистр
	         |ИЗ
	         |	РегистрСведений.торо_ЗначенияКоэффициентовРемонтныхОсобенностей КАК торо_ЗначенияКоэффициентовРемонтныхОсобенностей
	         |ГДЕ
	         |	торо_ЗначенияКоэффициентовРемонтныхОсобенностей.Регистратор <> &Ссылка
	         |
	         |ИНДЕКСИРОВАТЬ ПО
	         |	ОбъектРемонта,
	         |	ВидКоэффициента,
	         |	Период
	         |;
	         |
	         |////////////////////////////////////////////////////////////////////////////////
	         |ВЫБРАТЬ
	         |	ДокТЧ.ОбъектРемонта,
	         |	ДокТЧ.ВидКоэффициента,
	         |	ДокТЧ.Период
	         |ИЗ
	         |	ДокТЧ КАК ДокТЧ
	         |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Регистр КАК Регистр
	         |		ПО ДокТЧ.ОбъектРемонта = Регистр.ОбъектРемонта
	         |			И ДокТЧ.ВидКоэффициента = Регистр.ВидКоэффициента
	         |			И ДокТЧ.Период = Регистр.Период";
			 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	резЗапроса = Запрос.Выполнить();
	Если Не резЗапроса.Пустой() Тогда
		
		Выборка = резЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщение = новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для объекта ремонта ""%1"" на дату ""%2"" уже определен вид коэффициента ""%3"".'"),
				Выборка.ОбъектРемонта, Формат(Выборка.Период, "ДФ=dd.MM.yyyy"), Выборка.ВидКоэффициента);
			Сообщение.Сообщить();
		КонецЦикла;
		
		отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Для Каждого ТекСтрокаТЧ Из КоэффициентыРемонтныхОсобенностей Цикл
			
			Движение = Движения.торо_ЗначенияКоэффициентовРемонтныхОсобенностей.Добавить();
			
			Движение.Период = ТекСтрокаТЧ.ДатаНачалаИспользования;
			Движение.ОбъектРемонта = ТекСтрокаТЧ.ОбъектРемонта;
			Движение.ВидКоэффициента = ТекСтрокаТЧ.ВидКоэффициента;
			Движение.ЗначениеКоэффициента = ТекСтрокаТЧ.ЗначениеКоэффициента;
			Движение.Использование = ТекСтрокаТЧ.Использование;
		КонецЦикла;
		
		Для Каждого ТекСтрокаТЧ Из КоэффициентыРемонтныхОсобенностейПодчиненных Цикл
			
			Движение = Движения.торо_ЗначенияКоэффициентовРемонтныхОсобенностей.Добавить();
			
			Движение.Период = ТекСтрокаТЧ.ДатаНачалаИспользования;
			Движение.ОбъектРемонта = ТекСтрокаТЧ.ОбъектРемонта;
			Движение.ВидКоэффициента = ТекСтрокаТЧ.ВидКоэффициента;
			Движение.ЗначениеКоэффициента = ТекСтрокаТЧ.ЗначениеКоэффициента;
			Движение.Использование = ТекСтрокаТЧ.Использование;
		КонецЦикла;
		
		Движения.торо_ЗначенияКоэффициентовРемонтныхОсобенностей.Записать();
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли