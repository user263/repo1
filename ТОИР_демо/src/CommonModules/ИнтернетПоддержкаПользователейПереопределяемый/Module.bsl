
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Определяет имя текущей программы, по которому программа идентифицируется в
// сервисах Интернет-поддержки.
//
// Параметры:
//	ИмяПрограммы - Строка - в параметре возвращается уникальное имя программы в
//		сервисах Интернет-поддержки.
//
// Пример:
//	ИмяПрограммы = "Trade";
//
Процедура ПриОпределенииИмениПрограммы(ИмяПрограммы) Экспорт
	
	ИмяПрограммы = "TOIR20";
	
КонецПроцедуры

// В процедуре заполняется код языка интерфейса конфигурации (Метаданные.Языки),
// который передается сервисам Интернет-поддержки.
// Код языка заполняется в формате ISO-639-1.
// Если коды языков интерфейса конфигурации определены в формате ISO-639-1,
// тогда тело метода заполнять не нужно.
//
// Параметры:
//	КодЯзыка - Строка - в параметре передается код языка, указанный в
//		Метаданные.Языки;
//	КодЯзыкаВФорматеISO639_1 - Строка - в параметре возвращается
//		код языка в формате ISO-639-1.
//
// Пример:
//	Если КодЯзыка = "rus" Тогда
//		КодЯзыкаВФорматеISO639_1 = "ru";
//	ИначеЕсли КодЯзыка = "english" Тогда
//		КодЯзыкаВФорматеISO639_1 = "en";
//	КонецЕсли;
//
Процедура ПриОпределенииКодаЯзыкаИнтерфейсаКонфигурации(КодЯзыка, КодЯзыкаВФорматеISO639_1) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытийБиблиотеки

// Реализует обработку события сохранения в информационной базе данных
// аутентификации пользователя Интернет-поддержки - логина и пароля
// для подключения к сервисам Интернет-поддержки.
//
// Параметры:
//	ДанныеПользователя - Структура - структура с полями:
//		* Логин - Строка - логин пользователя;
//		* Пароль - Строка - пароль пользователя;
//
Процедура ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	
	
КонецПроцедуры

// Реализует обработку события удаления из информационной базы данных
// аутентификации пользователя Интернет-поддержки - логина и пароля
// для подключения к сервисам Интернет-поддержки.
//
Процедура ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки() Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеВерсииИБ

// Процедура вызывается при первом запуске библиотеки БИП.
// Процедура - для общих данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбщиеДанные_ПервыйЗапуск() Экспорт

КонецПроцедуры

// Процедура вызывается при первом запуске библиотеки БИП.
// Процедура - для каждой области данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбластьДанных_ПервыйЗапуск() Экспорт

КонецПроцедуры

// Процедура вызывается при обновлении библиотеки БИП на любую новую версию.
// Процедура - для общих данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбщиеДанные_ПерейтиНаВерсию() Экспорт

КонецПроцедуры

// Процедура вызывается при обновлении библиотеки БИП на любую новую версию.
// Процедура - для каждой области данных.
//
Процедура ОбновлениеИнформационнойБазы_ОбластьДанных_ПерейтиНаВерсию() Экспорт

КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Будет удалена в следующей редакции библиотеки, т.к. процедура
// не распространяет свое действие на все подсистемы библиотеки.
// Вместо этой процедуры необходимо использовать процедуры:
//    МониторИнтернетПоддержкиПереопределяемый.ИспользоватьМониторИнтернетПоддержки();
//    Подключение1СТакскомПереопределяемый.ИспользоватьСервис1СТакском().
// если в конфигурацию внедрены соответствующие подсистемы.
//
// Переопределяет возможность использования механизма Интернет-поддержки:
// монитор Интернет-поддержки, авторизация/регистрация в сервисе
// Интернет-поддержки, получение уникального идентификатора абонента
// электронного документооборота, вход в личный кабинет абонента электронного
// документооборота.
//
// Использование Интернет-поддержки запрещено при работе в модели сервиса.
// Процедура вызывается для дополнительной проверки разрешения при работе в
// локальном режиме.
//
// Для запрета использования функций Интернет-поддержки необходимо присвоить
// параметру Отказ значение Истина.
// 
// Параметры:
//	Отказ - Булево - Истина, использование Интернет-поддержки запрещено;
//		Ложь - в противном случае;
//		Значение по умолчанию - Ложь;
//
// Пример:
//	Если <Выражение> Тогда
//		Отказ = Истина;
//	КонецЕсли;
//
Процедура ИспользоватьИнтернетПоддержку(Отказ) Экспорт
	
	
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции библиотеки.
// Необходимо отказаться от использования этой процедуры.
// Вызывается перед авторизацией пользователя в Интернет-поддержке
// пользователей для определения данных текущего пользователя, если
// логин и пароль не указаны.
// Процедура используется ТОЛЬКО, если необходимо переопределить логин и пароль
// неавторизованного пользователя, например, на основе логина и пароля
// пользователя сервера обновлений или каким-либо другим способом.
//
// Параметры:
//	ДанныеПользователя - Структура - выходной параметр - структура, заполняемая
//			данными о пользователе Интернет-поддержки:
//		* Логин - Строка - логин пользователя;
//		* Пароль - Строка - пароль пользователя;
//
// Пример:
//	// Получение логина и пароля пользователя Интернет-поддержки
//	// из настроек пользователя сервера обновлений для конфигураций со встроенной
//	// библиотекой "Библиотека стандартных подсистем" (БСП):
//
//	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
//		"ОбновлениеКонфигурации", 
//		"НастройкиОбновленияКонфигурации"
//	);
//
//	Если Настройки = Неопределено Тогда
//		Возврат;
//	Иначе
//		ДанныеПользователя.Вставить("Логин" , Настройки.КодПользователяСервераОбновлений);
//		ДанныеПользователя.Вставить("Пароль", Настройки.ПарольСервераОбновлений);
//	КонецЕсли;
//
Процедура ПриОпределенииДанныхПользователяИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции библиотеки.
// Следует использовать метод ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки().
// Вызывается при успешной авторизации пользователя в Интернет-поддержке
// пользователей после ввода пользователем правильного логина и пароля.
// При необходимости процедура может быть использована для сохранения логина и
// пароля пользователя в смежных механизмах.
// Заполнение процедуры требуется ТОЛЬКО при необходимости переопределения
// обработки входа пользователя в Интернет-поддержку.
//
// Параметры:
//	ДанныеПользователя - Структура - структура с полями:
//		* Логин - Строка - логин пользователя;
//		* Пароль - Строка - пароль пользователя;
//
Процедура ПриАвторизацииПользователяВИнтернетПоддержке(ДанныеПользователя) Экспорт
	
	
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции библиотеки.
// Следует использовать метод ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки().
// Вызывается при выходе пользователя из Интернет-поддержки
// (нажатие пользователем кнопки "Выход" на форме Интернет-поддержки).
//
// Заполнение процедуры требуется ТОЛЬКО при необходимости переопределить
// обработку выхода пользователя из Интернет-поддержки пользователей.
// При необходимости может быть использована для обновления данных пользователя
// в смежных механизмах.
//
// Пример:
//	// Очистка логина и пароля пользователя Интернет-поддержки
//	// в настройках пользователя сервера обновлений для конфигураций со встроенной
//	// библиотекой "Библиотека стандартных подсистем" (БСП):
//
//	НастройкиОбновленияКонфигурации = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
//		"ОбновлениеКонфигурации",
//		"НастройкиОбновленияКонфигурации"
//	);
//
//	Если НастройкиОбновленияКонфигурации <> Неопределено Тогда
//		НастройкиОбновленияКонфигурации.Вставить("КодПользователяСервераОбновлений" , "");
//		НастройкиОбновленияКонфигурации.Вставить("ПарольСервераОбновлений"          , "");
//		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
//			"ОбновлениеКонфигурации", 
//			"НастройкиОбновленияКонфигурации",
//			НастройкиОбновленияКонфигурации);
//	КонецЕсли;
//
Процедура ПриВыходеПользователяИзИнтернетПоддержки() Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
