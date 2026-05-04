
-- VIEW 1: fato_notas_long
-- Transforma as notas de colunas para linhas (formato analítico)
-- Necessário para análise por matéria no Power BI

CREATE OR REPLACE VIEW `escola_dados.vw_notas_long` AS
SELECT
    turma,
    ano_escolar,
    periodo,
    ano_letivo,
    matricula,
    nome_aluno,
    sexo,
    media_geral,
    situacao,
    materia,
    nota
FROM `escola_dados.notas_turmas`
UNPIVOT (
    nota FOR materia IN (
        Portugues, Matematica, Historia, Geografia,
        Ciencias, Fisica, Quimica, Biologia,
        Ingles, Educacao_Fisica, Arte, Filosofia
    )
);



-- VIEW 2: vw_resumo_aluno
-- Uma linha por aluno com todas as métricas consolidadas

CREATE OR REPLACE VIEW `escola_dados.vw_resumo_aluno` AS
SELECT
    turma,
    ano_escolar,
    periodo,
    matricula,
    nome_aluno,
    sexo,
    ROUND(media_geral, 2)          AS media_geral,
    situacao,

    -- Classificação de desempenho dentro da turma
    CASE
        WHEN media_geral >= 8.0 THEN 'Destaque'
        WHEN media_geral >= 7.0 THEN 'Bom'
        WHEN media_geral >= 5.0 THEN 'Regular'
        ELSE 'Dificuldade'
    END AS classificacao,

    -- Ranking dentro da turma (1 = melhor)
    RANK() OVER (PARTITION BY turma ORDER BY media_geral DESC) AS rank_turma,

    -- Ranking geral entre todas as turmas
    RANK() OVER (ORDER BY media_geral DESC)                    AS rank_geral,

    -- Percentil dentro da turma
    ROUND(PERCENT_RANK() OVER (PARTITION BY turma ORDER BY media_geral) * 100, 1) AS percentil_turma

FROM `escola_dados.notas_turmas`;



-- VIEW 3: vw_resumo_turma
-- Indicadores agregados por turma (para comparativo entre turmas)

CREATE OR REPLACE VIEW `escola_dados.vw_resumo_turma` AS
SELECT
    turma,
    ano_escolar,
    periodo,
    COUNT(*)                                                AS total_alunos,
    ROUND(AVG(media_geral), 2)                              AS media_turma,
    ROUND(STDDEV(media_geral), 2)                           AS desvio_padrao,
    ROUND(MIN(media_geral), 2)                              AS menor_nota,
    ROUND(MAX(media_geral), 2)                              AS maior_nota,
    COUNTIF(situacao = 'Aprovado')                          AS aprovados,
    COUNTIF(situacao = 'Recuperação')                       AS recuperacao,
    COUNTIF(situacao = 'Reprovado')                         AS reprovados,
    ROUND(COUNTIF(situacao = 'Aprovado')   / COUNT(*) * 100, 1) AS pct_aprovados,
    ROUND(COUNTIF(situacao = 'Reprovado')  / COUNT(*) * 100, 1) AS pct_reprovados,
    COUNTIF(media_geral >= 8.0)                             AS alunos_destaque,
    COUNTIF(media_geral < 5.0)                              AS alunos_dificuldade,

    -- Ranking de desempenho entre turmas
    RANK() OVER (ORDER BY AVG(media_geral) DESC)            AS rank_turma

FROM `escola_dados.notas_turmas`
GROUP BY turma, ano_escolar, periodo;



-- VIEW 4: vw_media_por_materia
-- Média de cada matéria por turma — para heatmap / barras no BI

CREATE OR REPLACE VIEW `escola_dados.vw_media_por_materia` AS
SELECT
    turma,
    ano_escolar,
    periodo,
    materia,
    ROUND(AVG(nota), 2)                                     AS media_nota,
    ROUND(MIN(nota), 2)                                     AS menor_nota,
    ROUND(MAX(nota), 2)                                     AS maior_nota,
    COUNTIF(nota < 5.0)                                     AS abaixo_da_media,
    COUNT(*)                                                AS total_alunos,

    -- Ranking da matéria dentro da turma (1 = melhor matéria)
    RANK() OVER (PARTITION BY turma ORDER BY AVG(nota) DESC) AS rank_materia_turma,

    -- Média da matéria entre todas as turmas
    ROUND(AVG(AVG(nota)) OVER (PARTITION BY materia), 2)    AS media_geral_materia

FROM `escola_dados.vw_notas_long`
GROUP BY turma, ano_escolar, periodo, materia;



-- VIEW 5: vw_destaques_e_dificuldades
-- Top 5 destaques e alunos com dificuldade por turma

CREATE OR REPLACE VIEW `escola_dados.vw_destaques_e_dificuldades` AS
WITH ranked AS (
    SELECT
        turma,
        ano_escolar,
        matricula,
        nome_aluno,
        ROUND(media_geral, 2)   AS media_geral,
        situacao,
        RANK() OVER (PARTITION BY turma ORDER BY media_geral DESC) AS rank_desc,
        RANK() OVER (PARTITION BY turma ORDER BY media_geral ASC)  AS rank_asc
    FROM `escola_dados.notas_turmas`
)
SELECT
    turma,
    ano_escolar,
    matricula,
    nome_aluno,
    media_geral,
    situacao,
    CASE
        WHEN rank_desc <= 5 THEN 'Destaque'
        WHEN rank_asc  <= 5 THEN 'Dificuldade'
        ELSE NULL
    END AS categoria
FROM ranked
WHERE rank_desc <= 5 OR rank_asc <= 5
ORDER BY turma, media_geral DESC;



-- VIEW 6: vw_comparativo_turmas
-- Comparativo lado a lado entre turmas (útil para tabela matrix no BI)

CREATE OR REPLACE VIEW `escola_dados.vw_comparativo_turmas` AS
SELECT
    m.materia,
    MAX(IF(t.turma = '1A', ROUND(m_media, 2), NULL)) AS turma_1A,
    MAX(IF(t.turma = '1B', ROUND(m_media, 2), NULL)) AS turma_1B,
    MAX(IF(t.turma = '2A', ROUND(m_media, 2), NULL)) AS turma_2A,
    MAX(IF(t.turma = '3A', ROUND(m_media, 2), NULL)) AS turma_3A,
    MAX(IF(t.turma = '3B', ROUND(m_media, 2), NULL)) AS turma_3B,
    ROUND(AVG(m_media), 2)                            AS media_geral_escola
FROM (
    SELECT turma, materia, AVG(nota) AS m_media
    FROM `escola_dados.vw_notas_long`
    GROUP BY turma, materia
) m
CROSS JOIN (SELECT DISTINCT turma FROM `escola_dados.notas_turmas`) t
GROUP BY m.materia
ORDER BY m.materia;


