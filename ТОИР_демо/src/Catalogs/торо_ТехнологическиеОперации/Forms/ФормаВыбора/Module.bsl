
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЭтаФорма.ЗакрыватьПриВыборе = Ложь Тогда
		Оповестить("ПодборЗакрыт");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти