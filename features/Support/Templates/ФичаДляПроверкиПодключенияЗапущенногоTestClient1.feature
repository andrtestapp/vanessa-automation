# language: ru
# encoding: utf-8
#parent ua:
@UA26_Макеты_для_проверки_test_client
#parent uf:
@UF9_Вспомогательные_фичи

@IgnoreOnCIMainBuild
@Тест

Функциональность: ФичаДляПроверкиПодключенияЗапущенногоTestClient1
 

Сценарий: Для ФичаДляПроверкиПодключенияЗапущенногоTestClient
	Когда Я подключаю уже запущенный клиент тестирования с параметрами:
		| 'Имя подключения'                                                     | 'Порт' |
		| 'ПроверкаШагаЯПодключаюУжеЗапущенныйКлиентТестированияСПараметрами'   | '111'  |
