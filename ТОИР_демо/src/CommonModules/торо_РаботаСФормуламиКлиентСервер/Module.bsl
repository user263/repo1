
#Область ПрограммныйИнтерфейс

// Получает текст операнда для вставки в формулу.
//
// Параметры:
//  Операнд - Строка - имя операнда.
//
// Возвращаемое значение:
//  Строка - текст операнда.
//
Функция ПолучитьТекстОперандаДляВставки(Операнд) Экспорт
	
	Возврат "[" + Операнд + "]";
	
КонецФункции // ПолучитьТекстОперандаДляВставки()

// Осуществляет проверку корректности формулы.
//
// Параметры:
//  Формула                  - Строка - текст формулы
//  Операнды                - Массив - операнды формулы
//  Поле                    - Строка - имя поля, к которому необходимо привязать сообщение
//  СообщениеОбОшибке       - Строка - текст сообщения об ошибке
//  СтроковаяФормула        - Булево - признак строковой формулы
//  ПутьКДанным             - Строка - путь к данным, для выдачи сообщения об ошибке
//  ДополнительныеПараметры - Структура - поддерживаемые параметры:
//         * НеВыводитьСообщения - Булево - признак того что не нужно выводить сообщения пользователю, по умолчанию выводятся
//         * ТипРезультата       - ОписаниеТипов - возможные типы, возвращаемые формулой.
//
// Возвращаемое значение:
//  Булево - Ложь, если есть ошибки, иначе Истина.
//
Функция ПроверитьФормулу(Формула, Операнды, Знач Поле = "", Знач СообщениеОбОшибке = "", СтроковаяФормула = Ложь,
		ПутьКДанным = "", ДополнительныеПараметры = Неопределено) Экспорт
		
	Перем ТипРезультата;
		
	Результат = Истина;
	
	ВыводитьСообщения = Истина;
	Если ДополнительныеПараметры <> Неопределено 
		И ДополнительныеПараметры.Свойство("НеВыводитьСообщения") 
		И ДополнительныеПараметры.НеВыводитьСообщения Тогда
		ВыводитьСообщения = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Формула) Тогда
		
		Если СтроковаяФормула Тогда
			ТекстРасчета = """Строка"" + " + Формула;
			ЗначениеЗамены = """1""";
		Иначе
			ТипРезультата = Неопределено;
			Если ДополнительныеПараметры <> Неопределено Тогда
				ДополнительныеПараметры.Свойство("ТипРезультата", ТипРезультата);
			КонецЕсли;
			Если ТипРезультата = Новый ОписаниеТипов("Дата") Тогда
				ЗначениеЗамены = ТекущаяДата();
			Иначе
				ЗначениеЗамены = 1;
			КонецЕсли;
			ТекстРасчета = Формула;
		КонецЕсли;
		
		Для Каждого Операнд Из Операнды Цикл
			ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(Операнд), ЗначениеЗамены);
		КонецЦикла;
		
		Попытка
			
			РезультатРасчета = Вычислить(ТекстРасчета);
			
			Если СтроковаяФормула Тогда
				ТекстПроверки = СтрЗаменить(Формула, Символы.ПС, "");
				ТекстПроверки = СтрЗаменить(ТекстПроверки, " ", "");
				ОтсутствиеРазделителей = Найти(ТекстПроверки, "][")
					+ Найти(ТекстПроверки, """[")
					+ Найти(ТекстПроверки, "]""");
				Если ОтсутствиеРазделителей > 0 Тогда
					Если ВыводитьСообщения Тогда
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						НСтр("ru='В формуле обнаружены ошибки. Между операндами должен присутствовать оператор или разделитель'"),
						,
						Поле,
						ПутьКДанным,);
					КонецЕсли;
					Результат = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("ТипРезультата") Тогда
				
				ТипРезультатаРасчетаПравильный = Ложь;
				
				Для Каждого ДопустимыйТип Из ДополнительныеПараметры.ТипРезультата.Типы() Цикл
					Если ТипЗнч(РезультатРасчета) = ДопустимыйТип Тогда
						ТипРезультатаРасчетаПравильный = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ТипРезультатаРасчетаПравильный Тогда
					Если ВыводитьСообщения Тогда
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтрШаблон(НСтр("ru='В формуле обнаружены ошибки. Результат расчета должен быть типа %1'"), ДополнительныеПараметры.ТипРезультата),
						,
						Поле,
						ПутьКДанным,);
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
		
		Исключение
			
			Результат = Ложь;
			
			Если ВыводитьСообщения Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				?(ЗначениеЗаполнено(СообщениеОбОшибке) ,СообщениеОбОшибке, НСтр("ru='В формуле обнаружены ошибки. Проверьте формулу. Формулы должны составляться по правилам написания выражений на встроенном языке 1С:Предприятия.'")),
				,
				Поле,
				ПутьКДанным,);
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Извлекает операнды из текстовой формулы.
//
// Параметры:
//  Формула - Строка - текст формулы.
//
// Возвращаемое значение:
//  Массив - Операнды из текстовой формулы.
//
Функция ПолучитьМассивОперандовТекстовойФормулы(Формула) Экспорт
	
	МассивОперандов = Новый Массив();
	
	ТекстФормулы = СокрЛП(Формула);
	Если СтрЧислоВхождений(ТекстФормулы, "[") <> СтрЧислоВхождений(ТекстФормулы, "]") Тогда
		ЕстьОперанды = Ложь;
	Иначе
		ЕстьОперанды = Истина;
	КонецЕсли;
	
	Пока ЕстьОперанды = Истина Цикл
		НачалоОперанда = СтрНайти(ТекстФормулы, "[");
		КонецОперанда = СтрНайти(ТекстФормулы, "]");
		
		Если НачалоОперанда = 0
			Или КонецОперанда = 0
			Или НачалоОперанда > КонецОперанда Тогда
			ЕстьОперанды = Ложь;
			Прервать;
			
		КонецЕсли;
		
		ИмяОперанда = Сред(ТекстФормулы, НачалоОперанда + 1, КонецОперанда - НачалоОперанда - 1);
		МассивОперандов.Добавить(ИмяОперанда);
		ТекстФормулы = СтрЗаменить(ТекстФормулы, "[" + ИмяОперанда + "]", "");
		КонецПрошлогоОперанда = КонецОперанда;
		
	КонецЦикла;
	
	Возврат МассивОперандов
	
КонецФункции // ПолучитьМассивОперандовТекстовойФормулы()

// Получает массив доступных операндов из дерева
//
// Параметры:
//  ДеревоОперандов  - ДанныеФормыКоллекция - Дерево, в котором два уровня, операнд получается посредством склеивания
//                 идентификаторов строк верхнего и нижнего уровня.
//
// Возвращаемое значение:
//   Массив - Массив достуных операндов.
//
Функция МассивОперандовДляДерева(ДеревоОперандов) Экспорт

	МассивОперандов = Новый Массив();
	
	Для Каждого СтрокаВерхнегоУровня Из ДеревоОперандов.ПолучитьЭлементы() Цикл
		
		Для Каждого СтрокаВторогоУровня Из СтрокаВерхнегоУровня.ПолучитьЭлементы() Цикл
			
			МассивОперандов.Добавить(СтрокаВерхнегоУровня.Показатель +"." + СтрокаВторогоУровня.Ресурс);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат МассивОперандов;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
