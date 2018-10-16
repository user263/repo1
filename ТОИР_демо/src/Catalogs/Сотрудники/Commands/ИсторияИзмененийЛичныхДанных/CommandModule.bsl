#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		СсылкаНаОбъект = ПараметрКоманды[0];
	Иначе
		СсылкаНаОбъект = ПараметрКоманды;
	КонецЕсли;
	
	СписокВерсий = ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ВыборХранимыхВерсий",
								Новый Структура("Ссылка", ФизическоеЛицоСотрудника(СсылкаНаОбъект)),
								ПараметрыВыполненияКоманды.Источник,
								ПараметрыВыполненияКоманды.Уникальность,
								ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция ФизическоеЛицоСотрудника(Сотрудник)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
КонецФункции

#КонецОбласти