#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДатаНачалаЛимита") Тогда
		Объект.ДатаНачалаЛимита = Параметры.ДатаНачалаЛимита;
	КонецЕсли;
	Если Параметры.Свойство("ДатаОкончанияЛимита") Тогда
		Объект.ДатаОкончанияЛимита = Параметры.ДатаОкончанияЛимита;
	КонецЕсли;
	Если Параметры.Свойство("СтруктураПланаРемонтов") Тогда
		Для каждого Стр Из Параметры.СтруктураПланаРемонтов Цикл
			
			НС = Объект.ПланРемонтовКорректировка.Добавить();
			ЗаполнитьЗначенияСвойств(НС, Стр)
			
		КонецЦикла;
	КонецЕсли;
	ЗаполнитьОценкиРМ();
	
	Если Объект.ДатаНачалаЛимита <> Объект.ДатаОкончанияЛимита Тогда
		ДатаТек = Объект.ДатаНачалаЛимита;
		
		Пока ДатаТек <= Объект.ДатаОкончанияЛимита Цикл
			СписокГодов.Добавить(ДатаТек, Формат(ДатаТек, "ЧГ="));
			ДатаТек = ДатаТек + 1;
		КонецЦикла;
		
		ГодКорректировки = Формат(Объект.ДатаНачалаЛимита, "ЧГ=") + " - " + Формат(Объект.ДатаОкончанияЛимита, "ЧГ=");
		
		СписокГодов.Вставить(0,Формат(Объект.ДатаНачалаЛимита, "ЧГ=") + " - " + Формат(Объект.ДатаОкончанияЛимита, "ЧГ="));
		Элементы.ГодКорректировки.СписокВыбора.Очистить();
		Для Каждого ЭлементСписка Из СписокГодов Цикл
			Элементы.ГодКорректировки.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЦикла;
	Иначе
		ГодКорректировки = Объект.ДатаНачалаЛимита;
		Элементы.ГодКорректировки.КнопкаВыпадающегоСписка = Ложь;
	КонецЕсли;
	
	Объект.ПланРемонтовКорректировка.Сортировать("Удалить Возр,СпособВыполнения Убыв, РентабельностьРемонта Возр,СуммаРемонта Убыв, ОбъектРемонтныхРабот Возр, ВидРемонтныхРабот Возр, ДатаНач Возр");
	
	ЗаполнитьСпискиДоступныхОтборов();
	
	ПересчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СписокОрганизаций.Количество() = 1 Тогда
		ОтборОрганизация = СписокОрганизаций[0].Значение;
		ОтборОрганизацияПриИзменении(ОтборОрганизация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОтборНаправление) Тогда
		ОтборНаправление = "<По всем направлениям>";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	ПересчитатьСумму();
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		Элементы.ПланРемонтовКорректировка.ОтборСтрок = Новый ФиксированнаяСтруктура("Организация", ОтборОрганизация);
	Иначе
		Элементы.ПланРемонтовКорректировка.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
	ВремМассив = ТаблицаНаправлений.НайтиСтроки(Новый Структура("Организация",ОтборОрганизация));
	ИскомоеНаправление = Неопределено;
	Если ВремМассив.Количество() Тогда
		ИскомоеНаправление = ВремМассив[0].Направление;
		МассивСтрок = ТаблицаНаправлений.НайтиСтроки(Новый Структура("Организация, Направление",ОтборОрганизация, ИскомоеНаправление));
		Если МассивСтрок.Количество() = ВремМассив.Количество() Тогда
			ОтборНаправление = ИскомоеНаправление;
			ОтборНаправлениеПриИзменении(ОтборНаправление);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПересчитатьСумму();
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.Организации.ФормаВыбора", , Элемент, Объект);
	
	ЭлементОтбора = ФормаВыбора.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ПравоеЗначение = СписокОрганизаций;
	ЭлементОтбора.Использование = Истина;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если не ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для отбора по направлению необходимо вначале выбрать отбор по организации!'"));
		Возврат;
	КонецЕсли;
	
	СписокОтборов = Новый СписокЗначений;
	
	ВремМассив = ТаблицаНаправлений.НайтиСтроки(Новый Структура("Организация",ОтборОрганизация));
	Если ВремМассив.Количество() Тогда
		
		Для каждого Элем Из ВремМассив Цикл
			СписокОтборов.Добавить(Элем.Направление);
		КонецЦикла;
		
	КонецЕсли;
	
	ФормаВыбора = ПолучитьФорму("Справочник.торо_НаправленияОбъектовРемонтныхРабот.ФормаВыбора", Новый Структура("СписокОтбора", СписокОтборов), Элемент, Объект);
	
	ФормаВыбора.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеОчистка(Элемент, СтандартнаяОбработка)
	Элементы.ПланРемонтовКорректировка.ОтборСтрок.Направление.Использование = Ложь;
	ПересчитатьСумму();
	
	Если Не ЗначениеЗаполнено(ОтборНаправление) Тогда
		ОтборНаправление = "<По всем направлениям>";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОтборНаправление) Тогда
		Элементы.ПланРемонтовКорректировка.ОтборСтрок = Новый ФиксированнаяСтруктура("Направление", ОтборНаправление);
	Иначе
		Элементы.ПланРемонтовКорректировка.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	ПересчитатьСумму();
	
	Если Не ЗначениеЗаполнено(ОтборНаправление) Тогда
		ОтборНаправление = "<По всем направлениям>";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГодКорректировкиПриИзменении(Элемент)
	Попытка 
		ГодКорректировки = Число(ГодКорректировки);
		
		СтруктураОтбора = Новый Структура(Элементы.ПланРемонтовКорректировка.ОтборСтрок);
		СтруктураОтбора.Вставить("Год", ГодКорректировки);
		Элементы.ПланРемонтовКорректировка.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	Исключение
	КонецПопытки;
	ПересчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура ГодКорректировкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Число") Тогда
		СтандартнаяОбработка = Ложь;
		ГодКорректировки = ВыбранноеЗначение;
		
		СтруктураОтбора = Новый Структура(Элементы.ПланРемонтовКорректировка.ОтборСтрок);
		Если СтруктураОтбора.Свойство("Год") Тогда
			СтруктураОтбора.Удалить("Год");
		КонецЕсли;
		Элементы.ПланРемонтовКорректировка.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
		
		ПересчитатьСумму();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПланРемонтовКорректировка
&НаКлиенте
Процедура ПланРемонтовКорректировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПланРемонтовКорректировкаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПланРемонтовКорректировкаУдалитьПриИзменении(Элемент)
	ТекДанные = Элементы.ПланРемонтовКорректировка.ТекущиеДанные;
	
	СуммаОстаток = СуммаОстаток + ?(ТекДанные.Удалить,-1,1) * ТекДанные.СуммаРемонта;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Выбрать(Команда)
	МассивУдаления = Объект.ПланРемонтовКорректировка.НайтиСтроки(Новый Структура("Удалить",Истина));
	
	Если МассивУдаления.Количество() <> 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВыбратьЗавершение", ЭтотОбъект, Новый Структура("МассивУдаления", МассивУдаления)), НСтр("ru = 'Пометить выбранные ремонты в документе ППР как отмененные?'"),РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	
	ВыбратьФрагмент(МассивУдаления);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для каждого ТекСтрока из Объект.ПланРемонтовКорректировка Цикл
		ТекСтрока.Удалить = Истина;
	КонецЦикла;
	ПересчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого ТекСтрока из Объект.ПланРемонтовКорректировка Цикл
		ТекСтрока.Удалить = Ложь;
	КонецЦикла;
	ПересчитатьСумму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ПересчитатьСумму()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(торо_ПлановыеРемонтныеРаботыСрезПоследних.СтоимостьРемонта) КАК СтоимостьРемонта
	|ИЗ
	|	РегистрСведений.торо_ПлановыеРемонтныеРаботы.СрезПоследних(
	|			,
	|			НЕ ID В (&СписокID)
	|				И ВЫБОР
	|					КОГДА &Филиал = НЕОПРЕДЕЛЕНО
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ОбъектРемонтныхРабот.Организация = &Филиал
	|				КОНЕЦ
	|				И ВЫБОР
	|					КОГДА &Направление = НЕОПРЕДЕЛЕНО
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ОбъектРемонтныхРабот.Направление = &Направление
	|				КОНЕЦ) КАК торо_ПлановыеРемонтныеРаботыСрезПоследних
	|ГДЕ
	|	торо_ПлановыеРемонтныеРаботыСрезПоследних.Отменен = ЛОЖЬ
	|	И торо_ПлановыеРемонтныеРаботыСрезПоследних.Замещен = ЛОЖЬ
	|	И ГОД(торо_ПлановыеРемонтныеРаботыСрезПоследних.ДатаНачалаРемонтныхРабот) >= &ГодНач
	|	И ГОД(торо_ПлановыеРемонтныеРаботыСрезПоследних.ДатаНачалаРемонтныхРабот) <= &ГодКон";
	
	Запрос.УстановитьПараметр("ГодНач", ?(ТипЗнч(ГодКорректировки) = Тип("Строка"), Объект.ДатаНачалаЛимита, ГодКорректировки));
	Запрос.УстановитьПараметр("ГодКон", ?(ТипЗнч(ГодКорректировки) = Тип("Строка"), Объект.ДатаОкончанияЛимита, ГодКорректировки));
	Запрос.УстановитьПараметр("Направление", ?(ТипЗнч(ОтборНаправление) <> Тип("Строка"), ОтборНаправление, Неопределено));
	Запрос.УстановитьПараметр("Филиал", ?(ЗначениеЗаполнено(ОтборОрганизация), ОтборОрганизация, Неопределено));
	
	СтруктураПоиска = Новый Структура;
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		СтруктураПоиска.Вставить("Организация", ОтборОрганизация);
	КонецЕсли;
	Если ТипЗнч(ОтборНаправление) <> Тип("Строка") И ЗначениеЗаполнено(ОтборНаправление) Тогда
		СтруктураПоиска.Вставить("Направление", ОтборНаправление);
	КонецЕсли;
	
	Если ТипЗнч(ГодКорректировки) <> Тип("Строка") Тогда
		СтруктураПоиска.Вставить("Год", ГодКорректировки);
	КонецЕсли;

	ВремТаб = Объект.ПланРемонтовКорректировка.Выгрузить(СтруктураПоиска);
	
	Запрос.УстановитьПараметр("СписокID",ВремТаб.ВыгрузитьКолонку("ID"));
	
	СтруктураПоиска.Вставить("Удалить",Ложь);
	СтруктураПоиска.Вставить("Отменен",Ложь);
	СтруктураПоиска.Вставить("Замещен",Ложь);
	ВремТаб = Объект.ПланРемонтовКорректировка.Выгрузить(СтруктураПоиска);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() И Выборка.СтоимостьРемонта <> Null Тогда
		СуммаОстаток = Выборка.СтоимостьРемонта;
	Иначе
		СуммаОстаток = 0;
	КонецЕсли;
	
	СуммаОстаток = СуммаОстаток + ВремТаб.Итог("СуммаРемонта");
	
	ПолучитьСуммуЛимита();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуЛимита()
	
	Запрос = новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(торо_ГодовыеЛимитыРемонтныхРаботСрезПоследних.Лимит) КАК Лимит
	|ИЗ
	|	РегистрСведений.торо_ГодовыеЛимитыРемонтныхРабот.СрезПоследних(
	|			,
	|			ВЫБОР
	|					КОГДА &Направление = НЕОПРЕДЕЛЕНО
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Направление = &Направление
	|				КОНЕЦ
	|				И ВЫБОР
	|					КОГДА &Филиал = НЕОПРЕДЕЛЕНО
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Организация = &Филиал
	|				КОНЕЦ
	|				И ГОД(Период) >= &ГодНач
	|				И ГОД(Период) <= &ГодКон) КАК торо_ГодовыеЛимитыРемонтныхРаботСрезПоследних";
	
	Запрос.УстановитьПараметр("ГодНач", ?(ТипЗнч(ГодКорректировки) = Тип("Строка"), Объект.ДатаНачалаЛимита, ГодКорректировки));
	Запрос.УстановитьПараметр("ГодКон", ?(ТипЗнч(ГодКорректировки) = Тип("Строка"), Объект.ДатаОкончанияЛимита, ГодКорректировки));
	Запрос.УстановитьПараметр("Направление", ?(ТипЗнч(ОтборНаправление) <> Тип("Строка") И ЗначениеЗаполнено(ОтборНаправление), ОтборНаправление, Неопределено));
	Запрос.УстановитьПараметр("Филиал", ?(ЗначениеЗаполнено(ОтборОрганизация), ОтборОрганизация, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() тогда
		Если Выборка.Лимит <> Null Тогда
			СуммаЛимит = Выборка.Лимит;
		Иначе
			СуммаЛимит = 0;
		КонецЕсли;
	Иначе
		СуммаЛимит = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиДоступныхОтборов()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_ГодовыеЛимитыРемонтныхРаботСрезПоследних.Организация,
	|	торо_ГодовыеЛимитыРемонтныхРаботСрезПоследних.Направление
	|ИЗ
	|	РегистрСведений.торо_ГодовыеЛимитыРемонтныхРабот.СрезПоследних(
	|			,
	|			ГОД(Период) >= &ГодНач
	|				И ГОД(Период) <= &ГодКон) КАК торо_ГодовыеЛимитыРемонтныхРаботСрезПоследних";
	
	Запрос.УстановитьПараметр("ГодНач", Объект.ДатаНачалаЛимита);
	Запрос.УстановитьПараметр("ГодКон", Объект.ДатаОкончанияЛимита);
	
	Таб = Запрос.Выполнить().Выгрузить();
	Таб.Свернуть("Организация,Направление");
	ТаблицаНаправлений.Загрузить(Таб);
	
	ТабОрг = Таб.Скопировать(,"Организация");
	ТабОрг.Свернуть("Организация");
	
	СписокОрганизаций.ЗагрузитьЗначения(ТабОрг.ВыгрузитьКолонку("Организация"));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОценкиРМ()
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Таб.ID,
	|	Таб.ВидРемонтныхРабот,
	|	Таб.ОбъектРемонтныхРабот,
	|	Таб.датаНач,
	|	Таб.датаКон,
	|	Таб.СпособВыполнения,
	|	Таб.Исполнитель,
	|	Таб.СуммаРемонта,
	|	Таб.Отменен,
	|	Таб.Удалить,
	|	Таб.ГраничныйРемонт,
	|	Таб.Замещен
	|ПОМЕСТИТЬ ИсходнаяТаб
	|ИЗ
	|	&Таб КАК Таб
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходнаяТаб.ID,
	|	ИсходнаяТаб.ВидРемонтныхРабот,
	|	ИсходнаяТаб.ОбъектРемонтныхРабот,
	|	ИсходнаяТаб.датаНач,
	|	ИсходнаяТаб.датаКон,
	|	ИсходнаяТаб.СпособВыполнения,
	|	ИсходнаяТаб.Исполнитель,
	|	ИсходнаяТаб.СуммаРемонта,
	|	ИсходнаяТаб.Отменен,
	|	ИсходнаяТаб.ГраничныйРемонт,
	|	ИсходнаяТаб.Замещен,
	|	торо_ОценкаРМПлановыхРемонтов.ВероятностьВыходаИзСтроя,
	|	торо_ОценкаРМПлановыхРемонтов.Ущерб,
	|	торо_ОбъектыРемонта.Родитель,
	|	торо_ОбъектыРемонта.Организация,
	|	торо_ОбъектыРемонта.Направление,
	|	ВЫБОР
	|		КОГДА ИсходнаяТаб.СуммаРемонта = 0
	|			ТОГДА 0
	|		ИНАЧЕ ЕСТЬNULL(торо_ОценкаРМПлановыхРемонтов.ВероятностьВыходаИзСтроя, 0) / 100 * ЕСТЬNULL(торо_ОценкаРМПлановыхРемонтов.Ущерб, 0) / ИсходнаяТаб.СуммаРемонта
	|	КОНЕЦ КАК РентабельностьРемонта,
	|	ВЫБОР
	|		КОГДА ИсходнаяТаб.СуммаРемонта = 0
	|			ТОГДА ИСТИНА
	|		КОГДА ЕСТЬNULL(торо_ОценкаРМПлановыхРемонтов.ВероятностьВыходаИзСтроя, 0) / 100 * ЕСТЬNULL(торо_ОценкаРМПлановыхРемонтов.Ущерб, 0) = 0
	|			ТОГДА ИСТИНА
	|		КОГДА ИсходнаяТаб.Отменен
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Удалить,
	|	ГОД(ИсходнаяТаб.датаНач) КАК Год
	|ИЗ
	|	ИсходнаяТаб КАК ИсходнаяТаб
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ОценкаРМПлановыхРемонтов КАК торо_ОценкаРМПлановыхРемонтов
	|		ПО (торо_ОценкаРМПлановыхРемонтов.ID = ИсходнаяТаб.ID)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
	|		ПО (торо_ОбъектыРемонта.Ссылка = ИсходнаяТаб.ОбъектРемонтныхРабот)";
	Запрос.УстановитьПараметр("Таб", Объект.ПланРемонтовКорректировка.Выгрузить());
	
	Объект.ПланРемонтовКорректировка.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
        МассивУдаления = Новый Массив;
	Иначе
		МассивУдаления = ДополнительныеПараметры.МассивУдаления;
    КонецЕсли;
    
    ВыбратьФрагмент(МассивУдаления);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФрагмент(Знач МассивУдаления)
    
    Перем МассивПередачи, Элем;
    
    МассивПередачи = Новый Массив;
    Для каждого Элем Из МассивУдаления Цикл
        МассивПередачи.Добавить(Элем.ID);
    КонецЦикла;
    
    Оповестить("КорректировкаППРПоЛимитам", МассивПередачи);
    Закрыть();

КонецПроцедуры

#КонецОбласти