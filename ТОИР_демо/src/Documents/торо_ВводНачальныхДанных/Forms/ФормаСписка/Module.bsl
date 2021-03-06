#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	торо_СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, Новый Структура("УстановитьСвойствоЭлементовФормыОтПрав", Истина));

КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура СоздатьДляОбъектовРемонта(Команда)
	ОткрытьФорму("Документ.торо_ВводНачальныхДанных.Форма.ФормаДокумента", Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.торо_ВидыДокументаВводНачДанных.ПоОбъектуРемонта")), ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДляСписковОбъектов(Команда)
	ОткрытьФорму("Документ.торо_ВводНачальныхДанных.Форма.ФормаДокумента", Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.торо_ВидыДокументаВводНачДанных.ПоСпискуОбъектовРемонта")), ЭтаФорма);
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

