////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура Обмен_mobile_ЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("mobile", Источник, Отказ);
КонецПроцедуры

Процедура Обмен_mobile_ЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("mobile", Источник, Отказ,Замещение);
КонецПроцедуры

#КонецОбласти
