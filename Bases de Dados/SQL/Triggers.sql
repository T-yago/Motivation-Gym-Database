--
-- Unidade Curricular de Bases de Dados.
-- Sistemas de Dados Relacionais.
-- SQL 
--
-- TRIGGERS
--


-- Schema Ginasio
USE Ginasio;


DROP TRIGGER  IF EXISTS Funcionario_insert_trigger;

-- Envia todos os vencimentos em falta quando se tenta alterar o ginásio ou o horário ou o salário base associado a um funcionário, assegurando assim a fiabilidade e coerência temporal dos vencimentos emitidos

DELIMITER $$
CREATE TRIGGER Funcionario_insert_trigger
BEFORE UPDATE ON Funcionario
FOR EACH ROW
BEGIN
	IF NEW.Ginasio <> OLD.Ginasio THEN
		CALL emiteSalarios();
	ELSEIF NEW.SalarioBase <> OLD.SalarioBase THEN
		CALL emiteSalarios();
	ELSEIF NEW.HorarioTrabalho <> OLD.HorarioTrabalho THEN
		CALL emiteSalarios();
	END IF;

END $$



DROP TRIGGER  IF EXISTS Cliente_insert_trigger;

-- Envia todos as faturas em falta quando se tenta alterar o plano de treino de um cliente, assegurando assim a fiabilidade e coerência temporal das faturas emitidas

DELIMITER $$
CREATE TRIGGER Cliente_insert_trigger
BEFORE UPDATE ON Cliente
FOR EACH ROW
BEGIN
	IF NEW.PlanoTreino <> OLD.PlanoTreino THEN
		CALL emiteFaturas();
	END IF;

END $$