import csv
import mysql.connector

# Function to read data from a CSV file and return as a list of dictionaries
def read_csv(filename):
    with open(filename, newline='') as file:
        reader = csv.DictReader(file)
        return list(reader)
    

# Function to execute SQL queries
def execute_query(connection, query):
    cursor = connection.cursor()
    cursor.execute(query)
    connection.commit()

# Establish database connection
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Animais1!',
    database='Ginasio'
)

# Read data from CSV files
plano_treino_data = read_csv('plano_treino.csv')
cliente_data = read_csv('cliente.csv')
cliente_telefones_data = read_csv('cliente_telefones.csv')
entradas_saidas_data = read_csv('entradas_saidas.csv')
fatura_data = read_csv('fatura.csv')
funcao_data = read_csv('funcao.csv')
funcionario_data = read_csv('funcionario.csv')
funcionario_funcao_data = read_csv('funcionario_funcao.csv')
ginasio_data = read_csv('ginasio.csv')
funcionario_ginasio_data = read_csv('funcionario_ginasio.csv')
funcionario_cliente_data = read_csv('funcionario_cliente_data.csv')
funcionariotelefones = read_csv('funcionariotelefones.csv')
ginasiocliente = read_csv('ginasiocliente.csv')

# Populate tables

# PlanoTreino
for row in plano_treino_data:
    query = f"INSERT INTO PlanoTreino (Id, Preco, HorarioFim, HorarioInicio) VALUES ({row['Id']}, {row['Preco']}, '{row['HorarioFim']}', '{row['HorarioInicio']}')"
    execute_query(connection, query)

# Cliente
for row in cliente_data:
    query = f"INSERT INTO Cliente (NIF, DataNascimento, Email, Sexo, Nome, CodigoPostal, Rua, Cidade, Distrito, CondicoesMedicas, Extras, PlanoTreino) VALUES ('{row['NIF']}', '{row['DataNascimento']}', '{row['Email']}', '{row['Sexo']}', '{row['Nome']}', '{row['CodigoPostal']}', '{row['Rua']}', '{row['Cidade']}', '{row['Distrito']}', '{row['CondicoesMedicas']}', '{row['Extras']}', '{row['PlanoTreino']}')"
    execute_query(connection, query)

# ClienteTelefones
for row in cliente_telefones_data:
    query = f"INSERT INTO ClienteTelefones (Telemovel, Cliente) VALUES ('{row['Telemovel']}', '{row['Cliente']}')"
    execute_query(connection, query)

# EntradasSaidas
for row in entradas_saidas_data:
    query = f"INSERT INTO EntradasSaidas (Cliente, Data, Horario, EntradaSaida, Ginasio) VALUES ('{row['Cliente']}', '{row['Data']}', '{row['Horario']}', '{row['EntradaSaida']}', '{row['Ginasio']}')"
    execute_query(connection, query)

# Fatura
for row in fatura_data:
    query = f"INSERT INTO Fatura (MetodoPagamento, ValorMensalidade, DataEmissao, PrecoTotal, DataPagamento, Cliente) VALUES (NULL, '{row['ValorMensalidade']}', '{row['DataEmissao']}', '{row['PrecoTotal']}', NULL, '{row['Cliente']}')"
    execute_query(connection, query)

# Funcao
for row in funcao_data:
    query = f"INSERT INTO Funcao (Nome) VALUES ('{row['Nome']}')"
    execute_query(connection, query)

# Populate Funcionario table
for row in funcionario_data:
    query = f"INSERT INTO Funcionario (Nome, NIF, Sexo, DataNascimento, Email, Rua, Cidade, CodigoPostal, Distrito, DataContratacao, Ginasio, SalarioBase, HorarioTrabalho) VALUES ('{row['Nome']}', '{row['NIF']}','{row['Sexo']}', '{row['DataNascimento']}', '{row['Email']}', '{row['Rua']}', '{row['Cidade']}', '{row['CodigoPostal']}', '{row['Distrito']}', '{row['DataContratacao']}', '{row['Ginasio']}', '{row['SalarioBase']}', '{row['HorarioTrabalho']}')"
    execute_query(connection, query)

# FuncionarioFuncao
for row in funcionario_funcao_data:
    query = f"INSERT INTO FuncionarioFuncao (Funcionario, Funcao) VALUES ('{row['Funcionario']}', '{row['Funcao']}')"
    execute_query(connection, query)

# Ginasio
for row in ginasio_data:
    query = f"INSERT INTO Ginasio (Nome, DataAbertura, Rua, CodigoPostal ,Cidade, Distrito) VALUES ('{row['Nome']}', '{row['DataAbertura']}', '{row['Rua']}','{row['CodigoPostal']}', '{row['Cidade']}', '{row['Distrito']}')"
    execute_query(connection, query)

# FuncionarioGinasio
for row in funcionario_ginasio_data:
    query = f"INSERT INTO FuncionarioGinasio (DataPagamento, SalarioBase, SalarioTotal, HorarioTrabalho, Funcionario, Ginasio) VALUES ('{row['DataPagamento']}', '{row['SalarioBase']}', '{row['SalarioTotal']}', '{row['HorarioTrabalho']}', '{row['Funcionario']}', '{row['Ginasio']}')"
    execute_query(connection, query)


# FuncionarioCliente
for row in funcionario_cliente_data:
    query = f"INSERT INTO FuncionarioCliente (HorarioInicio,HorarioFim,Espaco,Modalidade,Valor,Funcionario,Cliente,Ginasio) VALUES ('{row['HorarioInicio']}', '{row['HorarioFim']}', '{row['Espaco']}', '{row['Modalidade']}', '{row['Valor']}', '{row['Funcionario']}', '{row['Cliente']}', '{row['Ginasio']}')"
    execute_query(connection, query)


# FuncionarioCliente
for row in funcionariotelefones:
    query = f"INSERT INTO FuncionarioTelefones (Telemovel,Funcionario) VALUES ('{row['Telemovel']}', '{row['Funcionario']}')"
    execute_query(connection, query)

# FuncionarioCliente
for row in ginasiocliente:
    query = f"INSERT INTO GinasioCliente (DataInscricao,Ginasio,Cliente) VALUES ('{row['DataInscricao']}', '{row['Ginasio']}', '{row['Cliente']}')"
    execute_query(connection, query)


# Close database connection
connection.close()






