#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции
#Область Печать

// Заполняет список команд печати.
//
// Параметры:
// КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Учет контролируемых показателей
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.торо_УчетКонтролируемыхПоказателей";
	КомандаПечати.Идентификатор = "УчетКонтролируемыхПоказателей";
	КомандаПечати.Представление = НСтр("ru = 'Учет контролируемых показателей'");
	КомандаПечати.СразуНаПринтер = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
	"НастройкиТОиР",
	"ПечатьДокументовБезПредварительногоПросмотра",
	Ложь);
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УчетКонтролируемыхПоказателей") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"УчетКонтролируемыхПоказателей", 
		"Учет контролируемых показателей", 
		ПечатьКонтролируемыхПоказателей(МассивОбъектов, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКонтролируемыхПоказателей(МассивОбъектов, ПараметрыПечати)

	ТабДок = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("УчетКонтролируемыхПоказателей");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	СтрокаТаблициОР = Макет.ПолучитьОбласть("СтрокаТаблициОР");
	СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	Подвал = Макет.ПолучитьОбласть("Подвал");
	
	Шапка.Параметры.Номер 	                 = МассивОбъектов[0].Номер;
	Шапка.Параметры.Дата 		             = МассивОбъектов[0].Дата;
	Шапка.Параметры.Организация 		     = МассивОбъектов[0].Организация;
	Шапка.Параметры.Подразделение            = МассивОбъектов[0].Подразделение;
	
	ТабДок.Вывести(Шапка);
	
	Ном = 1;
	СтароеЗначение  = Справочники.торо_ОбъектыРемонта.ПустаяСсылка();
	Для Каждого Строка Из МассивОбъектов[0].Показатели Цикл
		Если Строка.ОбъектРемонта <> СтароеЗначение тогда		
			СтрокаТаблициОР.Параметры.Н = Ном;
			СтрокаТаблициОР.Параметры.Заполнить(Строка);
			СтрокаТаблициОР.Параметры.ОбъектРемонта = торо_ЗаполнениеДокументов.ПолучитьПредоставленияОРДляПечати(Строка.ОбъектРемонта);
			ТабДок.Вывести(СтрокаТаблициОР);
			СтароеЗначение = Строка.ОбъектРемонта;
			Ном = Ном + 1;
		КонецЕсли;
		СтрокаТаблицы.Параметры.ЕдиницаИзмерения = Строка.Показатель.ЕдиницаИзмерения;	
		СтрокаТаблицы.Параметры.Заполнить(Строка);
		ТабДок.Вывести(СтрокаТаблицы);
		
	КонецЦикла;
	
	Подвал.Параметры.Ответственный 		= МассивОбъектов[0].Ответственный;
	Подвал.Параметры.Комментарий 		= МассивОбъектов[0].Комментарий;
	
	ТабДок.Вывести(Подвал);
	
	ТабДок.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб         = Истина;
	ТабДок.ТолькоПросмотр      = Истина;
	ТабДок.ОтображатьСетку     = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	ТабДок.ТолькоПросмотр = Истина;
	Возврат ТабДок;
	
КонецФункции // ПечатьКонтролируемыхПоказателей()

#КонецОбласти

Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
	
КонецПроцедуры

Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
	
	Реквизиты.Добавить("ИзМобильного");
		
КонецПроцедуры


#КонецОбласти

#КонецЕсли