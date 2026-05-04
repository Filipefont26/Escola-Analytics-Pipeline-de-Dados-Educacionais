

import pandas as pd
from google.cloud import bigquery
import os

PROJECT_ID  = "escola-analytics-2024"  
DATASET_ID  = "escola_dados"
TABLE_ID    = "notas_turmas"
LOCATION    = "US"               

# Caminho para as planilhas 
PASTA_PLANILHAS = r"C:\Users\lipem\OneDrive\Documentos\projeto escola\files"
ARQUIVOS_TURMAS = {
    "1A": "turma_1A.xlsx",
    "1B": "turma_1B.xlsx",
    "2A": "turma_2A.xlsx",
    "3A": "turma_3A.xlsx",
    "3B": "turma_3B.xlsx",
}

MATERIAS = [
    "Portugues", "Matematica", "Historia", "Geografia",
    "Ciencias", "Fisica", "Quimica", "Biologia",
    "Ingles", "Educacao_Fisica", "Arte", "Filosofia"
]

ANO_TURMA = {"1A": "1º Ano", "1B": "1º Ano", "2A": "2º Ano", "3A": "3º Ano", "3B": "3º Ano"}
PERIODO_TURMA = {"1A": "Manhã", "1B": "Tarde", "2A": "Manhã", "3A": "Manhã", "3B": "Tarde"}


def ler_planilha(turma_codigo: str, arquivo: str) -> pd.DataFrame:
    
    path = os.path.join(PASTA_PLANILHAS, arquivo)
    df = pd.read_excel(path, header=1, skipfooter=1)   

    # Renomeia colunas para padrão consistente
    colunas_esperadas = ["matricula", "nome_aluno", "sexo"] + MATERIAS + ["media_geral", "situacao"]
    df = df.iloc[:, :len(colunas_esperadas)]
    df.columns = colunas_esperadas

    # Remove linhas sem matrícula 
    df = df.dropna(subset=["matricula"])
    df = df[df["matricula"].astype(str).str.startswith("2024")]

    # Adiciona metadados da turma
    df.insert(0, "turma",    turma_codigo)
    df.insert(1, "ano_escolar", ANO_TURMA[turma_codigo])
    df.insert(2, "periodo",  PERIODO_TURMA[turma_codigo])
    df.insert(3, "ano_letivo", 2024)

    # Garante tipos corretos
    for mat in MATERIAS:
        df[mat] = pd.to_numeric(df[mat], errors="coerce")
    df["media_geral"] = pd.to_numeric(df["media_geral"], errors="coerce")

    print(f"  ✓ Turma {turma_codigo}: {len(df)} alunos carregados")
    return df


def criar_dataset(client: bigquery.Client):
    """Cria o dataset no BigQuery se não existir."""
    dataset_ref = bigquery.Dataset(f"{PROJECT_ID}.{DATASET_ID}")
    dataset_ref.location = LOCATION
    dataset_ref.description = "Dados escolares - Ensino Médio 2024"
    try:
        client.create_dataset(dataset_ref, exists_ok=True)
        print(f"✓ Dataset '{DATASET_ID}' pronto.")
    except Exception as e:
        print(f"✗ Erro ao criar dataset: {e}")
        raise


def definir_schema() -> list:
    """Define o schema da tabela principal no BigQuery."""
    campos_fixos = [
        bigquery.SchemaField("turma",        "STRING",  description="Código da turma (ex: 1A)"),
        bigquery.SchemaField("ano_escolar",  "STRING",  description="Ano escolar (ex: 1º Ano)"),
        bigquery.SchemaField("periodo",      "STRING",  description="Período (Manhã/Tarde)"),
        bigquery.SchemaField("ano_letivo",   "INTEGER", description="Ano letivo"),
        bigquery.SchemaField("matricula",    "STRING",  description="Matrícula do aluno"),
        bigquery.SchemaField("nome_aluno",   "STRING",  description="Nome completo do aluno"),
        bigquery.SchemaField("sexo",         "STRING",  description="M ou F"),
    ]
    campos_notas = [
        bigquery.SchemaField(mat, "FLOAT64", description=f"Nota de {mat.replace('_', ' ')}")
        for mat in MATERIAS
    ]
    campos_resultado = [
        bigquery.SchemaField("media_geral",  "FLOAT64", description="Média geral do aluno"),
        bigquery.SchemaField("situacao",     "STRING",  description="Aprovado / Recuperação / Reprovado"),
    ]
    return campos_fixos + campos_notas + campos_resultado


def fazer_upload(client: bigquery.Client, df: pd.DataFrame):
    """Faz o upload do DataFrame para o BigQuery (substitui a tabela)."""
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

    job_config = bigquery.LoadJobConfig(
        schema=definir_schema(),
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,  # recria a tabela
        create_disposition=bigquery.CreateDisposition.CREATE_IF_NEEDED,
    )

    job = client.load_table_from_dataframe(df, table_ref, job_config=job_config)
    job.result()  # aguarda conclusão

    tabela = client.get_table(table_ref)
    print(f"\n✓ Upload concluído!")
    print(f"  Tabela: {table_ref}")
    print(f"  Total de linhas: {tabela.num_rows}")
    print(f"  Tamanho: {tabela.num_bytes / 1024:.1f} KB")


def main():
    print("=" * 55)
    print("  UPLOAD ESCOLA → BIGQUERY")
    print("=" * 55)

    # 1. Lê todas as planilhas e concatena
    print("\n📂 Lendo planilhas...")
    dfs = []
    for codigo, arquivo in ARQUIVOS_TURMAS.items():
        df = ler_planilha(codigo, arquivo)
        dfs.append(df)
    df_total = pd.concat(dfs, ignore_index=True)
    print(f"\n  Total consolidado: {len(df_total)} alunos em {len(ARQUIVOS_TURMAS)} turmas")

    # 2. Conecta ao BigQuery
    print("\n🔗 Conectando ao BigQuery...")
    client = bigquery.Client(project=PROJECT_ID)

    # 3. Cria dataset
    print("\n📦 Verificando dataset...")
    criar_dataset(client)

    # 4. Upload
    print("\n⬆️  Enviando dados...")
    fazer_upload(client, df_total)

    print("\n✅ Processo finalizado com sucesso!")
    print(f"\n   Acesse: https://console.cloud.google.com/bigquery?project={PROJECT_ID}")


if __name__ == "__main__":
    main()
