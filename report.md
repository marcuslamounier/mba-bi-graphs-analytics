# Modelagem de Dados em Grafos para a startup VitalMind

**MBA em Business Intelligence – Turma 5BIR**
**Disciplina Graphs Analytics**

## VitalMind

A VitalMind é uma startup SaaS que desenvolve soluções para promover a saúde mental no ambiente corporativo. Seu modelo de negócio é baseado em três pilares principais:

1. **Plataforma SaaS de Monitoramento Preditivo**: Um software baseado em inteligência artificial que analisa dados de colaboradores (de forma anônima e ética) para prever riscos de saúde mental, como estresse ou burnout, permitindo intervenções proativas.
2. **Relatórios Personalizados e Benchmarking**: Relatórios detalhados sobre o bem-estar dos funcionários, com comparações setoriais, voltados para empresas que buscam insights estratégicos.
3. **Treinamentos e Eventos Exclusivos**: Programas de capacitação para líderes e equipes, focados em resiliência, gestão de estresse e cultura organizacional.

## Proposta de Modelagem em Grafos

Este trabalho propõe um modelo conceitual de banco de dados de grafo utilizando Neo4j para segmentação dos clientes da VitalMind. A modelagem considera os segmentos de empresas de médio e grande porte, distribuídas por setores econômicos e regiões geográficas, com o objetivo de suportar análises de mercado e personalização de serviços. O modelo inclui nós para Clientes, Setores, Produtos e Regiões, conectados por relacionamentos que representam interações e características.

## Planejamento

### Entidades

#### Clientes

Os clientes-alvo da VitalMind são empresas de médio porte (50-250 funcionários) e grande porte (>250 funcionários), distribuídas em setores como Tecnologia, Finanças, Manufatura, Saúde, Varejo e Serviços. A startup opera inicialmente no Brasil, com foco em cidades de médio e grande porte, como São Paulo, Rio de Janeiro e Belo Horizonte, mas planeja expansão para a América Latina. Cada segmento apresenta necessidades específicas:

- **Empresas de Médio Porte**: Priorizam soluções acessíveis e escaláveis.
- **Empresas de Grande Porte**: Demandam integração com sistemas existentes, relatórios avançados e conformidade regulatória.
- **Setores**: Tecnologia valoriza inovação e integração; Finanças e Saúde requerem conformidade; Manufatura busca produtividade.

Propriedades:

| **Nome** | **Tipo** | **Descrição** |
| --- | --- | --- |
| id_cliente | string | Identificador único do cliente |
| nm_fantasia | string | Nome da empresa |
| qt_funcionarios | int | Quantidade de funcionários |
| ds_porte | string | "Médio" ou "Grande" |
| id_cidade_sede | string | Código da cidade |
| dt_contratacao | date | Data de contratação |

#### Setores

Propriedades:

| **Nome** | **Tipo** | **Descrição** |
| --- | --- | --- |
| id_setor | string | Identificador único do setor |
| nm_setor | string | Nome do setor |
| ds_regulamentacao | string | Complexidade de regulamentação do setor (“Alta”, “Média”, “Baixa”) |

#### Produtos

Propriedades:

| **Nome** | **Tipo** | **Descrição** |
| --- | --- | --- |
| id_produto | string | Identificador único do produto |
| nm_produto | string | Nome do produto |
| ds_tipo | string | "Assinatura", "Relatório", "Treinamento" |
| vl_preco_base | float | Preço base ou unitário |

#### Cidades

Propriedades:

| **Nome** | **Tipo** | **Descrição** |
| --- | --- | --- |
| id_cidade | string | Identificador único da cidade |
| nm_cidade | string | Nome da cidade |
| nm_estado | string | Nome do estado |
| nm_pais | string | Nome do país |
| ds_regiao_estrategia | string | Descrição de campo para estratégia de vendas “LATAM”, “SP”, etc. |

### Relacionamentos

- (Cliente)-[:PERTENCE_A]->(Setor)
- (Cliente)-[:CONTRATA {dt_inicio, ds_frequencia, vl_contrato}]->(Produto)
- (Cliente)-[:SEDE_EM]->(Cidade)
- (Cidade)-[:LOCALIZADA_EM]->(Cidade)
- (Cliente)-[:SIMILAR_A {vl_similaridade}]->(Cliente)

## Execução e implementação

Para a implementação do modelo, foi criado um projeto do tipo “Blank Sandbox – Graph Data Science” na _sandbox_ do neo4j. No terminal executado via browser, foram executadas algumas linhas de código para a modelagem.

**_Criação das constantes para entidades_**

CREATE CONSTRAINT IF NOT EXISTS FOR (c:Cliente) REQUIRE c.id_cliente IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (s:Setor) REQUIRE s.id_setor IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (p:Produto) REQUIRE p.id_produto IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (ci:Cidade) REQUIRE ci.id_cidade IS UNIQUE;

**_Inclusão de dados para as entidades Setores e Produtos_**

// Criar Setores

CREATE (:Setor {id_setor: "S1", nm_setor: "Tecnologia", ds_regulamentacao: "Média"});

CREATE (:Setor {id_setor: "S2", nm_setor: "Finanças", ds_regulamentacao: "Alta"});

CREATE (:Setor {id_setor: "S3", nm_setor: "Manufatura", ds_regulamentacao: "Baixa"});

// Criar Produtos

CREATE (:Produto {id_produto: "P1", nm_produto: "Assinatura Plataforma", ds_tipo: "Assinatura", vl_preco_base: 2000.0});

CREATE (:Produto {id_produto: "P2", nm_produto: "Relatórios Personalizados", ds_tipo: "Relatório", vl_preco_base: 5000.0});

CREATE (:Produto {id_produto: "P3", nm_produto: "Treinamentos e Eventos", ds_tipo: "Treinamento", vl_preco_base: 10000.0});

**_Inclusão de dados para cidades_**

// Hierarquia Geográfica

MATCH (ci1:Cidade {id_cidade: "CID1"}), (ci3:Cidade {id_cidade: "CID3"})

CREATE (ci1)-\[:LOCALIZADA_EM\]->(ci3);

MATCH (ci2:Cidade {id_cidade: "CID2"}), (ci3:Cidade {id_cidade: "CID3"})

CREATE (ci2)-\[:LOCALIZADA_EM\]->(ci3);

**_Inclusão de dados para clientes_**

// Hierarquia Geográfica

MATCH (ci1:Cidade {id_cidade: "CID1"}), (ci3:Cidade {id_cidade: "CID3"})

CREATE (ci1)-\[:LOCALIZADA_EM\]->(ci3);

MATCH (ci2:Cidade {id_cidade: "CID2"}), (ci3:Cidade {id_cidade: "CID3"})

CREATE (ci2)-\[:LOCALIZADA_EM\]->(ci3);

crescente demanda por soluções de bem-estar no ambiente corporativo tem impulsionado o surgimento de startups SaaS (Software as a Service) voltadas para saúde mental. A VitalMind é uma dessas empresas, oferecendo uma plataforma de monitoramento preditivo, relatórios personalizados e treinamentos corporativos. Para competir em um mercado dinâmico, a segmentação eficaz de clientes é essencial, permitindo a personalização de serviços e a otimização de estratégias de marketing.

Bancos de dados de grafo, como o Neo4j, são particularmente adequados para modelar relações complexas entre entidades, como clientes, produtos e localizações geográficas. Este trabalho propõe um modelo conceitual em Neo4j para a VitalMind, com foco na segmentação de clientes por tamanho, setor e região. A pesquisa é guiada pela seguinte questão: _Como um modelo de grafo pode suportar a segmentação de clientes em uma startup SaaS de saúde mental corporativa?_

O artigo está organizado da seguinte forma: a Seção 2 descreve o conceito da VitalMind; a Seção 3 detalha a metodologia de modelagem; a Seção 4 apresenta o modelo conceitual e sua implementação; a Seção 5 discute os resultados; a Seção 6 conclui o trabalho; e a Seção 7 lista as referências.

**2.2. Relevância Estratégica**

A segmentação de clientes é crítica para a VitalMind, pois permite personalizar ofertas, otimizar campanhas de marketing e identificar oportunidades de cross-selling. Um modelo de dados que represente essas relações complexas pode suportar decisões estratégicas, como direcionar treinamentos para setores específicos ou expandir para novas regiões.

**3\. Metodologia**

A metodologia combina análise do contexto de negócio da VitalMind com técnicas de modelagem de dados em grafo. As etapas incluem:

1. **Análise do Negócio**: Identificação dos segmentos de clientes, produtos e interações com base em documentos internos da VitalMind (Canvas de Negócio e análise de concorrência).
2. **Definição do Modelo Conceitual**: Criação de nós (entidades) e relacionamentos para representar clientes, setores, produtos e regiões, seguindo as boas práticas de modelagem em Neo4j ().
3. **Implementação**: Desenvolvimento de um esquema em Cypher, com exemplos de nós e relacionamentos, e geração de uma lista fictícia de 300 potenciais clientes em cidades brasileiras.
4. **Validação**: Proposição de consultas Cypher para verificar a funcionalidade do modelo, como análises de segmentação e identificação de padrões.

Os dados de clientes foram gerados de forma fictícia, mas baseados em distribuições realistas de setores e cidades, utilizando fontes como o IBGE () e relatórios de mercado (,).

**4\. Modelagem de Dados em Neo4j**

**4.1. Modelo Conceitual**

O modelo conceitual foi projetado para representar os segmentos de clientes da VitalMind e suas interações com produtos e localizações. Os elementos principais são:

**Nós**

- **Cliente**: Representa uma empresa cliente.
  - Propriedades: id (string), nome (string), tamanho (int), segmento_tamanho (string: "Médio" ou "Grande"), localizacao (string), data_contratacao (date).
- **Setor**: Representa o setor de atuação (ex.: Tecnologia, Finanças).
  - Propriedades: nome (string), regulamentacao (string: "Alta", "Média", "Baixa").
- **Produto**: Representa os serviços da VitalMind.
  - Propriedades: id (string), nome (string), tipo (string: "Assinatura", "Relatório", "Treinamento"), preco_base (float).
- **Regiao**: Representa localizações geográficas.
  - Propriedades: nome (string), tipo (string: "Cidade", "Estado", "País", "Continente").

**Relacionamentos**

- **(:Cliente)-\[:PERTENCE_A\]->(:Setor)**: Indica o setor da empresa.
- **(:Cliente)-\[:USA {data_inicio, frequencia, valor_contrato}\]->(:Produto)**: Representa a contratação de produtos.
- **(:Cliente)-\[:LOCALIZADO_EM\]->(:Regiao)**: Associa o cliente a uma região.
- **(:Regiao)-\[:CONTEM\]->(:Regiao)**: Modela a hierarquia geográfica (ex.: São Paulo contém Brasil).
- **(:Cliente)-\[:SIMILAR_A {similaridade}\]->(:Cliente)**: Conecta clientes com características semelhantes.

**Diagrama**

(Cliente)-\[:PERTENCE_A\]->(Setor)

(Cliente)-\[:USA {data_inicio, frequencia, valor_contrato}\]->(Produto)

(Cliente)-\[:LOCALIZADO_EM\]->(Regiao)

(Regiao)-\[:CONTEM\]->(Regiao)

(Cliente)-\[:SIMILAR_A {similaridade}\]->(Cliente)

**4.2. Implementação**

O modelo foi implementado em Cypher, com constraints para garantir unicidade e exemplos de nós e relacionamentos. Abaixo, um trecho do código:

CREATE CONSTRAINT IF NOT EXISTS FOR (c:Cliente) REQUIRE c.id IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (p:Produto) REQUIRE p.id IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (s:Setor) REQUIRE s.nome IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (r:Regiao) REQUIRE r.nome IS UNIQUE;

// Exemplo de Nós

CREATE (:Setor {nome: "Tecnologia", regulamentacao: "Média"});

CREATE (:Produto {id: "P1", nome: "Assinatura Plataforma", tipo: "Assinatura", preco_base: 2000.0});

CREATE (:Regiao {nome: "São Paulo", tipo: "Cidade"});

CREATE (:Cliente {id: "C1", nome: "TechCorp", tamanho: 200, segmento_tamanho: "Médio", localizacao: "São Paulo", data_contratacao: date("2025-01-01")});

// Exemplo de Relacionamentos

MATCH (c:Cliente {id: "C1"}), (s:Setor {nome: "Tecnologia"}) CREATE (c)-\[:PERTENCE_A\]->(s);

MATCH (c:Cliente {id: "C1"}), (p:Produto {id: "P1"}) CREATE (c)-\[:USA {data_inicio: date("2025-01-01"), frequencia: "Mensal", valor_contrato: 2000.0}\]->(p);

MATCH (c:Cliente {id: "C1"}), (r:Regiao {nome: "São Paulo"}) CREATE (c)-\[:LOCALIZADO_EM\]->(r);

**4.3. Dados de Clientes**

Para testar o modelo, foi gerada uma lista fictícia de 300 potenciais clientes em cidades brasileiras de médio e grande porte (ex.: São Paulo, Recife, Joinville). A distribuição considera:

- **Regiões**: 50% Sudeste, 20% Sul, 20% Nordeste, 10% Centro-Oeste/Norte.
- **Setores**: Tecnologia (30%), Finanças (20%), Manufatura (20%), Saúde (15%), Varejo (10%), Serviços (5%).
- **Tamanho**: 60% médio porte, 40% grande porte.

Exemplo de trecho do CSV gerado:

id,nome,tamanho,segmento_tamanho,setor,cidade,estado,data_contratacao

C001,TechVida Solutions,150,Médio,Tecnologia,São Paulo,SP,2025-01-15

C002,CorpFin Group,400,Grande,Finanças,Rio de Janeiro,RJ,null

C003,InovaManufatura,200,Médio,Manufatura,Belo Horizonte,MG,2024-12-01

O CSV completo foi projetado para importação no Neo4j, com comando como:

LOAD CSV WITH HEADERS FROM 'file:///potenciais_clientes_vitalmind.csv' AS row

MERGE (c:Cliente {id: row.id})

SET c.nome = row.nome, c.tamanho = toInteger(row.tamanho), c.segmento_tamanho = row.segmento_tamanho

MERGE (s:Setor {nome: row.setor})

MERGE (c)-\[:PERTENCE_A\]->(s);

**5\. Resultados e Discussão**

O modelo conceitual proposto permite segmentar clientes da VitalMind de forma eficiente, suportando análises como:

- **Distribuição por Setor**: Consultas Cypher podem identificar quais setores (ex.: Tecnologia) contratam mais produtos, como:
- MATCH (c:Cliente)-\[:PERTENCE_A\]->(s:Setor), (c)-\[:USA\]->(p:Produto)
- RETURN s.nome, p.nome, COUNT(\*) AS total ORDER BY total DESC;
- **Padrões Geográficos**: A hierarquia de regiões facilita análises regionais (ex.: clientes em São Paulo vs. Recife).
- **Recomendações**: O relacionamento SIMILAR_A suporta estratégias de cross-selling, como recomendar relatórios para clientes de Finanças que já usam a plataforma.

A lista de 300 clientes fictícios reflete a realidade econômica brasileira, com maior concentração no Sudeste (50%) devido à densidade de empresas (). A flexibilidade do modelo permite expansão para novos setores, produtos ou regiões, como a América Latina, planejada pela VitalMind.

**5.1. Limitações**

- **Dados Fictícios**: A ausência de dados reais limita a validação prática do modelo. Dados de fontes como Crunchbase () poderiam enriquecer a análise.
- **Complexidade**: Relacionamentos como SIMILAR_A exigem algoritmos de similaridade (ex.: baseados em machine learning) para valores precisos, não implementados aqui.
- **Escopo**: O modelo foca em segmentação estática, sem considerar dinâmicas temporais (ex.: churn de clientes).

**6\. Conclusão**

Este trabalho apresentou o conceito da VitalMind, uma startup SaaS de saúde mental corporativa, e desenvolveu um modelo conceitual em Neo4j para segmentação de clientes. O modelo, baseado em nós (Cliente, Setor, Produto, Regiao) e relacionamentos (PERTENCE_A, USA, LOCALIZADO_EM, CONTEM, SIMILAR_A), oferece uma estrutura robusta para análises estratégicas. A geração de 300 potenciais clientes fictícios demonstrou a aplicabilidade do modelo em um contexto brasileiro, com potencial para suportar decisões de marketing e expansão.

Futuros trabalhos podem incorporar dados reais, expandir o modelo para incluir dinâmicas de interação com colaboradores ou integrar algoritmos de recomendação. A abordagem de grafos se mostra promissora para startups SaaS, especialmente em mercados competitivos como o de saúde mental corporativa.

**7\. Referências**

1. IBGE. (2023). _Estimativas da População_. Disponível em: [https://www.ibge.gov.br](https://www.ibge.gov.br/).
2. Gartner. (2024). _Forecast: Enterprise Software Markets, Worldwide_. Disponível em: [https://www.gartner.com](https://www.gartner.com/).
3. Crunchbase. (2025). _Database of Companies and Startups_. Disponível em: [https://www.crunchbase.com](https://www.crunchbase.com/).
4. Neo4j. (2024). _Graph Data Modeling Guidelines_. Disponível em: <https://neo4j.com/developer/graph-modeling>.
5. SEBRAE. (2023). _Panorama das Startups no Brasil_. Disponível em: [https://www.sebrae.com.br](https://www.sebrae.com.br/).
