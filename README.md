# ETL-dwh

--ETL-процесс от базы данных исчточника AdventureWorks2019 в систему dwh через staging area (stg) и слой хранения оперативных данных (ods).

[1. Извлекаем данные из базы данных источника и загружаем в слой храннения данных (Staging area [stg]]( https://github.com/kirillnovoselov/ETL-dwh/blob/main/1.%20Extract_DataSourceToStg.sql)

[2. Трансформируем данные и загружаем в слой хранения оперативных данных [ods]. Трансформируем данные по схеме "звезда" и создаем таблицу фактов и измерений.](https://github.com/kirillnovoselov/ETL-dwh/blob/main/2.%20Transform_StgToOds.sql)
