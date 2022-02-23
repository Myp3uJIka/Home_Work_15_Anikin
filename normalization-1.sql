-- в строке breed имеются наборы значений

-- [breed] новая таблица = список пород
CREATE TABLE breed_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    breed1 VARCHAR (20) NOT NULL,
    breed2 VARCHAR (20)
);

-- заполнение списка пород (отдельно для чистых пород и отдельно для смешанных)

INSERT INTO breed_list (breed1)
SELECT DISTINCT TRIM(breed) FROM animals
WHERE INSTR(breed, '/') == 0;

INSERT INTO breed_list (breed1, breed2)
SELECT DISTINCT SUBSTR(breed, 0, INSTR(breed, '/')), SUBSTR(breed, INSTR(breed, '/') + 1) FROM animals
WHERE INSTR(breed, '/') > 0;

-- [animal_id] новая таблица - список идентификаторов животных

CREATE TABLE animal_id_list
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    animal_id VARCHAR (7) NOT NULL
);

INSERT INTO animal_id_list (animal_id)
SELECT DISTINCT TRIM(animal_id) FROM animals;

-- создание промежутчной таблицы для связывания идентификатора животного и его породы

CREATE TABLE link_breed_animals
(
    animal_id INTEGER,
    breed INTEGER,
    PRIMARY KEY (animal_id, breed),
    FOREIGN KEY (animal_id) REFERENCES animal_id_list(id),
    FOREIGN KEY (breed) REFERENCES breed_list(id)
);

-- заполнение промежуточной таблицы (отдельно для чистых пород и отдельно для смешанных)

INSERT INTO link_breed_animals (animal_id, breed)
SELECT DISTINCT animal_id_list.id, breed_list.id FROM animals
LEFT JOIN animal_id_list ON animal_id_list.animal_id = TRIM(animals.animal_id)
INNER JOIN breed_list ON TRIM(animals.breed) = breed_list.breed1 WHERE breed2 IS NULL;

INSERT INTO link_breed_animals (animal_id, breed)
SELECT DISTINCT animal_id_list.id, breed_list.id FROM animals
    LEFT JOIN animal_id_list ON animal_id_list.animal_id = TRIM(animals.animal_id)
    INNER JOIN breed_list ON
        TRIM(animals.breed) = breed_list.breed1 || '/' || breed_list.breed2 WHERE INSTR(animals.breed, '/') > 0;



