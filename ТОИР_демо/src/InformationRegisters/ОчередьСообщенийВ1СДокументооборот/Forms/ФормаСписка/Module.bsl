#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПоИдентификаторуПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПоИдентификатору) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Идентификатор",
			Неопределено,
			ВидСравненияКомпоновкиДанных.Равно,,
			Ложь);
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		Идентификатор = Новый УникальныйИдентификатор(ПоИдентификатору);
	Исключение
		ПоказатьПредупреждение(, НСтр("ru = 'Идентификатор неверен.'"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Идентификатор",
			Неопределено,
			ВидСравненияКомпоновкиДанных.Равно,,
			Ложь);
		
		Возврат;
		
	КонецПопытки;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"Идентификатор",
		Идентификатор,
		ВидСравненияКомпоновкиДанных.Равно,,
		Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	#Если Не ВебКлиент Тогда
	ОткрытьСообщение();		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьСообщение()
	
	#Если Не ВебКлиент Тогда
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Состояние(НСтр("ru = 'Сообщение открывается. Пожалуйста, подождите...'"));
	ИдентификаторСообщения = ТекущиеДанные.Идентификатор;
	ДвоичныеДанные = ПросмотретьСообщениеНаСервере(ИдентификаторСообщения);  
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные.Записать(ИмяФайла);
	ЗапуститьПриложение(ИмяФайла);
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПросмотретьСообщениеНаСервере(ИдентификаторСообщения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОчередьСообщенийВ1СДокументооборот.Данные
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийВ1СДокументооборот КАК ОчередьСообщенийВ1СДокументооборот
	|ГДЕ
	|	ОчередьСообщенийВ1СДокументооборот.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторСообщения);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ДанныеСообщения = Результат.Выгрузить()[0].Данные.Получить();
	
	Если ТипЗнч(ДанныеСообщения) = Тип("ДвоичныеДанные") Тогда
		Возврат ДанныеСообщения;
	Иначе
		МассивЧастей = ДанныеСообщения;
		Если МассивЧастей = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ФайлСообщения = ПолучитьИмяВременногоФайла("xml");
		МассивФайловЧастей = Новый Массив;
		Для Каждого Часть Из МассивЧастей Цикл
			ИмяФайлаЧасти = ПолучитьИмяВременногоФайла("xml");
			ДвоичныеДанныеЧасти = Часть.Получить();
			ДвоичныеДанныеЧасти.Записать(ИмяФайлаЧасти);
			МассивФайловЧастей.Добавить(ИмяФайлаЧасти);
		КонецЦикла;
		
		ОбъединитьФайлы(МассивФайловЧастей, ФайлСообщения);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ФайлСообщения);
		
		Для Каждого ИмяФайла Из МассивФайловЧастей Цикл
			УдалитьФайлы(ИмяФайла);
		КонецЦикла;
		
		УдалитьФайлы(ФайлСообщения);
		
		Возврат ДвоичныеДанныеФайла;
	КонецЕсли;
	
КонецФункции

#КонецОбласти