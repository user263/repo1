#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.Список.КоманднаяПанель);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельСотрудниковСПодразделениями);
	// Конец СтандартныеПодсистемы.Печать
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Проинициализируем форму для отбора по роли сотрудника
	Параметры.Отбор.Свойство("РольСотрудника", РольСотрудника);
	УстановитьОтборПоРолиСотрудника(); 
	
	ВидВсеСотрудники = Истина;
	
	Если Параметры.РежимВыбора Тогда
		
		СкрытьСписокПодразделений = Ложь;
		
		// Проинициализируем режим выбора
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Список",
			"РежимВыбора",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСотрудниковБезПодразделений",
			"РежимВыбора",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокВыбрать",
			"Видимость",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокВыбратьСПодразделениями",
			"Видимость",
			Истина);
			
		// Скроем кнопки оформления документов
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОформитьДокумент",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОформитьДокументСПодразделениями",
			"Видимость",
			Ложь);
			
		// В режиме выбора, нет возможности изменить отбор по головной организации
		УстанавливатьОтборПоГоловнойОрганизации = Ложь;
		
		// Если это выбор из особенного документа, например "Прием на работу"
		// управляем отборами в зависимости от "принятости на работу".
		Параметры.Свойство("ДоступныНепринятые", ДоступныНепринятые);
		
		Параметры.Свойство("РазрешеноОтключатьОтборПоРоли", РазрешеноОтключатьОтборПоРоли);
		
		Если ДоступныНепринятые Тогда
			
			СкрытьСписокПодразделений = Истина; 
			
			// В отбор включаются, только сотрудники у которых еще нет текущей организации
			МассивОрганизаций = Новый Массив;
			МассивОрганизаций.Добавить(Справочники.Организации.ПустаяСсылка());
			
			// Запомним массив организаций в реквизитах формы
			МассивОрганизацийДляОтбора = Новый ФиксированныйМассив(МассивОрганизаций);
			
		Иначе
			
			// Проинициализируем переменные, для отбора по периоду
			ОтборПоПериодуКадровыхДанных = Ложь;
			ОтбиратьПоГоловнойОрганизации = Ложь;
			ПодразделениеДляОтбора = Неопределено;
			
			// Получим параметр ТекущаяОрганизация
			Параметры.Отбор.Свойство("ТекущаяОрганизация", ОрганизацияДляОтбора);
			
			// Если параметр не передан, получаем организацию из параметра ГоловнаяОрганизация
			Если НЕ ЗначениеЗаполнено(ОрганизацияДляОтбора) 
				И ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
				
				ОрганизацияДляОтбора = ГоловнаяОрганизация;
				ОтбиратьПоГоловнойОрганизации = Истина;
				
			КонецЕсли;
			
			// Получим параметр ТекущееПодразделение
			Если Параметры.Отбор.Свойство("ТекущееПодразделение") Тогда
				Если ЗначениеЗаполнено(Параметры.Отбор.ТекущееПодразделение) Тогда
					ПодразделениеДляОтбора = Параметры.Отбор.ТекущееПодразделение;
					СкрытьСписокПодразделений = Истина;
				Иначе
					// Если параметр ТекущееПодразделение задан, но не заполнен,
					// удалим его из списка параметров.
					ВидВсеСотрудники = Ложь;
					Параметры.Отбор.Удалить("ТекущееПодразделение");
				КонецЕсли;
			КонецЕсли;
			
			// Получим праметры периода отбора
			
			Если Параметры.Отбор.Свойство("НачалоПериодаПримененияОтбора") Тогда
				
				Если ЗначениеЗаполнено(Параметры.Отбор.НачалоПериодаПримененияОтбора) Тогда
					
					// Подбор работающих в указанном периоде, если окончание периода не задано,
					// считается, что отбираются работающие в текущем месяце.
					ОтборПоПериодуКадровыхДанных = Истина;
					
					НачалоПериодаПримененияОтбора = Параметры.Отбор.НачалоПериодаПримененияОтбора;
					
					Если Параметры.Отбор.Свойство("ОкончаниеПериодаПримененияОтбора") 
						И ЗначениеЗаполнено(Параметры.Отбор.ОкончаниеПериодаПримененияОтбора) Тогда
						ОкончаниеПериодаПримененияОтбора = Параметры.Отбор.ОкончаниеПериодаПримененияОтбора;
					Иначе
						ОкончаниеПериодаПримененияОтбора = КонецМесяца(НачалоПериодаПримененияОтбора);
					КонецЕсли;
					
				КонецЕсли;
				
				Параметры.Отбор.Удалить("НачалоПериодаПримененияОтбора");
				Параметры.Отбор.Удалить("ОкончаниеПериодаПримененияОтбора");
				
			КонецЕсли;
			
			Если НЕ ОтборПоПериодуКадровыхДанных 
				И Параметры.Отбор.Свойство("МесяцПримененияОтбора") Тогда
				
				Если ЗначениеЗаполнено(Параметры.Отбор.МесяцПримененияОтбора) Тогда
					
					// Подбор работавших в указанном месяце
					ОтборПоПериодуКадровыхДанных = Истина;
					
					НачалоПериодаПримененияОтбора = Параметры.Отбор.МесяцПримененияОтбора;
					ОкончаниеПериодаПримененияОтбора = КонецМесяца(НачалоПериодаПримененияОтбора);
					
				КонецЕсли;
				
				Параметры.Отбор.Удалить("МесяцПримененияОтбора");
				
			КонецЕсли;
			
			Если НЕ ОтборПоПериодуКадровыхДанных И 
				Параметры.Отбор.Свойство("ДатаПримененияОтбора") Тогда
				
				Если ЗначениеЗаполнено(Параметры.Отбор.ДатаПримененияОтбора) Тогда
					
					// Подбор работающих на указанную дату
					ОтборПоПериодуКадровыхДанных = Истина;
					
					НачалоПериодаПримененияОтбора = Параметры.Отбор.ДатаПримененияОтбора;
					ОкончаниеПериодаПримененияОтбора = Параметры.Отбор.ДатаПримененияОтбора;
				
				КонецЕсли;
			
				Параметры.Отбор.Удалить("ДатаПримененияОтбора");
				
			КонецЕсли;
			
			// Если получены организация и сам период, сформируем список ссылок и установим отбор.
			Если ЗначениеЗаполнено(ОрганизацияДляОтбора) И ОтборПоПериодуКадровыхДанных Тогда
				
				ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
				
				ПараметрыПолученияСотрудниковОрганизаций.Организация = ОрганизацияДляОтбора;
				Если ОтбиратьПоГоловнойОрганизации Тогда
					ПараметрыПолученияСотрудниковОрганизаций.ОтбиратьПоГоловнойОрганизации = ОтбиратьПоГоловнойОрганизации;
				КонецЕсли; 
				
				Если ЗначениеЗаполнено(ПодразделениеДляОтбора) Тогда
					ПараметрыПолученияСотрудниковОрганизаций.Подразделение = ПодразделениеДляОтбора;
				КонецЕсли;
					
				ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода 		= НачалоПериодаПримененияОтбора;
				ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода 	= ОкончаниеПериодаПримененияОтбора;
				
				ТаблицаСотрудников = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудниковОрганизаций);
				
				МассивСотрудников = ТаблицаСотрудников.ВыгрузитьКолонку("Сотрудник");
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивСотрудников, ВидСравненияКомпоновкиДанных.ВСписке);
				
				// В этом режиме, отключим отбор в параметрах по подразделению
				// оставим отбор по организации, если в качестве ТекущейОрганизации
				// передано обособленное подразделение, переопредлим отбор на головную 
				// организацию этого подразделения.
				
				Если Параметры.Отбор.Свойство("ГловнаяОрганизация")
					И ЗначениеЗаполнено(Параметры.Отбор.ГоловнаяОрганизация) Тогда
					Параметры.Отбор.Удалить("ТекущаяОрганизация");
				КонецЕсли; 
				
				Параметры.Отбор.Удалить("ТекущееПодразделение");
				
				ТекстЗаголовка = НСтр("ru='В списке отображены сотрудники'");
				Если НачалоПериодаПримененияОтбора = ОкончаниеПериодаПримененияОтбора Тогда
					
					ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						", " + НСтр("ru = 'работающие %1'"), 
						Формат(НачалоПериодаПримененияОтбора, "ДФ='дд ММММ гггг ""г.""'"));
						
				ИначеЕсли НачалоПериодаПримененияОтбора = НачалоМесяца(НачалоПериодаПримененияОтбора) 
						И ОкончаниеПериодаПримененияОтбора = НачалоДня(КонецМесяца(ОкончаниеПериодаПримененияОтбора)) 
						И Месяц(НачалоПериодаПримененияОтбора) = Месяц(ОкончаниеПериодаПримененияОтбора) Тогда
						
					ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						", " + НСтр("ru = 'работающие в период - %1 г.'"), 
						Формат(НачалоПериодаПримененияОтбора, "ДФ='ММММ гггг'"));
						
				Иначе
						
					ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					", " + НСтр("ru = 'работающие в период с %1 г. по %2 г.'"), 
					Формат(НачалоПериодаПримененияОтбора, "ДФ='дд ММММ гггг'"), 
					Формат(ОкончаниеПериодаПримененияОтбора, "ДФ='дд ММММ гггг'"));
					
				КонецЕсли;
				
				ТекстЗаголовка = ТекстЗаголовка + " "
					+ НСтр("ru='Чтобы увидеть полный список сотрудников установите флажок ""Показать всех сотрудников"".'");
								
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы,
					"НадписьИнформацияОбОтбореПоПериоду",
					"Заголовок",
					ТекстЗаголовка);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы,
					"ГруппаИнфонадписиОтбораПоПериоду",
					"Видимость",
					Истина);
				
			КонецЕсли; 
			
			// Если в режиме выбора, не задана организация, но сами параметры заданы,
			// ограничим список сотрудниками, теми у которых заполнена дата приема.
				
			Если НЕ ЗначениеЗаполнено(ОрганизацияДляОтбора) Тогда
				
				Если Параметры.Отбор.Свойство("ГловнаяОрганизация") 
					ИЛИ Параметры.Отбор.Свойство("ТекущаяОрганизация") Тогда
					ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ДатаПриема", '00010101', ВидСравненияКомпоновкиДанных.Больше);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	
		// Если при открытии формы выбора передан сотрудник,
		// и он "в архиве", включим режим вывода сотрудников
		// по которым уже не выполняются операции.
		
		Если ЗначениеЗаполнено(РольСотрудника) Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ГруппаИнфонадписейПриВыборепоРоли",
				"Видимость",
				Истина);
			
			ТекстОВозможностиСоздатьНового = "";
			
			Если РольСотрудника = Перечисления.РолиСотрудников.Работник Тогда
				
				Если ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли Тогда
					
					ТекстОВозможностиСоздатьНового = Символы.ПС + НСтр("ru = 'Вы можете создать нового работника.'");
					
					Элементы.НадписьПредупрежедние.Заголовок = 
						НСтр("ru = 'Не создавайте нового работника если он является договорником организации и уже введен
								|в систему - просто установите флажок ""Показать всех сотрудников"".'");
				Иначе
								
					ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
						Элементы,
						"ГруппаПредупрежедние",
						"Видимость",
						Ложь);
						
				КонецЕсли;
				
				Элементы.НадписьИнформация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сейчас в списке отображаются только те работники, на которых ранее уже оформлялись документы ""Прием на работу"".%1'"),
					ТекстОВозможностиСоздатьНового);
							
			Иначе
				
				СкрытьСписокПодразделений = Истина;
				
				Если ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли Тогда
					
					ТекстОВозможностиСоздатьНового = Символы.ПС + НСтр("ru = 'Вы можете создать нового договорника.'");
					
					Элементы.НадписьПредупрежедние.Заголовок = 
						НСтр("ru = 'Не создавайте нового договорника если он является сотрудником организации и уже введен
							|в систему - просто установите флажок ""Показать всех сотрудников"".'");
							
				Иначе
					
					ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
						Элементы,
						"ГруппаПредупрежедние",
						"Видимость",
						Ложь);
						
				КонецЕсли;
				
				Элементы.НадписьИнформация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сейчас в списке отображаются только те договорники, с которыми ранее уже оформлялись договоры гражданско-правового характера.%1'"),
					ТекстОВозможностиСоздатьНового);
					
			КонецЕсли;
			
		КонецЕсли;
		
		Если СкрытьСписокПодразделений Тогда
			
			ВидВсеСотрудники = Истина;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ВидСписка",
				"Видимость",
				Ложь);
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОтключитьОтборПоРолиСотрудника",
			"Видимость",
			ЗначениеЗаполнено(РольСотрудника) И РазрешеноОтключатьОтборПоРоли 
				ИЛИ ЗначениеЗаполнено(РольСотрудника) И ДоступныНепринятые);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Список",
			"ИзменятьСоставСтрок",
			ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСотрудниковБезПодразделений",
			"ИзменятьСоставСтрок",
			ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСоздать",
			"Видимость",
			ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСоздатьСПодразделениями",
			"Видимость",
			ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСкопировать",
			"Видимость",
			ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокСкопироватьСПодразделениями",
			"Видимость",
			ДоступныНепринятые ИЛИ РазрешеноОтключатьОтборПоРоли);
			
		Если Параметры.МножественныйВыбор = Истина Тогда
			РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		КонецЕсли;
		
	Иначе
	
		УстанавливатьОтборПоГоловнойОрганизации = НЕ ЗначениеЗаполнено(ГоловнаяОрганизация);
		
		НастройкаВидВсеСотрудники = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокСотрудников", "ВидВсеСотрудники");
		ВидВсеСотрудники = ?(НастройкаВидВсеСотрудники = Неопределено, Истина, НастройкаВидВсеСотрудники);
		
		ГоловнаяОрганизация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокСотрудников", "ГоловнаяОрганизация");;
		ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГоловнаяОрганизация, "Ссылка");
		
		Если НЕ ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
			
			ЗначенияДляЗаполнения = Новый Структура;
			ЗначенияДляЗаполнения.Вставить("Организация", "ГоловнаяОрганизация");
			
		КонецЕсли;
	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОтключитьОтборПоРолиСотрудника",
			"Видимость",
			ЗначениеЗаполнено(РольСотрудника));
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГоловнаяОрганизация",
		"Видимость",
		УстанавливатьОтборПоГоловнойОрганизации);
	
	УстановитьОтборСписка(Список, УстанавливатьОтборПоГоловнойОрганизации, ГоловнаяОрганизация, МассивОрганизацийДляОтбора, ПоказыватьСотрудниковВАрхиве);
	УстановитьОтоборПодразделений();
	
	УстановитьЗаголовокФормы();
	
	УстановитьВидСпискаСотрудников(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметры.РежимВыбора И ИмяСобытия = "СозданСотрудник" И Источник = ЭтаФорма Тогда
		ОповеститьОВыборе(Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ Элементы.Список.РежимВыбора И Не ЗавершениеРаботы Тогда
		СохранитьНастройкиПриЗакрытииНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборСписка(Список, УстанавливатьОтборПоГоловнойОрганизации, ГоловнаяОрганизация, МассивОрганизацийДляОтбора, ПоказыватьСотрудниковВАрхиве);
	УстановитьОтоборПодразделений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСотрудниковВАрхивеПриИзменении(Элемент)
	
	 УстановитьОтборСписка(Список, УстанавливатьОтборПоГоловнойОрганизации, ГоловнаяОрганизация, МассивОрганизацийДляОтбора, ПоказыватьСотрудниковВАрхиве);
	 
КонецПроцедуры
 
&НаКлиенте
Процедура ОтключитьОтборПоПериодуПриИзменении(Элемент)
	
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.Отбор, "Ссылка");
	Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		ЭлементОтбора.Использование = НЕ ОтключитьОтборПоПериоду;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборПоРолиСотрудникаПриИзменении(Элемент)
	
	УстановитьОтборПоРолиСотрудника();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСотрудниковПодчиненныхПодразделенийПриИзменении(Элемент)
	
	Если Элементы.СотрудникиПоПодразделениямСПодразделениями.Пометка Тогда
		УстановитьОтборПоПодразделению(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ДобавитьСотрудникаПоРоли(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокСотрудниковБезПодразделений
&НаКлиенте
Процедура СписокСотрудниковБезПодразделенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.СписокСотрудниковБезПодразделений.РежимВыбора Тогда
		ОповеститьОВыборе(ВыбраннаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковБезПодразделенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ДобавитьСотрудникаПоРоли(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодразделения

&НаКлиенте
Процедура ПодразделенияПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборПоПодразделению(ЭтаФорма);
	 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	Если Найти(Команда.Имя, "СписокКоманднаяПанельПодменюПечатьКомандаПечати") <> 0 Тогда
		УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	ИначеЕсли Найти(Команда.Имя, "КоманднаяПанельСотрудниковСПодразделениямиПодменюПечатьКомандаПечати") <> 0 Тогда
		УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СписокСотрудниковБезПодразделений);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ВыбратьСотрудникаИзСпискаПоПодразделениям(Команда)
	
	Если Элементы.СписокСотрудниковБезПодразделений.ТекущаяСтрока <> Неопределено Тогда
		ОповеститьОВыборе(Элементы.СписокСотрудниковБезПодразделений.ТекущаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьКадровыйПеревод(Команда)
	
	СотрудникиКлиент.ОформитьКадровыйПеревод(ЭтаФорма, ТекущийСотрудник());
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПриемНаРаботу(Команда)
	
	СотрудникиКлиент.ОформитьПриемНаРаботу(ЭтаФорма, ТекущийСотрудник());
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьУвольнение(Команда)
	
	СотрудникиКлиент.ОформитьУвольнение(ЭтаФорма, ТекущийСотрудник());
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеСотрудники(Команда)
	
	ВидВсеСотрудники = Истина;
	УстановитьВидСпискаСотрудников(ЭтаФорма);
	УстановитьОтборПоПодразделению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПоПодразделениям(Команда)
	
	ВидВсеСотрудники = Ложь;
	УстановитьВидСпискаСотрудников(ЭтаФорма);
	УстановитьОтборПоПодразделению(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ДобавитьСотрудникаПоРоли(Отказ)
	
	РольСотрудникаДляСозданияНового = Неопределено;
	
	Если ЗначениеЗаполнено(РольСотрудника) Тогда
		
		РольСотрудникаДляСозданияНового = РольСотрудника;
		
	ИначеЕсли ДоступныНепринятые Тогда

		РольСотрудникаДляСозданияНового = ПредопределенноеЗначение("Перечисление.РолиСотрудников.Работник");
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(РольСотрудникаДляСозданияНового) Тогда
		
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		ПараметрыФормы.Вставить("РольСотрудника", РольСотрудникаДляСозданияНового);
		ПараметрыФормы.Вставить("ГоловнаяОрганизация", ГоловнаяОрганизация);
		ПараметрыФормы.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		ОткрытьФорму(
				"Справочник.Сотрудники.ФормаОбъекта",
				ПараметрыФормы,
				ЭтаФорма);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(ГруппаОтбора, УстанавливатьОтборПоГоловнойОрганизации, ГоловнаяОрганизация, МассивОрганизацийДляОтбора, ПоказыватьСотрудниковВАрхиве)
	
	Если УстанавливатьОтборПоГоловнойОрганизации Тогда
		
		Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ГруппаОтбора, "ГоловнаяОрганизация", ГоловнаяОрганизация);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ГруппаОтбора, "ГоловнаяОрганизация");
		Конецесли;
		
	КонецЕсли;
	
	Если ТипЗнч(МассивОрганизацийДляОтбора) = Тип("ФиксированныйМассив") Тогда
		
		Если МассивОрганизацийДляОтбора.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ГруппаОтбора, "ТекущаяОрганизация", МассивОрганизацийДляОтбора, ВидСравненияКомпоновкиДанных.ВСписке);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ГруппаОтбора, "ТекущаяОрганизация");
		КонецЕсли; 
		
	КонецЕсли; 
			
КонецПроцедуры	

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если НЕ ОтключитьОтборПоРолиСотрудника И ЗначениеЗаполнено(РольСотрудника) Тогда
		
		Если РольСотрудника = Перечисления.РолиСотрудников.Договорник Тогда
			ТекстЗаголовка = НСтр("ru = 'Договорники'");
		Иначе
			ТекстЗаголовка = НСтр("ru = 'Сотрудники'");
		КонецЕсли;
		
	Иначе
		
		ТекстЗаголовка = НСтр("ru = 'Сотрудники'");
		
	КонецЕсли; 

	Если НЕ УстанавливатьОтборПоГоловнойОрганизации И ЗначениеЗаполнено(ОрганизацияДляОтбора) Тогда
		
		ТекстЗаголовка = ТекстЗаголовка + 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" (%1)",
				ОрганизацияДляОтбора);
		
	КонецЕсли;
	
	Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоРолиСотрудника() 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПодразделению(Форма)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Форма.Список, "ТекущаяОрганизация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Форма.Список, "ТекущееПодразделение");
	
	Если НЕ Форма.ВидВсеСотрудники Тогда
		
		ВидСравненияОтбора = ?(Форма.ПоказыватьСотрудниковПодчиненныхПодразделений, ВидСравненияКомпоновкиДанных.ВИерархии, ВидСравненияКомпоновкиДанных.Равно);
		Если ТипЗнч(Форма.Элементы.Подразделения.ТекущаяСтрока) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список, "ТекущееПодразделение", Форма.Элементы.Подразделения.ТекущаяСтрока, ВидСравненияОтбора);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидСпискаСотрудников(Форма)
	
	Если Форма.ВидВсеСотрудники Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ВсеСотрудники",
			"Пометка",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ВсеСотрудникиСПодразделениями",
			"Пометка",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СотрудникиПоПодразделениям",
			"Пометка",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СотрудникиПоПодразделениямСПодразделениями",
			"Пометка",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СострудникиСтраницы",
			"ТекущаяСтраница",
			Форма.Элементы.ВсеСотрудникиСтраница);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СписокВыбрать",
			"КнопкаПоУмолчанию",
			Форма.Элементы.Список.РежимВыбора);
			
		ТекущийСписок = Форма.Элементы.Список;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ПоказыватьСотрудниковПодчиненныхПодразделений",
			"Видимость",
			Ложь);
	
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ВсеСотрудники",
			"Пометка",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ВсеСотрудникиСПодразделениями",
			"Пометка",
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СотрудникиПоПодразделениям",
			"Пометка",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СотрудникиПоПодразделениямСПодразделениями",
			"Пометка",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СострудникиСтраницы",
			"ТекущаяСтраница",
			Форма.Элементы.ПоПодразделениямСтраница);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"СписокВыбратьСПодразделениями",
			"КнопкаПоУмолчанию",
			Форма.Элементы.СписокСотрудниковБезПодразделений.РежимВыбора);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ПоказыватьСотрудниковПодчиненныхПодразделений",
			"Видимость",
			Истина);
			
		ТекущийСписок = Форма.Элементы.СписокСотрудниковБезПодразделений;
	
	КонецЕсли;
	
	Форма.ТекущийЭлемент = ТекущийСписок;
		
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПриЗакрытииНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокСотрудников", "ВидВсеСотрудники", ВидВсеСотрудники);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокСотрудников", "ГоловнаяОрганизация", ГоловнаяОрганизация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтоборПодразделений()
	
	ПоказыватьОбособленныеПодразделения = Ложь;
		 
КонецПроцедуры

&НаКлиенте
Функция ТекущийСотрудник()
	
	Если Элементы.СострудникиСтраницы.ТекущаяСтраница = Элементы.ВсеСотрудникиСтраница Тогда
		Возврат Элементы.Список.ТекущаяСтрока;
	Иначе
		Возврат Элементы.СписокСотрудниковБезПодразделений.ТекущаяСтрока;
	КонецЕсли;
	
КонецФункции





#КонецОбласти