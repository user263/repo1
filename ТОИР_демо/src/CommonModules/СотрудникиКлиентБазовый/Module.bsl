////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентБазовый: методы, обслуживающие работу формы сотрудника
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы Сотрудника

// Обработчик оповещения для формы справочника Сотрудники.
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента.
//  ИмяСобытия - Строка - ИмяСобытия.
//  Параметр - Произвольный - параметр события.
//  Источник - Произвольный - источник события.
//
Процедура СотрудникиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Тогда
		Форма.ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененыДанныеДополнительнойФормы" И Источник = Форма Тогда
		СотрудникиВызовСервера.ПрочитатьДанныеИзХранилищаВФорму(
			Форма,
			СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(Параметр.ИмяФормы),
			Параметр.АдресВХранилище);
		СотрудникиКлиент.УстановитьПризнакРедактированияДанныхВДополнительнойФорме(Параметр.ИмяФормы, Форма)
	КонецЕсли; 

	СотрудникиКлиент.ЛичныеДанныеФизическогоЛицаОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма);
	
	// Вычеты
	Если ИмяСобытия = "ИзменениеДанныхМестаРаботы" И Параметр.ФизическоеЛицо = Форма.ФизическоеЛицоСсылка Тогда 
		
		Если Параметр.Сотрудник = Форма.Сотрудник.Ссылка Тогда
			СотрудникиВызовСервера.ПрочитатьДанныеСвязанныеССотрудником(Форма);
		Иначе
			СотрудникиВызовСервера.ОбработкаИзмененияДанныхОРабочемМесте(Форма, Параметр.Сотрудник, "ДругиеРабочиеМеста");
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ОтредактированаИстория" И (Форма.ФизическоеЛицоСсылка = Источник ИЛИ Форма.СотрудникСсылка = Источник) Тогда
		Если Параметр.ИмяРегистра = "ФИОФизическихЛиц" Тогда
			Если Форма[Параметр.ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
				НаименованиеПоМенеджеруЗаписи = Форма.ФИОФизическихЛиц.Фамилия + " " + Форма.ФИОФизическихЛиц.Имя + " " + Форма.ФИОФизическихЛиц.Отчество;
				Если Не ПустаяСтрока(НаименованиеПоМенеджеруЗаписи) И Форма.ФизическоеЛицо.ФИО <> НаименованиеПоМенеджеруЗаписи Тогда
					Форма.ФизическоеЛицо.ФИО = НаименованиеПоМенеджеруЗаписи;
					СотрудникиКлиент.СформироватьНаименованиеСотрудника(Форма);
				КонецЕсли; 
				СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(Форма);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "Перед записью".
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента.
//  Отказ - Булево - отказ.
//  ПараметрыЗаписи - Структура - параметры записи.
//  
Процедура СотрудникиПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	// Запрос про полное имя
	ЗапроситьРежимИзмененияФИО(Форма, Форма.ФИОФизическихЛиц, Форма.ФИОФизическихЛицНоваяЗапись, Отказ, НСтр("ru = 'сотрудника'"));
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
			
	Если Форма.ФИОФизическихЛицНоваяЗапись И Форма.ВыполненаКомандаСменыФИО = Ложь Тогда
		СотрудникиКлиент.ИзменитьФИОСотрудника(Форма, Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "Перед записью".
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента.
//  Отказ - Булево - отказ.
//  ПараметрыЗаписи - Структура - параметры записи.
//  ОповещениеЗавершения - ОписаниеОповещения - описание оповещения о закрытии.
//  ЗакрытьПослеЗаписи - Булево - закрыть форму после записи.
// 
Процедура ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ДополнительныеПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	
	Если Не Форма.СозданиеНового И Не Отказ Тогда
		// запрос про гражданство
		Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюФИО", ЭтотОбъект, ДополнительныеПараметры);
	Иначе 
		ФизическиеЛицаПередЗаписьюФИО(Отказ, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик оповещения для формы справочника ФизЛица.
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента.
//  ИмяСобытия - Строка - ИмяСобытия.
//  Параметр - Произвольный - параметр события.
//  Источник - Произвольный - источник события.
//
Процедура ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(Форма, ИмяСобытия, Параметр) Тогда
		Форма.ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененыДанныеДополнительнойФормы" И Источник = Форма Тогда
		СотрудникиВызовСервера.ПрочитатьДанныеИзХранилищаВФорму(
			Форма,
			СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(Параметр.ИмяФормы),
			Параметр.АдресВХранилище);
		СотрудникиКлиент.УстановитьПризнакРедактированияДанныхВДополнительнойФорме(Параметр.ИмяФормы, Форма)
	КонецЕсли;
	
	СотрудникиКлиент.ЛичныеДанныеФизическогоЛицаОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма);
	
	Если ИмяСобытия = "ОтредактированаИстория" И Форма.ФизическоеЛицоСсылка = Источник Тогда
		Если (Параметр.ИмяРегистра = "ГражданствоФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ДокументыФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ФИОФизическихЛиц")
			И Форма[Параметр.ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
			Если Параметр.ИмяРегистра = "ДокументыФизическихЛиц" Тогда
				ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(Форма, Форма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
				СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Серия ,Форма.Элементы.ДокументыФизическихЛицСерия, Форма);
				СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Номер ,Форма.Элементы.ДокументыФизическихЛицНомер, Форма);
				СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
			Иначе
				Если Параметр.ИмяРегистра = "ГражданствоФизическихЛиц" Тогда
					Если ЗначениеЗаполнено(Форма.ГражданствоФизическихЛиц.Страна) Тогда
						Форма.ГражданствоФизическихЛицЛицоБезГражданства = 0;
					Иначе
						Форма.ГражданствоФизическихЛицЛицоБезГражданства = 1;
					КонецЕсли;
					СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(Форма);
				ИначеЕсли Параметр.ИмяРегистра = "ФИОФизическихЛиц" Тогда
					НаименованиеПоМенеджеруЗаписи = Форма.ФИОФизическихЛиц.Фамилия + " " + Форма.ФИОФизическихЛиц.Имя + " " + Форма.ФИОФизическихЛиц.Отчество;
					Если Не ПустаяСтрока(НаименованиеПоМенеджеруЗаписи) И Форма.ФизическоеЛицо.ФИО <> НаименованиеПоМенеджеруЗаписи Тогда
						Форма.ФизическоеЛицо.ФИО = НаименованиеПоМенеджеруЗаписи;
					КонецЕсли; 
					СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(Форма);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

// Обработчик события "При изменении".
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента.
//  Элемент - ПолеВвода - элемент формы.
// 
Процедура ФизическиеЛицаИННПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбработатьОтображениеПоляИНН(Форма.ФизическоеЛицо.ИНН, Элемент,  Форма);
КонецПроцедуры

// Обработчик события "При изменении".
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента.
//  Элемент - ПолеВвода - элемент формы.
// 
Процедура ФизическиеЛицаСтраховойНомерПФРПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбработатьОтображениеПоляСтраховойНомерПФР(Форма.ФизическоеЛицо.СтраховойНомерПФР, Элемент, Форма);
КонецПроцедуры

// Обработчик события "ПриИзменении".
// Параметры:
//		Форма - УправляемаяФорма - форма документа.
//
Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Форма) Экспорт 
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Серия ,Форма.Элементы.ДокументыФизическихЛицСерия, Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Номер ,Форма.Элементы.ДокументыФизическихЛицНомер, Форма);
КонецПроцедуры

// Обработчик события "ПриИзменении".
// Параметры:
//		Форма - УправляемаяФорма - форма документа.
//		Элемент - ПолеВвода - элемент формы.
Процедура ДокументыФизическихЛицСерияПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Серия, Элемент,  Форма);
КонецПроцедуры

// Обработчик события "ПриИзменении".
// Параметры:
//		Форма - УправляемаяФорма - форма документа.
//		Элемент - ПолеВвода - элемент формы.
Процедура ДокументыФизическихЛицНомерПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Номер, Элемент,  Форма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ФизическиеЛицаПередЗаписьюФИО(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
		
	// Запрос про полное имя
	Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюИзменитьФИО", ЭтотОбъект, ДополнительныеПараметры);
	ЗапроситьРежимИзмененияФИО(Форма, Форма.ФИОФизическихЛиц, Форма.ФИОФизическихЛицНоваяЗапись, Отказ, НСтр("ru = 'сотрудника'"), Оповещение);
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюИзменитьФИО(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	// Если внесли изменение в ФИО.
	Если Форма.ФИОФизическихЛицНоваяЗапись И Форма.ВыполненаКомандаСменыФИО = Ложь Тогда
		Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюУдостоверениеЛичности", ЭтотОбъект, ДополнительныеПараметры);
		СотрудникиКлиент.ИзменитьФИОФизическогоЛица(Форма, Оповещение);
	Иначе 
		ФизическиеЛицаПередЗаписьюУдостоверениеЛичности(Ложь, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюУдостоверениеЛичности(Результат, ДополнительныеПараметры) Экспорт

	Отказ = (Результат = Неопределено);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	// Запрос про документ удостоверяющий личность.
	Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
    СотрудникиКлиент.ЗапроситьРежимИзмененияУдостоверенияЛичности(Форма, Форма.ДокументыФизическихЛиц.Период, Отказ, Оповещение);	
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюЗавершение(Отказ, ДополнительныеПараметры) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыЗаписи = ДополнительныеПараметры.ПараметрыЗаписи;
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Форма.Записать(ПараметрыЗаписи) Тогда
		
		Форма.Модифицированность = Ложь;
		Если ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
			Форма.Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


Процедура ЗапроситьРежимИзмененияФИО(Форма, МенеджерЗаписиФИО, НоваяЗапись, Отказ, ПредставлениеСущности, ОповещениеЗавершения = Неопределено)
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
	КонецЕсли;
		
КонецПроцедуры	

Процедура ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(Форма, ВедущийОбъект, ИмяСобытия, Параметр, Источник) Экспорт
		
КонецПроцедуры

#КонецОбласти