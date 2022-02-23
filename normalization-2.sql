-- вторая нормальная форма: одна таблица - один объект

-- объекты (помимо breed):
--  animal_id - идентификатор животного (связан с нидексом записи)
--  animal_type - тип животного (связан с animal_id)
--  name - кличка (свян с индексом записи)
--  color - цвет (связан с индексом записи)
--  date_of_birth - дата рождения (связан с animal_id)
--  outcome_subtype - тип программы (связан с индексом записи)
--  outcome_type - текущее состояние животного (связан с индексом записи)
--  outcome_data - информация о прибытии ([возраст на момент прибытия, месяц и год прибытия] связан с индексом записи)

-- [animal_id] содание связи с индексом записи (список идентификаторов уже создан в рамказ 1НФ)

CREATE TABLE link_animal_id_animals_index
(
    id INTEGER PRIMARY KEY,
    animal_id INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animal_id_list(id)
);

-- заполнение таблицы

INSERT INTO link_animal_id_animals_index
SELECT animals."index", animal_id_list.id FROM animals
INNER JOIN animal_id_list ON animals.animal_id = animal_id_list.animal_id;

-- [animal_type] новая таблица - список типов животных

CREATE TABLE animal_type_list
(
    id INTEGER PRIMARY KEY autoincrement,
    animal_type VARCHAR (20) NOT NULL
);

-- заполнение списка типов пород

INSERT INTO animal_type_list (animal_type)
SELECT DISTINCT animal_type FROM animals;

-- создание промежутчной таблицы для связывания типа животного и его идентификатора

CREATE TABLE link_animal_type_animal_id
(
    animal_id INTEGER,
    animal_type INTEGER,
    PRIMARY KEY (animal_type, animal_id),
    FOREIGN KEY (animal_id) REFERENCES animal_id_list(id),
    FOREIGN KEY (animal_type) REFERENCES animal_type_list(id)
);

-- заполнение промежуточной таблицы

INSERT INTO link_animal_type_animal_id (animal_id, animal_type)
SELECT DISTINCT animal_id_list.id, animal_type_list.id FROM animals
LEFT JOIN animal_id_list ON TRIM(animals.animal_id) = animal_id_list.animal_id
INNER JOIN animal_type_list ON TRIM(animals.animal_type) = animal_type_list.animal_type;

-- [name] новая таблица - список имён животных

CREATE TABLE name_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR (30)
);

-- заполнение списка имён

INSERT INTO name_list (name)
SELECT DISTINCT TRIM(name) FROM animals WHERE name IS NOT NULL;

-- создание промежуточной таблицы для связи имени и индекса записи

CREATE TABLE link_name_animals_index
(
    id INTEGER PRIMARY KEY,
    name INTEGER,
    FOREIGN KEY (name) REFERENCES name_list(id)
);

-- заполнение промежуточной таблицы

INSERT INTO link_name_animals_index
SELECT animals."index", name_list.id FROM animals
INNER JOIN name_list ON TRIM(animals.name) = name_list.name;

-- [color] новая таблица - список цветов

CREATE TABLE color_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    color1 VARCHAR (30),
    color2 VARCHAR (30)
);

-- заполнение списка цветов

INSERT INTO color_list (color1, color2)
SELECT DISTINCT color1, color2 FROM animals WHERE color1 IS NOT NULL;

-- создание промежуточной таблицы для связи цвета с индексом записи

CREATE TABLE link_color_animals_index
(
    id INTEGER PRIMARY KEY,
    color INTEGER,
    FOREIGN KEY (color) REFERENCES color_list(id)
);

-- заполнение промежуточной таблицы для одного цвета и для комбинированного

INSERT INTO link_color_animals_index
SELECT animals."index", color_list.id FROM animals
INNER JOIN color_list ON animals.color1 = color_list.color1 WHERE animals.color2 IS NULL AND color_list.color2 IS NULL;

INSERT INTO link_color_animals_index
SELECT animals."index", color_list.id FROM animals
INNER JOIN color_list ON (animals.color1 || animals.color2) = (color_list.color1 || color_list.color2)
WHERE animals.color2 IS NOT NULL;

-- [date_of_birth] новая таблица - дата рождения животного

CREATE TABLE date_of_birth_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_of_birth DATE
);

-- заполнение списка дат рождения

INSERT INTO date_of_birth_list (date_of_birth)
SELECT DISTINCT date_of_birth FROM animals WHERE date_of_birth IS NOT NULL;

-- создание промежуточной таблицы для связи даты рождения с animal_id

CREATE TABLE link_date_of_birth_animal_id
(
    animal_id INTEGER,
    date_of_birth INTEGER,
    PRIMARY KEY (animal_id, date_of_birth),
    FOREIGN KEY (animal_id) REFERENCES animal_id_list(id),
    FOREIGN KEY (date_of_birth) REFERENCES date_of_birth_list(id)
);

-- заполнение промежуточной таблицы

INSERT INTO link_date_of_birth_animal_id (animal_id, date_of_birth)
SELECT DISTINCT animal_id_list.id, date_of_birth_list.id FROM animals
LEFT JOIN animal_id_list ON TRIM(animals.animal_id) = animal_id_list.animal_id
INNER JOIN date_of_birth_list ON animals.date_of_birth = date_of_birth_list.date_of_birth;

-- [outcome_subtype] новая таблица - список программ

CREATE TABLE outcome_subtype_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    outcome_subtype VARCHAR (30)
);

-- заполнение таблицы

INSERT INTO outcome_subtype_list (outcome_subtype)
SELECT DISTINCT TRIM(outcome_subtype) FROM animals WHERE outcome_subtype IS NOT NULL;

-- создание промежуточной таблицы для связи программы с индексом записи

CREATE TABLE link_outcome_subtype_animals_index
(
    id INTEGER PRIMARY KEY,
    outcome_subtype INTEGER,
    FOREIGN KEY (outcome_subtype) REFERENCES outcome_subtype_list(id)
);

-- заполнение промежуточной таблицы

INSERT INTO link_outcome_subtype_animals_index
SELECT animals."index", outcome_subtype_list.id FROM animals
INNER JOIN outcome_subtype_list ON TRIM(animals.outcome_subtype) = outcome_subtype_list.outcome_subtype;

-- [outcome_type] новая таблица - список состояний животного

CREATE TABLE outcome_type_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    outcome_type VARCHAR (40)
);

-- заполнение таблицы

INSERT INTO outcome_type_list (outcome_type)
SELECT DISTINCT outcome_type FROM animals WHERE outcome_type IS NOT NULL;

-- создание промежутночной таблицы для связывания состояния животного с индексом записи

CREATE TABLE link_outcome_type_animals_index
(
    id INTEGER PRIMARY KEY,
    outcome_type INTEGER,
    FOREIGN KEY (outcome_type) REFERENCES outcome_type_list(id)
);

-- заполнение таблицы

INSERT INTO link_outcome_type_animals_index
SELECT animals."index", outcome_type_list.id FROM animals
INNER JOIN outcome_type_list ON animals.outcome_type = outcome_type_list.outcome_type;

-- [outcome_data] новая таблица - список вариантов информации о прибытии

CREATE TABLE outcome_data_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    age_upon_outcome VARCHAR (30),
    outcome_month INTEGER,
    outcome_year INTEGER
);

-- заполнение таблицы

INSERT INTO outcome_data_list (age_upon_outcome, outcome_month, outcome_year)
SELECT DISTINCT age_upon_outcome, outcome_month, outcome_year FROM animals;

-- создание промежуточной таблицы для связи данных о прибытии с индексом записи

CREATE TABLE link_outcome_data_animals_index
(
    id INTEGER PRIMARY KEY,
    outcome_data INTEGER,
    FOREIGN KEY (outcome_data) REFERENCES outcome_data_list(id)
);

-- заполнение таблицы

INSERT INTO link_outcome_data_animals_index
SELECT animals."index", outcome_data_list.id FROM animals
INNER JOIN outcome_data_list ON (animals.age_upon_outcome || animals.outcome_month || animals.outcome_year) =
                                (outcome_data_list.age_upon_outcome || outcome_data_list.outcome_month ||
                                 outcome_data_list.outcome_year);
