# Mapas sistemáticos com aves: dados para binarização

Repositório com os dados de dois mapas sistemáticos sobre aves.
O objetivo é binarizar as respostas codificadas nesses mapas para um estudo do laboratório (COSSEE).

## Os dois mapas

1. **Casallanovo, Santos & Cione (2026).** Bird and mammal diversity in agricultural landscapes and adjacent natural vegetation of the Brazilian Atlantic Forest: a systematic map. *Environmental Evidence*. https://doi.org/10.1186/s13750-026-00390-z
   - Licença: CC BY 4.0 (artigo) e CC0 (dados).
   - Pasta: `data/raw/casallanovo2026_mata_atlantica/`

2. **Adams, Fernández-Juricic, Bayne & St. Clair (2021).** Effects of artificial light on bird movement and distribution: a systematic map. *Environmental Evidence* 10: 37. https://doi.org/10.1186/s13750-021-00246-8
   - O banco principal é o *Additional file 15* (Excel). Também há uma versão em Access (*Additional file 13*).
   - Pasta: `data/raw/adams2021_luz_artificial/`

## Como usar

1. Rode o script a partir da raiz do repositório:

   ```
   Rscript scripts/01_baixar_dados.R
   ```

2. Confira `data/raw/registro_downloads.csv` para ver o que baixou.
3. Se algum arquivo falhar, baixe à mão pela página do artigo e salve na pasta certa.

## Estrutura

```
data/raw/         arquivos originais, sem mexer
data/processed/   dados já binarizados
scripts/          código em R
```

Regra simples: nunca editar nada em `data/raw/`. Todo tratamento vai para `data/processed/`.
