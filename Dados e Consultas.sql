USE Loja;
GO

-- Conjunto Usuários
INSERT INTO Usuario (idUsuario, login, senha)
VALUES
(1, 'op1', 'op1'),
(2, 'op2', 'op2');
GO

SELECT * FROM Usuario;
GO

-- Conjunto Produtos
INSERT INTO Produto (idProduto, nome, quantidade, precoVenda)
VALUES
(1, 'Banana', 100, 5.00),
(3, 'Laranja', 500, 2.00),
(4, 'Manga', 800, 4.00);
GO

SELECT * FROM Produto;
GO

-- Conjunto Pessoas
DECLARE @ID AS INTEGER = NEXT VALUE FOR sequenciaIdPessoa
INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@ID, 'Joao', 'Rua 12, casa 3, Quintanda', 'Riacho do Sul', 'PA', '1111-1111', 'joao@riacho.com');
INSERT INTO PessoaFisica (idPessoa, cpf)
VALUES (@ID, '11111111111');
GO

DECLARE @ID AS INTEGER = NEXT VALUE FOR sequenciaIdPessoa
INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@ID, 'JJC', 'Rua 11, Centro', 'Riacho do Norte', 'PA', '1212-1212', 'jjc@riacho.com');
INSERT INTO PessoaJuridica(idPessoa, cnpj)
VALUES (@ID, '22222222222222');
GO

SELECT * FROM Pessoa JOIN PessoaFisica ON (Pessoa.idPessoa = PessoaFisica.idPessoa);
SELECT * FROM Pessoa JOIN PessoaJuridica ON (Pessoa.idPessoa = PessoaJuridica.idPessoa);
GO

-- Conjunto Movimentações
UPDATE Produto SET precoVenda = 4.00 WHERE idProduto = 1;
GO

INSERT INTO Movimento (idMovimento, idPessoa, idProduto, idUsuario, tipo, quantidade, valorUnitario)
VALUES
(1, (SELECT idPessoa FROM Pessoa WHERE nome = 'Joao'), 1, 1, 'S', 20, (SELECT precoVenda FROM Produto WHERE idProduto = 1)),
(4, (SELECT idPessoa FROM Pessoa WHERE nome = 'Joao'), 3, 1, 'S', 15, (SELECT precoVenda FROM Produto WHERE idProduto = 3));
GO

UPDATE Produto SET precoVenda = 3.00 WHERE idProduto = 3;
GO

INSERT INTO Movimento (idMovimento, idPessoa, idProduto, idUsuario, tipo, quantidade, valorUnitario)
VALUES
(5, (SELECT idPessoa FROM Pessoa WHERE nome = 'Joao'), 3, 2, 'S', 10, (SELECT precoVenda FROM Produto WHERE idProduto = 3)),
(7, (SELECT idPessoa FROM Pessoa WHERE nome = 'JJC'), 3, 1, 'E', 15, 5.00),
(8, (SELECT idPessoa FROM Pessoa WHERE nome = 'JJC'), 4, 1, 'E', 20, 4.00);
GO

SELECT * FROM Movimento;
GO

-- Demais consultas
-- Dados completos de pessoas físicas
SELECT p.idPessoa, p.nome, p.logradouro, p.cidade, p.estado, p.telefone, p.email, pf.cpf
FROM Pessoa p JOIN PessoaFisica pf ON (p.idPessoa = pf.idPessoa);
GO

-- Dados completos de pessoas jurídicas
SELECT p.idPessoa, p.nome, p.logradouro, p.cidade, p.estado, p.telefone, p.email, pj.cnpj
FROM Pessoa p JOIN PessoaJuridica pj ON (p.idPessoa = pj.idPessoa);
GO

-- Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total
SELECT pr.nome, p.nome AS 'Fornecedor', m.quantidade, m.valorUnitario AS 'preço unitário', (m.quantidade * m.valorUnitario) AS 'valor total'
FROM Movimento m JOIN Produto pr ON (m.idProduto = pr.idProduto) JOIN Pessoa p ON (m.idPessoa = p.idPessoa)
WHERE m.tipo = 'E';
GO

-- Movimentações de saída, com produto, comprador, quantidade, preço unitário e valor total
SELECT pr.nome, p.nome AS 'Comprador', m.quantidade, m.valorUnitario AS 'preço unitário', (m.quantidade * m.valorUnitario) AS 'valor total'
FROM Movimento m JOIN Produto pr ON (m.idProduto = pr.idProduto) JOIN Pessoa p ON (m.idPessoa = p.idPessoa)
WHERE m.tipo = 'S';
GO

-- Valor total das entradas agrupadas por produto
SELECT pr.nome, SUM(m.quantidade * m.valorUnitario) AS 'valor total'
FROM Movimento m JOIN Produto pr ON (m.idProduto = pr.idProduto) WHERE m.tipo = 'E' GROUP BY pr.nome;
GO

-- Valor total das saídas agrupadas por produto
SELECT pr.nome, SUM(m.quantidade * m.valorUnitario) AS 'valor total'
FROM Movimento m JOIN Produto pr ON (m.idProduto = pr.idProduto) WHERE m.tipo = 'S' GROUP BY pr.nome;
GO

-- Operadores que não efetuaram movimentações de entrada (compra)
SELECT idUsuario FROM Movimento WHERE idUsuario NOT IN (SELECT idUsuario FROM Movimento WHERE tipo = 'E');
GO

-- Valor total de entrada, agrupado por operador
SELECT idUsuario, SUM(quantidade * valorUnitario) AS 'valor total de entrada' FROM Movimento WHERE tipo = 'E' GROUP BY idUsuario;
GO

-- Valor total de saída, agrupado por operador
SELECT idUsuario, SUM(quantidade * valorUnitario) AS 'valor total de saída' FROM Movimento WHERE tipo = 'S' GROUP BY idUsuario;
GO

-- Valor médio de venda por produto.
SELECT idProduto, (SUM(quantidade) / COUNT(idProduto)) AS 'valor médio de qt por venda' 
FROM Movimento WHERE tipo = 'S' GROUP BY idProduto;
GO