﻿&НаКлиенте
Перем Ванесса;

&НаКлиенте
Перем МассивТипов;

&НаКлиенте
Перем МассивВидов;

&НаКлиенте
Перем КешТекущееОкно;

&НаКлиенте
Перем КешТекущийЭлементФормы;


&НаКлиенте
Функция ПолучитьИдТипа(Тип)
	ИД = МассивТипов.Найти(Тип);
	Если ИД = Неопределено Тогда
		МассивТипов.Добавить(Тип);
		Возврат МассивТипов.Количество()-1;
	Иначе
		Возврат ИД;
	КонецЕсли;	 
КонецФункции	

&НаКлиенте
Функция ПолучитьИдВида(ВидПоля)
	ИД = МассивВидов.Найти(ВидПоля);
	Если ИД = Неопределено Тогда
		МассивВидов.Добавить(ВидПоля);
		Возврат МассивВидов.Количество()-1;
	Иначе
		Возврат ИД;
	КонецЕсли;	 
КонецФункции	

&НаКлиенте
Процедура ДобавитьКонтролВДерево(ТекущийКонтрол,ЭлементДерева)
	Тип                     = ТипЗнч(ТекущийКонтрол);
	ЭлементДерева.ТипВнутр  = ПолучитьИдТипа(Тип);
	ЭлементДерева.ТипСтрока = Строка(Тип);
	
	Попытка
		ВидПоля                 = ТекущийКонтрол.Вид;
		ЭлементДерева.ВидВнутр  = ПолучитьИдВида(ВидПоля);
		ЭлементДерева.ВидСтрока = Строка(ВидПоля);
	Исключение
	КонецПопытки;
	
	Если Тип = Тип("ТестируемоеОкноКлиентскогоПриложения") Тогда
		ЭлементДерева.Синоним = ТекущийКонтрол.Заголовок;
		ЗаголовокОкна         = ТекущийКонтрол.Заголовок;
		Возврат;
	ИначеЕсли Тип = Тип("ТестируемаяФорма") Тогда
		ЭлементДерева.Имя     = ТекущийКонтрол.ИмяФормы;
		ЭлементДерева.Синоним = ТекущийКонтрол.ТекстЗаголовка;
		
		ИмяТекущейФормы       = ТекущийКонтрол.ИмяФормы;
		ЗаголовокТекущейФормы = ТекущийКонтрол.ТекстЗаголовка;

		Возврат;
	КонецЕсли;	 
	
	Попытка
		ЭлементДерева.Имя     = ТекущийКонтрол.Имя;
		ЭлементДерева.Синоним = ТекущийКонтрол.ТекстЗаголовка;
	Исключение
		ВызватьИсключение "Не смог прочитать данные контрола. " + ОписаниеОшибки();
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеФормыРекурсивно(ТекущийКонтрол,ТекЭелементДерева)
	НовыйЭлементДерева = ТекЭелементДерева.ПолучитьЭлементы().Добавить();
	ДобавитьКонтролВДерево(ТекущийКонтрол,НовыйЭлементДерева);
	
	МассивЭлементов = ТекущийКонтрол.ПолучитьПодчиненныеОбъекты();
	Для Каждого Элем Из МассивЭлементов Цикл
		ЗаполнитьДанныеФормыРекурсивно(Элем,НовыйЭлементДерева);
		//ПодчиненныйЭлементДерева = НовыйЭлементДерева.ПолучитьЭлементы().Добавить();
		//ДобавитьКонтролВДерево(Элем,ПодчиненныйЭлементДерева);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДеревоФормы()
	ТекстШагов.Очистить();
	ДеревоФормы.ПолучитьЭлементы().Очистить();
	
	КонтекстСохраняемый = Ванесса.ОбъектКонтекстСохраняемый;
	Если НЕ КонтекстСохраняемый.Свойство("ТестовоеПриложение") Тогда
		Сообщить("Не подключен TestClient.");
		Возврат;
	КонецЕсли;	
	
	Попытка
		ТекущееОкно = Ванесса.НайтиТекущееОкноTestClient();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	КешТекущееОкно = ТекущееОкно;
	КешТекущийЭлементФормы = Неопределено;
	
	ЗаполнитьДанныеФормыРекурсивно(ТекущееОкно,ДеревоФормы);
	
	ПодключитьОбработчикОжидания("ПроверкаАктивногоЭлементаОткрытойФормы",1,Ложь);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущуюФормуTestClient()
	Попытка
		ТекущееОкно = Ванесса.НайтиТекущееОкноTestClient();
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Если ТекущееОкно = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;	 
	
	Если ТекущееОкно <> КешТекущееОкно Тогда
		ЗаполнитьДеревоФормы();
	КонецЕсли;	 
	
	ФормыОкна = ТекущееОкно.НайтиОбъекты(Тип("ТестируемаяФорма"));
	Если ФормыОкна.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	ТекФорма = ФормыОкна[0];
	//если у окна несколько форм - то непонятно как определить активный элемент
	
	Возврат ТекФорма;
КонецФункции	

&НаКлиенте
Процедура НайтиВДеревеАктивныйЭлементЕслиЭтоВозможно()
	
	ТекФорма = ПолучитьТекущуюФормуTestClient();
	Если ТекФорма = Неопределено Тогда
		Возврат;
	КонецЕсли;	 
	
	Попытка
		ТекЭлемент = ТекФорма.ПолучитьТекущийЭлемент();
	Исключение
		Возврат;
	КонецПопытки;
	
	Если ТекЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТекЭлемент <> КешТекущийЭлементФормы Тогда
		КешТекущийЭлементФормы = ТекЭлемент;
		
		Попытка
			Имя = ТекЭлемент.Имя;
		Исключение
			Сообщить(ОписаниеОшибки());
			Возврат;
		КонецПопытки;
		
		СтрокаДерева = НайтиСтрокуДереваСИменемЭлемента(Имя);
		
		Если СтрокаДерева = Неопределено Тогда
			//ЗаполнитьДеревоФормы();
			Возврат;
		КонецЕсли;	
		
		Элементы.ДеревоФормы.ТекущаяСтрока = СтрокаДерева.ПолучитьИдентификатор();
		ЗаполнитьТекстШаговПоАктивномуЭлементу();
		
		Сообщить("Найден активный элемент формы <" + Имя + ">");
	КонецЕсли;	 
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаАктивногоЭлементаОткрытойФормы()
	Попытка
		НайтиВДеревеАктивныйЭлементЕслиЭтоВозможно();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Функция НайтиСтрокуДереваСИменемЭлемента(Имя)
	Результат = Неопределено;
	НайтиСтрокуДереваСИменемЭлементаРекурсивно(ДеревоФормы.ПолучитьЭлементы(),Имя,Результат);
	Возврат Результат;
КонецФункции	

&НаКлиенте
Процедура НайтиСтрокуДереваСИменемЭлементаРекурсивно(ЭлементыДерева,Имя,Результат)
	Если Результат <> Неопределено Тогда
		Возврат;
	КонецЕсли;	 
	
	Для Каждого Элем Из ЭлементыДерева Цикл
		Если Элем.Имя = Имя Тогда
			Результат = Элем;
			Возврат;
		КонецЕсли;	 
		
		НайтиСтрокуДереваСИменемЭлементаРекурсивно(Элем.ПолучитьЭлементы(),Имя,Результат)
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	МассивТипов = Новый Массив;
	МассивВидов = Новый Массив;
	Ванесса = ВладелецФормы;
	ЗаполнитьДеревоФормы();
	СкрытьДопКолонки();
	ПолучатьАктивныйЭлементИзTestClient = Истина;
КонецПроцедуры

&НаКлиенте
Функция НайтиФормуРекурсивноВДереве(ДанныеЭлемента)
	ТекРодитель = ДанныеЭлемента.ПолучитьРодителя();
	Пока Истина Цикл
		Если ТекРодитель = Неопределено Тогда
			Прервать;
		КонецЕсли;	 
		
		Если ТекРодитель.ТипВнутр = ПолучитьИдТипа(Тип("ТестируемаяФорма")) Тогда
			Возврат ТекРодитель;
		КонецЕсли;	 
		
		ТекРодитель = ТекРодитель.ПолучитьРодителя();
	КонецЦикла;	
КонецФункции	

&НаКлиенте
Процедура АктивизироватьОбъектTestClient(ДанныеЭлемента)
	Если ДанныеЭлемента = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ДанныеЭлемента.ТипВнутр = ПолучитьИдТипа(Тип("ТестируемоеОкноКлиентскогоПриложения")) Тогда
		Возврат;
	ИначеЕсли ДанныеЭлемента.ТипВнутр = ПолучитьИдТипа(Тип("ТестируемаяФорма")) Тогда
		Возврат;
	КонецЕсли;	 
	
	ТекФормаДерево  = НайтиФормуРекурсивноВДереве(ДанныеЭлемента);
	
	Попытка
		ТекОкноЭлемент = Ванесса.НайтиТекущееОкноTestClient();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Если ТекОкноЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;	 
	
	Попытка
		ВсеФормыОкна = ТекОкноЭлемент.НайтиОбъекты(Тип("ТестируемаяФорма"));
		ТекФормаЭлемент = Неопределено;
		Для Каждого ФормаОкна Из ВсеФормыОкна Цикл
			Если ФормаОкна.ИмяФормы = ТекФормаДерево.Имя Тогда
				ТекФормаЭлемент = ФормаОкна;
				Прервать;
			КонецЕсли;	 
		КонецЦикла;	
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Если ТекФормаЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;	 
	
	Попытка
		ТекЭлемент = ТекФормаЭлемент.НайтиОбъект(,,ДанныеЭлемента.Имя);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Если ТекЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Попытка
		ТекЭлемент.Активизировать();
		КешТекущийЭлементФормы = ТекЭлемент;
		ЗаполнитьТекстШаговПоАктивномуЭлементу();
	Исключение
		Возврат;
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТекстШаговПоАктивномуЭлементу()
	ТекстШагов = "";
	
	ТекущиеДанные = Элементы.ДеревоФормы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ТекФорма = ПолучитьТекущуюФормуTestClient();
	Если ТекФорма = Неопределено Тогда
		Возврат;
	КонецЕсли;	 

	ЭлементФормы = ТекФорма.НайтиОбъект(,,ТекущиеДанные.Имя);
	
	Если ЭлементФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;	 
	
	МассивШагов = Новый Массив;
	
	Если ТипЗнч(ЭлементФормы) = Тип("ТестируемоеПолеФормы") Тогда
		Вид = ЭлементФормы.Вид;
		
		Если Вид = ВидПоляФормы.ПолеВвода Тогда
			ЗначениеПоля        = ЭлементФормы.ПолучитьПредставлениеДанных();
			МассивШагов.Добавить("И элемент формы """ + ЭлементФормы.ТекстЗаголовка + """ стал равен """ + ЗначениеПоля + """");
			МассивШагов.Добавить("И элемент формы с именем """ + ЭлементФормы.Имя + """ стал равен """ + ЗначениеПоля + """");
			
			Попытка
				ТекстРедактирования = ЭлементФормы.ПолучитьТекстРедактирования();
				Если ЗначениеПоля <> ТекстРедактирования Тогда
					МассивШагов.Добавить("И у элемента формы с именем """ + ЭлементФормы.Имя + """ текст редактирования стал равен """ + ТекстРедактирования + """");
				КонецЕсли;	 
			Исключение
			КонецПопытки;
		КонецЕсли;	 
	КонецЕсли;	 
	
	Для Каждого ТекстШага Из МассивШагов Цикл
		ТекстШагов.ДобавитьСтроку(ТекстШага);
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоФормыПриАктивизацииСтроки(Элемент)
	АктивизироватьОбъектTestClient(Элементы.ДеревоФормы.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьДеревоФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьТип(Команда)
	Если Не Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыТипСтрока.Видимость  Или Команда = "Показать" Тогда
		Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыТипСтрока.Видимость = Истина;
		Элементы.ПоказатьСкрытьТип.Картинка = БиблиотекаКартинок.УстановитьФлажки;
	Иначе
		Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыТипСтрока.Видимость = Ложь;
		Элементы.ПоказатьСкрытьТип.Картинка = БиблиотекаКартинок.СнятьФлажки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьВид(Команда)
	Если Не Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыВидСтрока.Видимость  Или Команда = "Показать" Тогда
		Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыВидСтрока.Видимость = Истина;
		Элементы.ПоказатьСкрытьВид.Картинка = БиблиотекаКартинок.УстановитьФлажки;
	Иначе
		Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыВидСтрока.Видимость = Ложь;
		Элементы.ПоказатьСкрытьВид.Картинка = БиблиотекаКартинок.СнятьФлажки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкрытьДопКолонки()
	ПоказатьСкрытьТип("");
	ПоказатьСкрытьВид("");
	Элементы.ПоказатьСкрытьВсеКолонки.Картинка = БиблиотекаКартинок.УстановитьФлажки;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьВсеКолонки(Команда)

	Если Не Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыТипСтрока.Видимость Или
		 Не Элементы.ДеревоФормы.ПодчиненныеЭлементы.ДеревоФормыВидСтрока.Видимость 
		Тогда

		ПоказатьСкрытьТип("Показать");
		ПоказатьСкрытьВид("Показать");
		Элементы.ПоказатьСкрытьВсеКолонки.Картинка = БиблиотекаКартинок.СнятьФлажки;
		
	Иначе
		СкрытьДопКолонки();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОтключитьОбработчикОжидания("ПроверкаАктивногоЭлементаОткрытойФормы");
КонецПроцедуры


&НаКлиенте
Процедура ПолучитьАктивныйЭлементИзTestClientПриИзменении(Элемент)
	Если Не ПолучатьАктивныйЭлементИзTestClient Тогда
		ОтключитьОбработчикОжидания("ПроверкаАктивногоЭлементаОткрытойФормы");
	Иначе	
		ПодключитьОбработчикОжидания("ПроверкаАктивногоЭлементаОткрытойФормы",1,Ложь);
	КонецЕсли;	 
КонецПроцедуры

