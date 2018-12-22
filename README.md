# RecipePuppy
Test task for Software Station

Тестовое задание Software Station: 

Написать одноэкранное приложение, которое отображает список рецептов. Никакой поиск не нужен.

- [ ] Данные подгружаются динамически по мере скрола компонента CollectionView. Каждая ячейка содержит название рецепта, короткое описание и картинку.

1. Пагинация
2. Большой объект,  ui collection view cell
3. NSCash для картинок

- [ ] Все полученные от сервера данные сохраняются с помощью CoreData в базу и отображаются с помощью FRC на контроллере.

1. Модуль Сервера
2. Модуль БД
3. Фасад, паттерн фасад (компоновать модуль сервера и бд)
4. Fetch results controller https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller 

- [x] По тапу на ячейку показывается кастомный модальный контроллер не на весь экран, по типу https://dribbble.com/shots/3019799-Achievement-Unlocked  В контроллере отображается webview и подгружается страница рецепта.

1. Нужно создать объект popup controller
2. Метод show in view
3. От него наследую web view modal controller

- [x] Описание API: http://www.recipepuppy.com/about/api/

Язык реализации: Swift  Все должно быть сделано нативными средствами, без использование сторонних библиотек. Срок выполнения 14 дней

Фичи:
- [x] Сделать ячейки по ширине экрана
- [ ] Индикатор загрузки веб страницы
- [x] При нажатии текста не срабатывает переход
- [ ] Обновлять собачку на веб вью при появлении интернета