#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Направление = Параметры.Отбор.Владелец;
	Иначе
		Направление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновноеНаправлениеОР",
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодобратьНаправление();
	НаправлениеПриИзменении(Элементы.Направление);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура НаправлениеПриИзменении(Элемент)
	
	Если Направление = ПредопределенноеЗначение("Справочник.торо_НаправленияОбъектовРемонтныхРабот.ПустаяСсылка") Тогда
		
		Направление = ПредопределенноеЗначение("Справочник.торо_НаправленияОбъектовРемонтныхРабот.БезНаправления");
		
	КонецЕсли;
	
	ЭлементыОтбора = Дерево.Отбор.Элементы;
	Если Направление <> Неопределено Тогда
		
		Если ЭлементыОтбора.Количество() Тогда
			ЭлементыОтбора[0].ПравоеЗначение = Направление;
		Иначе
			НС = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НС.Использование = Истина;
			НС.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
			НС.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НС.ПравоеЗначение = Направление;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеОчистка(Элемент, СтандартнаяОбработка)
	
	ПодобратьНаправление();	
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ПодобратьНаправление()
	
	Если Направление = ПредопределенноеЗначение("Справочник.торо_НаправленияОбъектовРемонтныхРабот.ПустаяСсылка") Тогда
		Направление = ПредопределенноеЗначение("Справочник.торо_НаправленияОбъектовРемонтныхРабот.БезНаправления");		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти