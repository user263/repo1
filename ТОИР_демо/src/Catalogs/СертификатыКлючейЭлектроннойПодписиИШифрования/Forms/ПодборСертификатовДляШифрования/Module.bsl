#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебный.УстановитьУсловноеОформлениеСпискаСертификатов(Список);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Организация", Организация);
	
	ЗакрыватьПриВыборе = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования")
	   И Параметр.Свойство("ЭтоНовый") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Источник;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаПользователейИспользованиеПриИзменении(Элемент)
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПользователейПриИзменении(Элемент)
	
	ГруппаПользователейПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Не Копирование Тогда
		ПараметрыСоздания = Новый Структура;
		ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
		ПараметрыСоздания.Вставить("Организация",   Организация);
		
		ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификатПослеВыбораНазначения(
			"ТолькоДляШифрования", ПараметрыСоздания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	
	Элементы.Список.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзФайла(Команда)
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация",   Организация);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификатТолькоДляШифрованияИзФайла(ПараметрыСоздания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ГруппаПользователейПриИзмененииНаСервере()
	
	Если ГруппаПользователейИспользование Тогда
		Список.ТекстЗапроса =
		"ВЫБРАТЬ
		|	Сертификаты.Ссылка,
		|	Сертификаты.ПометкаУдаления,
		|	Сертификаты.Наименование,
		|	Сертификаты.КомуВыдан,
		|	Сертификаты.Фирма,
		|	Сертификаты.Фамилия,
		|	Сертификаты.Имя,
		|	Сертификаты.Отчество,
		|	Сертификаты.Должность,
		|	Сертификаты.КемВыдан,
		|	Сертификаты.ДействителенДо,
		|	Сертификаты.Подписание,
		|	Сертификаты.Шифрование,
		|	Сертификаты.Отпечаток,
		|	Сертификаты.ДанныеСертификата,
		|	Сертификаты.Программа,
		|	Сертификаты.Отозван,
		|	Сертификаты.УсиленнаяЗащитаЗакрытогоКлюча,
		|	Сертификаты.Организация,
		|	Сертификаты.Пользователь,
		|	Сертификаты.ПользовательОповещенОСрокеДействия,
		|	Сертификаты.Добавил,
		|	Сертификаты.Предопределенный,
		|	Сертификаты.ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
		|ГДЕ
		|	Сертификаты.СостояниеЗаявления В (ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено))
		|	И ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|			ГДЕ
		|				СоставыГруппПользователей.Пользователь = Сертификаты.Пользователь
		|				И СоставыГруппПользователей.ГруппаПользователей В (&ГруппаПользователей))";
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "ГруппаПользователей", ГруппаПользователей);
	Иначе
		Список.ТекстЗапроса =
		"ВЫБРАТЬ
		|	Сертификаты.Ссылка,
		|	Сертификаты.ПометкаУдаления,
		|	Сертификаты.Наименование,
		|	Сертификаты.КомуВыдан,
		|	Сертификаты.Фирма,
		|	Сертификаты.Фамилия,
		|	Сертификаты.Имя,
		|	Сертификаты.Отчество,
		|	Сертификаты.Должность,
		|	Сертификаты.КемВыдан,
		|	Сертификаты.ДействителенДо,
		|	Сертификаты.Подписание,
		|	Сертификаты.Шифрование,
		|	Сертификаты.Отпечаток,
		|	Сертификаты.ДанныеСертификата,
		|	Сертификаты.Программа,
		|	Сертификаты.Отозван,
		|	Сертификаты.УсиленнаяЗащитаЗакрытогоКлюча,
		|	Сертификаты.Организация,
		|	Сертификаты.Пользователь,
		|	Сертификаты.ПользовательОповещенОСрокеДействия,
		|	Сертификаты.Добавил,
		|	Сертификаты.Предопределенный,
		|	Сертификаты.ИмяПредопределенныхДанных
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
		|ГДЕ
		|	Сертификаты.СостояниеЗаявления В (ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено))";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
