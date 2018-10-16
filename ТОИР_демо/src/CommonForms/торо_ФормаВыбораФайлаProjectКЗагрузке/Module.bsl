
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПутьКЗагружаемомуФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Каталог = "c:\ProjectIntegration\";
	ДиалогОткрытияФайла.Фильтр = ФильтрЗагружаемыхФайлов();
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите загружаемый проект:'");
	
	ПутьКЗагружаемомуФайлу = "";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ПутьКЗагружаемомуФайлу = ДиалогОткрытияФайла.ПолноеИмяФайла;
	Иначе
		СП = Новый СообщениеПользователю;
		СП.Текст = НСтр("ru = 'Проект не выбран'");
		СП.Поле = "ПутьКЗагружаемомуФайлу";
		СП.УстановитьДанные(ЭтотОбъект);
		СП.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	Если ПутьКЗагружаемомуФайлу <> "" Тогда
		ЭтотОбъект.Закрыть(ПутьКЗагружаемомуФайлу);
	Иначе
		СП = Новый СообщениеПользователю;
		СП.Текст = НСтр("ru = 'Файл не выбран.'");
		СП.Поле = "ПутьКЗагружаемомуФайлу";
		СП.УстановитьДанные(ЭтотОбъект);
		СП.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ФильтрЗагружаемыхФайлов()
	
	Возврат НСтр("ru = 'Все файлы (*.mpp; *.xml)|*.mpp;*.xml|'")
	      + НСтр("ru = 'Файлы MS Project (*.mpp)|*.mpp|'")
	      + НСтр("ru = 'Файлы обмена XML (*.xml)|*.xml|'");
	
КонецФункции

#КонецОбласти
