////////////////////////////////////////////////////////////////////////////////
// торо_РасчетППР: методы, для расчета ППР
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Процедура ФоновыйРасчетППР() Экспорт
	
	// читаем из регистра
	ППРДляРасчета = РегистрыСведений.торо_ППРДляРасчетаВФоновомРежиме.СрезПоследних();
	ППРДляРасчетаНаборЗаписей = РегистрыСведений.торо_ППРДляРасчетаВФоновомРежиме.СоздатьНаборЗаписей();
	ППРДляРасчетаНаборЗаписей.Прочитать();
	Для Каждого СтрокаСсылкаНаППР Из ППРДляРасчета Цикл
		Если Не СтрокаСсылкаНаППР.Рассчитан Тогда
			НоваяСтрокаФоновыйППР = ППРДляРасчетаНаборЗаписей.Добавить();
			НоваяСтрокаФоновыйППР.ВыборочныйРасчет = СтрокаСсылкаНаППР.ВыборочныйРасчет;
			Попытка
				
				ТаблицаОРДляВыборочногоРасчета = Неопределено;
				Если СтрокаСсылкаНаППР.ВыборочныйРасчет Тогда
					Запрос = Новый Запрос;
					Запрос.Текст =
					"ВЫБРАТЬ
					|	торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме.ВидРемонтныхРабот,
					|	торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме.ОбъектРемонтныхРабот,
					|	торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме.ЭтоЦепочка
					|ИЗ
					|	РегистрСведений.торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме КАК торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме
					|ГДЕ
					|	торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме.ДокументППР = &ДокументППР";
					Запрос.УстановитьПараметр("ДокументППР", СтрокаСсылкаНаППР.ДокументППР);
					ТаблицаОРДляВыборочногоРасчета = Запрос.Выполнить().Выгрузить();
				КонецЕсли;
				
				Если РасчетППР(СтрокаСсылкаНаППР.ДокументППР, , Истина,, ТаблицаОРДляВыборочногоРасчета) Тогда
					НоваяСтрокаФоновыйППР.ДокументППР = СтрокаСсылкаНаППР.ДокументППР;
					НоваяСтрокаФоновыйППР.Рассчитан = Истина;
					НоваяСтрокаФоновыйППР.Период = ТекущаяДата();
				Иначе
					НоваяСтрокаФоновыйППР.ДокументППР = СтрокаСсылкаНаППР.ДокументППР;
					НоваяСтрокаФоновыйППР.Период = ТекущаяДата();
					НоваяСтрокаФоновыйППР.ОписаниеОшибки = "Расчет не выполнен! Проверьте настройки системы и настройки пользователя для выполнения фонового задания.";
				КонецЕсли;
			Исключение
				НоваяСтрокаФоновыйППР.ДокументППР = СтрокаСсылкаНаППР.ДокументППР;
				НоваяСтрокаФоновыйППР.Период = ТекущаяДата();
				НоваяСтрокаФоновыйППР.ОписаниеОшибки = ОписаниеОшибки();
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	ППРДляРасчетаНаборЗаписей.Записать();
	
	Для каждого НоваяСтрокаФоновыйППР из ППРДляРасчетаНаборЗаписей Цикл
		Если НоваяСтрокаФоновыйППР.ВыборочныйРасчет И НоваяСтрокаФоновыйППР.Рассчитан Тогда
			НаборЗаписейОбъектовРемонта = РегистрыСведений.торо_ОбъектыРемонтаДляВыборочногоРасчетаППРВФоновомРежиме.СоздатьНаборЗаписей();
			НаборЗаписейОбъектовРемонта.Отбор.ДокументППР.Установить(НоваяСтрокаФоновыйППР.ДокументППР);
			НаборЗаписейОбъектовРемонта.Записать(Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Выполняет расчет ППР.
//
// Параметры:
//		Ссылка - ДокументСсылка.торо_ПланГрафикППР - ссылка на документ ППР для расчета.
//		РассчитыватьСтоимости - Булево - необходимость рассчитать стоимости ремонтов после расчета ППР.
//		ФоновыйРассчет - Булево - это фоновый расчет.
//		СтруктураДанныхДляРасчетаВизуализации - Структура - стркутура данных, необходимых для рассчета визуализации.
//		ТаблицаОРДляВыборочногоРасчета - ТаблицаЗначений - таблица со списокм ОР, для которых необходимо выполнить расчет.
//
// Возвращаемое значение:
//		ТаблицаЗначений - таблица плана ремонтов, если расчет не фоновый.
//		Булево - признак успешности фонового расчета.
Функция РасчетППР(Ссылка, РассчитыватьСтоимости = Неопределено, ФоновыйРассчет = Ложь, СтруктураДанныхДляРасчетаВизуализации = Неопределено, ТаблицаОРДляВыборочногоРасчета = Неопределено) Экспорт
	
	ЭтоГрафикРегламентныхМероприятий = (ТипЗнч(Ссылка) = Тип("ДокументСсылка.торо_ГрафикРегламентныхМероприятийТОиР"));
	ЭтоРасчетВизуализации = (Ссылка = Неопределено);
	
	Если НЕ ЭтоРасчетВизуализации Тогда
		
		ВидОперации = Ссылка.ВидОперации;
		ПланРемонтов = Ссылка.ПланРемонтов.Выгрузить();
		
		Если Не ЭтоГрафикРегламентныхМероприятий Тогда
			МассивДоступныхДляКорректировкиСтрок = Документы.торо_ПланГрафикРемонта.ОбновитьДоступностьДляРедактирования(Ссылка,ВидОперации,Ссылка.ПланРемонтов.Выгрузить());
		Иначе 
			МассивДоступныхДляКорректировкиСтрок = Документы.торо_ГрафикРегламентныхМероприятийТОиР.ОбновитьДоступностьДляРедактирования(Ссылка,ВидОперации,Ссылка.ПланРемонтов.Выгрузить());
		КонецЕсли;
		
		Если РассчитыватьСтоимости = Неопределено Тогда
			Если ВидОперации <> Перечисления.торо_ВидыОперацийПланаГрафикаППР.Корректировка Тогда
				РассчитыватьСтоимости = Истина;
			Иначе
				РассчитыватьСтоимости = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Отказ = Ложь;
		ПланРемонтовID = Ссылка.ПланРемонтов.Выгрузить(, "ID");
		
		СисИнфо      = Новый СистемнаяИнформация;
		СтрокаВерсии = СисИнфо.ВерсияПриложения;
		
		ТаблицаОбъектыРемонта = Новый ТаблицаЗначений;
		
		Если ЭтоГрафикРегламентныхМероприятий Тогда
			
			ТаблицаОбъектыРемонта.Колонки.Добавить("ОбъектРемонтныхРабот", Новый ОписаниеТипов("СправочникСсылка.торо_СписокОбъектовРегламентногоМероприятия"));
			
		Иначе
			
			ТаблицаОбъектыРемонта.Колонки.Добавить("ОбъектРемонтныхРабот", Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта"));
			
		КонецЕсли;
		
		ТаблицаОбъектыРемонта.Колонки.Добавить("ВидРемонтныхРабот",    Новый ОписаниеТипов("СправочникСсылка.торо_ВидыРемонтов"));
		
		ТаблицаЦепочки = Новый ТаблицаЗначений;
		ТаблицаЦепочки.Колонки.Добавить("ОбъектРемонтныхРабот", Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта"));
		ТаблицаЦепочки.Колонки.Добавить("Цепочка",              Новый ОписаниеТипов("СправочникСсылка.торо_ЦепочкиРемонта"));
		
		Если ЭтоГрафикРегламентныхМероприятий Тогда
			ОбъектыРемонтаИзППР = Ссылка.Маршруты.Выгрузить();
			ОбъектыРемонтаИзППР.Колонки.СписокОбъектовРемонта.Имя = "ОбъектРемонтныхРабот";
			ОбъектыРемонтаИзППР.Колонки.ВидМероприятия.Имя        = "ВидРемонтныхРабот";
		Иначе
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	Таб.ВидРемонтныхРабот КАК ВидРемонтныхРабот,
			               |	Таб.НомерСтроки,
			               |	Таб.ОбъектРемонтныхРабот КАК ОбъектРемонтныхРабот,
			               |	Таб.ЭтоЦепочка
			               |ПОМЕСТИТЬ ВТ_ОбъектыРемонтаИзППР
			               |ИЗ
			               |	&Таб КАК Таб
			               |
			               |ИНДЕКСИРОВАТЬ ПО
			               |	ВидРемонтныхРабот,
			               |	ОбъектРемонтныхРабот
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ
			               |	ВТ_ОбъектыРемонтаИзППР.ВидРемонтныхРабот,
			               |	ВТ_ОбъектыРемонтаИзППР.НомерСтроки,
			               |	ВТ_ОбъектыРемонтаИзППР.ОбъектРемонтныхРабот,
			               |	ВТ_ОбъектыРемонтаИзППР.ЭтоЦепочка
			               |ИЗ
			               |	ВТ_ОбъектыРемонтаИзППР КАК ВТ_ОбъектыРемонтаИзППР
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.торо_НормативныеРемонтыОборудования КАК торо_НормативныеРемонтыОборудования
			               |		ПО ВТ_ОбъектыРемонтаИзППР.ВидРемонтныхРабот = торо_НормативныеРемонтыОборудования.ВидРемонта
			               |			И ВТ_ОбъектыРемонтаИзППР.ОбъектРемонтныхРабот = торо_НормативныеРемонтыОборудования.ОбъектРемонта
			               |			И (НЕ ВТ_ОбъектыРемонтаИзППР.ЭтоЦепочка)
			               |ГДЕ
			               |	торо_НормативныеРемонтыОборудования.НеУчаствуетВПланировании = ЛОЖЬ
			               |
			               |ОБЪЕДИНИТЬ ВСЕ
			               |
			               |ВЫБРАТЬ
			               |	ВТ_ОбъектыРемонтаИзППР.ВидРемонтныхРабот,
			               |	ВТ_ОбъектыРемонтаИзППР.НомерСтроки,
			               |	ВТ_ОбъектыРемонтаИзППР.ОбъектРемонтныхРабот,
			               |	ВТ_ОбъектыРемонтаИзППР.ЭтоЦепочка
			               |ИЗ
			               |	ВТ_ОбъектыРемонтаИзППР КАК ВТ_ОбъектыРемонтаИзППР
			               |ГДЕ
			               |	ВТ_ОбъектыРемонтаИзППР.ЭтоЦепочка
								|	И ВЫРАЗИТЬ(ВТ_ОбъектыРемонтаИзППР.ОбъектРемонтныхРабот КАК Справочник.торо_ОбъектыРемонта).НеУчаствуетВПланировании = ЛОЖЬ";
								
			Если ТипЗнч(ТаблицаОРДляВыборочногоРасчета) <> Тип("ТаблицаЗначений") Тогда
				Запрос.УстановитьПараметр("Таб", Ссылка.ОбъектыРемонта.Выгрузить());
			Иначе
				Если ТаблицаОРДляВыборочногоРасчета.Колонки.Найти("НомерСтроки") = Неопределено Тогда
					ТаблицаОРДляВыборочногоРасчета.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
					НомерСтроки = 1;
					Для каждого Строка из ТаблицаОРДляВыборочногоРасчета Цикл
						Строка.НомерСтроки = НомерСтроки;
						НомерСтроки = НомерСтроки + 1;
					КонецЦикла;
				КонецЕсли;
				Запрос.УстановитьПараметр("Таб", ТаблицаОРДляВыборочногоРасчета);
			КонецЕсли;
			
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда Возврат Ложь; КонецЕсли;
			
			ОбъектыРемонтаИзППР = Результат.Выгрузить();
			
		КонецЕсли; 
		
		Для Каждого ОР Из ОбъектыРемонтаИзППР Цикл
			Если ТипЗнч(ОР.ВидРемонтныхРабот) = Тип("СправочникСсылка.торо_ЦепочкиРемонта") Тогда
				НС = ТаблицаЦепочки.Добавить();
				ЗаполнитьЗначенияСвойств(НС,ОР);
				НС.Цепочка = ОР.ВидРемонтныхРабот;
			ИначеЕсли ТипЗнч(ОР.ВидРемонтныхРабот) = Тип("СправочникСсылка.торо_ВидыРемонтов") Тогда
				Если НЕ ЭтоГрафикРегламентныхМероприятий И ОР.ОбъектРемонтныхРабот.НеУчаствуетВПланировании тогда Продолжить; КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(ТаблицаОбъектыРемонта.Добавить(),ОР);
			КонецЕсли;
		КонецЦикла;
		
		СтруктураДанных = Новый Структура;
		
		Если Не ЭтоГрафикРегламентныхМероприятий Тогда
			
			СтруктураДанных.Вставить("ТаблицаПланРемонтов", ?(ВидОперации = Перечисления.торо_ВидыОперацийПланаГрафикаППР.Корректировка, Документы.торо_ПланГрафикРемонта.ЗаполнитьДоступностьДляРедактированияПолная(Ссылка.ПланРемонтов,МассивДоступныхДляКорректировкиСтрок), Ссылка.ПланРемонтов.Выгрузить()));
		Иначе
			СтруктураДанных.Вставить("ТаблицаПланРемонтов", ?(ВидОперации = Перечисления.торо_ВидыОперацийПланаГрафикаППР.Корректировка, Документы.торо_ГрафикРегламентныхМероприятийТОиР.ЗаполнитьДоступностьДляРедактированияПолная(Ссылка.ПланРемонтов,МассивДоступныхДляКорректировкиСтрок), Ссылка.ПланРемонтов.Выгрузить()));
			
		КонецЕсли;
		
		СтруктураДанных.Вставить("ТаблицаОбъектыРемонта",    ТаблицаОбъектыРемонта);
		СтруктураДанных.Вставить("ТаблицаЦепочки",           ТаблицаЦепочки);
		СтруктураДанных.Вставить("ДатаПланирования",         Ссылка.ДатаПланирования);
		СтруктураДанных.Вставить("ПериодичностьДетализации", Ссылка.ПериодичностьДетализации);
		СтруктураДанных.Вставить("КоличествоПериодов",       Ссылка.КоличествоПериодов);
		
	Иначе
		СтруктураДанных = СтруктураДанныхДляРасчетаВизуализации;	
	КонецЕсли;
	
	
	ИмяОбработки = "торо_ЗащитаУправлениеРемонтами83";		
	ТаблицаРемонтов = торо_СЛКСервер.ЗаполнитьПланГрафикППР_Session(ИмяОбработки, СтруктураДанных,, Ссылка);
	
	Если ТаблицаРемонтов = Неопределено Тогда
		
		Возврат Ложь;
		
	КонецЕсли; 
	
	Если НЕ ЭтоРасчетВизуализации Тогда
		Если Не ВидОперации = Перечисления.торо_ВидыОперацийПланаГрафикаППР.Корректировка Тогда
			
			Если РассчитыватьСтоимости Тогда
				МассивСтрокДляРедактирования = ТаблицаРемонтов.Скопировать(, "ID");
				МассивСтрокДляРедактирования.Колонки.Добавить("ДоступенДляРедактирования", Новый ОписаниеТипов("Булево"));
				МассивСтрокДляРедактирования.ЗаполнитьЗначения(Истина, "ДоступенДляРедактирования");
				Если ЭтоГрафикРегламентныхМероприятий Тогда
					ПланРемонтов = Документы.торо_ГрафикРегламентныхМероприятийТОиР.РассчитатьСтоимостиРемонтов(ТаблицаРемонтов, Ссылка, МассивСтрокДляРедактирования);
				Иначе
					ПланРемонтов = Документы.торо_ПланГрафикРемонта.РассчитатьСтоимостиРемонтов(ТаблицаРемонтов, Ссылка, МассивСтрокДляРедактирования);
				КонецЕсли;
			Иначе
				ПланРемонтов = ТаблицаРемонтов.Скопировать();
			КонецЕсли;
			
		Иначе
			
			Для Каждого СтрокаПланРемонтов Из ПланРемонтов Цикл
				СтрокаПланРемонтов.ДатаНач = Дата(1,1,1,0,0,0);
				СтрокаПланРемонтов.ДатаКон = Дата(1,1,1,0,0,0);
				
			КонецЦикла;
			
			Для Каждого СтрокаРемонта Из ТаблицаРемонтов Цикл
				
				КорректируемаяСтрока = ПланРемонтов.Найти(СтрокаРемонта.ID,"ID");
				Если КорректируемаяСтрока = Неопределено Тогда
					НоваяСтрокаПлана = ПланРемонтов.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаПлана,СтрокаРемонта);
				Иначе
					ЗаполнитьЗначенияСвойств(КорректируемаяСтрока,СтрокаРемонта);
				КонецЕсли;
				
			КонецЦикла;
			
			Для Каждого СтрокаПланаРемонтов Из ПланРемонтов Цикл
				
				Если (МассивДоступныхДляКорректировкиСтрок.Найти(СтрокаПланаРемонтов.ID) = Неопределено ИЛИ МассивДоступныхДляКорректировкиСтрок.Найти(СтрокаПланаРемонтов.ID).ДоступенДляРедактирования) Тогда
					Если Не ЗначениеЗаполнено(СтрокаПланаРемонтов.ДатаНач) И Не ЗначениеЗаполнено(СтрокаПланаРемонтов.ДатаКон) Тогда
						СтрокаПланаРемонтов.Отменен = Истина;
						СтрокаПланаРемонтов.ДатаНач = СтрокаПланаРемонтов.ДатаНачСт;
						СтрокаПланаРемонтов.ДатаКон = СтрокаПланаРемонтов.ДатаКонСт;
					КонецЕсли;
				Иначе
					СтрокаПланаРемонтов.ДатаНач = СтрокаПланаРемонтов.ДатаНачСт;
					СтрокаПланаРемонтов.ДатаКон = СтрокаПланаРемонтов.ДатаКонСт;
				КонецЕсли;
				
			КонецЦикла;	
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ФоновыйРассчет Тогда
		ДокументППР = Ссылка.ПолучитьОбъект();
		
		Если ТипЗнч(ТаблицаОРДляВыборочногоРасчета) <> Тип("ТаблицаЗначений") Тогда 
			ДокументППР.ПланРемонтов.Загрузить(ПланРемонтов);
		Иначе
			
			СтруктураПоиска = Новый Структура("ОбъектРемонтныхРабот, ВидРемонтныхРабот");
			Для каждого СтрокаОР из ТаблицаОРДляВыборочногоРасчета Цикл
				Если СтрокаОР.ЭтоЦепочка Тогда
					Для каждого ВидРемонтаИзЦепочки из СтрокаОР.ВидРемонтныхРабот.ПоследовательностьРемонтов Цикл
						ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОР);
						СтруктураПоиска.ВидРемонтныхРабот = ВидРемонтаИзЦепочки.ВидРемонта;
						ЗаменитьСтрокиПланаРемонтовПоСтруктуреПоиска(ДокументППР, ПланРемонтов, СтруктураПоиска, СтрокаОР.ВидРемонтныхРабот);
					КонецЦикла;
				Иначе
					ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОР);
					ЗаменитьСтрокиПланаРемонтовПоСтруктуреПоиска(ДокументППР, ПланРемонтов, СтруктураПоиска);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		ДокументППР.Записать();
		Возврат Истина;
	ИначеЕсли ЭтоРасчетВизуализации Тогда
		Возврат ТаблицаРемонтов;
	Иначе
		Возврат ПланРемонтов;
	КонецЕсли;
КонецФункции

Процедура ЗаменитьСтрокиПланаРемонтовПоСтруктуреПоиска(ДокументППР, ПланРемонтов, СтруктураПоиска, ЦепочкаРемонтов = Неопределено)
	
	Если ЦепочкаРемонтов <> Неопределено Тогда
		
		СтруктураПоискаЦепочки = Новый Структура("ОбъектРемонтныхРабот, ВидРемонтныхРабот");
		ЗаполнитьЗначенияСвойств(СтруктураПоискаЦепочки, СтруктураПоиска);
		СтруктураПоискаЦепочки.ВидРемонтныхРабот = ЦепочкаРемонтов;
		СтрокиТаблицыОР = ДокументППР.ОбъектыРемонта.НайтиСтроки(СтруктураПоискаЦепочки);
		
	Иначе
		
		СтрокиТаблицыОР = ДокументППР.ОбъектыРемонта.НайтиСтроки(СтруктураПоиска);
		
	КонецЕсли;
	
	Если СтрокиТаблицыОР.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиРемонта = ДокументППР.ПланРемонтов.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаРемонта из СтрокиРемонта Цикл
		ДокументППР.ПланРемонтов.Удалить(СтрокаРемонта);
	КонецЦикла;
	
	НовыеСтрокиРемонта = ПланРемонтов.НайтиСтроки(СтруктураПоиска);
	Для каждого НоваяСтрокаРемонта из НовыеСтрокиРемонта Цикл
		НовСтр = ДокументППР.ПланРемонтов.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, НоваяСтрокаРемонта);
	КонецЦикла;
	
КонецПроцедуры


// Функция получает таблицу соответствия версий обработки расчета ППР и версий конфигурации.
//
// Возвращаемое значение:
//		ТаблицаЗначений - с полями
//			* ВерсияРелиза - Строка - версия релиза.
//			* ВерсияОбработки - Строка - версия обработки.
//			* ВерсияСЛК - Строка - версия СЛК.
//
Функция ПолучитьТаблицуСоответствияВерсийОбработокРелизам() Экспорт

	ТаблицаСоответствияВерсийОбработокРелизам = Новый ТаблицаЗначений;
	ТаблицаСоответствияВерсийОбработокРелизам.Колонки.Добавить("ВерсияРелиза");
	ТаблицаСоответствияВерсийОбработокРелизам.Колонки.Добавить("ВерсияОбработки");
	ТаблицаСоответствияВерсийОбработокРелизам.Колонки.Добавить("ВерсияСЛК");

	МакетОписаниеРолейКонфигурации = ПолучитьОбщийМакет("торо_СоответствиеВерсийКонфигурацииИОбработкиРасчетаППР");
	ОбластьСписокРолей = МакетОписаниеРолейКонфигурации.ПолучитьОбласть("СоответствиеВерсийОбработокВерсиямРелиза");
	Для Сч = 1 По ОбластьСписокРолей.ВысотаТаблицы Цикл
		СтрокаТаблицы = ТаблицаСоответствияВерсийОбработокРелизам.Добавить();
		СтрокаТаблицы.ВерсияРелиза         = ОбластьСписокРолей.Область(Сч,1,Сч,1).Текст;
		СтрокаТаблицы.ВерсияОбработки      = ОбластьСписокРолей.Область(Сч,2,Сч,2).Текст;
		СтрокаТаблицы.ВерсияСЛК 		   = ОбластьСписокРолей.Область(Сч,3,Сч,3).Текст;
	КонецЦикла;
	
	Возврат ТаблицаСоответствияВерсийОбработокРелизам;
	
КонецФункции // 

// Процедура создаёт в переданной ВТ таблицу графиков работы аналогично методу БСП СоздатьВТРасписанияРаботыНаПериод.
// Отличие в возможности копировать заполнение графика текущего года на период, например, 
// график текущего года на 10 лет вперёд.
// Используется при расчете визуализации, чтобы не заставлять пользователя заполнять графики на много лет вперёд.
//
// Параметры:
//		МенеджерВТ - МенеджерВременныхТаблиц - менеджер временных таблиц запроса.
//		Графики - Массив - массив элементов типа СправочникСсылка.Календари.
//		ДатаНачала - Дата - начало периода.
//		ДатаОкончания - Дата - конец периода.
//		ДляВизуализации - Булево - признак, что функция вызывается для расчета визуализации.
//
Процедура СоздатьВТРасписанияРаботыНаПериодСКопированиемПериода(МенеджерВТ,Графики,ДатаНачала,ДатаОкончания,ДляВизуализации = Ложь) Экспорт
	Если ДатаОкончания >= Дата(3999,12,31,23,59,59) Тогда
		ДатаОкончания = Дата(3999,12,31,23,59,59);
	КонецЕсли;
	
	ПериодПланирования = ДатаОкончания - ДатаНачала;
	Если НЕ ДляВизуализации Тогда
		КалендарныеГрафики.СоздатьВТРасписанияРаботыНаПериод(МенеджерВТ, Графики, ДатаНачала, ДатаОкончания);
	Иначе
		// Дублирует текст запроса в КалендарныеГрафики.СоздатьВТРасписанияРаботыНаПериод кроме последней таблицы.
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ШаблонЗаполнения.Ссылка КАК ГрафикРаботы,
			|	МАКСИМУМ(ШаблонЗаполнения.НомерСтроки) КАК ДлинаЦикла
			|ПОМЕСТИТЬ ВТДлинаЦиклаГрафиков
			|ИЗ
			|	Справочник.Календари.ШаблонЗаполнения КАК ШаблонЗаполнения
			|ГДЕ
			|	ШаблонЗаполнения.Ссылка В(&Календари)
			|
			|СГРУППИРОВАТЬ ПО
			|	ШаблонЗаполнения.Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Календари.Ссылка КАК ГрафикРаботы,
			|	ДанныеПроизводственногоКалендаря.Дата КАК ДатаГрафика,
			|	ДанныеПроизводственногоКалендаря.ДатаПереноса,
			|	ВЫБОР
			|		КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК ПредпраздничныйДень
			|ПОМЕСТИТЬ ВТСведенияПоКалендарю
			|ИЗ
			|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
			|		ПО ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = Календари.ПроизводственныйКалендарь
			|			И (Календари.Ссылка В (&Календари))
			|			И (ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания)
			|			И (ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
			|				ИЛИ ДанныеПроизводственногоКалендаря.ДатаПереноса <> ДАТАВРЕМЯ(1, 1, 1))
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КалендарныеГрафики.Календарь КАК ГрафикРаботы,
			|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика,
			|	РАЗНОСТЬДАТ(Календари.ДатаОтсчета, КалендарныеГрафики.ДатаГрафика, ДЕНЬ) + 1 КАК ДнейОтДатыОтсчета,
			|	СведенияПоКалендарю.ПредпраздничныйДень,
			|	СведенияПоКалендарю.ДатаПереноса
			|ПОМЕСТИТЬ ВТДниВключенныеВГрафик
			|ИЗ
			|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
			|		ПО КалендарныеГрафики.Календарь = Календари.Ссылка
			|			И (КалендарныеГрафики.Календарь В (&Календари))
			|			И (КалендарныеГрафики.ДатаГрафика МЕЖДУ &ДатаНачала И &ДатаОкончания)
			|			И (КалендарныеГрафики.ДеньВключенВГрафик)
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияПоКалендарю КАК СведенияПоКалендарю
			|		ПО (СведенияПоКалендарю.ГрафикРаботы = КалендарныеГрафики.Календарь)
			|			И (СведенияПоКалендарю.ДатаГрафика = КалендарныеГрафики.ДатаГрафика)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДниВключенныеВГрафик.ГрафикРаботы КАК ГрафикРаботы,
			|	ДниВключенныеВГрафик.ДатаГрафика,
			|	ВЫБОР
			|		КОГДА ДниВключенныеВГрафик.РезультатДеленияПоМодулю = 0
			|			ТОГДА ДниВключенныеВГрафик.ДлинаЦикла
			|		ИНАЧЕ ДниВключенныеВГрафик.РезультатДеленияПоМодулю
			|	КОНЕЦ КАК НомерДня,
			|	ДниВключенныеВГрафик.ПредпраздничныйДень
			|ПОМЕСТИТЬ ВТДатыНомераДней
			|ИЗ
			|	(ВЫБРАТЬ
			|		ДниВключенныеВГрафик.ГрафикРаботы КАК ГрафикРаботы,
			|		ДниВключенныеВГрафик.ДатаГрафика КАК ДатаГрафика,
			|		ДниВключенныеВГрафик.ПредпраздничныйДень КАК ПредпраздничныйДень,
			|		ДниВключенныеВГрафик.ДлинаЦикла КАК ДлинаЦикла,
			|		ДниВключенныеВГрафик.ДнейОтДатыОтсчета - ДниВключенныеВГрафик.ЦелаяЧастьРезультатаДеления * ДниВключенныеВГрафик.ДлинаЦикла КАК РезультатДеленияПоМодулю
			|	ИЗ
			|		(ВЫБРАТЬ
			|			ДниВключенныеВГрафик.ГрафикРаботы КАК ГрафикРаботы,
			|			ДниВключенныеВГрафик.ДатаГрафика КАК ДатаГрафика,
			|			ДниВключенныеВГрафик.ПредпраздничныйДень КАК ПредпраздничныйДень,
			|			ДниВключенныеВГрафик.ДнейОтДатыОтсчета КАК ДнейОтДатыОтсчета,
			|			ДлинаЦиклов.ДлинаЦикла КАК ДлинаЦикла,
			|			(ВЫРАЗИТЬ(ДниВключенныеВГрафик.ДнейОтДатыОтсчета / ДлинаЦиклов.ДлинаЦикла КАК ЧИСЛО(15, 0))) - ВЫБОР
			|				КОГДА (ВЫРАЗИТЬ(ДниВключенныеВГрафик.ДнейОтДатыОтсчета / ДлинаЦиклов.ДлинаЦикла КАК ЧИСЛО(15, 0))) > ДниВключенныеВГрафик.ДнейОтДатыОтсчета / ДлинаЦиклов.ДлинаЦикла
			|					ТОГДА 1
			|				ИНАЧЕ 0
			|			КОНЕЦ КАК ЦелаяЧастьРезультатаДеления
			|		ИЗ
			|			ВТДниВключенныеВГрафик КАК ДниВключенныеВГрафик
			|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
			|				ПО ДниВключенныеВГрафик.ГрафикРаботы = Календари.Ссылка
			|					И (Календари.СпособЗаполнения = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины))
			|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДлинаЦиклаГрафиков КАК ДлинаЦиклов
			|				ПО ДниВключенныеВГрафик.ГрафикРаботы = ДлинаЦиклов.ГрафикРаботы) КАК ДниВключенныеВГрафик) КАК ДниВключенныеВГрафик
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДниВключенныеВГрафик.ГрафикРаботы,
			|	ДниВключенныеВГрафик.ДатаГрафика,
			|	ВЫБОР
			|		КОГДА ДниВключенныеВГрафик.ДатаПереноса ЕСТЬ NULL 
			|			ТОГДА ДЕНЬНЕДЕЛИ(ДниВключенныеВГрафик.ДатаГрафика)
			|		ИНАЧЕ ДЕНЬНЕДЕЛИ(ДниВключенныеВГрафик.ДатаПереноса)
			|	КОНЕЦ,
			|	ДниВключенныеВГрафик.ПредпраздничныйДень
			|ИЗ
			|	ВТДниВключенныеВГрафик КАК ДниВключенныеВГрафик
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
			|		ПО ДниВключенныеВГрафик.ГрафикРаботы = Календари.Ссылка
			|ГДЕ
			|	Календари.СпособЗаполнения = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияГрафикаРаботы.ПоНеделям)
			|
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ДниВключенныеВГрафик.ГрафикРаботы,
			|	ДОБАВИТЬКДАТЕ(ДниВключенныеВГрафик.ДатаГрафика,ГОД,%Год%) КАК ДатаГрафика,
			|	ДниВключенныеВГрафик.НомерДня,
			|	ЕСТЬNULL(РасписанияРаботыПредпраздничногоДня.ВремяНачала, РасписанияРаботы.ВремяНачала) КАК ВремяНачала,
			|	ЕСТЬNULL(РасписанияРаботыПредпраздничногоДня.ВремяОкончания, РасписанияРаботы.ВремяОкончания) КАК ВремяОкончания
			|ПОМЕСТИТЬ ВТРасписанияРаботыВрем
			|ИЗ
			|	ВТДатыНомераДней КАК ДниВключенныеВГрафик
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Календари.РасписаниеРаботы КАК РасписанияРаботы
			|		ПО (РасписанияРаботы.Ссылка = ДниВключенныеВГрафик.ГрафикРаботы)
			|			И (РасписанияРаботы.НомерДня = ДниВключенныеВГрафик.НомерДня)
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Календари.РасписаниеРаботы КАК РасписанияРаботыПредпраздничногоДня
			|		ПО (РасписанияРаботыПредпраздничногоДня.Ссылка = ДниВключенныеВГрафик.ГрафикРаботы)
			|			И (РасписанияРаботыПредпраздничногоДня.НомерДня = 0)
			|			И (ДниВключенныеВГрафик.ПредпраздничныйДень)
			|";
			
		
		Если Год(ДатаНачала) = Год(ДатаОкончания) Тогда
				
			ТекГод = Год(ТекущаяДата());
			ГодРасчета = Год(ДатаНачала);
			ДатаНачалаТекГод = ДобавитьМесяц(ДатаНачала,12*(ТекГод - ГодРасчета));
			ДатаОкончанияТекГод = ДобавитьМесяц(ДатаОкончания,12*(ТекГод - ГодРасчета));
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%Год%",Формат(ГодРасчета - ТекГод,"ЧН=0; ЧГ=0"));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВТРасписанияРаботыВрем","ВТРасписанияРаботы");
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
			Запрос.УстановитьПараметр("Календари", Графики);
			Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаТекГод);
			Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончанияТекГод);
			Запрос.Выполнить();
	
		Иначе
			
			ТекДата = ТекущаяДата();
			СмещениеОтТекущейДаты = Год(ДатаНачала) - Год(ТекДата);
			
			ТекстЗапроса = ТекстЗапроса + "
			|;
			|
			|///////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТРасписанияРаботыВрем.ГрафикРаботы КАК ГрафикРаботы,
			|	ДобавитьКДате(ВТРасписанияРаботыВрем.ДатаГрафика,ГОД,"+СмещениеОтТекущейДаты+") КАК ДатаГрафика,
			|	ВТРасписанияРаботыВрем.НомерДня КАК НомерДня,
			|	ВТРасписанияРаботыВрем.ВремяНачала КАК ВремяНачала,
			|	ВТРасписанияРаботыВрем.ВремяОкончания КАК ВремяОкончания
			|ПОМЕСТИТЬ ВТРасписанияРаботы
			|ИЗ
			|	ВТРасписанияРаботыВрем
			|ГДЕ
			|	ДобавитьКДате(ВТРасписанияРаботыВрем.ДатаГрафика,ГОД,"+СмещениеОтТекущейДаты+") >= &ДатаНачалаНастоящая
			|";
			
			// Приводим разницу к годам, аналогично /(60/60/24/365.25)
			КоличествоЛет = ПериодПланирования / 31557600;
			КоличествоЛет = Цел(КоличествоЛет) + ?(Цел(КоличествоЛет)<КоличествоЛет,1,0);
			
			Для Сч = 1 По КоличествоЛет Цикл
				
				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	ВТРасписанияРаботыВрем.ГрафикРаботы,
				|	ДОБАВИТЬКДАТЕ(ВТРасписанияРаботыВрем.ДатаГрафика,ГОД,"+Формат(Сч + СмещениеОтТекущейДаты,"ЧГ=0")+"),
				|	ВТРасписанияРаботыВрем.НомерДня,
				|	ВТРасписанияРаботыВрем.ВремяНачала,
				|	ВТРасписанияРаботыВрем.ВремяОкончания
				|ИЗ
				|	ВТРасписанияРаботыВрем
				|";
				
				Если Сч = КоличествоЛет Тогда
					ТекстЗапроса = ТекстЗапроса + "
					|ГДЕ
					|	ДОБАВИТЬКДАТЕ(ВТРасписанияРаботыВрем.ДатаГрафика,ГОД,"+Формат(Сч + СмещениеОтТекущейДаты,"ЧГ=0")+") <= &ДатаОкончанияНастоящая
					|";
				КонецЕсли;
			КонецЦикла;
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ДОБАВИТЬКДАТЕ(ДниВключенныеВГрафик.ДатаГрафика,ГОД,%Год%) КАК ДатаГрафика","ДниВключенныеВГрафик.ДатаГрафика");
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
			Запрос.УстановитьПараметр("Календари", Графики);
			Запрос.УстановитьПараметр("ДатаНачала", НачалоГода(ТекущаяДата()));
			Запрос.УстановитьПараметр("ДатаОкончания", КонецГода(ТекущаяДата()));
			Запрос.УстановитьПараметр("ДатаНачалаНастоящая", ДатаНачала);
			Запрос.УстановитьПараметр("ДатаОкончанияНастоящая", ДатаОкончания);
			Запрос.Выполнить();

		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти
