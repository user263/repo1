
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
	Настройки.События.ПриСозданииНаСервере 								= Истина;
КонецПроцедуры

Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПользовательскиеНастройкиЭлементы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	НастройкиКомпоновщика = КомпоновщикНастроек.Настройки;
	ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы, НастройкиКомпоновщика, Форма);
		
КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПользовательскиеНастройкиЭлементы = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	НастройкиКомпоновщика = КомпоновщикНастроек.Настройки;
	ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы, НастройкиКомпоновщика, Форма);
	
КонецПроцедуры

Процедура ПрименитьФункциональныеОпцииКНастройкам(ПользовательскиеНастройкиЭлементы, НастройкиКомпоновщика, Форма)
	
	// Сделать привязку между выводимыми данными в отчете и ФО в системе:
	// 1. Флаг "По дефектам" - ФО "Учет выявленных дефектов";
	// 2. Флаг "По ППР" - ФО "Использовать ППР";
	// 3. Флаг "По предписаниям" - ФО "Использовать внешние основания для работ";
	// 4. Флаг "По регламентным мероприятиям" - ФО "Использовать регламентные мероприятия";
	// 5. Флаг "Затраты по запчастям" - ФО "Учет запчастей".

	ФО_УчетДефектов = ПолучитьФункциональнуюОпцию("торо_УчетВыявленныхДефектовОборудования");
	ФО_ИспользоватьППР = ПолучитьФункциональнуюОпцию("торо_ИспользоватьППР");
	ФО_ИспользоватьВнешниеОснования = ПолучитьФункциональнуюОпцию("торо_ИспользоватьВнешниеОснованияДляРабот");
	ФО_ИспользоватьРегламентныеМероприятия = ПолучитьФункциональнуюОпцию("торо_ИспользоватьРегламентныеМероприятия");
	ФО_УчетЗапчастей = ПолучитьФункциональнуюОпцию("торо_УчетЗапчастей");
	
	Для каждого Элемент Из ПользовательскиеНастройкиЭлементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(Элемент.Параметр) = "ПоДефектам" И Не ФО_УчетДефектов Тогда
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ИначеЕсли Строка(Элемент.Параметр) = "ПоППР" И Не ФО_ИспользоватьППР Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ИначеЕсли Строка(Элемент.Параметр) = "ПоПредписаниям" И Не ФО_ИспользоватьВнешниеОснования Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ИначеЕсли Строка(Элемент.Параметр) = "ПоРегламентнымМероприятиям" И Не ФО_ИспользоватьРегламентныеМероприятия Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ИначеЕсли Строка(Элемент.Параметр) = "ЗатратыПоЗапчастям" И Не ФО_УчетЗапчастей Тогда 
				Элемент.Значение      = Ложь;
				Элемент.Использование = Ложь;
				Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	ФО_УчетДефектов = ПолучитьФункциональнуюОпцию("торо_УчетВыявленныхДефектовОборудования");
	ФО_ИспользоватьППР = ПолучитьФункциональнуюОпцию("торо_ИспользоватьППР");
	ФО_ИспользоватьВнешниеОснования = ПолучитьФункциональнуюОпцию("торо_ИспользоватьВнешниеОснованияДляРабот");
	ФО_ИспользоватьРегламентныеМероприятия = ПолучитьФункциональнуюОпцию("торо_ИспользоватьРегламентныеМероприятия");
	ФО_УчетЗапчастей = ПолучитьФункциональнуюОпцию("торо_УчетЗапчастей");

	Если ЭтоАдресВременногоХранилища(Форма.НастройкиОтчета.АдресСхемы) Тогда
		СКД = ПолучитьИзВременногоХранилища(Форма.НастройкиОтчета.АдресСхемы);
		
		Параметр = СКД.Параметры.Найти("ПоДефектам");
		Если Параметр <> Неопределено И Не ФО_УчетДефектов Тогда
			Параметр.Значение = Ложь;
			Параметр.ОграничениеИспользования = Истина;
		КонецЕсли;
		
		Параметр = СКД.Параметры.Найти("ПоППР");
		Если Параметр <> Неопределено И Не ФО_ИспользоватьППР Тогда
			Параметр.Значение = Ложь;
			Параметр.ОграничениеИспользования = Истина;
		КонецЕсли;

		Параметр = СКД.Параметры.Найти("ПоПредписаниям");
		Если Параметр <> Неопределено И Не ФО_ИспользоватьВнешниеОснования Тогда
			Параметр.Значение = Ложь;
			Параметр.ОграничениеИспользования = Истина;
		КонецЕсли;

		Параметр = СКД.Параметры.Найти("ПоРегламентнымМероприятиям");
		Если Параметр <> Неопределено И Не ФО_ИспользоватьРегламентныеМероприятия Тогда
			Параметр.Значение = Ложь;
			Параметр.ОграничениеИспользования = Истина;
		КонецЕсли;
		
		Параметр = СКД.Параметры.Найти("ЗатратыПоЗапчастям");
		Если Параметр <> Неопределено И Не ФО_УчетЗапчастей Тогда
			Параметр.Значение = Ложь;
			Параметр.ОграничениеИспользования = Истина;
		КонецЕсли;

		Форма.НастройкиОтчета.АдресСхемы = ПоместитьВоВременноеХранилище(СКД, Форма.НастройкиОтчета.АдресСхемы);
		Форма.НастройкиОтчета.СхемаМодифицирована = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
