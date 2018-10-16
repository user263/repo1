#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если (Запись.ВидДвижения = ВидДвиженияНакопления.Расход И Запись.ВНаличии <> 0)
		 Или (Запись.ВидДвижения = ВидДвиженияНакопления.Приход И Запись.КОтгрузке <> 0)Тогда
			ТребуетсяКонтроль = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Склад,"КонтролироватьОперативныеОстатки");
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если Не ТребуетсяКонтроль Тогда
		ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыВЯчейкахЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.ВНаличии
	|		ИНАЧЕ -Таблица.ВНаличии
	|	КОНЕЦ КАК ВНаличииПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыНаСкладахПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И (НЕ &ЭтоНовый)
	|	И Таблица.КонтролироватьОстатки";
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика КАК Характеристика,
	|	ТаблицаИзменений.Серия КАК Серия,
	|	ТаблицаИзменений.Склад КАК Склад,
	|	ТаблицаИзменений.Помещение КАК Помещение,
	|	СУММА(ТаблицаИзменений.ВНаличииИзменение) КАК ВНаличииИзменение,
	|	СУММА(ТаблицаИзменений.КОтгрузкеИзменение) КАК КОтгрузкеИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыНаСкладахИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Номенклатура КАК Номенклатура,
	|		Таблица.Характеристика КАК Характеристика,
	|		Таблица.Серия КАК Серия,
	|		Таблица.Склад КАК Склад,
	|		Таблица.Помещение КАК Помещение,
	|		Таблица.ВНаличииПередЗаписью КАК ВНаличииИзменение,
	|		Таблица.КОтгрузкеПередЗаписью КАК КОтгрузкеИзменение
	|	ИЗ
	|		ДвиженияТоварыНаСкладахПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.Серия,
	|		Таблица.Склад,
	|		Таблица.Помещение,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.ВНаличии
	|			ИНАЧЕ Таблица.ВНаличии
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КОтгрузке
	|			ИНАЧЕ Таблица.КОтгрузке
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И Таблица.КонтролироватьОстатки) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Склад,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Серия,
	|	ТаблицаИзменений.Помещение
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ТаблицаИзменений.ВНаличииИзменение) > 0
	|		ИЛИ СУММА(ТаблицаИзменений.КОтгрузкеИзменение) < 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияТоварыНаСкладахПередЗаписью";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияТоварыНаСкладахИзменение", Выборка.Количество > 0);

КонецПроцедуры

#КонецОбласти

#КонецЕсли