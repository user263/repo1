#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ОтборПоПроведенным") Тогда
		торо_ОбщегоНазначения.УстановитьОтборВСпискеДокументов(Список, "Проведен", Параметры.ОтборПоПроведенным, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборПоСтатусам") И Параметры.ОтборПоСтатусам Тогда
		торо_ОбщегоНазначения.УстановитьОтборВСпискеДокументов(Список, "СтатусДокумента", Перечисления.торо_СтатусыДокументов.Зарегистрирован, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
	// Ограничение ввода на основании
	торо_СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, Новый Структура("ОграничитьВводНаОсновании",Истина));
	
	ЭтаФорма.Элементы.Список.ПодчиненныеЭлементы.СтатусДокумента.Видимость = ПолучитьФункциональнуюОпцию("торо_ИспользоватьСтатусыДокументовТОиР");
	
КонецПроцедуры
#КонецОбласти