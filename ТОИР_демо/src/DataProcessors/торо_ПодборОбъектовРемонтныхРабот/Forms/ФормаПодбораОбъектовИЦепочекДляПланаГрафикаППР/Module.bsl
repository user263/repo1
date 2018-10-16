
&НаКлиенте
Перем СостояниеДереваОР;

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(КлючНазначенияИспользования) Тогда
		Отказ = Истина;
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Обработка не предназначена для непосредственного использования.'"));
		возврат;
	КонецЕсли;
	
	ТекСтруктураИерархии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
																				"НастройкиТОиР",
																				"ОсновнаяСтруктураИерархии",
																				Истина);
																				
	ВидПодбора = "ЦепочкиРемонтныхРабот";
	ЗапросЦепочки = Истина;
	
	Если Параметры.Свойство("ИспользоватьДокументыЖЦОборудования") Тогда
		ФОИспользоватьДокументыЖЦОборудования = Параметры.ИспользоватьДокументыЖЦОборудования;
	Иначе
		ФОИспользоватьДокументыЖЦОборудования = ПолучитьФункциональнуюОпцию("торо_ИспользоватьДокументыПринятияИСписанияОборудования");
	КонецЕсли;
	
	Если ФОИспользоватьДокументыЖЦОборудования Тогда
		ПолучитьСписокСтатусовНаСервере(СписокСтатусов,ВидПодбора);
	КонецЕсли;
	
	ЗаполнитьПараметрыИерархии();
	
	СтруктураПараметровИерархии = Новый Структура(
	"СтруктураИерархии,ИзменяетсяДокументами,СтроитсяАвтоматически,РеквизитОР,ТипРеквизитаОР,ИерархическийСправочник,РодительИерархии",
	ТекСтруктураИерархии, ИзменяетсяДокументами, СтроитсяАвтоматически, ИерархияРеквизитОР, ИерархияТипРеквизитаОР,ИерархическийСправочник);
	
	ЭтаФорма.ОрганизацияДляОтбора = ?(Параметры.Свойство("Организация"), Параметры.Организация, Справочники.Организации.ПустаяСсылка());
	ЭтаФорма.ПодразделениеДляОтбора = ?(Параметры.Свойство("Подразделение"), Параметры.Подразделение, Справочники.СтруктураПредприятия.ПустаяСсылка());
	ЭтаФорма.НеУчаствуетВПланировании = ?(Параметры.Свойство("НеУчаствуетВПланировании"), Параметры.НеУчаствуетВПланировании, Ложь);

	СтруктураПараметровФормы = Новый Структура(
	"ИмяФормы, СостояниеДереваОР, ОтборОбъектРемонта, СписокСтатусов, ВидПодбора, Организация, Подразделение, НеУчаствуетВПланировании",
	ЭтаФорма.ИмяФормы, Неопределено, Неопределено, СписокСтатусов, ВидПодбора, ЭтаФорма.ОрганизацияДляОтбора, ЭтаФорма.ПодразделениеДляОтбора, НеУчаствуетВПланировании);
	
	МассивСтруктурОР = Справочники.торо_ОбъектыРемонта.ПолучитьМассивСтрокДляЗаполненияДерева(СтруктураПараметровИерархии,СтруктураПараметровФормы);
	
	ЗаполнитьДеревоПриСозданииНаСервере(МассивСтруктурОР);
	
	Элементы.ОрганизацияДляОтбора.Видимость = ЗначениеЗаполнено(ЭтаФорма.ОрганизацияДляОтбора);
	Элементы.ПодразделениеДляОтбора.Видимость = ЗначениеЗаполнено(ЭтаФорма.ПодразделениеДляОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ТекСтруктураИерархииПриИзменении(Элемент)
	
	ЗаполнитьДеревоНаСервере();
	
	Для каждого СтрокаДерева Из Дерево.ПолучитьЭлементы() Цикл
		
		Элементы.Дерево.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
		
	КонецЦикла;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево
&НаКлиенте
Процедура ДеревоПередРазворачиванием(Элемент, Строка, Отказ)
	
	ТекДанные = Дерево.НайтиПоИдентификатору(Строка);
	
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.Ссылка) И НЕ ТекДанные.СвязиОбновлялись Тогда
		СтрокиДерева = ТекДанные.ПолучитьЭлементы();
		Если СтрокиДерева.Количество() > 0 Тогда
			СтруктураПараметровИерархии = Новый Структура(
			"СтруктураИерархии,ИзменяетсяДокументами,СтроитсяАвтоматически,РеквизитОР,ТипРеквизитаОР,ИерархическийСправочник",
			ТекСтруктураИерархии, ИзменяетсяДокументами, СтроитсяАвтоматически, ИерархияРеквизитОР, ИерархияТипРеквизитаОР,ИерархическийСправочник);
			
			СтруктураПараметровФормы = Новый Структура(
			"ИмяФормы, СостояниеДереваОР, ОтборОбъектРемонта, СписокСтатусов, Организация, Подразделение, НеУчаствуетВПланировании",
			ЭтаФорма.ИмяФормы, СостояниеДереваОР, Неопределено, СписокСтатусов, ЭтаФорма.ОрганизацияДляОтбора, ЭтаФорма.ПодразделениеДляОтбора, ЭтаФорма.НеУчаствуетВПланировании);
			
			МассивЭлементов = Новый Массив;
			Для Каждого СтрокаДерева Из СтрокиДерева Цикл
				МассивЭлементов.Добавить(СтрокаДерева.Ссылка);
			КонецЦикла;
			
			СтруктураДобавления = ПолучитьСтруктуруНовыхСтрок(ТекДанные.Ссылка, СтруктураПараметровИерархии,МассивЭлементов,СтруктураПараметровФормы);
		КонецЕсли;
		ТекДанные.СвязиОбновлялись = Истина;
		
		Для каждого СтрокаДерева Из СтрокиДерева Цикл
			
			Если СтруктураДобавления = Неопределено Тогда Продолжить; КонецЕсли;
			
			Для каждого ТекЭлем Из СтруктураДобавления Цикл
				Если ТекЭлем.Родитель <> СтрокаДерева.Ссылка Тогда
					Продолжить;
				КонецЕсли;
				НС = СтрокаДерева.ПолучитьЭлементы().Добавить();
				НС.Ссылка                        = ТекЭлем.ОбъектИерархии;
				НС.РеквизитДопУпорядочивания     = ТекЭлем.РеквизитДопУпорядочиванияОР;
				
				НС.РодительИерархии              = ТекЭлем.Родитель;
				НС.ПометкаУдаления               = ТекЭлем.ПометкаУдаления;
				НС.Картинка                      = ТекЭлем.ИндексКартинки;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ТекОбъектРемонтаЦепочки = Элементы.Дерево.ТекущиеДанные;
	Если ТекОбъектРемонтаЦепочки = Неопределено ИЛИ ТипЗнч(ТекОбъектРемонтаЦепочки.Ссылка) <> Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
		Возврат;
	КонецЕсли;
	
	МассивЦепочек = ПолучитьВидыЦепочекНаСервере(ТекОбъектРемонтаЦепочки.Ссылка);
	
	ТаблицаЦепочек.Очистить();
	
	Для каждого Элем Из МассивЦепочек Цикл
		НС = ТаблицаЦепочек.Добавить();
		ЗаполнитьЗначенияСвойств(НС, Элем);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанныеОР = Элементы.Дерево.ТекущиеДанные;
	
	Если НЕ ТекДанныеОР = Неопределено Тогда
		ВыборОбъектаРемонта(ТекДанныеОР.Ссылка);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЦепочек
&НаКлиенте
Процедура ТаблицаЦепочекПриАктивизацииСтроки(Элемент)
	
	ТекСтрока = Элементы.ТаблицаЦепочек.ТекущиеДанные;
	ТаблицаВидовРемонта.Очистить();

	Если НЕ ТекСтрока = Неопределено Тогда
		МассивРемонтов = ПолучитьВидыРемонтаНаСервере(ТекСтрока.ВидЦепочки);
				
		Для каждого Элем Из МассивРемонтов Цикл
			НС = ТаблицаВидовРемонта.Добавить();
			ЗаполнитьЗначенияСвойств(НС, Элем);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦепочекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыборЦепочки();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыборЦепочки();
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьДеревоПриСозданииНаСервере(МассивСтруктурОР)
	
	НС = Дерево.ПолучитьЭлементы().Добавить();
	НС.Ссылка = ТекСтруктураИерархии;
	НС.Картинка = 4;
	НС.СвязиОбновлялись = Истина;
	
	Если СтроитсяАвтоматически Тогда
		РодительИерархии = Справочники[ИерархияТипРеквизитаОР].ПустаяСсылка();
	Иначе
		РодительИерархии = ПредопределенноеЗначение("Справочник.торо_ОбъектыРемонта.ПустаяСсылка");
	КонецЕсли;
	
	Для Каждого ЭлементКорневой Из МассивСтруктурОР Цикл
		Если ЭлементКорневой.РодительИерархии = РодительИерархии Тогда
			
			НСКорневая = НС.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НСКорневая,ЭлементКорневой);
			НСКорневая.Ссылка = ЭлементКорневой.ОбъектИерархии;
			НСКорневая.Картинка = ЭлементКорневой.ИндексКартинки;
			НСКорневая.РеквизитДопУпорядочивания = ЭлементКорневой.РеквизитДопУпорядочиванияОР;
			Для Каждого ЭлементПодчиненный Из МассивСтруктурОР Цикл
				Если ЭлементПодчиненный.РодительИерархии = ЭлементКорневой.ОбъектИерархии Тогда
					НСПодчиненная = НСКорневая.ПолучитьЭлементы().Добавить();
					ЗаполнитьЗначенияСвойств(НСПодчиненная,ЭлементПодчиненный);
					НСПодчиненная.Ссылка = ЭлементПодчиненный.ОбъектИерархии;
					НСПодчиненная.Картинка = ЭлементПодчиненный.ИндексКартинки;
					НСПодчиненная.РеквизитДопУпорядочивания = ЭлементПодчиненный.РеквизитДопУпорядочиванияОР;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыИерархии()
	
	Если ЗначениеЗаполнено(ТекСтруктураИерархии) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	торо_СтруктурыОР.РазрешенВводНовыхОР,
		               |	торо_СтруктурыОР.ИзменяетсяДокументами,
		               |	торо_СтруктурыОР.СтроитсяАвтоматически,
					   |	торо_СтруктурыОР.РеквизитОР,
					   |	торо_СтруктурыОР.ТипРеквизитаОР
		               |ИЗ
		               |	Справочник.торо_СтруктурыОР КАК торо_СтруктурыОР
		               |ГДЕ
		               |	торо_СтруктурыОР.Ссылка = &СтруктураИерархии";
		Запрос.УстановитьПараметр("СтруктураИерархии",ТекСтруктураИерархии);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ИзменяетсяДокументами  = Выборка.ИзменяетсяДокументами;
		СтроитсяАвтоматически  = Выборка.СтроитсяАвтоматически;
		ИерархияРеквизитОР	   = Выборка.РеквизитОР;
		ИерархияТипРеквизитаОР = Выборка.ТипРеквизитаОР;
		Если СтроитсяАвтоматически И ИерархияТипРеквизитаОР <> "" Тогда
			ИерархическийСправочник= Метаданные.Справочники[ИерархияТипРеквизитаОР].Иерархический;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНаСервере()
	
	Дерево.ПолучитьЭлементы().Очистить();
	
	ИзменяетсяДокументами = ТекСтруктураИерархии.ИзменяетсяДокументами; 
	СтроитсяАвтоматически = ТекСтруктураИерархии.СтроитсяАвтоматически;
	ИерархияРеквизитОР = ТекСтруктураИерархии.РеквизитОР;
	ИерархияТипРеквизитаОР = ТекСтруктураИерархии.ТипРеквизитаОР;
	
	Если СтроитсяАвтоматически И ИерархияТипРеквизитаОР <> "" Тогда
		ИерархическийСправочник = Метаданные.Справочники[ИерархияТипРеквизитаОР].Иерархический;
	КонецЕсли;
	
	СтруктураПараметровИерархии = Новый Структура(
	"СтруктураИерархии,ИзменяетсяДокументами,СтроитсяАвтоматически,РеквизитОР,ТипРеквизитаОР,ИерархическийСправочник,РодительИерархии",
		ТекСтруктураИерархии, ИзменяетсяДокументами, СтроитсяАвтоматически, ИерархияРеквизитОР, ИерархияТипРеквизитаОР,ИерархическийСправочник);
		
	СтруктураПараметровФормы = Новый Структура(
	"ИмяФормы, СостояниеДереваОР, ОтборОбъектРемонта, СписокСтатусов, ВидПодбора, Организация, Подразделение, НеУчаствуетВПланировании",
	ЭтаФорма.ИмяФормы, Неопределено, Неопределено, СписокСтатусов, ВидПодбора, ЭтаФорма.ОрганизацияДляОтбора, ЭтаФорма.ПодразделениеДляОтбора, НеУчаствуетВПланировании);
	
	МассивСтруктурОР = Справочники.торо_ОбъектыРемонта.ПолучитьМассивСтрокДляЗаполненияДерева(СтруктураПараметровИерархии,СтруктураПараметровФормы);
	ЗаполнитьДеревоПриСозданииНаСервере(МассивСтруктурОР);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокСтатусовНаСервере(СписокСтатусов,ВидПодбора)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	торо_НастройкиДоступностиОбъектовРемонта.СтатусОРВУчете
	|ИЗ
	|	РегистрСведений.торо_НастройкиДоступностиОбъектовРемонта КАК торо_НастройкиДоступностиОбъектовРемонта
	|ГДЕ
	|	торо_НастройкиДоступностиОбъектовРемонта.ДоступностьПриПодборе";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОтображатьНепринятые = (НЕ ВидПодбора = "ВидПараметровНаработки"
						  И НЕ ВидПодбора = "НастройкаПодбораВводНачальныхДанныхСоВременем"
						  И НЕ ВидПодбора = "ВводНачальныхДанных");
	
	Пока Выборка.Следующий() Цикл
		Если ОтображатьНепринятые Тогда
			СписокСтатусов.Добавить(Выборка.СтатусОРВУчете);
		ИначеЕсли Не Выборка.СтатусОРВУчете = Перечисления.торо_СтатусыОРВУчете.НеПринятоКУчету Тогда
			СписокСтатусов.Добавить(Выборка.СтатусОРВУчете);
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруНовыхСтрок(Ссылка, ПараметрыСтруктурыИерархии, МассивЭлементов, СтруктураПараметровФормы)
	
	Возврат Справочники.торо_ОбъектыРемонта.ПолучитьСтруктуруНовыхСтрокДляДереваПриРазворачивании(Ссылка, ПараметрыСтруктурыИерархии,МассивЭлементов,СтруктураПараметровФормы); 
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВидыЦепочекНаСервере(ОбъектРемонта)
	
	СписокОтбора = Новый СписокЗначений;
	СписокОтбора.Добавить(ОбъектРемонта);
	СписокОтбора.Добавить(ОбъектРемонта.ТиповойОР);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	торо_РемонтныеЦиклыОборудования.ВидЦепочки,
	|	торо_РемонтныеЦиклыОборудования.ГруппаОбъектовРемонтов
	|ИЗ
	|	РегистрСведений.торо_РемонтныеЦиклыОборудования КАК торо_РемонтныеЦиклыОборудования
	|ГДЕ
	|	торо_РемонтныеЦиклыОборудования.ГруппаОбъектовРемонтов В (&СписокОтбора)";
	
	Запрос.УстановитьПараметр("СписокОтбора", СписокОтбора);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МассивЦепочек = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Структ = Новый Структура("ВидЦепочки, ГруппаОбъектовРемонтов");
		ЗаполнитьЗначенияСвойств(Структ, Выборка);
		МассивЦепочек.Добавить(Структ);
		
	КонецЦикла;
	
	Возврат МассивЦепочек;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВидыРемонтаНаСервере(ВидЦепочки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_ЦепочкиРемонтаПоследовательностьРемонтов.Ссылка КАК ВидЦепочки,
	|	торо_ЦепочкиРемонтаПоследовательностьРемонтов.ВидРемонта
	|ИЗ
	|	Справочник.торо_ЦепочкиРемонта.ПоследовательностьРемонтов КАК торо_ЦепочкиРемонтаПоследовательностьРемонтов
	|ГДЕ
	|	торо_ЦепочкиРемонтаПоследовательностьРемонтов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ВидЦепочки);
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	МассивРемонтов = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Структ = Новый Структура("ВидЦепочки, ВидРемонта");
		ЗаполнитьЗначенияСвойств(Структ, Выборка);
		МассивРемонтов.Добавить(Структ);
		
	КонецЦикла;
	
	Возврат МассивРемонтов;
	
КонецФункции

&НаКлиенте
Процедура ВыборЦепочки()
	
	ВыделенныеСтроки = Элементы.ТаблицаЦепочек.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество()= 0 Тогда
		Если ТаблицаЦепочек.Количество() = 0 Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для текущего объекта ремонта не задано ни одной цепочки ремонта.'"));
		Иначе
		  // торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбраны цепочки ремонтов для подбора.'"));
		КонецЕсли;
	Иначе
		
		КоллекцияСтрок = ДеревоВыбрСтрок.ПолучитьЭлементы();
		КоллекцияСтрок.Очистить();
		
		ТекДанныеОР = Элементы.Дерево.ТекущиеДанные;
		Если Не ТекДанныеОР = Неопределено Тогда
			ТекОР = ТекДанныеОР.Ссылка;
			НС = КоллекцияСтрок.Добавить();
			НС.Объект = ТекОР;
			Для каждого Стр Из ВыделенныеСтроки Цикл
				ВыдСтрока = ТаблицаЦепочек.НайтиПоИдентификатору(Стр);
				
				Если НЕ ВыдСтрока = Неопределено Тогда
					
					Строки = НС.ПолучитьЭлементы();
					НовСтр = Строки.Добавить();
					НовСтр.Цепочка = ВыдСтрока.ВидЦепочки;
					
				КонецЕсли;
				
			КонецЦикла;	
			
		КонецЕсли;
		
		ОповеститьОВыборе(ДеревоВыбрСтрок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОбъектаРемонта(ТекОР)
	
	Если ЗапросЦепочки Тогда
		Если ТаблицаЦепочек.Количество() = 0 Тогда
			
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для элемента дерева ОР ""%1"" нет цепочек ремонтов.'"),ТекОР));
			
		Иначе
			
			СписокЦепочек = Новый СписокЗначений;
			Для Каждого СтрокаТЗЦепочек Из ТаблицаЦепочек Цикл
				СписокЦепочек.Добавить(СтрокаТЗЦепочек.ВидЦепочки);
			КонецЦикла;
			
			Для Каждого СтрокаПометки Из СписокЦепочек Цикл
				СтрокаПометки.Пометка = Истина;
			КонецЦикла;
			
			СписокЦепочек.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("ВыборОбъектаРемонтаЗавершение", ЭтотОбъект, Новый Структура("СписокЦепочек, ТекОР", СписокЦепочек, ТекОР)), НСтр("ru = 'Выбор цепочек ремонта'"));
		КонецЕсли;
	Иначе
		ОповеститьОВыборе(ТекОР);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОбъектаРемонтаЗавершение(Список, ДополнительныеПараметры) Экспорт
    
    СписокЦепочек = ДополнительныеПараметры.СписокЦепочек;
    ТекОР = ДополнительныеПараметры.ТекОР;
    
    
    Если ЗначениеЗаполнено(Список) Тогда
        
        КоллекцияСтрок = ДеревоВыбрСтрок.ПолучитьЭлементы();
        КоллекцияСтрок.Очистить();
        НС = КоллекцияСтрок.Добавить();
        НС.Объект = ТекОР;
        
        Для Каждого ЭлементСписка Из СписокЦепочек Цикл
            Если ЭлементСписка.Пометка Тогда
                
                Строки = НС.ПолучитьЭлементы();
                НовСтр = Строки.Добавить();
                НовСтр.Цепочка = ЭлементСписка.Значение;
                
            КонецЕсли; 
        КонецЦикла;
        
        ОповеститьОВыборе(ДеревоВыбрСтрок);
        
    КонецЕсли;

КонецПроцедуры

СостояниеДереваОР = Новый Структура("МассивОткрытыхОР",Новый Массив);

#КонецОбласти
