```sql
--1
SELECT c.nome_curso || ' tem carga horária de ' || TO_CHAR(c.carga_hora_curso)||' horas' AS "Dados Curso"
FROM curso c
ORDER BY c.nome_curso DESC;

-- 2-
SELECT ce.nome_cert, ce.carga_hora_cert, ce.nota_corte_cert
FROM certificacao ce
WHERE (UPPER(ce.nome_cert) LIKE '%PROFESSIONAL%'
			OR UPPER(ce.nome_cert) LIKE '%INSTRUCTOR%' )
AND ce.nota_corte_cert >= 85

-- 3-
SELECT a.nome_aluno AS Aluna, ROUND((current.date a.dt_nascto_aluno)/365.25, 0) AS Idade, a.login
FROM aluno a
WHERE ROUND((current_date a.dt_nascto_aluno)/362.25,0) > 22
AND a.sexo_aluno = 'F'
		AND UPPER(a.login) NOT LIKE '%K%'
		AND UPPER(a.login) NOT LIKE '%Y%'
		AND UPPER(a.login) NOT LIKE '%W%'

-- 4
SELECT t.num_turma, TO_CHAR(t.dt_inicio, 'DD/MM/YYY') AS Data_inicio, t.vl_curso, t.vagas
FROM turma t
WHERE t.vagas BETWEEN 30 AND 50
AND t.vl_curso BETWEEN 450 ANF 550
AND TO_DATE(TO_CHAR(t.dt_inicio, 'DD/MM/YYY')) > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYY'));

-- 5
SELECT c.nome_curso, c.carga)hora_curso, t.num_turma, t.dt_inicio, t.vl_curso, t.vagas
FROM turma t INNER JOIN curso c
							ON(t.id_curso = c.id_curso)
WHERE t.vagas BETWEEN 30 AND 40
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR(t.dt_inicio, 'DD/MM/YYY')) > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYY'))

```