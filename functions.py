import sqlite3


def search_record_by_id(indx):
    with sqlite3.connect('animal.db') as connection:
        cursor = connection.cursor()
        query_sqlite = (f"""
                        SELECT 
                        animals_nf.indx AS record_id,
                        animal_id_list.animal_id AS animal_id,
                        animal_type_list.animal_type AS animal_type,
                        name_list.name AS animal_name, 
                        breed_list.breed1 AS breed1,
                        breed_list.breed2 AS breed2,
                        color_list.color1 AS color1,
                        color_list.color2 AS color2,
                        date_of_birth_list.date_of_birth AS date_of_birth,
                        outcome_subtype_list.outcome_subtype AS outcome_subtype,
                        outcome_type_list.outcome_type AS outcome_type,
                        outcome_data_list.age_upon_outcome AS age_upon_outcome,
                        outcome_data_list.outcome_month AS outcome_month,
                        outcome_data_list.outcome_year AS outcome_year
                        FROM animals_nf 
                        LEFT JOIN animal_id_list ON animal_id_list.id = animals_nf.animal_id
                        LEFT JOIN animal_type_list ON animal_type_list.id = animals_nf.animal_type  
                        LEFT JOIN name_list ON name_list.id = animals_nf.name
                        LEFT JOIN breed_list ON breed_list.id = animals_nf.breed
                        LEFT JOIN color_list ON color_list.id = animals_nf.color
                        LEFT JOIN date_of_birth_list ON date_of_birth_list.id = animals_nf.date_of_birth
                        LEFT JOIN outcome_nf ON outcome_nf.indx = animals_nf.indx
                        LEFT JOIN outcome_subtype_list ON outcome_subtype_list.id = outcome_nf.outcome_subtype
                        LEFT JOIN outcome_type_list ON outcome_type_list.id = outcome_nf.outcome_type
                        LEFT JOIN outcome_data_list ON outcome_data_list.id = outcome_nf.outcome_data
                        
                        WHERE animals_nf.indx = {indx}
                        
            """)
        cursor.execute(query_sqlite)
        extract = cursor.fetchall()
        print(extract)
        dict_result = {'record_id': extract[0][0], 'animal_id': extract[0][1], 'animal_type': extract[0][2],
                       'name': extract[0][3], 'breed1': extract[0][4], 'breed2': extract[0][5],
                       'color1': extract[0][6], 'color2': extract[0][7], 'date_of_birth': extract[0][8],
                       'outcome_subtype': extract[0][9], 'outcome_type': extract[0][10],
                       'age_upon_outcome': extract[0][11], 'outcome_month': extract[0][12],
                       'outcome_year': extract[0][13]}
        return dict_result
