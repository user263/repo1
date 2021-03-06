#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// Ограничение ввода на основании
	торо_СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, Новый Структура("ОграничитьВводНаОсновании, УстановитьСвойствоЭлементовФормыОтПрав",Истина, Истина));	
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать

	ЭтаФорма.Элементы.Список.ПодчиненныеЭлементы.СтатусДокумента.Видимость = ПолучитьФункциональнуюОпцию("торо_ИспользоватьСтатусыДокументовТОиР");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия  = "ПАРАМЕТРЫ_ПЕЧАТИ_АктДефектации" И Источник = ЭтаФорма Тогда
		
		Если Не Параметр = Неопределено ИЛИ НЕ Параметр.Количество() = 0 Тогда
			Для каждого Элем Из Параметр Цикл
				
				СтруктураПараметровКоманды = Новый Структура("Док, ID", Элементы.Список.ТекущиеДанные.Ссылка, Элем);
				МассивПараметровКоманды = Новый Массив();
				МассивПараметровКоманды.Добавить(Элементы.Список.ТекущиеДанные.Ссылка);
						
				торо_Печать.НапечататьДокумент("Документ.торо_ВыявленныеДефекты",
												"АктДефектации",
												МассивПараметровКоманды,
												СтруктураПараметровКоманды);
			КонецЦикла;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти