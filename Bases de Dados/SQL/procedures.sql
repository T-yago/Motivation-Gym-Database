--
-- Unidade Curricular de Bases de Dados.
-- Sistemas de Dados Relacionais.
-- SQL 
--
-- PROCEDURES
--


-- Schema Ginasio
USE Ginasio;


DROP PROCEDURE IF EXISTS funcionarioNovaFuncao;

-- Associa uma nova função a um Funcionário

DELIMITER $$
CREATE PROCEDURE funcionarioNovaFuncao 
	(IN NomeFuncaoAdd VARCHAR(45), IN IdFuncionarioAdd INT)
BEGIN

	START TRANSACTION;
	
    -- Verificar se os dados a introduzir são válidos
	IF NOT EXISTS (
		SELECT *
			FROM Funcao
            WHERE Nome = NomeFuncaoAdd
	) OR NOT EXISTS (
		SELECT *
			FROM Funcionario
			WHERE idFuncionário = IdFuncionarioAdd
    ) THEN
		ROLLBACK;
	END IF;
	
    IF NOT EXISTS (
        SELECT * 
        FROM FuncionarioFuncao
        WHERE Funcionario = IdFuncionarioAdd
            AND Funcao = NomeFuncaoAdd
    ) AND NomeFuncaoAdd != 'Diretor' AND NomeFuncaoAdd != 'Rececionista' THEN
        INSERT INTO FuncionarioFuncao
		    (Funcionario, Funcao)
            VALUES
				(IdFuncionarioAdd, NomeFuncaoAdd);
    ELSE
        ROLLBACK;
    END IF;

	COMMIT;
END $$

CALL funcionarioNovaFuncao('Treinador Privado', '4');
SELECT *
	FROM FuncionarioFuncao;



DROP PROCEDURE IF EXISTS funcionarioNovoGinasio;

-- Associa um novo ginásio a um Funcionário

DELIMITER $$
CREATE PROCEDURE funcionarioNovoGinasio 
	(IN idGinasioNew INT, IN IdFuncionarioAdd INT)
BEGIN

	START TRANSACTION;
    
    -- Verificar se os dados a introduzir são válidos
    IF NOT EXISTS (
		SELECT *
			FROM Ginasio
            WHERE idGinasio = idGinasioNew
	) OR NOT EXISTS (
		SELECT *
			FROM Funcionario
			WHERE idFuncionário = IdFuncionarioAdd
	) THEN
		ROLLBACK;
	END IF;

	UPDATE Funcionario
		SET Ginasio = idGinasioNew
        WHERE idFuncionário = IdFuncionarioAdd;

	COMMIT;
END $$

CALL funcionarioNovoGinasio('2', '6');
SELECT *
	FROM Funcionario;



DROP PROCEDURE IF EXISTS funcionarioNovoSalarioBase;

-- Associa um novo salário base a um Funcionário

DELIMITER $$
CREATE PROCEDURE funcionarioNovoSalarioBase 
	(IN salarioBaseNew DECIMAL(8,4), IN IdFuncionarioAdd INT)
BEGIN

	START TRANSACTION;
    
    -- Verificar se os dados a introduzir são válidos
    IF NOT EXISTS (
		SELECT *
			FROM Funcionario
			WHERE idFuncionário = IdFuncionarioAdd
	) THEN
		ROLLBACK;
	END IF;

	UPDATE Funcionario
		SET SalarioBase = salarioBaseNew
        WHERE idFuncionário = IdFuncionarioAdd;

	COMMIT;
END $$

CALL funcionarioNovoSalarioBase('2500.00', '6');
SELECT *
	FROM Funcionario;



DROP PROCEDURE IF EXISTS funcionarioNovoHorarioTrabalho;

-- Associa um novo horário de trabalho a um Funcionário

DELIMITER $$
CREATE PROCEDURE funcionarioNovoHorarioTrabalho 
	(IN HorarioTrabalhoNew ENUM('1','2','3'), IN IdFuncionarioAdd INT)
BEGIN

	START TRANSACTION;
    
    -- Verificar se os dados a introduzir são válidos
    IF NOT EXISTS (
		SELECT *
			FROM Funcionario
			WHERE idFuncionário = IdFuncionarioAdd
	) THEN
		ROLLBACK;
	END IF;

	UPDATE Funcionario
		SET HorarioTrabalho = HorarioTrabalhoNew
        WHERE idFuncionário = IdFuncionarioAdd;

	COMMIT;
END $$

CALL funcionarioNovoHorarioTrabalho('1', '3');
SELECT *
	FROM Funcionario;



DROP PROCEDURE IF EXISTS clienteNovoPlanoTreino;

-- Associa um novo plano de treino a um cliente

DELIMITER $$
CREATE PROCEDURE clienteNovoPlanoTreino
	(IN PlanoTreinoNew ENUM('1','2','3'), IN IdClienteAdd INT)
BEGIN

	START TRANSACTION;
    
    -- Verificar se os dados a introduzir são válidos
    IF NOT EXISTS (
		SELECT *
			FROM Cliente
			WHERE idCliente = IdClienteAdd
	) THEN
		ROLLBACK;
	END IF;

	UPDATE Cliente
		SET PlanoTreino = PlanoTreinoNew
        WHERE idCliente = IdClienteAdd;

	COMMIT;
END $$

CALL clienteNovoPlanoTreino('2', '3');
SELECT *
	FROM Cliente;



DROP PROCEDURE IF EXISTS reservarAulaGrupo;

-- Reserva uma aula de Grupo

DELIMITER $$
CREATE PROCEDURE reservarAulaGrupo 
	(IN IdFuncionarioAdd INT, IN HorarioInicioAdd DATETIME,
		IN HorarioFimAdd DATETIME, IN EspacoAdd ENUM('1','2','3','4','5'), IN ModalidadeAdd VARCHAR(30), IN ValorAdd DECIMAL(8,4), IN GinasioAdd INT, IN Lotacao INT)
BEGIN

	DECLARE Counter INT;
    SET Counter = 1;

	START TRANSACTION;
    
    -- Verificar se os dados existem
    IF NOT EXISTS (
		SELECT *
			FROM Ginasio
			WHERE idGinasio = GinasioAdd
	) OR NOT EXISTS (
		SELECT *
			FROM Funcionario
			WHERE idFuncionário = IdFuncionarioAdd
	) THEN
		ROLLBACK;
	END IF;

	-- Verificar se os dados são válidos
		IF EXISTS (
			SELECT *
				FROM FuncionarioCliente
				WHERE HorarioInicio < HorarioFimAdd
					AND HorarioFim > HorarioInicioAdd
                    AND Espaco = EspacoAdd
                    AND Ginasio = GinasioAdd
		) OR EXISTS (
			SELECT *
				FROM FuncionarioCliente
				WHERE HorarioInicio < HorarioFimAdd
					AND HorarioFim > HorarioInicioAdd
					AND Funcionario = IdFuncionarioAdd
		) OR NOT EXISTS (
			SELECT *
				FROM FuncionarioFuncao
				WHERE Funcionario = IdFuncionarioAdd
					AND Funcao = 'Treinador de Grupo'
        ) THEN
			ROLLBACK;
		ELSE
			WHILE Counter <= Lotacao DO
        
			INSERT INTO FuncionarioCliente
				(HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Funcionario, Cliente, Ginasio)
				VALUES
					(HorarioInicioAdd, HorarioFimAdd, EspacoAdd, ModalidadeAdd, ValorAdd, IdFuncionarioAdd, NULL, GinasioAdd);
				
                SET Counter = Counter + 1;
			END WHILE;
		END IF;

	COMMIT;
END $$


CALL reservarAulaGrupo('1', '2023-01-10 08:00:00', '2023-01-10 09:00:00', '2', 'Ginástica', '2.50', '1', '5');
SELECT *
	FROM FuncionarioCliente;



DROP PROCEDURE IF EXISTS marcaAulaGrupo;

-- Agenda uma aula de grupo para um cliente

DELIMITER $$
CREATE PROCEDURE marcaAulaGrupo
	(IN IdClienteAdd INT, IN HorarioInicioAdd DATETIME, IN HorarioFimAdd DATETIME, IN EspacoAdd ENUM('1','2','3','4','5'), IN GinasioAdd INT)
BEGIN

	DECLARE idVaga INT;

	START TRANSACTION;
    
    -- Verificar se existe alguma vaga disponível para essa aula
	SELECT idAula
	INTO idVaga
			FROM FuncionarioCliente
			WHERE Ginasio = GinasioAdd
				AND HorarioInicio = HorarioInicioAdd
                AND Espaco = EspacoAdd
				AND Cliente IS NULL
			ORDER BY idAula ASC
            LIMIT 1;

	IF idVaga IS NULL THEN
		ROLLBACK;
	ELSEIF NOT EXISTS (
		SELECT *
			FROM FuncionarioCliente
            WHERE HorarioInicio < HorarioFimAdd
				AND HorarioFim > HorarioInicioAdd
				AND Cliente = IdClienteAdd
	) THEN
		UPDATE FuncionarioCliente
			SET Cliente = idClienteAdd
            WHERE idAula = idVaga;
	ELSE
		ROLLBACK;
    END IF;

	COMMIT;
END $$


CALL marcaAulaGrupo('3', '2023-01-10 08:00:00', '2023-01-10 09:00:00', '2', '1');
SELECT *
	FROM FuncionarioCliente;



DROP PROCEDURE IF EXISTS marcaAulaPrivada;

-- Agenda uma aula privada para um cliente

DELIMITER $$
CREATE PROCEDURE marcaAulaPrivada
	(IN idClienteAdd INT, IN idFuncionarioAdd INT, IN HorarioInicioAdd DATETIME, IN HorarioFimAdd DATETIME, IN ValorAdd DECIMAL(8,4), IN GinasioAdd INT)
BEGIN

	START TRANSACTION;
    
    -- Verificar se os dados existem
    IF NOT EXISTS (
		SELECT *
			FROM Ginasio
			WHERE idGinasio = GinasioAdd
	) OR NOT EXISTS (
		SELECT *
			FROM Funcionario
			WHERE idFuncionário = IdFuncionarioAdd
	) OR NOT EXISTS (
		SELECT *
			FROM Cliente
			WHERE idCliente = idClienteAdd
	) THEN
		ROLLBACK;
	END IF;

	-- Verificar se os dados são válidos
	IF EXISTS (
		SELECT *
			FROM FuncionarioCliente
			WHERE HorarioInicio < HorarioFimAdd
				AND HorarioFim > HorarioInicioAdd
				AND Funcionario = idFuncionarioAdd
	) OR EXISTS (
		SELECT *
			FROM FuncionarioCliente
			WHERE HorarioInicio < HorarioFimAdd
				AND HorarioFim > HorarioInicioAdd
				AND Cliente = idClienteAdd
	) OR NOT EXISTS (
		SELECT *
			FROM FuncionarioFuncao
			WHERE Funcionario = IdFuncionarioAdd
				AND Funcao = 'Treinador Privado'
	) THEN
		ROLLBACK;
	ELSE
		INSERT INTO FuncionarioCliente
			(HorarioInicio, HorarioFim, Espaco, Modalidade, Valor, Funcionario, Cliente, Ginasio)
			VALUES
				(HorarioInicioAdd, HorarioFimAdd, '0', 'Personal Training', ValorAdd, idFuncionarioAdd, idClienteAdd, GinasioAdd);
	END IF;

	COMMIT;
END $$


CALL marcaAulaPrivada('1', '2', '2023-01-10 10:00:00', '2023-01-10 11:00:00', '10.00', '1');
SELECT *
	FROM FuncionarioCliente;



DROP PROCEDURE IF EXISTS entradaSaidaClienteGinasio;

-- Regista uma entrada/saída de um cliente no ginásio

DELIMITER $$
CREATE PROCEDURE entradaSaidaClienteGinasio
	(IN idClienteAdd INT, DataAdd DATE, IN HorarioAdd TIME, IN GinasioAdd INT)
BEGIN

	DECLARE UltimoHorarioRegistado TIME;
    DECLARE UltimaDataRegistada DATE;
    DECLARE UltimoEntradaSaidaRegistada ENUM('0','1');

	START TRANSACTION;
    
    -- Verificar se os dados existem
    IF NOT EXISTS (
		SELECT *
			FROM Ginasio
			WHERE idGinasio = GinasioAdd
	) OR NOT EXISTS (
		SELECT *
			FROM Cliente
			WHERE idCliente = idClienteAdd
	) THEN
		ROLLBACK;
	END IF;
    
    SELECT Horario, Data, EntradaSaida
    INTO UltimoHorarioRegistado, UltimaDataRegistada, UltimoEntradaSaidaRegistada
	FROM EntradasSaidas
		WHERE Cliente = idClienteAdd
			AND Ginasio = GinasioAdd
		ORDER BY Data DESC
        LIMIT 1;
    
    IF UltimaDataRegistada > DataAdd OR
		(UltimaDataRegistada = DataAdd AND UltimoHorarioRegistado >= HorarioAdd
    ) THEN
		ROLLBACK;
	ELSEIF UltimoEntradaSaidaRegistada = '0' THEN
		INSERT INTO EntradasSaidas
			(Cliente, Data, Horario, EntradaSaida, Ginasio)
			VALUES
				(idClienteAdd, DataAdd, HorarioAdd, '1', GinasioAdd);
	ELSEIF UltimoEntradaSaidaRegistada = '1' OR UltimoEntradaSaidaRegistada IS NULL THEN
		INSERT INTO EntradasSaidas
			(Cliente, Data, Horario, EntradaSaida, Ginasio)
			VALUES
				(idClienteAdd, DataAdd, HorarioAdd, '0', GinasioAdd);
	END IF;

	COMMIT;
END $$


CALL entradaSaidaClienteGinasio('1', '2023-01-01', '11:00:04', '1');
SELECT *
	FROM EntradasSaidas;

