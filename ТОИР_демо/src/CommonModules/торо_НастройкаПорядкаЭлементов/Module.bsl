////////////////////////////////////////////////////////////////////////////////
// торо_НастройкаПорядкаЭлементов: методы, для работы с порядком элементо
//
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс
// Заполняет значение реквизита дополнительного упорядочивания у объекта.
//
// Параметры:
//		Ссылка - Объект - записываемый объект;
//		СтруктураИерархии - СправочникСсылка.торо_СтруктурыОР - структура иерархии.
//		Отказ    - Булево - признак отказа от записи объекта.
Процедура ЗаполнитьЗначениеРеквизитаУпорядочивания(Ссылка, СтруктураИерархии, Отказ) Экспорт
	
	// Если в обработчике был установлен отказ новый порядок не вычисляем
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Проверим, есть ли у объекта реквизит доп. упорядочивания
	Информация = торо_НастройкаПорядкаЭлементовСлужебный.ПолучитьИнформациюДляПеремещения(Ссылка, СтруктураИерархии);
	
	// Вычислим новое значение для порядка элемента
	НаборЗаписей = РегистрыСведений.торо_ПорядокОРПоИерархии.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбъектРемонта.Установить(Ссылка);
	НаборЗаписей.Отбор.СтруктураИерархии.Установить(СтруктураИерархии);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	НС = НаборЗаписей.Добавить();
	НС.ОбъектРемонта = Ссылка;
	НС.СтруктураИерархии = СтруктураИерархии;
	НС.РеквизитДопУпорядочиванияОР = торо_НастройкаПорядкаЭлементовСлужебный.ПолучитьНовоеЗначениеРеквизитаДопУпорядочивания(
					Информация, Информация.Родитель, СтруктураИерархии);
	НаборЗаписей.Записать();
						
КонецПроцедуры

// Возвращает максимальное значение реквизита доп. упорядочивания.
// Параметры:
//		Иерархия - СправочникСсылка.торо_СтруктурыОР - структура иерархии.
// Возвращаемое значение:
//		Число - максимальное значение.
Функция ПолучитьМаксимальноеЗначениеРеквизитаДопУпорядоивания(Иерархия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.РеквизитДопУпорядочиванияОР КАК РеквизитДопУпорядочивания
	|ИЗ
	|	РегистрСведений.торо_ПорядокОРПоИерархии КАК Таблица
	|ГДЕ
	|	Таблица.СтруктураИерархии = &СтруктураИерархии
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ";
	
	Запрос.УстановитьПараметр("СтруктураИерархии", Иерархия);
	
	РезЗапроса = Запрос.Выполнить();
	
	Если РезЗапроса.Пустой() Тогда 
		возврат 1; 
	КонецЕсли;
	
	Выборка = РезЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.РеквизитДопУпорядочивания + 1;	
	
КонецФункции

#КонецОбласти

