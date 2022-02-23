-- animal (normal form)

CREATE TABLE animals_nf
(
    indx INTEGER PRIMARY KEY,
    animal_id INTEGER,
    animal_type INTEGER,
    name INTEGER,
    breed INTEGER,
    color INTEGER,
    date_of_birth INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animal_id_list(id),
    FOREIGN KEY (animal_type) REFERENCES animal_type_list(id),
    FOREIGN KEY (name) REFERENCES name_list(id),
    FOREIGN KEY (breed) REFERENCES breed_list(id),
    FOREIGN KEY (color) REFERENCES color_list(id),
    FOREIGN KEY (date_of_birth) REFERENCES date_of_birth_list(id)
);

INSERT INTO animals_nf
SELECT link_animal_id_animals_index.id, link_animal_id_animals_index.animal_id, link_animal_type_animal_id.animal_type,
       link_name_animals_index.name, link_breed_animals.breed, link_color_animals_index.color,
       link_date_of_birth_animal_id.date_of_birth
FROM link_animal_id_animals_index
JOIN link_animal_type_animal_id ON link_animal_id_animals_index.animal_id = link_animal_type_animal_id.animal_id
LEFT JOIN link_name_animals_index ON link_animal_id_animals_index.id = link_name_animals_index.id
LEFT JOIN link_breed_animals ON link_animal_id_animals_index.animal_id = link_breed_animals.animal_id
LEFT JOIN link_color_animals_index ON link_animal_id_animals_index.id = link_color_animals_index.id
LEFT JOIN link_date_of_birth_animal_id
    ON link_animal_id_animals_index.animal_id = link_date_of_birth_animal_id.animal_id;

-- outcome (normal form)

CREATE TABLE outcome_nf
(
    indx INTEGER PRIMARY KEY,
    outcome_data INTEGER,
    outcome_subtype INTEGER,
    outcome_type INTEGER,
    FOREIGN KEY (outcome_data) REFERENCES outcome_data_list(id),
    FOREIGN KEY (outcome_subtype) REFERENCES outcome_subtype_list(id),
    FOREIGN KEY (outcome_type) REFERENCES outcome_type_list(id)
);

INSERT INTO outcome_nf
SELECT link_outcome_data_animals_index.id, link_outcome_data_animals_index.outcome_data,
       link_outcome_subtype_animals_index.outcome_subtype, link_outcome_type_animals_index.outcome_type
FROM link_outcome_data_animals_index
LEFT JOIN link_outcome_subtype_animals_index
    ON link_outcome_data_animals_index.id = link_outcome_subtype_animals_index.id
LEFT JOIN link_outcome_type_animals_index
    ON link_outcome_data_animals_index.id = link_outcome_type_animals_index.id;

-- animals_full (объединение нормальных форм)
-- [не знаю зачем я создал эту таблицу, мне показалось, так будет правильно]

CREATE TABLE animals_full
(
    animals_nf INTEGER,
    outcome_nf INTEGER,
    PRIMARY KEY (animals_nf, outcome_nf),
    FOREIGN KEY (animals_nf) REFERENCES animals_nf(indx),
    FOREIGN KEY (outcome_nf) REFERENCES outcome_nf(indx)
);

INSERT INTO animals_full
SELECT animals_nf.indx, outcome_nf.indx
FROM animals_nf
LEFT JOIN outcome_nf ON animals_nf.indx = outcome_nf.indx;