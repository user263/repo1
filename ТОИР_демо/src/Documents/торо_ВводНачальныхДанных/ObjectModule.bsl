
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

Перем мТаблицаОбъектовРемонта;
Перем ТаблицаИерархии;
Перем СписокПодчиненныхОбъектов;

Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ВидОперации = Перечисления.торо_ВидыДокументаВводНачДанных.ПоОбъектуРемонта Тогда
		Если ОбъектыРемонта.Количество() = 0 Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена табличная часть объектов ремонта. Проведение невозможно!'"));
			Отказ = истина;
			Возврат;
		КонецЕсли;
	Иначе
		Если СпискиОбъектовРемонта.Количество() = 0 Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена табличная часть списка объектов ремонта. Проведение невозможно!'"));
			Отказ = истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = Строка(Ссылка);
	
	Движения.торо_ЗавершенныеРемонтныеРаботы.Записывать = Истина;
	Для Каждого Работа Из ВыполненныеРаботы Цикл 
		Движение = Движения.торо_ЗавершенныеРемонтныеРаботы.Добавить();
		Движение.ВидРемонтныхРабот = Работа.ВидРемонтныхРабот;
		Движение.ОбъектРемонта = Работа.ОбъектРемонта;
		Движение.Период = Работа.ДатаОкончанияРемонта;
		Движение.ID = Новый УникальныйИдентификатор;
		Движение.ДатаОкончания = Работа.ДатаОкончанияРемонта;
	КонецЦикла;
	
	Движения.торо_НаработкаОбъектовРемонта.Записывать = Истина;
	Движения.торо_ПериодыНаработкиОР.Записывать = Истина;
	Для Каждого Наработка Из НаработкаОбъектыРемонта Цикл 
		Движение=Движения.торо_НаработкаОбъектовРемонта.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.ДатаКон = Наработка.ДатаРаботыПо;
		Движение.ДатаНач = Наработка.ДатаРаботыС;
		Движение.Наработка = Наработка.Значение;
		Движение.ОбъектРемонта = Наработка.ОбъектРемонта;
		Движение.Показатель = Наработка.Показатель;
		Движение.Период = Наработка.ДатаРаботыПо;
		
		Движение = Движения.торо_ПериодыНаработкиОР.Добавить();
		Движение.Период = Наработка.ДатаРаботыПо;
		Движение.ОбъектРемонта = Наработка.ОбъектРемонта;
		Движение.Показатель = Наработка.Показатель;
	КонецЦикла;
	
	Движения.торо_ЗначенияКонтролируемыхПоказателей.Записывать = Истина;
	Для Каждого Показатель Из ПоказателиОбъектыРемонта Цикл 
		Движение=Движения.торо_ЗначенияКонтролируемыхПоказателей.Добавить();
		Движение.ДатаКонтроля = Показатель.ДатаКонтроля;
		Движение.Значение = Показатель.Значение;
		Движение.ОбъектРемонта = Показатель.ОбъектРемонта;
		Движение.Показатель = Показатель.Показатель;
		Движение.Период = Дата;
	КонецЦикла;
	
	Движения.торо_ИсторияЗапчастейОбъектаРемонта.Записывать = Истина;
	Для каждого Запчасть из ЗапчастиОбъектаРемонта Цикл
		Движение=Движения.торо_ИсторияЗапчастейОбъектаРемонта.Добавить();
		Движение.Запчасть = Запчасть.Номенклатура;
		Движение.ОбъектРемонта = Запчасть.ОбъектРемонта;
		Движение.СерийныйНомер = Запчасть.СерийныйНомер;
		Движение.Период = Дата;
		Движение.Количество = ?(ЗначениеЗаполнено(Запчасть.Количество) И Не ЗначениеЗаполнено(Запчасть.СерийныйНомер) ,Запчасть.Количество,1);
		Движение.СтатусДвиженияЗЧ = Запчасть.СтатусДвиженияЗЧ;
		Движение.Установлена = Истина;
	КонецЦикла;
	
	Движения.торо_КоличествоПусковОР.Записывать = Истина;
	Для каждого Пуск из ПускиОР Цикл
		Движение=Движения.торо_КоличествоПусковОР.Добавить();
		Движение.ОбъектРемонта = Пуск.ОбъектРемонта;
		Движение.ВидПуска = Пуск.ВидПуска;
		Движение.Количество = Пуск.Количество;
		Движение.Период = Дата;
	КонецЦикла;
	
	Движения.торо_ТекущееСостояниеОР.Записывать = Истина;
	Движения.торо_ОстановленноеОборудование.Записывать = Истина;
	Движения.торо_ОборудованиеНаИспытаниях.Записывать = Истина;
	Для каждого ОбъектРемонта из мТаблицаОбъектовРемонта Цикл
		Если Не ОбъектРемонта.ОбъектРемонта.ЭтоГруппа Тогда
			Если ЗначениеЗаполнено(ОбъектРемонта.ТекущееСостояние) Тогда
				Движение=Движения.торо_ТекущееСостояниеОР.Добавить();
				Движение.ОбъектРемонта = ОбъектРемонта.ОбъектРемонта;
				Движение.ВидЭксплуатации = ОбъектРемонта.ТекущееСостояние;
				Движение.ПричинаПростоя = ОбъектРемонта.ПричинаПростоя;
				Движение.Период = ОбъектРемонта.ОбъектРемонта.ДатаВводаВЭксплуатацию;
				
				Если ОбъектРемонта.ТекущееСостояние.ТипЭксплуатации = Перечисления.торо_ТипЭксплуатации.Простой Тогда
					Движение=Движения.торо_ОстановленноеОборудование.Добавить();
					Движение.ОбъектРемонта 	= ОбъектРемонта.ОбъектРемонта;
					Движение.Количество 	= 1;
					Движение.Дата 			= ОбъектРемонта.ОбъектРемонта.ДатаВводаВЭксплуатацию;
					Движение.ПричинаПростоя = ОбъектРемонта.ПричинаПростоя;
					Движение.Период 		= ОбъектРемонта.ОбъектРемонта.ДатаВводаВЭксплуатацию;
					Движение.ВидДвижения	= ВидДвиженияНакопления.Приход;
				ИначеЕсли ОбъектРемонта.ТекущееСостояние.ТипЭксплуатации = Перечисления.торо_ТипЭксплуатации.Испытания Тогда
					Движение=Движения.торо_ОборудованиеНаИспытаниях.Добавить();
					Движение.ВидДвижения    = ВидДвиженияНакопления.Приход;
					Движение.ОбъектРемонта	= ОбъектРемонта.ОбъектРемонта;
					Движение.Период			= ОбъектРемонта.ОбъектРемонта.ДатаВводаВЭксплуатацию;
					Движение.Количество		= 1;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;		
	КонецЦикла;
	
	// регламентные мероприятия +
	Движения.торо_ЗавершенныеМероприятия.Записывать = Истина;
	Для Каждого Работа Из РегламентныеМероприятия Цикл 
		Движение = Движения.торо_ЗавершенныеМероприятия.Добавить();
		Движение.СписокОбъектов = Работа.СписокОбъектов;
		Движение.ВидМероприятия = Работа.ВидМероприятия;
		Движение.Период = Работа.ДатаПоследнегоМероприятия;
		Движение.ID = Новый УникальныйИдентификатор;
		Движение.ДатаОкончания = Работа.ДатаПоследнегоМероприятия;
	КонецЦикла;
	// регламентные мероприятия -
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ПолучитьТаблицуОбъектовРемонта();
				
		ПроверитьНаНаличиеДокументовМеняющихСостоянияОР(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПолучитьПодчиненныеОбъекты(ОбъектРемонта, Иерархия, ПолучатьТаблицуВходящих = Ложь)
	
	Если ПолучатьТаблицуВходящих Тогда
		
		ТаблицаИерархии.Очистить();
		
		СписокПодчиненныхОбъектов.Очистить();
		
		Запрос = Новый Запрос;
		
		Если Иерархия.ИзменяетсяДокументами Тогда
			
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	РасположениеОРВСтруктуреИерархии.ОбъектИерархии,
			|	РасположениеОРВСтруктуреИерархии.РодительИерархии
			|ИЗ
			|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(&Дата, СтруктураИерархии = &Иерархия) КАК РасположениеОРВСтруктуреИерархии
			|ГДЕ
			|	НЕ РасположениеОРВСтруктуреИерархии.Удален";
			
			Запрос.УстановитьПараметр("Дата", Дата);
			Запрос.УстановитьПараметр("Иерархия", Иерархия);
			
		Иначе
			
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии,
			|	торо_ИерархическиеСтруктурыОР.РодительИерархии
			|ИЗ
			|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
			|ГДЕ
			|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &Иерархия";

			Запрос.УстановитьПараметр("Иерархия", Иерархия);

		КонецЕсли;
		
		ТаблицаИерархии = Запрос.Выполнить().Выгрузить();
	КонецЕсли;	
	
	МассивСтрокОР = ТаблицаИерархии.НайтиСтроки(Новый Структура("РодительИерархии", ОбъектРемонта));
	
	Если МассивСтрокОР.Количество() Тогда
		
		Для Каждого ЭлементМассиваОР Из МассивСтрокОР Цикл
			ПолучитьПодчиненныеОбъекты(ЭлементМассиваОР.ОбъектИерархии, Иерархия);
			Если ТипЗнч(ЭлементМассиваОР.ОбъектИерархии) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
				СписокПодчиненныхОбъектов.Добавить(ЭлементМассиваОР.ОбъектИерархии);
			КонецЕсли;
		КонецЦикла;	
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьТаблицуОбъектовРемонта()
	
	мТаблицаОбъектовРемонта.Очистить();
	Для каждого ТекСтрока из ОбъектыРемонта Цикл
		
		СтруктураПоиска = Новый Структура();
		
		СтруктураПоиска.Вставить("ОбъектРемонта",			ТекСтрока.ОбъектРемонта);
		
		НайденныеСтроки = мТаблицаОбъектовРемонта.НайтиСтроки(СтруктураПоиска);
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			мТаблицаОбъектовРемонта.Удалить(НайденнаяСтрока);
		КонецЦикла;		
		
		Если НЕ ТекСтрока.ИзменятьСостояниеПодчиненныхОР Тогда
			НС = мТаблицаОбъектовРемонта.Добавить();
			ЗаполнитьЗначенияСвойств(НС , ТекСтрока);
			
		Иначе
						
			НС = мТаблицаОбъектовРемонта.Добавить();
			ЗаполнитьЗначенияСвойств(НС , ТекСтрока);
			
			ПолучитьПодчиненныеОбъекты(ТекСтрока.ОбъектРемонта, ТекСтрока.Иерархия, Истина);
			
			Для Каждого ЭлементСписка Из СписокПодчиненныхОбъектов Цикл
				
				    СтруктураПоиска = Новый Структура();
					
					СтруктураПоиска.Вставить("ОбъектРемонта",			ЭлементСписка.Значение);
					
					Если мТаблицаОбъектовРемонта.НайтиСтроки(СтруктураПоиска).Количество() Тогда
						Продолжить;
					КонецЕсли;	
					
					НС = мТаблицаОбъектовРемонта.Добавить();
					
					ЗаполнитьЗначенияСвойств(НС , ТекСтрока);
					НС.ОбъектРемонта		 	= ЭлементСписка.Значение;
					
			КонецЦикла;	
 				
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьНаНаличиеДокументовМеняющихСостоянияОР(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОбъектыРемонта.ОбъектРемонта,
	               |	ОбъектыРемонта.ТекущееСостояние
	               |ПОМЕСТИТЬ ОбъектыРемонта
	               |ИЗ
	               |	&ОбъектыРемонта КАК ОбъектыРемонта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Состояния.ОбъектРемонта,
	               |	Состояния.ТекущееСостояние
	               |ИЗ
	               |	ОбъектыРемонта КАК Состояния
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.торо_ТекущееСостояниеОР КАК торо_ТекущееСостояниеОР
	               |		ПО Состояния.ОбъектРемонта = торо_ТекущееСостояниеОР.ОбъектРемонта
	               |ГДЕ
	               |	торо_ТекущееСостояниеОР.Регистратор <> &Ссылка";
	Запрос.УстановитьПараметр("ОбъектыРемонта", мТаблицаОбъектовРемонта);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ТаблицаНеверныхСтрокТЧ = Запрос.Выполнить().Выгрузить();
	ТаблицаНеверныхСтрокТЧ.Свернуть("ОбъектРемонта, ТекущееСостояние");
	
	Если ТаблицаНеверныхСтрокТЧ.Количество() > 0 Тогда

		Для Каждого Строка Из ТаблицаНеверныхСтрокТЧ Цикл
			Если ЗначениеЗаполнено(Строка.ТекущееСостояние) Тогда
				торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Для объекта ремонта %1 уже имеются документы меняющие состояния объекта!'"),Строка.ОбъектРемонта));
				Отказ = Истина;
			КонецЕсли;
		КонецЦикла;
						
	КонецЕсли;
	
КонецПроцедуры

мТаблицаОбъектовРемонта = ОбъектыРемонта.ВыгрузитьКолонки();

ТаблицаИерархии = Новый ТаблицаЗначений;
СписокПодчиненныхОбъектов = Новый СписокЗначений;

#КонецОбласти

#КонецЕсли