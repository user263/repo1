#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОсновнойМенеджер = Пользователи.ТекущийПользователь();
	ДатаРегистрации = ТекущаяДата();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Наименование") Тогда
			Наименование = ДанныеЗаполнения.Наименование;
		ИначеЕсли ДанныеЗаполнения.Свойство("Описание") Тогда
			Наименование = ДанныеЗаполнения.Описание;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ОсновнойМенеджер = Пользователи.ТекущийПользователь();
	ДатаРегистрации = ТекущаяДата();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не Клиент И Не Поставщик И Не ПрочиеОтношения И Не Предопределенный Тогда
		Текст = НСтр("ru = 'Необходимо определить хотя бы один тип бизнес-отношений'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Клиент",
			,
			Отказ);
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обработка смены пометки удаления.
	Если Не ЭтоНовый() И Не ЭтоГруппа Тогда
		
		Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
			Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
				КонтрагентПартнера = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Ссылка);
				Если НЕ КонтрагентПартнера.Пустая() Тогда
					КонтрагентПартнера.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		
		Пол = Перечисления.ПолФизическогоЛица.ПустаяСсылка();
		ДатаРождения = Дата(1,1,1);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаписатьИерархиюПартнера(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
