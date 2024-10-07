USE Loja;
GO

CREATE SEQUENCE sequenciaIdPessoa
START WITH 1
INCREMENT BY 1;
GO

CREATE TABLE Pessoa (
idPessoa INTEGER NOT NULL,
nome VARCHAR(255) NOT NULL,
logradouro VARCHAR(255) NOT NULL,
cidade VARCHAR(255) NOT NULL,
estado CHAR(2) NOT NULL,
telefone VARCHAR(12) NOT NULL,
email VARCHAR(255) NOT NULL,
PRIMARY KEY(idPessoa));
GO

CREATE TABLE PessoaJuridica (
idPessoa INTEGER NOT NULL,
cnpj VARCHAR(14) NOT NULL,
PRIMARY KEY(idPessoa),
FOREIGN KEY(idPessoa) REFERENCES Pessoa(idPessoa));
GO

CREATE TABLE PessoaFisica (
idPessoa INTEGER NOT NULL,
cpf VARCHAR(11) NOT NULL,
PRIMARY KEY(idPessoa),
FOREIGN KEY(idPessoa) REFERENCES Pessoa(idPessoa));
GO

CREATE TABLE Produto (
idProduto INTEGER NOT NULL,
nome VARCHAR(255) NOT NULL,
quantidade INTEGER NOT NULL,
precoVenda NUMERIC NOT NULL,
PRIMARY KEY(idProduto));
GO

CREATE TABLE Usuario(
idUsuario INTEGER NOT NULL,
login VARCHAR(20) NOT NULL,
senha VARCHAR(20) NOT NULL,
PRIMARY KEY(idUsuario));
GO

CREATE TABLE Movimento(
idMovimento INTEGER NOT NULL,
idPessoa INTEGER NOT NULL,
idProduto INTEGER NOT NULL,
idUsuario INTEGER NOT NULL,
tipo CHAR(1) NOT NULL,
quantidade INTEGER NOT NULL,
valorUnitario NUMERIC NOT NULL,
PRIMARY KEY(idMovimento),
FOREIGN KEY(idPessoa) REFERENCES Pessoa(idPessoa),
FOREIGN KEY(idProduto) REFERENCES Produto(idProduto),
FOREIGN KEY(idUsuario) REFERENCES Usuario(idUsuario));
GO