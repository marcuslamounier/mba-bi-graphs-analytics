// 1. Create PAIS_Brasil Node and State-to-Country LOCALIZADA_EM Relationships
MERGE (p:Cidade {id_cidade: 'PAIS_Brasil', nm_cidade: 'Brasil', nm_estado: '', nm_pais: 'Brasil', ds_regiao_estrategia: 'LATAM'})
WITH p
MATCH (e:Cidade)
WHERE e.id_cidade STARTS WITH 'EST_'
MERGE (e)-[:LOCALIZADA_EM]->(p);

// 2. Create CONTRATA Relationships
// P1: Assinatura Plataforma (100% of clients with non-null dt_contratacao)
MATCH (c:Cliente)
WHERE c.dt_contratacao IS NOT NULL
MATCH (p1:Produto {id_produto: "P1"})
MERGE (c)-[:CONTRATA {dt_inicio: c.dt_contratacao, ds_frequencia: "Mensal", vl_contrato: 2000.0}]->(p1);

// P2: Relatórios Personalizados (20% of clients with non-null dt_contratacao)
MATCH (c:Cliente)
WHERE c.dt_contratacao IS NOT NULL
WITH c, rand() AS r
WHERE r < 0.2
MATCH (p2:Produto {id_produto: "P2"})
MERGE (c)-[:CONTRATA {dt_inicio: c.dt_contratacao, ds_frequencia: "Trimestral", vl_contrato: 5000.0}]->(p2);

// P3: Treinamentos e Eventos (10% of clients with non-null dt_contratacao)
MATCH (c:Cliente)
WHERE c.dt_contratacao IS NOT NULL
WITH c, rand() AS r
WHERE r < 0.1
MATCH (p3:Produto {id_produto: "P3"})
MERGE (c)-[:CONTRATA {dt_inicio: c.dt_contratacao, ds_frequencia: "Semestral", vl_contrato: 10000.0}]->(p3);

// 3. Create SIMILAR_A Relationships (10% of pairs, same sector and size)
MATCH (c1:Cliente)
MATCH (c2:Cliente)
WHERE c1.id_cliente < c2.id_cliente // Avoid duplicates
AND c1.ds_porte = c2.ds_porte
AND EXISTS {
    MATCH (c1)-[:PERTENCE_A]->(s:Setor)
    MATCH (c2)-[:PERTENCE_A]->(s2:Setor)
    WHERE s.id_setor = s2.id_setor
}
AND rand() < 0.1 // 10% chance
MERGE (c1)-[:SIMILAR_A {vl_similaridade: 0.6 + rand() * 0.3}]->(c2);
