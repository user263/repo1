
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВариантАнализа = Параметры.ВариантАнализа;
	ПредставлениеПараметров = Параметры.ПредставлениеПараметров;
	
	Элементы.Настройки.Пометка = Ложь;
	
	ЭтаФорма.Заголовок = НСтр("ru='Расшифровка показателя '")+ВариантАнализа;
	
	ТабДанных = торо_ПоказателиKPI.ОбъединитьТаблицыДанныхИзПараметров(Параметры);
	Если ТабДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресТаблицыДанных = ПоместитьВоВременноеХранилище(ТабДанных, ЭтаФорма.УникальныйИдентификатор);
	
	СКД = торо_ПоказателиKPI.ПодготовитьСКДДляВыводаТаблицыДанных(ТабДанных);
	
	АдресСКД = ПоместитьВоВременноеХранилище(СКД, ЭтаФорма.УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	СформироватьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	Результат.Очистить();
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресСКД) Тогда
		Возврат;
	КонецЕсли;
	
	СКД = ПолучитьИзВременногоХранилища(АдресСКД);
	ТабДанных = ПолучитьИзВременногоХранилища(АдресТаблицыДанных);
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	Макет = Отчеты.торо_МониторKPI.ПолучитьМакет("МакетСтраницыПоказателя");
		
	торо_ПоказателиKPI.СформироватьУниверсальныйОтчетРасшифровкуПоказателя(Результат, Макет, СКД, ТабДанных, Настройки, ВариантАнализа, ПредставлениеПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	Элементы.ГруппаНастройки.Видимость = Не Элементы.ГруппаНастройки.Видимость;
	Элементы.Настройки.Пометка = Элементы.ГруппаНастройки.Видимость;
	
КонецПроцедуры

#КонецОбласти
