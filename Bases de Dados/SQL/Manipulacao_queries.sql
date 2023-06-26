--
-- Unidade Curricular de Bases de Dados.
-- Sistemas de Dados Relacionais.
-- SQL 
--
-- Q U E R I E S
--

-- Ativar ou desativar os safe updates
SET sql_safe_updates = 0;
SET sql_safe_updates = 1;

-- Schema Ginasio
USE Ginasio ;

-- Ver os Dados das diversas Tebelas

SELECT *
	FROM planotreino;
    
SELECT *
	FROM cliente;
    
SELECT *
	FROM ClienteTelefones;
    
SELECT *
	FROM entradassaidas;

SELECT *
	FROM fatura;

SELECT *
	FROM funcao;

SELECT *
	FROM funcionario;

SELECT *
	FROM funcionariofuncao;

SELECT *
	FROM funcionariocliente;

SELECT *
	FROM ginasio;
    
SELECT *
	FROM funcionarioginasio;

SELECT *
	FROM funcionariotelefones;

SELECT *
	FROM ginasiocliente;


-- Apagar os dados das diversas tabelas

DELETE FROM planotreino;

DELETE FROM cliente;

DELETE FROM ClienteTelefones;

DELETE FROM entradassaidas;

DELETE FROM fatura;

DELETE FROM funcao;

DELETE FROM funcionario;

DELETE FROM funcionariofuncao;

DELETE FROM funcionariocliente;

DELETE FROM ginasio;

DELETE FROM funcionarioginasio;

DELETE FROM funcionariotelefones;

DELETE FROM ginasiocliente;






-- Aceder ao histórico das horas de entrada e saída de um determinado cliente.

DELIMITER //

CREATE PROCEDURE GetEntradaSaidaByClienteId(IN clienteId INT)
BEGIN
    SELECT *
    FROM EntradasSaidas
    WHERE Cliente = clienteId;
END //

DELIMITER ;

CALL GetEntradaSaidaByClienteId(1);


-- Obter a lista de clientes que estão a usufruir de um determinado plano de treino.

DELIMITER //

CREATE PROCEDURE GetClientesByPlanoTreino(IN planoTreinoId ENUM('1', '2', '3'))
BEGIN
    SELECT *
    FROM Cliente
    WHERE PlanoTreino = planoTreinoId;
END //

DELIMITER ;

CALL GetClientesByPlanoTreino('2');


-- Perceber, a cada momento, quantos utilizadores estão inscritos ou já estiveram inscritos em treinos privados.

DELIMITER //

CREATE PROCEDURE GetClientsInCurrentTraining()
BEGIN
    SELECT c.*
    FROM Cliente c
    INNER JOIN FuncionarioCliente fc ON c.idCliente = fc.Cliente
    WHERE fc.Modalidade = 'Personal Training'
    AND NOW() BETWEEN fc.HorarioInicio AND fc.HorarioFim;
END //

DELIMITER ;

CALL GetClientsInCurrentTraining();



-- Fazer um relatório do número e percentagem de utentes que usufruem dos extras que o ginásio dá a possibilidade de aderir, como o refill de água e o banho.

DELIMITER //

DELIMITER //

CREATE PROCEDURE GenerateExtrasUsageReport()
BEGIN
    DECLARE totalUsers INT;
    DECLARE waterRefillUsers INT;
    DECLARE showerUsers INT;
    DECLARE bothExtrasUsers INT;
    DECLARE waterRefillPercentage DECIMAL(5, 2);
    DECLARE showerPercentage DECIMAL(5, 2);
    DECLARE bothExtrasPercentage DECIMAL(5, 2);
    
    -- Get the total number of users
    SELECT COUNT(*) INTO totalUsers FROM Cliente;
    
    -- Get the number of users using water refill
    SELECT COUNT(*) INTO waterRefillUsers FROM Cliente WHERE Extras = '1' OR Extras = '3';
    
    -- Get the number of users using shower facilities
    SELECT COUNT(*) INTO showerUsers FROM Cliente WHERE Extras = '2' OR Extras = '3';
    
    -- Get the number of users using both extras (water refill and shower)
    SELECT COUNT(*) INTO bothExtrasUsers FROM Cliente WHERE Extras = '3';
    
    -- Calculate the percentage of users for water refill, shower, and both extras
    SET waterRefillPercentage = (waterRefillUsers / totalUsers) * 100;
    SET showerPercentage = (showerUsers / totalUsers) * 100;
    SET bothExtrasPercentage = (bothExtrasUsers / totalUsers) * 100;
    
    -- Output the report
    SELECT 'Extras' AS Description, 'Number of Users' AS Metric, 'Percentage (%)' AS Percentage
    UNION ALL
    SELECT 'Water Refill', waterRefillUsers, waterRefillPercentage
    UNION ALL
    SELECT 'Shower Facilities', showerUsers, showerPercentage
    UNION ALL
    SELECT 'Both Extras (Water Refill and Shower)', bothExtrasUsers, bothExtrasPercentage;
END //

DELIMITER ;

CALL GenerateExtrasUsageReport();


-- Saber quantos novos clientes o ginásio angariou em cada mês

SELECT YEAR(DataInscricao) AS Ano, MONTH(DataInscricao) AS Mes, COUNT(*) AS NovosClientes
FROM GinasioCliente
GROUP BY YEAR(DataInscricao), MONTH(DataInscricao)
ORDER BY YEAR(DataInscricao), MONTH(DataInscricao);


-- Saber quantos funcionários de uma determinada especialidade se encontram atualmente ativos, em cada momento.

SELECT ff.Funcao, COUNT(*) AS NumeroFuncionariosAtivos
FROM FuncionarioFuncao ff
JOIN Funcionario f ON ff.Funcionario = f.idFuncionário
GROUP BY ff.Funcao;


-- Entender qual a especialidade que está a render mais lucro para o ginásio.

SELECT Modalidade, SUM(Valor) AS TotalGanho
FROM FuncionarioCliente
GROUP BY Modalidade
ORDER BY SomaValores DESC;


-- No final de cada mês deve ser possível conhecer a lotação do ginásio em diferentes intervalos de tempo do dia.
DELIMITER //

CREATE PROCEDURE CalculaLotacaoPorMesAno(IN p_mes INT, IN p_ano INT)
BEGIN
  SELECT
    CASE
      WHEN HOUR(HorarioInicio) >= 7 AND HOUR(HorarioInicio) < 13 THEN '7:00-13:00'
      WHEN HOUR(HorarioInicio) >= 13 AND HOUR(HorarioInicio) < 19 THEN '13:00-19:00'
      WHEN HOUR(HorarioInicio) >= 19 AND HOUR(HorarioInicio) <= 23 THEN '19:00-23:00'
    END AS IntervaloTempo,
    COUNT(*) AS Lotacao
  FROM
    FuncionarioCliente
  WHERE
    MONTH(HorarioInicio) = p_mes AND YEAR(HorarioInicio) = p_ano
  GROUP BY
    IntervaloTempo
  ORDER BY
    IntervaloTempo ASC;
END //

DELIMITER ;



CALL CalculaLotacaoPorMesAno(1, 2023);








