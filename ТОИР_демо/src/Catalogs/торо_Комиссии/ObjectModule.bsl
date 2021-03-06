
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	МассивСтрок = СоставКомиссии.НайтиСтроки(Новый Структура("ЧленКомиссии", Председатель));
	
	Если МассивСтрок.Количество() > 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Сотрудник не может быть председателем и членом комиссии одновременно'") ;
		Сообщение.Поле  = "Председатель";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить(); 
		Отказ = Истина;
	КонецЕсли;
	
	ВспомТЗ = СоставКомиссии.Выгрузить();
	ВспомТЗ.Колонки.Добавить("Количество");
	ВспомТЗ.ЗаполнитьЗначения(1, "Количество");
	ВспомТЗ.Свернуть("ЧленКомиссии", "Количество");
	
	Для каждого Строка Из ВспомТЗ Цикл
		Если Строка.Количество > 1 Тогда
			
			МассивСтрок = СоставКомиссии.НайтиСтроки(Новый Структура("ЧленКомиссии", Строка.ЧленКомиссии));
			НомераСтрок = "";
			
			Для каждого СтрокаДляНомера Из МассивСтрок Цикл
				НомераСтрок = НомераСтрок + ", " + СтрокаДляНомера.НомерСтроки;
			КонецЦикла;
			
			НомераСтрок = Сред(НомераСтрок, 3, СтрДлина(НомераСтрок));
			
			Сообщение = Новый СообщениеПользователю;
			ТекстСообщения = НСтр("ru = 'Сотрудник %Сотрудник% указан в составе членов комиссии в строках %НомераСтрок%'"); 
			Сообщение.Текст = СтрЗаменить(СтрЗаменить(ТекстСообщения, "%Сотрудник%", Строка.ЧленКомиссии), "%НомераСтрок%", НомераСтрок);
			Сообщение.Сообщить(); 
			Отказ = Истина;
			
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти