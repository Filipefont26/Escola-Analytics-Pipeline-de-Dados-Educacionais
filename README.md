# 📊 Escola Analytics  Pipeline de Dados Educacionais

> Pipeline completo de dados escolares: das planilhas por turma até um dashboard interativo no Power BI, passando pelo Google BigQuery como camada de centralização e modelagem.


## 🎯 Objetivo

Replicar e modernizar um fluxo de análise escolar anteriormente feito de forma manual, centralizando dados de múltiplas turmas em uma única plataforma de nuvem e construindo um dashboard analítico para apoiar decisões pedagógicas.



## 🏗️ Arquitetura do Projeto

```
Planilhas Excel (5 turmas)
        ↓
   Python + Pandas
  (leitura e tratamento)
        ↓
   Google BigQuery
  (centralização e modelagem SQL)
        ↓
   Power BI Desktop
  (dashboard interativo)
```



## 📁 Estrutura do Repositório

```
escola-analytics/
├── upload_bigquery.py         # Script de ingestão de dados
├── modelagem_bigquery.sql     # Views SQL para análise
├── turma_1A.xlsx              # Base de dados — Turma 1A
├── turma_1B.xlsx              # Base de dados — Turma 1B
├── turma_2A.xlsx              # Base de dados — Turma 2A
├── turma_3A.xlsx              # Base de dados — Turma 3A
├── turma_3B.xlsx              # Base de dados — Turma 3B
└── README.md
```



## 🛠️ Tecnologias Utilizadas

| Tecnologia | Finalidade |
|---|---|
| Python 3 | Leitura, tratamento e ingestão dos dados |
| Pandas | Manipulação e consolidação das planilhas |
| Google BigQuery | Data warehouse na nuvem |
| SQL (BigQuery dialect) | Modelagem analítica com views |
| Power BI Desktop | Visualização e dashboard interativo |
| DAX | Medidas e cálculos no Power BI |



## ⚙️ Como Reproduzir

### Pré-requisitos
- Python 3.x instalado
- Google Cloud SDK instalado e autenticado
- Conta no Google Cloud Platform com BigQuery ativado
- Power BI Desktop instalado

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/escola-analytics.git
cd escola-analytics
```

### 2. Instale as dependências
```bash
pip install pandas openpyxl google-cloud-bigquery pyarrow
```

### 3. Autentique no Google Cloud
```bash
gcloud auth application-default login
```

### 4. Configure o Project ID
Abra o `upload_bigquery.py` e edite:
```python
PROJECT_ID = "seu-project-id"
```

### 5. Execute o upload
```bash
python upload_bigquery.py
```

### 6. Crie as views no BigQuery
Execute o conteúdo do arquivo `modelagem_bigquery.sql` no console do BigQuery.

### 7. Conecte o Power BI
Abra o Power BI Desktop → Obter Dados → Google BigQuery → selecione as views `vw_*`.



## 📊 Dashboard — Páginas

| Página | Conteúdo |
|---|---|
| Turma 1A | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 1B | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 2A | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 3A | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 3B | KPIs, média por matéria, top 5, alunos em dificuldade |
| Visão Geral | Comparativo entre turmas, ranking, matérias críticas |


## 🔍 Análises Disponíveis

- **Média geral por turma** — comparativo de desempenho entre turmas
- **Média por matéria** — identificação de disciplinas com maior dificuldade
- **Ranking de alunos** — top 5 destaques com sistema de medalhas 🥇🥈🥉
- **Alunos em dificuldade** — lista de alunos abaixo da média com matéria mais crítica
- **Distribuição por situação** — Aprovado / Recuperação / Reprovado
- **Distribuição por sexo** — perfil demográfico por turma
- **Matéria fraca por turma** — disciplina com menor média em cada turma



## 📈 Resultados da Análise (Base Simulada)

- **150 alunos** distribuídos em 5 turmas do Ensino Médio
- **Melhor turma:** 1A — média 7,5 e 93,3% de aprovação
- **Turma mais crítica:** 1B — média 5,67 e 0% de aprovação
- **Matérias críticas:** Química (1A e 2A) e Educação Física (1B e 3A)
- **Média geral da escola:** 6,67



## 🔄 Atualização dos Dados

Para atualizar os dados com um novo período letivo:
1. Substitua ou atualize os arquivos `.xlsx`
2. Execute novamente: `python upload_bigquery.py`
3. No Power BI: **Página Inicial → Atualizar**

As views no BigQuery são dinâmicas — não precisam ser recriadas.


## 👤 Autor

Feito por **Filipe Fontoura** — conecte-se no # 📊 Escola Analytics — Pipeline de Dados Educacionais

> Pipeline completo de dados escolares: das planilhas por turma até um dashboard interativo no Power BI, passando pelo Google BigQuery como camada de centralização e modelagem.


## 🎯 Objetivo

Replicar e modernizar um fluxo de análise escolar anteriormente feito de forma manual, centralizando dados de múltiplas turmas em uma única plataforma de nuvem e construindo um dashboard analítico para apoiar decisões pedagógicas.



## 🏗️ Arquitetura do Projeto

```
Planilhas Excel (5 turmas)
        ↓
   Python + Pandas
  (leitura e tratamento)
        ↓
   Google BigQuery
  (centralização e modelagem SQL)
        ↓
   Power BI Desktop
  (dashboard interativo)
```



## 📁 Estrutura do Repositório

```
escola-analytics/
├── upload_bigquery.py         # Script de ingestão de dados
├── modelagem_bigquery.sql     # Views SQL para análise
├── turma_1A.xlsx              # Base de dados — Turma 1A
├── turma_1B.xlsx              # Base de dados — Turma 1B
├── turma_2A.xlsx              # Base de dados — Turma 2A
├── turma_3A.xlsx              # Base de dados — Turma 3A
├── turma_3B.xlsx              # Base de dados — Turma 3B
└── README.md
```



## 🛠️ Tecnologias Utilizadas

| Tecnologia | Finalidade |
|---|---|
| Python 3 | Leitura, tratamento e ingestão dos dados |
| Pandas | Manipulação e consolidação das planilhas |
| Google BigQuery | Data warehouse na nuvem |
| SQL (BigQuery dialect) | Modelagem analítica com views |
| Power BI Desktop | Visualização e dashboard interativo |
| DAX | Medidas e cálculos no Power BI |



## ⚙️ Como Reproduzir

### Pré-requisitos
- Python 3.x instalado
- Google Cloud SDK instalado e autenticado
- Conta no Google Cloud Platform com BigQuery ativado
- Power BI Desktop instalado

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/escola-analytics.git
cd escola-analytics
```

### 2. Instale as dependências
```bash
pip install pandas openpyxl google-cloud-bigquery pyarrow
```

### 3. Autentique no Google Cloud
```bash
gcloud auth application-default login
```

### 4. Configure o Project ID
Abra o `upload_bigquery.py` e edite:
```python
PROJECT_ID = "seu-project-id"
```

### 5. Execute o upload
```bash
python upload_bigquery.py
```

### 6. Crie as views no BigQuery
Execute o conteúdo do arquivo `modelagem_bigquery.sql` no console do BigQuery.

### 7. Conecte o Power BI
Abra o Power BI Desktop → Obter Dados → Google BigQuery → selecione as views `vw_*`.



## 📊 Dashboard — Páginas

| Página | Conteúdo |
|---|---|
| Turma 1A | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 1B | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 2A | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 3A | KPIs, média por matéria, top 5, alunos em dificuldade |
| Turma 3B | KPIs, média por matéria, top 5, alunos em dificuldade |
| Visão Geral | Comparativo entre turmas, ranking, matérias críticas |


## 🔍 Análises Disponíveis

- **Média geral por turma** — comparativo de desempenho entre turmas
- **Média por matéria** — identificação de disciplinas com maior dificuldade
- **Ranking de alunos** — top 5 destaques com sistema de medalhas 🥇🥈🥉
- **Alunos em dificuldade** — lista de alunos abaixo da média com matéria mais crítica
- **Distribuição por situação** — Aprovado / Recuperação / Reprovado
- **Distribuição por sexo** — perfil demográfico por turma
- **Matéria fraca por turma** — disciplina com menor média em cada turma



## 📈 Resultados da Análise (Base Simulada)

- **150 alunos** distribuídos em 5 turmas do Ensino Médio
- **Melhor turma:** 1A  média 7,5 e 93,3% de aprovação
- **Turma mais crítica:** 1B — média 5,67 e 0% de aprovação
- **Matérias críticas:** Química (1A e 2A) e Educação Física (1B e 3A)
- **Média geral da escola:** 6,67



## 🔄 Atualização dos Dados

Para atualizar os dados com um novo período letivo:
1. Substitua ou atualize os arquivos `.xlsx`
2. Execute novamente: `python upload_bigquery.py`
3. No Power BI: **Página Inicial → Atualizar**

As views no BigQuery são dinâmicas  não precisam ser recriadas.


## 👤 Autor

Feito por **Felipe** — conecte-se no [LinkedIn]()


<img width="1311" height="739" alt="Captura de tela 2026-05-04 173736" src="https://github.com/user-attachments/assets/69ac1333-26b0-4026-aead-a787abd55da6" />
<img width="1313" height="737" alt="Captura de tela 2026-05-04 173754" src="https://github.com/user-attachments/assets/64433ed2-227a-4b08-941b-e95a9d2f1d0b" />
<img width="1312" height="737" alt="Captura de tela 2026-05-04 173806" src="https://github.com/user-attachments/assets/c3044dd0-d9d2-457f-ae08-b4f6420e494d" />
<img width="1312" height="736" alt="Captura de tela 2026-05-04 173815" src="https://github.com/user-attachments/assets/be576c46-bc92-4933-ae4b-0aa972f1ae2d" />
<img width="1311" height="736" alt="Captura de tela 2026-05-04 173828" src="https://github.com/user-attachments/assets/7a241817-a803-4093-bc05-6e7494e91d2b" />
<img width="1311" height="734" alt="Captura de tela 2026-05-04 173839" src="https://github.com/user-attachments/assets/bfb9d2b8-54a6-45e4-8586-e4aedec7ed7b" />
<img width="1314" height="734" alt="Captura de tela 2026-05-04 173854" src="https://github.com/user-attachments/assets/42146880-3aa2-45a9-8a2c-661de1e9794d" />







