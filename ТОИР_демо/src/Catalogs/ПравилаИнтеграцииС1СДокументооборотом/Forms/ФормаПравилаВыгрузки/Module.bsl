
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИмяРеквизитаОбъектаДокументооборота", ИмяРеквизитаОбъектаДокументооборота);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаДокументооборота", ПредставлениеРеквизитаОбъектаДокументооборота);
	Параметры.Свойство("ТипРеквизитаОбъектаДокументооборота", ТипРеквизитаОбъектаДокументооборота);
	Параметры.Свойство("ВариантПравилаЗаполненияРеквизитов", ВариантПравилаЗаполненияРеквизитов);
	Параметры.Свойство("ИмяРеквизитаОбъектаПотребителя", ИмяРеквизитаОбъектаПотребителя);
	Параметры.Свойство("ЗначениеРеквизитаДокументооборота", ЗначениеРеквизитаДокументооборота);
	Параметры.Свойство("ИдентификаторЗначенияРеквизита", ИдентификаторЗначенияРеквизита);
	Параметры.Свойство("ТипЗначенияРеквизита", ТипЗначенияРеквизита);
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("ТипОбъектаПотребителя", ТипОбъектаПотребителя);
	Параметры.Свойство("ОбновлятьЗначение", ОбновлятьЗначение);
	Параметры.Свойство("ДополнительныйРеквизитДокументооборотаID", ДополнительныйРеквизитДокументооборотаID);
	Параметры.Свойство("ДополнительныйРеквизитДокументооборотаТип", ДополнительныйРеквизитДокументооборотаТип);
	Параметры.Свойство("Ключевой", Ключевой);
	Параметры.Свойство("ШаблонЗначение", ШаблонЗначение);
	Параметры.Свойство("ШаблонИдентификатор", ШаблонИдентификатор);
	Параметры.Свойство("ЗаполненВШаблоне", ЗаполненВШаблоне);
	
	РеквизитОбъекта = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта");
	УказанноеЗначение = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение");
	ВыражениеНаВстроенномЯзыке = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке");
	ИзШаблона = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ИзШаблона");
	НеЗаполнять = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ПустаяСсылка");
	
	Если ЗаполненВШаблоне Тогда
		
		СписокВариантов = Элементы.ВариантПравилаЗаполненияРеквизитов.СписокВыбора;
		СписокВариантов.Удалить(СписокВариантов.НайтиПоЗначению(НеЗаполнять));
		СписокВариантов.Добавить(ИзШаблона, НСтр("ru = 'Из шаблона'"));
			
		Элементы.СтраницыШаблон.ТекущаяСтраница = Элементы.СтраницаЗаполненВШаблоне;
			
		Если Параметры.ШаблонЗапрещаетИзменение = Истина
			Или ИмяРеквизитаОбъектаДокументооборота = "documentType" Тогда
			
			ШаблонЗапрещаетИзменение = Истина;
			
			ВариантПравилаЗаполненияРеквизитов = ИзШаблона;
			Элементы.ВариантПравилаЗаполненияРеквизитов.Доступность = Ложь;
			
			Если ИмяРеквизитаОбъектаДокументооборота = "documentType" Тогда
				ИнформационнаяНадпись = 
					НСтр("ru = 'Вид документа выбран в шаблоне и не может быть изменен.'");
			Иначе
				ИнформационнаяНадпись = 
					НСтр("ru = 'Шаблон запрещает изменение заданных в нем реквизитов.'");
			КонецЕсли;
				
		КонецЕсли;
		
	Иначе // не заполнен в шаблоне
		
		Элементы.СтраницыШаблон.ТекущаяСтраница = Элементы.СтраницаНеЗаполненВШаблоне;
		
		Если ИмяРеквизитаОбъектаДокументооборота = "documentType" Тогда
			ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение;
			Элементы.ВариантПравилаЗаполненияРеквизитов.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	// Выберем вариант по умолчанию.
	Если Не ЗначениеЗаполнено(ВариантПравилаЗаполненияРеквизитов) Тогда
		
		Если Не ЗаполненВШаблоне Тогда
			Если ИмяРеквизитаОбъектаДокументооборота = "folder"
				Или ИмяРеквизитаОбъектаДокументооборота = "accessLevel"
				Или ИмяРеквизитаОбъектаДокументооборота = "activityMatter" Тогда
				ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение;
				ОбновлятьЗначение = Ложь;
			Иначе
				ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта;
				ОбновлятьЗначение = Истина;
			КонецЕсли;
		Иначе
			ВариантПравилаЗаполненияРеквизитов = Перечисления.ВариантыПравилЗаполненияРеквизитов.ИзШаблона;
		КонецЕсли;
		
	КонецЕсли;
	
	// Настроим поле ввода для примитивных типов.
	ПервыйТип = ТипРеквизитаОбъектаДокументооборота[0].Значение;
	Если ЗначениеРеквизитаДокументооборота = Неопределено Тогда
		Если ПервыйТип = "Число" Тогда
			ЗначениеРеквизитаДокументооборота = 0;
		ИначеЕсли ПервыйТип = "Дата" Тогда
			ЗначениеРеквизитаДокументооборота = Дата(1, 1, 1);
		ИначеЕсли ПервыйТип = "Булево" Тогда
			ЗначениеРеквизитаДокументооборота = Ложь;
		Иначе // строка или ссылочный тип ДО
			ЗначениеРеквизитаДокументооборота = "";
		КонецЕсли;
	КонецЕсли;
	Если ПервыйТип = "Число"
		Или ПервыйТип = "Дата" Тогда
		Элементы.ЗначениеРеквизитаДокументооборота.КнопкаРегулирования = Истина;
	КонецЕсли;
	
	// Ограничим выбор вариантов заполнения и флажка Ключевой.
	Если ИмяРеквизитаОбъектаДокументооборота = "documentType" Тогда
		Ключевой = Истина;
		Элементы.Ключевой.Доступность = Ложь;
		Элементы.ОбновлятьЗначение.Доступность = Ложь;
	Иначе
		Если ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке
			Или ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта
			Или ВариантПравилаЗаполненияРеквизитов = НеЗаполнять Тогда
			Элементы.Ключевой.Доступность = Ложь;
		Иначе
			Элементы.Ключевой.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ДоступенФункционалОбмен = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP");
	Элементы.ОбновлятьЗначение.Видимость = ДоступенФункционалОбмен;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура КлючевойПриИзменении(Элемент)
	
	Если Ключевой Тогда
		Если ЗаполненВШаблоне Тогда
			Если ШаблонЗапрещаетИзменение Тогда
				ВариантПравилаЗаполненияРеквизитов = ИзШаблона;
				УстановитьДоступность();
			КонецЕсли;
		Иначе
			ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение;
			УстановитьДоступность();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПравилаЗаполненияРеквизитовПриИзменении(Элемент)
	
	Если ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке
		Или ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта
		Или (ВариантПравилаЗаполненияРеквизитов = НеЗаполнять
			И Не ЗаполненВШаблоне) Тогда
		Ключевой = Ложь;
		Элементы.Ключевой.Доступность = Ложь;
	Иначе
		Элементы.Ключевой.Доступность = Истина;
	КонецЕсли;
	
	ОбновлятьЗначение =
		ДоступенФункционалОбмен
		И (ОбновлятьЗначение Или ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта)
		И Не (ВариантПравилаЗаполненияРеквизитов = НеЗаполнять)
		И Не (ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение);
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяРеквизитаОбъектаПотребителяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьРеквизитОбъектаПотребителя();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДокументооборотаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипЗнч(ЗначениеРеквизитаДокументооборота) = Тип("Число")
		Или ТипЗнч(ЗначениеРеквизитаДокументооборота) = Тип("Дата")
		Или ТипЗнч(ЗначениеРеквизитаДокументооборота) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыбратьЗначениеРеквизитаДокументооборота(Элементы.ЗначениеРеквизитаДокументооборота);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДокументооборотаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; 
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗначениеРеквизитаДокументооборота = ВыбранноеЗначение.name;
		ИдентификаторЗначенияРеквизита = ВыбранноеЗначение.id;
		ТипЗначенияРеквизита = ВыбранноеЗначение.type;
	Иначе
		ЗначениеРеквизитаДокументооборота = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДокументооборотаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ПервыйТип = ТипРеквизитаОбъектаДокументооборота[0].Значение;
		Если ПервыйТип = "Строка"
			Или ПервыйТип = "Булево"
			Или ПервыйТип = "Дата"
			Или ПервыйТип = "Число" Тогда
			Возврат;
		КонецЕсли;
			
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			ПервыйТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаДокументооборотаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ПервыйТип = ТипРеквизитаОбъектаДокументооборота[0].Значение;
		Если ПервыйТип = "Строка"
			Или ПервыйТип = "Булево"
			Или ПервыйТип = "Дата"
			Или ПервыйТип = "Число" Тогда
			Возврат;
		КонецЕсли;
			
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			ПервыйТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ЗначениеРеквизитаДокументооборотаОбработкаВыбора(
				Элементы.ЗначениеРеквизитаДокументооборота,
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВычисляемоеВыражениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВычисляемоеВыражение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ВариантПравилаЗаполненияРеквизитов", ВариантПравилаЗаполненияРеквизитов);
	Результат.Вставить("ИмяРеквизитаОбъектаПотребителя");
	Результат.Вставить("ЗначениеРеквизитаДокументооборота");
	Результат.Вставить("ИдентификаторЗначенияРеквизита");
	Результат.Вставить("ТипЗначенияРеквизита");
	Результат.Вставить("ВычисляемоеВыражение");
	Результат.Вставить("Картинка");
	Результат.Вставить("ОбновлятьЗначение", ОбновлятьЗначение);
	Результат.Вставить("ДополнительныйРеквизитОбъекта", ДополнительныйРеквизитОбъекта);
	Результат.Вставить("ДополнительныйРеквизитОбъектаСвойство", ДополнительныйРеквизитОбъектаСвойство);
	Результат.Вставить("Ключевой", Ключевой);
	Результат.Вставить("ШаблонПредставление");
	
	Если ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта Тогда 
		
		Результат.ИмяРеквизитаОбъектаПотребителя = ИмяРеквизитаОбъектаПотребителя;
		Результат.Картинка = 1;
		
	ИначеЕсли ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение Тогда 
		
		Результат.ЗначениеРеквизитаДокументооборота = ЗначениеРеквизитаДокументооборота;
		Результат.ИдентификаторЗначенияРеквизита = ИдентификаторЗначенияРеквизита;
		Результат.ТипЗначенияРеквизита = ТипЗначенияРеквизита;
		
		// Проверим, нет ли конфликта правила и шаблона.
		Если ЗаполненВШаблоне И
			((ЗначениеЗаполнено(ИдентификаторЗначенияРеквизита) И ИдентификаторЗначенияРеквизита <> ШаблонИдентификатор)
			Или (Не ЗначениеЗаполнено(ИдентификаторЗначенияРеквизита) И ЗначениеРеквизитаДокументооборота <> ШаблонЗначение)) Тогда
			
			Результат.Картинка = 4;
			Результат.ШаблонПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'шаблон: %1'"),
				ШаблонЗначение);
			
		Иначе // конфликта нет
			
			Результат.Картинка = 2;
			
		КонецЕсли;
		
	ИначеЕсли ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке Тогда 
		
		Результат.ВычисляемоеВыражение = ВычисляемоеВыражение;
		Результат.Картинка = 3;
		
	ИначеЕсли ВариантПравилаЗаполненияРеквизитов = ИзШаблона Тогда 
		
		Результат.ШаблонПредставление = ШаблонЗначение;
		Результат.Картинка = 5;
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаПотребителя()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта", ТипОбъектаПотребителя);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаПотребителя", ИмяРеквизитаОбъектаПотребителя);
	ПараметрыФормы.Вставить("ПредставлениеРеквизитаОбъектаДокументооборота", ПредставлениеРеквизитаОбъектаДокументооборота);
	
	ИмяФормыВыбора = "Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыборРеквизитаПотребителя";
	Оповещение = Новый ОписаниеОповещения("ВыбратьРеквизитОбъектаПотребителяЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаПотребителяЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда 
		Результат.Свойство("Имя", ИмяРеквизитаОбъектаПотребителя);
		Результат.Свойство("ДополнительныйРеквизитОбъекта", ДополнительныйРеквизитОбъекта);
		Результат.Свойство("ДополнительныйРеквизитОбъектаСвойство", ДополнительныйРеквизитОбъектаСвойство);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДокументооборота(Элемент) 
	
	Типы = ТипРеквизитаОбъектаДокументооборота;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("ОписаниеТипа", ТипРеквизитаОбъектаДокументооборота);
	ПараметрыВыбора.Вставить("ТекстРедактирования", Элемент.ТекстРедактирования);
	
	Если Типы.Количество() = 1 Тогда 
		ВыбратьЗначениеРеквизитаДокументооборотаЗавершение(Типы[0].Значение, ПараметрыВыбора);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыбратьЗначениеРеквизитаДокументооборотаЗавершение",
			ЭтаФорма,
			ПараметрыВыбора);
		СписокТипов = Новый СписокЗначений;
		СписокТипов.ЗагрузитьЗначения(Типы);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДокументооборотаЗавершение(ЗначениеТипа, ПараметрыВыбора) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьЗначениеРеквизитаДокументооборотаЗавершениеВводаЗначения", ЭтаФорма);
	
	Если ЗначениеТипа = "Строка" Тогда 
		
		ЗначениеРеквизита = ПараметрыВыбора.ТекстРедактирования;
		
		ПоказатьВводСтроки(Оповещение, ЗначениеРеквизита,
			ПредставлениеРеквизитаОбъектаДокументооборота,, Истина);
		
	ИначеЕсли ЗначениеТипа = "Число" Тогда 
		ЗначениеРеквизита = ЗначениеРеквизитаДокументооборота;
		ПоказатьВводЧисла(Оповещение, ЗначениеРеквизита, 
			ПредставлениеРеквизитаОбъектаДокументооборота, 15, 5);
			
	ИначеЕсли ЗначениеТипа = "Дата" Тогда 
		ЗначениеРеквизита = ЗначениеРеквизитаДокументооборота;
		ПоказатьВводДаты(Оповещение, ЗначениеРеквизита, 
			ПредставлениеРеквизитаОбъектаДокументооборота, 
			ЧастиДаты.Дата); 
		
	ИначеЕсли ЗначениеТипа = "ДатаВремя" Тогда 
		ЗначениеРеквизита = ЗначениеРеквизитаДокументооборота;
		ПоказатьВводДаты(Оповещение, ЗначениеРеквизита, 
			ПредставлениеРеквизитаОбъектаДокументооборота, 
			ЧастиДаты.ДатаВремя); 
			
	ИначеЕсли ЗначениеТипа = "Время" Тогда 
		ЗначениеРеквизита = ЗначениеРеквизитаДокументооборота;
		ПоказатьВводДаты(Оповещение, ЗначениеРеквизита, 
			ПредставлениеРеквизитаОбъектаДокументооборота, 
			ЧастиДаты.Время); 
			
	ИначеЕсли ЗначениеТипа = "Булево" Тогда
		ЗначениеРеквизита = ЗначениеРеквизитаДокументооборота;
		ПоказатьВводЗначения(Оповещение, ЗначениеРеквизита, 
			ПредставлениеРеквизитаОбъектаДокументооборота, Тип("Булево"));
		
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТипОбъектаВыбора", ЗначениеТипа);
		Если ЗначениеЗаполнено(ИдентификаторЗначенияРеквизита)
			И ЗначениеТипа = ТипЗначенияРеквизита Тогда
			ПараметрыФормы.Вставить("ВыбранныйЭлемент", ИдентификаторЗначенияРеквизита);
		КонецЕсли;
		Если ЗначениеТипа = "DMObjectPropertyValue" Тогда 
			Владелец = Новый Структура;
			Владелец.Вставить("ID", 	ДополнительныйРеквизитДокументооборотаID);
			Владелец.Вставить("Type", 	ДополнительныйРеквизитДокументооборотаТип);
			
			Отбор = Новый Структура;
			Отбор.Вставить("AdditionalProperty", Владелец);
			
			ПараметрыФормы.Вставить("Отбор", Отбор);
		КонецЕсли;
		
		ИмяФормыВыбора = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИзСписка";
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаДокументооборотаЗавершениеВводаЗначения(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда 
			ЗначениеРеквизитаДокументооборота = Результат.РеквизитПредставление;
			ИдентификаторЗначенияРеквизита = Результат.РеквизитID;
			ТипЗначенияРеквизита = Результат.РеквизитТип;
		Иначе
			ЗначениеРеквизитаДокументооборота = Результат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражение();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВычисляемоеВыражение", ВычисляемоеВыражение);
	ПараметрыФормы.Вставить("ТипВыражения", "ПравилоВыгрузки");
	ПараметрыФормы.Вставить("ТипОбъектаПотребителя", ТипОбъектаПотребителя);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВычисляемоеВыражениеЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыражениеНаВстроенномЯзыке",
		ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражениеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда 
		ВычисляемоеВыражение = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ИмяРеквизитаОбъектаПотребителя.Доступность = (ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта);
	Элементы.ИмяРеквизитаОбъектаПотребителя.АвтоОтметкаНезаполненного = (ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта);
	Элементы.ИмяРеквизитаОбъектаПотребителя.ОтметкаНезаполненного = (ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта) И Не ЗначениеЗаполнено(ИмяРеквизитаОбъектаПотребителя);
	
	Элементы.ЗначениеРеквизитаДокументооборота.Доступность = (ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение);
	Элементы.ЗначениеРеквизитаДокументооборота.АвтоОтметкаНезаполненного = (ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение);
	Элементы.ЗначениеРеквизитаДокументооборота.ОтметкаНезаполненного = (ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение) И Не ЗначениеЗаполнено(ЗначениеРеквизитаДокументооборота);
	
	Элементы.ВычисляемоеВыражение.Доступность = (ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.АвтоОтметкаНезаполненного = (ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.ОтметкаНезаполненного = (ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке) И Не ЗначениеЗаполнено(ВычисляемоеВыражение);
	
	РазрешеноОбновление = Не ШаблонЗапрещаетИзменение
		И (ВариантПравилаЗаполненияРеквизитов <> УказанноеЗначение)
		И (ВариантПравилаЗаполненияРеквизитов <> ИзШаблона);
	Элементы.ОбновлятьЗначение.Доступность = РазрешеноОбновление;
	ОбновлятьЗначение = ОбновлятьЗначение И РазрешеноОбновление;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ВариантПравилаЗаполненияРеквизитов = РеквизитОбъекта Тогда 
		ПроверяемыеРеквизиты.Добавить("ИмяРеквизитаОбъектаПотребителя");
		
	ИначеЕсли ВариантПравилаЗаполненияРеквизитов = УказанноеЗначение Тогда 
		ПроверяемыеРеквизиты.Добавить("ЗначениеРеквизитаДокументооборота");
		
	ИначеЕсли ВариантПравилаЗаполненияРеквизитов = ВыражениеНаВстроенномЯзыке Тогда 
		ПроверяемыеРеквизиты.Добавить("ВычисляемоеВыражение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти