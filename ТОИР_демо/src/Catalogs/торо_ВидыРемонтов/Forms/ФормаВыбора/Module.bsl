#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.КлючНазначенияИспользования) Тогда
		Если (Параметры.КлючНазначенияИспользования = "ПредшествующиеРемонты" 
				ИЛИ Параметры.КлючНазначенияИспользования = "Визуализация"
				ИЛИ Параметры.КлючНазначенияИспользования = "ПредшествующиеМероприятия" 				
				)
			И Параметры.Свойство("СписокОтбора") Тогда
			
			Элементы.Список.Отображение = ОтображениеТаблицы.Список;
			
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));										 
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
			ЭлементОтбора.ПравоеЗначение = Параметры.СписокОтбора;
			ЭлементОтбора.Использование = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	торо_СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, Новый Структура("УстановитьСвойствоЭлементовФормыОтПрав", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не (ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("ТаблицаФормы") И ЭтаФорма.ВладелецФормы.Имя = "ДеревоПланаГрафикаППРСУчетомПозиции") Тогда	
		ПользовательскийОтбор = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
		ПользовательскийОтбор.Элементы.Очистить();
	КонецЕсли;

КонецПроцедуры


#КонецОбласти