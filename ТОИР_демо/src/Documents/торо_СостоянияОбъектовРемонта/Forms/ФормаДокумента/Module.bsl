////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ
Перем массивдоступныхстатусов;

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Основание") Тогда
		торо_ЗаполнениеДокументов.ПроверитьВозможностьВводаНаОсновании(Параметры.Основание,Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли; 
		
		Если Параметры.Свойство("ДокументОснование") И ТипЗнч(Параметры.ДокументОснование) = Тип("ДокументСсылка.торо_ВыявленныеДефекты") Тогда
			
			Если Параметры.Свойство("МассивОР") Тогда
				
				Объект.Организация 		 = Параметры.Организация;
				Объект.Подразделение 	 = Параметры.Подразделение;
				Объект.ДокументОснование = Параметры.ДокументОснование;
				ТекСтруктураИерархии 	 = Параметры.СтруктураИерархии;
				
				// Объект.ВидОперации устанавливается далее по коду.
				
				ВидЭксплуатацииПриСозданииНаОсновании = Константы.торо_ВидЭксплуатацииДляВводаНаОснованииВыявленногоДефекта.Получить();
				
				Для Каждого ОР Из Параметры.МассивОР Цикл
					
			        НС = Объект.ОбъектыРемонта.Добавить();
			        НС.ОбъектРемонта = ОР;
			        НС.ДатаОкончания = Параметры.ДатаОбнаруженияДефекта;
			        НС.ВидЭксплуатации = ВидЭксплуатацииПриСозданииНаОсновании;
			        НС.Иерархия = Параметры.СтруктураИерархии;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЕсли;
	
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
	
	Если Параметры.Свойство("ВидОперации") Тогда
		Объект.ВидОперации = Параметры.ВидОперации;
	Иначе		
		Объект.ВидОперации = ?(ЗначениеЗаполнено(Объект.ВидОперации), Объект.ВидОперации, Перечисления.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатации);
	КонецЕсли;
	
	// Вывести в заголовке формы вид операции.
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), РеквизитФормыВЗначение("Объект"), ЭтаФорма);
	
	мОтображатьПоложение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиТОиР",
			"ПоказыватьПоложениеОР",
			Истина);
		
	Элементы.ОбъектыРемонтаОтображатьПоложение.Пометка = мОтображатьПоложение;
	Элементы.ОбъектыРемонтаПоложение.Видимость = мОтображатьПоложение;
	
	Если Не ЗначениеЗаполнено(ТекСтруктураИерархии) Тогда
		ТекСтруктураИерархии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"НастройкиТОиР",
				"ОсновнаяСтруктураИерархии",
				Истина);
	КонецЕсли;
		
	УстановитьОбязательностьЗаполнения();
	// Ограничение ввода на основании
	торо_СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, Новый Структура("ОграничитьВводНаОсновании, УстановитьСвойствоЭлементовФормыОтПрав",Истина, Истина));
	
	ВидПускаПростой = Перечисления.торо_ТипЭксплуатации.Простой;
	
	Если ЗначениеЗаполнено(Объект.ВидЭксплуатации) Тогда
		ТипЭксплуатации = Объект.ВидЭксплуатации.ТипЭксплуатации;
		ОбязательныйВводВидаПуска = Объект.ВидЭксплуатации.ОбязательныйВводВидаПуска;
	КонецЕсли;
	ЗаполнитьДобавочныеРеквизитыТЧ();
	УстановитьФлагиОбязательностиЗаполненияПричиныПростоя();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	УстановитьОбязательностьЗаполнения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если мОтображатьПоложение Тогда	
		
		ЗаполнитьПоложенияОР();
		
	КонецЕсли;
	
	УстановитьВнешнийВидФормы();
	УстановитьЗаголовокПодменюВидаОперации();
	
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
	
	Если ТекущийОбъект.ВидОперации = Перечисления.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод Тогда
		Для Каждого СтрокаОР Из ТекущийОбъект.ОбъектыРемонта Цикл
			
			Если СтрокаОР.ДатаНачала > СтрокаОР.ДатаОкончания Тогда
				торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для объекта ремонта %1 в строке № %2 дата начала периода больше даты окончания периода!'"),СтрокаОР.ОбъектРемонта,СтрокаОР.НомерСтроки));
				Отказ = Истина; 
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	торо_РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(ТекущийОбъект.ВидОперации), ТекущийОбъект, ЭтаФорма);
	ЗаполнитьДобавочныеРеквизитыТЧ();
	УстановитьФлагиОбязательностиЗаполненияПричиныПростоя();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = тип("СписокЗначений") Тогда
	КонецЕсли;
	
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
Процедура ВидЭксплуатацииПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ВидЭксплуатации) Тогда
		РеквизитыВидаЭксплуатации = УстановитьТипЭксплуатации(Объект.ВидЭксплуатации);
		ТипЭксплуатации = РеквизитыВидаЭксплуатации.ТипЭксплуатации;
		ОбязательныйВводВидаПуска = РеквизитыВидаЭксплуатации.ОбязательныйВводВидаПуска; 
	Иначе
		ТипЭксплуатации = ТипЭксплуатации.Пустая();
		ОбязательныйВводВидаПуска = Ложь;
	КонецЕсли;
	
	ТипыЭксплуатации = ПолучитьТипыЭксплуатацииДокументаНаСервере(Объект.ОбъектыРемонта);
	УстановитьФлагиОбязательностиЗаполненияПричиныПростоя();
	Если ЗначениеЗаполнено(Объект.ВидЭксплуатации) И НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатации) Тогда
		Если Элементы.ОбъектыРемонтаВидЭксплуатации.Видимость Тогда
			Элементы.ОбъектыРемонтаВидПуска.Видимость = Истина; 
		Иначе
			Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость = Истина;
		КонецЕсли;
	Иначе
		УстановитьВидимостьКолонокВидовПусков(ТипыЭксплуатации);
	КонецЕсли;
	УстановитьВидимостьКолонкиПричинаПростоя(ТипыЭксплуатации);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбъектыРемонта
&НаКлиенте
Процедура ОбъектыРемонтаОбъектРемонтаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыВыбора, СтандартнаяОбработка)
	ПараметрыВыбора.Отбор.Вставить("Документ", Строка(ТипЗнч(Объект.Ссылка)));
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаОбъектРемонтаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыВыбора, Ожидание, СтандартнаяОбработка)
	ПараметрыВыбора.Отбор.Вставить("Документ", Строка(ТипЗнч(Объект.Ссылка)));
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекДанные = Элемент.ТекущиеДанные;
		ТекДанные.Иерархия = ТекСтруктураИерархии;
		ТекДанные.ПричинаПростояОбязательностьЗаполнения = ОпределитьНеобходимостьЗаполненияПричиныПростояПоСтроке(ТекДанные, Объект.ВидОперации, ТипЭксплуатации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаОбъектРемонтаПриИзменении(Элемент)
	 	
	ТекущиеДанные = Элементы.ОбъектыРемонта.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		Если ПроверитьЕстьЛиПодчиненныеОР(ТекущиеДанные.ОбъектРемонта, ТекСтруктураИерархии) Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ОбъектыРемонтаОбъектРемонтаПриИзмененииЗавершение", ЭтотОбъект, Новый Структура("ТекущиеДанные", ТекущиеДанные)), НСтр("ru = 'Изменить состояние подчиненных объектов ремонта?'"), РежимДиалогаВопрос.ДаНет, 0);
		КонецЕсли;
		
	КонецЕсли;
	
	Если мОтображатьПоложение Тогда
		ЗаполнитьПоложенияОР(Элементы.ОбъектыРемонта.ТекущиеДанные.ОбъектРемонта);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаОбъектРемонтаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ТекущиеДанные = ДополнительныеПараметры.ТекущиеДанные;
    
    
    ТекущиеДанные.ИзменятьСостояниеПодчиненныхОР = (РезультатВопроса = КодВозвратаДиалога.Да);

КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаВидЭксплуатацииНаПериодПриИзменении(Элемент)
		
	ТекДанные = Элементы.ОбъектыРемонта.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.ВидЭксплуатацииНаПериод) Тогда
		РеквизитыВидаЭксплуатации = УстановитьТипЭксплуатации(ТекДанные.ВидЭксплуатацииНаПериод);
		ТекДанные.ТипЭксплуатацииНаПериод = РеквизитыВидаЭксплуатации.ТипЭксплуатации;
		ТекДанные.ОбязательныйВводВидаПускаНаПериод = РеквизитыВидаЭксплуатации.ОбязательныйВводВидаПуска;
		ТекДанные.ВидПускаНаПериодОбязательностьЗаполнения = РеквизитыВидаЭксплуатации.ОбязательныйВводВидаПуска;
	Иначе
		ТекДанные.ТипЭксплуатацииНаПериод = ТекДанные.ТипЭксплуатацииНаПериод.Пустая();
		ТекДанные.ОбязательныйВводВидаПускаНаПериод = Ложь;
		ТекДанные.ВидПускаНаПериодОбязательностьЗаполнения = Ложь;
	КонецЕсли;	
	
	ТипыЭксплуатации = ПолучитьТипыЭксплуатацииДокументаНаСервере(Объект.ОбъектыРемонта);
	
	Если ЗначениеЗаполнено(ТекДанные.ВидЭксплуатацииНаПериод) И НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТекДанные.ТипЭксплуатацииНаПериод) Тогда
		Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость = Истина;  
	ИначеЕсли Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость Тогда
		УстановитьВидимостьКолонокВидовПусков(ТипыЭксплуатации);
	КонецЕсли;
	УстановитьВидимостьКолонкиПричинаПростоя(ТипыЭксплуатации);
	
	ТекДанные.ПричинаПростояОбязательностьЗаполнения = ОпределитьНеобходимостьЗаполненияПричиныПростояПоСтроке(ТекДанные, Объект.ВидОперации, ТипЭксплуатации);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаВидЭксплуатацииПриИзменении(Элемент)
	
	ТекДанные = Элементы.ОбъектыРемонта.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекДанные.ВидЭксплуатации) Тогда
		РеквизитыВидаЭксплуатации = УстановитьТипЭксплуатации(ТекДанные.ВидЭксплуатации);
		ТекДанные.ТипЭксплуатации = РеквизитыВидаЭксплуатации.ТипЭксплуатации;
		ТекДанные.ОбязательныйВводВидаПуска = РеквизитыВидаЭксплуатации.ОбязательныйВводВидаПуска;
		ТекДанные.ВидПускаОбязательностьЗаполнения = РеквизитыВидаЭксплуатации.ОбязательныйВводВидаПуска; 
	Иначе
		ТекДанные.ТипЭксплуатации = ТекДанные.ТипЭксплуатацииНаПериод.Пустая();
		ТекДанные.ОбязательныйВводВидаПуска = Ложь;
		ТекДанные.ВидПускаОбязательностьЗаполнения = Ложь;
	КонецЕсли;

	ТипыЭксплуатации = ПолучитьТипыЭксплуатацииДокументаНаСервере(Объект.ОбъектыРемонта);
	
	Если ЗначениеЗаполнено(ТекДанные.ВидЭксплуатации) И НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТекДанные.ТипЭксплуатации) Тогда
		Элементы.ОбъектыРемонтаВидПуска.Видимость = Истина;  
	ИначеЕсли Элементы.ОбъектыРемонтаВидПуска.Видимость Тогда
		УстановитьВидимостьКолонокВидовПусков(ТипыЭксплуатации);
	КонецЕсли;
	УстановитьВидимостьКолонкиПричинаПростоя(ТипыЭксплуатации);
	
	ТекДанные.ПричинаПростояОбязательностьЗаполнения = ОпределитьНеобходимостьЗаполненияПричиныПростояПоСтроке(ТекДанные, Объект.ВидОперации, ТипЭксплуатации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если  ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда 
		Для Каждого ЭлементСписка Из ВыбранноеЗначение Цикл
			Если Объект.ОбъектыРемонта.НайтиСтроки(Новый Структура("ОбъектРемонта", ЭлементСписка.Значение)).Количество() = 0 Тогда
				НС = Объект.ОбъектыРемонта.Добавить();
				НС.ОбъектРемонта = ЭлементСписка.Значение;
				НС.Иерархия 	 = ТекСтруктураИерархии;
			КонецЕсли;  
		КонецЦикла;
		
	ИначеЕсли  ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
		НС = Объект.ОбъектыРемонта.Добавить();
		НС.ОбъектРемонта = ВыбранноеЗначение;
		НС.Иерархия 	 = ТекСтруктураИерархии;
	Иначе	
		
		Для Каждого Стр Из ВыбранноеЗначение.ПолучитьЭлементы() Цикл
			Если Объект.ОбъектыРемонта.НайтиСтроки(Новый Структура("ОбъектРемонта", Стр.Объект)).Количество() = 0 Тогда
				НС = Объект.ОбъектыРемонта.Добавить();
				НС.ОбъектРемонта = Стр.Объект;
				НС.Иерархия 	 = ТекСтруктураИерархии;
				Если Объект.ВидОперации= ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод") Тогда
					НС.ДатаНачала = Стр.ДатаНачала;
					НС.ДатаОкончания = Стр.ДатаОкончания;
				Иначе
					НС.ДатаОкончания = Стр.ДатаНачала;
				КонецЕсли;
				Элементы.ОбъектыРемонта.ТекущаяСтрока = НС.ПолучитьИдентификатор();
				НС.ПричинаПростояОбязательностьЗаполнения = ОпределитьНеобходимостьЗаполненияПричиныПростояПоСтроке(НС, Объект.ВидОперации, ТипЭксплуатации);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если мОтображатьПоложение Тогда	
		
		ЗаполнитьПоложенияОР();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыРемонтаОбъектРемонтаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.торо_АктОВыполненииРегламентногоМероприятия") Тогда
		
		ПараметрыОтбора = Новый Структура("СписокОР", СписокОРИзАкта());
		ОткрытьФорму("Обработка.торо_ПодборОбъектовРемонтныхРабот.Форма.ФормаПодбораОРИзРегламентногоАкта",ПараметрыОтбора,Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		СписокДоступныхСтатусов = ПолучитьСписокСтатусовНаСервере();
		
		ПараметрыОтбора = Новый Структура("СписокСтатусов", СписокДоступныхСтатусов);
		ПараметрыОтбора.Вставить("СтруктураИерархии",       ТекСтруктураИерархии);
		
		ОткрытьФорму("Справочник.торо_ОбъектыРемонта.Форма.ФормаВыбора",ПараметрыОтбора,Элемент,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
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

&НаКлиенте
Процедура ОтображатьПоложение(Команда)
	
	Кнопка = Элементы.ОбъектыРемонтаОтображатьПоложение;
	Кнопка.Пометка = НЕ Кнопка.Пометка;	
	Элементы.ОбъектыРемонтаПоложение.Видимость = Кнопка.Пометка;
	Если Кнопка.Пометка Тогда
		ЗаполнитьПоложенияОР(); 
	КонецЕсли;
	
	мОтображатьПоложение = Кнопка.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИерархии(Команда)
		
	ПараметрыФормы = Новый Структура();
	
	ПараметрыФормы.Вставить("ТекСтруктураИерархии",ТекСтруктураИерархии);
	ОткрытьФорму("Документ.торо_ВыявленныеДефекты.Форма.ФормаНастройкиВидаИерархии",ПараметрыФормы,ЭтотОбъект,,,,Новый ОписаниеОповещения("НастройкаИерархииЗавершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	Если Объект.ВидЭксплуатации = ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод") Тогда
		ФлагОтказа = Истина;
		Для Каждого СтрокаОР Из Объект.ОбъектыРемонта Цикл
			Если СтрокаОР.ДатаНачала > СтрокаОР.ДатаОкончания Тогда
				торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для объекта ремонта %1 в строке № %2 дата начала периода больше даты окончания периода!'"),СтрокаОР.ОбъектРемонта,СтрокаОР.НомерСтроки));
				ФлагОтказа = Истина; 
			КонецЕсли;
		КонецЦикла; 
		
		Если ФлагОтказа Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьДаннымиПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	Если Не ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.торо_АктОВыполненииРегламентногоМероприятия") Тогда 		
		
		ОткрытьФорму("Обработка.торо_ПодборОбъектовРемонтныхРабот.Форма.ФормаПодбораОбъектовДляПланаГрафикаППР",
		Новый Структура("КлючНазначенияИспользования, ВидОперации, ЗакрыватьПриВыборе, СтруктураИерархии", "торо_СостоянияОбъектовРемонта", Объект.ВидОперации, Ложь,ТекСтруктураИерархии),Элементы.ОбъектыРемонта,Объект.Ссылка,ВариантОткрытияОкна.ОтдельноеОкно);
		
	Иначе
		
		ПараметрыОтбора = Новый Структура("СписокОР", СписокОРИзАкта());
		ПараметрыОтбора.Вставить("ЭтоПодбор", Истина);  
		ПараметрыОтбора.Вставить("ДатаДокумента", Объект.Дата);  
		ОткрытьФорму("Обработка.торо_ПодборОбъектовРемонтныхРабот.Форма.ФормаПодбораОРИзРегламентногоАкта",ПараметрыОтбора,Элементы.ОбъектыРемонта,,ВариантОткрытияОкна.ОтдельноеОкно,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СостояниеНаДату(Команда)
	ИзменитьВидОперацииДокумента(ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатации"));
	УстановитьЗаголовокПодменюВидаОперации();
КонецПроцедуры

&НаКлиенте
Процедура СостояниеНаПериод(Команда)
	ИзменитьВидОперацииДокумента(ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод"));
	УстановитьЗаголовокПодменюВидаОперации();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеОбИзмененииСостояния(Команда)
	
	МассивСтруктурСтрокТЧ = Новый Массив;
	КолонкиТЧ = "НомерСтроки, ДатаОкончания, ДатаНачала, ОбъектРемонта, ПричинаПростоя, ВидЭксплуатации, ВидПуска, ВидЭксплуатацииНаПериод, ВидПускаНаПериод, Примечание, ТипЭксплуатации, ТипЭксплуатацииНаПериод";
	Для каждого СтрокаТЧ Из Объект.ОбъектыРемонта Цикл
	
		СтруктураСтроки = Новый Структура(КолонкиТЧ);
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаТЧ);
		МассивСтруктурСтрокТЧ.Добавить(СтруктураСтроки);
	
	КонецЦикла;
	ПараметрыФормыЗаполнения = Новый Структура("МассивСтруктурСтрокТЧ, ВидОперации, Ссылка", МассивСтруктурСтрокТЧ, Объект.ВидОперации, Объект.Ссылка);
	ФормаЗаполнения = ПолучитьФорму("Документ.торо_СостоянияОбъектовРемонта.Форма.ФормаЗаполненияДанныхОбИзмененииСостояния", ПараметрыФормыЗаполнения, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор, ВариантОткрытияОкна.ОтдельноеОкно);
	ФормаЗаполнения.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаЗаполнения.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьДанныеОбИзмененииСостоянияЗавершение", ЭтотОбъект);
	ФормаЗаполнения.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеОбИзмененииСостоянияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		
		Для Каждого СтруктураСтрокиТЧ Из РезультатЗакрытия Цикл
			НайденныеСтроки = Объект.ОбъектыРемонта.НайтиСтроки(Новый Структура("НомерСтроки", СтруктураСтрокиТЧ.НомерСтроки));
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
				ЗаполнитьЗначенияСвойств(НайденнаяСтрока, СтруктураСтрокиТЧ);
			
			КонецЦикла;
		КонецЦикла;
		Модифицированность = Истина;
		УстановитьВнешнийВидФормы();
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

&НаСервере
Процедура ЗаполнитьДобавочныеРеквизитыТЧ()
	
	Для Каждого СтрокаТЧ Из Объект.ОбъектыРемонта Цикл
		СтрокаТЧ.ТипЭксплуатации = СтрокаТЧ.ВидЭксплуатации.ТипЭксплуатации;
		СтрокаТЧ.ТипЭксплуатацииНаПериод = СтрокаТЧ.ВидЭксплуатацииНаПериод.ТипЭксплуатации;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФлагиОбязательностиЗаполненияПричиныПростоя()
	
	ВидДокументаЕстьНаПериод = (Объект.ВидОперации = Перечисления.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод);
	
	Для Каждого Строка Из Объект.ОбъектыРемонта Цикл
		Строка.ПричинаПростояОбязательностьЗаполнения = ОпределитьНеобходимостьЗаполненияПричиныПростояПоСтроке(Строка, Объект.ВидОперации, ТипЭксплуатации);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьНеобходимостьЗаполненияПричиныПростояПоСтроке(Строка, ВидОперации, ТипЭксплуатации)
	
	ВидДокументаЕстьНаПериод = (ВидОперации = ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод"));
	ВидПускаПростой = ПредопределенноеЗначение("Перечисление.торо_ТипЭксплуатации.Простой");
	Если ВидДокументаЕстьНаПериод Тогда
		ОбязательноКЗаполнениюПричинаПростоя = ?(ЗначениеЗаполнено(Строка.ТипЭксплуатацииНаПериод), Строка.ТипЭксплуатацииНаПериод, ТипЭксплуатации) = ВидПускаПростой;
		ОбязательноКЗаполнениюПричинаПростоя = ОбязательноКЗаполнениюПричинаПростоя Или Строка.ТипЭксплуатации = ВидПускаПростой;
	Иначе
		ОбязательноКЗаполнениюПричинаПростоя = ?(ЗначениеЗаполнено(Строка.ТипЭксплуатации), Строка.ТипЭксплуатации, ТипЭксплуатации) = ВидПускаПростой;
	КонецЕсли;
	Возврат ОбязательноКЗаполнениюПричинаПростоя;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоложенияОР(ОР = Неопределено)
	
	СписокПоложений = Новый СписокЗначений;
	Если ОР = Неопределено Тогда
		
		Для каждого Стр Из Объект.ОбъектыРемонта Цикл
			
			Если СписокПоложений.НайтиПоЗначению(Стр.ОбъектРемонта) = Неопределено Тогда
				СписокПоложений.Добавить(Стр.ОбъектРемонта);		
			КонецЕсли;
			
			Стр.Положение = "";
			
		КонецЦикла; 
	Иначе
		
		СписокПоложений.Добавить(ОР);
		
	КонецЕсли;
	
	СтруктураПоложений = ПолучитьСтруктуруПоложенийОРНаСервере(СписокПоложений, ТекСтруктураИерархии, ТекущаяДата());
	
	Если ОР = Неопределено Тогда
		Для каждого Стр Из СтруктураПоложений Цикл
			
			МассивСтрок = Объект.ОбъектыРемонта.НайтиСтроки(Новый Структура("ОбъектРемонта", Стр.Ключ));
			
			Для каждого Элем Из МассивСтрок Цикл
				
				Элем.Положение = Стр.Значение;
				
			КонецЦикла; 
			
		КонецЦикла;
	Иначе
		Элементы.ОбъектыРемонта.ТекущиеДанные.Положение = СтруктураПоложений[ОР];
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПоложенийОРНаСервере(СписокПоложений, СтруктураИерархии, Дата)
	
	Возврат торо_ОбщегоНазначения.ПолучитьПоложенияВИерархииОбъектовРемРабот(СписокПоложений, СтруктураИерархии, Дата);	
	
КонецФункции

&НаКлиенте
Процедура УстановитьВнешнийВидФормы()

	Элементы.ОбъектыРемонтаДатаНачала.Видимость = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод"));
	
	Элементы.ОбъектыРемонтаВидЭксплуатацииНаПериод.Видимость = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод"));
	
	Элементы.ОбъектыРемонтаДатаОкончания.Заголовок  = ?(Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод"),НСтр("ru = 'Окончание периода'"),НСтр("ru = 'Дата изменения состояния'"));
	
	Элементы.ОбъектыРемонтаДатаНачала.АвтоОтметкаНезаполненного = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.торо_ВидыОперацийОтклоненияВРаботеОборудования.ВидЭксплуатацииНаПериод"));
		
    Элементы.ОбъектыРемонтаПоложение.Видимость = мОтображатьПоложение;
	
	ТипыЭксплуатации = ПолучитьТипыЭксплуатацииДокументаНаСервере(Объект.ОбъектыРемонта);
	УстановитьВидимостьКолонокВидовПусков(ТипыЭксплуатации);
    УстановитьВидимостьКолонкиПричинаПростоя(ТипыЭксплуатации);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКолонкиПричинаПростоя(ТипыЭксплуатации)
	
	Элементы.ОбъектыРемонтаПричинаПростоя.Видимость = Ложь;
		
	Если ЗначениеЗаполнено(Объект.ВидЭксплуатации) И ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатации) Тогда
		Элементы.ОбъектыРемонтаПричинаПростоя.Видимость = Истина;
	Иначе
		Для Каждого ТипЭксплуатацииТЧ Из ТипыЭксплуатации.ТипыЭксплуатации Цикл
			Если ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатацииТЧ) Тогда
				Элементы.ОбъектыРемонтаПричинаПростоя.Видимость = Истина;
				Возврат;
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТипЭксплуатацииТЧ Из ТипыЭксплуатации.ТипыЭксплуатацииНаПериод Цикл
			Если ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатацииТЧ) Тогда
				Элементы.ОбъектыРемонтаПричинаПростоя.Видимость = Истина;
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТипыЭксплуатацииДокументаНаСервере(Знач ОбъектыРемонта)
	
	ВозвращаемыйРезультат = Новый Структура;
	
	ВидыЭксплуатации = ОбъектыРемонта.Выгрузить(,"ВидЭксплуатации, ВидЭксплуатацииНаПериод");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВидыЭксплуатации.ВидЭксплуатации
	                      |ПОМЕСТИТЬ ВидыЭксплуатации
	                      |ИЗ
	                      |	&ВидыЭксплуатации КАК ВидыЭксплуатации
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	торо_ВидыЭксплуатации.ТипЭксплуатации
	                      |ИЗ
	                      |	ВидыЭксплуатации КАК ВидыЭксплуатации
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ВидыЭксплуатации КАК торо_ВидыЭксплуатации
	                      |		ПО (ВидыЭксплуатации.ВидЭксплуатации = торо_ВидыЭксплуатации.Ссылка)");
	Запрос.УстановитьПараметр("ВидыЭксплуатации",ОбъектыРемонта.Выгрузить(,"ВидЭксплуатации"));
	ВозвращаемыйРезультат.Вставить("ТипыЭксплуатации",Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ТипЭксплуатации"));
	
	ВидыЭксплуатацииНаПериод = ОбъектыРемонта.Выгрузить(,"ВидЭксплуатацииНаПериод");
	ВидыЭксплуатацииНаПериод.Колонки.ВидЭксплуатацииНаПериод.Имя = "ВидЭксплуатации";
	Запрос.УстановитьПараметр("ВидыЭксплуатации",ВидыЭксплуатацииНаПериод);
	ВозвращаемыйРезультат.Вставить("ТипыЭксплуатацииНаПериод",Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ТипЭксплуатации"));
	
	Возврат ВозвращаемыйРезультат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатации)
	
	Возврат ТипЭксплуатации = ВидПускаПростой;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьКолонокВидовПусков(ТипыЭксплуатации)
	
	Элементы.ОбъектыРемонтаВидПуска.Видимость = Ложь;
	Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(ТипЭксплуатации) Тогда
		
		Если Элементы.ОбъектыРемонтаВидЭксплуатации.Видимость Тогда
			Элементы.ОбъектыРемонтаВидПуска.Видимость = НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатации);
		КонецЕсли;
		
		Если Элементы.ОбъектыРемонтаВидЭксплуатацииНаПериод.Видимость Тогда
			Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость = НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатации);
		КонецЕсли;

	КонецЕсли;
	
	ТипыЭксплуатации = ПолучитьТипыЭксплуатацииДокументаНаСервере(Объект.ОбъектыРемонта);
	
	Если НЕ Элементы.ОбъектыРемонтаВидПуска.Видимость Тогда
		
		Для Каждого ТипЭксплуатацииТЧ Из ТипыЭксплуатации.ТипыЭксплуатации Цикл
			Если Элементы.ОбъектыРемонтаВидЭксплуатации.Видимость 
				И НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатацииТЧ) Тогда
				
				Элементы.ОбъектыРемонтаВидПуска.Видимость = Истина;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость Тогда
		
		Для Каждого ТипЭксплуатацииТЧ Из ТипыЭксплуатации.ТипыЭксплуатацииНаПериод Цикл
			Если Элементы.ОбъектыРемонтаВидЭксплуатацииНаПериод.Видимость 
				И НЕ ПолучитьВидимостьВидаПускаНаКлиенте(ТипЭксплуатацииТЧ) Тогда
				
				Элементы.ОбъектыРемонтаВидПускаНаПериод.Видимость = Истина;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЕстьЛиПодчиненныеОР(ОбъектРемонта, СтруктураИерархии)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_ОбъектыРемонтаГруппы.ОбъектГруппа
	|ИЗ
	|	РегистрСведений.торо_ОбъектыРемонтаГруппы КАК торо_ОбъектыРемонтаГруппы
	|ГДЕ
	|	торо_ОбъектыРемонтаГруппы.ОбъектИерархии = &ОбъектИерархии
	|	И торо_ОбъектыРемонтаГруппы.СтруктураИерархии = &СтруктураИерархии";
	
	Запрос.УстановитьПараметр("ОбъектИерархии", ОбъектРемонта);
	Запрос.УстановитьПараметр("СтруктураИерархии", СтруктураИерархии);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ОбъектГруппа;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьТипЭксплуатации(ВидЭксплуатации)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ТипЭксплуатации",ВидЭксплуатации.ТипЭксплуатации);
	ФОУчетПусковОборудования = Константы.торо_УчетПусковОборудования.Получить();
	СтруктураПараметров.Вставить("ОбязательныйВводВидаПуска", ?(ФОУчетПусковОборудования, ВидЭксплуатации.ОбязательныйВводВидаПуска, ЛОжь));
	
	Возврат СтруктураПараметров;		
КонецФункции 

&НаКлиенте
Процедура НастройкаИерархииЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ТекСтруктураИерархии = РезультатЗакрытия;
		
	Если мОтображатьПоложение Тогда	
		
		ЗаполнитьПоложенияОР();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиПоУмолчаниюНаСервере()
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	ДокОбъект.ЗаполнитьДаннымиПоУмолчанию();
	
	ЗначениеВРеквизитФормы(ДокОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокПодменюВидаОперации()
	Элементы.ПодМенюВыборВидаОперации.Заголовок = Объект.ВидОперации;	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидОперацииДокумента(ВидОперации)
	Если Не Объект.ВидОперации = ВидОперации Тогда
		Объект.ВидОперации = ВидОперации;
		УстановитьВнешнийВидФормы()
	КонецЕсли; 	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСтатусовНаСервере()
	
	СписокЗн = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	торо_НастройкиДоступностиОбъектовРемонта.СтатусОРВУчете
	|ИЗ
	|	РегистрСведений.торо_НастройкиДоступностиОбъектовРемонта КАК торо_НастройкиДоступностиОбъектовРемонта
	|ГДЕ
	|	торо_НастройкиДоступностиОбъектовРемонта.ДоступностьПриПодборе";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.СтатусОРВУчете = Перечисления.торо_СтатусыОРВУчете.НеПринятоКУчету Тогда
			СписокЗн.Добавить(Выборка.СтатусОРВУчете);
		КонецЕсли; 
	КонецЦикла;
	Возврат СписокЗн;
КонецФункции

&НаСервере
Процедура УстановитьОбязательностьЗаполнения()
	
	Для каждого Стр Из Объект.ОбъектыРемонта Цикл
	
		ФОУчетПусковОборудования = Константы.торо_УчетПусковОборудования.Получить();
		Если ЗначениеЗаполнено(Стр.ВидЭксплуатации) и ФОУчетПусковОборудования Тогда
			Стр.ВидПускаОбязательностьЗаполнения = Стр.ВидЭксплуатации.ОбязательныйВводВидаПуска;
		Иначе
			Стр.ВидПускаОбязательностьЗаполнения = Ложь;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Стр.ВидЭксплуатацииНаПериод) и ФОУчетПусковОборудования Тогда
			Стр.ВидПускаНаПериодОбязательностьЗаполнения = Стр.ВидЭксплуатацииНаПериод.ОбязательныйВводВидаПуска;
		Иначе
			Стр.ВидПускаНаПериодОбязательностьЗаполнения = Ложь;
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере 
Функция СписокОРИзАкта()
	СписокОР = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	торо_АктОВыполненииРегламентногоМероприятияМероприятияОбъектов.ОбъектРемонта
	|ИЗ
	|	Документ.торо_АктОВыполненииРегламентногоМероприятия.МероприятияОбъектов КАК торо_АктОВыполненииРегламентногоМероприятияМероприятияОбъектов
	|ГДЕ
	|	торо_АктОВыполненииРегламентногоМероприятияМероприятияОбъектов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ТЗОР = Результат.Выгрузить();
		СписокОР.ЗагрузитьЗначения(ТЗОР.ВыгрузитьКолонку("ОбъектРемонта"));
	КонецЕсли;
	
	Возврат СписокОР;
	
КонецФункции

#КонецОбласти

