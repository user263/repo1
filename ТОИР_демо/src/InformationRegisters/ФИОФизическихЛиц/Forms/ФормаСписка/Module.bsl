#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФизическоеЛицо = Параметры.ФизическоеЛицо;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	Если НЕ ФизическоеЛицо.Пустая() тогда
		Оповестить("ИзмененоФИО", ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
