
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьСхемуКомпоновкиДанных(Параметры.ЗначениеКопирования);
	ЗаполнитьСписокВыбораОтчетов();
	РасставитьФлагиПоВариантуЗаполнения();
	
	Значение = СписокВыбораОтчетов.НайтиПоЗначению(Объект.Отчет);
	Если Значение <> Неопределено Тогда
		ОтчетДляРасшифровкиПредставление = Значение.Представление;
	КонецЕсли;
	
	ОбновитьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Отчет) Тогда
		обМетаданных = Метаданные.Отчеты.Найти(ТекущийОбъект.Отчет);
		Если обМетаданных = Неопределено Тогда
			ТекстСообщения = НСтр("ru = 'Указанный отчёт не найден!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.Отчет");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ПроверятьУникальностьИдентификатора = Ложь;
	Если 	ПроверятьУникальностьИдентификатора Тогда
		Если ЗначениеЗаполнено(ТекущийОбъект.ИдентификаторДляФормул) Тогда
			ЗапросДублей = Новый Запрос;
			ЗапросДублей.Текст = 
			"ВЫБРАТЬ
			|	торо_ПоказателиKPI.Ссылка
			|ИЗ
			|	Справочник.торо_ПоказателиKPI КАК торо_ПоказателиKPI
			|ГДЕ
			|	торо_ПоказателиKPI.Ссылка <> &Ссылка
			|	И торо_ПоказателиKPI.ИдентификаторДляФормул = &ИдентификаторДляФормул";
			ЗапросДублей.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
			ЗапросДублей.УстановитьПараметр("ИдентификаторДляФормул", ТекущийОбъект.ИдентификаторДляФормул);
			ВыборкаДублей = ЗапросДублей.Выполнить().Выбрать();
			
			ШаблонСообщения = НСтр("ru='Идентификатор для формул ""%1"" уже использован в показателе ""%2"".'");
			Пока ВыборкаДублей.Следующий() Цикл
				ТекстСообщения = СтрШаблон(ШаблонСообщения, ТекущийОбъект.ИдентификаторДляФормул, ВыборкаДублей.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ВыборкаДублей.Ссылка,,,Отказ);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьСхемуКомпоновкиДанных(ТекущийОбъект);
			
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	#Если ТолстыйКлиентУправляемоеПриложение Тогда
		Если ТипЗнч(ВыбранноеЗначение) = Тип("СхемаКомпоновкиДанных") Тогда
			АдресСКД = ПоместитьВоВременноеХранилище(ВыбранноеЗначение, ЭтаФорма.УникальныйИдентификатор);
			Модифицированность = Истина;
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ОтчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораОтчетов;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание > 0 Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Текст) Тогда
			ДанныеВыбора = Новый СписокЗначений;
			Для каждого Элемент из СписокВыбораОтчетов Цикл
				Если СтрНачинаетсяС(Элемент.Значение, Текст) Тогда
					ДанныеВыбора.Добавить(Элемент.Значение);
				КонецЕсли;
			КонецЦикла;
		Иначе
			ДанныеВыбора = СписокВыбораОтчетов;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетДляРасшифровкиПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СписокВыбораОтчетов;

КонецПроцедуры

&НаКлиенте
Процедура ОтчетДляРасшифровкиПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
		Если Ожидание > 0 Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Текст) Тогда
			ДанныеВыбора = Новый СписокЗначений;
			Для каждого Элемент из СписокВыбораОтчетов Цикл
				Если СтрНачинаетсяС(Элемент.Значение, Текст) ИЛИ СтрНачинаетсяС(Элемент.Представление, Текст) Тогда
					ДанныеВыбора.Добавить(Элемент.Значение, Элемент.Представление);
				КонецЕсли;
			КонецЦикла;
		Иначе
			ДанныеВыбора = СписокВыбораОтчетов;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтчетДляРасшифровкиПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Значение = СписокВыбораОтчетов.НайтиПоЗначению(ВыбранноеЗначение);
	Если Значение <> Неопределено Тогда
		Объект.Отчет = ВыбранноеЗначение;
		ОтчетДляРасшифровкиПредставление = Значение.Представление;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОтчетДляРасшифровкиПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Отчет = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетДляРасшифровкиПредставлениеПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ОтчетДляРасшифровкиПредставление) Тогда
		Объект.Отчет = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииФлажка(Элемент)
	
	ИзмененныйФлаг = Элемент.Имя;
	
	Если ЭтаФорма[ИзмененныйФлаг] = Истина Тогда
		
		Если Элемент = Элементы.ФлагФормула Тогда
			ФлагСКД = Ложь;
			ФлагВнешнийПоказатель = Ложь;
			Объект.ВариантЗаполнения = ПредопределенноеЗначение("Перечисление.торо_ВариантыЗаполненияПоказателяKPI.Формула");
		ИначеЕсли Элемент = Элементы.ФлагСКД Тогда
			ФлагФормула = Ложь;
			ФлагВнешнийПоказатель = Ложь;
			Объект.ВариантЗаполнения = ПредопределенноеЗначение("Перечисление.торо_ВариантыЗаполненияПоказателяKPI.СКД");
		ИначеЕсли Элемент = Элементы.ФлагВнешнийПоказатель Тогда
			ФлагСКД = Ложь;
			ФлагФормула = Ложь;
			Объект.ВариантЗаполнения = ПредопределенноеЗначение("Перечисление.торо_ВариантыЗаполненияПоказателяKPI.ВнешнийПоказатель");
		КонецЕсли;
		
	ИначеЕсли НЕ ФлагФормула И НЕ ФлагСКД И НЕ ФлагВнешнийПоказатель Тогда
		Объект.ВариантЗаполнения = ПредопределенноеЗначение("Перечисление.торо_ВариантыЗаполненияПоказателяKPI.ПустаяСсылка");
	КонецЕсли;
	
	ОбновитьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНастройкиСКД(Команда)
	
	#Если ТолстыйКлиентУправляемоеПриложение Тогда
		СКД = ПолучитьИзВременногоХранилища(АдресСКД);
		Конструктор = Новый КонструкторСхемыКомпоновкиДанных(СКД);
		Конструктор.Редактировать(ЭтаФорма);
	#Иначе
		ТекстСообщения = НСтр("ru='Для того чтобы редактировать схему компоновки, необходимо запустить конфигурацию в режиме толстого клиента.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
	#КонецЕсли	
		
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьЗапросСКД(Команда)
	
	ПараметрыФормы = Новый Структура("АдресСКД, Показатель", АдресСКД, Объект.Наименование);
	ОткрытьФорму("Справочник.торо_ПоказателиKPI.Форма.ФормаПросмотраТекстаЗапроса", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстФормулыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура("Показатель, ТекстФормулы", Объект.Ссылка, Объект.ТекстФормулы);
	ОткрытьФорму("Справочник.торо_ПоказателиKPI.Форма.РедакторФормул", ПараметрыФормы, Элемент, ЭтаФорма.УникальныйИдентификатор, ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РасставитьФлагиПоВариантуЗаполнения()
	
	ФлагФормула = (Объект.ВариантЗаполнения = Перечисления.торо_ВариантыЗаполненияПоказателяKPI.Формула);
	ФлагСКД = (Объект.ВариантЗаполнения = Перечисления.торо_ВариантыЗаполненияПоказателяKPI.СКД);
	ФлагВнешнийПоказатель = (Объект.ВариантЗаполнения = Перечисления.торо_ВариантыЗаполненияПоказателяKPI.ВнешнийПоказатель);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьФорму(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.ТекстФормулы.Доступность = Форма.ФлагФормула;
	Элементы.ТекстФормулы.АвтоОтметкаНезаполненного = Форма.ФлагФормула;
	Элементы.РедактироватьНастройкиСКД.Доступность = Форма.ФлагСКД;
	Элементы.ПросмотретьЗапросСКД.Доступность = Форма.ФлагСКД;
	Элементы.ИдентификаторВнешнегоПоказателя.Доступность = Форма.ФлагВнешнийПоказатель;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОтчетов()
	
	ОтчетыИсключения = Новый массив;
	ОтчетыИсключения.Добавить("торо_МониторKPI");
	ОтчетыИсключения.Добавить("торо_ПанельОтчетов");
	
	СписокВыбораОтчетов.Очистить();
	Для каждого МетаданныеОтчета из Метаданные.Отчеты Цикл
		Если ОтчетыИсключения.Найти(МетаданныеОтчета.Имя) = Неопределено Тогда 
			Представление = МетаданныеОтчета.Синоним + " (" +МетаданныеОтчета.Имя+")"; 
			СписокВыбораОтчетов.Добавить(МетаданныеОтчета.Имя, Представление);
		Конецесли;
	КонецЦикла;
	
	СписокВыбораОтчетов.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуКомпоновкиДанных(ЗначениеКопирования)
	
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		ОбъектЗначение = ЗначениеКопирования;
	Иначе
		ОбъектЗначение = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	СКД = ОбъектЗначение.СхемаКомпоновкиДанных.Получить();
	Если СКД = Неопределено Тогда
		СКД = Новый СхемаКомпоновкиДанных;
	КонецЕсли;
	АдресСКД = ПоместитьВоВременноеХранилище(СКД, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСхемуКомпоновкиДанных(ТекущийОбъект)
	
	СКД = ПолучитьИзВременногоХранилища(АдресСКД);
	ТекущийОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(СКД, Новый СжатиеДанных(9));
	
КонецПроцедуры

#КонецОбласти


