# RetailAnalytics

## Contents

1. [Chapter I](#chapter-i) \
   1.1. [Introduction](#introduction)
2. [Chapter II](#chapter-ii) \
   2.1. [Information](#information)
3. [Chapter III](#chapter-iii) \
   3.1. [Part 1. Создание базы данных](#part-1-создание-базы-данных)  
   3.2. [Part 2. Создание представлений](#part-2-создание-представлений)  

## Chapter I

## Introduction

В данном проекте создана база данных со знаниями о клиентах розничных сетей, а также написаны представления и процедуры, необходимые для создания персональных предложений.

## Chapter II

## Logical view of database model

Данные, описанные в таблицах из раздела [Входные данные](#входные-данные) заполняются пользователем.

Данные, описанные в представлениях из раздела [Выходные данные](#выходные-данные) вычисляются программно. \
Более подробное описание для заполнения этих представлений будет дано ниже.

### Входные данные

#### Таблица Персональные данные

| **Поле**                    | **Название поля в системе** | **Формат / возможные значения**                                                  | **Описание** |
|:---------------------------:|:---------------------------:|:--------------------------------------------------------------------------------:|:------------:|
| Идентификатор клиента       | Customer_ID                 | ---                                                                              | ---          |
| Имя                         | Customer_Name               | Кириллица или латиница, первая буква заглавная, остальные прописные, допустимы тире и пробелы | ---          |
| Фамилия                     | Customer_Surname            | Кириллица или латиница, первая буква заглавная, остальные прописные, допустимы тире и пробелы | ---          |
| E-mail клиента              | Customer_Primary_Email      | Формат E-mail                                                                    | ---          |
| Телефон клиента             | Customer_Primary_Phone      | +7 и 10 арабских цифр                                                                 | ---          |

#### Таблица Карты

| **Поле**              | **Название поля в системе** | **Формат / возможные значения** | **Описание**                                     |
|:---------------------:|:---------------------------:|:-------------------------------:|:------------------------------------------------:|
| Идентификатор карты   | Customer_Card_ID            | ---                             | ---                                              |
| Идентификатор клиента | Customer_ID                 | ---                             | Одному клиенту может принадлежать несколько карт |

#### Таблица Транзакции

| **Поле**                 | **Название поля в системе** | **Формат / возможные значения** | **Описание**                                                          |
|:------------------------:|:---------------------------:|:-------------------------------:|:---------------------------------------------------------------------:|
| Идентификатор транзакции | Transaction_ID              | ---                             | Уникальное значение                                                   |
| Идентификатор карты      | Customer_Card_ID            | ---                             | ---                                                                   |
| Сумма транзакции         | Transaction_Summ            | Арабская цифра                  | Сумма транзакции в рублях (полная стоимость покупки без учета скидок) |
| Дата транзакции          | Transaction_DateTime        | дд.мм.гггг чч:мм:сс             | Дата и время совершения транзакции                                    |
| Торговая точка           | Transaction_Store_ID        | Идентификатор магазина          | Магазин, в котором была совершена транзакция                          |

#### Таблица Чеки

| **Поле**                            | **Название поля в системе** | **Формат / возможные значения** | **Описание**                                                                                            |
|:-----------------------------------:|:---------------------------:|:-------------------------------:|:-------------------------------------------------------------------------------------------------------:|
| Идентификатор транзакции            | Transaction_ID              | ---                             | Идентификатор транзакции указывается для всех позиций в чеке                                            |
| Позиция в чеке                      | SKU_ID                      | ---                             | ---                                                                                                     |
| Количество штук или килограмм       | SKU_Amount                  | Арабская цифра                  | Указание, какое количество товара было куплено                                                          |
| Сумма, на которую был куплен товар  | SKU_Summ                    | Арабская цифра                  | Сумма покупки фактического объема данного товара в рублях (полная стоимость без учета скидок и бонусов) |
| Оплаченная стоимость покупки товара | SKU_Summ_Paid               | Арабская цифра                  | Фактически оплаченная сумма покупки данного товара, не включая сумму предоставленной скидки             |
| Предоставленная скидка              | SKU_Discount                | Арабская цифра                  | Размер предоставленной на товар скидки в рублях                                                         |

#### Таблица Товарная матрица

| **Поле**                    | **Название поля в системе** | **Формат / возможные значения**        | **Описание**                                                                                                                                                                                                 |
|:---------------------------:|:---------------------------:|:--------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Идентификатор товара        | SKU_ID                      | ---                                    | ---                                                                                                                                                                                                          |
| Название товара             | SKU_Name                    | Кириллица или латиница, арабские цифры, спецсимволы | ---                                                                                                                                                                                                          |
| Группа SKU                  | Group_ID                    | ---                                    | Идентификатор группы родственных товаров, к которой относится товар (например, одинаковые йогурты одного производителя и объема, но разных вкусов). Указывается один идентификатор для всех товаров в группе |

#### Таблица Торговые точки

| **Поле**                    | **Название поля в системе** | **Формат / возможные значения** | **Описание**                                                   |
|:---------------------------:|:---------------------------:|:-------------------------------:|:--------------------------------------------------------------:|
| Торговая точка              | Transaction_Store_ID        | ---                             | ---                                                            |
| Идентификатор товара        | SKU_ID                      | ---                             | ---                                                            |
| Закупочная стоимость товара | SKU_Purchase_Price          | Арабская цифра                  | Закупочная стоимость товара для данного магазина               |
| Розничная стоимость товара  | SKU_Retail_Price            | Арабская цифра                  | Стоимость продажи товара без учета скидок для данного магазина |

#### Таблица Группы SKU

| **Поле**                    | **Название поля в системе** | **Формат / возможные значения**        | **Описание** |
|:---------------------------:|:---------------------------:|:--------------------------------------:|:------------:|
| Группа SKU                  | Group_ID                    | ---                                    | ---          |
| Название группы             | Group_Name                  | Кириллица или латиница, арабские цифры, спецсимволы | ---          |

#### Таблица Дата формирования анализа

| **Поле**                    | **Название поля в системе** | **Формат / возможные значения**        | **Описание** |
|:---------------------------:|:---------------------------:|:--------------------------------------:|:------------:|
| Дата формирования анализа                  | Analysis_Formation                    | дд.мм.гггг чч:мм:сс                                    | ---          |

### Выходные данные

#### Представление Клиенты

| **Поле**                                    | **Название поля в системе**    | **Формат / возможные значения**  | **Описание**                                                                  |
|:-------------------------------------------:|:------------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------:|
| Идентификатор клиента                       | Customer_ID                    | ---                              | Уникальное значение                                                           |
| Значение среднего чека                      | Customer_Average_Check         | Арабская цифра, десятичная дробь | Значение среднего чека клиента в рублях за анализируемый период               |
| Сегмент по среднему чеку                    | Customer_Average_Check_Segment | Высокий; Средний; Низкий         | Описание сегмента                                                             |
| Значение частоты транзакций                 | Customer_Frequency             | Арабская цифра, десятичная дробь | Значение частоты визитов клиента в среднем количестве дней между транзакциями |
| Сегмент по частоте транзакций               | Customer_Frequency_Segment     | Часто; Средне; Редко             | Описание сегмента                                                             |
| Количество дней после предыдущей транзакции | Customer_Inactive_Period       | Арабская цифра, десятичная дробь | Количество дней, прошедших с даты предыдущей транзакции клиента               |
| Коэффициент оттока                          | Customer_Churn_Rate            | Арабская цифра, десятичная дробь | Значение коэффициента оттока клиента                                          |
| Сегмент по коэффициенту оттока              | Customer_Churn_Segment         | Высокий; Средний; Низкий         | Описание сегмента                                                             |
| Номер сегмента                              | Customer_Segment               | Арабская цифра                   | Номер сегмента, к которому принадлежит клиент                                 |
| Идентификатор основного магазина            | Customer_Primary_Store         | ---                              | ---                                                                           |

#### Представление История покупок

| **Поле**                        | **Название поля в системе** | **Формат / возможные значения**  | **Описание**                                                                                                                                                                                                 |
|:-------------------------------:|:---------------------------:|:--------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Идентификатор клиента           | Customer_ID                 | ---                              | ---                                                                                                                                                                                                          |
| Идентификатор транзакции        | Transaction_ID              | ---                              | ---                                                                                                                                                                                                          |
| Дата транзакции                 | Transaction_DateTime        | гггг-мм-ддTчч:мм:сс.0000000      | Дата совершения транзакции                                                                                                                                                                                   |
| Группа SKU                      | Group_ID                    | ---                              | Идентификатор группы родственных товаров, к которой относится товар (например, одинаковые йогурты одного производителя и объема, но разных вкусов). Указывается один идентификатор для всех товаров в группе |
| Себестоимость                   | Group_Cost                  | Арабская цифра, десятичная дробь | ---                                                                                                                                                                                                          |
| Базовая розничная стоимость     | Group_Summ                  | Арабская цифра, десятичная дробь | ---                                                                                                                                                                                                          |
| Фактически оплаченная стоимость | Group_Summ_Paid             | Арабская цифра, десятичная дробь | ---                                                                                                                                                                                                          |

#### Представление Периоды

| **Поле**                            | **Название поля в системе** | **Формат / возможные значения**  | **Описание**                                                                                                                                                                                                 |
|:-----------------------------------:|:---------------------------:|:--------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Идентификатор клиента               | Customer_ID                 | ---                              | ---                                                                                                                                                                                                          |
| Идентификатор группы SKU            | Group_ID                    | ---                              | Идентификатор группы родственных товаров, к которой относится товар (например, одинаковые йогурты одного производителя и объема, но разных вкусов). Указывается один идентификатор для всех товаров в группе |
| Дата первой покупки группы          | First_Group_Purchase_Date   | гггг-мм-ддTчч:мм:сс.0000000      | ---                                                                                                                                                                                                          |
| Дата последней покупки группы       | Last_Group_Purchase_Date    | гггг-мм-ддTчч:мм:сс.0000000      | ---                                                                                                                                                                                                          |
| Количество транзакций с группой     | Group_Purchase              | Арабская цифра, десятичная дробь | ---                                                                                                                                                                                                          |
| Интенсивность покупок группы        | Group_Frequency             | Арабская цифра, десятичная дробь | ---                                                                                                                                                                                                          |
| Минимальный размер скидки по группе | Group_Min_Discount          | Арабская цифра, десятичная дробь | ---                                                                                                                                                                                                          |

#### Представление Группы

| **Поле**                   | **Название поля в системе** | **Формат / возможные значения**  | **Описание**                                                                                                                        |
|:--------------------------:|:---------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------:|
| Идентификатор клиента      | Customer_ID                 | ---                              | ---                                                                                                                                 |
| Идентификатор группы       | Group_ID                    | ---                              | ---                                                                                                                                 |
| Индекс востребованности    | Group_Affinity_Index        | Арабская цифра, десятичная дробь | Коэффициент востребованности данной группы клиентом                                                                                 |
| Индекс оттока              | Group_Churn_Rate            | Арабская цифра, десятичная дробь | Индекс оттока клиента по конкретной группе                                                                                          |
| Индекс стабильности        | Group_Stability_Index       | Арабская цифра, десятичная дробь | Показатель, демонстрирующий стабильность потребления группы клиентом                                                                |
| Актуальная маржа по группе | Group_Margin                | Арабская цифра, десятичная дробь | Показатель актуальной маржи по группе для конкретного клиента                                                                       |
| Доля транзакций со скидкой | Group_Discount_Share        | Арабская цифра, десятичная дробь | Доля транзакций по покупке группы клиентом, в рамках которых были применена скидка (без учета списания бонусов программы лояльности) |
| Минимальный размер скидки  | Group_Minimum_Discount      | Арабская цифра, десятичная дробь | Минимальный размер скидки, зафиксированный для клиента по группе                                                                    |
| Средний размер скидки      | Group_Average_Discount      | Арабская цифра, десятичная дробь | Средний размер скидки по группе для клиента                                                                                         |


## Chapter III

## Part 1. Создание базы данных

Напиши скрипт *part1.sql*, создающий базу данных и таблицы, описанные выше в разделе [входные данные](#входные-данные).

Также внеси в скрипт процедуры, позволяющие импортировать и экспортировать данные для каждой таблицы из файлов/в файлы с расширением *.csv* и *.tsv*. \
В качестве параметра каждой процедуры для импорта из *csv* файла указывается разделитель.

В каждую из таблиц внеси как минимум по 5 записей.
По мере выполнения задания тебе потребуются новые данные, чтобы проверить все варианты работы.
Эти новые данные также должны быть добавлены в этом скрипте. \
Некоторые тестовые данные могут быть найдены в папке *datasets*.

Если для добавления данных в таблицы использовались *csv* или *tsv* файлы, они также должны быть выгружены в GIT репозиторий.

## Part 2. Создание представлений

Создай скрипт *part2.sql*, в котором напиши представления, описанные выше в разделе [выходные данные](#выходные-данные).
Также внеси в скрипт тестовые запросы для каждого представления. Допустимо для каждого представления создавать отдельный скрипт, начинающийся с *part2_*.

Более подробную информацию для получения каждого поля можно найти в папке materials.

