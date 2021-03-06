
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	ПредлагатьПерейтиНаСайтПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ПредлагатьПерейтиНаСайтПриЗапуске",
		Ложь);

	// СтандартныеПодсистемы.БазоваяФункциональность
	Если ЭтоВебКлиент Тогда
		Элементы.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы.Видимость = Ложь;
	Иначе
		Элементы.ГруппаУстановитьРасширениеРаботыСФайламиНаКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		Истина);
	
	ДействиеПоДвойномуЩелчкуМыши = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов",
		"ДействиеПоДвойномуЩелчкуМыши",
		Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл);
	
	СпособСравненияВерсийФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСравненияФайлов",
		"СпособСравненияВерсийФайлов",
		Перечисления.СпособыСравненияВерсийФайлов.ПустаяСсылка());
	
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		Ложь);
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		Ложь);
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		Истина);
	
	ПоказыватьКолонкуРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ПоказыватьКолонкуРазмер",
		Ложь);
	
	// Заполнение настроек открытия файлов.
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"Расширение",
		"TXT XML INI");
	
	СтрокаНастройки.СпособОткрытия = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов\ТекстовыеФайлы",
		"СпособОткрытия",
		Перечисления.СпособыОткрытияФайлаНаПросмотр.ВоВстроенномРедакторе);
	
	Если ЭтоВебКлиент Тогда
		Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость      = Ложь;
	КонецЕсли;
	
	Если ЭтоВебКлиент Или ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.НастройкаЭП.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
	// =ТОиР==>
	
	ОсновнаяСтруктураИерархии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновнаяСтруктураИерархии",
	Справочники.торо_СтруктурыОР.ПустаяСсылка());
	
	ИерархияДляМобильногоПриложения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ИерархияДляМобильногоПриложения",
	Справочники.торо_СтруктурыОР.ПустаяСсылка());
	
	ОсновноеНаправлениеОР = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновноеНаправлениеОР",
	Справочники.торо_НаправленияОбъектовРемонтныхРабот.ПустаяСсылка());
	
	ОсновнаяОрганизация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновнаяОрганизация",
	Справочники.Организации.ПустаяСсылка());
	
	ОсновноеПодразделение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновноеПодразделение",
	Справочники.СтруктураПредприятия.ПустаяСсылка());
	
	ОсновнойОтветственный = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновнойОтветственный",
	Справочники.Пользователи.ПустаяСсылка());
	
	ОсновнойГрафикРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновнойГрафикРаботы",
	Истина);
	
	ОсновнойИнициаторДефекта = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновнойИнициаторДефекта",
	Неопределено);
	
	ОсновнойПериодПланирования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ОсновнойПериодПланирования",
	Истина);
	
	ЗапретитьОткрытиеНесколькихСеансов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ЗапретитьОткрытиеНесколькихСеансов",
	Истина);
	
	ПоказыватьПоложениеОР = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПоказыватьПоложениеОР",
	Истина);
	
	ПодставлятьТекущуюДатуВоВнешнееОснованиеИВыявленныеДефекты = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПодставлятьТекущуюДатуВоВнешнееОснованиеИВыявленныеДефекты",
	Истина);
	
	ПечатьДокументовБезПредварительногоПросмотра = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПечатьДокументовБезПредварительногоПросмотра",
	Ложь);
	
	ПолучатьУведомленияВВидеВсплывающихПодсказок = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПолучатьУведомленияВВидеВсплывающихПодсказок",
	Истина);
	
	ПоказыватьПутеводительПоДемоБазе = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПоказыватьПутеводительПоДемоБазе",
	Истина);
	
	ПоказыватьСообщениеПриРасчетеППР = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПоказыватьСообщениеПриРасчетеППР",
	Истина);
	
	ПоказыватьПанельЗадачТОиР = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
	"ОбщаяФорма.торо_ТекущиеЗадачиТОиР",
	"ОткрыватьПриЗапуске",
	Истина);
	
	ВариантМасштаба = ХранилищеСистемныхНастроек.Загрузить(
	"Общее/НастройкиКлиентскогоПриложения");
	
	Если Не ВариантМасштаба = Неопределено Тогда
		ВариантМасштабаФормКомпактный = (ВариантМасштаба.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения.Компактный);
	Иначе
		ВариантМасштабаФормКомпактный = Ложь;
	КонецЕсли;
	
	// +Параметры представления
	ФОторо_РазрешитьПользовательскуюНастройкуПредставлений = ПолучитьФункциональнуюОпцию("торо_РазрешитьПользовательскуюНастройкуПредставлений");
	
	Если ФОторо_РазрешитьПользовательскуюНастройкуПредставлений Тогда
		Элементы.ПредставлениеДанных.Видимость = Истина;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	торо_ПараметрыПользовательскогоПредставленияОбъектов.ОбъектКонфигурации,
		               |	торо_ПараметрыПользовательскогоПредставленияОбъектов.ФорматнаяСтрокаПоУмолчанию,
					   |	торо_ПараметрыПользовательскогоПредставленияОбъектов.ОбъектКонфигурацииСиноним
		               |ИЗ
		               |	РегистрСведений.торо_ПараметрыПользовательскогоПредставленияОбъектов КАК торо_ПараметрыПользовательскогоПредставленияОбъектов";
		Рез = Запрос.Выполнить();
		Если НЕ Рез.Пустой() Тогда
			Выборка = Рез.Выбрать();
			Пока Выборка.Следующий() Цикл
				НС = ТаблицаПредставлений.Добавить();
				ЗаполнитьЗначенияСвойств(НС,Выборка);
				НС.ПоУмолчанию = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкиПредставлений",
				"ПредставлениеДля"+Выборка.ОбъектКонфигурации+"ПоУмолчанию",
				Истина);
				НС.ФорматнаяСтрока = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкиПредставлений",
				"ПредставлениеДля"+Выборка.ОбъектКонфигурации,
				НС.ФорматнаяСтрокаПоУмолчанию);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	// -Параметры представления
	// <==ТОиР=
	
	ФО_ИнтеграцияС1СДокументоборот = ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграциюС1СДокументооборот");
	Элементы.ИнтеграцияС1СДокументооборот.Видимость = ФО_ИнтеграцияС1СДокументоборот;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда	
	НапоминатьОбУстановкеРасширенияРаботыСФайлами = ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами();
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
#КонецЕсли	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница Общие

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайлами()
	
	Подключено = ПодключитьРасширениеРаботыСФайлами();
	Элементы.НапоминатьОбУстановкеРасширенияРаботыСФайлами.Доступность = Не Подключено;
	Элементы.УстановитьРасширениеРаботыСФайламиНаКлиенте.Доступность = Не Подключено;
	Текст = ?(Подключено, НСтр("ru = 'Расширение работы с файлами в веб-браузере установлено.'"), 
		НСтр("ru ='Для выполнения ряда действий при работе в веб-клиенте
			|требуется установить расширение работы с файлами на данном компьютере.'"));
	Элементы.ДекорацияРасширение.Заголовок = Текст;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы(Команда)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница Печать

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	ФайловыеФункцииКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭП(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСКриптографиейНаКлиенте(Команда)
	Обработчик = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСКриптографиейНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСКриптографией(Обработчик);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница ПредставлениеДанных

&НаКлиенте
Процедура ТаблицаПредставленийПриИзменении(Элемент)
	Элементы.Группа15.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПредставленийФорматнаяСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.ТаблицаПредставлений.ТекущиеДанные;
	ОткрытьФорму("ОбщаяФорма.торо_КонструкторФорматнойСтроки",Новый Структура("ОбъектКонфигурации,ОбъектКонфигурацииСиноним,ФорматнаяСтрока",ТекДанные.ОбъектКонфигурации,ТекДанные.ОбъектКонфигурацииСиноним,ТекДанные.ФорматнаяСтрока),Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница ИнтеграцияС1СДокументооборот

&НаКлиенте
Процедура НастройкиАвторизации1СДокументооборот(Команда)
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.АвторизацияВ1СДокументооборот");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница НастройкиТОиР

&НаКлиенте
Процедура ОсновнаяСтруктураИерархииПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ИерархияДляМобильногоПриложения) И ЗначениеЗаполнено(ОсновнаяСтруктураИерархии) Тогда
		Автоматическая = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнаяСтруктураИерархии, "СтроитсяАвтоматически");
		Если Автоматическая <> Истина Тогда
			ИерархияДляМобильногоПриложения = ОсновнаяСтруктураИерархии;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Настройки = Новый Массив;
	
	Настройки.Добавить(ОписаниеНастройки(
		"ОбщиеНастройкиПользователя",
		"ПредлагатьПерейтиНаСайтПриЗапуске",
		ПредлагатьПерейтиНаСайтПриЗапуске));
		
	// СтандартныеПодсистемы.БазоваяФункциональность
	Настройки.Добавить(ОписаниеНастройки(
		"ОбщиеНастройкиПользователя",
		"ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
		ЗапрашиватьПодтверждениеПриЗавершенииПрограммы));
		
#Если ВебКлиент Тогда		
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами",
		ИдентификаторКлиента,
		НапоминатьОбУстановкеРасширенияРаботыСФайлами));
	Если НапоминатьОбУстановкеРасширенияРаботыСФайлами = Истина Тогда
		НапоминатьОбУстановкеРасширенияРаботыСФайлами = Неопределено;
	КонецЕсли;
#КонецЕсли
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиОткрытияФайлов",
		"ДействиеПоДвойномуЩелчкуМыши",
		ДействиеПоДвойномуЩелчкуМыши));
	
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиОткрытияФайлов",
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		СпрашиватьРежимРедактированияПриОткрытииФайла));
	
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы",
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		ПоказыватьПодсказкиПриРедактированииФайлов));
	
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		ПоказыватьЗанятыеФайлыПриЗавершенииРаботы));
	
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиСравненияФайлов",
		"СпособСравненияВерсийФайлов",
		СпособСравненияВерсийФайлов));
	
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы",
		"ПоказыватьКолонкуРазмер",
		ПоказыватьКолонкуРазмер));
	
	Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы",
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		ПоказыватьИнформациюЧтоФайлНеБылИзменен));
	
	// Настройки открытия файлов
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда
	
		Настройки.Добавить(ОписаниеНастройки(
			"НастройкиОткрытияФайлов\ТекстовыеФайлы",
			"Расширение",
			НастройкиОткрытияФайлов[0].Расширение));
		
		Настройки.Добавить(ОписаниеНастройки(
			"НастройкиОткрытияФайлов\ТекстовыеФайлы",
			"СпособОткрытия",
			НастройкиОткрытияФайлов[0].СпособОткрытия));
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// =ТОиР==>

	ЗаписатьВХранилищеСистемныхНастроек();
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновнаяСтруктураИерархии",
	ОсновнаяСтруктураИерархии));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ИерархияДляМобильногоПриложения",
	ИерархияДляМобильногоПриложения));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновноеНаправлениеОР",
	ОсновноеНаправлениеОР));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновнаяОрганизация",
	ОсновнаяОрганизация));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновноеПодразделение",
	ОсновноеПодразделение));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновнойОтветственный",
	ОсновнойОтветственный));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновнойГрафикРаботы",
	ОсновнойГрафикРаботы));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновнойИнициаторДефекта",
	ОсновнойИнициаторДефекта));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ОсновнойПериодПланирования",
	ОсновнойПериодПланирования));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ЗапретитьОткрытиеНесколькихСеансов",
	ЗапретитьОткрытиеНесколькихСеансов));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ПоказыватьПоложениеОР",
	ПоказыватьПоложениеОР));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ПодставлятьТекущуюДатуВоВнешнееОснованиеИВыявленныеДефекты",
	ПодставлятьТекущуюДатуВоВнешнееОснованиеИВыявленныеДефекты));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ПечатьДокументовБезПредварительногоПросмотра",
	ПечатьДокументовБезПредварительногоПросмотра));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ПолучатьУведомленияВВидеВсплывающихПодсказок",
	ПолучатьУведомленияВВидеВсплывающихПодсказок));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ПоказыватьПутеводительПоДемоБазе",
	ПоказыватьПутеводительПоДемоБазе));
	
	Настройки.Добавить(ОписаниеНастройки(
	"НастройкиТОиР",
	"ПоказыватьСообщениеПриРасчетеППР",
	ПоказыватьСообщениеПриРасчетеППР));
	
	Настройки.Добавить(ОписаниеНастройки(
	"ОбщаяФорма.торо_ТекущиеЗадачиТОиР",
	"ОткрыватьПриЗапуске", 
	ПоказыватьПанельЗадачТОиР));
	
	// +Параметры представления
	Для Каждого Строка Из ТаблицаПредставлений Цикл
		Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПредставлений",
		"ПредставлениеДля"+Строка.ОбъектКонфигурации+"ПоУмолчанию",
		Строка.ПоУмолчанию));
		Настройки.Добавить(ОписаниеНастройки(
		"НастройкиПредставлений",
		"ПредставлениеДля"+Строка.ОбъектКонфигурации,
		Строка.ФорматнаяСтрока));
	КонецЦИкла;
	// -Параметры представления
	
	// <==ТОиР=
	
	Модифицированность = Ложь;
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(Настройки);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьВХранилищеСистемныхНастроек()
	
	НастройкиИнтерфейса = Новый НастройкиКлиентскогоПриложения;
	НастройкиИнтерфейса.ВариантМасштабаФормКлиентскогоПриложения = ?(ВариантМасштабаФормКомпактный,
	ВариантМасштабаФормКлиентскогоПриложения.Компактный,
	ВариантМасштабаФормКлиентскогоПриложения.Обычный);	
	
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения",  , НастройкиИнтерфейса);
	
КонецПроцедуры

Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСКриптографиейНаКлиентеЗавершение(ПараметрыВыполнения) Экспорт
	Перем ОбработчикНеТребуется; // Обработчик не требуется
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемПодтверждениеПолучено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПодтверждениеПолучено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	ЗаписатьИЗакрыть(Неопределено);
КонецПроцедуры

#КонецОбласти
