////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ".
// Клиентские процедуры и функции для интерактивного обновления информационной базы.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Только для внутреннего использования. Продолжение процедуры ПередНачаломРаботыПрограммы.
Процедура ПроверитьСтатусОбработчиковОтложенногоОбновления(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("НеобходимоВыполнитьОбработчикиОтложенногоОбновления") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ИнтерактивнаяОбработкаПроверкиСтатусаОтложенногоОбновления",
			ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из модуля СтандартныеПодсистемыКлиент в блоке ПередНачаломРаботыСистемы.
//
// Параметры:
//   Параметры - Структура - См. описание первого параметра
//       функции ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОбновлениеИнформационнойБазы().
//
Процедура ОбновитьИнформационнуюБазу(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("НеобходимоОбновлениеИнформационнойБазы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"НачатьОбновлениеИнформационнойБазы", ЭтотОбъект);
	Иначе
		Если ПараметрыРаботыКлиента.Свойство("ЗагрузитьСообщениеОбменаДанными") Тогда
			Перезапустить = Ложь;
			ОбновлениеИнформационнойБазыСлужебныйВызовСервера.ВыполнитьОбновлениеИнформационнойБазы(Истина, Перезапустить);
			Если Перезапустить Тогда
				Параметры.Отказ = Истина;
				Параметры.Перезапустить = Истина;
			КонецЕсли;
		КонецЕсли;
		ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед интерактивным началом работы пользователя с областью данных.
// Соответствует событию ПередНачаломРаботыСистемы модулей приложения.
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыКлиента.РазделениеВключено Или Не ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		ОбновлениеИнформационнойБазыКлиентПереопределяемый.ПриОпределенииВозможностиОбновления(ПараметрыКлиента.ВерсияДанныхОсновнойКонфигурации);
	КонецЕсли;
	
	Если ПараметрыКлиента.Свойство("ИнформационнаяБазаЗаблокированаДляОбновления") Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить("Перезапустить", НСтр("ru = 'Перезапустить'"));
		Кнопки.Добавить("Завершить",     НСтр("ru = 'Завершить работу'"));
		
		ПараметрыВопроса = Новый Структура;
		ПараметрыВопроса.Вставить("КнопкаПоУмолчанию", "Перезапустить");
		ПараметрыВопроса.Вставить("КнопкаТаймаута",    "Перезапустить");
		ПараметрыВопроса.Вставить("Таймаут",           60);
		
		ОписаниеПредупреждения = Новый Структура;
		ОписаниеПредупреждения.Вставить("Кнопки",           Кнопки);
		ОписаниеПредупреждения.Вставить("ПараметрыВопроса", ПараметрыВопроса);
		ОписаниеПредупреждения.Вставить("ТекстПредупреждения",
			ПараметрыКлиента.ИнформационнаяБазаЗаблокированаДляОбновления);
		
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент.ЭтотОбъект,
			ОписаниеПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму отложенных обработчиков.
//
Процедура ПоказатьОтложенныеОбработчики() Экспорт
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенныеОбработчики");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для процедуры ОбновитьИнформационнуюБазу.
Процедура ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры)
	
	Если Параметры.Свойство("ФормаИндикацияХодаОбновленияИБ") Тогда
		Если Параметры.ФормаИндикацияХодаОбновленияИБ.Открыта() Тогда
			Параметры.ФормаИндикацияХодаОбновленияИБ.НачатьЗакрытие();
		КонецЕсли;
		Параметры.Удалить("ФормаИндикацияХодаОбновленияИБ");
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ОбновитьИнформационнуюБазу.
Процедура НачатьОбновлениеИнформационнойБазы(Параметры, ОбработкаПродолжения) Экспорт
	
	Если Параметры.Свойство("ФормаИндикацияХодаОбновленияИБ") Тогда
		Форма = Параметры.ФормаИндикацияХодаОбновленияИБ;
	Иначе
		ИмяФормы = "Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОбновленияИБ";
		Форма = ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения(
			"ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
		Параметры.Вставить("ФормаИндикацияХодаОбновленияИБ", Форма);
	КонецЕсли;
	
	Форма.ОбновитьИнформационнуюБазу();
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПередНачаломРаботыПрограммы.
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры, Неопределен) Экспорт
	
	ИмяФормы = "Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОбновленияИБ";
	Форма = ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения(
		"ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
	Параметры.Вставить("ФормаИндикацияХодаОбновленияИБ", Форма);
	Форма.ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ОбновитьИнформационнуюБазу.
Процедура ПослеЗакрытияФормыИндикацияХодаОбновленияИБ(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура("Отказ, Перезапустить", Истина, Ложь);
	КонецЕсли;
	
	Если Результат.Отказ Тогда
		Параметры.Отказ = Истина;
		Если Результат.Перезапустить Тогда
			Параметры.Перезапустить = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПроверитьСтатусОбработчиковОтложенногоОбновления.
Процедура ИнтерактивнаяОбработкаПроверкиСтатусаОтложенногоОбновления(Параметры, Неопределен) Экспорт
	
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенноеОбновлениеНеЗавершено", , , , , ,
		Новый ОписаниеОповещения("ПослеЗакрытияФормыПроверкиСтатусаОтложенногоОбновления",
			ЭтотОбъект, Параметры));
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПроверитьСтатусОбработчиковОтложенногоОбновления.
Процедура ПослеЗакрытияФормыПроверкиСтатусаОтложенногоОбновления(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда
		Параметры.Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Если есть непоказанные описания изменения и у пользователя не отключен
// показ - открыть форму ОписаниеИзмененийПрограммы.
//
Процедура ПоказатьОписаниеИзмененийСистемы()
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	// ТОиР++
	//Если ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы Тогда
	Если НЕ (ПараметрыРаботыКлиента.Свойство("ПоказатьОписаниеИзмененийСистемы") 
				И ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы = Ложь) Тогда
	// ТОиР --
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказыватьТолькоИзменения", Истина);
		
		ОткрытьФорму("ОбщаяФорма.ОписаниеИзмененийПрограммы", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Выводит оповещение пользователю о том, что отложенная обработка данных
// не выполнена.
//
Процедура ОповеститьОтложенныеОбработчикиНеВыполнены() Экспорт
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Работа в программе временно ограничена'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Не завершен переход на новую версию'"),
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

// Возвращает навигационную ссылку обработки ОбновлениеИнформационнойБазы.
//
Функция НавигационнаяСсылкаОбработки()
	Возврат "e1cib/app/Обработка.РезультатыОбновленияПрограммы";
КонецФункции

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ПоказатьСообщениеОбОшибочныхОбработчиках")
		Или ПараметрыКлиента.Свойство("ПоказатьОповещениеОНевыполненныхОбработчиках") Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусОтложенногоОбновления", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Вызывается при интерактивном начале работы пользователя с областью данных.
// Соответствует событию ПриНачалеРаботыСистемы модулей приложения.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеИзмененийСистемы();
	
КонецПроцедуры

#КонецОбласти
