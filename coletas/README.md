# Coletas oficiais até 30/09/2026

Este diretório substitui o acervo antigo de coletas e é o conjunto de referência para o laboratório da IA.

## Organização

- `small/coletas_5s_10s_ate_2026-09-30.tar.xz.b64x2`: todos os CSVs 5s/10s enviados em 30/09, preservados dentro de um `tar.xz` e transportados em Base64 duplo (`b64x2`).
- `raw/`: RAWs grandes em formato compacto `F9RAW`, também transportados em Base64 duplo (`b64x2`).
- `manifest.json`: tamanho, número de linhas e SHA-256 dos arquivos originais.
- `tools/decode_coletas.py`: extrai os pequenos e reconstrói os RAWs em CSV.

## Por que F9RAW?

Os RAWs somam mais de 100 MB. Para manter o Git utilizável, eles foram normalizados e comprimidos. O formato F9RAW preserva numericamente todas as colunas do RAW, exceto `timestamp_utc` e `timestamp_brt`, que são derivados de `at_ns`. O conteúdo de preço, fases, IDs e janelas 1s/5s/10s/60s permanece no pacote.

A formatação textual pode ser normalizada na reconstrução (por exemplo, zeros decimais à direita e quebras de linha), mas os valores numéricos permanecem preservados. Os SHA-256 dos CSVs originais ficam registrados no manifesto.

## RAWs

- AUDNZD-OTC: 28/09 → 29/09, dividido em 2 partes de transporte.
- NZDUSD: 29/09.
- SOLUSD: 29/09 → 30/09.
- XAUUSD: 29/09.

## Uso

```bash
python tools/decode_coletas.py extract-small small/coletas_5s_10s_ate_2026-09-30.tar.xz.b64x2 ./restauradas

python tools/decode_coletas.py decode-raw \
  raw/AUDNZD_OTC/audnzd_otc_raw_2026-09-28_29.f9raw.xz.part001.b64x2 \
  raw/AUDNZD_OTC/audnzd_otc_raw_2026-09-28_29.f9raw.xz.part002.b64x2 \
  --out ./restauradas/dados_audnzd_otc_RAW.csv
```

Os scripts operacionais oficiais ficam fora daqui e permanecem congelados. Este diretório é somente o laboratório de dados da IA.
