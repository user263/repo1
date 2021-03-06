////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Управляет доступностью команд "Вверх", "Вниз", "Удалить" в таблице настройки доп. реквизитов в объектах ремонта.
//
//	Параметры:
//		Форма - УправляемаяФорма - форма справочника.
//		ИмяТаблицыДопРеквизитовСведений - Строка - Имя таблицы, если не указано, 
//											то "Свойства_ЗначенияДополнительныхРеквизитов".
Процедура УстановитьДоступностьКомандРедактированияДопРеквизитовСведений(Форма, ИмяТаблицыДопРеквизитовСведений = "") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяТаблицыДопРеквизитовСведений) Тогда
		ИмяТаблицыДопРеквизитовСведений = "Свойства_ЗначенияДополнительныхРеквизитов";
	Конецесли;
	
	Элементы = Форма.Элементы;
	ТаблицаДопРеквизитовЭлемент = Элементы[ИмяТаблицыДопРеквизитовСведений];
	
	ТекущиеДанные = ТаблицаДопРеквизитовЭлемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДопРеквизитов = Форма[ИмяТаблицыДопРеквизитовСведений];
	КомандыРедактирования = КомандыРедактированияДопРеквизитовСведений(ИмяТаблицыДопРеквизитовСведений);
	
	// Если активная строка - строка общего доп. реквизита (сведения), то сделать недоступными кнопки добавления, удаления, перемещения.
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		КомандыРедактирования.Удалить, 
		"Доступность", 
		Не ТекущиеДанные.ОбщееСвойство);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		КомандыРедактирования.ПереместитьВверх, 
		"Доступность", 
		Не ТекущиеДанные.ОбщееСвойство);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		КомандыРедактирования.ПереместитьВниз, 
		"Доступность", 
		Не ТекущиеДанные.ОбщееСвойство);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		КомандыРедактирования.КонтекстноеМенюУдалить, 
		"Доступность", 
		Не ТекущиеДанные.ОбщееСвойство);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		КомандыРедактирования.КонтекстноеМенюПереместитьВверх, 
		"Доступность", 
		Не ТекущиеДанные.ОбщееСвойство);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		КомандыРедактирования.КонтекстноеМенюПереместитьВниз,
		"Доступность",
		Не ТекущиеДанные.ОбщееСвойство);
	
	// Если активная строка - первая или последняя в списке, то сделать недоступными кнопки сдвига вверх или вниз.
	Если Не ТекущиеДанные.ОбщееСвойство Тогда
		
		ИндексСтроки = ТаблицаДопРеквизитов.Индекс(ТекущиеДанные);
		
		Если ИндексСтроки = 0 Тогда
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, 
				КомандыРедактирования.ПереместитьВверх, 
				"Доступность", 
				Ложь);
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, 
				КомандыРедактирования.КонтекстноеМенюПереместитьВверх, 
				"Доступность", 
				Ложь);
			
		КонецЕсли;
		
		Если ИндексСтроки = ТаблицаДопРеквизитов.Количество() - 1 Тогда
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, 
				КомандыРедактирования.ПереместитьВниз, 
				"Доступность", 
				Ложь);
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, 
				КомандыРедактирования.КонтекстноеМенюПереместитьВниз, 
				"Доступность", 
				Ложь);
			
		КонецЕсли;
		
		Если ИндексСтроки > 0 Тогда
			
			ПредыдущаяСтрока = ТаблицаДопРеквизитов[ИндексСтроки - 1];
			
			Если ПредыдущаяСтрока.ОбщееСвойство Тогда
				
				// Если предыдущая строка является строкой общего реквизита, то сделать недоступной кнопку сдвига вверх.
				ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы, 
					КомандыРедактирования.ПереместитьВверх, 
					"Доступность", 
					Ложь);
				
				ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы, 
					КомандыРедактирования.КонтекстноеМенюПереместитьВверх, 
					"Доступность", 
					Ложь);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИндексСтроки < ТаблицаДопРеквизитов.Количество()-1 Тогда
			
			СледующаяСтрока = ТаблицаДопРеквизитов[ИндексСтроки + 1];
			
			Если СледующаяСтрока.ОбщееСвойство Тогда
				
				// Если предыдущая строка является строкой общего реквизита, то сделать недоступной кнопку сдвига вверх.
				ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы, 
					КомандыРедактирования.ПереместитьВниз, 
					"Доступность", 
					Ложь);
				
				ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы, 
					КомандыРедактирования.КонтекстноеМенюПереместитьВниз, 
					"Доступность", 
					Ложь);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Настраивает положение и вид кнопок "Вверх", "Вниз", "Удалить" и других 
// в таблице настройки доп. реквизитов в объектах ремонта.
//
//	Параметры:
//		Форма - УправляемаяФорма - форма справочника.
//		ЕстьПравоРедактирования - Булево - у пользователя есть право на редактирование справочника.
Процедура НастроитьКнопкиКоманднойПанелиТаблицыДопРеквизитов(Форма, ЕстьПравоРедактирования = Истина) Экспорт
	
	Структура = Новый Структура("Свойства_ОтображатьЗначенияВТаблице");
	ЗаполнитьЗначенияСвойств(Структура, Форма);
	
	Если Структура.Свойства_ОтображатьЗначенияВТаблице = Истина Тогда
		
		СтруктураКоманд = УправлениеСвойствамиКлиентСервер.КомандыРедактированияДопРеквизитовСведений("Свойства_ЗначенияДополнительныхРеквизитов");
		Форма.Элементы[СтруктураКоманд.ПереместитьВверх].ТолькоВоВсехДействиях = Ложь;
		Форма.Элементы[СтруктураКоманд.ПереместитьВниз].ТолькоВоВсехДействиях = Ложь;
		Форма.Элементы[СтруктураКоманд.Удалить].ТолькоВоВсехДействиях = Ложь;
		
		Форма.Элементы[СтруктураКоманд.Удалить].Отображение = ОтображениеКнопки.Картинка;
		Форма.Элементы[СтруктураКоманд.Добавить].Отображение = ОтображениеКнопки.Картинка;
		Форма.Элементы[СтруктураКоманд.Скопировать].Видимость = Ложь;
		Форма.Элементы[СтруктураКоманд.КонтекстноеМенюСкопировать].Видимость = Ложь;

		Если НЕ ЕстьПравоРедактирования Тогда
			Для каждого Элемент из СтруктураКоманд Цикл
				Форма.Элементы[Элемент.Значение].Доступность = Ложь;
			КонецЦикла;
			Форма.Элементы["Свойства_ЗначенияДополнительныхРеквизитовЗначение"].ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КомандыРедактированияДопРеквизитовСведений(ИмяТаблицыДопРеквизитовСведений = "") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяТаблицыДопРеквизитовСведений) Тогда
		ИмяТаблицыДопРеквизитовСведений = "Свойства_ЗначенияДополнительныхРеквизитов";
	Конецесли;
	
	СтруктураКоманд = Новый Структура;
	СтруктураКоманд.Вставить("Удалить", 			ИмяТаблицыДопРеквизитовСведений + "Удалить");
	СтруктураКоманд.Вставить("ПереместитьВверх",	ИмяТаблицыДопРеквизитовСведений + "ПереместитьВверх");
	СтруктураКоманд.Вставить("ПереместитьВниз",	ИмяТаблицыДопРеквизитовСведений + "ПереместитьВниз");
	СтруктураКоманд.Вставить("Добавить",			ИмяТаблицыДопРеквизитовСведений + "Добавить");
	СтруктураКоманд.Вставить("Скопировать",		ИмяТаблицыДопРеквизитовСведений + "Скопировать");
	
	СтруктураКоманд.Вставить("КонтекстноеМенюУдалить", 			ИмяТаблицыДопРеквизитовСведений + "КонтекстноеМенюУдалить");
	СтруктураКоманд.Вставить("КонтекстноеМенюПереместитьВверх",	ИмяТаблицыДопРеквизитовСведений + "КонтекстноеМенюПереместитьВверх");
	СтруктураКоманд.Вставить("КонтекстноеМенюПереместитьВниз",	ИмяТаблицыДопРеквизитовСведений + "КонтекстноеМенюПереместитьВниз");
	СтруктураКоманд.Вставить("КонтекстноеМенюДобавить",			ИмяТаблицыДопРеквизитовСведений + "КонтекстноеМенюДобавить");
	СтруктураКоманд.Вставить("КонтекстноеМенюСкопировать",		ИмяТаблицыДопРеквизитовСведений + "КонтекстноеМенюСкопировать");
	
	Возврат СтруктураКоманд;
	
КонецФункции

#КонецОбласти
