-- Consultas analíticas para demonstrar o uso do modelo dimensional.

-- 1. Faturamento por mês de locação.
SELECT d.ano, d.mes, d.nomeMes,
       COUNT(*) AS qtd_locacoes,
       ROUND(SUM(f.valorTotal), 2) AS faturamento
FROM fato_locacao f
JOIN dim_data d ON d.skData=f.skDataLocacao
GROUP BY d.ano,d.mes,d.nomeMes
ORDER BY d.ano,d.mes;

-- 2. Faturamento e quantidade de locações por vendedor.
SELECT v.nome,
       COUNT(*) AS qtd_locacoes,
       ROUND(SUM(f.valorTotal),2) AS faturamento
FROM fato_locacao f
JOIN dim_vendedor v ON v.skVendedor=f.skVendedor
GROUP BY v.skVendedor,v.nome
ORDER BY faturamento DESC;

-- 3. Carros com maior número de locações.
SELECT c.marca,c.modelo,c.ano,
       COUNT(*) AS qtd_locacoes,
       ROUND(SUM(f.valorTotal),2) AS faturamento
FROM fato_locacao f
JOIN dim_carro c ON c.skCarro=f.skCarro
GROUP BY c.skCarro,c.marca,c.modelo,c.ano
ORDER BY qtd_locacoes DESC, faturamento DESC;

-- 4. Desempenho por combustível.
SELECT c.tipo,
       COUNT(*) AS qtd_locacoes,
       ROUND(SUM(f.valorTotal),2) AS faturamento,
       ROUND(AVG(f.valorTotal),2) AS ticket_medio
FROM fato_locacao f
JOIN dim_combustivel c ON c.skCombustivel=f.skCombustivel
GROUP BY c.skCombustivel,c.tipo
ORDER BY faturamento DESC;

-- 5. Quilometragem média registrada por carro.
SELECT c.marca,c.modelo,
       COUNT(*) AS qtd_locacoes,
       ROUND(AVG(f.kmCarro),0) AS km_medio
FROM fato_locacao f
JOIN dim_carro c ON c.skCarro=f.skCarro
GROUP BY c.skCarro,c.marca,c.modelo
ORDER BY km_medio DESC;

-- 6. Clientes com maior número de locações.
SELECT c.nomeCliente,c.cidade,c.estado,
       COUNT(*) AS qtd_locacoes,
       ROUND(SUM(f.valorTotal),2) AS valor_total
FROM fato_locacao f
JOIN dim_cliente c ON c.skCliente=f.skCliente
GROUP BY c.skCliente,c.nomeCliente,c.cidade,c.estado
ORDER BY qtd_locacoes DESC, valor_total DESC;
