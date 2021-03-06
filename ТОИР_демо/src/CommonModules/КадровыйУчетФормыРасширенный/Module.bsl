////////////////////////////////////////////////////////////////////////////////
// КадровыйУчетФормыРасширенный: методы, обслуживающие работу форм кадровых документов.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет необходимые действия при создании на сервере.
// Параметры:
//		Форма - УправляемаяФорма - форма документа.
Процедура ФормаКадровогоДокументаПриСозданииНаСервере(Форма) Экспорт
	
	КадровыйУчетФормыБазовый.ФормаКадровогоДокументаПриСозданииНаСервере(Форма);
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ФиксированныеЗначения = Новый Массив;
		
		МетаданныеДокумента = Форма.Объект.Ссылка.Метаданные();
		
		Если МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено И ЗначениеЗаполнено(Форма.Объект.Организация) Тогда
			ФиксированныеЗначения.Добавить("Организация");
		КонецЕсли; 
		
		Если МетаданныеДокумента.Реквизиты.Найти("ПодразделениеПрежнее") <> Неопределено Тогда
			
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.ПодразделениеПрежнее");
			Если ЗначениеЗаполнено(Форма.Объект.ПодразделениеПрежнее) Тогда
				ФиксированныеЗначения.Добавить("Подразделение");
			КонецЕсли; 
			
		КонецЕсли; 
		
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(Форма, ЗначенияДляЗаполнения, ФиксированныеЗначения);
		
	КонецЕсли; 
																	
КонецПроцедуры

#КонецОбласти