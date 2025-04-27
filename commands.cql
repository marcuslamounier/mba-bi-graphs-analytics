// 1. Criar Constraints
CREATE CONSTRAINT IF NOT EXISTS FOR (c:Cliente) REQUIRE c.id_cliente IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (s:Setor) REQUIRE s.id_setor IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:Produto) REQUIRE p.id_produto IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (ci:Cidade) REQUIRE ci.id_cidade IS UNIQUE;

// 2. Criar Setores
CREATE (:Setor {id_setor: "S1", nm_setor: "Tecnologia", ds_regulamentacao: "Média"});
CREATE (:Setor {id_setor: "S2", nm_setor: "Finanças", ds_regulamentacao: "Alta"});
CREATE (:Setor {id_setor: "S3", nm_setor: "Manufatura", ds_regulamentacao: "Baixa"});
CREATE (:Setor {id_setor: "S4", nm_setor: "Saúde", ds_regulamentacao: "Alta"});
CREATE (:Setor {id_setor: "S5", nm_setor: "Varejo", ds_regulamentacao: "Média"});
CREATE (:Setor {id_setor: "S6", nm_setor: "Serviços", ds_regulamentacao: "Baixa"});

// 3. Criar Produtos
CREATE (:Produto {id_produto: "P1", nm_produto: "Assinatura Plataforma", ds_tipo: "Assinatura", vl_preco_base: 2000.0});
CREATE (:Produto {id_produto: "P2", nm_produto: "Relatórios Personalizados", ds_tipo: "Relatório", vl_preco_base: 5000.0});
CREATE (:Produto {id_produto: "P3", nm_produto: "Treinamentos e Eventos", ds_tipo: "Treinamento", vl_preco_base: 10000.0});

// 4. Importar Cidades
LOAD CSV WITH HEADERS FROM 'https://github.com/marcuslamounier/mba-bi-graphs-analytics/blob/main/data/cidades_vitalmind.csv' AS row
MERGE (ci:Cidade {id_cidade: row.id_cidade})
SET ci.nm_cidade = row.nm_cidade,
    ci.nm_estado = row.nm_estado,
    ci.nm_pais = row.nm_pais,
    ci.ds_regiao_estrategia = row.ds_regiao_estrategia
MERGE (e:Cidade {id_cidade: 'EST_' + row.nm_estado, nm_cidade: row.nm_estado, nm_estado: row.nm_estado, nm_pais: row.nm_pais, ds_regiao_estrategia: row.ds_regiao_estrategia})
MERGE (p:Cidade {id_cidade: 'PAIS_Brasil', nm_cidade: 'Brasil', nm_estado: '', nm_pais: 'Brasil', ds_regiao_estrategia: 'LATAM'})
MERGE (ci)-[:LOCALIZADA_EM]->(e)
MERGE (e)-[:LOCALIZADA_EM]->(p);

// 5. Importar Clientes e Relacionamentos PERTENCE_A e SEDE_EM
LOAD CSV WITH HEADERS FROM 'https://github.com/marcuslamounier/mba-bi-graphs-analytics/blob/main/data/potenciais_clientes_vitalmind_novo_completo.csv' AS row
MERGE (c:Cliente {id_cliente: row.id_cliente})
SET c.nm_fantasia = row.nm_fantasia,
    c.qt_funcionarios = toInteger(row.qt_funcionarios),
    c.ds_porte = row.ds_porte,
    c.id_cidade_sede = row.id_cidade_sede,
    c.dt_contratacao = CASE row.dt_contratacao WHEN '' THEN null ELSE date(row.dt_contratacao) END
MERGE (s:Setor {id_setor: row.id_setor})
MERGE (ci:Cidade {id_cidade: row.id_cidade_sede})
MERGE (c)-[:PERTENCE_A]->(s)
MERGE (c)-[:SEDE_EM]->(ci);

// 6. Criar Relacionamentos CONTRATA (para clientes com dt_contratacao não nulo)
LOAD CSV WITH HEADERS FROM 'file:///potenciais_clientes_vitalmind_novo_completo.csv' AS row
MATCH (c:Cliente {id_cliente: row.id_cliente})
WHERE row.dt_contratacao IS NOT NULL
MATCH (p1:Produto {id_produto: "P1"}) // Assinatura Plataforma
MERGE (c)-[:CONTRATA {dt_inicio: date(row.dt_contratacao), ds_frequencia: "Mensal", vl_contrato: 2000.0}]->(p1)
WITH c, row
WHERE rand() < 0.2 // 20% também contratam Relatórios
MATCH (p2:Produto {id_produto: "P2"})
MERGE (c)-[:CONTRATA {dt_inicio: date(row.dt_contratacao), ds_frequencia: "Trimestral", vl_contrato: 5000.0}]->(p2)
WITH c, row
WHERE rand() < 0.1 // 10% também contratam Treinamentos
MATCH (p3:Produto {id_produto: "P3"})
MERGE (c)-[:CONTRATA {dt_inicio: date(row.dt_contratacao), ds_frequencia: "Semestral", vl_contrato: 10000.0}]->(p3);

// 7. Criar Relacionamentos SIMILAR_A (10% dos clientes, mesmo setor e porte)
MATCH (c1:Cliente)
MATCH (c2:Cliente)
WHERE c1.id_cliente < c2.id_cliente // Evitar duplicatas
AND c1.ds_porte = c2.ds_porte
AND c1.id_cliente IN (
    MATCH (c:Cliente)-[:PERTENCE_A]->(s:Setor)
    WHERE c.id_cliente = c1.id_cliente
    MATCH (c2:Cliente)-[:PERTENCE_A]->(s2:Setor)
    WHERE c2.id_cliente = c2.id_cliente AND s.id_setor = s2.id_setor
    RETURN c1.id_cliente
)
AND rand() < 0.1 // 10% de chance
MERGE (c1)-[:SIMILAR_A {vl_similaridade: 0.6 + rand() * 0.3}]->(c2); // Similaridade entre 0.6 e 0.9