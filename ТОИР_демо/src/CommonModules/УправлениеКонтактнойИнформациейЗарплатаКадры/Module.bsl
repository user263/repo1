
#Область СлужебныйПрограммныйИнтерфейс

// Обработчик для события формы ПриСозданииНаСервере, вызывает соответствующий метод подсистемы
// УправлениеКонтактнойИнформации. Дополняет элементы отображения полей ввода адресов, полями
// отображающими результаты проверки адресов на корректность.
//
// Параметры:
//    Форма                - УправляемаяФорма - Форма объекта-владельца, предназначенная для вывода контактной 
//                           информации.
//    Объект               - Объект-владелец контактной информации.
//    ПоложениеЗаголовкаКИ - Может принимать значения ПоложениеЗаголовкаЭлементаФормы.Лево 
//                           или ПоложениеЗаголовкаЭлементаФормы.Верх (по умолчанию).
//
Процедура ПриСозданииНаСервере(Форма, Объект, ИмяЭлементаДляРазмещения, ПоложениеЗаголовкаКИ = "") Экспорт
	
	Если ПоложениеЗаголовкаКИ <> ПоложениеЗаголовкаЭлементаФормы.Верх
		И ПоложениеЗаголовкаКИ <> ПоложениеЗаголовкаЭлементаФормы.Лево Тогда
		
		ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
	КонецЕсли; 
	
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(Форма, Объект, ИмяЭлементаДляРазмещения, ПоложениеЗаголовкаКИ);
	
	ДополнитьФормуПолямиОтображенияПроверкиАдресов(Форма);
	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(Форма);
	
КонецПроцедуры

// Добавляет (удаляет) поле ввода или комментарий на форму.
//
Процедура ОбновитьКонтактнуюИнформацию(Форма, Объект, Результат, ЗависимостиВидовАдресов = Неопределено) Экспорт
	
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(Форма, Объект, Результат);
	
	Если Результат <> Неопределено И Результат.Свойство("ДобавляемыйВид") Тогда
		ДополнитьФормуПолямиОтображенияПроверкиАдресов(Форма);
	КонецЕсли;
	
	ЗаполнитьЗависимыеАдреса(Форма, Результат, ЗависимостиВидовАдресов);
	
	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Дополняет форму, содержащую контактную информацию предупреждающими
// надписями для полей содержащих адрес.
//
Процедура ДополнитьФормуПолямиОтображенияПроверкиАдресов(Форма)

	КоллекцияПолейКонтактнойИнформации = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	Если КоллекцияПолейКонтактнойИнформации <> Неопределено Тогда
		
		РоссийскиеАдреса = ЗарплатаКадрыПовтИсп.ВидыРоссийскихАдресов();
		
		Для Каждого КонтактнаяИнформация Из КоллекцияПолейКонтактнойИнформации Цикл
			
			Элемент = Форма.Элементы.Найти(КонтактнаяИнформация.ИмяРеквизита);
			Если Элемент <> Неопределено Тогда
				
				// Для полей контактной информации, содержащих телефонные номера ограничивается ширина.
				Если КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон
					ИЛИ КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Факс
					ИЛИ КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				
					Элемент.РастягиватьПоГоризонтали = Ложь;
					Элемент.Ширина = 20;
					
				// Поля, содержащие адрес дополняются, полями отображающими результаты проверки адресов.
				ИначеЕсли КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
					
					Если КонтактнаяИнформация.Вид = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица Тогда
						
						ИмяГруппыАдресаПоПрописке = "ГруппаАдресПоПрописке" + Элемент.Имя;
						ГруппаАдресаПоПрописке = Форма.Элементы.Найти(ИмяГруппыАдресаПоПрописке);
						Если ГруппаАдресаПоПрописке = Неопределено Тогда
							
							ГруппаАдресаПоПрописке = Форма.Элементы.Добавить(ИмяГруппыАдресаПоПрописке, Тип("ГруппаФормы"));
							ГруппаАдресаПоПрописке.Вид = ВидГруппыФормы.ОбычнаяГруппа;
							ГруппаАдресаПоПрописке.ОтображатьЗаголовок = Ложь;
							ГруппаАдресаПоПрописке.Отображение = ОтображениеОбычнойГруппы.Нет;
							ГруппаАдресаПоПрописке.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
							
							Форма.Элементы.Переместить(ГруппаАдресаПоПрописке, Элемент.Родитель, Элемент);
							Форма.Элементы.Переместить(Элемент, ГруппаАдресаПоПрописке);
							
							ЭлементДатаРегистрации = Форма.Элементы.Добавить("ДатаРегистрации" + Элемент.Имя, Тип("ПолеФормы"), ГруппаАдресаПоПрописке);
							ЭлементДатаРегистрации.Вид = ВидПоляФормы.ПолеВвода;
							ЭлементДатаРегистрации.ПутьКДанным = "ФизическоеЛицо.ДатаРегистрации";
							ЭлементДатаРегистрации.РастягиватьПоГоризонтали = Ложь;
							
							Если Врег(Форма.ПараметрыКонтактнойИнформации.ГруппаКонтактнаяИнформация.ПоложениеЗаголовка) = Врег("Верх") Тогда
								ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Верх;
							Иначе
								ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Лево;
							КонецЕсли;
							
							ЭлементДатаРегистрации.ПоложениеЗаголовка = ПоложениеЗаголовкаКИ;
							ЭлементДатаРегистрации.УстановитьДействие("ПриИзменении", "Подключаемый_ФизлицоДатаРегистрацииПриИзменении");
							
						КонецЕсли; 
						
					КонецЕсли; 
					
					Если РоссийскиеАдреса.Получить(КонтактнаяИнформация.Вид) = Истина Тогда
						Элемент.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
					КонецЕсли; 
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;

КонецПроцедуры

// Обновляет предупреждающие надписи к элементу, содержащему адрес.
//
Процедура ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(Форма) Экспорт

	АдресныйКлассификаторЗагружен = Неопределено;
	ПроверенныеАдреса = Новый Соответствие;
	КоллекцияПолейКонтактнойИнформации = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	
	Если КоллекцияПолейКонтактнойИнформации <> Неопределено Тогда
		
		РоссийскиеАдреса = ЗарплатаКадрыПовтИсп.ВидыРоссийскихАдресов();
		Для Каждого КонтактнаяИнформация Из КоллекцияПолейКонтактнойИнформации Цикл
			
			Если КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес
				И РоссийскиеАдреса.Получить(КонтактнаяИнформация.Вид) = Истина Тогда
				
				Если АдресныйКлассификаторЗагружен = Неопределено Тогда
					АдресныйКлассификаторЗагружен = АдресныйКлассификатор.КлассификаторЗагружен();
				КонецЕсли; 
				
				Элемент = Форма.Элементы.Найти(КонтактнаяИнформация.ИмяРеквизита);
				Если Элемент <> Неопределено Тогда
					
					УстановитьОтображениеПоляАдреса(
						Форма[Элемент.Имя],
						КонтактнаяИнформация.ЗначенияПолей,
						Элемент,
						Форма,
						КонтактнаяИнформация.Вид,
						АдресныйКлассификаторЗагружен,
						ПроверенныеАдреса
					);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

// Осуществляет проверку заполненного элемента содержащего адрес и выводит
// предупреждающие надписи.
//
Процедура УстановитьОтображениеПоляАдреса(Адрес, СписокПолей, Элемент, Форма, ВидАдреса, АдресныйКлассификаторЗагружен = Неопределено, ПроверенныеАдреса = Неопределено) Экспорт
	
	СообщенияПроверки = "";
	ЦветТекстаПоля = ЦветаСтиля.ЦветТекстаПоля;
	
	Если ТипЗнч(ПроверенныеАдреса) = Тип("Соответствие") Тогда
		НастройкиОтображенияАдреса = ПроверенныеАдреса.Получить(Адрес);
	Иначе
		НастройкиОтображенияАдреса = Неопределено;
	КонецЕсли;
	
	Если НастройкиОтображенияАдреса = Неопределено Тогда
		
		Если Не ПустаяСтрока(Адрес) Тогда
		
			Если АдресныйКлассификаторЗагружен = Неопределено Тогда
				АдресныйКлассификаторЗагружен = АдресныйКлассификатор.КлассификаторЗагружен();
			КонецЕсли;
			
			Если Не АдресныйКлассификаторЗагружен Тогда

				СообщенияПроверки = НСтр("ru = 'Адресный классификатор не загружен'");
				РезультатПроверки = Неопределено;

			Иначе
				
				РезультатПроверки = ЗарплатаКадрыВызовСервера.ПроверитьАдрес(СписокПолей, ВидАдреса);
				Если РезультатПроверки.Результат <> "Корректный" Тогда
					
					Для каждого ЭлементОписанияОшибки Из РезультатПроверки.СписокОшибок Цикл
						СообщенияПроверки = СообщенияПроверки + ЭлементОписанияОшибки.Представление + Символы.ПС;
					КонецЦикла;
					СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СообщенияПроверки, 1);
					
					СообщенияПроверки = НСтр("ru = 'Адрес не соответствует адресному классификатору
						|'") + СообщенияПроверки;
					
				КонецЕсли;
				
			КонецЕсли;
			
			СообщенияПроверки = ?(ПустаяСтрока(СообщенияПроверки), НСтр("ru = 'Адрес введен правильно - в соответствии с требованиями'"), СообщенияПроверки);
			ЗаголовокОшибкиДополнительный = СтрПолучитьСтроку(СообщенияПроверки, 1);
			СообщенияПроверки = СокрЛП(Сред(СообщенияПроверки, СтрДлина(ЗаголовокОшибкиДополнительный) + 1));
			
			Если РезультатПроверки = Неопределено ИЛИ РезультатПроверки.Результат <> "Корректный" Тогда
				ЦветТекстаПоля = ЦветаСтиля.ПоясняющийОшибкуТекст;
			КонецЕсли; 
			
		КонецЕсли; 
		
	Иначе
		СообщенияПроверки = НастройкиОтображенияАдреса.СообщенияПроверки;
		ЦветТекстаПоля = НастройкиОтображенияАдреса.ЦветТекстаПоля;
	КонецЕсли;
	
	Если ТипЗнч(ПроверенныеАдреса) = Тип("Соответствие") Тогда
		ПроверенныеАдреса.Вставить(Адрес, Новый Структура("СообщенияПроверки,ЦветТекстаПоля", СообщенияПроверки, ЦветТекстаПоля));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		Элемент.Имя,
		"ЦветТекста",
		ЦветТекстаПоля);
	
	//ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
	//	Форма,
	//	Элемент.Имя,
	//	СообщенияПроверки);

КонецПроцедуры

Процедура ЗаполнитьЗависимыеАдреса(Форма, Результат, ЗависимостиВидовАдресов)
	
	Если ЗависимостиВидовАдресов <> Неопределено
		И Результат <> Неопределено И Результат.Свойство("ИмяРеквизита") Тогда
		
		ИмяЭлемента = Результат.ИмяРеквизита;
		
		КоллекцияПолейКонтактнойИнформации = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
		Если КоллекцияПолейКонтактнойИнформации <> Неопределено Тогда
			
			СтруктураПоиска = Новый Структура("ИмяРеквизита", ИмяЭлемента);
			НайденныеСтрокиТекущегоАдреса = КоллекцияПолейКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтрокиТекущегоАдреса.Количество() > 0 Тогда
				
				СтрокаТекущегоАдреса = НайденныеСтрокиТекущегоАдреса[0];
				Если НЕ ПустаяСтрока(СтрокаТекущегоАдреса.ЗначенияПолей) Тогда
					
					КоллекцияЗависимыхВидов = ЗависимостиВидовАдресов.Получить(СтрокаТекущегоАдреса.Вид);
					Если КоллекцияЗависимыхВидов <> Неопределено Тогда
						
						Для каждого ЭлементКонтактнойИнформации Из КоллекцияПолейКонтактнойИнформации Цикл
							
							Для каждого ЗависимыйВид Из КоллекцияЗависимыхВидов Цикл
								Если ЭлементКонтактнойИнформации.Вид = ЗависимыйВид
									И ПустаяСтрока(ЭлементКонтактнойИнформации.ЗначенияПолей) Тогда
									
									ЭлементКонтактнойИнформации.ЗначенияПолей = СтрокаТекущегоАдреса.ЗначенияПолей;
									Форма[ЭлементКонтактнойИнформации.ИмяРеквизита] = Форма[СтрокаТекущегоАдреса.ИмяРеквизита];
										
								КонецЕсли; 
							КонецЦикла;
							
						КонецЦикла;
						
					КонецЕсли; 
					
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
