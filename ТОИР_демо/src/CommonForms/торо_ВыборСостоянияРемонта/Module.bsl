
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("сзСтатусОР") Тогда
		сзСтатусОР = Параметры.сзСтатусОР;
	Иначе 
		сзСтатусОР = Новый СписокЗначений;
	КонецЕсли;
	
	дз = Новый ДеревоЗначений;
	дз.Колонки.Добавить("СостояниеОР");
	дз.Колонки.Добавить("ТехИмя");
	
	стрРодитель = дз.Строки.Добавить();
	стрРодитель.СостояниеОР = "Документ ""Выявленный дефект""";
	нс = стрРодитель.Строки.Добавить();	нс.СостояниеОР = "Зарегистрирован"; нс.ТехИмя = "Зарегистрирован (выявленный дефект)";
	нс = стрРодитель.Строки.Добавить();	нс.СостояниеОР = "Запланировано устранение"; нс.ТехИмя = "Запланировано устранение (выявленный дефект)";
	нс = стрРодитель.Строки.Добавить();	нс.СостояниеОР = "Устраняется"; нс.ТехИмя = "Устраняется (выявленный дефект)";
	нс = стрРодитель.Строки.Добавить();	нс.СостояниеОР = "Устранен"; нс.ТехИмя = "Устранен (выявленный дефект)";
	
	стрРодитель = дз.Строки.Добавить();
	стрРодитель.СостояниеОР = "Документ ""Внешнее основание для работ""";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Зарегистрирован"; нс.ТехИмя = "Зарегистрирован (внешнее основание)";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Запланировано устранение"; нс.ТехИмя = "Запланировано устранение (внешнее основание)";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Устраняется"; нс.ТехИмя = "Устраняется (внешнее основание)";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Устранен"; нс.ТехИмя = "Устранен (внешнее основание)";

	стрРодитель = дз.Строки.Добавить();
	стрРодитель.СостояниеОР = "Документ ""План-график ППР""";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Введен ППР"; нс.ТехИмя = "Введен ППР (план-график ППР)";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Запланировано выполнение"; нс.ТехИмя = "Запланировано выполнение (план-график ППР)";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Выполняется"; нс.ТехИмя = "Выполняется (план-график ППР)";
	нс = стрРодитель.Строки.Добавить(); нс.СостояниеОР = "Выполнен"; нс.ТехИмя = "Выполнен (план-график ППР)";
	
	тДерево = РеквизитФормыВЗначение("Состояния");
	Для каждого СтрокаР из дз.Строки Цикл
		стрРодитель = тДерево.Строки.Добавить();
		стрРодитель.Состояние = СтрокаР.СостояниеОР;
		стрРодитель.ТехИмя = СтрокаР.ТехИмя;
		ВсеВыбраны = Истина;
		
		Для каждого текСтрока из СтрокаР.Строки Цикл
			НайС = сзСтатусОР.НайтиПоЗначению(текСтрока.ТехИмя);
			нс = стрРодитель.Строки.Добавить();
			нс.Состояние = текСтрока.СостояниеОР;
			нс.ТехИмя = текСтрока.ТехИмя;
			Если НайС <> Неопределено И НайС.Пометка ТОгда
				нс.Выбрать = Истина;
			Иначе 
				нс.Выбрать = Ложь;
				ВсеВыбраны = Ложь;
			КонецЕсли
		КонецЦикла;
		
		стрРодитель.Выбрать = ВсеВыбраны;
	КонецЦикла;
	ЗначениеВРеквизитФормы(тДерево, "Состояния");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Уровень1 = Состояния.ПолучитьЭлементы();
	Для каждого текСтрока из Уровень1 Цикл
		Элементы.Состояния.Развернуть(текСтрока.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Передать(Команда)
	
	сз = Новый СписокЗначений;
	
	Уровень1 = Состояния.ПолучитьЭлементы();
	Для каждого СтрокаУ1 из Уровень1 цикл
		Уровень2 = СтрокаУ1.ПолучитьЭлементы();
		Для каждого СтрокаУ2 из Уровень2 Цикл
			сз.Добавить(СтрокаУ2.ТехИмя, СтрокаУ2.ТехИмя, СтрокаУ2.Выбрать);
		КонецЦикла;
	КонецЦикла;
	
	Закрыть(сз);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СостоянияВыбратьПриИзменении(Элемент)
	
	текСтрока = Элементы.Состояния.ТекущаяСтрока;
	Если текСтрока <> Неопределено Тогда
		СтрокаДерева = Состояния.НайтиПоИдентификатору(текСтрока);
		РаспространитьНаПодчиненные(СтрокаДерева);
		
		стрРодитель = СтрокаДерева.ПолучитьРодителя();
		Если стрРодитель <> Неопределено Тогда
			Уровень1 = стрРодитель.ПолучитьЭлементы();
			ВсеВыбраны = Истина;
			Для каждого СтрокаУ1 из Уровень1 Цикл
				Если НЕ СтрокаУ1.Выбрать Тогда
					ВсеВыбраны = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			стрРодитель.Выбрать = ВсеВыбраны;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспространитьНаПодчиненные(СтрокаДерева)
	Уровень1 = СтрокаДерева.ПолучитьЭлементы();
	Для каждого СтрокаУ1 из Уровень1 Цикл
		СтрокаУ1.Выбрать = СтрокаДерева.Выбрать;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	Уровень1 = Состояния.ПолучитьЭлементы();
	Для каждого СтрокаУ1 из Уровень1 Цикл
		СтрокаУ1.Выбрать = Истина;
		РаспространитьНаПодчиненные(СтрокаУ1);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	Уровень1 = Состояния.ПолучитьЭлементы();
	Для каждого СтрокаУ1 из Уровень1 Цикл
		СтрокаУ1.Выбрать = Ложь;
		РаспространитьНаПодчиненные(СтрокаУ1);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти