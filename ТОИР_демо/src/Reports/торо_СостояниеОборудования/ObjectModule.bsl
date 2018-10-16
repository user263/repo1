Перем ТекущиеНастройкиОтчета;

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере 						= Истина;
	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек         = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора               = Истина;
КонецПроцедуры

Процедура ПодготовитьСписокПоказателей(ОР,СписокНаработка,СписокПоказателей)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	торо_ПараметрыНаработкиОбъектовРемонта.Показатель КАК Показатель
	|ИЗ
	|	РегистрСведений.торо_ПараметрыНаработкиОбъектовРемонта КАК торо_ПараметрыНаработкиОбъектовРемонта
	|ГДЕ
	|	торо_ПараметрыНаработкиОбъектовРемонта.ОбъектРемонта = &ОбъектРемонта";
		
	Запрос.УстановитьПараметр("ОбъектРемонта", ОР);	
	РезультатЗапроса = Запрос.Выполнить();		
	Выборка = РезультатЗапроса.Выбрать();	
	Пока Выборка.Следующий() Цикл
		СписокНаработка.Добавить(Выборка.Показатель);	
	КонецЦикла; 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзмеряемыеПоказателиОР.Показатель КАК Показатель
	|ИЗ
	|	РегистрСведений.торо_ИзмеряемыеПоказателиОбъектовРемонта КАК ИзмеряемыеПоказателиОР
	|ГДЕ
	|	ИзмеряемыеПоказателиОР.ОбъектРемонта = &ОбъектРемонта
	|	ИЛИ ИзмеряемыеПоказателиОР.ОбъектРемонта = &ТиповойОР";
		
	Запрос.УстановитьПараметр("ОбъектРемонта", ОР);
	Запрос.УстановитьПараметр("ТиповойОР", ОР.ТиповойОР);
	РезультатЗапроса = Запрос.Выполнить();		
	Выборка = РезультатЗапроса.Выбрать();	
	Пока Выборка.Следующий() Цикл
		СписокПоказателей.Добавить(Выборка.Показатель);	
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПользовательскиеНастройкиЭлементы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	НастройкиСтруктура = КомпоновщикНастроек.Настройки.Структура;
	ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы, НастройкиСтруктура, Форма);
		
КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПользовательскиеНастройкиЭлементы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	НастройкиСтруктура = КомпоновщикНастроек.Настройки.Структура;
	ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы, НастройкиСтруктура, Форма);
	
КонецПроцедуры

Процедура ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы, НастройкиСтруктура, Форма)
	
	ПараметрыВыполнения = Форма.Параметры;
	
	Если ПараметрыВыполнения.Свойство("ОбъектРемонта") Тогда
		СписокНаработка = Новый СписокЗначений;
		СписокПоказателей = Новый СписокЗначений;
		ПодготовитьСписокПоказателей(ПараметрыВыполнения.ОбъектРемонта,СписокНаработка,СписокПоказателей);
	КонецЕсли;

	ПоказателиФО = ПолучитьФункциональнуюОпцию("торо_УчетКонтролируемыхПоказателей");
	НаработкаФО = ПолучитьФункциональнуюОпцию("торо_УчетНаработкиОборудования");
	
	Для каждого Элемент Из ПользовательскиеНастройкиЭлементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(Элемент.Параметр) = "ОбъектРемонта" И ПоказателиФО Тогда
				Если ПараметрыВыполнения.Свойство("ОбъектРемонта") Тогда
					Элемент.Значение      = ПараметрыВыполнения.ОбъектРемонта;
					Элемент.Использование = Истина;			
					Продолжить;
				КонецЕсли;
			ИначеЕсли Строка(Элемент.Параметр) = "КонтролируемыеПоказатели" И ПоказателиФО Тогда
				Если СписокПоказателей <> Неопределено И ПараметрыВыполнения.Свойство("ТекПоказатель") Тогда
					
					Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("КонтролируемыеПоказатели"));
					Параметр.ДоступныеЗначения.ЗагрузитьЗначения(СписокПоказателей.ВыгрузитьЗначения());
					
					ТекПоказатель = Новый СписокЗначений;
					ТекПоказатель.Добавить(ПараметрыВыполнения.ТекПоказатель);
					
					Элемент.Значение = ТекПоказатель;
					Элемент.Использование = Истина;
					
					Продолжить;
					
				Иначе
					Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("КонтролируемыеПоказатели"));
					Элемент.Использование = Истина; 
				КонецЕсли;
			ИначеЕсли Строка(Элемент.Параметр) = "ПоказательНаработки" И НаработкаФО Тогда
				Если СписокНаработка <> Неопределено Тогда
					Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("ПоказательНаработки"));
					Параметр.ДоступныеЗначения.Очистить();
					Параметр.ДоступныеЗначения.ЗагрузитьЗначения(СписокНаработка.ВыгрузитьЗначения());
					Элемент.Значение = Справочники.ПараметрыВыработкиОС.ПустаяСсылка();
					Элемент.Использование = Истина;
					Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто;
					Продолжить;
				Иначе
					Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(Новый ПараметрКомпоновкиДанных("ПоказательНаработки"));
					Параметр.ДоступныеЗначения.Очистить();	
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	
	Если Не НаработкаФО Тогда
		Для каждого Элемент Из ПользовательскиеНастройкиЭлементы Цикл
			Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				Если Строка(Элемент.Параметр) = "ПоказательНаработки"
					ИЛИ Строка(Элемент.Параметр) = "СредняяНаработка" Тогда 			
					Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
					Элемент.Использование = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Для Каждого Элемент Из НастройкиСтруктура Цикл
			Для Каждого ВыбранноеПоле Из Элемент.Выбор.Элементы Цикл
				Если ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗначениеПараметраНаработки") Тогда
					НастройкиСтруктура.Удалить(Элемент);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ПоказателиФО Тогда
		Для каждого Элемент Из ПользовательскиеНастройкиЭлементы Цикл
			Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				Если Строка(Элемент.Параметр) = "КонтролируемыеПоказатели" Тогда 			
					Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
					Элемент.Использование = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры


Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
	ПоказателиФО = ПолучитьФункциональнуюОпцию("торо_УчетКонтролируемыхПоказателей");
	НаработкаФО = ПолучитьФункциональнуюОпцию("торо_УчетНаработкиОборудования");
	
	ИДНастройки_ПериодОтчета = Неопределено;
	
	Попытка
		ПользовательскиеНастройкиЭлементы = Форма.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	Исключение
		ПользовательскиеНастройкиЭлементы = Форма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	КонецПопытки;
	
	Для каждого Элемент из ПользовательскиеНастройкиЭлементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(Элемент.Параметр) = "ПериодВыполнени" Тогда
				ИДНастройки_ПериодОтчета = СтрЗаменить(Элемент.ИдентификаторПользовательскойНастройки, "-", "");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	Для каждого Элем Из Форма.Элементы Цикл 		
		Если ЗначениеЗаполнено(ИДНастройки_ПериодОтчета) 
			И Найти(Элем.Имя, ИДНастройки_ПериодОтчета) > 0 Тогда
			Если ТипЗнч(Элем) = Тип("ГруппаФормы") 
				ИЛИ (ТипЗнч(Элем) = Тип("ПолеФормы") И Элем.Вид = ВидПоляФормы.ПолеВвода) Тогда
				Элем.РастягиватьПоГоризонтали = Истина;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры 

Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
	Если Строка(СвойстваНастройки.ДоступнаяНастройкаКД.Параметр) = "КонтролируемыеПоказатели" Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "ВЫБРАТЬ
		|	ИзмеряемыеПоказателиОР.Показатель КАК Показатель
		|ИЗ
		|	РегистрСведений.торо_ИзмеряемыеПоказателиОбъектовРемонта КАК ИзмеряемыеПоказателиОР
		|ГДЕ
		|	ИзмеряемыеПоказателиОР.ОбъектРемонта = &ОбъектРемонта
		|	ИЛИ ИзмеряемыеПоказателиОР.ОбъектРемонта = &ТиповойОР";
		
		ЭлементыНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
		
		Для каждого ЭлементНастройки Из ЭлементыНастроек Цикл
			 Если Строка(ЭлементНастройки.Параметр) = "ОбъектРемонта" Тогда
			 	ОР = ЭлементНастройки.Значение;
				Если ТипЗнч(ОР) = Тип("СписокЗначений") Тогда
					ОР = ОР[0].Значение;
				КонецЕсли;
				Прервать;
			 КонецЕсли; 
		КонецЦикла; 
		
		Если Не ОР = Неопределено Тогда
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "ВЫБРАТЬ
			|	ИзмеряемыеПоказателиОР.Показатель КАК Показатель
			|ИЗ
			|	РегистрСведений.торо_ИзмеряемыеПоказателиОбъектовРемонта КАК ИзмеряемыеПоказателиОР
			|ГДЕ
			|	ИзмеряемыеПоказателиОР.ОбъектРемонта = &ОбъектРемонта
			|	ИЛИ ИзмеряемыеПоказателиОР.ОбъектРемонта = &ТиповойОР";
			СвойстваНастройки.ЗапросЗначенийВыбора.Параметры.Вставить("ОбъектРемонта", ОР);
			СвойстваНастройки.ЗапросЗначенийВыбора.Параметры.Вставить("ТиповойОР", ОР.ТиповойОР);		
		Иначе
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "ВЫБРАТЬ
			|	ИзмеряемыеПоказателиОР.Показатель КАК Показатель
			|ИЗ
			|	РегистрСведений.торо_ИзмеряемыеПоказателиОбъектовРемонта КАК ИзмеряемыеПоказателиОР";
		КонецЕсли; 
		
	КонецЕсли;
	
	Если Строка(СвойстваНастройки.ДоступнаяНастройкаКД.Параметр) = "ПоказательНаработки" Тогда
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "ВЫБРАТЬ
		|	торо_ПараметрыНаработкиОбъектовРемонта.Показатель КАК Показатель
		|ИЗ
		|	РегистрСведений.торо_ПараметрыНаработкиОбъектовРемонта КАК торо_ПараметрыНаработкиОбъектовРемонта
		|ГДЕ
		|	торо_ПараметрыНаработкиОбъектовРемонта.ОбъектРемонта = &ОбъектРемонта";
		
		ЭлементыНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
		
		Для каждого ЭлементНастройки Из ЭлементыНастроек Цикл
			Если Строка(ЭлементНастройки.Параметр) = "ОбъектРемонта" Тогда
				ОР = ЭлементНастройки.Значение;
				Если ТипЗнч(ОР) = Тип("СписокЗначений") Тогда
					ОР = ОР[0].Значение;
				КонецЕсли;
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
		
		Если Не ОР = Неопределено Тогда
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "ВЫБРАТЬ
			|	торо_ПараметрыНаработкиОбъектовРемонта.Показатель КАК Показатель
			|ИЗ
			|	РегистрСведений.торо_ПараметрыНаработкиОбъектовРемонта КАК торо_ПараметрыНаработкиОбъектовРемонта
			|ГДЕ
			|	торо_ПараметрыНаработкиОбъектовРемонта.ОбъектРемонта = &ОбъектРемонта";
			СвойстваНастройки.ЗапросЗначенийВыбора.Параметры.Вставить("ОбъектРемонта", ОР);
		Иначе
			СвойстваНастройки.ЗапросЗначенийВыбора.Текст = "ВЫБРАТЬ
			|	торо_ПараметрыНаработкиОбъектовРемонта.Показатель КАК Показатель
			|ИЗ
			|	РегистрСведений.торо_ПараметрыНаработкиОбъектовРемонта КАК торо_ПараметрыНаработкиОбъектовРемонта";
		КонецЕсли; 
		
	КонецЕсли; 	

КонецПроцедуры
 

#КонецОбласти

#КонецЕсли
