#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ФОИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("торо_ИспользоватьХарактеристикиНоменклатуры");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Если ФОИспользоватьХарактеристикиНоменклатуры = Истина тогда
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ФОИспользоватьСерии = Константы.ИспользоватьСерииНоменклатуры.Получить();
	
	// регистр ТоварыНаСкладах Приход
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Если ТекСтрокаТовары.Номенклатура.ВидНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар 
			или ТекСтрокаТовары.Номенклатура.ВидНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара
			Тогда
			
			Движение = Движения.ТоварыНаСкладах.Добавить();
			Движение.ВидДвижения    = ВидДвиженияНакопления.Приход;
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
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ЭтотОбъект.Движения.ТоварыНаСкладах.Записывать = Истина;
	ЭтотОбъект.Движения.Записать();
КонецПроцедуры

#КонецОбласти

#КонецЕсли