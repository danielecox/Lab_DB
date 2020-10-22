```sql
/******************************************
Aula 22/Setembro/ 2020
OUTER JOIN, Subqueires, CASE< DECODE
*******************************************/

-- 26 - Mostrar todos os dados do curso com a turma mais cara
SELECT c.*, t.num_turma, t.vl_curso
FROM curso c JOIN turma t ON(t.id_curso=c.id_curso)
WHERE t.vl_curso = (SELECT MAX(t.vl_curso) FROM turma t);

SELECT * FROM turma
ORDER BY vl_curso DESC;

--ppde ser enganoso
SELECT * FROM(
SELECT * FROM turma
ORDER BY vl_curso)
WHERE ROWNUM =1;

-- 27 - quem faz os mesmo cursos que a Maria Cristina
SELECT * FROM aluno;

SELECT a.nome_aluno, mt.id_curso
FROM matricula mt JOIN aluno a ON(mt.id_aluno = a.id_aluno)
WHERE mt.id_curso IN
                    (
                        SELECT mt.id_curso
                        FROM matricula mt JOIN aluno a ON(mt.id_aluno = a.id_aluno)
                        WHERE UPPER(a.nome_aluno) LIKE 'MARIA %'
                        AND UPPER(a.nome_aluno) LIKE '%CRISTINA%'
                    )
ORDER BY 1, 2;

-- JUNCAO EXTERNA - OUTER JOIN
-- alunos que fizeram matricula
SELECT a.id_aluno, a.nome_aluno, mt.id_curso, mt.id_aluno
FROM aluno a INNER JOIN matricula mt
             ON (a.id_aluno=mt.id_aluno)
ORDER BY 1;

-- 28 - alunos que não fizeram matricula -- indicar se estou fazendo A - B ou B - A
SELECT a.id_aluno, a.nome_aluno, mt.id_curso, mt.id_aluno
FROM aluno a LEFT OUTER JOIN matricula mt -- A - B ou seja Aluno - Matricula
             ON (a.id_aluno=mt.id_aluno) -- 14 linhas
WHERE mt-id_aluno IS NULL -- 2 matriculas não feitas = 14 -12
ORDER BY 1; 

-- Colocando agora matricula com prioritaria - nada retorna - Não existe FK sem apontar para a PK
SELECT a.id_aluno, a.nome_aluno, mt.id_curso, mt.id_aluno
FROM aluno a  RIGHT OUTER JOIN aluno a -- B -A ou seja Matricula - Aluno
             ON (a.id_aluno=mt.id_aluno) 
WHERE mt-id_aluno IS NULL 
ORDER BY 1; 

-- tornando aluno o lado direito do OUTER JOIN - resultado igual ao do LEFT anterioe
SELECT a.id_aluno, a.nome_aluno, mt.id_curso, mt.id_aluno
FROM matricula mt RIGHT OUTER JOIN aluno a -- B -A ou seja Matricula - Aluno
             ON (a.id_aluno=mt.id_aluno) 
WHERE mt-id_aluno IS NULL 
ORDER BY 1; 

/* o dono da chave primária vai ser o LEFT JOIN */

-- 29 - forma mais intuitiva com NOT IN -- não matriculados
SELECT a.id_aluno, a.nome_aluno
FROM aluno a -- todos os alunos
WHERE a.id_aluno NOT IN(
                            SELECT mt.id_aluno FROM matricula mt --alunos matriculados
                        );    
                        
-- 30 usando operador conjunto - no Oracle é MINUS na maioria dos outros é EXCEPT
SELECT a1.* FROM aluno a1 WHERE a1.id_aluno IN(
    SELECT a.id_aluno, a.nome_aluno FROM aluno a -- todos os alunos
    MINUS
    (SELECT mt.id_aluno FROM matricula mt)); --alunos matriculados);  
    
-- 31 mostrar todos os dados dos cursos que ainda não utilizam software
-- OUTER JOIN
SELECT * FROM uso_softwares_curso;
SELECT c.*, usw.id_curso AS Uso
FROM curso c LEFT OUTER JOIN uso_softwares_curso usw
             ON(c.id_curso=usw.id_curso)
WHERE usw.id_curso IS NULL;

--32 MINUS
SELECT c.* FROM curso c WHERE c.id_curso IN (
                                                SELECT c.id_curso FROM curso c;
                                                    MINUS 
                                                        SELECT usw.id_curso FROM uso_softwares_curso usw);
                                                        
--NOt IN
SELECT c.* FROM curso c WHERE c.id_curso NOT IN (
                                                  SELECT usw.id_curso FROM uso_softwares_curso usw);

-- 33 - alunos que fizeram matricula em certificacoes da Oracle mas não participaram de aula
SELECT a.nome_aluno, mt.id_curso, a.id_aluno AS tbAluno, pa.id_aluno AS TbParticipacao, pa.id_curso
FROM aluno a JOIN matricula mt ON(a.id_aluno=mt.id_aluno)
             JOIN turma t ON(mt.num_turma=t.num_turma AND mt.id_curso=t.id_curso)
             JOIN curso c ON (t.id_curso=c.id_curso)
             JOIN certificacao ce ON(ce.id_cert=c.id_cert)
             JOIN empresa_certificacao emp ON(ce.id_empresa_cert=emp.id_empresa)
             JOIN aula al ON (al.id_curso=c.id_curso)
             LEFT JOIN participacao_aula pa ON (al.id_curso=pa.id_curso AND al.num_aula=pa.num_aula
                                                AND pa.id_aluno=a.id_aluno)
WHERE UPPER(emp.nome_empresa) LIKE '%ORACLE%'
AND pa.id_aluno IS NULL;

-- 34 - DECODE - corresponde a um IF
SELECT a.nome_aluno, DECODE (a.sexo_aluno, 'M', 'Masculino', 'F', 'Feminino', null, '?') AS Sexo
FROM aluno a;

-- 35 CASE
SELECT a.nome_aluno, 
    CASE a.sexo_aluno
        WHEN 'M' THEN 'Masculino'
        WHEN 'F' THEN 'Feminino'
        WHEN NULL THEN '?'
     END AS Sexo
FROM aluno a;

-- outra forma
SELECT a.nome_aluno, 
    CASE 
        WHEN a.sexo_aluno = 'M' THEN 'Masculino'
        WHEN a.sexo_aluno = 'F' THEN 'Feminino'
        WHEN UPPER(email_aluno) LIKE '%FATEC%' THEN 'Fatecano'
        ELSE 'Sei lá'
     END AS Informacao
FROM aluno a;
```