#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ
Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Движения.торо_РасположениеОРВСтруктуреИерархии.Очистить();
	
	// регистр торо_РасположениеОРВСтруктуреИерархии
	Для Каждого ТекСтрокаПоложенияВСтруктуреИерархии Из ПоложенияВСтруктуреИерархии Цикл
		
		Если Не ТипЗнч(ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
			
			НоваяГруппаОР = Справочники.торо_ОбъектыРемонта.СоздатьГруппу();
			НоваяГруппаОР.Наименование = Строка(ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии);
			
			Попытка
				НоваяГруппаОР.Записать();
				
				СтрокаОбъектИерархии = ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии;
				
				ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии = НоваяГруппаОР.Ссылка;
				
				МассивСтрокСЭтимРодителем = ПоложенияВСтруктуреИерархии.НайтиСтроки(Новый Структура("РодительИерархии", СтрокаОбъектИерархии));
				
				Для каждого СтрокаПоложения Из МассивСтрокСЭтимРодителем Цикл
					СтрокаПоложения.РодительИерархии = ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии;
				КонецЦикла; 
				
			Исключение
				Сообщение = Новый СообщениеПользователю;
				ТекстСообщения = НСтр("ru = 'Не удалось создать группу объектов ремонта ""%ОбъектИерархии%""'");
				Сообщение.Текст = СтрЗаменить(ТекстСообщения, "%ОбъектИерархии%", ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии);
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецПопытки;
			
		КонецЕсли; 
		
		
		Движение = Движения.торо_РасположениеОРВСтруктуреИерархии.Добавить();
		Движение.Период = Дата;
		Движение.ОбъектИерархии = ТекСтрокаПоложенияВСтруктуреИерархии.ОбъектИерархии;
		Движение.СтруктураИерархии = СтруктураИерархии;
		Движение.РодительИерархии = ТекСтрокаПоложенияВСтруктуреИерархии.РодительИерархии;
		Движение.Удален = ТекСтрокаПоложенияВСтруктуреИерархии.Удален;
	КонецЦикла;

КонецПроцедуры
#КонецОбласти

#КонецЕсли