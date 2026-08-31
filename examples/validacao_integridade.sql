-- Deve retornar 0 em todas as consultas.
PRAGMA foreign_keys = ON;
SELECT COUNT(*) AS clientes_sem_cidade
FROM tb_cliente c LEFT JOIN tb_cidade ci ON ci.idCidade=c.idCidade
WHERE ci.idCidade IS NULL;

SELECT COUNT(*) AS locacoes_sem_cliente
FROM tb_locacao l LEFT JOIN tb_cliente c ON c.idCliente=l.idCliente
WHERE c.idCliente IS NULL;

SELECT COUNT(*) AS locacoes_sem_carro
FROM tb_locacao l LEFT JOIN tb_carro c ON c.idCarro=l.idCarro
WHERE c.idCarro IS NULL;

SELECT COUNT(*) AS locacoes_com_periodo_invalido
FROM tb_locacao
WHERE date(dataEntrega) < date(dataLocacao);
