
&НаКлиенте
Перем ОбъектИерархии;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	Если Параметры.Свойство("СтруктураИерархии") Тогда
		Объект.СтруктураИерархии = Параметры.СтруктураИерархии;
		
		Если Параметры.Свойство("ОбъектИерархии") И ЗначениеЗаполнено(Параметры.ОбъектИерархии) Тогда
		
			Если ТипЗнч(Параметры.ОбъектИерархии) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
				
				НС = Объект.ПоложенияВСтруктуреИерархии.Добавить();
				НС.ОбъектИерархии	   = Параметры.ОбъектИерархии;
				НС.РодительИерархии	   = ?(ТипЗнч(Параметры.РодительИерархии) = Тип("СправочникСсылка.торо_ОбъектыРемонта"), Параметры.РодительИерархии, Справочники.торо_ОбъектыРемонта.ПустаяСсылка());
				НС.ПредыдущееПоложение = торо_РаботаСИерархией.ПолучитьТекущихРодителейВИерархии(Параметры.ОбъектИерархии,Объект.СтруктураИерархии)[Параметры.ОбъектИерархии];
				
			ИначеЕсли ТипЗнч(Параметры.ОбъектИерархии) = Тип("Массив") Тогда	
				
				СоответствиеОРИРодителей = торо_РаботаСИерархией.ПолучитьТекущихРодителейВИерархии(Параметры.ОбъектИерархии,Объект.СтруктураИерархии);
				
				Для Каждого КлючИЗначение Из СоответствиеОРИРодителей Цикл
					
					НС = Объект.ПоложенияВСтруктуреИерархии.Добавить();
					НС.ОбъектИерархии	   = КлючИЗначение.Ключ;
					НС.РодительИерархии	   =  ?(ТипЗнч(Параметры.РодительИерархии) = Тип("СправочникСсылка.торо_ОбъектыРемонта"), Параметры.РодительИерархии, Справочники.торо_ОбъектыРемонта.ПустаяСсылка());
					НС.ПредыдущееПоложение = КлючИЗначение.Значение;
					
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(Параметры.ОбъектИерархии) = Тип("Структура") Тогда
				
				Ветка = торо_РаботаСИерархией.ПолучитьТекущихРодителейВИерархии(
					Параметры.ОбъектИерархии.МассивОР, 
					Параметры.ОбъектИерархии.Иерархия,
					Неопределено, Параметры.ОбъектИерархии.КореньВетки);
				
				тз = Новый ТаблицаЗначений;
				тз.Колонки.Добавить("Ключ", Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта"));
				тз.Колонки.Добавить("Значение", Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта"));
				КореньВетки = Параметры.ОбъектИерархии.КореньВетки;
				Для Каждого текОР Из Ветка Цикл
					нс = тз.Добавить();
					
					Значение = Неопределено;
					Если КореньВетки <> текОР.Ключ И типЗнч(текОР.Значение) <> Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
						
						Наименование = текОР.Значение.Наименование;
						Элемент = Справочники.торо_ОбъектыРемонта.НайтиПоНаименованию(Наименование);
						Если НЕ ЗначениеЗаполнено(Элемент) Тогда
							Элемент = Справочники.торо_ОбъектыРемонта.СоздатьГруппу();
							Элемент.Наименование = Наименование;
							Элемент.Записать();
							Значение = Элемент.Ссылка;
						Иначе
							Значение = Элемент;
						КонецЕсли;
					КонецЕсли;
					
					Ключ = Неопределено;
					Если типЗнч(текОР.Ключ) <> Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
						
						Наименование = текОР.Ключ.Наименование;
						Элемент = Справочники.торо_ОбъектыРемонта.НайтиПоНаименованию(Наименование);
						Если НЕ ЗначениеЗаполнено(Элемент) Тогда
							Элемент = Справочники.торо_ОбъектыРемонта.СоздатьГруппу();
							Элемент.Наименование = Наименование;
							Элемент.Записать();
							Ключ = Элемент.Ссылка;
						Иначе
							Ключ = Элемент;
						КонецЕсли;
					КонецЕсли;
					
					нс.Значение = ?(ЗначениеЗаполнено(Значение), Значение, текОР.значение);
					нс.Ключ = ?(ЗначениеЗаполнено(Ключ), Ключ, текОР.Ключ);
					
					Если КореньВетки = текОР.Ключ Тогда
						КореньВетки = нс.Ключ;
					КонецЕсли;
				КонецЦикла;				
				
				Для Каждого КлючИЗначение Из тз Цикл
					
					НС = Объект.ПоложенияВСтруктуреИерархии.Добавить();
					НС.ОбъектИерархии	   = КлючИЗначение.Ключ;
					НС.РодительИерархии	   = 
						?(КлючИЗначение.Ключ = КореньВетки, 
							?(ТипЗнч(Параметры.РодительИерархии) = Тип("СправочникСсылка.торо_ОбъектыРемонта"), Параметры.РодительИерархии, Справочники.торо_ОбъектыРемонта.ПустаяСсылка()), 
							КлючИЗначение.Значение);
					НС.ПредыдущееПоложение = КлючИЗначение.Значение;
					
					Если НЕ ЗначениеЗаполнено(НС.ПредыдущееПоложение) Тогда
						НС.ПредыдущееПоложение = "Внесен в структуру иерархии";
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			
			Объект.Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновнаяОрганизация",
			Истина);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
			
			Объект.Подразделение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновноеПодразделение",
			Истина);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
			
			Объект.Ответственный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновнойОтветственный",
			Справочники.Пользователи.ПустаяСсылка());
			
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокОРВТекущейИерархии();
	
	// Заголовок формы++
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	// Заголовок формы--	
	
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Заголовок формы++
	
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	
	// Заголовок формы--	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Для каждого текСтрока из Объект.ПоложенияВСтруктуреИерархии Цикл
		ОповеститьОЗаписиНового(ТекСтрока.ОбъектИерархии);
	КонецЦикла;
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьСписокОРВТекущейИерархии();
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктураИерархииНачалоВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Ответ = РезультатВопроса;
	
    Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.СтруктураИерархии = ДополнительныеПараметры.ВыбранноеЗначение;
		Объект.ПоложенияВСтруктуреИерархии.Очистить();
		ЗаполнитьСписокОРВТекущейИерархии();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтруктураИерархииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.СтруктураИерархии <> ВыбранноеЗначение 
		И Объект.ПоложенияВСтруктуреИерархии.Количество() > 0 
		Тогда
		стрПараметры = Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение);
		ТекстВопроса = НСтр("ru = 'Таблица положений объектов ремонта будет очищена. Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("СтруктураИерархииНачалоВыбораЗавершение", ЭтотОбъект, стрПараметры), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Модифицированность = Истина;
	Иначе
		Объект.СтруктураИерархии = ВыбранноеЗначение;
		ЗаполнитьСписокОРВТекущейИерархии();
	КонецЕсли;
	 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
    УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоложенияВСтруктуреИерархии

&НаКлиенте
Процедура ПоложенияВСтруктуреИерархииОбъектИерархииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Тип") Тогда
		ПредыдущееПоложение = ПоложенияВСтруктуреИерархииОбъектИерархииОбработкаВыбораНаСервере(ВыбранноеЗначение, Объект.СтруктураИерархии);
		Элементы.ПоложенияВСтруктуреИерархии.ТекущиеДанные.ПредыдущееПоложение = ПредыдущееПоложение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоложенияВСтруктуреИерархииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не ЗначениеЗаполнено(Объект.СтруктураИерархии) Тогда
		
		Отказ = Истина;
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Заполните значение структуры иерархии!'"), 60);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоложенияВСтруктуреИерархииОбъектИерархииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПоложенияВСтруктуреИерархии.ТекущиеДанные;
	Если Не ТекущиеДанные = Неопределено Тогда
		Если Не ЗначениеЗаполнено(ТекущиеДанные.ОбъектИерархии) Тогда
			ТекущиеДанные.ОбъектИерархии = ПредопределенноеЗначение("Справочник.торо_ОбъектыРемонта.ПустаяСсылка");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ТекущиеДанные.РодительИерархии) Тогда
			ТекущиеДанные.РодительИерархии = ПредопределенноеЗначение("Справочник.торо_ОбъектыРемонта.ПустаяСсылка");
		КонецЕсли; 
	КонецЕсли;  
	
	СтандартнаяОбработка = Ложь;
	ПараметрыВыбораОР = Новый Структура;
	ПараметрыВыбораОР.Вставить("СтруктураИерархии", Объект.СтруктураИерархии);
	ПараметрыВыбораОР.Вставить("РазрешитьВыборГрупп", Истина);
	ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаВыбора",ПараметрыВыбораОР,Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПоложенияВСтруктуреИерархииРодительИерархииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыВыбораОР = Новый Структура;
	ПараметрыВыбораОР.Вставить("СтруктураИерархии", Объект.СтруктураИерархии);
	ПараметрыВыбораОР.Вставить("РазрешитьВыборГрупп", Истина);
	ПараметрыВыбораОР.Вставить("ЗапретитьИзменениеИерархии", Истина);
	ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаВыбора",ПараметрыВыбораОР,Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоложенияВСтруктуреИерархииРодительИерархииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание > 0 Тогда
		СтандартнаяОбработка = Ложь;
		Если Текст = "" Тогда
			ДанныеВыбора = СписокОРВТекущейИерархии;
		Иначе
			ДанныеВыбора = Новый СписокЗначений;
			Для каждого СтрокаТаблицы из ТаблицаОРВТекущейИерархииДляВводаПоСтроке Цикл
				Если СтрНайти(СтрокаТаблицы.Наименование, Текст) > 0 ИЛИ СтрНайти(СтрокаТаблицы.Код, Текст) > 0 Тогда
					ДанныеВыбора.Добавить(СтрокаТаблицы.Значение, СтрокаТаблицы.Наименование + " ("+СтрокаТаблицы.Код+")");
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

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

&НаСервереБезКонтекста
Функция ПоложенияВСтруктуреИерархииОбъектИерархииОбработкаВыбораНаСервере(ОбъектРемонта, СтруктураИерархии)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии,
	|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.Удален
	|ИЗ
	|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(
	|			&Дата,
	|			ОбъектИерархии = &ОбъектРемонта
	|				И СтруктураИерархии = &СтруктураИерархии) КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних";
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("ОбъектРемонта", ОбъектРемонта);
	Запрос.УстановитьПараметр("СтруктураИерархии", СтруктураИерархии);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Не Выборка.Удален Тогда
			Если НЕ ЗначениеЗаполнено(Выборка.РодительИерархии) Тогда
				Возврат "Корневая группа";
			КонецЕсли;
			
			Возврат Выборка.РодительИерархии;
		КонецЕсли;
	КонецЕсли;
	Возврат "Внесен в структуру иерархии";	
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокОРВТекущейИерархии()
	
	СписокОРВТекущейИерархии.Очистить();
	ТаблицаОРВТекущейИерархииДляВводаПоСтроке.Очистить();
	
	Если ЗначениеЗаполнено(Объект.СтруктураИерархии) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.ОбъектИерархии
		|ПОМЕСТИТЬ ВТ_Срез
		|ИЗ
		|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(&Период, СтруктураИерархии = &СтруктураИерархии) КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних
		|ГДЕ
		|	НЕ торо_РасположениеОРВСтруктуреИерархииСрезПоследних.Удален
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Срез.ОбъектИерархии КАК Значение,
		|	ВТ_Срез.ОбъектИерархии.Наименование КАК Наименование,
		|	ВТ_Срез.ОбъектИерархии.Код КАК Код
		|ИЗ
		|	ВТ_Срез КАК ВТ_Срез";
		Запрос.УстановитьПараметр("Период", ПолучитьМоментВремени(Объект.Ссылка, Объект.Дата));
		Запрос.УстановитьПараметр("СтруктураИерархии", Объект.СтруктураИерархии);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОРВТекущейИерархии.Добавить(Выборка.Значение, Выборка.Наименование + " ("+Выборка.Код+")");
			НовСтр = ТаблицаОРВТекущейИерархииДляВводаПоСтроке.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, Выборка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМоментВремени(Ссылка, Дата)
	
	Если НЕ Ссылка.Пустая() Тогда
		Возврат Ссылка.МоментВремени();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

