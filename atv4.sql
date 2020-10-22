```sql
-- 1) Reescrever a consulta 17 da aula com a sintaxe do INNER JOIN;
SELECT a.nome_aluno, c.nome_curos, fsw.nome_fabr
FROM aluno a INNER JOIN matricula mt --aluno x matricula
             ON(a.id_aluno = mt.id_aluno)
             INNER JOIN turma t -- matricula x turma
             ON(mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
             INNER JOIN curso c --turma x curso
             ON(t.id_curso = c.id_curso) 
             INNER JOIN certificacao ce -- curso x certificacao
             ON(c.id_cert = ce.id_cert)
             INNER JOIN empresa_certificacao emp -- empresa_certificadora x certificacao
             ON(ce.id_empresa_cert = emp.id_empresa)
             INNER JOIN software sw -- software x uso_software
             ON(sw.id_softw = emp.id_softw)
             INNER JOIN uso_softwares_curso swc --uso_software x curso
             ON(swc.id_curso = c.id_curso)
             INNER JOIN fabricante_softw fsw -- software x fabricante
             ON(sw.id_fabr = fsw.id_fabr)
WHERE UPPER(emp.nome_empresa) LIKE '%'||UPPER(fsw.nome_fabr)||'%';

-- 2) Mostrar para cada curso a média de duração das turmas em dias;
SELECT c.nome_curso, AVG(t.dt_termino - t.dt_inicio) AS Media_turma
FROM curso c INNER JOIN turma t
            ON(c.id_curso = t.id_curso)
GROUP BY c.nome_curso;            

-- 3) Mostrar a quantidade de matriculados por curso, mês (use a data da matrícula) e sexo com idade superior a 21anos;
select * from matricula
select * from aluno
select * from curso
select * from uso_softwares_curso
select * from software
select * from turma
select * from empresa_certificacao
select * from certificacao
SELECT c.nome_curso, ROUND((current_date - a.dt_nascto_aluno)/365.25),0) AS Idade, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, a.sexo_aluno   
FROM aluno a JOIN matricula mt
             ON (a.id_aluno = mt.id_aluno)
             JOIN turma t
             ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
             JOIN curso c 
             ON (t.id_curso = c.id_curso)
 WHERE ROUND((current_date - a.dt_nascto_aluno)/365.25),0) > 21   
 GROUP BY nome_curso;

-- 4) Mostrar os cursosque utilizam mais de 3 softwares (nome do curso)
SELECT c.nome_curso
FROM curso c JOIN uso_softwares_curso sw
            ON(c.id_curso = sw.id_curso)
            JOIN software sfw
            ON(sw.id_software = sfw.id_softw)
GROUP BY c.nome_curso
HAVING COUNT(sfw.nome_softw) > 3

-- 5) Mostrar o nome do curso e a turma para os cursos da empresa Ciscoque tiveram mais de R$ 2mil de arrecadação por turma.
SELECT c.nome_curso, t.num_turma, emp.nome_empresa, SUM(mt.vl_pago) AS Arrecadacao
FROM turma t JOIN matricula mt
            ON(t.num_turma = mt.num_turma)
            JOIN curso c
            ON(mt.id_curso = c.id_curso)
            JOIN certificacao ce
            ON(c.id_cert = ce.id_cert)
            JOIN empresa_certificacao emp
            ON(ce.id_empresa_cert = emp.id_empresa)
GROUP BY c.nome_curso, t.num_turma, emp.nome_empresa
HAVING UPPER(emp.nome_empresa) LIKE '%CISCO%' AND SUM(mt.vl_pago) > 2000;
            
-- 6) Mostrar para cada empresa certificadora o valor total arrecadado e a média com as matrículas nos seus cursos, 
-- para cada mês, e o número de matriculados mas desde que ultrapassem mais de 50 por mês.
SELECT emp.nome_empresa, SUM(mt.vl_pago) AS Arrecadacao, AVG(mt.num_matricula) AS Media_matricula, EXTRACT(MONTH FROM mt.dt_hora_matr)
FROM turma t JOIN matricula mt
            ON(t.num_turma = mt.num_turma)
            JOIN curso c
            ON(mt.id_curso = c.id_curso)
            JOIN certificacao ce
            ON(c.id_cert = ce.id_cert)
            JOIN empresa_certificacao emp
            ON(ce.id_empresa_cert = emp.id_empresa)
GROUP BY emp.nome_empresa, EXTRACT(MONTH FROM mt.dt_hora_matr)
HAVING COUNT(mt.num_matricula) > 50;

-- 7) Mostrar para cada aluno (nome) a quantidade de aulas cursadas em cada curso matriculado.
SELECT a.nome_aluno, SUM(c.qtde_aulas) AS Aulas
FROM aluno a JOIN matricula mt
             ON (a.id_aluno = mt.id_aluno)
             JOIN turma t
             ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
             JOIN curso c 
             ON (t.id_curso = c.id_curso)
GROUP BY a.nome_aluno;
```