#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОткрыватьПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбщаяФорма.торо_ТекущиеЗадачиТОиР", "ОткрыватьПриЗапуске", Истина);
		
	Если ОткрыватьПриЗапуске И (торо_Согласования.ПроверитьИспользованиеСогласованияДокументов("",Ложь) 
											ИЛИ торо_Согласования.ПроверитьИспользованиеСогласованияДокументов("", Истина)) Тогда 
		
		Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиТОиР", "ОсновнаяОрганизация", Истина);
		ОбновитьЗадачи();
	Иначе 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьЗадачи();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ОткрыватьПриЗапускеПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ОбщаяФорма.торо_ТекущиеЗадачиТОиР", "ОткрыватьПриЗапуске", ОткрыватьПриЗапуске);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыОснования

&НаКлиенте
Процедура ТекущиеЗадачиСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.ТекущиеЗадачиСписок.ТекущиеДанные;
	
	Если Не ДанныеСтроки = Неопределено Тогда
		ПоказатьЗначение(,ДанныеСтроки.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьЗадачи()
	
	ТаблицаСОтображаемымиДокументами = Новый ТаблицаЗначений;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	торо_СтатусыСогласованияДокументовРемонтныхРабот.Документ,
	|	МИНИМУМ(торо_СтатусыСогласованияДокументовРемонтныхРабот.Порядок) КАК Порядок
	|ПОМЕСТИТЬ ТекущийПорядок
	|ИЗ
	|	РегистрСведений.торо_СтатусыСогласованияДокументовРемонтныхРабот КАК торо_СтатусыСогласованияДокументовРемонтныхРабот
	|ГДЕ
	|	(торо_СтатусыСогласованияДокументовРемонтныхРабот.Организация = &Организация ИЛИ &Организация = Значение(Справочник.Организации.ПустаяСсылка))
	|	И торо_СтатусыСогласованияДокументовРемонтныхРабот.Дата = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	торо_СтатусыСогласованияДокументовРемонтныхРабот.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	торо_СтатусыСогласованияДокументовРемонтныхРабот.Документ
	|ИЗ
	|	ТекущийПорядок КАК ТекущийПорядок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_СтатусыСогласованияДокументовРемонтныхРабот КАК торо_СтатусыСогласованияДокументовРемонтныхРабот
	|		ПО ТекущийПорядок.Документ = торо_СтатусыСогласованияДокументовРемонтныхРабот.Документ
	|			И ТекущийПорядок.Порядок = торо_СтатусыСогласованияДокументовРемонтныхРабот.Порядок
	|ГДЕ
	|	торо_СтатусыСогласованияДокументовРемонтныхРабот.Пользователь = &Пользователь
	|	И торо_СтатусыСогласованияДокументовРемонтныхРабот.Дата = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И (торо_СтатусыСогласованияДокументовРемонтныхРабот.Организация = &Организация ИЛИ &Организация = Значение(Справочник.Организации.ПустаяСсылка))
	|	И (НЕ торо_СтатусыСогласованияДокументовРемонтныхРабот.НеНапоминать)";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ТекущиеЗадачиСписок.Очистить();
	
	МассивДобавляемых = ПроверитьВыборкуНаВозможностьДобавленияЗадач(Выборка);
	
	Для Каждого Документ Из МассивДобавляемых Цикл
		
		НоваяЗадача = ТекущиеЗадачиСписок.Добавить();
		НоваяЗадача.ТекстСписка	= "Согласовать документ " + Документ;
		НоваяЗадача.Ссылка = Документ;
		
	КонецЦикла;
	
	Элементы.ТекущиеЗадачиСписок.Обновить();
		
КонецПроцедуры

&НаСервере
Функция ПроверитьВыборкуНаВозможностьДобавленияЗадач(Выборка)
	
	МассивВозвращаемый = Новый Массив;
	
	Если Выборка.Количество() > 0 Тогда
		ФОИспользоватьМероприятия = ПолучитьФункциональнуюОпцию("торо_ИспользоватьРегламентныеМероприятия");
		ФОИспользоватьВнешниеОснования = ПолучитьФункциональнуюОпцию("торо_ИспользоватьВнешниеОснованияДляРабот");
		ФОИспользоватьДефекты = ПолучитьФункциональнуюОпцию("торо_УчетВыявленныхДефектовОборудования");
		ФОИспользоватьЗаявки = ПолучитьФункциональнуюОпцию("торо_ИспользоватьСметыРемонта");
		ФОИспользоватьНаряды = ПолучитьФункциональнуюОпцию("торо_ИспользоватьНарядыНаВыполнениеРабот");
		ФОИспользоватьПланГрафикРемонта = ПолучитьФункциональнуюОпцию("торо_ИспользоватьППР");
		ФОИспользоватьОстановочныеРемонты = ПолучитьФункциональнуюОпцию("торо_ИспользоватьОстановочныеРемонты");
		ФОИспользоватьАктПриемкиОборудования = ПолучитьФункциональнуюОпцию("торо_ИспользоватьАктПриемкиОборудования");
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_АктОВыполненииЭтапаРабот;
		мИспользоватьСогласованияДляАктаОВыполненииРабот = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_ВнешнееОснованиеДляРабот;
		мИспользоватьСогласованияДляВнешнихОснований = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_ВыявленныеДефекты;
		мИспользоватьСогласованияДляДефектов = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_ЗаявкаНаРемонт;
		мИспользоватьСогласованияДляЗаявок = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_НарядНаВыполнениеРемонтныхРабот;
		мИспользоватьСогласованияДляНарядовНаРемРаботы = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_ПланГрафикРемонта;
		мИспользоватьСогласованияДляПланГрафикРемонта = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияМероприятий.торо_АктОВыполненииРегламентногоМероприятия;
		мИспользоватьСогласованияДляАктовОВыполненииМероприятий = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента, Истина);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияМероприятий.торо_ГрафикРегламентныхМероприятийТОиР;
		мИспользоватьСогласованияДляГрафиковМероприятий = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента, Истина);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияМероприятий.торо_НарядНаРегламентноеМероприятие;
		мИспользоватьСогласованияДляНарядовНаМероприятия = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента, Истина);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_ОстановочныеРемонты;
		мИспользоватьСогласованияДляОстановочныхРемонтов = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ВидДокумента = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_АктПриемкиОборудования;
		мИспользоватьСогласованияДляАктовПриемкиОборудования = торо_Согласования.ПроверитьИспользованиеСогласованияДокументов(ВидДокумента);
		
		ПолучатьАктыОВыполненииЭтаповРабот = мИспользоватьСогласованияДляАктаОВыполненииРабот;
		ПолучатьАктыОВыполненииРегламентныхМероприятий = ФОИспользоватьМероприятия И мИспользоватьСогласованияДляАктовОВыполненииМероприятий;
		ПолучатьВнешниеОснованияДляРабот = ФОИспользоватьВнешниеОснования И мИспользоватьСогласованияДляВнешнихОснований;
		ПолучатьВыявленныеДефекты = ФОИспользоватьДефекты И мИспользоватьСогласованияДляДефектов;
		ПолучатьГрафикиРегламентныхМероприятий = ФОИспользоватьМероприятия И мИспользоватьСогласованияДляГрафиковМероприятий;
		ПолучатьЗаявкиНаРемонт = ФОИспользоватьЗаявки И мИспользоватьСогласованияДляЗаявок;
		ПолучатьНарядыНаВыполнениеРемонтныхРабот = ФОИспользоватьНаряды И мИспользоватьСогласованияДляНарядовНаРемРаботы;
		ПолучатьНарядыНаРегламентныеМероприятия = ФОИспользоватьМероприятия И мИспользоватьСогласованияДляНарядовНаМероприятия;
		ПолучатьПланыГрафикиРемонта = ФОИспользоватьПланГрафикРемонта и мИспользоватьСогласованияДляПланГрафикРемонта;
		ПолучатьОстановочныеРемонты = ФОИспользоватьОстановочныеРемонты и мИспользоватьСогласованияДляОстановочныхРемонтов;
		ПолучатьАктыПриемкиОборудования = ФОИспользоватьАктПриемкиОборудования и мИспользоватьСогласованияДляАктовПриемкиОборудования;
		
		Пока Выборка.Следующий() Цикл
			
			Документ = Выборка.Документ;
			
			Если ТипЗнч(Документ) = Тип("ДокументСсылка.торо_АктОВыполненииЭтапаРабот") 
					И ПолучатьАктыОВыполненииЭтаповРабот Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_АктОВыполненииРегламентногоМероприятия")
					И ПолучатьАктыОВыполненииРегламентныхМероприятий Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ВнешнееОснованиеДляРабот")
					И ПолучатьВнешниеОснованияДляРабот Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ВыявленныеДефекты") 
					И ПолучатьВыявленныеДефекты Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ГрафикРегламентныхМероприятийТОиР") 
					И ПолучатьГрафикиРегламентныхМероприятий Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ЗаявкаНаРемонт") 
					И ПолучатьЗаявкиНаРемонт Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_НарядНаВыполнениеРемонтныхРабот")
					И ПолучатьНарядыНаВыполнениеРемонтныхРабот Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_НарядНаРегламентноеМероприятие") 
					И ПолучатьНарядыНаРегламентныеМероприятия Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ПланГрафикРемонта") 
					И ПолучатьПланыГрафикиРемонта Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_ОстановочныеРемонты") 
					И ПолучатьОстановочныеРемонты Тогда
				МассивВозвращаемый.Добавить(Документ);
			ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.торо_АктПриемкиОборудования") 
					И ПолучатьАктыПриемкиОборудования Тогда
				МассивВозвращаемый.Добавить(Документ);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивВозвращаемый;
	
КонецФункции	

#КонецОбласти