#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

перем СтруктураДанных Экспорт; // Содержит структуру данных о статусе документа (Начальный, СогласованиеЗавершено, ПроводитьДокумент, ШаблонСообщенияЭлектроннойПочты) 
										// из регистра сведений торо_МатрицаПереходаСтатусовДокументов. 
Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

#Область ОбработчикиСобытий
// Процедура - обработчик события "ОбработкаЗаполнения".
// 
Процедура ОбработкаЗаполнения(Основание)
	
	Ответственный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиТОиР", "ОсновнойОтветственный");
	Если НЕ ЗначениеЗаполнено(Ответственный) тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;	
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.торо_ЗаявкаНаРемонт") Тогда
		
		ТекДата = ТекущаяДата();
		Дата = ТекДата;
		
		ДокументыОснования.Добавить().ДокументОснование = Основание;
		
		Организация = Основание.Организация;
		Подразделение = Основание.Подразделение;
					
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.торо_ВыявленныеДефекты") Тогда

		ТекДата = ТекущаяДата();
		
		ДокументыОснования.Добавить().ДокументОснование = Основание;
		
		Организация = Основание.Организация;
		Подразделение = Основание.Подразделение;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.торо_ПланГрафикРемонта") Тогда
		
		Организация = Основание.Организация;
		Подразделение = Основание.Подразделение;

		ДокументыОснования.Добавить().ДокументОснование = Основание;
		ВыводФормыПодбораПриОткрытии = Истина;	
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.торо_ВнешнееОснованиеДляРабот") Тогда
		
		Организация = Основание.Организация;
		Подразделение = Основание.Подразделение;
		
		ДокументыОснования.Добавить().ДокументОснование = Основание;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СписокТЧ = Новый Структура();
	СписокТЧ.Вставить("ДокументыОснования", "Документы основания");
	СписокТЧ.Вставить("РемонтыОборудования", "Ремонты оборудования");
	СписокТЧ.Вставить("РемонтныеРаботы", "Ремонтные работы");
	торо_ОбщегоНазначения.ПроверитьЗаполненностьТабличныхЧастей(ЭтотОбъект, СписокТЧ, Отказ);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУправляемыеБлокировки();
	
	// Согласование++
	
	// Проверим использование статусов документов.
	ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_НарядНаВыполнениеРемонтныхРабот;
	мИспользоватьСогласованиеДокументов = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
	
	Если мИспользоватьСогласованиеДокументов Тогда
		торо_РаботаСоСтатусамиДокументовСервер.ПроверитьРазрешениеПроведенияПоСтатусу(Ссылка, СпособСогласования, ДополнительныеСвойства, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	
	// Согласование--

	Если РемонтыОборудования.Количество() = 0 Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В документе не заполнена табличная часть ремонтов оборудования. Проведение невозможно!'"));
		Отказ = истина;
		Возврат;
	КонецЕсли;
	
	Если РемонтныеРаботы.Количество() > 0 Тогда
		Если Не ЗначениеЗаполнено(РемонтныеРаботы[0].ID) Тогда
			РемонтныеРаботы.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = Строка(Ссылка);
	
	// Проверить заполнение ТЧ
	ПроверитьЗаполнениеТабличнойЧастиРемонтыОборудования(Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиРемонтныеРаботы(Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиДокументыОснования(Отказ, Заголовок);
	
	Если ДокументыОснования.Количество()>0 Тогда
		ПроверитьДатуДокумента(Отказ, Заголовок);
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок);
		
	КонецЕсли;
	
	// закрытие предписаний (вырожденных в ремонты)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	торо_ПредписанияСрезПоследних.ОбъектРемонта,
	               |	торо_ПредписанияСрезПоследних.ID,
	               |	торо_ПредписанияСрезПоследних.Описание,
	               |	торо_ПредписанияСрезПоследних.ПлановаяДатаРемонта,
	               |	торо_ПредписанияСрезПоследних.Обработано,
	               |	торо_ПредписанияСрезПоследних.Период,
	               |	торо_ПредписанияСрезПоследних.Организация,
	               |	торо_ПредписанияСрезПоследних.Подразделение
	               |ИЗ
	               |	РегистрСведений.торо_ВнешниеОснованияДляРабот.СрезПоследних(
	               |			,
	               |			ID В (&ID)
	               |				И Регистратор <> &Регистратор) КАК торо_ПредписанияСрезПоследних";
			
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("ID",РемонтыОборудования.Выгрузить(РемонтыОборудования.НайтиСтроки(Новый Структура("ЗакрываетПредписание",Истина)),"ID").ВыгрузитьКолонку("ID"));
	ТаблицаЗакрывамыхПредписаний = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ОбработанноеПредписание Из ТаблицаЗакрывамыхПредписаний Цикл
		
		Если ОбработанноеПредписание.Обработано Тогда
			Отказ = Истина;
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Попытка обработки закрытого предписания по %1 (%2)'"),
				ОбработанноеПредписание.ОбъектРемонта,ОбработанноеПредписание.Описание));
		ИначеЕсли ОбработанноеПредписание.Период >= Дата Тогда
			Отказ = Истина;
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Попытка обработки предписания по %1 (%2) датой раньше даты регистрации!'"),
				ОбработанноеПредписание.ОбъектРемонта,ОбработанноеПредписание.Описание));			
		Иначе
			Движения.торо_ВнешниеОснованияДляРабот.Записывать = Истина;
			Движение = Движения.торо_ВнешниеОснованияДляРабот.Добавить();	
			
			Движение.Период 				= Дата;
			Движение.ОбъектРемонта 			= ОбработанноеПредписание.ОбъектРемонта;
			Движение.ID 					= ОбработанноеПредписание.ID;
			Движение.Обработано 			= Истина;
			Движение.Описание 				= ОбработанноеПредписание.Описание;
			Движение.ПлановаяДатаРемонта 	= ОбработанноеПредписание.ПлановаяДатаРемонта;
			Движение.Организация 			= ОбработанноеПредписание.Организация;
			Движение.Подразделение 			= ОбработанноеПредписание.Подразделение;

		КонецЕсли;
	КонецЦикла;
	
	// закрытие предписаний с закладки закрываемые предписания
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаID.ID,
	               |	ТаблицаID.РемонтыОборудования_ID
	               |ПОМЕСТИТЬ ТаблицаID
	               |ИЗ
	               |	&ТаблицаID КАК ТаблицаID
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	торо_ПредписанияСрезПоследних.ОбъектРемонта,
	               |	торо_ПредписанияСрезПоследних.ID,
	               |	торо_ПредписанияСрезПоследних.Описание,
	               |	торо_ПредписанияСрезПоследних.ПлановаяДатаРемонта,
	               |	торо_ПредписанияСрезПоследних.Обработано,
	               |	торо_ПредписанияСрезПоследних.Период,
	               |	ТаблицаID.РемонтыОборудования_ID,
	               |	торо_ПредписанияСрезПоследних.Организация,
	               |	торо_ПредписанияСрезПоследних.Подразделение
	               |ИЗ
	               |	РегистрСведений.торо_ВнешниеОснованияДляРабот.СрезПоследних(
	               |			,
	               |			ID В
	               |				(ВЫБРАТЬ
	               |					ТаблицаID.ID
	               |				ИЗ
	               |					ТаблицаID)) КАК торо_ПредписанияСрезПоследних
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаID КАК ТаблицаID
	               |		ПО торо_ПредписанияСрезПоследних.ID = ТаблицаID.ID";
			
	Запрос.УстановитьПараметр("ТаблицаID",ЗакрываемыеПредписания.Выгрузить(,"ID,РемонтыОборудования_ID"));
	ТаблицаЗакрывамыхПредписанийТЧ = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ОбработанноеПредписание Из ТаблицаЗакрывамыхПредписанийТЧ Цикл
		
		Если ОбработанноеПредписание.Обработано Тогда
			Отказ = Истина;
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Попытка обработки закрытого предписания по %1 (%2)'"),
				ОбработанноеПредписание.ОбъектРемонта,ОбработанноеПредписание.Описание));
		ИначеЕсли ОбработанноеПредписание.Период >= Дата Тогда
			Отказ = Истина;
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Попытка обработки предписания по %1 (%2) датой раньше даты регистрации!'"),
				ОбработанноеПредписание.ОбъектРемонта,ОбработанноеПредписание.Описание));
		Иначе
			Движения.торо_ВнешниеОснованияДляРабот.Записывать = Истина;
			Движение = Движения.торо_ВнешниеОснованияДляРабот.Добавить();	
			
			Движение.Период 				= Дата;
			Движение.ОбъектРемонта 			= ОбработанноеПредписание.ОбъектРемонта;
			Движение.ID 					= ОбработанноеПредписание.ID;
			Движение.Обработано 			= Истина;
			Движение.Описание 				= ОбработанноеПредписание.Описание;
			Движение.ПлановаяДатаРемонта 	= ОбработанноеПредписание.ПлановаяДатаРемонта;
			Движение.РемонтыОборудования_id = ОбработанноеПредписание.РемонтыОборудования_ID;
			Движение.Организация 			= ОбработанноеПредписание.Организация;
			Движение.Подразделение 			= ОбработанноеПредписание.Подразделение;

		КонецЕсли;
	КонецЦикла;
	
	Движения.торо_СтатусыДокументовНарядовНаРемонтныеРаботы.Записывать = Истина;
	торо_РаботаСоСтатусамиДокументовСервер.УстановитьСтатусДокумента(Ссылка, Ссылка, Движения, Перечисления.торо_СтатусыДокументов.Зарегистрирован);
	торо_РаботаСоСтатусамиДокументовСервер.ИзменитьСтатусыДокументовОснований(Ссылка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	торо_РаботаСоСтатусамиДокументовСервер.ОчиститьСогласованиеПриКопировании(ЭтотОбъект);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Не Отказ Тогда
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_НарядНаВыполнениеРемонтныхРабот;
		торо_РаботаСоСтатусамиДокументовСервер.ПриЗаписиОбъекта(Ссылка, ВидДокумента, СпособСогласования, ДополнительныеСвойства,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МассивIDДляБлокировки = торо_Ремонты.МассивIDДляБлокировкиРемонтовОборудования(Ссылка, РемонтыОборудования.ВыгрузитьКолонку("ID"));
	Если МассивIDДляБлокировки <> Неопределено И МассивIDДляБлокировки.Количество() > 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Невозможно отменить проведение документа, так как имеются созданные на его основании проведенные документы!'");
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Не Отказ Тогда
		торо_РаботаСоСтатусамиДокументовСервер.ОтменаПроведения(Ссылка);
	КонецЕсли;	
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ФоИнтеграцияСПромБезопасностью = ПолучитьФункциональнуюОпцию("торо_ИнтеграцияСПромБезопасностью");
	ЕстьОпасныеРаботы = Ложь;
	Если ФоИнтеграцияСПромБезопасностью = Истина Тогда
		Для каждого текСтрока из РемонтыОборудования Цикл
			Если текСтрока.ОпаснаяРабота Тогда
				ЕстьОпасныеРаботы = Истина;
				Если Не ЗначениеЗаполнено(текСтрока.МестоПроведенияРабот) Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='В табличной части ""Ремонтные работы"" в строке №%1 не заполнено поле ""Место проведения работ"", для опасных работ это поле должно быть заполнено. Проведение документа было отменено.'"),
									текСтрока.НомерСтроки));
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		масРолей = Новый Массив;

		Если ЕстьОпасныеРаботы Тогда
			масРолей.Добавить(Перечисления.торо_ОтветственныеЛица.Допускающий);
			масРолей.Добавить(Перечисления.торо_ОтветственныеЛица.ОтветственныйЗаПодготовкуОбъекта);
			масРолей.Добавить(Перечисления.торо_ОтветственныеЛица.РуководительРабот);
		Иначе
			масРолей.Добавить(Перечисления.торо_ОтветственныеЛица.Допускающий);
			масРолей.Добавить(Перечисления.торо_ОтветственныеЛица.ОтветственныйЗаПодготовкуОбъекта);
			масРолей.Добавить(Перечисления.торо_ОтветственныеЛица.Наблюдающий);
		КонецЕсли;
		
		ЕстьВсеНужныеРоли = ПроверитьНаличиеНеобходимыхРолей(масРолей, Ответственные, ЕстьОпасныеРаботы);
		
		Если НЕ ЕстьВсеНужныеРоли Тогда 
			Отказ = Истина;
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Ответственные.Сотрудник");
		МассивНепроверяемыхРеквизитов.Добавить("Ответственные.ОтветственноеЛицо");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ПроверитьДатуДокумента(Отказ, Заголовок)
	
	МассивОснований = ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
	СписокДатОснований = Новый СписокЗначений;
	Для Каждого Основание Из МассивОснований Цикл
		СписокДатОснований.Добавить(Основание.Дата);
	КонецЦикла;
	СписокДатОснований.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	Если Дата < СписокДатОснований[0].Значение Тогда
		СтрокаСообщения = НСтр("ru = 'Дата документа меньше даты документа-основания!'");
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		Отказ = Истина;

	КонецЕсли;
	
КонецПроцедуры

// Проверяет правильность заполнения строк табличной части "РемонтыОборудования".
//
// Параметры:
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиРемонтыОборудования(Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ОбъектРемонта,ВидРемонтныхРабот,ДатаНачала");
	
	// Вызовем общую процедуру проверки.
	торо_ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РемонтыОборудования", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры

// Проверяет правильность заполнения строк табличной части "Документы основания".
//
// Параметры:
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиДокументыОснования(Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ДокументОснование");
	
	// Вызовем общую процедуру проверки.
	торо_ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДокументыОснования", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры

// Проверяет правильность заполнения строк табличной части "РемонтныеРаботы".
//
// Параметры:
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиРемонтныеРаботы(Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("РемонтнаяРабота,РемонтыОборудования_ID");
	
	// Вызовем общую процедуру проверки.
	торо_ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РемонтныеРаботы", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок)
	
	ДвиженияПоРегистру_торо_Ремонты(РежимПроведения, Отказ);
	
	ДвиженияПоРегистру_торо_НарядыПоРемонтам(РежимПроведения, Отказ);
	
	ТабРемРаб = ПодготовитьТаблицуПроведенияРемонтныхРабот();
	
	ТаблицаРемонтовОборудования = ПолучитьТаблицуРемонтовОборудования();
	
	РемонтыСЗаявками = ТаблицаРемонтовОборудования.Скопировать(Новый Структура("ЕстьЗаявка", Истина));
	РемонтыБезЗаявок = ТаблицаРемонтовОборудования.Скопировать(Новый Структура("ЕстьЗаявка", Ложь));
	
	ТаблицаНеУчтенныхРабот = ТабНеУчтенныхРабот(ТабРемРаб, РемонтыСЗаявками.ВыгрузитьКолонку("ID"));
	ТаблицаРаботБезЗаявок = ПолучитьТаблицуРемонтныхРаботБезЗаявок(ТабРемРаб, РемонтыБезЗаявок.ВыгрузитьКолонку("ID"));
	
	ДвиженияПоРегистру_торо_ВыполняемыеРемонтныеРаботы(ТабРемРаб, РежимПроведения, Отказ);
	
	ДвиженияПоРегистру_торо_ЗапланированныеРемонтныеРаботы(ТаблицаНеУчтенныхРабот, ТаблицаРаботБезЗаявок, РежимПроведения, Отказ);
	
КонецПроцедуры

Функция ПолучитьТаблицуРемонтныхРаботБезЗаявок(ТабРемРаб, МассивID)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таб.РемонтнаяРабота,
	|	Таб.IDРемонта,
	|	Таб.ID КАК IDОперации,
	|	Таб.Родитель_ID,
	|	Таб.Количество
	|ПОМЕСТИТЬ ТабРемонтныхРабот
	|ИЗ
	|	&Таб КАК Таб
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабРемонтныхРабот.РемонтнаяРабота,
	|	ТабРемонтныхРабот.IDРемонта,
	|	ТабРемонтныхРабот.IDОперации,
	|	ТабРемонтныхРабот.Родитель_ID,
	|	ТабРемонтныхРабот.Количество
	|ИЗ
	|	ТабРемонтныхРабот КАК ТабРемонтныхРабот
	|ГДЕ
	|	ТабРемонтныхРабот.IDРемонта В (&IDРемонта)";
	
	Запрос.УстановитьПараметр("Таб", ТабРемРаб);
	Запрос.УстановитьПараметр("IDРемонта", МассивID);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьТаблицуРемонтовОборудования()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.ID
		|ПОМЕСТИТЬ ТабID
		|ИЗ
		|	Документ.торо_НарядНаВыполнениеРемонтныхРабот.РемонтыОборудования КАК торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования
		|ГДЕ
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтыОборудования.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабID.ID,
		|	ВЫБОР
		|		КОГДА торо_ЗаявкиПоРемонтамСрезПоследних.IDРемонта ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьЗаявка
		|ИЗ
		|	ТабID КАК ТабID
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ЗаявкиПоРемонтам.СрезПоследних(
		|				,
		|				IDРемонта В
		|					(ВЫБРАТЬ
		|						Таб.ID
		|					ИЗ
		|						ТабID КАК Таб)) КАК торо_ЗаявкиПоРемонтамСрезПоследних
		|		ПО ТабID.ID = торо_ЗаявкиПоРемонтамСрезПоследних.IDРемонта";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Процедура ДвиженияПоРегистру_торо_ЗапланированныеРемонтныеРаботы(ТабНеУчтенныхРабот, ТабРаботБезЗаявки, РежимПроведения, Отказ)
	
	Движения.торо_ЗапланированныеРемонтныеРаботы.Записывать = Истина;
	
	Для каждого СтрТаб Из ТабНеУчтенныхРабот Цикл
		
		Движение = Движения.торо_ЗапланированныеРемонтныеРаботы.Добавить();
		Движение.Период = Дата;
		Движение.IDОперации = СтрТаб.IDОперации;
		Движение.IDРемонта = СтрТаб.IDРемонта;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Родитель_ID = СтрТаб.Родитель_ID;
		Движение.ПроцентОпераций = СтрТаб.ПроцентОперацийДок - СтрТаб.ПроцентОпераций;
		
	КонецЦикла;
	
	Для каждого СтрТаб Из ТабРаботБезЗаявки Цикл
		
		Движение = Движения.торо_ЗапланированныеРемонтныеРаботы.Добавить();
		Движение.Период = Дата;
		Движение.IDОперации = СтрТаб.IDОперации;
		Движение.IDРемонта = СтрТаб.IDРемонта;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Родитель_ID = СтрТаб.Родитель_ID;
		Движение.ПроцентОпераций = СтрТаб.Количество * 100;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТабНеУчтенныхРабот(ТабРемРаб, МассивID)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таб.РемонтнаяРабота,
		|	Таб.IDРемонта,
		|	Таб.ID КАК IDОперации,
		|	Таб.Родитель_ID,
		|	Таб.Количество
		|ПОМЕСТИТЬ ТабРемонтныхРабот
		|ИЗ
		|	&Таб КАК Таб
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабРемонтныхРабот.РемонтнаяРабота,
		|	ТабРемонтныхРабот.IDРемонта,
		|	ТабРемонтныхРабот.IDОперации,
		|	ТабРемонтныхРабот.Родитель_ID,
		|	ТабРемонтныхРабот.Количество
		|ИЗ
		|	ТабРемонтныхРабот КАК ТабРемонтныхРабот
		|ГДЕ
		|	ТабРемонтныхРабот.IDРемонта В (&IDРемонта)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабРемонтныхРабот.IDРемонта,
		|	ТабРемонтныхРабот.IDОперации,
		|	ТабРемонтныхРабот.Родитель_ID,
		|	ТабРемонтныхРабот.Количество * 100 КАК ПроцентОперацийДок,
		|	ЕСТЬNULL(торо_ЗапланированныеРемонтныеРаботы.ПроцентОпераций, 0) КАК ПроцентОпераций
		|ИЗ
		|	ТабРемонтныхРабот КАК ТабРемонтныхРабот
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.торо_ЗапланированныеРемонтныеРаботы КАК торо_ЗапланированныеРемонтныеРаботы
		|		ПО ТабРемонтныхРабот.IDРемонта = торо_ЗапланированныеРемонтныеРаботы.IDРемонта
		|			И ТабРемонтныхРабот.IDОперации = торо_ЗапланированныеРемонтныеРаботы.IDОперации
		|			И ТабРемонтныхРабот.Родитель_ID = торо_ЗапланированныеРемонтныеРаботы.Родитель_ID
		|			И (ВЫРАЗИТЬ(торо_ЗапланированныеРемонтныеРаботы.Регистратор КАК Документ.торо_ЗаявкаНаРемонт) ССЫЛКА Документ.торо_ЗаявкаНаРемонт)
		|ГДЕ 
		|			торо_ЗапланированныеРемонтныеРаботы.ПроцентОпераций < ТабРемонтныхРабот.Количество * 100";

	Запрос.УстановитьПараметр("Таб", ТабРемРаб);
	Запрос.УстановитьПараметр("IDРемонта", МассивID);
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить();

КонецФункции

Процедура ДвиженияПоРегистру_торо_Ремонты(РежимПроведения, Отказ)
	
	// Движения по регистру сведений торо_Ремонты
	Движения.торо_Ремонты.Записывать = Истина;
	Для Каждого СтрРемонта Из РемонтыОборудования Цикл
		
		Движение = Движения.торо_Ремонты.Добавить();
		Движение.Период 			= МоментВремени().Дата;
		Движение.ID 				= СтрРемонта.ID;
		Движение.ОбъектРемонта 		= СтрРемонта.ОбъектРемонта;
		Движение.ВидРемонта			= СтрРемонта.ВидРемонтныхРабот;
		Движение.ДатаНачалаФакт		= СтрРемонта.ДатаНачала;
		Движение.ДатаОкончанияФакт	= СтрРемонта.ДатаОкончания;
		Движение.ГарантийныйРемонт  = СтрРемонта.ГарантийныйРемонт;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДвиженияПоРегистру_торо_НарядыПоРемонтам(РежимПроведения, Отказ)
	
	// Движения по регистру сведений торо_НарядыПоРемонтам
	Движения.торо_НарядыПоРемонтам.Записывать = Истина;
	Для Каждого СтрРемонта Из РемонтыОборудования Цикл
		
		Движение = Движения.торо_НарядыПоРемонтам.Добавить();
		Движение.Период 			= МоментВремени().Дата;
		Движение.IDРемонта			= СтрРемонта.ID;
		
	КонецЦикла;		
	
КонецПроцедуры

Функция ПодготовитьТаблицуПроведенияРемонтныхРабот()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы.РемонтнаяРабота,
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы.Родитель_ID,
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы.РемонтыОборудования_ID КАК IDРемонта,
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы.ID,
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы.Количество
		|ИЗ
		|	Документ.торо_НарядНаВыполнениеРемонтныхРабот.РемонтныеРаботы КАК торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы
		|ГДЕ
		|	торо_НарядНаВыполнениеРемонтныхРаботРемонтныеРаботы.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ТаблицаПроведения = Запрос.Выполнить().Выгрузить();
	
	КЧ = Новый КвалификаторыЧисла(5, 2);
	МассивТипов = Новый Массив(1);
	МассивТипов.Добавить(Тип("Число"));
	ОписаниеТиповЧ = Новый ОписаниеТипов(МассивТипов, , ,КЧ);
	ТаблицаПроведения.Колонки.Добавить("ПроцентНевыполненныхРабот", ОписаниеТиповЧ);
	
	КД = Новый КвалификаторыДаты(ЧастиДаты.Дата);
	МассивТипов = Новый Массив();
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповД = Новый ОписаниеТипов(МассивТипов, , ,КД);
	ТаблицаПроведения.Колонки.Добавить("ДатаНачалаРемонта", ОписаниеТиповД);
	
	Для каждого Строка Из РемонтыОборудования Цикл
		
		МассивСтрок = ТаблицаПроведения.НайтиСтроки(Новый Структура("IDРемонта",Строка.ID));
		
		Для каждого СтрокаМассива Из МассивСтрок Цикл
			СтрокаМассива.ДатаНачалаРемонта = Строка.ДатаНачала;
		КонецЦикла;
		
	КонецЦикла; 

	торо_Ремонты.ЗаполнитьПроцентыНевыполненныхРаботПоНормамВремени("", ТаблицаПроведения);
	
	РасставитьПроцентНаРодительскихУровнях("", ТаблицаПроведения); 
	
	Возврат ТаблицаПроведения;

КонецФункции

// Процедура устанавливает значение процента на родительских уровнях таблицы ремонтных работ акта.
//
// Параметры:
//  СтрокаДерева – строка дерева значений.
//  Процент      – число – устанавливаемый процент.
//
Процедура РасставитьПроцентНаРодительскихУровнях(ID_Поиска, ТаблицаПроведения)
	
	СуммаСПроцентомВыполнения = 0;
	
	МассивСтрок = ТаблицаПроведения.НайтиСтроки(Новый Структура("Родитель_ID", ID_Поиска));
	
	Для Каждого Элемент Из МассивСтрок Цикл
		
		РасставитьПроцентНаРодительскихУровнях(Элемент.ID, ТаблицаПроведения);
		
		СуммаСПроцентомВыполнения = СуммаСПроцентомВыполнения + Элемент.ПроцентНеВыполненныхРабот;
		
	КонецЦикла;
	
	Если СуммаСПроцентомВыполнения > 0 Тогда
		
		СтрокаТЗ = ТаблицаПроведения.Найти(ID_Поиска, "ID");
		Если Не СтрокаТЗ = Неопределено Тогда
			
			СтрокаТЗ.ПроцентНеВыполненныхРабот = СтрокаТЗ.ПроцентНеВыполненныхРабот * СуммаСПроцентомВыполнения / 100;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры // РасставитьПроцентНаНижнихУровнях()

Процедура ДвиженияПоРегистру_торо_ВыполняемыеРемонтныеРаботы(ТабРемРаб, РежимПроведения, Отказ)
	
	Движения.торо_ВыполняемыеРемонтныеРаботы.Записывать = Истина;
	
	Для каждого СтрТаб Из ТабРемРаб Цикл
		
		Движение = Движения.торо_ВыполняемыеРемонтныеРаботы.Добавить();
		Движение.Период = Дата;
		Движение.IDОперации = СтрТаб.ID;
		Движение.IDРемонта = СтрТаб.IDРемонта;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Родитель_ID = СтрТаб.Родитель_ID;
		Движение.РемонтнаяРабота = СтрТаб.РемонтнаяРабота;
		Движение.ПроцентОпераций = СтрТаб.Количество * 100;
		Движение.ПроцентРемонта = СтрТаб.ПроцентНевыполненныхРабот;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьУправляемыеБлокировки()
	
	Блокировка = Новый БлокировкаДанных;
	
	// закрытие предписаний (по таблице ремонты оборудования)
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.торо_ВнешниеОснованияДляРабот");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РемонтыОборудования.Выгрузить(Новый Структура("ЗакрываетПредписание",Истина),"ID");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ID", "ID");
	
	// закрытие предписаний (по таблице закрываемых предписаний)
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.торо_ВнешниеОснованияДляРабот");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ЗакрываемыеПредписания.Выгрузить(,"ID");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ID", "ID");
	
	// проверяем, есть ли заявка
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.торо_ЗаявкиПоРемонтам");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = РемонтыОборудования.Выгрузить(,"ID");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("IDРемонта", "ID");
	
	//
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.торо_ЗапланированныеРемонтныеРаботы");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РемонтныеРаботы.Выгрузить(,"РемонтыОборудования_ID,ID,Родитель_ID");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("IDРемонта", "РемонтыОборудования_ID");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("IDОперации", "ID");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Родитель_ID", "Родитель_ID");
		
	Блокировка.Заблокировать();
	
КонецПроцедуры

Функция ПроверитьНаличиеНеобходимыхРолей(масРолей, тз, ЕстьОпасныеРаботы)
	
	Результат = Истина;
	
	Для каждого ТекРоль из масРолей Цикл
		
		Если тз.Найти(ТекРоль, "ОтветственноеЛицо") = Неопределено Тогда
			Результат = Ложь;
			Если ЕстьОпасныеРаботы Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'В документе присутствуют опасные работы и в табличной части ""Ответственные лица"" обязательно должен быть указан ""%1"". Проведение документа было отменено.'"),
					ТекРоль));
			Иначе 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'В табличной части ""Ответственные лица"" обязательно должен быть указан ""%1"". Проведение документа было отменено.'"),
					ТекРоль));
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции 

#КонецОбласти

#КонецЕсли