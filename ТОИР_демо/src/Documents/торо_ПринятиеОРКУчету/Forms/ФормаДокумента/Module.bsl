#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	ТекСтруктураИерархии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
															"НастройкиТОиР",
															"ОсновнаяСтруктураИерархии",
															Справочники.торо_СтруктурыОР.ПустаяСсылка());
	
	Если Параметры.Свойство("ОбъектРемонта") И ЗначениеЗаполнено(Параметры.ОбъектРемонта) Тогда
		
		ОбъектДокумент = РеквизитФормыВЗначение("Объект");
		ОбъектДокумент.Заполнить(Параметры.ОбъектРемонта);
		ЗначениеВРеквизитФормы(ОбъектДокумент,"Объект");
		
	КонецЕсли;
	Если Параметры.Свойство("ДатаВводаВЭксплуатацию")
		И ЗначениеЗаполнено(Параметры.ДатаВводаВЭксплуатацию) Тогда
		Объект.ДатаВводаВЭксплуатацию = Параметры.ДатаВводаВЭксплуатацию;
	КонецЕсли; 
	
	
	ВходитВСостав = ПолучитьРодителяОРНаСервере(ТекСтруктураИерархии, Объект.ОбъектРемонта);
	
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

	Если РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
		
	Иначе
		
		УстановитьВидимостьДоступность();
		
	КонецЕсли;
	
	// Заголовок формы++
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	// Заголовок формы--	
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПроверитьНаличиеГарантий(Объект.ОбъектРемонта);
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
	
	Элементы.ИзменитьИерархию.Заголовок = ТекСтруктураИерархии;
	ПеречитатьИнвентарныйНомер(Истина);	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = НЕ ПроверитьЗаполнение();
	
	Если Не ЭтаФорма.ВладелецФормы = Неопределено
		И ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		ПараметрыЗаписи.Вставить("ОткрытИзОР", Истина);
	Иначе
		ПараметрыЗаписи.Вставить("ОткрытИзОР", Ложь);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ТекущийОбъект.ОткрытИзФормыОР = ПараметрыЗаписи.ОткрытИзОР;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьВидимостьДоступность();
	
	// Заголовок формы++
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	// Заголовок формы--	

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПараметрыОповещения = Новый Структура("ОбъектРемонта, ДатаВводаВЭксплуатацию", Объект.ОбъектРемонта,Объект.ДатаВводаВЭксплуатацию);
	Оповестить("СОЗДАН_ДОКУМЕНТ_ПРИНЯТИЕ_К_УЧЕТУ", ПараметрыОповещения, ЭтаФорма.ВладелецФормы);
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
Процедура ОбъектРемонтаПриИзменении(Элемент)
	ВходитВСостав = ПолучитьРодителяОРНаСервере(ТекСтруктураИерархии, Объект.ОбъектРемонта);
	ПеречитатьИнвентарныйНомер(Истина);
	ПроверитьНаличиеГарантий(Объект.ОбъектРемонта);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектРемонтаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокДоступныхСтатусов = ПолучитьСписокСтатусовНаСервере();
	
	ПараметрыОтбора = Новый Структура("СписокСтатусов", СписокДоступныхСтатусов);
	ПараметрыОтбора.Вставить("СтруктураИерархии",       ТекСтруктураИерархии);
	
	ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаВыбора",ПараметрыОтбора,Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
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

&НаКлиенте
Процедура ИзменитьИерархию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораИерахии", ЭтаФорма);
	ПараметрыФормыИерархии = Новый Структура("СписокИерархийОР", ЗаполнитьСписокСтруктурНаСервере(ТекСтруктураИерархии));
	ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаНастройкиВидаИерархии",ПараметрыФормыИерархии,ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьИнвентарныйНомер(Команда)
	ВидимостьПоляИнвНомер = ПроверитьЗаполненностьИнвНомераНаСервере(Объект.ОбъектРемонта);
	Элементы.ОбъектРемонтаИнвентарныйНомер.Видимость = ВидимостьПоляИнвНомер;
	Элементы.Декорация1.Видимость                    = Не ВидимостьПоляИнвНомер;
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

&НаКлиенте
Процедура ОбработкаВыбораИерахии(Результат, Параметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		ТекСтруктураИерархии = Результат.СтруктураИерархии;
		Элементы.ИзменитьИерархию.Заголовок = ТекСтруктураИерархии;
		ВходитВСостав = ПолучитьРодителяОРНаСервере(ТекСтруктураИерархии, Объект.ОбъектРемонта);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРодителяОРНаСервере(ТекСтруктураИерархии, ОбъектРемонта)
	
	Запрос = Новый Запрос;
	
	Если ТекСтруктураИерархии.СтроитсяАвтоматически Тогда
		Если Не ЗначениеЗаполнено(ОбъектРемонта) Тогда
			Возврат "<не указан объект ремонта>";
		Иначе
			Возврат Строка(ОбъектРемонта[ТекСтруктураИерархии.РеквизитОР]);
		КонецЕсли;
	КонецЕсли;
	
	Если ТекСтруктураИерархии.ИзменяетсяДокументами Тогда
		Запрос.Текст = "ВЫБРАТЬ
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии КАК Родитель
		|ИЗ
		|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(
		|			,
		|			СтруктураИерархии = &ТекСтруктураИерархии
		|				И ОбъектИерархии = &ОбъектРемонта) КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних";
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		|	торо_ИерархическиеСтруктурыОР.РодительИерархии КАК Родитель
		|ИЗ
		|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
		|ГДЕ
		|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии = &ОбъектРемонта
		|	И торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &ТекСтруктураИерархии";
	КонецЕсли; 
				   
	Запрос.УстановитьПараметр("ТекСтруктураИерархии", ТекСтруктураИерархии);
	Запрос.УстановитьПараметр("ОбъектРемонта",        ОбъектРемонта);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Родитель;
	ИначеЕсли Не ЗначениеЗаполнено(ОбъектРемонта) Тогда
		Возврат "<не указан объект ремонта>";	
	Иначе	
		Возврат "<не включен в структуру иерархии>";
	КонецЕсли;
	
КонецФункции


&НаСервереБезКонтекста
Функция ЗаполнитьСписокСтруктурНаСервере(ТекСтруктураИерархии, БезТекИерархии = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_СтруктурыОР.Ссылка,
	|	торо_СтруктурыОР.Наименование
	|ИЗ
	|	Справочник.торо_СтруктурыОР КАК торо_СтруктурыОР
	|ГДЕ
	|	торо_СтруктурыОР.ПометкаУдаления = ЛОЖЬ";
	
	Если БезТекИерархии Тогда
		
		Запрос.Текст = Запрос.Текст + " И торо_СтруктурыОР.Ссылка <> &СтруктураИерархии";
		Запрос.УстановитьПараметр("СтруктураИерархии", ТекСтруктураИерархии);
		
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СписокСтруктурОР = Новый СписокЗначений;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СписокСтруктурОР.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Наименование);
		
	КонецЦикла;
	
	Если БезТекИерархии Тогда
		
		СписокСтруктурОР[0].Пометка = Истина;
	Иначе
		
		Для каждого ЭлементСписка Из СписокСтруктурОР Цикл
			
			ЭлементСписка.Пометка = ЭлементСписка.Значение = ТекСтруктураИерархии;	
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокСтруктурОР;

КонецФункции

&НаСервере 
Процедура УстановитьВидимостьДоступность()
	
	Если Объект.Проведен Тогда
		Элементы.Шапка.ТолькоПросмотр = Истина;
	Иначе
		Элементы.Шапка.ТолькоПросмотр = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокСтатусовНаСервере()
	
	СписокЗн = Новый СписокЗначений;
	СписокЗн.Добавить(Перечисления.торо_СтатусыОРВУчете.НеПринятоКУчету);
	СписокЗн.Добавить(Перечисления.торо_СтатусыОРВУчете.СнятоСУчета);
	Возврат СписокЗн;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьЗаполненностьИнвНомераНаСервере(ОР)
	Возврат ЗначениеЗаполнено(ОР.ИнвентарныйНомер);	
КонецФункции

&НаСервереБезКонтекста
Процедура ПроверитьНаличиеГарантий(ОбъектРемонта)
	
	Если ЗначениеЗаполнено(ОбъектРемонта) Тогда
		ТаблицаГарантий = торо_ГарантийноеОбслуживание.ПолучитьТаблицуГарантий(ОбъектРемонта);
		
		Если ТаблицаГарантий.Количество() = 0 Тогда   
			ШаблонСообщения = НСтр("ru = 'Для объекта ремонта ""%1"" не заполнены сведения о гарантиях.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ОбъектРемонта);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


