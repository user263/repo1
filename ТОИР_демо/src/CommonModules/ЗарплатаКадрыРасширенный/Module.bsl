////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ОформлениеНесколькихДокументовНаОднуДату

Функция ЗначениеСдвигаПериодаЗаписиРегистра(Документ) Экспорт 
	
	ТипДокумента = ТипЗнч(Документ);
	
	Сдвиг = Неопределено;
	
	Если ТипДокумента = Тип("ДокументСсылка.ПриемНаРаботу") Тогда
		Сдвиг = 20;
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.Увольнение") Тогда
		Сдвиг = 86360;
	КонецЕсли;
	
	Возврат Сдвиг;
	
КонецФункции

Функция КонкурирующиеПоПериодуРегистраторыНачислений() Экспорт 
	
	КонкурирующиеРегистраторы = Новый Массив;
	
	КонкурирующиеРегистраторы.Добавить(Тип("ДокументСсылка.КадровыйПеревод"));
	
	Возврат КонкурирующиеРегистраторы;
	
КонецФункции

Процедура УстановитьВремяРегистрацииДокумента(Движения, СотрудникиДаты, Регистратор, ИмяКолонкиПериод = "ДатаСобытия") Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	СдвигПериода = ЗначениеСдвигаПериодаЗаписиРегистра(Регистратор);
	
	Если СдвигПериода <> Неопределено Тогда 
		
		// Документ с фиксированным временем
		СотрудникиДаты.Свернуть(ИмяКолонкиПериод + ", Сотрудник");
		
		НаборЗаписей = РегистрыСведений.ВремяРегистрацииДокументовПлановыхНачислений.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Регистратор);
		
		Для Каждого ДанныеСотрудника Из СотрудникиДаты Цикл 
			
			ДатаСобытия = НачалоДня(ДанныеСотрудника[ИмяКолонкиПериод]);
			ВремяРегистрации = ДатаСобытия + СдвигПериода;
			
			ЗаписьРегистра = НаборЗаписей.Добавить();
			ЗаписьРегистра.Дата = ДатаСобытия;
			ЗаписьРегистра.Сотрудник = ДанныеСотрудника.Сотрудник;
			ЗаписьРегистра.Документ = Регистратор;
			ЗаписьРегистра.ВремяРегистрации = ВремяРегистрации;
			
		КонецЦикла;
	
		НаборЗаписей.Записать();
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СотрудникиДаты." + ИмяКолонкиПериод + " КАК Дата,
	               |	СотрудникиДаты.Сотрудник КАК Сотрудник
	               |ПОМЕСТИТЬ ВТСотрудникиДаты
	               |ИЗ
	               |	&СотрудникиДаты КАК СотрудникиДаты
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	НАЧАЛОПЕРИОДА(СотрудникиДаты.Дата, ДЕНЬ) КАК Дата,
	               |	СотрудникиДаты.Сотрудник
	               |ПОМЕСТИТЬ ВТИзмеренияДаты
	               |ИЗ
	               |	ВТСотрудникиДаты КАК СотрудникиДаты
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВремяРегистрацииДокументов.Дата КАК Дата,
	               |	ВремяРегистрацииДокументов.Сотрудник КАК Сотрудник,
	               |	ВремяРегистрацииДокументов.Документ КАК Документ,
	               |	ВремяРегистрацииДокументов.ВремяРегистрации КАК ВремяРегистрации
	               |ПОМЕСТИТЬ ВТЗаписиРегистра
	               |ИЗ
	               |	ВТИзмеренияДаты КАК ИзмеренияДаты
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВремяРегистрацииДокументовПлановыхНачислений КАК ВремяРегистрацииДокументов
	               |		ПО ИзмеренияДаты.Дата = ВремяРегистрацииДокументов.Дата
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Документ,
	               |	Дата,
	               |	Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ИзмеренияДаты.Дата,
	               |	ЗаписиРегистра.ВремяРегистрации КАК ВремяРегистрации
	               |ПОМЕСТИТЬ ВТВремяРегистрацииДокументов
	               |ИЗ
	               |	ВТИзмеренияДаты КАК ИзмеренияДаты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаписиРегистра КАК ЗаписиРегистра
	               |		ПО ИзмеренияДаты.Дата = ЗаписиРегистра.Дата
	               |			И (ЗаписиРегистра.Документ = &Регистратор)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВремяРегистрацииДокументов.Дата,
	               |	ВремяРегистрацииДокументов.ВремяРегистрации
	               |ИЗ
	               |	ВТВремяРегистрацииДокументов КАК ВремяРегистрацииДокументов
	               |ГДЕ
	               |	ВремяРегистрацииДокументов.ВремяРегистрации ЕСТЬ NULL ";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ВремяРегистрацииДокумента = Новый Соответствие;
	
	ТребуетсяНовоеВремяРегистрации = Не РезультатЗапроса.Пустой();
	
	Если Не ТребуетсяНовоеВремяРегистрации Тогда
		
		// Проверим, что по набору сотрудников нет конфликтов с другими регистраторами.
		Запрос.Текст = "ВЫБРАТЬ
		               |	ИзмеренияДаты.Сотрудник
		               |ИЗ
		               |	ВТИзмеренияДаты КАК ИзмеренияДаты
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВремяРегистрацииДокументов КАК ВремяРегистрацииДокументов
		               |		ПО ИзмеренияДаты.Дата = ВремяРегистрацииДокументов.Дата
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаписиРегистра КАК ЗаписиРегистра
		               |		ПО ИзмеренияДаты.Дата = ЗаписиРегистра.Дата
		               |			И ИзмеренияДаты.Сотрудник = ЗаписиРегистра.Сотрудник
		               |			И (ВремяРегистрацииДокументов.ВремяРегистрации = ЗаписиРегистра.ВремяРегистрации)
		               |			И (ЗаписиРегистра.Документ <> &Регистратор)";
					   
		РезультатЗапроса = Запрос.Выполнить();
					   
		ТребуетсяНовоеВремяРегистрации = Не РезультатЗапроса.Пустой();
		
	КонецЕсли;
	
	Если Не ТребуетсяНовоеВремяРегистрации Тогда
	
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВремяРегистрацииДокументов.Дата,
		               |	ВремяРегистрацииДокументов.ВремяРегистрации
		               |ИЗ
		               |	ВТВремяРегистрацииДокументов КАК ВремяРегистрацииДокументов";
					   
		Выборка = Запрос.Выполнить().Выбрать();			   
		
		Пока Выборка.Следующий() Цикл 
			ВремяРегистрацииДокумента.Вставить(Выборка.Дата, Выборка.ВремяРегистрации);
		КонецЦикла;
		
		// Если список сотрудников и дат в переданной таблице и в регистре не совпадает - нужно перезаписать набор.
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВремяРегистрацииДокументов.Дата КАК Дата,
		               |	ВремяРегистрацииДокументов.Сотрудник КАК Сотрудник
		               |ПОМЕСТИТЬ ВТЗаписиРегистратора
		               |ИЗ
		               |	РегистрСведений.ВремяРегистрацииДокументовПлановыхНачислений КАК ВремяРегистрацииДокументов
		               |ГДЕ
		               |	ВремяРегистрацииДокументов.Документ = &Регистратор
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ИзмеренияДаты.Сотрудник
		               |ИЗ
		               |	ВТИзмеренияДаты КАК ИзмеренияДаты
		               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаписиРегистратора КАК ЗаписиРегистратора
		               |		ПО ИзмеренияДаты.Дата = ЗаписиРегистратора.Дата
		               |			И ИзмеренияДаты.Сотрудник = ЗаписиРегистратора.Сотрудник
		               |ГДЕ
		               |	ЗаписиРегистратора.Сотрудник ЕСТЬ NULL 
		               |
		               |ОБЪЕДИНИТЬ ВСЕ
		               |
		               |ВЫБРАТЬ
		               |	ЗаписиРегистратора.Сотрудник
		               |ИЗ
		               |	ВТЗаписиРегистратора КАК ЗаписиРегистратора
		               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТИзмеренияДаты КАК ИзмеренияДаты
		               |		ПО ЗаписиРегистратора.Дата = ИзмеренияДаты.Дата
		               |			И ЗаписиРегистратора.Сотрудник = ИзмеренияДаты.Сотрудник
		               |ГДЕ
		               |	ИзмеренияДаты.Сотрудник ЕСТЬ NULL ";
					   
		РезультатЗапроса = Запрос.Выполнить();
					   
		ЗаписатьНабор = Не РезультатЗапроса.Пустой();
		
	Иначе 
		
		// Определим свободное время для регистрации движений документа.
		Запрос.Текст = "ВЫБРАТЬ
		               |	ЗаписиРегистра.Дата КАК Дата,
		               |	МАКСИМУМ(ДОБАВИТЬКДАТЕ(ЗаписиРегистра.ВремяРегистрации, СЕКУНДА, 1)) КАК ВремяРегистрации
		               |ПОМЕСТИТЬ ВТСвободноеВремяРегистрации
		               |ИЗ
		               |	ВТИзмеренияДаты КАК ИзмеренияДаты
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаписиРегистра КАК ЗаписиРегистра
		               |		ПО ИзмеренияДаты.Дата = ЗаписиРегистра.Дата
		               |			И ИзмеренияДаты.Сотрудник = ЗаписиРегистра.Сотрудник
		               |			И (ЗаписиРегистра.Документ <> &Регистратор)
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ЗаписиРегистра.Дата
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВремяРегистрацииДокументов.Дата КАК Дата,
		               |	ЕСТЬNULL(СвободноеВремяРегистрации.ВремяРегистрации, ДАТАВРЕМЯ(1, 1, 1)) КАК ВремяРегистрации
		               |ИЗ
		               |	ВТВремяРегистрацииДокументов КАК ВремяРегистрацииДокументов
		               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТСвободноеВремяРегистрации КАК СвободноеВремяРегистрации
		               |		ПО ВремяРегистрацииДокументов.Дата = СвободноеВремяРегистрации.Дата";
					   
		Выборка = Запрос.Выполнить().Выбрать();			   
		
		СдвигПериода = 60;
		
		Пока Выборка.Следующий() Цикл
			ВремяРегистрации = ?(ЗначениеЗаполнено(Выборка.ВремяРегистрации), Выборка.ВремяРегистрации, Выборка.Дата + СдвигПериода);
			ВремяРегистрацииДокумента.Вставить(Выборка.Дата, ВремяРегистрации);
		КонецЦикла;
		
		ЗаписатьНабор = Истина;
		
	КонецЕсли;
	
	Если ЗаписатьНабор Тогда 
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	ИзмеренияДаты.Дата КАК Дата,
		               |	ИзмеренияДаты.Сотрудник КАК Сотрудник
		               |ИЗ
		               |	ВТИзмеренияДаты КАК ИзмеренияДаты";
					  
		Выборка = Запрос.Выполнить().Выбрать();
		
		НаборЗаписей = РегистрыСведений.ВремяРегистрацииДокументовПлановыхНачислений.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Регистратор);
			
		Пока Выборка.Следующий() Цикл 
			
			ДатаСобытия = Выборка.Дата;
			ВремяРегистрации = ВремяРегистрацииДокумента.Получить(ДатаСобытия);
			
			ЗаписьРегистра = НаборЗаписей.Добавить();
			ЗаписьРегистра.Дата = ДатаСобытия;
			ЗаписьРегистра.Сотрудник = Выборка.Сотрудник;
			ЗаписьРегистра.Документ = Регистратор;
			ЗаписьРегистра.ВремяРегистрации = ВремяРегистрации;
			
		КонецЦикла;
	
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
	Для Каждого НаборЗаписейРегистра Из Движения Цикл 
		НаборЗаписейРегистра.ДополнительныеСвойства.Вставить("ВремяРегистрацииДокумента", ВремяРегистрацииДокумента);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти