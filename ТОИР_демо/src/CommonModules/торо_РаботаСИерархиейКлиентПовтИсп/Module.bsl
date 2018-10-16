////////////////////////////////////////////////////////////////////////////////
// торо_РаботаСИерархиейКлиентПовтИсп: методы, для работы с иерархиями
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Функция возвращает список всех используемых иерархий.
// Параметры:
//		ИсключаемаяИерархия - СправочникСсылка.торо_СтруктурыОР - если заполнено, то эта иерархия не выводится в список.
// Возвращаемое значение:
//		СписокЗначений - список иерархий.
Функция ПолучитьСписокИерархий(ИсключаемаяИерархия = Неопределено) Экспорт
	
	Возврат торо_РаботаСИерархией.ПолучитьСписокИерархий(ИсключаемаяИерархия);
	
КонецФункции

#КонецОбласти
