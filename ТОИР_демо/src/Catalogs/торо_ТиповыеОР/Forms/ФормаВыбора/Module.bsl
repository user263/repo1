#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТипПоискаДанных = Элементы.ТипПоискаДанных.СписокВыбора[0].Значение;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийПрочихЭлементовФормы  	
&НаКлиенте
Процедура ЗначениеОтбораСпискаОбъектовРемонтаПриИзменении(Элемент)  	
	ОтборНаКлиентеСписокОР(Элемент.ТекстРедактирования);
КонецПроцедуры   

&НаКлиенте
Процедура ЗначениеОтбораСпискаОбъектовРемонтаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	ОтборНаКлиентеСписокОР(Элемент.ТекстРедактирования);
КонецПроцедуры 

&НаКлиенте
Процедура ЗначениеОтбораСпискаОбъектовРемонтаОчистка(Элемент, СтандартнаяОбработка)
	ОтборНаКлиентеСписокОР("");	
КонецПроцедуры  

&НаКлиенте
Процедура ТипПоискаДанныхПриИзменении(Элемент)
	ОтборНаКлиентеСписокОР();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОтборНаКлиентеСписокОР(Текст = Неопределено)
	Если Текст = Неопределено Тогда
		Текст = Элементы.ЗначениеОтбораСпискаОбъектовРемонта.ТекстРедактирования;		
	КонецЕсли; 
	
	РеквизитПоиска = ТипПоискаДанных;
	СтруктураОтбора = Новый Структура;
	
	Список.Отбор.Элементы.Очистить();
	
	Если Текст <> "" Тогда
		
		Если НЕ Элементы.Список.Отображение = ОтображениеТаблицы.Список Тогда
			Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		КонецЕсли;
		
		ЭлемОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлемОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
		ЭлемОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(РеквизитПоиска);
		ЭлемОтбора.ПравоеЗначение = СокрЛП(Текст);
		ЭлемОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;
	
КонецПРоцедуры
#КонецОбласти  