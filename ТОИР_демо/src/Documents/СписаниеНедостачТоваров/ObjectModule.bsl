#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ФОИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("торо_ИспользоватьХарактеристикиНоменклатуры");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Если ФОИспользоватьХарактеристикиНоменклатуры = Истина тогда
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	КонецЕсли;
	
	ФОИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Серия");
	Если ФОИспользоватьСерииНоменклатуры = Истина тогда
		НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												Отказ,
												МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ФОИспользоватьСерии = Константы.ИспользоватьСерииНоменклатуры.Получить();

	// регистр ТоварыНаСкладах Приход
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Если ТекСтрокаТовары.Номенклатура.ВидНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
			
			Движение = Движения.ТоварыНаСкладах.Добавить();
			Движение.ВидДвижения    = ВидДвиженияНакопления.Расход;
			Движение.Период         = Дата;
			Движение.Номенклатура   = ТекСтрокаТовары.Номенклатура;
			Движение.Характеристика = ТекСтрокаТовары.Характеристика;
			Движение.Склад          = Склад;
			Движение.ВНаличии       = ТекСтрокаТовары.Количество;
			
			Если ФОИспользоватьСерии Тогда
				Движение.Серия      = ТекСтрокаТовары.Серия;
			КонецЕсли;	
			
		КонецЕсли;	
	КонецЦикла;
	
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.Записать();

	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ТабТовары.Номенклатура,
	               |	ТабТовары.Характеристика,
	               |	ТабТовары.Серия
	               |ПОМЕСТИТЬ ТабТовары
	               |ИЗ
	               |	&ТабТовары КАК ТабТовары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТабТовары.Номенклатура,
	               |	ТабТовары.Характеристика,
	               |	ТабТовары.Серия,
	               |	СУММА(ЕСТЬNULL(ТоварыНаСкладахОстатки.ВНаличииОстаток, 0)) КАК ВНаличииОстаток,
	               |	ВЫРАЗИТЬ(ТабТовары.Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения КАК ЕдиницаИзмерения
	               |ИЗ
	               |	ТабТовары КАК ТабТовары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(
	               |				&Дата,
	               |				Склад = &Склад
	               |					И (Номенклатура, Серия, Характеристика) В
	               |						(ВЫБРАТЬ
	               |							Таблица.Номенклатура,
	               |							Таблица.Серия,
	               |							Таблица.Характеристика
	               |						ИЗ
	               |							ТабТовары КАК Таблица)) КАК ТоварыНаСкладахОстатки
	               |		ПО ТабТовары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
	               |			И ТабТовары.Характеристика = ТоварыНаСкладахОстатки.Характеристика
	               |			И (&Серия)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТабТовары.Серия,
	               |	ТабТовары.Характеристика,
	               |	ТабТовары.Номенклатура";
	
	Запрос.УстановитьПараметр("ТабТовары",	Товары.Выгрузить());
	Запрос.УстановитьПараметр("Склад",		Склад);
	Запрос.УстановитьПараметр("Дата",		Дата + 1);
	
	Если Не ФОИспользоватьСерии Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабТовары.Серия,", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Таблица.Серия,", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Серия,", ""); 
		Запрос.УстановитьПараметр("Серия", Истина);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Серия", "ТабТовары.Серия = ТоварыНаСкладахОстатки.Серия");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВНаличииОстаток < 0 Тогда
			ШаблонСообщения = "Номенклатура %Номенклатура% / %Характеристика% /%Серия%.
			|Превышен свободный остаток товара на складе %СкладОтправитель% на %Количество% %ЕдИзм%";
			
			
			ШаблонСообщения = СтрЗаменить(ШаблонСообщения,"%Номенклатура%",     Выборка.Номенклатура);				
			ШаблонСообщения = СтрЗаменить(ШаблонСообщения,"%Характеристика%",   Выборка.Характеристика);
			ШаблонСообщения = СтрЗаменить(ШаблонСообщения,"%СкладОтправитель%", Склад);
			ШаблонСообщения = СтрЗаменить(ШаблонСообщения,"%Количество%",       - Число(Выборка.ВналичииОстаток));
			ШаблонСообщения = СтрЗаменить(ШаблонСообщения,"%ЕдИзм%",            Выборка.ЕдиницаИзмерения);
			
			Если Не ФОИспользоватьСерии Тогда 				
				ШаблонСообщения = СтрЗаменить(ШаблонСообщения, " /%Серия%", "");
			Иначе 
				ШаблонСообщения = СтрЗаменить(ШаблонСообщения,"%Серия%"					, Выборка.Серия); 				
			КонецЕсли;   
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ШаблонСообщения,ЭтотОбъект,"Склад",,Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если Не Константы.торо_ИспользоватьКонтрольОтрицательныхОстатков.Получить() Тогда
		Отказ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ЭтотОбъект.Движения.ТоварыНаСкладах.Записывать = Истина;
	ЭтотОбъект.Движения.Записать();
КонецПроцедуры

#КонецОбласти

#КонецЕсли
