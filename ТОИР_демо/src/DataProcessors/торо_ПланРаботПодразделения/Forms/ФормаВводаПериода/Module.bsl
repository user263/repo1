
#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Элементы.ТПОтборПечатнойФормыЗначение.ВыбиратьТип=Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НоваяСтрока=ТПОтборПечатнойФормы.Добавить();	
	НоваяСтрока.Имя="Объект ремонта";
	
	НоваяСтрока=ТПОтборПечатнойФормы.Добавить();
	НоваяСтрока.Имя="Вид ремонта";
	
	Если Параметры.Подразделение.Количество()>0 Тогда
		Подразделение = Параметры.Подразделение[0].Значение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДатаНачала) Тогда
		НачПерПоян = Параметры.ДатаНачала;
	Иначе
		КонПерПоян = Дата(0001,01,1);	
	КонецЕслИ;

	
	Если ЗначениеЗаполнено(Параметры.Датаокончания) Тогда
		КонПерПоян = Параметры.Датаокончания;
	Иначе
		КонПерПоян = Дата(3999,11,1);	
	КонецЕслИ;
	ВыводитьПо = Параметры.ВыводитьПо;
	
	ТекГод = Год(ТекущаяДата());
	Элементы.ИнтервалРазбиения.СписокВыбора.Добавить("Год");
	Элементы.ИнтервалРазбиения.СписокВыбора.Добавить("Месяц");
	Элементы.ИнтервалРазбиения.СписокВыбора.Добавить("Неделя");
	Элементы.ИнтервалРазбиения.СписокВыбора.Добавить("День");
	ИнтервалРазбиения = "Месяц";
 	
	ПериодНач=НачПерПоян;
	ПериодКон=КонПерПоян;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ПериодНачПриИзменении(Элемент)
	ПериодНачПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПериодНачПриИзмененииНаСервере()
	Если ПериодНач > ПериодКон И ЗначениеЗаполнено(ПериодКон) тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала периода не может быть больше даты его начала.'"));
		ПериодНач = НачПерПоян;
		Возврат;
	КонецЕсли;	
	Если ПериодНач < НачПерПоян или ПериодНач > КонПерПоян Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введенная дата находится за пределами возможного диапазона.'"));
		ПериодНач = НачПерПоян;
		Возврат;
	КонецЕсли;
	Если ((НачалоДня(ПериодКон) - НачалоДня(ПериодНач))/(60*60*24)>=31*3) И
		(ИнтервалРазбиения = Перечисления.Периодичность.День) тогда 
		    торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Детализация для такого периода не допустима по дням!'"));
			Элементы.ПолеВыбораИнтервала.Значение = "Неделя";
			ИнтервалРазбиения = Перечисления.Периодичность.Неделя;	
		Возврат;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПериодКонПриИзменении(Элемент)
	ПериодКонПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПериодКонПриИзмененииНаСервере()
	Если ПериодКон < ПериодНач тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата конца периода не может быть меньше даты его начала.'"));
		ПериодКон = КонПерПоян;
		Возврат;
	КонецЕсли;	
	Если ПериодКон < НачПерПоян или ПериодКон > КонПерПоян Тогда
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введенная дата находится за пределами возможного диапазона.'"));
		ПериодКон = КонПерПоян;
		Возврат;
	КонецЕсли;
	Если ((НачалоДня(ПериодКон) - НачалоДня(ПериодНач))/(60*60*24)>=31*3) И
		(ИнтервалРазбиения = Перечисления.Периодичность.День) тогда 
		    торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Детализация для такого периода не допустима по дням!'"));
			Элементы.ПолеВыбораИнтервала.Значение = "Неделя";
			ИнтервалРазбиения = Перечисления.Периодичность.Неделя;
			Возврат;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалРазбиенияПриИзменении(Элемент)
	
	Если ИнтервалРазбиения = "Год" Тогда		
	ИначеЕсли ИнтервалРазбиения = "Месяц" Тогда			
	ИначеЕсли ИнтервалРазбиения = "Неделя" Тогда		
	ИначеЕсли ИнтервалРазбиения = "День" Тогда
		Если (НачалоДня(ПериодКон) - НачалоДня(ПериодНач))/(60*60*24)>=31*3 тогда 
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Детализация для такого периода не допустима по дням.'"));
			ИнтервалРазбиения = "Неделя";	
		КонецЕсли;
	Иначе
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Детализация для такого периода не допустима.'"));
		ИнтервалРазбиения = "Месяц";	
	КонецЕсли;	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТПОтборПечатнойФормы
&НаКлиенте
Процедура ТПОтборПечатнойФормыЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ТПОтборПечатнойФормы.ТекущиеДанные;
	Если ТекДанные <> Неопределено И ТекДанные.Значение = Неопределено Тогда
		
		НеобходимСписок = (ТекДанные.ВидСравнения = ВидСравнения.ВСписке Или ТекДанные.ВидСравнения = ВидСравнения.НеВСписке Или ТекДанные.ВидСравнения = ВидСравнения.ВСпискеПоИерархии);
		
		Если ТекДанные.Имя = "Объект ремонта" Тогда
			Если НеобходимСписок Тогда
				НеобходимыйСписок = Новый СписокЗначений;
				НеобходимыйСписок.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта, СправочникСсылка.торо_СписокОбъектовРегламентногоМероприятия");
				ТекДанные.Значение = НеобходимыйСписок;
			Иначе
				СписокТипов = Новый СписокЗначений;
				СписокТипов.Добавить(Тип("СправочникСсылка.торо_ОбъектыРемонта"));
				СписокТипов.Добавить(Тип("СправочникСсылка.торо_СписокОбъектовРегламентногоМероприятия"));
				СписокТипов.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ПоказВыбораТипаТПОтборПечатнойФормыЗначениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ТекДанные", ТекДанные)), "Выберите тип");
			КонецЕсли;
		ИначеЕсли ТекДанные.Имя = "Вид ремонта" Тогда
			Если НеобходимСписок Тогда
				НеобходимыйСписок = Новый СписокЗначений;
				НеобходимыйСписок.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.торо_ВидыРемонтов");
				ТекДанные.Значение = НеобходимыйСписок;
			Иначе
				ТекДанные.Значение = ПредопределенноеЗначение("Справочник.торо_ВидыРемонтов.ПустаяСсылка");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказВыбораТипаТПОтборПечатнойФормыЗначениеНачалоВыбораЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		Если РезультатВыбора.Значение = Тип("СправочникСсылка.торо_ОбъектыРемонта") Тогда
			ДопПараметры.ТекДанные.Значение = ПредопределенноеЗначение("Справочник.торо_ОбъектыРемонта.ПустаяСсылка");
		ИначеЕсли РезультатВыбора.Значение = Тип("СправочникСсылка.торо_СписокОбъектовРегламентногоМероприятия") Тогда
			ДопПараметры.ТекДанные.Значение = ПредопределенноеЗначение("Справочник.торо_СписокОбъектовРегламентногоМероприятия.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТПОтборПечатнойФормыЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ТПОтборПечатнойФормы.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.Значение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТПОтборПечатнойФормыВидСравненияПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТПОтборПечатнойФормы.ТекущиеДанные;
	Если ТекДанные <> Неопределено И ТекДанные.Значение <> Неопределено Тогда
		НеобходимСписок = (ТекДанные.ВидСравнения = ВидСравнения.ВСписке Или ТекДанные.ВидСравнения = ВидСравнения.НеВСписке Или ТекДанные.ВидСравнения = ВидСравнения.ВСпискеПоИерархии);
		
		Если Не НеобходимСписок И ТипЗнч(ТекДанные.Значение) = Тип("СписокЗначений") Тогда
			Если ТекДанные.Значение.Количество() > 0 Тогда
				ТекДанные.Значение = ТекДанные.Значение[0].Значение;
			Иначе
				ТекДанные.Значение = ?(ТекДанные.Имя = "Объект ремонта", Неопределено, ПредопределенноеЗначение("Справочник.торо_ВидыРемонтов.ПустаяСсылка"));
			КонецЕсли;
		ИначеЕсли НеобходимСписок И Не ТипЗнч(ТекДанные.Значение) = Тип("СписокЗначений") Тогда
			НеобходимыйСписок = Новый СписокЗначений;
			НеобходимыйСписок.ТипЗначения = ?(ТекДанные.Имя = "Объект ремонта",Новый ОписаниеТипов("СправочникСсылка.торо_ОбъектыРемонта, СправочникСсылка.торо_СписокОбъектовРегламентногоМероприятия"), Новый ОписаниеТипов("СправочникСсылка.торо_ВидыРемонтов"));
			Если ЗначениеЗаполнено(ТекДанные.Значение) Тогда
				НеобходимыйСписок.Добавить(ТекДанные.Значение);
			КонецЕсли;
			ТекДанные.Значение = НеобходимыйСписок;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Печать(Команда)
	
	ПередатьПараметр = Новый Структура;
	Если ЗначениеЗаполнено(ПериодНач) Тогда
		ПередатьПараметр.Вставить("ДатаНачала",ПериодНач);
	Иначе
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Печать невозможна - заполните дату начала в поле ""Период""'"));
		Возврат;
	КонецЕсли;	
	Если ЗначениеЗаполнено(ПериодКон) Тогда
		ПередатьПараметр.Вставить("ДатаКонца",ПериодКон);
	Иначе
		торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Печать невозможна - заполните дату окончания в поле ""Период""'"));
		Возврат;
	КонецЕсли;	
	ПередатьПараметр.Вставить("Подразделение",Подразделение);
	ПередатьПараметр.Вставить("ВыводитьПо",ВыводитьПо);
	ПередатьПараметр.Вставить("ИнтервалРазбиения",ИнтервалРазбиения);
	ПередатьПараметр.Вставить("ОтборФормы",ТПОтборПечатнойФормы); 	
	
	Оповестить(КлючНазначенияИспользования, ПередатьПараметр, ЭтаФорма.ВладелецФормы);
	Закрыть();	
КонецПроцедуры

#КонецОбласти


