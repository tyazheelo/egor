## 📄 Лабораторной работа №6

## 📱 Описание проекта

Данная лабораторная работа выполнена в рамках дисциплины **"Технологии программирования для мобильных приложений"** студентом 2 курса специальности "Прикладная информатика".

В ходе работы было разработано **5 мобильных приложений** для iOS с использованием различных технологий и подходов:

| № | Приложение | Технологии | Язык |
|---|------------|------------|------|
| 1 | Background Switcher | UIKit, Interface Builder | Swift |
| 2 | City Weather & Library Info | UIKit, Interface Builder, Localization | Objective-C |
| 3 | Body Calculator | UIKit, AutoLayout, Localization | Swift |
| 4 | RGBullsEye | SwiftUI, @State, @Binding | Swift |
| 5 | Two-Scene Volume Calculator | UIKit, AutoLayout, StackView, Localization | Swift |

## 📝 Контрольные вопросы

### Вопросы по разработке

<details>
<summary><b>1. Как зарегистрироваться как разработчик Apple и добавить идентификатор организации?</b></summary>

1. Перейти на сайт [developer.apple.com](https://developer.apple.com)
2. Войти с Apple ID (или создать новый)
3. Нажать "Join the Apple Developer Program"
4. Оплатить годовую подписку ($99)
5. В Xcode: Preferences → Accounts → Добавить Apple ID
6. Для добавления Identifier: Certificates, Identifiers & Profiles → Identifiers → "+"
7. Ввести название и Bundle ID (например, dev.name.*)
</details>

<details>
<summary><b>2. Как добавить элементы управления на экран (контроллер)?</b></summary>

Через Interface Builder (Main.storyboard):
1. Открыть библиотеку объектов (значок "+" или Cmd+Shift+L)
2. Найти нужный элемент (Label, Button, TextField, Switch)
3. Перетащить элемент на сцену контроллера
4. Расположить и настроить размеры
</details>

<details>
<summary><b>3. Какие типы элементов управления есть в библиотеке объектов Xcode?</b></summary>

- **Label** — текстовая надпись
- **Button** — кнопка
- **TextField** — поле ввода текста
- **TextView** — многострочное текстовое поле
- **Switch** — переключатель (вкл/выкл)
- **Slider** — ползунок
- **SegmentedControl** — сегментированный контрол
- **ImageView** — отображение изображений
- **TableView** — таблица
- **CollectionView** — коллекция
- **PickerView** — выбор значения
- **ProgressView** — индикатор прогресса
- **ActivityIndicator** — индикатор загрузки
</details>

<details>
<summary><b>4. Что такое IBOutlet?</b></summary>

`IBOutlet` — это аннотация, которая связывает элемент интерфейса (созданный в Interface Builder) с переменной в коде. Позволяет программно изменять свойства элемента (текст, цвет, состояние и т.д.).

```swift
@IBOutlet weak var myLabel: UILabel!
```
</details>

<details>
<summary><b>5. Что такое IBAction?</b></summary>

`IBAction` — это аннотация, которая связывает событие элемента интерфейса (например, нажатие кнопки) с методом в коде. Метод выполняется при возникновении события.

```swift
@IBAction func buttonTapped(_ sender: UIButton) {
    print("Button was tapped")
}
```
</details>

<details>
<summary><b>6. Опишите способы создания IBOutlet и IBAction?</b></summary>

**Способ 1 (через Assistant Editor):**
1. Открыть Main.storyboard и ViewController.swift в Assistant Editor
2. Зажать Ctrl и перетащить элемент в код
3. Выбрать Outlet (для IBOutlet) или Action (для IBAction)
4. Ввести имя и нажать Connect

**Способ 2 (вручную):**
1. Написать в коде: `@IBOutlet weak var ...`
2. Вернуться в storyboard, открыть Connections Inspector
3. Перетащить от кружка к элементу на сцене
</details>

<details>
<summary><b>7. Из каких компонент состоит графический интерфейс программ на Objective-C?</b></summary>

- **UIWindow** — контейнер верхнего уровня
- **UIViewController** — контроллер, управляющий экраном
- **UIView** — базовый элемент для отображения
- **Subviews** — дочерние элементы (кнопки, метки и т.д.)
- **AutoLayout Constraints** — правила позиционирования
- **Storyboard/XIB** — файлы интерфейса
</details>

<details>
<summary><b>8. Что такое Outline View и Canvas в контексте Interface Builder?</b></summary>

- **Outline View** — левая панель в Interface Builder, отображающая иерархию всех элементов на сцене (контроллеры, вью, констрейнты)
- **Canvas** — центральная область, где визуально отображается интерфейс приложения. Позволяет перетаскивать элементы и настраивать их расположение
</details>

<details>
<summary><b>9. Что такое AutoLayout и Safe area?</b></summary>

**AutoLayout** — система автоматического позиционирования элементов относительно друг друга и границ экрана. Позволяет создавать адаптивные интерфейсы, которые корректно отображаются на разных устройствах и ориентациях.

**Safe Area** — область экрана, которая не перекрывается системными элементами (статус-бар, динамический остров, индикатор home). Позволяет размещать контент в видимой области.
</details>

<details>
<summary><b>10. Что такое scene, container, relationship connection, segue?</b></summary>

- **Scene** — экран/сцена в приложении (контроллер + его вью)
- **Container** — контейнерный контроллер (Navigation Controller, Tab Bar Controller)
- **Relationship connection** — связь между container'ом и его child контроллерами
- **Segue** — переход между сценами (show, modal, popover и т.д.)
</details>

<details>
<summary><b>11. Что такое StackView и constraints?</b></summary>

**UIStackView** — контейнер, который автоматически располагает свои дочерние элементы горизонтально или вертикально. Упрощает создание адаптивных интерфейсов без множества констрейнтов.

**Constraints** — правила AutoLayout, определяющие позицию и размер элементов относительно других элементов или границ экрана.
</details>

<details>
<summary><b>12. В чем отличие между UIKit и SwiftUI?</b></summary>

| Характеристика | UIKit | SwiftUI |
|----------------|-------|---------|
| Парадигма | Императивная | Декларативная |
| Год выпуска | 2007 | 2019 |
| Язык | Objective-C / Swift | Swift |
| Управление состоянием | Delegates, Targets | @State, @Binding, @ObservedObject |
| Код интерфейса | Storyboard/XIB или программно | Декларативный Swift код |
| Адаптация | AutoLayout | Автоматическая |
| Preview | Нет (только при запуске) | Живой превью в Canvas |
| Объём кода | Больше | Меньше (~30-50%) |
</details>

## 👤 Автор

| Поле | Значение |
|------|----------|
| **Имя** | Жук Егор |
| **Группа** | 12 |
| **Курс** | 2 курс |
| **Специальность** | Прикладная информатика |
| **Дисциплина** | Технологии программирования для мобильных приложений |
