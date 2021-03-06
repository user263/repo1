
#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.торо_ПланГрафикРемонта") Тогда
		ПараметрыФормы = Новый Структура("Документ, ТабЧасть, ОР, ВР, Дата", ПараметрКоманды,"ПланРемонтов", "ОбъектРемонтныхРабот", "ВидРемонтныхРабот", "ДатаКон")
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.торо_АктОВыполненииЭтапаРабот") Тогда
		ПараметрыФормы = Новый Структура("Документ, ТабЧасть, ОР, ВР, Дата", ПараметрКоманды,"РемонтыОборудования", "ОбъектРемонта", "ВидРемонтныхРабот", "ДатаОкончания")
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.торо_НарядНаВыполнениеРемонтныхРабот") Тогда
		ПараметрыФормы = Новый Структура("Документ, ТабЧасть, ОР, ВР, Дата", ПараметрКоманды,"РемонтыОборудования", "ОбъектРемонта", "ВидРемонтныхРабот", "ДатаОкончания")
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.торо_ЗаявкаНаРемонт") Тогда
		ПараметрыФормы = Новый Структура("Документ, ТабЧасть, ОР, ВР, Дата", ПараметрКоманды,"РемонтыОборудования", "ОбъектРемонта", "ВидРемонтныхРабот", "ДатаОкончания")
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.торо_ВыявленныеДефекты") Тогда
		ПараметрыФормы = Новый Структура("Документ, ТабЧасть, ОР, Дата", ПараметрКоманды,"СписокДефектов", "ОбъектРемонта", "ДатаОбнаружения")
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.торо_ФормаСпискаДокументовМТОПоРемонту", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
#КонецОбласти