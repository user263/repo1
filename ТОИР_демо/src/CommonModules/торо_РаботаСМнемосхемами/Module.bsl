////////////////////////////////////////////////////////////////////////////////
// торо_РаботаСМнемосхемами: методы, для построения графических схем
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Функция создает новую карту
//
// Параметры:
//		ГрафическаяСхема - ГрафическаяСхема - элемент формы графическая схема.
//		Картинка - Картинка - картинка для размещения.
//		СтруктураДопСвойств - Структура - структура дополнительных данных.
//
Процедура мнс_СоздатьНовуюКарту(ГрафическаяСхема,Картинка, СтруктураДопСвойств) Экспорт
	
	Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
	
	Если Обработка = Неопределено Тогда
		Для Инд = 1 По 10 Цикл
			ОбработкаЗащита_Мнемосхемы = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
			Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session(); 
			Если Обработка <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Обработка = Неопределено Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить защищенную обработку, операция не будет выполнена! Проверьте связь с сервером лицензий!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	МассивВремФайл = новый Массив;
	Обработка.СоздатьНовуюКарту(ГрафическаяСхема,Картинка,МассивВремФайл, СтруктураДопСвойств);
	
	ОчиститьВремФайлы(МассивВремФайл);
	
КонецПроцедуры

// Процедура создает первый элемент мнемосхемы.
//
// Параметры:
//		ГрафическаяСхема - ГрафическаяСхема - элемент формы графическая схема.
//		Картинка - Картинка - картинка для размещения.
//		СтруктураДопСвойств - Структура - структура дополнительных данных.
//
Процедура мнс_СоздатьПервыйЭлемент(ГрафическаяСхема,Картинка, СтруктураДопСвойств) Экспорт
	
	Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
	
	Если Обработка = Неопределено Тогда
		Для Инд = 1 По 10 Цикл
			ОбработкаЗащита_Мнемосхемы = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
			Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session(); 
			Если Обработка <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Обработка = Неопределено Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить защищенную обработку, операция не будет выполнена! Проверьте связь с сервером лицензий!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	МассивВремФайл = новый Массив;
	Обработка.СоздатьПервыйЭлемент(ГрафическаяСхема,Картинка,МассивВремФайл, СтруктураДопСвойств);
	
	ОчиститьВремФайлы(МассивВремФайл);
КонецПроцедуры

// Функция создает узел.
//
// Параметры:
//		ТекЭлемент_имя - Строка - имя текущего элемента.
//		ПолеГрафическойСхемы - ГрафическаяСхема - элемент формы графическая схема.
//		Направление - Строка - направление элемента линии ("Вниз", "Вправо").
//		СоединятьЛинией - Булево - нужна ли соединительная линия.
//		ТолщинаСоединительнойЛинии - Число - толщина соединительной линии.
//		Шаг - Число - шаг сетки.
//		Картинка - Картинка - картинка элемента.
//		НомерДобавленногоЭлемента - Число - номер добавленного элемента.
//		ДопДанныеУзла - Структура - структура дополнительных данных.
//
Процедура мнс_СоздатьУзел(ТекЭлемент_имя, ПолеГрафическойСхемы, Направление, СоединятьЛинией,ТолщинаСоединительнойЛинии, Шаг,Картинка,НомерДобавленногоЭлемента, ДопДанныеУзла) Экспорт
	
	Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
	
	Если Обработка = Неопределено Тогда
		Для Инд = 1 По 10 Цикл
			ОбработкаЗащита_Мнемосхемы = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
			Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session(); 
			Если Обработка <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Обработка = Неопределено Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить защищенную обработку, операция не будет выполнена! Проверьте связь с сервером лицензий!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	
	МассивВремФайл = новый Массив;
	
	
	Обработка.СоздатьУзел_ПоИмениТекЭлемента(ТекЭлемент_имя, ПолеГрафическойСхемы, Направление, СоединятьЛинией,ТолщинаСоединительнойЛинии, Шаг,Картинка,НомерДобавленногоЭлемента,МассивВремФайл, ДопДанныеУзла);
	
	ОчиститьВремФайлы(МассивВремФайл);
	
КонецПроцедуры

// Функция создает линию.
//
// Параметры:
//		КонецСтроки - Строка - имя элемента мнемосхемы, к которому надо провести линию.
//		ТекЭлемент - ЭлементГрафическойСхемы - секущий элемент схемы.
//		ГрафическаяСхема - ГрафическаяСхема - элемент формы графическая схема.
//
Процедура мнс_СоздатьЛинию(Знач КонецСтроки,Знач ТекЭлемент,ГрафическаяСхема) Экспорт   
	
	Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
	
	Если Обработка = Неопределено Тогда
		Для Инд = 1 По 10 Цикл
			ОбработкаЗащита_Мнемосхемы = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
			Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session(); 
			Если Обработка <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Обработка = Неопределено Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить защищенную обработку, операция не будет выполнена! Проверьте связь с сервером лицензий!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	МассивВремФайл = новый Массив;
	
	Обработка.СоздатьЛинию(КонецСтроки,ТекЭлемент,ГрафическаяСхема,"Низ","Верх",,,МассивВремФайл);
	ОчиститьВремФайлы(МассивВремФайл);
	
КонецПроцедуры

// Создает чистую карту.
//
// Параметры:
//		ПолеГрафическойСхемы - ГрафическаяСхема - элемент формы графическая схема.
//
Процедура мнс_СоздатьЧистуюКарту(ПолеГрафическойСхемы) Экспорт
	
	
	Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
	
	Если Обработка = Неопределено Тогда
		Для Инд = 1 По 10 Цикл
			ОбработкаЗащита_Мнемосхемы = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session();
			Обработка = торо_СЛКСервер.ПодключитьЗащищеннуюОбработку_Session(); 
			Если Обработка <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Обработка = Неопределено Тогда
			торо_ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить защищенную обработку, операция не будет выполнена! Проверьте связь с сервером лицензий!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	МассивВремФайл = новый Массив;
	
	Обработка.СоздатьЧистуюКарту(ПолеГрафическойСхемы,МассивВремФайл);
	
	ОчиститьВремФайлы(МассивВремФайл);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура очищает временные файлы 
//
Процедура ОчиститьВремФайлы(МассивВремФайл)
	Для каждого ТекЗначение Из МассивВремФайл Цикл
		ВремФайл = Новый Файл(ТекЗначение);
		Если ВремФайл.Существует() Тогда
			УдалитьФайлы(ТекЗначение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

