#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если Не ТекущиеДанные = Неопределено Тогда
		Если Не ТекущиеДанные.ЭтоГруппа Тогда
			СтандартнаяОбработка = Ложь;
			ОткрытьФорму("Справочник.торо_СписокОбъектовРегламентногоМероприятия.Форма.ФормаЭлемента", Новый Структура("Ключ", ТекущиеДанные.Ссылка), ЭтаФорма, ТекущиеДанные.Ссылка);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти