-- ------------------------------------------------------
-- ------------------------------------------------------
-- Universidade do Minho
-- Mestrado Integrado em Engenharia Informática
-- Lincenciatura em Ciências da Computação
-- Unidade Curricular de Bases de Dados
-- 
-- Caso de Estudo: Ginásio
-- Criação da Base de Dados
-- Junho/2023
-- ------------------------------------------------------
-- ------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';
-- -----------------------------------------------------
-- Schema Ginasio
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS Ginasio ;
-- -----------------------------------------------------
-- Schema Ginasio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS Ginasio;
USE Ginasio ;
-- -----------------------------------------------------
-- Table PlanoTreino
-- -----------------------------------------------------
DROP TABLE IF EXISTS PlanoTreino ;

CREATE TABLE IF NOT EXISTS PlanoTreino (
  Id ENUM('1','2','3') NOT NULL,
  Preco DECIMAL(8,2) NOT NULL,
  HorarioFim TIME NOT NULL,
  HorarioInicio TIME NOT NULL,
  PRIMARY KEY (Id))
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;

-- -----------------------------------------------------
-- Table Cliente
-- -----------------------------------------------------
DROP TABLE IF EXISTS Cliente ;

CREATE TABLE IF NOT EXISTS Cliente (
  idCliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
  NIF INT NOT NULL,
  DataNascimento DATE NOT NULL,
  Email VARCHAR(150) NOT NULL,
  Sexo ENUM('0','1') NOT NULL,
  Nome VARCHAR(45) NOT NULL,
  CodigoPostal VARCHAR(30) NOT NULL,
  Rua VARCHAR(100) NOT NULL,
  Cidade VARCHAR(50) NOT NULL,
  Distrito VARCHAR(30) NOT NULL,
  CondicoesMedicas VARCHAR(500) NULL,
  Extras ENUM('0','1','2','3') DEFAULT '0',
  PlanoTreino ENUM('1','2','3') NOT NULL,
  PRIMARY KEY (idCliente),
  CONSTRAINT fk_Cliente_PlanoTreino
  FOREIGN KEY (PlanoTreino)
    REFERENCES PlanoTreino (Id)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table ClienteTelefones
-- -----------------------------------------------------
DROP TABLE IF EXISTS ClienteTelefones ;

CREATE TABLE IF NOT EXISTS ClienteTelefones (
  Telemovel INT NOT NULL,
  Cliente INT UNSIGNED NOT NULL,
  PRIMARY KEY (Telemovel, Cliente),
  CONSTRAINT fk_ClienteTelefones_Cliente
  FOREIGN KEY (Cliente)
    REFERENCES Cliente (idCliente)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table EntradasSaidas
-- -----------------------------------------------------
DROP TABLE IF EXISTS EntradasSaidas ;

CREATE TABLE IF NOT EXISTS EntradasSaidas (
  Cliente INT UNSIGNED NOT NULL,
  Data DATE NOT NULL,
  Horario TIME NOT NULL,
  EntradaSaida ENUM('0','1') NOT NULL,
  Ginasio INT NOT NULL,
  PRIMARY KEY (Cliente, Data, Horario, Ginasio),
  CONSTRAINT fk_EntradasSaidas_Cliente
  FOREIGN KEY (Cliente)
    REFERENCES Cliente (idCliente)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table Fatura
-- -----------------------------------------------------
DROP TABLE IF EXISTS Fatura ;

CREATE TABLE IF NOT EXISTS Fatura (
  idFatura INT UNSIGNED NOT NULL AUTO_INCREMENT,
  MetodoPagamento ENUM('0','1','2') NULL DEFAULT NULL,
  ValorMensalidade DECIMAL(8,2) NOT NULL,
  DataEmissao DATE NOT NULL,
  PrecoTotal DECIMAL(8,2) NOT NULL,
  DataPagamento DATE NULL DEFAULT NULL,
  Cliente INT NOT NULL,
  PRIMARY KEY (idFatura))
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;

SELECT * FROM Cliente;
-- -----------------------------------------------------
-- Table Funcao
-- -----------------------------------------------------
DROP TABLE IF EXISTS Funcao ;

CREATE TABLE IF NOT EXISTS Funcao (
  Nome ENUM('Treinador de Sala', 'Treinador Privado', 'Treinador de Grupo', 'Rececionista', 'Diretor') NOT NULL,
  PRIMARY KEY (Nome))
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table Funcionario
-- -----------------------------------------------------
DROP TABLE IF EXISTS Funcionario ;

CREATE TABLE IF NOT EXISTS Funcionario (
  idFuncionário INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  NIF INT NOT NULL,
  Sexo ENUM('0','1') NOT NULL,
  DataNascimento DATE NOT NULL,
  Email VARCHAR(150) NOT NULL,
  Rua VARCHAR(100) NOT NULL,
  Cidade VARCHAR(50) NOT NULL,
  CodigoPostal VARCHAR(30) NOT NULL,
  Distrito VARCHAR(30) NOT NULL,
  DataContratacao DATE NOT NULL,
  Ginasio INT NOT NULL,
  SalarioBase DECIMAL(8,4) NOT NULL,
  HorarioTrabalho ENUM('1','2','3') NOT NULL,
  PRIMARY KEY (idFuncionário))
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table FuncionarioCliente
-- -----------------------------------------------------
DROP TABLE IF EXISTS FuncionarioCliente ;

CREATE TABLE IF NOT EXISTS FuncionarioCliente (
  idAula INT UNSIGNED NOT NULL AUTO_INCREMENT,
  HorarioInicio DATETIME NOT NULL,
  HorarioFim DATETIME NOT NULL,
  Espaco ENUM('0','1','2','3','4','5') DEFAULT '0',
  Modalidade VARCHAR(30) NOT NULL,
  Valor DECIMAL(8,4) NOT NULL,
  Funcionario INT UNSIGNED NOT NULL,
  Cliente INT UNSIGNED NULL,
  Ginasio INT UNSIGNED NOT NULL, 
  PRIMARY KEY (idAula),
  CONSTRAINT fk_FuncionarioCliente_Cliente
  FOREIGN KEY (Cliente)
    REFERENCES Cliente (idCliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_FuncionarioCliente_Funcionario
  FOREIGN KEY (Funcionario)
    REFERENCES Funcionario (idFuncionário)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table FuncionarioFuncao
-- -----------------------------------------------------
DROP TABLE IF EXISTS FuncionarioFuncao ;

CREATE TABLE IF NOT EXISTS FuncionarioFuncao (
  Funcionario INT UNSIGNED NOT NULL,
  Funcao ENUM('Treinador de Sala', 'Treinador Privado', 'Treinador de Grupo', 'Rececionista', 'Diretor') NOT NULL,
  PRIMARY KEY (Funcionario, Funcao),
  CONSTRAINT fk_FuncionarioFuncao_Funcao
  FOREIGN KEY (Funcao)
    REFERENCES Funcao (Nome)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_FuncionarioFuncao_Funcionario
  FOREIGN KEY (Funcionario)
    REFERENCES Funcionario (idFuncionário)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table FuncionarioGinasio
-- -----------------------------------------------------
DROP TABLE IF EXISTS FuncionarioGinasio ;

CREATE TABLE IF NOT EXISTS FuncionarioGinasio (
  DataPagamento DATE NOT NULL,
  SalarioBase DECIMAL(8,4) NOT NULL,
  SalarioTotal DECIMAL(8,4) NOT NULL,
  HorarioTrabalho ENUM('1','2','3') NOT NULL,
  Funcionario INT UNSIGNED NOT NULL,
  Ginasio INT UNSIGNED NOT NULL,
  PRIMARY KEY (DataPagamento, Funcionario, Ginasio),
  CONSTRAINT fk_FuncionarioGinasio_Funcionario
  FOREIGN KEY (Funcionario)
    REFERENCES Funcionario (idFuncionário)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_FuncionarioGinasio_Ginasio
  FOREIGN KEY (Ginasio)
    REFERENCES Ginasio (idGinasio)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table FuncionarioTelefones
-- -----------------------------------------------------
DROP TABLE IF EXISTS FuncionarioTelefones ;

CREATE TABLE IF NOT EXISTS FuncionarioTelefones (
  Telemovel INT NOT NULL,
  Funcionario INT UNSIGNED NOT NULL,
  PRIMARY KEY (Telemovel, Funcionario),
  CONSTRAINT fk_FuncionarioTelefones_Funcionario
  FOREIGN KEY (Funcionario)
    REFERENCES Funcionario (idFuncionário)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table Ginasio
-- -----------------------------------------------------
DROP TABLE IF EXISTS Ginasio ;

CREATE TABLE IF NOT EXISTS Ginasio (
  idGinasio INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(30) NOT NULL,
  DataAbertura DATE NOT NULL,
  Rua VARCHAR(100) NOT NULL,
  CodigoPostal VARCHAR(30) NOT NULL,
  Cidade VARCHAR(50) NOT NULL,
  Distrito VARCHAR(30) NOT NULL,
  PRIMARY KEY (idGinasio))
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


-- -----------------------------------------------------
-- Table GinasioCliente
-- -----------------------------------------------------
DROP TABLE IF EXISTS GinasioCliente ;

CREATE TABLE IF NOT EXISTS GinasioCliente (
  DataInscricao DATE NOT NULL,
  Ginasio INT UNSIGNED NOT NULL,
  Cliente INT UNSIGNED NOT NULL,
  PRIMARY KEY (Ginasio, Cliente),
  CONSTRAINT fk_GinasioCliente_Ginasio
  FOREIGN KEY (Ginasio)
    REFERENCES Ginasio (idGinasio)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_GinasioCliente_Cliente
  FOREIGN KEY (Cliente)
    REFERENCES Cliente (idCliente)
    ON DELETE RESTRICT ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARSET=utf8MB4;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
