////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентСерверВнутренний: методы, обслуживающие работу формы сотрудника
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами

// Частный случай формы сотрудников.
// Параметры:
// 	ИмяОткрываемойФормы - Строка - имя открываемой формы. 
// Возвращаемое значение:
//		Структура - описание формы.	
//
Функция ОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	Возврат СотрудникиКлиентСерверРасширенный.ОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
	
КонецФункции

#КонецОбласти