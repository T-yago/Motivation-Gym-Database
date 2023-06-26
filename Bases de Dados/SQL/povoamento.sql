
-- ------------------------------------------------------
-- ------------------------------------------------------
-- Universidade do Minho
-- Mestrado Integrado em Engenharia Informática
-- Lincenciatura em Ciências da Computação
-- Unidade Curricular de Bases de Dados
-- 
-- Caso de Estudo: Ginásio
-- Povoamento inicial da base de dados
-- Junho/2023
-- ------------------------------------------------------
-- ------------------------------------------------------

-- Schema Ginasio
USE Ginasio ;

--
-- Permissão para fazer operações de remoção de dados.
SET SQL_SAFE_UPDATES = 0;

-- Inserir dados na tabela PlanoTreino
INSERT INTO PlanoTreino (Id, Preco, HorarioFim, HorarioInicio)
VALUES
  ('1', '25.00', '7:00:00', '13:00:00'),
  ('2', '30.00', '7:00:00', '19:00:00'),
  ('3', '35.00', '7:00:00', '23:00:00');


-- Inserir dados na tabela Cliente
INSERT INTO Cliente (NIF, DataNascimento, Email, Sexo, Nome, CodigoPostal, Rua, Cidade, Distrito, CondicoesMedicas, Extras, PlanoTreino)
VALUES
  ('123456789', '1990-05-15', 'joao.silva@example.com', '1', 'João Silva', '12345', 'Rua dos Lírios', 'Lisboa', 'Lisboa', 'Nenhuma', '0', '1'),
  ('987654321', '1985-08-25', 'maria.santos@example.com','0', 'Maria Santos', '54321', 'Rua da Fonte', 'Porto', 'Porto', 'Nenhuma', '1', '2'),
  ('654321987', '1992-12-10', 'pedro.oliveira@example.com', '1', 'Pedro Oliveira', '67890', 'Rua dos Girassóis', 'Braga', 'Braga', 'Nenhuma', '1', '3'),
  ('111222333', '1995-02-18', 'ana.rodrigues@example.com', '0', 'Ana Rodrigues', '55555', 'Rua das Oliveiras', 'Coimbra', 'Coimbra', 'Nenhuma', '1', '1'),
  ('444555666', '1988-07-01', 'ricardo.faria@example.com', '1', 'Ricardo Faria', '99999', 'Rua dos Cravos', 'Faro', 'Faro', 'Nenhuma', '2', '2'),
  ('777888999', '1993-09-22', 'carla.silveira@example.com', '0', 'Carla Silveira', '77777', 'Rua dos Pinheiros', 'Viseu', 'Viseu', 'Nenhuma', '3', '3'),
  ('222333444', '1997-12-05', 'gustavo.pereira@example.com', '1', 'Gustavo Pereira', '44444', 'Rua dos Jasmins', 'Évora', 'Évora', 'Nenhuma', '2', '1'),
  ('555666777', '1990-04-30', 'patricia.sousa@example.com', '0', 'Patrícia Sousa', '11111', 'Rua das Rosas', 'Bragança', 'Bragança', 'Nenhuma', '2', '2'),
  ('888999000', '1987-11-13', 'miguel.carvalho@example.com', '1', 'Miguel Carvalho', '88888', 'Rua dos Crisântemos', 'Guarda', 'Guarda', 'Nenhuma', '1', '3'),
  ('333444555', '1994-03-27', 'sara.gomes@example.com', '0', 'Sara Gomes', '22222', 'Rua das Camélias', 'Aveiro', 'Aveiro', 'Nenhuma', '3', '1'); 


-- Inserir dados na tabela ClienteTelefones
INSERT INTO ClienteTelefones (Telemovel, Cliente)
VALUES
  ('912345678', '1'),
  ('923456789', '1'),
  ('934567890', '2'),
  ('945678901', '3'),
  ('956789012', '4'),
  ('967890123', '4'),
  ('978901234', '5'),
  ('989012345', '6'),
  ('990123456', '7'),
  ('901234567', '8'),
  ('987678099', '9'),
  ('997637123', '10');
  
  
-- Inserir dados na tabela EntradasSaidas
INSERT INTO EntradasSaidas (Cliente, Data, Horario, EntradaSaida, Ginasio)
VALUES
  ('1', '2023-01-01', '08:30:00', '0', '1'),
  ('1', '2023-01-01', '9:45:00', '1', '1'),
  ('2', '2023-01-01', '09:15:00', '0', '1'),
  ('2', '2023-01-01', '11:30:00', '1', '1'),
  ('3', '2023-01-01', '07:45:00', '0', '1'),
  ('3', '2023-01-01', '9:30:00', '1', '1'),
  ('4', '2023-01-01', '18:00:00', '0', '1'),
  ('4', '2023-01-01', '19:15:00', '1', '1'),
  ('5', '2023-01-01', '08:15:00', '0', '1'),
  ('5', '2023-01-01', '9:00:00', '1', '1'),
  ('6', '2023-01-01', '11:30:00', '0', '1'),
  ('6', '2023-01-02', '11:45:00', '1', '1'),
  ('6', '2023-01-02', '9:30:00', '0', '1'),
  ('6', '2023-01-04', '18:00:00', '1', '1'),
  ('9', '2023-01-05', '19:15:00', '0', '1'),
  ('9', '2023-01-05', '20:15:00', '1', '1'),
  ('10', '2023-01-06', '9:00:00', '0', '1');


-- Inserir dados na tabela Fatura
INSERT INTO Fatura (MetodoPagamento, ValorMensalidade, DataEmissao, PrecoTotal, DataPagamento, Cliente)
VALUES
  (NULL, '25.00', '2023-01-10', '26.25', NULL, '1'),
  (NULL, '25.00', '2023-02-10', '28.75', NULL, '1'),
  (NULL, '30.00', '2023-01-15', '36.50', NULL, '2'),
  (NULL, '30.00', '2023-02-15', '34.00', NULL, '2'),
  (NULL, '25.00', '2023-01-01', '29.00', NULL, '4'),
  (NULL, '25.00', '2023-02-01', '37.50', NULL, '4'),
  (NULL, '25.00', '2023-03-01', '29.00', NULL, '4'),
  (NULL, '25.00', '2023-04-01', '29.00', NULL, '4'),
  (NULL, '30.00', '2023-01-12', '35.25', NULL, '5'),
  (NULL, '30.00', '2023-02-12', '45.00', NULL, '5'),
  (NULL, '30.00', '2023-03-12', '35.25', NULL, '5'),
  (NULL, '35.00', '2023-01-15', '35.00', NULL, '6'),
  (NULL, '25.00', '2023-01-02', '30.25', NULL, '7'),
  (NULL, '25.00', '2023-02-02', '45.75', NULL, '7'),
  (NULL, '30.00', '2023-01-05', '35.25', NULL, '8'),
  (NULL, '30.00', '2023-02-05', '66.25', NULL, '8'),
  (NULL, '30.00', '2023-03-05', '35.25', NULL, '8'),
  (NULL, '25.00', '2023-01-19', '25.00', NULL, '10');

  
-- Inserir dados na tabela Funcao
INSERT INTO Funcao (Nome)
VALUES
  ('Treinador de Sala'),
  ('Treinador Privado'),
  ('Treinador de Grupo'),
  ('Rececionista'),
  ('Diretor');

-- Inserir dados na tabela Funcionario
INSERT INTO Funcionario (Nome, NIF, Sexo, DataNascimento, Email, Rua, Cidade, CodigoPostal, Distrito, DataContratacao, Ginasio, SalarioBase, HorarioTrabalho)
VALUES
  ('Júnior Neto', '123456789', '1', '1990-05-15', 'joao.silva@example.com', 'Rua dos Lírios', 'Lisboa', '12345', 'Lisboa', '2022-01-01', '1', '1500.00', '1'),
  ('Maria Santos', '987654321', '0', '1985-08-25', 'maria.santos@example.com', 'Rua da Fonte', 'Porto', '54321', 'Porto', '2022-02-01', '1', '1200.00', '2'),
  ('Pedro Oliveira', '654321987', '1', '1992-12-10', 'pedro.oliveira@example.com', 'Rua dos Girassóis', 'Braga', '67890', 'Braga', '2022-03-01', '1', '900.00', '3'),
  ('Ana Rodrigues', '111222333', '0', '1995-02-18', 'ana.rodrigues@example.com', 'Rua das Oliveiras', 'Coimbra', '55555', 'Coimbra', '2022-04-01', '1', '1100.00', '1'),
  ('Ricardo Faria', '444555666', '1', '1988-07-01', 'ricardo.faria@example.com', 'Rua dos Cravos', 'Faro', '99999', 'Faro', '2022-05-01', '1', '1000.00', '2'),
  ('Carla Silveira', '777888999', '0', '1993-09-22', 'carla.silveira@example.com', 'Rua dos Pinheiros', 'Viseu', '77777', 'Viseu', '2022-06-01', '1', '1100.00', '3');

-- Inserir dados na tabela FuncionarioFuncao
INSERT INTO FuncionarioFuncao (Funcionario, Funcao)
VALUES
  ('1', 'Diretor'),
  ('2', 'Rececionista'),
  ('3', 'Treinador de Sala'),
  ('3', 'Treinador de Grupo'),
  ('3', 'Treinador Privado'),
  ('4', 'Treinador de Grupo'),
  ('5', 'Treinador de Sala'),
  ('5', 'Treinador de Grupo'),
  ('6', 'Treinador de Grupo'),
  ('6', 'Treinador de Sala');

INSERT INTO Ginasio (Nome, DataAbertura, Rua, CodigoPostal, Cidade, Distrito)
VALUES
  ('Motivation Gym', '2023-01-01', 'Rua Augusta', '4700', 'Braga', 'Braga'); 


-- Inserir dados na tabela FuncionarioGinasio
INSERT INTO FuncionarioGinasio (DataPagamento, SalarioBase, SalarioTotal, HorarioTrabalho, Funcionario, Ginasio)
VALUES
  ('2022-01-01', '1500.0000', '1500.0000', '1', '1', '1'),
  ('2022-02-01', '1500.0000', '1500.0000', '1', '1', '1'),
  ('2022-02-01', '1200.0000', '1200.0000', '2', '2', '1'),
  ('2022-03-01', '1500.0000', '1500.0000', '1', '1', '1'),
  ('2022-03-01', '1200.0000', '1200.0000', '2', '2', '1'),
  ('2022-03-01', '900.0000', '900.0000', '3', '3', '1'),
  ('2022-04-01', '1500.0000', '1500.0000', '1', '1', '1'),
  ('2022-04-01', '1200.0000', '1200.0000', '2', '2', '1'),
  ('2022-04-01', '900.0000', '900.0000', '3', '3', '1'),
  ('2022-04-01', '1100.0000', '1100.0000', '1', '4', '1'),
  ('2022-05-01', '1500.0000', '1500.0000', '1', '1', '1'),
  ('2022-05-01', '1200.0000', '1200.0000', '2', '2', '1'),
  ('2022-05-01', '900.0000', '900.0000', '3', '3', '1'),
  ('2022-05-01', '1100.0000', '1100.0000', '1', '4', '1'),
  ('2022-05-01', '1000.0000', '1000.0000', '2', '5', '1'),
  ('2022-06-01', '1500.0000', '1500.0000', '1', '1', '1'),
  ('2022-06-01', '1200.0000', '1200.0000', '2', '2', '1'),
  ('2022-06-01', '900.0000', '900.0000', '3', '3', '1'),
  ('2022-06-01', '1100.0000', '1100.0000', '1', '4', '1'),
  ( '2022-06-01', '1000.0000', '1000.0000', '2', '5', '1'),
  ('2022-06-01', '1100.0000', '1100.0000', '1', '6', '1');

-- Inserir dados na tabela FuncionarioCliente
INSERT INTO FuncionarioCliente (HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Funcionario, Cliente, Ginasio)
VALUES
  ('2023-01-10 08:00:00', '2023-01-10 09:00:00', '1', 'Pilates', '2.50', '3', '1', '1'),
  ('2023-01-10 08:00:00', '2023-01-10 09:00:00', '1', 'Pilates', '2.50', '3', '2', '1'),
  ('2023-01-10 08:00:00', '2023-01-10 09:00:00', '1', 'Pilates', '2.50', '3', '3', '1'),
  ('2023-01-14 16:00:00', '2023-01-14 17:00:00', '4', 'Zumba', '8.50', '5', '4', '1'),
  ('2023-01-15 10:00:00', '2023-01-15 11:30:00', '5', 'Spinning', '9.75', '6', '1', '1'),
  ('2024-01-16 18:30:00', '2024-01-16 20:00:00', '2', 'CrossFit', '20.00', '6', '6', '1'),
  ('2024-01-16 18:30:00', '2024-01-16 20:00:00', '2', 'CrossFit', '20.00', '6', '7', '1'),
  ('2024-01-18 15:00:00', '2024-01-18 16:30:00', '3', 'Personal Training', '12.75', '3', '8', '1'),
  ('2024-01-19 17:30:00', '2024-01-19 18:30:00', '4', 'Zumba', '8.50', '5', '8', '1'),
  ('2024-01-20 09:00:00', '2024-01-20 10:30:00', '5', 'Spinning', '9.75', '6', '7', '1');

INSERT INTO FuncionarioTelefones (Telemovel, Funcionario)
VALUES
  ('912345678', '1'),
  ('923456789', '2'),
  ('934567890', '3'),
  ('945678901', '4'),
  ('956789012', '5'),
  ('967890123', '1'),
  ('978901234', '2'),
  ('989012345', '3'),
  ('900123456', '1'),
  ('911234567', '1');

INSERT INTO GinasioCliente (DataInscricao, Ginasio, Cliente)
VALUES
  ('2023-01-10', '1', '1'),
  ('2023-01-15', '1', '2'),
  ('2023-01-20', '1', '3'),
  ('2023-01-01', '1', '4'),
  ('2023-01-12', '1', '5'),
  ('2023-01-15', '1', '6'),
  ('2023-01-2', '1', '7'),
  ('2023-01-5', '1', '8'),
  ('2023-01-8', '1', '9'),
  ('2023-01-19', '1', '10');
  
  