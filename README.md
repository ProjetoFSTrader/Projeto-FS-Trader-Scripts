# 📊 Projeto FS Trader Scripts

**Indicadores de análise técnica em Quadcode Script (QCS)**  
**Desenvolvedor: Fábio Santiago Trader**

Um espaço dedicado ao desenvolvimento, estudo e evolução de indicadores gráficos para plataformas de negociação compatíveis com **Quadcode Script**, linguagem baseada em Lua.

O **FS Trader** reúne pesquisas sobre leitura de preço, suporte e resistência, força e exaustão das velas, zonas de consolidação e critérios de proteção. O foco é criar ferramentas que auxiliem a interpretação do mercado com clareza, disciplina e gestão de risco.

> **Nossa filosofia:** o indicador é uma ferramenta de leitura do gráfico, não uma promessa de acerto nem um substituto para a análise do trader.

## 🧩 Scripts disponíveis

| Arquivo | Descrição | Situação |
| --- | --- | --- |
| [S20_ALUNOS.txt](S20_ALUNOS.txt) | Versão F20 de referência, mais seletiva, utilizada na proposta educacional do projeto. | Preservada |
| [F21_VERSAO_PESSOAL.txt](F21_VERSAO_PESSOAL.txt) | Variante pessoal de maior frequência de sinalização. | Preservada |
| [F9_BRUTO_PIONEIRO.txt](F9_BRUTO_PIONEIRO.txt) | Versão pioneira original, guardada para referência e estudo. | Preservada |
| [F20_M30_PROTECAO_TESTE.txt](F20_M30_PROTECAO_TESTE.txt) | Experimento F20 com suporte/resistência do último M30 fechado, resistência vermelha, suporte verde e referência M30 nas proteções de borda e repetição. | **Experimental: validar em DEMO** |

**Importante:** o F20 M30 é um arquivo independente. Os scripts de referência não foram substituídos ou modificados.

## 🔎 Linhas de estudo

- **Price Action:** leitura de velas, força, continuidade, pausas e exaustão.
- **Suportes e resistências:** referências de períodos maiores e comportamento nas bordas.
- **Proteção e seletividade:** reduzir insistências e sinais em condições desfavoráveis, sem confundir redução de sinais com maior precisão.
- **Volatilidade intravela:** investigar velocidade, amplitude, reversões e agitação do preço com dados históricos e observações ao vivo.

## 🛠️ Tecnologia

- **Linguagem:** Quadcode Script (QCS), baseada em Lua.
- **Formato:** scripts em `.txt` para estudo, edição e importação em ambientes que suportem QCS.
- **Documentação técnica:** [Quadcode Script](https://quadcode-tech.github.io/quadcodescript-docs/).

A compatibilidade e o comportamento de cada versão dependem do editor, da implementação de QCS e dos dados da plataforma utilizada. Teste primeiro em ambiente demonstrativo.

## ⚠️ Aviso de risco

Estes scripts são ferramentas de **estudo e análise técnica**. Não executam automaticamente operações por conta própria, não constituem uma sala de sinais, recomendação financeira ou garantia de resultados. Negociações financeiras envolvem risco de perda, inclusive integral do capital utilizado.

## 👨‍💻 Sobre o desenvolvedor

**Fábio Santiago Trader**  
Criador do **Projeto FS Trader Scripts**.

Desenvolvimento orientado à observação real do gráfico, experimentação, revisão de regras e educação de traders iniciantes. Cada versão preserva um estágio de pesquisa: o objetivo é aprender com o comportamento do preço e tornar os indicadores mais claros e responsáveis.

---

**⭐ Achou este projeto útil ou quer acompanhar sua evolução? Deixe uma estrela no repositório!** Seu apoio ajuda a dar visibilidade à pesquisa e ao trabalho de desenvolvimento.

*Projeto independente, sem afiliação oficial com a Quadcode ou com plataformas de negociação.*
