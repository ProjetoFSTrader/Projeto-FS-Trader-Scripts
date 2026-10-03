# ETHUSD OTC RAW x FS Trader F9 V17 M+ — análise exploratória

Data da coleta: 2026-10-03
Ativo: ETHUSD-OTC
active_id: 1941
Janela BRT: 2026-10-03 08:28:30-03:00 a 2026-10-03 11:47:45.278016-03:00
Registros RAW: 42.750
Minutos M1 observados: 200
Duração: 3h19m15s
Mediana entre updates: 0,248s
Maior intervalo entre updates: 1,000s
Campos ausentes: 0
SHA-256 RAW: 38a1d12c90861a8bef1df8e8e7fe7a249c4909c2c29a10570054ae299892b7a5
SHA-256 F9 V17 M+: 7aaf9460a05ec4a3d7befad3c0f1e8ec9b42acc070b188642d0eac7b656dad96

## Escopo e cautelas
Análise exploratória, não taxa de acerto operacional oficial. A coleta tem cerca de 3h19 e ~200 M1. O replay usa estados intrabar do RAW e reproduz conceitos centrais do V17, mas não executa o motor Lua da corretora byte a byte. O campo value foi usado como proxy de preço e não inclui payout, strike, latência ou execução.

## Integridade
- 42.750 atualizações, todas active_id 1941.
- Sem valores ausentes nas 32 colunas.
- Nenhum gap >10s; maior gap 1,0s.
- Primeiro e último M1 são parciais.

## V17 M+
O núcleo continua TA/TB com EMA10. O M+ usa corpo <0,58 x m5 e range <0,95 x m5, exclui rompimento forte, lateral/caixote e H ativo. No árbitro por vela, M tem prioridade sobre C/FS ou V/FS.

## Microvela / M+
Replay aproximado sem memória persistente completa do H:
- 10s: 21 candidatos, 57,1% favoráveis até o fechamento.
- 20s: 23, 43,5%.
- 30s: 20, 55,0%.
- 40s: 18, 77,8%.
- 50s: 16, 68,8%.

Antes de 30s, o ETHUSD não mostrou vantagem estável suficiente para transformar M em entrada automática.

Nos 20 candidatos presentes aos 30s, 55% terminaram o próprio M1 no sentido do fluxo e 55% tiveram o M1 seguinte fechando no mesmo sentido; 80% tiveram pelo menos um desses comportamentos. n=20 é pequeno.

## M+ versus M3
No snapshot de 30s, 16 dos 20 M+ também satisfaziam o corte antigo corpo <0,42 x m5 e range <0,75 x m5. Nessa subamostra, 62,5% terminaram favoráveis. Amostra insuficiente para concluir que estreitar o M melhora o operacional.

## Sinal precoce e latch
O primeiro candidato M+ até 30s apareceu em 61 minutos e a mediana do primeiro disparo ficou muito perto da abertura. Isso ocorre porque corpo e range naturalmente começam pequenos. Como o V17 trava a primeira classificação da vela, este é um ponto importante para validação visual.

Preço do primeiro disparo como referência: 55,7% favoráveis. Mantendo a direção inicial e usando ~29s como referência: 52,5%. M isolado não demonstrou edge suficiente nesta amostra.

## Rompimento e aceitação
Extremo dos 10 M1 anteriores:
- fora aos 10s: 13 casos, 61,5% sustentaram até o fechamento;
- 20s: 22, 59,1%;
- 30s: 25, 52,0%.

Em 49 primeiros rompimentos até 30s observáveis por mais 10s:
- voltou para dentro em 10s: 24 casos, 25,0% sustentaram no fechamento;
- continuou fora após 10s: 25 casos, 56,0% sustentaram.

O ponto promissor é retenção/aceitação depois do rompimento, não o simples toque.

## H
Leitura aproximada das condições instantâneas:
- 10s: 19 ocorrências, 73,7% moveram até o fechamento no sentido oposto à perna antiga;
- 20s: 17, 70,6%;
- 30s: 16, 68,8%.

Isso favorece H como aviso de extremo nesta janela, mas não prova ordem de reversão nem bloqueio absoluto. A memória persistente completa do H não foi reproduzida.

## Comparação conceitual
- F9 original: TA/TB simples explica densidade de pernadas, mas reage cedo a movimentos pequenos.
- F9 V15: estágio/microvela reduz reentrada, mas historicamente custa oportunidades; microvela isolada não justificou bloqueio geral.
- F9 V17 M+: arquitetura mais compatível com estes dados: compressão vira categoria discricionária M em vez de proibição universal. M isolado ainda não é edge demonstrado.
- F10 V14: filtros amplos podem evitar eventos ruins, mas o custo em boas entradas precisa continuar medido. Este ETHUSD não sustenta nova cascata de bloqueios no F9.

## Próximas hipóteses
1. M + retenção após rompimento.
2. M aos 20–30s + velocidade dos últimos 5–10s.
3. Separar microvela persistente de vela pequena prestes a expandir.
4. M perto de H versus M no meio da perna.
5. Medir losses evitados versus entradas boas bloqueadas.
6. Repetir em COSMOS OTC e outros ativos.

## Decisão
Nenhuma alteração no oficial nem no V17 a partir deste ETHUSD isolado. V17 M+ permanece experimental e M continua aviso/opção do trader, não entrada automática. O achado mais consistente é a importância da retenção após rompimento; compressão/tamanho isolados ainda não bastam.
