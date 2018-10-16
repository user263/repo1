#Область ПрограммныйИнтерфейс

// Получает список полей, необходимых для построения представления.
//
// Параметры:
//		ФорматнаяСтрока - Строка - Строка, по которой формируется представление.
//
// Возвращаемое значение:
//		Массив - массив полей для получения представления.
//
Функция ПолучитьСписокПолей(ФорматнаяСтрока) Экспорт
	
	МассивПолей = Новый Массив;
	
	ПодстрокаПоиска = ФорматнаяСтрока;
	
	Пока Истина Цикл
		
		НомерСимвола1 = Найти(ПодстрокаПоиска,"%");
		Если НомерСимвола1 = 0 Тогда
			Прервать;
		КонецЕсли;
		ПодстрокаПоиска = Сред(ПодстрокаПоиска,НомерСимвола1+1);
		НомерСимвола2 = Найти(ПодстрокаПоиска,"%");
		Если НомерСимвола2 = 0 Тогда
			Прервать;
		КонецЕсли;
		МассивПолей.Добавить(Лев(ПодстрокаПоиска,НомерСимвола2-1));
		ПодстрокаПоиска = Сред(ПодстрокаПоиска,НомерСимвола2+1);
		
	КонецЦикла;
	
	Возврат МассивПолей;
	
КонецФункции

// Получает строковое представление для ОР по форматной строке и данным.
//
// Параметры:
//		ФорматнаяСтрока - Строка - Строка, по которой формируется представление.
//		Данные - Структура - данные для получения представления.
//
// Возвращаемое значение:
//		Строка - представление.
Функция ПолучитьПредставлениеПоФорматнойСтроке(ФорматнаяСтрока,Данные) Экспорт
	
	Представление = ФорматнаяСтрока;
	Для Каждого КлючИЗначение Из Данные Цикл
		Представление = СтрЗаменить(Представление,"%"+КлючИЗначение.Ключ+"%",Строка(КлючИЗначение.Значение));
	КонецЦикла;
	Возврат Представление;
	
КонецФункции

#КонецОбласти