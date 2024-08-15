# Power BI pet project

[![ru](https://img.shields.io/badge/lang-ru-green.svg)](https://github.com/DanchukIvan/contoso_pbi_project/tree/main/Other%20readme/README.ru.md)
[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/DanchukIvan/contoso_pbi_project/tree/main/README.md)

Данный репозиторий содержит исходники для дашборда, выполненного в ходе освоения :student: Power BI <img src="https://github.com/microsoft/PowerBI-Icons/blob/main/PNG/Power-BI.png"  width="2%" height="2%"> и DAX. Использованы синтетические данные, сгенерированные с помощью [Contoso Data Generator](https://github.com/sql-bi/Contoso-Data-Generator.git).

В целом дашборд насчитывает **7 страниц, 160+ мер (включая форматирующие and объектно-специфичные меры)**, а модель состоит из **20 таблиц**. Таблица фактов, вокруг которой строились расчеты, состоит из более чем **200K** строк.

Данный отчет не адаптирован под просмотр контента со смартфона.

Отчет сохраняется как проект Power Bi (формат .pbib, подробнее про него можно посмотреть [здесь](https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-overview)) для целей интеграции с git, но вы можете загрузить обычный файл .pbix и необходимые ресурсы из папки Simple pbix.

В репо представлены:

* [assets](https://github.com/DanchukIvan/contoso_pbi_project/tree/main/Simple%20pbix/Assets) - иконки, файлы графических редакторов с шаблонами подложек и готовые подложки.
* [sql queries](https://github.com/DanchukIvan/contoso_pbi_project/tree/main/SQL%20Queries) - тексты sql-запросов, использованных для создания дополнительных таблиц к сгенерированным при помощи CDG[^1]. Эти запросы написаны на диалекте MS SQL Server.
* [database backup](https://github.com/DanchukIvan/contoso_pbi_project/tree/main/SqlBackup) - дамп базы данных, сгенерированной CDG. В этом дампе отсутствуют вышеуказанные дополнительные таблицы.
* папки с префиксом *'E2E Report'* - содержат метаданные и контент проекта, представленные в человекочитаемом формате, позволяющем отслеживать изменения в отчете с помощью Git на уровне отдельных компонент.

Некоторые папки репозитория могут содержать дополнительные пояснения относительно их содержимого.

[^1]: CDG - Contoso Data Generator.
