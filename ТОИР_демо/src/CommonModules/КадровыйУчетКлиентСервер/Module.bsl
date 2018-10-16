////////////////////////////////////////////////////////////////////////////////
// КадровыйУчетКлиентСервер: методы кадрового учета, работающие на стороне 
//							клиента и сервера.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает свойство Наименование объекту Сотрудник.
// Параметры:
//		Фамилия - Строка - фамилия, 
//		Имя - Строка - Имя, 
//		Отчество - Строка - отчество,
//		УточнениеНаименованияФизЛица - Строка - строка, дополняющая имя физ. лица.
//		УточнениеНаименованияСотрудника - Строка - строка, дополняющая имя сотрудника.
// Возвращаемое значение:
//		Строка - полное наименование сотрудника.
Функция ПолноеНаименованиеСотрудника(Фамилия, Имя, Отчество, УточнениеНаименованияФизЛица, УточнениеНаименованияСотрудника = "") Экспорт
	
	ПолноеНаименование = Фамилия;
	
	Если ЗначениеЗаполнено(Имя) Тогда
		ПолноеНаименование = ПолноеНаименование + " " + Имя;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчество) Тогда
		ПолноеНаименование = ПолноеНаименование + " " + Отчество;
	КонецЕсли;
	Если ЗначениеЗаполнено(УточнениеНаименованияФизЛица) Тогда
		ПолноеНаименование = ПолноеНаименование + " " + УточнениеНаименованияФизЛица;
	КонецЕсли;
		
	Возврат ПолноеНаименование;
	
КонецФункции

#КонецОбласти