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






-- Saber quantos clientes se encontram no ginásio neste momento

SELECT COUNT(SubQ.Cliente)
	FROM (
		SELECT Cliente, MAX(CONCAT(Data, ' ', Horario)) AS Momento
		FROM EntradasSaidas
		GROUP BY Cliente
	) AS SubQ
		INNER JOIN EntradasSaidas AS E
		ON SubQ.Cliente = E.Cliente
			AND SubQ.Momento = CONCAT(E.Data, ' ', E.Horario)
	WHERE E.EntradaSaida = '0';


-- Saber que clientes se encontram no ginásio

SELECT E.Cliente, C.Nome
	FROM (
		SELECT Cliente, MAX(CONCAT(Data, ' ', Horario)) AS Momento
		FROM EntradasSaidas
		GROUP BY Cliente
	) AS SubQ
		INNER JOIN EntradasSaidas AS E
		ON SubQ.Cliente = E.Cliente
			AND SubQ.Momento = CONCAT(E.Data, ' ', E.Horario)
			INNER JOIN Cliente AS C
            ON E.Cliente = C.idCliente
	WHERE E.EntradaSaida = '0';


-- Saber quantos clientes já facultaram aulas de grupo
    
SELECT COUNT(DISTINCT Cliente)
		FROM FuncionarioCliente
        WHERE Modalidade != 'Personal Training'
			AND Cliente IS NOT NULL;
            
-- Saber quantos clientes estão insvritos ou já tiveram inscritos em treinos privados
    
SELECT COUNT(DISTINCT Cliente)
		FROM FuncionarioCliente
        WHERE Modalidade = 'Personal Training';


-- Aceder ao histórico de aulas de grupo e aulas privadas

DROP PROCEDURE IF EXISTS clienteAulasHistorico;

DELIMITER $$
CREATE PROCEDURE clienteAulasHistorico
	(IN idCliente INT)
BEGIN
	
    SELECT *
		FROM FuncionarioCLiente
        WHERE Cliente = idCliente
			AND HorarioInicio < NOW();
	
END $$

CALL clienteAulasHistorico('1');


-- Aceder às aulas de grupo e aulas privadas agendadas por um cliente

DROP PROCEDURE IF EXISTS clienteAulasAgendadas;

DELIMITER $$
CREATE PROCEDURE clienteAulasAgendadas
	(IN idCliente INT)
BEGIN
	
    SELECT *
		FROM FuncionarioCLiente
        WHERE Cliente = idCliente
			AND HorarioInicio > NOW();
	
END $$

CALL clienteAulasAgendadas('8');


-- Aceder às aulas de grupo e/ou aulas privadas que um funcionario com essa especialidade lecionou

DROP PROCEDURE IF EXISTS funcionarioAulasHistorico;

DELIMITER $$
CREATE PROCEDURE funcionarioAulasHistorico
	(IN idFuncionario INT)
BEGIN
	
    SELECT DISTINCT Funcionario, HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Ginasio
		FROM FuncionarioCLiente
        WHERE Funcionario = idFuncionario
			AND HorarioInicio < NOW()
		GROUP BY Funcionario, HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Ginasio;
	
END $$

CALL funcionarioAulasHistorico('3');


-- Aceder às aulas de grupo e/ou aulas privadas que um funcionario com essa especialidade tem agendadas

DROP PROCEDURE IF EXISTS funcionarioAulasAgendadas;

DELIMITER $$
CREATE PROCEDURE funcionarioAulasAgendadas
	(IN idFuncionario INT)
BEGIN
	
    SELECT DISTINCT Funcionario, HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Ginasio
		FROM FuncionarioCLiente
        WHERE Funcionario = idFuncionario
			AND HorarioInicio > NOW()
		GROUP BY Funcionario, HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Ginasio;
	
END $$

CALL funcionarioAulasAgendadas('3');


-- Conhecer quantas aulas privadas ou de grupo cada treinador com essas especialidades deu

SELECT Funcionario, COUNT(DISTINCT CONCAT(Funcionario, ' ', HorarioInicio)) AS 'Aulas Dadas'
	FROM FuncionarioCLiente
	WHERE HorarioInicio < NOW()
	GROUP BY Funcionario;


-- Saber quantos funcionários de uma determinada especialidade se encontram atualmente ativos, de momento.

DROP PROCEDURE IF EXISTS especialidadeAtivos;

DELIMITER $$
CREATE PROCEDURE especialidadeAtivos
	(IN FuncaoVer ENUM('Treinador de Sala','Treinador Privado','Treinador de Grupo','Rececionista','Diretor'))
BEGIN
	
    SELECT F.idFuncionário, F.Nome
		FROM Funcionario AS F
			INNER JOIN FuncionarioFuncao AS FF
            ON F.idFuncionário = FF.Funcionario
        WHERE FF.Funcao = FuncaoVer
			AND (
				(F.HorarioTrabalho = '1' AND ('07:00:00' <= CURTIME() AND '13:00:00' >= CURTIME()))
                OR (F.HorarioTrabalho = '2' AND ('13:00:00' <= CURTIME() AND '18:00:00' >= CURTIME()))
                OR (F.HorarioTrabalho = '3' AND ('18:00:00' <= CURTIME() AND '23:00:00' >= CURTIME()))
			);
	
END $$

CALL especialidadeAtivos('Treinador de Sala');


-- Em cada momento, consultar quais os clientes que se encontram inscritos em cada aula de grupo agendadas

SELECT FC.Cliente, C.Nome, FC.HorarioInicio, FC.HorarioFim, FC.Funcionario, FC.Modalidade, FC.Ginasio
	FROM Cliente AS C
		INNER JOIN FuncionarioCliente AS FC
        ON C.idCliente = FC.Cliente
	WHERE HorarioInicio > NOW()
    AND FC.Modalidade != 'Personal Training'
    AND FC.CLiente IS NOT NULL;


-- Aceder ao histórico das horas de entrada e saída de um determinado cliente.

DROP PROCEDURE IF EXISTS GetEntradaSaidaByClienteId;

DELIMITER $$
CREATE PROCEDURE GetEntradaSaidaByClienteId
	(IN clienteId INT)
BEGIN
    SELECT *
    FROM EntradasSaidas
    WHERE Cliente = clienteId;
END $$

CALL GetEntradaSaidaByClienteId('1');


-- Obter a lista de clientes que estão a usufruir de um determinado plano de treino.

DROP PROCEDURE IF EXISTS GetClientesByPlanoTreino;

DELIMITER $$
CREATE PROCEDURE GetClientesByPlanoTreino
	(IN planoTreinoId ENUM('1', '2', '3'))
BEGIN
    SELECT *
    FROM Cliente
    WHERE PlanoTreino = planoTreinoId;
END $$

CALL GetClientesByPlanoTreino('2');


-- Fazer um relatório do número e percentagem de utentes que usufruem dos extras que o ginásio dá a possibilidade de aderir, como o refill de água e o banho.

DROP PROCEDURE IF EXISTS GenerateExtrasUsageReport;

DELIMITER $$
CREATE PROCEDURE GenerateExtrasUsageReport()
BEGIN
    DECLARE totalUsers INT;
    DECLARE waterRefillUsers INT;
    DECLARE showerUsers INT;
    DECLARE bothExtrasUsers INT;
    DECLARE waterRefillPercentage DECIMAL(5, 2);
    DECLARE showerPercentage DECIMAL(5, 2);
    DECLARE bothExtrasPercentage DECIMAL(5, 2);
    
    -- Numero total de clientes
    SELECT COUNT(*) INTO totalUsers FROM Cliente;
    
    -- Numero total de clientes a usufruir de refill de água
    SELECT COUNT(*) INTO waterRefillUsers FROM Cliente WHERE Extras = '1' OR Extras = '3';
    
    -- Numero total de clientes que pagam para poder tomar banho
    SELECT COUNT(*) INTO showerUsers FROM Cliente WHERE Extras = '2' OR Extras = '3';
    
    -- Numero total de clientes que pagam para poder tomar banho e encher a água
    SELECT COUNT(*) INTO bothExtrasUsers FROM Cliente WHERE Extras = '3';
    
    -- Calcular as percentagens
    SET waterRefillPercentage = (waterRefillUsers / totalUsers) * 100;
    SET showerPercentage = (showerUsers / totalUsers) * 100;
    SET bothExtrasPercentage = (bothExtrasUsers / totalUsers) * 100;

    SELECT 'Extras' AS Description, 'Number of Users' AS Metric, 'Percentage (%)' AS Percentage
    UNION ALL
    SELECT 'Water Refill', waterRefillUsers, waterRefillPercentage
    UNION ALL
    SELECT 'Shower Facilities', showerUsers, showerPercentage
    UNION ALL
    SELECT 'Both Extras (Water Refill and Shower)', bothExtrasUsers, bothExtrasPercentage;
END $$

CALL GenerateExtrasUsageReport();


-- Saber quantos novos clientes o ginásio angariou em cada mês

SELECT YEAR(DataInscricao) AS Ano, MONTH(DataInscricao) AS Mes, COUNT(*) AS NovosClientes
	FROM GinasioCliente
	GROUP BY YEAR(DataInscricao), MONTH(DataInscricao)
	ORDER BY YEAR(DataInscricao), MONTH(DataInscricao);


-- Entender qual a especialidade que está a render mais lucro para o ginásio

SELECT Modalidade, SUM(Valor) AS TotalGanho
	FROM FuncionarioCliente
	GROUP BY Modalidade
	ORDER BY SUM(Valor) DESC;

