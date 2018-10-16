////////////////////////////////////////////////////////////////////////////////
// Подсистема "Настройка порядка элементов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик команды "Переместить вверх" формы списка.
//
// Параметры:
//  РеквизитФормыСписок - ДинамическийСписок - реквизит формы, содержащий список;
//  ЭлементФормыСписок  - ТаблицаФормы       - элемент формы, содержащий список.
//
Процедура ПереместитьЭлементВверхВыполнить(РеквизитФормыСписок, ЭлементФормыСписок) Экспорт
	
	ПереместитьЭлемент(РеквизитФормыСписок, ЭлементФормыСписок, "Вверх");
	
КонецПроцедуры

// Обработчик команды "Переместить вниз" формы списка.
//
// Параметры:
//  РеквизитФормыСписок - ДинамическийСписок - реквизит формы, содержащий список;
//  ЭлементФормыСписок  - ТаблицаФормы       - элемент формы, содержащий список.
//
Процедура ПереместитьЭлементВнизВыполнить(РеквизитФормыСписок, ЭлементФормыСписок) Экспорт
	
	ПереместитьЭлемент(РеквизитФормыСписок, ЭлементФормыСписок, "Вниз");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПереместитьЭлемент(СписокРеквизит, СписокЭлемент, Направление)
	
	Если СписокЭлемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокРеквизит", СписокРеквизит);
	Параметры.Вставить("СписокЭлемент", СписокЭлемент);
	Параметры.Вставить("Направление", Направление);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПереместитьЭлементПроверкаВыполнена", ЭтотОбъект, Параметры);
	
	ПроверитьСписокПередОперацией(ОписаниеОповещения, СписокРеквизит);
	
КонецПроцедуры

Процедура ПереместитьЭлементПроверкаВыполнена(РезультатПроверки, ДополнительныеПараметры) Экспорт
	
	Если РезультатПроверки <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	СписокЭлемент = ДополнительныеПараметры.СписокЭлемент;
	СписокРеквизит = ДополнительныеПараметры.СписокРеквизит;
	Направление = ДополнительныеПараметры.Направление;
	
	ОтображениеСписком = (СписокЭлемент.Отображение = ОтображениеТаблицы.Список);
	
	ТекстОшибки = НастройкаПорядкаЭлементовСлужебныйВызовСервера.ИзменитьПорядокЭлементов(
		СписокЭлемент.ТекущиеДанные.Ссылка, СписокРеквизит, ОтображениеСписком, Направление);
		
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
	
	СписокЭлемент.Обновить();
	
КонецПроцедуры

Процедура ПроверитьСписокПередОперацией(ОбработчикРезультата, СписокРеквизит)
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	Параметры.Вставить("СписокРеквизит", СписокРеквизит);
	
	Если Не СортировкаВСпискеУстановленаПравильно(СписокРеквизит) Тогда
		ТекстВопроса = НСтр("ru = 'Для изменения порядка элементов необходимо настроить сортировку списка
								|по полю ""Порядок"". Настроить необходимую сортировку?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьСписокПередОперациейОтветПоСортировкеПолучен", ЭтотОбъект, Параметры);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Настроить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не настраивать'"));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
	ПереместитьЭлементПроверкаВыполнена(Истина, ОбработчикРезультата.ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПроверитьСписокПередОперациейОтветПоСортировкеПолучен(РезультатОтвета, ДополнительныеПараметры) Экспорт
	
	Если РезультатОтвета <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СписокРеквизит = ДополнительныеПараметры.СписокРеквизит;
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из СписокРеквизит.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.Проверить(ПользовательскиеНастройкиПорядка <> Неопределено, НСтр("ru = 'Пользовательская настройка порядка не найдена.'"));
	
	ПользовательскиеНастройкиПорядка.Элементы.Очистить();
	Элемент = ПользовательскиеНастройкиПорядка.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Элемент.Использование = Истина;
	Элемент.Поле = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
	Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
КонецПроцедуры

Функция СортировкаВСпискеУстановленаПравильно(Список)
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПользовательскиеНастройкиПорядка = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЭлементыПорядка = ПользовательскиеНастройкиПорядка.Элементы;
	
	// Найдем первый используемый элемент порядка.
	Элемент = Неопределено;
	Для Каждого ЭлементПорядка Из ЭлементыПорядка Цикл
		Если ЭлементПорядка.Использование Тогда
			Элемент = ЭлементПорядка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Элемент = Неопределено Тогда
		// Не установлена никакая сортировка.
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элемент) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		Если Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			ПолеРеквизита = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
			Если Элемент.Поле = ПолеРеквизита Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
