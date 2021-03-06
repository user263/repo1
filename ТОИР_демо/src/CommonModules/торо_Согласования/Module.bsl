////////////////////////////////////////////////////////////////////////////////
// торо_Согласования: методы, реализующие одноименную функциональность
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Функция добавляет статусы согласования по документуъ
//
// Параметры:
//  СсылкаНаДокумент - ДокументСсылка - ссылка на документ.
//  ДополнительныеСвойства - Структура - доп. свойства.
Процедура ДобавитьСтатусыСогласованияПоДокументу(СсылкаНаДокумент, ДополнительныеСвойства = Неопределено) Экспорт
	
	// Заполним таблицу согласующих.
	ТаблицаСогласующих = Новый ТаблицаЗначений;
	ТаблицаСогласующих.Колонки.Добавить("Согласующий", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	// Дополнительные свойства заполняются на форме перед записью документа.
	// В регистрах информация на этот момент может быть устаревшая, т.к. 
	// событие ПриЗаписи в форме документа (когда выполняется запись в регистры)
	// срабатывает после событий ПриЗаписи и ОбработкаПроведения в модуле объекта.
	// Но если запись выполнялась не из формы, то берем, что есть в регистрах.
	Если ДополнительныеСвойства <> Неопределено Тогда
		
		Если ДополнительныеСвойства.Свойство("СтатусДокумента") Тогда
			СтатусДокумента = ДополнительныеСвойства.СтатусДокумента;
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("Согласующие") Тогда
			СогласующиеДокумента = ДополнительныеСвойства.Согласующие;
		КонецЕсли;
		
	Иначе
		СтатусДокумента = ПолучитьТекущийСтатусСогласованияДокумента(СсылкаНаДокумент);
		СогласующиеДокумента = ПолучитьТаблицуСогласующихДокумента(СсылкаНаДокумент);
	КонецЕсли;

	
	ДеревоСогласования = торо_Ремонты.ПолучитьДеревоСогласования(СсылкаНаДокумент.СпособСогласования, СтатусДокумента, СогласующиеДокумента);
	
	Для Каждого СтрокаСтатусов Из ДеревоСогласования.Строки Цикл
		
		Для Каждого СтрокаСогласующих Из СтрокаСтатусов.Строки Цикл
			
			НовСтрокаТЗ = ТаблицаСогласующих.Добавить();
			НовСтрокаТЗ.Согласующий = СтрокаСогласующих.Согласующий;
			
			Для Каждого СтрокаЗамещающих Из СтрокаСогласующих.Строки Цикл
				
				НовСтрокаТЗ = ТаблицаСогласующих.Добавить();
				НовСтрокаТЗ.Согласующий = СтрокаЗамещающих.Замещающий;
				
			КонецЦикла; 
			
		КонецЦикла; 
		
	КонецЦикла;
	
	ТаблицаСогласующих.Свернуть("Согласующий");
	ТаблицаСогласующих.Колонки.Добавить("Дата"         , Новый ОписаниеТипов("Дата"));
	ТаблицаСогласующих.Колонки.Добавить("НеНапоминать" , Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтрокаСогласующих Из ТаблицаСогласующих Цикл
		
		ОтключитьОповещение = Истина;
		
		// Этап 1 Проход по согласовавшим
		МассивСтрокСогласовавших = ДеревоСогласования.Строки.НайтиСтроки(Новый Структура("Согласующий, Замещающий", 
		СтрокаСогласующих.Согласующий, Справочники.Пользователи.ПустаяСсылка()), Истина);
		
		Для Каждого ЭлементМС Из МассивСтрокСогласовавших Цикл
			
			Если Не ЭлементМС.Согласовано Тогда
				
				ЕстьСогласованные = Ложь;
				Для Каждого СтрокаЗамещения Из ЭлементМС.Строки Цикл
					
					Если СтрокаЗамещения.Согласовано Тогда
						
						ЕстьСогласованные = Истина;
						Прервать;
						
					КонецЕсли; 
					
				КонецЦикла; 
				
				Если Не ЕстьСогласованные Тогда
					
					ОтключитьОповещение = Ложь;
					Прервать;
					
				КонецЕсли; 
				
			КонецЕсли; 	
			
		КонецЦикла; 		
		
		Если Не ОтключитьОповещение Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		// Этап №2 Проход по замещающим
		МассивСтрокЗамещающих = ДеревоСогласования.Строки.НайтиСтроки(Новый Структура("Замещающий",
		СтрокаСогласующих.Согласующий), Истина);
		
		Для Каждого ЭлементМЗ Из МассивСтрокЗамещающих Цикл
			
			Если (Не ЭлементМЗ.Согласовано) И (Не ЭлементМЗ.Родитель.Согласовано) Тогда
				
				ЕстьСогласованные = Ложь;
				Для Каждого СтрокаЗамещения Из ЭлементМЗ.Родитель.Строки Цикл
					
					Если СтрокаЗамещения.Согласовано Тогда
						
						ЕстьСогласованные = Истина;
						Прервать;
						
					КонецЕсли; 
					
				КонецЦикла; 
				
				Если Не ЕстьСогласованные Тогда
					
					ОтключитьОповещение = Ложь;
					Прервать;
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла;
		
		Если Не ОтключитьОповещение Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		СтрокаСогласующих.Дата = ТекущаяДата();
		СтрокаСогласующих.НеНапоминать = Истина;
		
	КонецЦикла; 
	
	
	НаборЗаписейСогласования = РегистрыСведений.торо_СтатусыСогласованияДокументовРемонтныхРабот.СоздатьНаборЗаписей();
	НаборЗаписейСогласования.Отбор.Документ.Установить(СсылкаНаДокумент);
	НаборЗаписейСогласования.Записать();
	
	НаборЗаписейСогласования.Отбор.Статус.Установить(СтатусДокумента);
	НаборЗаписейСогласования.Отбор.Организация.Установить(СсылкаНаДокумент.Организация);
	
	Для Каждого СтрокаТЗ Из ТаблицаСогласующих Цикл
		
		НоваяЗапись = НаборЗаписейСогласования.Добавить();
		НоваяЗапись.Организация  = СсылкаНаДокумент.Организация;
		НоваяЗапись.Документ     = СсылкаНаДокумент;
		НоваяЗапись.Пользователь = СтрокаТЗ.Согласующий;
		НоваяЗапись.Статус       = СтатусДокумента;
		НоваяЗапись.НеНапоминать = СтрокаТЗ.НеНапоминать;
		НоваяЗапись.Дата         = СтрокаТЗ.Дата;
		
	КонецЦикла;
	
	НаборЗаписейСогласования.Записать();
	
КонецПроцедуры

// Функция возвращает массив ссылок документов, находящихся в статусе, по которому не запрещен отбор,
// либо не указан способ согласования (для случая, когда на момент включения системы 
// согласования уже были введены некоторые документы), 
// либо система согласования для данного вида документов не используется.
//
// Параметры:
//  ТипДокумента - Строка - Название документа из конфигуратора.
//
// Возвращаемое значение:
//  Массив - массив ссылок на документы.
Функция ПолучитьСписокДоступныхДокументов(ТипДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
				   
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	торо_ТекущиеСтатусыДокументов.Документ КАК Ссылка,
	|	торо_ТекущиеСтатусыДокументов.СтатусДокумента,
	|	ВЫРАЗИТЬ(торо_ТекущиеСтатусыДокументов.Документ КАК Документ."	+ ТипДокумента + ").СпособСогласования КАК СпособСогласования
	|ИЗ
	|	РегистрСведений.торо_ТекущиеСтатусыДокументов КАК торо_ТекущиеСтатусыДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.торо_МатрицаПереходаСтатусовДокументов КАК торо_МатрицаПереходаСтатусовДокументов
	|		ПО торо_ТекущиеСтатусыДокументов.СтатусДокумента = торо_МатрицаПереходаСтатусовДокументов.ТекущийСтатус
	|			И (ВЫРАЗИТЬ(торо_ТекущиеСтатусыДокументов.Документ КАК Документ."	+ ТипДокумента + ").СпособСогласования = торо_МатрицаПереходаСтатусовДокументов.СпособСогласования)
	|ГДЕ
	|	торо_ТекущиеСтатусыДокументов.Документ ССЫЛКА Документ."	+ ТипДокумента + "
	|	И торо_МатрицаПереходаСтатусовДокументов.НеИспользоватьВПодборах";

	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции	

// Функция проверяет, используется ли система согласования для документов данного типа.
//
// Параметры:
//  ИмяТипа - ПеречислениеСсылка.торо_ВидыДокументовСогласованияРемонтов - тип документа.
//  Регламентный - Булево - это документ регламентного мероприятия.
// Возвращаемое значение:
//  Булево - для документа включено согласование.
Функция ПроверитьИспользованиеСогласованияДокументов(Знач ИмяТипа = "", Регламентный = Ложь) Экспорт
	
	ФОИспользоватьСогласование = ПолучитьФункциональнуюОпцию("торо_ИспользоватьСогласование");
	КонстантаРемонты = Константы.торо_ИспользоватьСогласованиеДокументовРемонтов.Получить();
	КонстантаМероприятия = Константы.торо_ИспользоватьСогласованиеДокументовМероприятий.Получить();
	Если ИмяТипа = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_ОстановочныеРемонты 
			или ИмяТипа = Перечисления.торо_ВидыДокументовСогласованияРемонтов.торо_АктПриемкиОборудования
			Тогда
		докСогласованиеИспользуется = Ложь;
	Иначе		
		докСогласованиеИспользуется = Константы.ИспользоватьИнтеграциюС1СДокументооборот.Получить() И Константы.ИспользоватьПроцессыИЗадачи1СДокументооборота.Получить();
	КонецЕсли;
	
	Если НЕ ФОИспользоватьСогласование ИЛИ (НЕ КонстантаРемонты И НЕ КонстантаМероприятия) Тогда
		Возврат Ложь;
	ИначеЕсли ИмяТипа = "" Тогда
		Возврат НЕ докСогласованиеИспользуется;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		
		"ВЫБРАТЬ
		|	торо_ВидыДокументовСогласования.ВидДокумента КАК ВидДокумента
		|ИЗ
		|	РегистрСведений.торо_ВидыДокументовСогласования КАК торо_ВидыДокументовСогласования
		|ГДЕ
		|	торо_ВидыДокументовСогласования.ВидДокумента = &ВидДокумента";
		
		// В случае формирования уведомлений передается строка с именем документа. На всякий случай возьмем в попытку.
		Попытка
			ИмяТипа = ?(ТипЗнч(ИмяТипа) = Тип("Строка"),?(Регламентный, Вычислить("Перечисления.торо_ВидыДокументовСогласованияМероприятий." + ИмяТипа),Вычислить("Перечисления.торо_ВидыДокументовСогласованияРемонтов." + ИмяТипа)),ИмяТипа);
		Исключение
			// Значит документ с таким именем не участвует в согласованиях и можем спокойно возвращать ложь.
			Возврат Ложь;
		КонецПопытки;
		Запрос.УстановитьПараметр("ВидДокумента", ИмяТипа);
		
		Результат = запрос.Выполнить();
		// согласование по документу используется
		Если Не Результат.Пустой() Тогда
			Возврат ?(Регламентный,КонстантаМероприятия,КонстантаРемонты) И НЕ докСогласованиеИспользуется;
		// согласование по документу не используется	
		Иначе
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

// Функция возвращает статус согласования документа из регистра торо_ТекущиеСтатусыДокументов.
// Параметры:
//  Документ - ДокументСсылка - документ, для которого получается статус.
// Возвращаемое значение:
//  СправочникСсылка.торо_СтатусыСогласованияДокументовРемонтныхРабот - статус согласования.
Функция ПолучитьТекущийСтатусСогласованияДокумента(Документ) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Документ) Тогда
		Возврат Справочники.торо_СтатусыСогласованияДокументовРемонтныхРабот.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	торо_ТекущиеСтатусыДокументов.Документ,
	|	торо_ТекущиеСтатусыДокументов.СтатусДокумента
	|ИЗ
	|	РегистрСведений.торо_ТекущиеСтатусыДокументов КАК торо_ТекущиеСтатусыДокументов
	|ГДЕ
	|	торо_ТекущиеСтатусыДокументов.Документ = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтатусДокумента;
	КонецЕсли;
	
	Возврат Справочники.торо_СтатусыСогласованияДокументовРемонтныхРабот.ПустаяСсылка();
	
КонецФункции

// Функция возвращает список лиц, уже согласовавших документ на последней итерации.
// Параметры:
//  Документ - ДокументСсылка - документ, для которого получается статус.
// Возвращаемое значение:
//  ТаблицаЗначений - таблица согласующих.
Функция ПолучитьТаблицуСогласующихДокумента(Документ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	торо_ТекущиеСогласующиеДокументов.СтатусДокумента,
	|	торо_ТекущиеСогласующиеДокументов.Согласующий,
	|	торо_ТекущиеСогласующиеДокументов.Замещающий,
	|	торо_ТекущиеСогласующиеДокументов.Согласовано
	|ИЗ
	|	РегистрСведений.торо_ТекущиеСогласующиеДокументов КАК торо_ТекущиеСогласующиеДокументов
	|ГДЕ
	|	торо_ТекущиеСогласующиеДокументов.Документ = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаРезультат;
	
КонецФункции

// Возвращает ключ записи регистра сведений торо_ИсторияСтатусовДокументов по структуре ключевых полей.
//
// Параметры:
//		СтруктураКлюча - Структура - Структура с полями, соответствующмими измерениям регистра.
// Возвращаемое значение:
//		РегистрСведенийКлючЗаписи.торо_ИсторияСтатусовДокументов - ключ записи. 
Функция ПолучитьКлючЗаписиИсторииСтатусовДокументов(СтруктураКлюча) Экспорт
	
	Возврат РегистрыСведений.торо_ИсторияСтатусовДокументов.СоздатьКлючЗаписи(СтруктураКлюча);
		
КонецФункции

// Возвращает комментарий к статусу согласования из записи регистра сведений торо_ИсторияСтатусовДокументов,
// определяемой по значениям измерений, переданных в параметре.
//
// Параметры:
//		СтруктураКлюча - Структура - Структура с полями, соответствующмими измерениям регистра.
// Возвращаемое значение:
//		Строка - текст комментария к статусу согласования. 
Функция ПолучитьКомментарийКСтатусуСогласования(СтруктураКлюча) Экспорт
	
	Запись = РегистрыСведений.торо_ИсторияСтатусовДокументов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, СтруктураКлюча);
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Возврат Запись.Комментарий;
	КонецЕсли;
	
КонецФункции

#КонецОбласти