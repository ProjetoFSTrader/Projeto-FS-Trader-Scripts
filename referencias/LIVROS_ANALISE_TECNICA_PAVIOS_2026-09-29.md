# Referência — Livros de análise técnica e leitura de pavios

Data: 2026-09-29

## Materiais recebidos

1. **Análise Técnica do Zero — Grupo Delta Estrutural**
   - PDF recebido nesta conversa.
   - Conteúdos úteis para o projeto: candlesticks, tendência, lateralização, suporte/resistência, falso rompimento, médias, padrões gráficos, gestão de risco e rotina.
2. **Diário do Trader para Impressão**
   - PDF de uma página para registro de operações, condição do mercado, direção, confiança, execução, resultado, disciplina e emoção.

> Observação: este arquivo no GitHub é uma referência de estudo do projeto. Os PDFs originais permanecem nos arquivos da conversa; este registro guarda os conceitos relevantes.

## Pavios — pontos que chamaram atenção

O livro define **pavio (ou sombra)** como a parte da vela que mostra até onde o preço chegou antes de recuar.

Leituras apresentadas no material:

- **Pavio inferior longo**, especialmente depois de uma queda e com corpo pequeno na parte superior (martelo), sugere rejeição de preços mais baixos e reação compradora.
- **Pavio superior longo**, especialmente depois de uma alta e com corpo pequeno na parte inferior (estrela cadente), sugere rejeição de preços mais altos e reação vendedora.
- Uma sequência de **corpos grandes com pavios curtos** indica movimento mais decidido e menor resistência contrária.
- Velas pequenas/alternadas sugerem indecisão e consolidação.
- O próprio livro alerta que **um padrão de vela isolado não é sinal automático de compra ou venda**. A localização e o contexto do gráfico importam tanto quanto o formato.

## Relação com o F9/F10

Isso reforça uma regra que já usamos no projeto:

**“Pavio não manda. Pavio avisa. O contexto decide.”**

Para o código, o pavio pode ser tratado como informação de:
- rejeição;
- perda de eficiência;
- tentativa de rompimento devolvida;
- possível exaustão em topo/fundo;
- confirmação de continuação quando é curto em uma sequência forte.

Mas o livro **não fornece um percentual universal de pavio** que determine bloqueio ou reversão. Portanto, não devemos criar regra rígida como “pavio > X% = não entrar” sem validar nos RAW/CSV.

## Pista de pesquisa para o projeto

Vale testar nos dados:
- relação pavio/corpo;
- pavio superior e inferior separadamente;
- posição na sequência (início, meio, última perna);
- proximidade de topo/fundo/suporte/resistência;
- mercado tendencial x lateral;
- se houve rompimento e retenção ou rompimento e retorno;
- resultado da próxima janela operacional.

Objetivo: descobrir se existe alguma faixa de **pavio + contexto** que ajude a detectar devolução/exaustão sem matar as boas sequências.
