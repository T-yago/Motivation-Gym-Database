import csv
import mysql.connector

# Connect to the MySQL server
cnx = mysql.connector.connect(
    host="localhost",
    user="root",
    password="passwd",
    database="Ginasio"
)

# Create a cursor object to execute SQL queries
cursor = cnx.cursor()

# Define the SQL query to insert data into the Cliente table
insert_query = """
INSERT INTO cliente (NIF, DataNascimento, Email, Sexo, Nome, CodigoPostal, Rua, Cidade, Distrito, CondicoesMedicas, Extras, PlanoTreino)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

# Read data from the CSV file and insert into the Cliente table
with open('cliente_data.csv', 'r') as file:
    reader = csv.reader(file)

    for row in reader:
        # Extract data from each row
        nif = int(row[0])
        data_nascimento = row[1]
        email = row[2]
        sexo = row[3]
        nome = row[4]
        codigo_postal = row[5]
        rua = row[6]
        cidade = row[7]
        distrito = row[8]
        condicoes_medicas = row[9]
        extras = row[10]
        plano_treino = row[11]

        # Execute the insert query with the extracted data
        cursor.execute(insert_query, (
            nif, data_nascimento, email, sexo, nome, codigo_postal, rua, cidade,
            distrito, condicoes_medicas, extras, plano_treino
        ))




# Commit the changes and close the connection
cnx.commit()
cnx.close()
