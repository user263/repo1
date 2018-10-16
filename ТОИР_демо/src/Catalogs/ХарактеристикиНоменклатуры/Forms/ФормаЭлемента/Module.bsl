#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ВидНоменклатуры,"ИспользованиеХарактеристик"); 
	
	Если РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
		Если РеквизитыВладельца.ИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры И Параметры.ВидНоменклатуры <> Справочники.ВидыНоменклатуры.ПустаяСсылка() Тогда
			Объект.Владелец = Параметры.ВидНоменклатуры;
		ИначеЕсли РеквизитыВладельца.ИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры И ЗначениеЗаполнено(Параметры.Владелец) Тогда
			Объект.Владелец = Параметры.Владелец;
		ИначеЕсли ЗначениеЗаполнено(Параметры.Владелец) Тогда
			Объект.Владелец = Параметры.Владелец;
		КонецЕсли;	
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Контекст = Новый Структура();
	Контекст.Вставить("Объект", Объект);
	Контекст.Вставить("ИмяЭлементаДляРазмещения",   "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Контекст);
	// Конец СтандартныеПодсистемы.Свойства

	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ВидНоменклатуры");
		Элементы.Владелец.Заголовок = НСтр("ru='Номенклатура'");
		Номенклатура = Объект.Владелец;
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		ВидНоменклатуры = Объект.Владелец;
		Элементы.Владелец.Заголовок = НСтр("ru='Вид номенклатуры'");
	КонецЕсли;
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		ВидНоменклатуры = Объект.Владелец.ВидНоменклатуры;
		Элементы.Владелец.Заголовок = НСтр("ru='Номенклатура'");
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		ВидНоменклатуры = Объект.Владелец;
		Элементы.Владелец.Заголовок = НСтр("ru='Вид номенклатуры'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства
#КонецОбласти