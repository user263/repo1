#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ

Перем ОткрытИзФормыОР Экспорт; // Переменная показывает что документ был открыт из формы объекта ремонта.
Перем БезусловнаяЗапись Экспорт; // Отключает проверки при записи документа

Перем ОРВладелец Экспорт; // Переменная хранит объект ремонта владельца документа.
перем СтруктураДанных Экспорт;  // Структура, хранящая данные для работы с уведомлениями.


#Область ОбработчикиСобытий
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
		ОбъектРемонта = ДанныеЗаполнения;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ТоварыНаСкладах Приход
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаНоменклатура Из Номенклатура Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения    = ВидДвиженияНакопления.Приход;
		Движение.Период         = Дата;
		Движение.Номенклатура   = ТекСтрокаНоменклатура.Номенклатура;
		Движение.Характеристика = ТекСтрокаНоменклатура.ХарактеристикаНоменклатуры;
		Движение.Склад          = ТекСтрокаНоменклатура.Склад;
		Движение.ВНаличии       = ТекСтрокаНоменклатура.Количество;
	КонецЦикла;
	
	// регистр торо_СтатусыОбъектовРемонтаВУчете
	
	
	Движения.торо_СтатусыОбъектовРемонтаВУчете.Записывать = Истина;
	
	НаборЗаписей = Движения.торо_СтатусыОбъектовРемонтаВУчете;
	 	
	НС = НаборЗаписей.Добавить();
	НС.ОбъектРемонта     = ОбъектРемонта;
	НС.Период            = ДатаСписания;
	НС.СтатусОР          = Перечисления.торо_СтатусыОРВУчете.СнятоСУчета;
	
	Для каждого Строка Из СписокПодчиненныхСнятыхСУчета Цикл
		
		НС = НаборЗаписей.Добавить();
		НС.ОбъектРемонта     = Строка.ОбъектРемонта;
		НС.Период            = ДатаСписания;
		НС.СтатусОР          = Перечисления.торо_СтатусыОРВУчете.СнятоСУчета;

	КонецЦикла;
	
	Попытка
		
		Если Не ОткрытИзФормыОР Тогда
			
			ОбъектРемонтаОбъект = ОбъектРемонта.ПолучитьОбъект();
						
			Структура = РегистрыСведений.торо_НастройкиДоступностиОбъектовРемонта.Получить(Новый Структура("СтатусОРВУчете",Перечисления.торо_СтатусыОРВУчете.СнятоСУчета));
			
			Если Не Структура = Неопределено Тогда
				
				ОбъектРемонтаОбъект.НеУчаствуетВПланировании = Структура.ЗначениеПоУмолчанию;
				
			КонецЕсли;
			ОбъектРемонтаОбъект.Записать();
			
		КонецЕсли;
	Исключение
		Отказ = Истина;
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Запись не выполнена.'"));
	КонецПопытки; 

	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	 	
	Если ОткрытИзФормыОР = Неопределено Тогда
		ОткрытИзФормыОР = Ложь;
	КонецЕсли; 
	
	Если Не БезусловнаяЗапись Тогда
		Отказ = ПроверкаПередПроведением();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Попытка
		
		СписокОбъектов = Новый СписокЗначений;
		СписокОбъектов.Добавить(ОбъектРемонта);
		
		Для каждого ОР Из СписокПодчиненныхСнятыхСУчета Цикл
			СписокОбъектов.Добавить(ОР.ОбъектРемонта);
		КонецЦикла;
		
		Для каждого Элемент Из СписокОбъектов Цикл
			Если Не ОткрытИзФормыОР
				ИЛИ Не Элемент.Значение = ОРВладелец Тогда
				
				ОбъектРемонтаОбъект = Элемент.Значение.ПолучитьОбъект();			
				Структура = РегистрыСведений.торо_НастройкиДоступностиОбъектовРемонта.Получить(Новый Структура("СтатусОРВУчете",Перечисления.торо_СтатусыОРВУчете.ПринятоКУчету));
				
				Если Не Структура = Неопределено Тогда
					
					ОбъектРемонтаОбъект.НеУчаствуетВПланировании = Структура.ЗначениеПоУмолчанию;
					
				КонецЕсли;
				ОбъектРемонтаОбъект.Записать();
				
			КонецЕсли;
		КонецЦикла; 
		
	Исключение
		Отказ = Истина;
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Запись не выполнена.'"));
	КонецПопытки; 

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПроверкаПередПроведением()
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(ОбъектРемонта) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено обязательное для заполнения поле ""Объект ремонта""'");
		Сообщение.Поле  = "ОбъектРемонта";
		Сообщение.УстановитьДанные(ЭтотОбъект);

		Сообщение.Сообщить(); 
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаСписания) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено обязательное для заполнения поле ""Дата списания""'");
		Сообщение.Поле  = "ДатаСписания";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить(); 
	КонецЕсли;

	Для каждого Строка Из Номенклатура Цикл
		Если Не ЗначениеЗаполнено(Строка.Склад) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В строке %1 табличной части <Номенклатура> не заполнено поле <Склад>.'"),Строка.НомерСтроки);
			Сообщение.Поле  = "Номенклатура[" + (Строка.НомерСтроки - 1) + "].Склад";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить(); 
			
		КонецЕсли; 
	КонецЦикла; 
	
	
	Если Отказ Тогда
		Возврат Отказ;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	торо_СтатусыОбъектовРемонтаВУчете.Период,
	               |	торо_СтатусыОбъектовРемонтаВУчете.Регистратор КАК Регистратор,
	               |	торо_СтатусыОбъектовРемонтаВУчете.ОбъектРемонта,
	               |	торо_СтатусыОбъектовРемонтаВУчете.СтатусОР,
	               |	ВЫБОР
	               |		КОГДА торо_СтатусыОбъектовРемонтаВУчете.Период > &ДатаВводаВЭксплуатацию
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
				   
	               |	КОНЕЦ КАК ЭтоДокументПосле
	               |ИЗ
	               |	РегистрСведений.торо_СтатусыОбъектовРемонтаВУчете КАК торо_СтатусыОбъектовРемонтаВУчете
	               |ГДЕ
	               |	торо_СтатусыОбъектовРемонтаВУчете.ОбъектРемонта = &ОбъектРемонта
	               |	И торо_СтатусыОбъектовРемонтаВУчете.Регистратор <> &Регистратор";
	
	Запрос.УстановитьПараметр("ОбъектРемонта"         , ОбъектРемонта);
	Запрос.УстановитьПараметр("ДатаВводаВЭксплуатацию", ДатаСписания);
	Запрос.УстановитьПараметр("Регистратор"           , Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		тзРезультат = Результат.Выгрузить();
		// проверка на наличие уже установленных состояний
		СтруктураПоиска = Новый Структура("ЭтоДокументПосле", Ложь);
		ВспомогательнаяТаблица = тзРезультат.Скопировать(СтруктураПоиска);
		Если ВспомогательнаяТаблица.Количество() > 0 Тогда
			
			ВспомогательнаяТаблица.Сортировать("Период Убыв");
			
			Если ВспомогательнаяТаблица[0].СтатусОР = Перечисления.торо_СтатусыОРВУчете.СнятоСУчета Тогда
				Отказ = Истина;
				торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для объекта ремонта <%1> уже зафиксировано состояние <Снято с учета> документом %2. Дата состояния: %3.'"),
					ОбъектРемонта,ВспомогательнаяТаблица[0].Регистратор,ВспомогательнаяТаблица[0].Период));
			КонецЕсли; 

		КонецЕсли; 
		
		// проверка на наличие документов после указанный даты ввода в эксплуатацию
		
		СтруктураПоиска = Новый Структура("ЭтоДокументПосле", Истина);
		ВспомогательнаяТаблица = тзРезультат.Скопировать(СтруктураПоиска);
		Если ВспомогательнаяТаблица.Количество() > 0 Тогда
			Отказ = Истина;
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для объекта ремонта <%1> имеются более поздние документы'"),
				ОбъектРемонта));
		КонецЕсли; 

		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

БезусловнаяЗапись = Ложь;

#КонецОбласти

#КонецЕсли