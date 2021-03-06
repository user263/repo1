#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТекСтруктураИерархии") Тогда
		ТекСтруктураИерархии = Параметры.ТекСтруктураИерархии;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивОР") Тогда
		Для каждого Элем Из Параметры.МассивОР Цикл
			МассивОР.Добавить(Элем);
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивОРВерхнегоУровня") Тогда
		ЗаполнитьДеревоНаСервере(Параметры.МассивОРВерхнегоУровня);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ПередатьМассив И Не ЗавершениеРаботы Тогда 
		СписокВозврата = Новый СписокЗначений;
		ОбойтиДерево(СписокВозврата, ДеревоИерархии.ПолучитьЭлементы()[0]);
		Оповестить("ПродолжитьОперацию", СписокВозврата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДерево(СписокВозврата, Узел)
	
	Для каждого ТекСтрока из Узел.ПолучитьЭлементы() Цикл
		Если ТекСтрока.Выделить = 1 и ТекСтрока.Выбран = Ложь Тогда
			СписокВозврата.Добавить(ТекСтрока.Ссылка);
		КонецЕсли;
		ОбойтиДерево(СписокВозврата, ТекСтрока)
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого текЭлем из МассивОР Цикл
		масРодителей = Новый Массив;
		масРодителей.Добавить(ТекЭлем.Значение);
		ПолучитьЦепочкуРодителей(ТекЭлем.Значение, масРодителей);
		
		элементы.ДеревоИерархии.Развернуть(ДеревоИерархии.ПолучитьЭлементы()[0].ПолучитьИдентификатор());
		ДеревоЭлементы = ДеревоИерархии.ПолучитьЭлементы()[0].ПолучитьЭлементы();
		Для каждого текПос из МасРодителей Цикл
			Для каждого текСтрока из ДеревоЭлементы Цикл
				Если текСтрока.Ссылка = текПос Тогда
					идентСтроки = текСтрока.ПолучитьИдентификатор();
					Если элементы.ДеревоИерархии.Развернут(идентСтроки) = Ложь Тогда
						элементы.ДеревоИерархии.Развернуть(идентСтроки, Ложь);
					КонецЕсли;
					ДеревоЭлементы = текСтрока.ПолучитьЭлементы();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервере 
Процедура ПолучитьЦепочкуРодителей(ОР, МасРодителей)
	
	Если ТекСтруктураИерархии.ИзменяетсяДокументами Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			           |	ИерархияОР.РодительИерархии
			           |ИЗ
			           |	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(
			           |			&Период,
			           |			СтруктураИерархии = &СИ
			           |				И ОбъектИерархии = &ОР) КАК ИерархияОР";
		
		Запрос.УстановитьПараметр("Период", ТекущаяДата());
		Запрос.УстановитьПараметр("СИ", ТекСтруктураИерархии);
		Запрос.УстановитьПараметр("ОР", ОР);
		
		резЗапроса = Запрос.Выполнить();
		Выборка = резЗапроса.Выбрать();
		Если Выборка.Следующий() И Выборка.РодительИерархии <> Справочники.торо_ОбъектыРемонта.ПустаяСсылка() Тогда 
			МасРодителей.Вставить(0, Выборка.РодительИерархии);
			ПолучитьЦепочкуРодителей(Выборка.РодительИерархии, МасРодителей); 
		КонецЕсли;		
	Иначе 
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	торо_ИерархическиеСтруктурыОР.РодительИерархии
		               |ИЗ
		               |	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
		               |ГДЕ
		               |	торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии
		               |	И торо_ИерархическиеСтруктурыОР.ОбъектИерархии = &ОбъектИерархии";
					   
		Запрос.УстановитьПараметр("СтруктураИерархии", ТекСтруктураИерархии);
		Запрос.УстановитьПараметр("ОбъектИерархии", ОР);
		
		резЗапроса = Запрос.Выполнить();
		Выборка = резЗапроса.Выбрать();
		Если Выборка.Следующий() И Выборка.РодительИерархии <> Справочники.торо_ОбъектыРемонта.ПустаяСсылка() Тогда 
			МасРодителей.Вставить(0, Выборка.РодительИерархии);
			ПолучитьЦепочкуРодителей(Выборка.РодительИерархии, МасРодителей); 
		КонецЕсли;
		
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоИерархии

&НаКлиенте
Процедура ДеревоИерархииПередРазворачиванием(Элемент, Строка, Отказ)
	ТекДанные = ДеревоИерархии.НайтиПоИдентификатору(Строка);
	
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.Ссылка) И НЕ ТекДанные.СвязиОбновлялись Тогда
		
		СтрокиДерева = ТекДанные.ПолучитьЭлементы();
		Если СтрокиДерева.Количество() > 0 Тогда
			СтруктураДобавления = ПолучитьСтруктуруНовыхСтрок(ТекДанные.Ссылка, ТекСтруктураИерархии);
		КонецЕсли;
		ТекДанные.СвязиОбновлялись = Истина;
		
		Для каждого СтрокаДерева Из СтрокиДерева Цикл
			СтрокаДереваЭлементы = СтрокаДерева.ПолучитьЭлементы();
			Для каждого ТекЭлем Из СтруктураДобавления Цикл
				Если ТекЭлем.Значение.Родитель <> СтрокаДерева.Ссылка Тогда
					Продолжить;
				КонецЕсли;
				НС = СтрокаДереваЭлементы.Добавить();
				
				Если СтроитсяАвтоматически И ТипЗнч(ТекЭлем.Ключ) <> Тип("Число") Тогда
					НС.Ссылка = ТекЭлем.Ключ;
				Иначе
					НС.Ссылка = ТекЭлем.Значение.ОбъектИерархии;
					НС.РеквизитДопУпорядочивания = ТекЭлем.Значение.РеквизитДопУпорядочиванияОР;
				КонецЕсли;
				
				Если НЕ МассивОР.НайтиПоЗначению(НС.Ссылка)= Неопределено Тогда
					НС.Выделить = 1;
					НС.Выбран = Истина;
				Иначе
					НС.Выделить = 0;
				КонецЕсли;
				
				НС.РодительИерархии = ТекЭлем.Значение.Родитель;
				НС.ПометкаУдаления = ТекЭлем.Значение.ПометкаУдаления;
				НС.Картинка = ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(НС.Ссылка, ТекСтруктураИерархии);
				
			КонецЦикла;
		КонецЦикла;		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОперацию(Команда)
	
	ПередатьМассив = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере 
Процедура ЗаполнитьДеревоНаСервере(МассивОР)
	Запрос = Новый Запрос;
	
	ДеревоСФормы = РеквизитФормыВЗначение("ДеревоИерархии");
	
	ИзменяетсяДокументами = ТекСтруктураИерархии.ИзменяетсяДокументами;
	СтроитсяАвтоматически = ТекСтруктураИерархии.СтроитсяАвтоматически;
	Если СтроитсяАвтоматически Тогда
		ИерархическийСправочник = Метаданные.Справочники[ТекСтруктураИерархии.ТипРеквизитаОР].Иерархический;
	КонецЕсли;
	
	НС = ДеревоСФормы.Строки.Добавить();
	КоличествоЭлементовВДереве = КоличествоЭлементовВДереве + 1;
	НС.Ссылка   = ТекСтруктураИерархии;
	НС.Картинка = ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(НС.Ссылка, ТекСтруктураИерархии);
	НС.СвязиОбновлялись = Истина;
	
	ЗаполнитьОсновноеВДеревеСервере(НС, Справочники.торо_ОбъектыРемонта.ПустаяСсылка());
	
	ЗначениеВРеквизитФормы(ДеревоСФормы, "ДеревоИерархии");	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(СсылкаСтроки, СтруктураИерархии, ПометкаУдаления = Неопределено)
	
	Если ТипЗнч(СсылкаСтроки) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	торо_ОбъектыРемонтаГруппы.ОбъектИерархии,
		|	торо_ОбъектыРемонтаГруппы.СтруктураИерархии,
		|	торо_ОбъектыРемонтаГруппы.ОбъектГруппа
		|ИЗ
		|	РегистрСведений.торо_ОбъектыРемонтаГруппы КАК торо_ОбъектыРемонтаГруппы
		|ГДЕ
		|	торо_ОбъектыРемонтаГруппы.ОбъектИерархии = &ОбъектИерархии
		|	И торо_ОбъектыРемонтаГруппы.СтруктураИерархии = &СтруктураИерархии
		|	И торо_ОбъектыРемонтаГруппы.ОбъектГруппа";
		
		Запрос.УстановитьПараметр("ОбъектИерархии", СсылкаСтроки);
		Запрос.УстановитьПараметр("СтруктураИерархии", СтруктураИерархии);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ТабВыборки = РезультатЗапроса.Выгрузить();
		
		Если СсылкаСтроки.ЭтоГруппа Тогда
			ИндексКартинки = ?(ПометкаУдаления = Неопределено,?(СсылкаСтроки.ПометкаУдаления, 6, 5),?(ПометкаУдаления, 6, 5));
		ИначеЕсли ТабВыборки.Количество() > 0 Тогда
			ИндексКартинки = ?(ПометкаУдаления = Неопределено,?(СсылкаСтроки.ПометкаУдаления, 3, 2),?(ПометкаУдаления, 3, 2));
		Иначе
			ИндексКартинки = ?(ПометкаУдаления = Неопределено,?(СсылкаСтроки.ПометкаУдаления, 1, 0),?(ПометкаУдаления, 1, 0));
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(СсылкаСтроки) = Тип("Строка") Тогда
		
		ИндексКартинки = 9;
		
	ИначеЕсли ТипЗнч(СсылкаСтроки) <> Тип("СправочникСсылка.торо_СтруктурыОР") И ТипЗнч(СсылкаСтроки) <> Тип("Строка") Тогда 
		
		ИндексКартинки = ?(ПометкаУдаления = Неопределено,?(СсылкаСтроки.ПометкаУдаления, 10, 9),?(ПометкаУдаления, 10, 9));
		
	Иначе
		
		ИндексКартинки = 4;
		
	КонецЕсли;
	
	Возврат ИндексКартинки;
	
КонецФункции // ОпределитьИндексКартинки()

&НаСервере
Процедура ЗаполнитьОсновноеВДеревеСервере(СтрокаДерева, РодительИерархии, ЕстьКартинка = Истина)
	
	Если ТекСтруктураИерархии.ИзменяетсяДокументами Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии,
		|	торо_ИерархическиеСтруктурыОР.РодительИерархии,
		|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии
		|ПОМЕСТИТЬ РасположениеОР
		|ИЗ
		|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(, СтруктураИерархии = &СтруктураИерархии) КАК торо_ИерархическиеСтруктурыОР
		|ГДЕ
		|	торо_ИерархическиеСтруктурыОР.Удален = ЛОЖЬ
		|	И торо_ИерархическиеСтруктурыОР.РодительИерархии = &РодительИерархии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.ОбъектИерархии,
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.СтруктураИерархии,
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии
		|ПОМЕСТИТЬ ТабБезПорядка
		|ИЗ
		|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(, СтруктураИерархии = &СтруктураИерархии) КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних
		|ГДЕ
		|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии В
		|			(ВЫБРАТЬ
		|				РасположениеОР.ОбъектИерархии
		|			ИЗ
		|				РасположениеОР КАК РасположениеОР)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РасположениеОР.ОбъектИерархии,
		|	РасположениеОР.СтруктураИерархии,
		|	РасположениеОР.РодительИерархии
		|ИЗ
		|	РасположениеОР КАК РасположениеОР
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабБезПорядка.ОбъектИерархии,
		|	ТабБезПорядка.СтруктураИерархии,
		|	ТабБезПорядка.РодительИерархии,
		|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР КАК РеквизитДопУпорядочиванияОР
		|ИЗ
		|	ТабБезПорядка КАК ТабБезПорядка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ПорядокОРПоИерархии КАК торо_ПорядокОРПоИерархии
		|		ПО ТабБезПорядка.ОбъектИерархии = торо_ПорядокОРПоИерархии.ОбъектРемонта
		|			И ТабБезПорядка.СтруктураИерархии = торо_ПорядокОРПоИерархии.СтруктураИерархии
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочиванияОР";
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии,
		|	торо_ИерархическиеСтруктурыОР.РодительИерархии,
		|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии
		|ПОМЕСТИТЬ РасположениеОР
		|ИЗ
		|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
		|ГДЕ
		|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии
		|	И торо_ИерархическиеСтруктурыОР.РодительИерархии = &РодительИерархии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	торо_ИерархическиеСтруктурыОР.ОбъектИерархии,
		|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии,
		|	торо_ИерархическиеСтруктурыОР.РодительИерархии
		|ПОМЕСТИТЬ ТабБезПорядка
		|ИЗ
		|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
		|ГДЕ
		|	торо_ИерархическиеСтруктурыОР.РодительИерархии В
		|			(ВЫБРАТЬ
		|				РасположениеОР.ОбъектИерархии
		|			ИЗ
		|				РасположениеОР КАК РасположениеОР)
		|	И торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РасположениеОР.ОбъектИерархии,
		|	РасположениеОР.СтруктураИерархии,
		|	РасположениеОР.РодительИерархии
		|ИЗ
		|	РасположениеОР КАК РасположениеОР
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабБезПорядка.ОбъектИерархии,
		|	ТабБезПорядка.СтруктураИерархии,
		|	ТабБезПорядка.РодительИерархии,
		|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР КАК РеквизитДопУпорядочиванияОР
		|ИЗ
		|	ТабБезПорядка КАК ТабБезПорядка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ПорядокОРПоИерархии КАК торо_ПорядокОРПоИерархии
		|		ПО ТабБезПорядка.ОбъектИерархии = торо_ПорядокОРПоИерархии.ОбъектРемонта
		|			И ТабБезПорядка.СтруктураИерархии = торо_ПорядокОРПоИерархии.СтруктураИерархии
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочиванияОР";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СтруктураИерархии", ТекСтруктураИерархии);
	Запрос.УстановитьПараметр("РодительИерархии", РодительИерархии);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаИерархии = РезультатЗапроса.Выгрузить();	
	
	СтруктураПоиска = Новый Структура("РодительИерархии", РодительИерархии);
	МассивКорневыхСтрок = ТаблицаИерархии.НайтиСтроки(СтруктураПоиска);
	
	Для каждого Элем Из МассивКорневыхСтрок Цикл
		
		НовСтрокаДерева = СтрокаДерева.Строки.Добавить();
		КоличествоЭлементовВДереве = КоличествоЭлементовВДереве + 1;
		НовСтрокаДерева.Ссылка = Элем.ОбъектИерархии;
		НовСтрокаДерева.РодительИерархии = Элем.РодительИерархии;
		НовСтрокаДерева.ПометкаУдаления = Элем.ОбъектИерархии.ПометкаУдаления;
		НовСтрокаДерева.Картинка = ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(НовСтрокаДерева.Ссылка, ТекСтруктураИерархии);
		НовСтрокаДерева.РеквизитДопУпорядочивания = Элем.РеквизитДопУпорядочиванияОР;
		
		Если НЕ МассивОР.НайтиПоЗначению(Элем.ОбъектИерархии) = Неопределено Тогда
			НовСтрокаДерева.Выделить = 1;
			НовСтрокаДерева.Выбран = Истина;
		Иначе 
			НовСтрокаДерева.Выделить = 0;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("РодительИерархии", Элем.ОбъектИерархии);
		МассивСтрок = ТаблицаИерархии.НайтиСтроки(СтруктураПоиска);
		
		Для каждого ЭлементМассива ИЗ МассивСтрок Цикл
			НС = НовСтрокаДерева.Строки.Добавить();
			КоличествоЭлементовВДереве = КоличествоЭлементовВДереве + 1;
			НС.Ссылка = ЭлементМассива.ОбъектИерархии;
			НС.РодительИерархии = ЭлементМассива.РодительИерархии;
			НС.ПометкаУдаления = ЭлементМассива.ОбъектИерархии.ПометкаУдаления;
			НС.Картинка = ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(НС.Ссылка, ТекСтруктураИерархии);
			НС.РеквизитДопУпорядочивания = ЭлементМассива.РеквизитДопУпорядочиванияОР;
			Если НЕ МассивОР.НайтиПоЗначению(ЭлементМассива.ОбъектИерархии) = Неопределено Тогда
				НС.Выделить = 1;
				НС.Выбран = Истина;
			Иначе 
				НС.Выделить = 0;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруНовыхСтрок(Ссылка, СтруктураИерархии)
	
	Если СтруктураИерархии.СтроитсяАвтоматически Тогда
		
		СтруктураВозврата = Новый Соответствие;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	СправочникСсылка.Родитель,
		|	СправочникСсылка.Ссылка,
		|	СправочникСсылка.ПометкаУдаления
		|ПОМЕСТИТЬ ТабПодразделений
		|ИЗ
		|	Справочник." + СтруктураИерархии.ТипРеквизитаОР + " КАК СправочникСсылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник." + СтруктураИерархии.ТипРеквизитаОР + " КАК СпрСсылка
		|		ПО СправочникСсылка.Родитель = СпрСсылка.Ссылка
		|ГДЕ
		|	СпрСсылка.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправочникСсылка.Ссылка,
		|	СправочникСсылка.Родитель,
		|	СправочникСсылка.ПометкаУдаления
		|ПОМЕСТИТЬ ИтогТаб1
		|ИЗ
		|	ТабПодразделений КАК ТабПодразделений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник." + СтруктураИерархии.ТипРеквизитаОР + " КАК СправочникСсылка
		|		ПО ТабПодразделений.Ссылка = СправочникСсылка.Родитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИтогТаб1.Ссылка,
		|	ИтогТаб1.Родитель,
		|	ИтогТаб1.ПометкаУдаления
		|ИЗ
		|	ИтогТаб1 КАК ИтогТаб1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(1) КАК Количество,
		|	ТабПодразделений.ПометкаУдаления,
		|	ТабПодразделений.Ссылка КАК Ссылка
		|ИЗ
		|	ТабПодразделений КАК ТабПодразделений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
		|		ПО ТабПодразделений.Ссылка = торо_ОбъектыРемонта." + СтруктураИерархии.РеквизитОР + " 
		|
		|СГРУППИРОВАТЬ ПО
		|	ТабПодразделений.ПометкаУдаления,
		|	ТабПодразделений.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	торо_ОбъектыРемонта.Ссылка,
		|	торо_ОбъектыРемонта.ПометкаУдаления,
		|	ТабПодразделений.Ссылка КАК Родитель,
		|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР
		|ИЗ
		|	ТабПодразделений КАК ТабПодразделений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ПорядокОРПоИерархии КАК торо_ПорядокОРПоИерархии
		|			ПО торо_ОбъектыРемонта.Ссылка = торо_ПорядокОРПоИерархии.ОбъектРемонта
		|		ПО ТабПодразделений.Ссылка = торо_ОбъектыРемонта."+ СтруктураИерархии.РеквизитОР + "
		|ГДЕ
		|	торо_ПорядокОРПоИерархии.СтруктураИерархии = &СтруктураИерархии
		|
		|УПОРЯДОЧИТЬ ПО
		 |	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("СтруктураИерархии", СтруктураИерархии);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Выборка = РезультатЗапроса[3].Выбрать();
		Таб = РезультатЗапроса[2].Выгрузить();
		Пока Выборка.Следующий() Цикл 
			
			МассивСтрок = Таб.НайтиСтроки(Новый Структура("Родитель", Выборка.Ссылка));
			Если Выборка.Количество > 0 И МассивСтрок.Количество() > 0 Тогда
				СтруктураВозврата.Вставить(Выборка.Ссылка, Новый Структура("Родитель, ПометкаУдаления", Выборка.Ссылка, Выборка.ПометкаУдаления));	
			КонецЕсли;
		КонецЦикла;
		
		Выборка = РезультатЗапроса[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураВозврата.Вставить(Выборка.Ссылка, Новый Структура("Родитель, ПометкаУдаления", Выборка.Родитель, Выборка.ПометкаУдаления));
		КонецЦикла;
		
		Выборка = РезультатЗапроса[4].Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивСтрок = Таб.НайтиСтроки(Новый Структура("Родитель", Выборка.Родитель));
			Если МассивСтрок.Количество() = 0 Тогда
				СтруктураВозврата.Вставить(Выборка.РеквизитДопУпорядочиванияОР, Новый Структура("ОбъектИерархии, Родитель, ПометкаУдаления", Выборка.Ссылка, Выборка.Родитель, Выборка.ПометкаУдаления));
			КонецЕсли;
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	торо_ОбъектыРемонта.Ссылка,
		|	торо_ОбъектыРемонта.ПометкаУдаления,
		|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР
		|ИЗ
		|	Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ПорядокОРПоИерархии КАК торо_ПорядокОРПоИерархии
		|		ПО торо_ОбъектыРемонта.Ссылка = торо_ПорядокОРПоИерархии.ОбъектРемонта
		|ГДЕ
		|	торо_ПорядокОРПоИерархии.СтруктураИерархии = &СтруктураИерархии
		|	И торо_ОбъектыРемонта." + СтруктураИерархии.РеквизитОР + " = &Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР";
		
		Запрос.УстановитьПараметр("Подразделение", Ссылка);
		Запрос.УстановитьПараметр("СтруктураИерархии", СтруктураИерархии);
		
		РезЗапроса = Запрос.Выполнить();
		
		Выборка = РезЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СтруктураВозврата.Вставить(Выборка.РеквизитДопУпорядочиванияОР, Новый Структура("ОбъектИерархии, Родитель, ПометкаУдаления", Выборка.Ссылка, Ссылка, Выборка.ПометкаУдаления));
		КонецЦикла;

	Иначе
		
		СтруктураВозврата = Новый Соответствие;
		
		Если СтруктураИерархии.ИзменяетсяДокументами Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	торо_РасположениеОРВСтруктуреИерархии.ОбъектИерархии КАК Ссылка,
			|	торо_РасположениеОРВСтруктуреИерархии.СтруктураИерархии,
			|	торо_РасположениеОРВСтруктуреИерархии.РодительИерархии,
			|	торо_РасположениеОРВСтруктуреИерархии.ОбъектИерархии.ПометкаУдаления КАК ПометкаУдаления
			|ПОМЕСТИТЬ ТабБезПорядка
			|ИЗ
			|	РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(, СтруктураИерархии = &СтруктураИерархии) КАК торо_РасположениеОРВСтруктуреИерархииСрезПоследних
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.торо_РасположениеОРВСтруктуреИерархии.СрезПоследних(, СтруктураИерархии = &СтруктураИерархии) КАК торо_РасположениеОРВСтруктуреИерархии
			|		ПО (торо_РасположениеОРВСтруктуреИерархии.РодительИерархии = торо_РасположениеОРВСтруктуреИерархииСрезПоследних.ОбъектИерархии)
			|ГДЕ
			|	торо_РасположениеОРВСтруктуреИерархииСрезПоследних.РодительИерархии = &РодительИерархии
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТабБезПорядка.Ссылка,
			|	ТабБезПорядка.СтруктураИерархии,
			|	ТабБезПорядка.РодительИерархии,
			|	ТабБезПорядка.ПометкаУдаления,
			|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР КАК РеквизитДопУпорядочиванияОР
			|ИЗ
			|	ТабБезПорядка КАК ТабБезПорядка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ПорядокОРПоИерархии КАК торо_ПорядокОРПоИерархии
			|		ПО ТабБезПорядка.Ссылка = торо_ПорядокОРПоИерархии.ОбъектРемонта
			|			И ТабБезПорядка.СтруктураИерархии = торо_ПорядокОРПоИерархии.СтруктураИерархии
			|
			|УПОРЯДОЧИТЬ ПО
			|	РеквизитДопУпорядочиванияОР";
			
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ИерархическиеСтруктурыОР.ОбъектИерархии КАК Ссылка,
			|	ИерархическиеСтруктурыОР.СтруктураИерархии,
			|	ИерархическиеСтруктурыОР.РодительИерархии,
			|	ИерархическиеСтруктурыОР.ОбъектИерархии.ПометкаУдаления КАК ПометкаУдаления
			|ПОМЕСТИТЬ ТабБезПорядка
			|ИЗ
			|	РегистрСведений.торо_ИерархическиеСтруктурыОР КАК торо_ИерархическиеСтруктурыОР
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.торо_ИерархическиеСтруктурыОР КАК ИерархическиеСтруктурыОР
			|		ПО (ИерархическиеСтруктурыОР.РодительИерархии = торо_ИерархическиеСтруктурыОР.ОбъектИерархии)
			|ГДЕ
			|	торо_ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии
			|	И торо_ИерархическиеСтруктурыОР.РодительИерархии = &РодительИерархии
			|	И ИерархическиеСтруктурыОР.СтруктураИерархии = &СтруктураИерархии		              
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТабБезПорядка.Ссылка,
			|	ТабБезПорядка.СтруктураИерархии,
			|	ТабБезПорядка.РодительИерархии,
			|	ТабБезПорядка.ПометкаУдаления,
			|	торо_ПорядокОРПоИерархии.РеквизитДопУпорядочиванияОР КАК РеквизитДопУпорядочиванияОР
			|ИЗ
			|	ТабБезПорядка КАК ТабБезПорядка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.торо_ПорядокОРПоИерархии КАК торо_ПорядокОРПоИерархии
			|		ПО ТабБезПорядка.Ссылка = торо_ПорядокОРПоИерархии.ОбъектРемонта
			|			И ТабБезПорядка.СтруктураИерархии = торо_ПорядокОРПоИерархии.СтруктураИерархии
			|
			|УПОРЯДОЧИТЬ ПО
			|	РеквизитДопУпорядочиванияОР";
		КонецЕсли;		
		
		Запрос.УстановитьПараметр("СтруктураИерархии", СтруктураИерархии);				
		Запрос.УстановитьПараметр("РодительИерархии", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураВозврата.Вставить(Выборка.Ссылка, 
				Новый Структура("ОбъектИерархии, Родитель, ПометкаУдаления, РеквизитДопУпорядочиванияОР",
					Выборка.Ссылка, Выборка.РодительИерархии, Выборка.ПометкаУдаления, Выборка.РеквизитДопУпорядочиванияОР));
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура ПроставитьГалочкиПоВеткеВниз(СтрокаДерева, ЗначГалки)
	
	Для Каждого Элем Из СтрокаДерева.ПолучитьЭлементы() Цикл
		
		Элем.Выбран = ЗначГалки;
		ПроставитьГалочкиПоВеткеВниз(Элем, ЗначГалки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроставитьГалочкиПоВеткеВверх(СтрокаДерева, ЗначГалки)
	
	СтрРодитель = СтрокаДерева.ПолучитьРодителя();
	
	Если ТипЗнч(СтрРодитель.Ссылка) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
		ПодчиненныеСтроки = СтрРодитель.ПолучитьЭлементы();
		Если ПодчиненныеСтроки.Количество() > 1 Тогда
			Для каждого Стр Из ПодчиненныеСтроки Цикл
				Стр.Выбран = ЗначГалки;
				ПроставитьГалочкиПоВеткеВниз(Стр, ЗначГалки);
			КонецЦикла;
		КонецЕсли;
		
		СтрРодитель.Выбран = ЗначГалки;
		ПроставитьГалочкиПоВеткеВверх(СтрРодитель, ЗначГалки);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти