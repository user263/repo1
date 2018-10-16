
#Область ОбработчикиСобытийЭлементовТаблицыФормыОповещаемые
&НаКлиенте
Процедура ОповещаемыеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		СписокДоступныхТипов = Новый СписокЗначений;
		
		СписокДоступныхТипов.Добавить("Пользователи");
		СписокДоступныхТипов.Добавить("Ответственный по документу");
		
		Если торо_Согласования.ПроверитьИспользованиеСогласованияДокументов() Тогда
			
			СписокДоступныхТипов.Добавить("Согласующие");
			СписокДоступныхТипов.Добавить("Оповещаемые");
			
		КонецЕсли;
		
		ВыбранныйТип = Неопределено;

		
		СписокДоступныхТипов.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОповещаемыеПриНачалеРедактированияЗавершение", ЭтотОбъект), НСтр("ru = 'Кому формировать уведомления'"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОповещаемыеПриНачалеРедактированияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    ВыбранныйТип = ВыбранныйЭлемент;
    
    Если ВыбранныйТип <> Неопределено Тогда	
        Если ВыбранныйТип.Значение = "Пользователи" Тогда
            
            Элементы.Оповещаемые.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
            
        Иначе
            
            Элементы.Оповещаемые.ТекущиеДанные.Пользователь = ВыбранныйТип;
            
        КонецЕсли;
    Иначе
        Элементы.Оповещаемые.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
    КонецЕсли;
    
КонецПроцедуры


#КонецОбласти