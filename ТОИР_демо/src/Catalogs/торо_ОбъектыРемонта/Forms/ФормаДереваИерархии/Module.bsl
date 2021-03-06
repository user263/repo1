#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекСтруктураИерархии = Параметры.СтруктураИерархии;
	ЗаполнитьПараметрыИерархии();
	
	ДеревоСФормы = ДанныеФормыВЗначение(Параметры.Ключ, Тип("ДеревоЗначений"));
	ЗначениеВРеквизитФормы(ДеревоСФормы, "Дерево");
	
	ВыделитьСтрокуДереваНаКлиенте(Параметры.ТекущийОбъект, Дерево.ПолучитьЭлементы(),Ложь);
	
	Элементы.ФормаСправочникторо_ОбъектыРемонтаИерархическийПросмотр.Пометка = Истина;
	ТипПоискаДанных = Элементы.ТипПоискаДанных.СписокВыбора[0].Значение;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЗакладок(Ложь);
	Элементы.Дерево.Развернуть(0);
	
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
				
			СтруктураПараметровФормы = Новый Структура("ИмяФормы, СостояниеДереваОР, ОтборОбъектРемонта", 
																	ЭтаФорма.ИмяФормы, Неопределено, Неопределено);
				
			МассивЭлементов = Новый Массив;
			Для Каждого СтрокаДерева Из СтрокиДерева Цикл
				МассивЭлементов.Добавить(СтрокаДерева.Ссылка);
			КонецЦикла;
			СтруктураДобавления = ПолучитьСтруктуруНовыхСтрок(ТекДанные.Ссылка, СтруктураПараметровИерархии,МассивЭлементов,СтруктураПараметровФормы);

		КонецЕсли;
		
		ТекДанные.СвязиОбновлялись = Истина;
		Для каждого СтрокаДерева Из СтрокиДерева Цикл
			Для каждого ТекЭлем Из СтруктураДобавления Цикл
				Если ТекЭлем.Родитель <> СтрокаДерева.Ссылка тогда
					Продолжить;
				КонецЕсли;
				НС = СтрокаДерева.ПолучитьЭлементы().Добавить();
				НС.Ссылка = ТекЭлем.ОбъектИерархии;
				НС.Картинка = ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(НС.Ссылка);
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыполнитьВыборЗначения();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийПрочихЭлементовФормы

&НаКлиенте
Процедура ЗначениеОтбораСпискаОбъектовРемонтаПриИзменении(Элемент)
	ОтборНаКлиентеСписокОР(Элемент.ТекстРедактирования);	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеОтбораСпискаОбъектовРемонтаОчистка(Элемент, СтандартнаяОбработка)	
	ОтборНаКлиентеСписокОР("");	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеОтбораСпискаОбъектовРемонтаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	ОтборНаКлиентеСписокОР(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТипПоискаДанныхПриИзменении(Элемент)
	ОтборНаКлиентеСписокОР();
КонецПроцедуры  

&НаКлиенте
Процедура СписокОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыполнитьВыборЗначения();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыполнитьВыборЗначения();
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервереБезКонтекста
Функция ОпределитьИндексКартинкиСтрокиДереваПроизвольнойИерархииНаСервере(СсылкаСтроки,ПометкаУдаления = Неопределено)
	
	Если ТипЗнч(СсылкаСтроки) = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
		
		Если СсылкаСтроки.ЭтоГруппа Тогда
			ИндексКартинки = ?(ПометкаУдаления = Неопределено,?(СсылкаСтроки.ПометкаУдаления, 6, 5),?(ПометкаУдаления, 6, 5));
		Иначе
			ИндексКартинки = ?(ПометкаУдаления = Неопределено,?(СсылкаСтроки.ПометкаУдаления, 1, 0),?(ПометкаУдаления, 1, 0));
		КонецЕсли;
			
	Иначе
		
		ИндексКартинки = 4;
		
	КонецЕсли;
	
	Возврат ИндексКартинки;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруНовыхСтрок(Ссылка, ПараметрыСтруктурыИерархии, МассивЭлементов, СтруктураПараметровФормы)
	
	СтруктураВозврата = Справочники.торо_ОбъектыРемонта.ПолучитьСтруктуруНовыхСтрокДляДереваПриРазворачивании(Ссылка, ПараметрыСтруктурыИерархии,МассивЭлементов,СтруктураПараметровФормы);
	торо_РаботаСИерархией.ЗаполнитьДопПоляСпискаОбъектовСервере(СтруктураВозврата);
	Возврат СтруктураВозврата;	
	
КонецФункции

&НаКлиенте
Процедура ВыбратьЗавершение(РезультатВопроса,ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Закрыть(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыделитьСтрокуДереваНаКлиенте(Ссылка, ЭлементыДерева, СтрокаВыделена)
	
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Если СтрокаВыделена Тогда
			Возврат;
		КонецЕсли; 
		
		Если ЭлементДерева.Ссылка = Ссылка Тогда
			СтрокаВыделена = Истина;
			Элементы.Дерево.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			Возврат;
		Иначе
			ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
			ВыделитьСтрокуДереваНаКлиенте(Ссылка,ВложенныеЭлементы,СтрокаВыделена);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборЗначения()
	
	Если Элементы.ГруппаДерево.Видимость Тогда
		ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.СписокОбъектов.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть(Неопределено);
	Иначе
		Если торо_ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Ссылка,"ПометкаУдаления") Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ВыбратьЗавершение",ЭтаФорма,ТекущиеДанные.Ссылка),НСтр("ru = 'Выбранные данные помечены на удаление. Выполнить выбор этих данных?'"),РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
		Иначе
			Закрыть(ТекущиеДанные.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНаКлиентеСписокОР(Текст = Неопределено)
	
	Если Текст = Неопределено Тогда
		Текст = Элементы.ЗначениеОтбораСпискаОбъектовРемонта.ТекстРедактирования;		
	КонецЕсли;
	
	ИспользованиеИтбора = (Текст <> "");
	РеквизитПоиска = ТипПоискаДанных;
	СтруктураОтбора = Новый Структура;
	
	УстановитьВидимостьЗакладок(ИспользованиеИтбора);
	
	Если ИспользованиеИтбора Тогда
		Кнопка = Элементы.ФормаСправочникторо_ОбъектыРемонтаИерархическийПросмотр;
		Если Кнопка.Пометка Тогда
			Кнопка.Пометка = НЕ Кнопка.Пометка;
			торо_РаботаСИерархиейКлиент.УстановитьОтборВСписке(ЭтаФорма, Неопределено, Истина);
		КонецЕсли;
		СтруктураОтбора.Вставить(РеквизитПоиска, СокрЛП(Текст));	
	КонецЕсли;

	Элементы.СписокОбъектов.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	
КонецПРоцедуры

&НаКлиенте
Процедура УстановитьВидимостьЗакладок(РежимПоиска = Ложь)
	
	Элементы.ГруппаДерево.Видимость = НЕ РежимПоиска;
	Элементы.ГруппаСписок.Видимость = РежимПоиска;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыИерархии()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
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
	
КонецПроцедуры

#КонецОбласти
