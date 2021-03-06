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
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	УстановитьУсловноеОформление();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			
			Объект.Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ОсновнаяОрганизация",
			Истина);
			
		КонецЕсли;
		СлужебныеРеквизитыЗаполнитьНаСервере();
	КонецЕсли;
	
	// Заголовок формы++
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	// Заголовок формы--
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СлужебныеРеквизитыЗаполнитьНаСервере();
	
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
	
	СлужебныеРеквизитыЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ИмяТЧ = "Номенклатура";
	ИмяРеквизита = "Номенклатура";
	ДобавитьНоменклатуруИзПодбора(ВыбранноеЗначение, ИмяТЧ, ИмяРеквизита);
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыНоменклатура

&НаКлиенте
Процедура НоменклатураНоменклатураПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Номенклатура.ТекущиеДанные;
	
	ТекущаяСтрока.ХарактеристикиИспользуются = ПолучитьХарактеристикиИспользуются(ТекущаяСтрока.Номенклатура);
	
	Если Не ТекущаяСтрока.ХарактеристикиИспользуются Тогда
		ТекущаяСтрока.ХарактеристикаНоменклатуры = Неопределено;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НоменклатураЕдиницаИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаполнитьДанныеВыбораУпаковки(Элементы.Номенклатура.ТекущиеДанные.Номенклатура, ДанныеВыбора, СтандартнаяОбработка);
	
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
Процедура ПодборНоменклатуры(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",         Истина);
	ПараметрыФормы.Вставить("ИспользоватьДатыОтгрузки",                  Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                    Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",           Истина);
	ПараметрыФормы.Вставить("Склад",                                     Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок",                                 НСтр("ru = 'Подбор номенклатуры'"));
	ПараметрыФормы.Вставить("ЗаголовокКнопкиЗапрашиватьКоличествоИЦену", НСтр("ru = 'Запрашивать количество'"));
	ПараметрыФормы.Вставить("Дата",                                      ТекущаяДата());
	ПараметрыФормы.Вставить("Документ",                                  Объект.Ссылка);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",				 "ПростойПодборНоменклатуры");
	
	ОткрытьФорму("Обработка.торо_ПодборНоменклатуры.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
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
Процедура ЗаполнитьДанныеВыбораУпаковки(Номенклатура, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораУпаковки = Новый Структура("Номенклатура", Номенклатура);
	СтандартнаяОбработка = Ложь;
	ЗаполнитьДанныеВыбораУпаковкиСервер(ДанныеВыбора, ПараметрыВыбораУпаковки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДанныеВыбораУпаковкиСервер(ДанныеВыбора, ПараметрыВыбора)

	ДанныеВыбора = Справочники.УпаковкиНоменклатуры.ПолучитьДанныеВыбора(ПараметрыВыбора);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьХарактеристикиИспользуются(Номенклатура)
	
	Возврат НЕ Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать = Номенклатура.ИспользованиеХарактеристик;
	
КонецФункции

&НаСервере
Процедура СлужебныеРеквизитыЗаполнитьНаСервере()

	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Номенклатура,
		Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются")));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НоменклатураХарактеристикаНоменклатуры.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Номенклатура.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.НейтральноСерый);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<характеристики не используются>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного",Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность",Ложь);
	
	// Чтобы не отображалась единица измерения в табличной части, когда заполнена Упаковка.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НоменклатураНоменклатураЕдиницаИзмерения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Номенклатура.ЕдиницаИзмерения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	//
	
КонецПроцедуры

&НаСервере 
Процедура ДобавитьНоменклатуруИзПодбора(Адрес, ИмяТЧ, ИмяРеквизита)
	
	Тз = ПолучитьИзВременногоХранилища(Адрес);
	
	СтруктураДействий = Новый Структура;
	Для каждого текСтрока из Тз Цикл
		
		СтруктураПоиска = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры", текСтрока.Номенклатура, текСтрока.Характеристика);
			
		НайС = Объект[ИмяТЧ].НайтиСтроки(СтруктураПоиска);
		КоэфУпаковкиВыбр = ?(ЗначениеЗаполнено(текСтрока.Упаковка), текСтрока.Упаковка.Коэффициент, 1);
		Если НайС.Количество() = 0 Тогда
			нс = Объект[ИмяТЧ].Добавить();
			ЗаполнитьЗначенияСвойств(нс, текСтрока);
			нс.ХарактеристикаНоменклатуры = текСтрока.Характеристика;
			нс[ИмяРеквизита] = текСтрока.Номенклатура;
			Если ЗначениеЗаполнено(текСтрока.Упаковка) Тогда
				нс.ЕдиницаИзмерения = текСтрока.Упаковка;
			КонецЕсли; 
			нс.МинимальныйОстаток = текСтрока.КоличествоУпаковок * ?(ЗначениеЗаполнено(нс.ЕдиницаИзмерения), 1, КоэфУпаковкиВыбр);
			
		Иначе
			
			нс = НайС[0];
			Если НЕ ЗначениеЗаполнено(нс.ЕдиницаИзмерения)Тогда
				нс.МинимальныйОстаток = нс.МинимальныйОстаток + текСтрока.КоличествоУпаковок * КоэфУпаковкиВыбр;
			ИначеЕсли нс.ЕдиницаИзмерения <> текСтрока.Упаковка Тогда
				нс.МинимальныйОстаток = нс.МинимальныйОстаток + текСтрока.КоличествоУпаковок * КоэфУпаковкиВыбр / ?(ЗначениеЗаполнено(нс.ЕдиницаИзмерения), нс.ЕдиницаИзмерения.Коэффициент, 1);
			Иначе
				нс.МинимальныйОстаток = нс.МинимальныйОстаток + текСтрока.КоличествоУпаковок;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураХарактеристикаНоменклатурыСоздание(Элемент, СтандартнаяОбработка)
	Если Элементы.Номенклатура.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элементы.Номенклатура.ТекущиеДанные.Номенклатура) Тогда	
		Вид = торо_ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Элементы.Номенклатура.ТекущиеДанные.Номенклатура, "ВидНоменклатуры");
		СтруктураПараметров = Новый Структура("ВидНоменклатуры, Владелец", Вид, Элементы.Номенклатура.ТекущиеДанные.Номенклатура);
		ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.Форма.ФормаЭлемента", СтруктураПараметров);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти