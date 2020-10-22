```sql
-- Table pessoa
CREATE TABLE paciente (
id_sus INTEGER NOT NULL PRIMARY KEY,
nome_paciente VARCHAR2(50) NOT NULL,
endereco_paciente VARCHAR(50) NULL,
rg_paciente NUMERIC(9) NOT NULL
cpf_paciente INTERGER(11) NOT NULL,
telefone_paciente NUMERIC(14) NOT NULL,
email_paciente VARCHAR(50) NOT NULL,
data_nascimento_paciente DATE NOT NULL,
UNIQUE (cpf_paciente)

);

--Tabela IndicadoresAtendimento
CREATE TABLE indicadoresatendimento(
cod_paciente INTEGER NOT NULL --PFK
cod_atendimento INTEGER NOT NULL --PFK
crm NUMERIC(6) NOT NULL --PFK
);

--Tabela TipoAtendimento
CREATE TABLE tipoatendimento(
cod_atendimento INTEGER PRIMARY KEY,
data_atendimento DATE NOT NULL,
num_atendimento VARCHAR NOT NULL,
cod_unidade INTEGER NOT NULL,
cod_unidade INTEGER NOT NULL, --FK
);

--Tabela Medico
CREATE TABLE medico(
crm NUMERIC(6) PRIMARY KEY,
hora_entrada DATE NOT NULL,
hora_saida DATE NOT NULL,
escala CHAR(8) NOT NULL,
cod_funcionario INTEGER NOT NULL --FK
);

--Tabela Funcionario
CREATE TABLE funcionario(
cod_funcionario INTEGER PRIMARY KEY,
escala_hora_trabalho VARCHAR2(50) NOT NULL,
cargo VARCHAR2(50) NOT NULL
);

--Tabela rede_publica
CRETE TABLE rede_publica(
id_estado CHAR(2) NOT NULL,
id_sus INTEGER NOT NULL, --FK
cod_funcionario INTEGER NOT NULL, --FK
cod_unidade INTEGER NOT NULL --FK
);

--Tabela Unidade Atendimento
CREATE TABLE UnidadeAtendimento(
cod_unidade INTEGER PRIMARY KEY,
nome_unidade VARCHAR(50) NOT NULL,
telefone_unidade NUMERIC(11) NOT NULL,
responsavel_unidade VARCHAR2(50) NOT NULL,
regiao_unidade VARCHAR2(50) NOT NULL,
distrito_unidade VARCHAR2(50) NOT NULL
);

--Tabela hospitais
CREATE TABLE hospitais(
cod_hospital INTEGER PRIMARY KEY,
cod_unidade_hospital INTEGER NOT NULL,--PFK
num_leitos_emergencia NUMERIC(3) NOT NULL,
num_leitos_uti NUMERIC(3) NOT NULL
);

--Tabela PostosSaude
cod_posto INTEGER PRIMARY KEY,
cod_unidade_posto INTEGER NOT NULL, --PFK
desc_vacinas VARCHAR2(50) NOT NULL,
atendimentos_prestados VARCHAR(50) NOT NULL

--Tabela ConsultaMedica
CREATE TABLE consultamedica (
id_consulta INTEGER PRIMARY KEY,
cod_atendimento INTEGER NOT NULL --FK
data_hora_consulta DATE NOT NULL,
diagnostico VARCHAR2(50) NOT NULL,
prescicao_medica VARCHAR2(50) NOT NULL,
status_consulta VARCHAR2(50) NOT NULL
);

--Tabela Internacao
CREATE TABLE internacao(
id_internacao INTEGER PRIMARY KEY,
cod_atendimento INTEGER NOT NULL --FK
motivo_internacao VARCHAR2(50) NOT NULL,
diagnostico_inicial VARCHAR2(50) NOT NULL,
cmr NUMERIC(6) NOT NULL --FK
);

--Alterações para chaves estrangeiras
cod_unidade (Tipoatendimento fk) - Tabela unidade
cod_funcionario(medico fk) - Tabela Funcionario
```