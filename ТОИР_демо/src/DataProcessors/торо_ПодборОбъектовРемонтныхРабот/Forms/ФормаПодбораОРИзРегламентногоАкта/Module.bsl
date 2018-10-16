
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокОР") Тогда		

		СписокОбъектов = Параметры.СписокОр;

	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоПодбор") Тогда
		ЭтоПодбор = Истина;
		Элементы.СписокОбъектов.МножественныйВыбор = Истина;
		Элементы.СписокОбъектов.РежимВыделения = РежимВыделенияТаблицы.Множественный;   		
		ЭтаФорма.ЗакрыватьПриВыборе = Ложь;     
	Иначе
		Элементы.СписокОбъектов.МножественныйВыбор = Ложь;
		Элементы.СписокОбъектов.РежимВыделения = РежимВыделенияТаблицы.Одиночный;
	КонецЕсли;
	
	Если Параметры.Свойство("КонтролируемыеПоказатели") Тогда
		ВидПодбора = "КонтролируемыеПоказатели";
		ЗапрашиватьКонтролируемыеПоказатели = (Параметры.Свойство("ЭтоПодбор") = Истина);
		Элементы.ЗапрашиватьКонтролируемыеПоказатели.Видимость = (Параметры.Свойство("ЭтоПодбор") = Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыНаработки") Тогда
		ВидПодбора = "ПараметрыНаработки";
		ЗапрашиватьВидПараметровНаработки = Истина;
		Элементы.ГруппаПоНаработке.Видимость = (Параметры.Свойство("ЭтоПодбор") = Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТаблицаПоказателей.Очистить();
	СписокВидовПоказателей.Очистить();  
	СписокВидовПараметров.Очистить();  
	
	ЗначениеВозврата =  ОтобратьОбъекты();
	
	Если ТипЗнч(ЗначениеВозврата) = Тип("СписокЗначений") тогда 
		
		Если ЗначениеВозврата.Количество() = 1 Тогда
			ОповеститьОВыборе(ЗначениеВозврата[0].Значение);
		Иначе 
			ОповеститьОВыборе(ЗначениеВозврата);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ЗначениеВозврата) = Тип("Структура") Тогда
		
		Если ВидПодбора="КонтролируемыеПоказатели" Тогда
			ТекстЗаголовкаОкна = НСтр("ru = 'Выберите виды контролируемых показателей'");
		ИначеЕсли ВидПодбора = "ПараметрыНаработки" Тогда
			ТекстЗаголовкаОкна = НСтр("ru = 'Выберите виды параметров наработки'");  
		КонецЕсли;
		
		
		Если ВидПодбора="КонтролируемыеПоказатели" Тогда			
			
			Если СписокВидовПоказателей.Количество() Тогда
				СписокВидовПоказателей.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("ВыбратьЗавершение1", ЭтотОбъект), ТекстЗаголовкаОкна);
			Иначе
				ОповеститьОВыборе(ТаблицаПоказателей);
			КонецЕсли; 
		Иначе 
			
			Если СписокВидовПараметров.Количество() Тогда
				СписокВидовПараметров.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("ВыбратьЗавершение2", ЭтотОбъект), ТекстЗаголовкаОкна);
			КонецЕсли
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Выбрать(этаформа.Команды.Найти("Выбрать"));	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция СписокВыбранныхОР()
	СписокОР = Новый СписокЗначений; 	
	ВыделенныеСтроки = Элементы.СписокОбъектов.ВыделенныеСтроки;

	Для Каждого Строка Из ВыделенныеСтроки цикл
		СтрокаСписка = СписокОбъектов.НайтиПоИдентификатору(Строка);
		
		Если СтрокаСписка <> Неопределено Тогда 			
			СписокОр.Добавить(строкаСписка.Значение);			
		КонецЕсли;  		
		
	КонецЦикла;    
   
Возврат СписокОР;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьЗавершение1(Список, Параметры)  Экспорт
	
	ВыбраныЭлементы = (Список <> Неопределено);
	
	Если ВыбраныЭлементы Тогда
		
		ПроставитьПометкиВТаблицеПоказателей();
		ОповеститьОВыборе(ТаблицаПоказателей);

	КонецЕсли;  	
		
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьЗавершение2(Список, Параметры)  Экспорт
	
	ВыбраныЭлементы = (Список <> Неопределено);
	
	Если ВыбраныЭлементы Тогда
		
		ПроставитьПометкиВТаблицеПараметров();
		Стр = Новый Структура("СписокОР, ТаблицаПоказателей", СписокВыбранныхОР(), ТаблицаПоказателей); 		
		ОповеститьОВыборе(Стр);  
		
	КонецЕсли;  	
		
КонецПроцедуры


&НаКлиенте
Функция ОтобратьОбъекты()
	                      	
	Если ВидПодбора = "ПараметрыНаработки" и Не ЭтоПодбор Тогда
		
		ЗначениеВозврата  = СписокВыбранныхОР();
		
	ИначеЕсли ЗапрашиватьКонтролируемыеПоказатели или ЗапрашиватьВидПараметровНаработки Тогда 	
		
		ЗначениеВозврата = СписокПоказателейОбъектаРемонта();			
		
	Иначе
				
		ЗначениеВозврата  = СписокВыбранныхОР();
		
	КонецЕсли;  	
	
	Возврат ЗначениеВозврата;
	
КонецФункции
	
			

&НаСервере
Функция СписокПоказателейОбъектаРемонта()
	
	Для Каждого  ИД из Элементы.СписокОбъектов.ВыделенныеСтроки Цикл
		
		ВыдСтрока = СписокОбъектов.НайтиПоИдентификатору(ИД);
		ОбъектРР = ВыдСтрока.Значение;

		Если ВыдСтрока <> Неопределено Тогда
			Если ВидПодбора="КонтролируемыеПоказатели" Тогда
				
				МассивПоказателей = ПланыВидовХарактеристик.торо_ИзмеряемыеПоказателиОбъектовРемонта.ПолучитьСтруктуруИзмеряемыхПоказателейОбъектовРемонта(ОбъектРР,,Ложь);
				Для Каждого СтруктураПоказателей Из МассивПоказателей Цикл
					СтрокаВПР = ТаблицаПоказателей.Добавить();
					СтрокаВПР.Объект = ОбъектРР;
					СтрокаВПР.ИзмеряемыйПоказатель = СтруктураПоказателей.Показатель;
					
					Если СписокВидовПоказателей.НайтиПоЗначению(СтруктураПоказателей.Показатель) = Неопределено Тогда
						СписокВидовПоказателей.Добавить(СтруктураПоказателей.Показатель, , Истина);
					КонецЕсли;
				КонецЦикла;

				Если МассивПоказателей.Количество() = 0 тогда
					Если Не ТаблицаПоказателей.НайтиСтроки(Новый структура ("Объект", ОбъектРР)).Количество()Тогда
						СтрокаВПР = ТаблицаПоказателей.Добавить();
						СтрокаВПР.Объект = ОбъектРР;
					КонецЕсли; 
				КонецЕсли;
				
			ИначеЕсли ВидПодбора = "ПараметрыНаработки" Тогда
			 	ДатаСнятияпоказателей = ТекущаяДата();
				СтруктураОтбора = Новый Структура("ОбъектРемонта",ОбъектРР);		
				ТаблицаПараметровНаработки= РегистрыСведений.торо_ПараметрыНаработкиОбъектовРемонта.СрезПоследних(,СтруктураОтбора);
				Для Каждого СтрПараметрНаработки Из ТаблицаПараметровНаработки Цикл
					СтрокаВПР = ТаблицаПоказателей.Добавить();
					СтрокаВПР.Объект = ОбъектРР;
					СтрокаВПР.Параметр = СтрПараметрНаработки.Показатель;
					СтрокаВПР.ДатаСнятия = ДатаСнятияПоказателей;
					СтрокаВПР.УчитыватьПростоиОР = УчитыватьПростоиОР;
					СтрокаВПР.ПроставлятьПлановуюНаработку = ПроставлятьПлановуюНаработку;

					
					Если СписокВидовПараметров.НайтиПоЗначению(СтрПараметрНаработки.Показатель) = Неопределено Тогда
						
						СписокВидовПараметров.Добавить(СтрПараметрНаработки.Показатель, , Истина);
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если Не ТаблицаПараметровНаработки.Количество() Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Невозможно добавить строку регистрации наработки, поскольку для объекта ремонта %1 отсутствуют параметры наработки!'"),ОбъектРР);
					Сообщение.Сообщить();
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
		
	КонецЦикла;
	
	Если ВидПодбора = "ПараметрыНаработки" Тогда
		СтруктураОтбора = Новый Структура("ТаблицаОбъектов, СписокПоказателей", ТаблицаПоказателей, СписокВидовПараметров); 
	Иначе
		СтруктураОтбора = Новый Структура("ТаблицаОбъектов, СписокПараметров", ТаблицаПоказателей, СписокВидовПоказателей); 		
	КонецЕсли;
	
	Возврат СтруктураОтбора;
	
КонецФункции



&НаСервере 
Процедура ПроставитьПометкиВТаблицеПоказателей()
	
	Для Каждого ЭлементСписка из СписокВидовПоказателей Цикл
		Если ЭлементСписка.Пометка  Тогда
		  СтруктураПоиска = Новый Структура("ИзмеряемыйПоказатель", ЭлементСписка.Значение);
		  НайдСтроки = ТаблицаПоказателей.НайтиСтроки(СтруктураПоиска);
		  Для Каждого Строка из НайдСтроки Цикл
			 Строка.Выбран = Истина; 
		  КонецЦикла;
		  
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Процедура ПроставитьПометкиВТаблицеПараметров()
	
	Для Каждого ЭлементСписка из СписокВидовПараметров Цикл
		Если ЭлементСписка.Пометка  Тогда
		  СтруктураПоиска = Новый Структура("Параметр", ЭлементСписка.Значение);
		  НайдСтроки = ТаблицаПоказателей.НайтиСтроки(СтруктураПоиска);
		  Для Каждого Строка из НайдСтроки Цикл
			 Строка.Выбран = Истина; 
		  КонецЦикла;  		  
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

