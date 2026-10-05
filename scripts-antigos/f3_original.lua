instrument { name = "F3.2 OTC REFEITO", icon="jpg", overlay = true }
input_group {
    "C",
    comprar_color = input {default = "green", type = input.color}
}
input_group {
    "Periodo Max/Min",
    doch_time = input {default = "12", type = input.string}
}
input_group {
    "Periodo da Micro Tendencia",
    emaa_per = input {default = "12", type = input.string}
}
input_group {
    "Periodo da  Macro Tendencia",
    emab_per = input {default = "100", type = input.string}
}
input_group {
    "Media Rapida",
    emac_per = input {default = "4", type = input.string}
}
input_group {
    "Media Lenta",
    emad_per = input {default = "15", type = input.string}
}
input_group {
    "V",
    vender_color = input {default = "#fcf805", type = input.color}
}
input_group {
    "Candles",
    positivo = input { default = "#0bd104",type = input.color },
    negativo = input { default = "#f70202",  type = input.color },
    neutro   = input { default = "#787b86",  type = input.color },  -- FIX: usada na cor da vela quando TA/TB sao falsos, nao existia
}
-- FIX: upline_color/lowline_color eram usadas no plot() de Resistencia/Suporte mas nunca declaradas (chegavam nil)
input_group {
    "Canal (Resistencia/Suporte)",
    upline_color  = input { default = "#f23645", type = input.color },
    lowline_color = input { default = "#089981", type = input.color }
}
EMAA   = ema(close,emaa_per)
EMAB   = ema(close,emab_per)
EMAC   = ema(hlc3,emac_per)
EMAD   = ema(hlc3,emad_per)
upper  = highest (high, doch_time)
lower  = lowest  (low,  doch_time)
TA    = ((close > close[1]) and (close > EMAA) and (EMAA > EMAA[1]))
TB    = ((close < close[1]) and (close < EMAA) and (EMAA < EMAA[1]))
ENC   = ((EMAC[1] < EMAD[1]) and (EMAC > EMAD))
ENV   = ((EMAC[1] > EMAD[1]) and (EMAC < EMAD))
sec = security (current_ticker_id, "5m")  -- alterado de "1m" pra "5m" a pedido do usuario
if sec then
local bar_color
if (TA == true) then
    bar_color = positivo
elseif (TB == true) then
    bar_color = negativo
else
    bar_color = neutro
end
    plot_candle (open, high, low, close, "ES", bar_color)
    plot (upper, "Resistencia", upline_color)
    plot (lower, "Suporte",lowline_color)
end
-- Bolinhas grandes Bull/Bear Engulfing removidas na faxina visual
input_group { "UP - UP COLOR", call_color = input { default="#0bd104", type = input.color } }
input_group { "DOWN - DOWN COLOR", put_color = input { default="#f70202", type = input.color } }

input_group {
    "Fractais OTC",
    fractal_top_color = input { default = "#ff8c00", type = input.color },
    fractal_bottom_color = input { default = "#00ff88", type = input.color }
}
range_8 = highest(high, 8) - lowest(low, 8)
range_ref = highest(high, doch_time) - lowest(low, doch_time)
range_atual = high - low
range_1 = high[1] - low[1]
range_2 = high[2] - low[2]
range_3 = high[3] - low[3]
media_range = nz((range_atual + range_1 + range_2 + range_3) / 4, range_atual)
corpo_atual = abs(close - open)
corpo_1 = abs(close[1] - open[1])
corpo_2 = abs(close[2] - open[2])
media_gap = abs(EMAC - EMAD)

-- FILTRO ESPECIFICO DA TERCEIRA VELA
-- Libera a terceira vela somente quando a segunda manteve pressao.
pavio_superior_1 = high[1] - max(open[1], close[1])
pavio_inferior_1 = min(open[1], close[1]) - low[1]

segunda_forte_compra =
    (range_1 > 0) and
    (close[1] > open[1]) and
    (close[1] > close[2]) and
    (corpo_1 >= (media_range * 0.55)) and
    (pavio_superior_1 <= (range_1 * 0.30)) and
    (close[1] >= (low[1] + (range_1 * 0.65)))

segunda_forte_venda =
    (range_1 > 0) and
    (close[1] < open[1]) and
    (close[1] < close[2]) and
    (corpo_1 >= (media_range * 0.55)) and
    (pavio_inferior_1 <= (range_1 * 0.30)) and
    (close[1] <= (high[1] - (range_1 * 0.65)))

sequencia_terceira_compra =  -- ESTAVEL: agora sao 3 velas ja fechadas (close[1..3]), nao inclui mais a vela ao vivo
    (close[1] > open[1]) and
    (close[2] > open[2]) and
    (close[3] > open[3])

sequencia_terceira_venda =  -- ESTAVEL: agora sao 3 velas ja fechadas (close[1..3]), nao inclui mais a vela ao vivo
    (close[1] < open[1]) and
    (close[2] < open[2]) and
    (close[3] < open[3])

bloqueia_terceira_compra =
    sequencia_terceira_compra and
    (not segunda_forte_compra)

bloqueia_terceira_venda =
    sequencia_terceira_venda and
    (not segunda_forte_venda)

-- FILTROS DE VELAS (Doji e Exaustao)
is_doji = corpo_atual <= (range_atual * 0.10)
is_exaustao = corpo_1 > (media_range * 2.5)  -- ESTAVEL: usa vela ja fechada (corpo_1), nao mais a vela ao vivo (corpo_atual)

-- TRAVA DE CAIXOTE (Lateralizacao Curta)
-- Evita alternancia constante de cores em velas pequenas
caixote_cor = ((close > open) and (close[1] < open[1])) or ((close < open) and (close[1] > open[1]))
caixote_tamanho = (corpo_atual < media_range * 0.60) and (corpo_1 < media_range * 0.60)
bloqueia_caixote = caixote_cor and caixote_tamanho

lateralizacao =
    -- V8.2: trava de lateralizacao mais forte para reduzir sinal invertido em mercado travado
    ((media_range > 0) and (range_atual < (media_range * 0.70)) and (range_1 < (media_range * 0.70))) or
    ((media_range > 0) and (corpo_atual < (media_range * 0.35)) and (corpo_1 < (media_range * 0.35))) or
    bloqueia_caixote

fractal_topo_base =
    (high[2] > high[1]) and
    (high[2] > high) and
    (high[2] > high[3]) and
    (high[2] > high[4])
fractal_fundo_base =
    (low[2] < low[1]) and
    (low[2] < low) and
    (low[2] < low[3]) and
    (low[2] < low[4])
fractal_topo_forte =
    fractal_topo_base and
    (high[2] >= upper[2]) and
    (close < close[1]) and
    (close[1] < high[2]) and
    ((range_ref > 0 and (high[2] - low[2]) > (range_ref * 0.10)) or (corpo_2 > media_range * 0.45)) and
    not lateralizacao
fractal_fundo_forte =
    fractal_fundo_base and
    (low[2] <= lower[2]) and
    (close > close[1]) and
    (close[1] > low[2]) and
    ((range_ref > 0 and (high[2] - low[2]) > (range_ref * 0.10)) or (corpo_2 > media_range * 0.45)) and
    not lateralizacao
plot_shape(fractal_topo_forte,
        'Fractal_Topo_Limpo',
        shape_style.triangledown,
        shape_size.large,
        fractal_top_color,
        shape_location.abovebar,
        -2,
        "F",
        fractal_top_color
)
plot_shape(fractal_fundo_forte,
        'Fractal_Fundo_Limpo',
        shape_style.triangleup,
        shape_size.large,
        fractal_bottom_color,
        shape_location.belowbar,
        -2,
        "F",
        fractal_bottom_color
)

-- ===================================================================
-- CORRECAO F3.2: EXAUSTAO MELHORADA (reconhece exaustao nas bandas)
-- ===================================================================
perto_resistencia = (range_ref > 0) and (high[1] >= (upper[1] - (range_ref * 0.04)))  -- ESTAVEL: vela e canal ja fechados
perto_suporte     = (range_ref > 0) and (low[1]  <= (lower[1] + (range_ref * 0.04)))  -- ESTAVEL: vela e canal ja fechados

-- Exaustao de compra: candle de alta perto da resistencia, corpo diminuindo,
-- nao faz topo novo = perdeu forca no topo
exaustao_compra_banda =  -- ESTAVEL: compara as 2 ultimas velas fechadas, nao a vela ao vivo
    (close[1] > open[1]) and
    perto_resistencia and
    (corpo_1 < corpo_2) and
    (high[1] <= high[2])

-- Exaustao de venda: candle de baixa perto do suporte, corpo diminuindo,
-- nao faz fundo novo = perdeu forca no fundo  
exaustao_venda_banda =  -- ESTAVEL: compara as 2 ultimas velas fechadas, nao a vela ao vivo
    (close[1] < open[1]) and
    perto_suporte and
    (corpo_1 < corpo_2) and
    (low[1] >= low[2])

-- Exaustao por pavio de rejeicao (martelo / estrela cadente na banda)
exaustao_rejeicao_compra =  -- ESTAVEL: usa a vela ja fechada (corpo_1/range_1), nao a vela ao vivo
    (corpo_1 <= media_range * 0.50) and
    perto_resistencia and
    (high[1] - max(open[1], close[1])) > (range_1 * 0.40)  -- pavio superior > 40% do range

exaustao_rejeicao_venda =  -- ESTAVEL: usa a vela ja fechada (corpo_1/range_1), nao a vela ao vivo
    (corpo_1 <= media_range * 0.50) and
    perto_suporte and
    (min(open[1], close[1]) - low[1]) > (range_1 * 0.40)  -- pavio inferior > 40% do range

-- ===================================================================
-- CORRECAO F3.2: REVERSAO NA PRIMEIRA E SEGUNDA VELA
-- ===================================================================

-- PRIMEIRA VELA DE REVERSAO (entrada imediata apos toque na banda ou fractal)
-- Compra: vela de alta surgindo apos toque no suporte ou fractal de fundo
rev_compra_1a =
    (close > open) and
    (close[1] < open[1]) and  -- vela anterior era de baixa
    ((low[1] <= lower[1]) or fractal_fundo_base) and  -- origem no suporte/fractal
    (close > close[1]) and  -- fechou acima do fechamento anterior
    (corpo_atual >= media_range * 0.30) and
    (not lateralizacao) and
    (not is_doji) and
    (not exaustao_rejeicao_venda)  -- nao entra se for martelo no suporte (aguarda conf.)

-- Venda: vela de baixa surgindo apos toque na resistencia ou fractal de topo
rev_venda_1a =
    (close < open) and
    (close[1] > open[1]) and  -- vela anterior era de alta
    ((high[1] >= upper[1]) or fractal_topo_base) and  -- origem na resistencia/fractal
    (close < close[1]) and  -- fechou abaixo do fechamento anterior
    (corpo_atual >= media_range * 0.30) and
    (not lateralizacao) and
    (not is_doji) and
    (not exaustao_rejeicao_compra)  -- nao entra se for estrela cadente na resist. (aguarda conf.)

-- SEGUNDA VELA DE REVERSAO (confirmacao)
-- Compra: segunda vela de alta confirmando a reversao
rev_compra_2a =
    (close > open) and
    (close[1] > open[1]) and  -- primeira vela de alta
    (close[2] < open[2]) and  -- antes era baixa
    ((low[2] <= lower[2]) or fractal_fundo_base) and  -- origem no suporte/fractal
    (close > close[1]) and  -- momentum subindo
    (corpo_atual >= media_range * 0.25) and
    (not lateralizacao) and
    (not is_doji)

-- Venda: segunda vela de baixa confirmando a reversao
rev_venda_2a =
    (close < open) and
    (close[1] < open[1]) and  -- primeira vela de baixa
    (close[2] > open[2]) and  -- antes era alta
    ((high[2] >= upper[2]) or fractal_topo_base) and  -- origem na resistencia/fractal
    (close < close[1]) and  -- momentum caindo
    (corpo_atual >= media_range * 0.25) and
    (not lateralizacao) and
    (not is_doji)

-- ===================================================================
-- CORRECAO F3.2: REVERSAO RAPIDA ORIGINAL (mantida, com ajuste)
-- ===================================================================

-- Relaxei o engolfo total: aceita close > close[1] quando tem fractal/banda
rev_compra_rapida =
    (close > open) and
    (
        (close > high[1]) or  -- engolfo total (ideal)
        (fractal_fundo_base and (close > close[1]))  -- ou reversao de fractal sem engolfo
    ) and
    (close > EMAA) and
    ((low[1] <= lower[1]) or fractal_fundo_base) and
    ((corpo_atual + corpo_1) > (media_range * 0.40))

rev_venda_rapida =
    (close < open) and
    (
        (close < low[1]) or  -- engolfo total (ideal)
        (fractal_topo_base and (close < close[1]))  -- ou reversao de fractal sem engolfo
    ) and
    (close < EMAA) and
    ((high[1] >= upper[1]) or fractal_topo_base) and
    ((corpo_atual + corpo_1) > (media_range * 0.40))

-- ===================================================================
-- CORRECAO F3.2: VELA DE DESCANSO / LIQUIDACAO (filtro melhorado)
-- ===================================================================

corpo_3 = abs(close[3] - open[3])
corpo_4 = abs(close[4] - open[4])

-- Vela de descanso: corpo pequeno, range contido, dentro do range da vela anterior
-- Nao rompe estrutura = nao e sinal de entrada
vela_descanso =
    (media_range > 0) and
    (corpo_atual <= media_range * 0.42) and  -- corpo muito pequeno
    (range_atual <= media_range * 1.20) and  -- range contido
    (high <= high[1] * 1.002) and  -- nao rompeu topo da anterior
    (low  >= low[1]  * 0.998)      -- nao rompeu fundo da anterior

-- Contexto de forca antes do descanso: 3+ velas na mesma direcao
tendencia_alta_previa =
    (close[1] > open[1]) and (close[2] > open[2]) and (close[3] > open[3])
tendencia_baixa_previa =
    (close[1] < open[1]) and (close[2] < open[2]) and (close[3] < open[3])

-- Bloqueia entrada quando: veio tendencia + vela de descanso + candle atual
-- tenta continuar mas sem forca real
bloqueia_compra_descanso =
    tendencia_alta_previa and
    vela_descanso and
    (close > open) and  -- candle atual tenta subir
    (high <= high[2]) and  -- mas nao supera o topo de 2 velas atras
    (corpo_atual < corpo_2 * 0.90)  -- e o corpo e menor que o da tendencia

bloqueia_venda_descanso =
    tendencia_baixa_previa and
    vela_descanso and
    (close < open) and  -- candle atual tenta cair
    (low >= low[2]) and  -- mas nao supera o fundo de 2 velas atras
    (corpo_atual < corpo_2 * 0.90)  -- e o corpo e menor que o da tendencia

-- ===================================================================
-- SINAIS ORIGINAIS (mantidos)
-- ===================================================================

compra_original =
    sequencia_terceira_compra and
    segunda_forte_compra

venda_original =
    sequencia_terceira_venda and
    segunda_forte_venda

cont_compra_tendencia =
    (close > open) and
    (close[1] > open[1]) and
    (close > close[1]) and
    (close[1] > close[2]) and
    (close > EMAA) and
    (EMAA >= EMAA[1]) and
    (EMAC >= EMAD) and
    ((corpo_atual + corpo_1) > (media_range * 0.70))

cont_compra_tendencia_anterior =
    (close[1] > open[1]) and
    (close[2] > open[2]) and
    (close[1] > close[2]) and
    (close[2] > close[3]) and
    (close[1] > EMAA[1]) and
    (EMAA[1] >= EMAA[2]) and
    (EMAC[1] >= EMAD[1]) and
    ((corpo_1 + corpo_2) > (media_range * 0.90))

cont_venda_tendencia =
    (close < open) and
    (close[1] < open[1]) and
    (close < close[1]) and
    (close[1] < close[2]) and
    (close < EMAA) and
    (EMAA <= EMAA[1]) and
    (EMAC <= EMAD) and
    ((corpo_atual + corpo_1) > (media_range * 0.65))

cont_venda_tendencia_anterior =
    (close[1] < open[1]) and
    (close[2] < open[2]) and
    (close[1] < close[2]) and
    (close[2] < close[3]) and
    (close[1] < EMAA[1]) and
    (EMAA[1] <= EMAA[2]) and
    (EMAC[1] <= EMAD[1]) and
    ((corpo_1 + corpo_2) > (media_range * 0.85))

cont_compra_v7 = cont_compra_tendencia and not cont_compra_tendencia_anterior
cont_venda_v7  = cont_venda_tendencia and not cont_venda_tendencia_anterior

venda_baixa_limpa_v82 =
    (range_ref > 0) and
    (not lateralizacao) and
    (close < open) and
    (close < low[1]) and
    (close < EMAA) and
    (EMAA <= EMAA[1]) and
    (EMAC <= EMAD) and
    (corpo_atual > (media_range * 0.50)) and
    (low > (lower + (range_ref * 0.05)))

compra_alta_limpa_v82 =
    (range_ref > 0) and
    (not lateralizacao) and
    (close > open) and
    (close > high[1]) and
    (close > EMAA) and
    (EMAA >= EMAA[1]) and
    (EMAC >= EMAD) and
    (corpo_atual > (media_range * 0.50)) and
    (high < (upper - (range_ref * 0.05)))

-- TRAVA DE EXAUSTAO EXTREMA - ELITE F3
-- Nao corta a 3a/4a vela boa. So tenta cortar a ultima armadilha.
-- ESTAVEL: sequencias agora contam velas ja fechadas [1..4/5/6], sem incluir a vela ao vivo
seq_alta4 = (close[1]>open[1]) and (close[2]>open[2]) and (close[3]>open[3]) and (close[4]>open[4])
seq_baixa4 = (close[1]<open[1]) and (close[2]<open[2]) and (close[3]<open[3]) and (close[4]<open[4])

seq_alta5 = seq_alta4 and (close[5]>open[5])
seq_baixa5 = seq_baixa4 and (close[5]<open[5])

seq_alta6 = seq_alta5 and (close[6]>open[6])
seq_baixa6 = seq_baixa5 and (close[6]<open[6])

distancia_ema = abs(close[1]-EMAA[1])  -- ESTAVEL: distancia da ultima vela fechada, nao da vela ao vivo
esticado_forte = distancia_ema > (media_range * 2.20)
esticado_extremo = distancia_ema > (media_range * 2.55)

perda_forca_alta = seq_alta4 and (corpo_1 < corpo_2) and (high[1] <= high[2])  -- ESTAVEL
perda_forca_baixa = seq_baixa4 and (corpo_1 < corpo_2) and (low[1] >= low[2])  -- ESTAVEL

bloqueio_compra_extremo =
    (seq_alta6 and esticado_forte) or
    (seq_alta5 and esticado_extremo) or
    (perda_forca_alta and perto_resistencia and esticado_extremo)

bloqueio_venda_extremo =
    (seq_baixa6 and esticado_forte) or
    (seq_baixa5 and esticado_extremo) or
    (perda_forca_baixa and perto_suporte and esticado_extremo)

-- TRAVA LOCALIZADA DE FALSO REINICIO - F3.2 OTC REFEITO
-- Nao conta sequencia estrutural e nao bloqueia continuacao limpa.
-- Atua somente quando:
-- 1) houve movimento esticado ate o extremo;
-- 2) surgiu uma vela contraria pequena de descanso;
-- 3) a vela atual tenta retomar a direcao anterior sem romper o extremo.

range_4 = high[4] - low[4]

alta_forte_antes_descanso =
    (close[2] > open[2]) and
    (close[3] > open[3]) and
    (close[4] > open[4]) and
    (close[2] > close[3]) and
    (close[3] > close[4])

baixa_forte_antes_descanso =
    (close[2] < open[2]) and
    (close[3] < open[3]) and
    (close[4] < open[4]) and
    (close[2] < close[3]) and
    (close[3] < close[4])

descanso_baixa_no_topo =
    (close[1] < open[1]) and
    (media_range > 0) and
    (corpo_1 <= (media_range * 0.55)) and
    (range_1 <= (media_range * 1.20)) and
    (high[1] >= (highest(high, 6)[1] - (media_range * 0.25))) and
    (close[1] >= EMAA[1])

descanso_alta_no_fundo =
    (close[1] > open[1]) and
    (media_range > 0) and
    (corpo_1 <= (media_range * 0.55)) and
    (range_1 <= (media_range * 1.20)) and
    (low[1] <= (lowest(low, 6)[1] + (media_range * 0.25))) and
    (close[1] <= EMAA[1])

tentativa_reinicio_compra =
    alta_forte_antes_descanso and
    descanso_baixa_no_topo and
    (close > open) and
    (close <= high[1]) and
    (high <= high[1]) and
    (
        perto_resistencia or
        (abs(close[2] - EMAA[2]) > (media_range * 2.00))
    )

tentativa_reinicio_venda =
    baixa_forte_antes_descanso and
    descanso_alta_no_fundo and
    (close < open) and
    (close >= low[1]) and
    (low >= low[1]) and
    (
        perto_suporte or
        (abs(close[2] - EMAA[2]) > (media_range * 2.00))
    )

-- ===================================================================
-- CORRECAO F3.2: BLOQUEIO DE TERCEIRA VELA EM EXAUSTAO DE BANDA
-- ===================================================================
bloqueia_terceira_compra_exaustao =
    sequencia_terceira_compra and
    (exaustao_compra_banda or exaustao_rejeicao_compra)

bloqueia_terceira_venda_exaustao =
    sequencia_terceira_venda and
    (exaustao_venda_banda or exaustao_rejeicao_venda)

-- ===================================================================
-- SINAL FINAL (CORRIGIDO F3.2)
-- ===================================================================

compra_final =
    (not lateralizacao) and
    (not is_doji) and
    (not is_exaustao) and
    (not bloqueio_compra_extremo) and
    (not tentativa_reinicio_compra) and
    (not bloqueia_terceira_compra) and
    (not bloqueia_terceira_compra_exaustao) and
    (not bloqueia_compra_descanso) and
    (
        rev_compra_1a or        -- NOVO: 1a vela de reversao no suporte/fractal
        rev_compra_2a or        -- NOVO: 2a vela confirmando reversao
        compra_original or
        rev_compra_rapida or
        cont_compra_v7 or
        compra_alta_limpa_v82
    )

venda_final =
    (not lateralizacao) and
    (not is_doji) and
    (not is_exaustao) and
    (not bloqueio_venda_extremo) and
    (not tentativa_reinicio_venda) and
    (not bloqueia_terceira_venda) and
    (not bloqueia_terceira_venda_exaustao) and
    (not bloqueia_venda_descanso) and
    (
        rev_venda_1a or         -- NOVO: 1a vela de reversao na resistencia/fractal
        rev_venda_2a or         -- NOVO: 2a vela confirmando reversao
        venda_original or
        rev_venda_rapida or
        cont_venda_v7 or
        venda_baixa_limpa_v82
    )

-- BOLINHAS REMOVIDAS NA VERSAO F3.2 OTC REFEITO

if compra_final then
    plot_shape(1,
            'Bull_UP',
            shape_style.arrowup,
            shape_size.large,
            call_color,
            shape_location.belowbar,
            0,
            "",
            "#fcfc04"
                       )
else
    if venda_final then
    plot_shape(1,
            'Bear_DOWN',
            shape_style.arrowdown,
            shape_size.large,
            put_color,
            shape_location.abovebar,
            0,
            "",
            "#fcfc01"
                       )
    end
end

method_id = input (1, "Type", input.string_selection, { "M1 " })  -- FIX: default era 2, mas methods{} so tem 1 item (m15) -> methods[2] = nil -> crash ao chamar method(sec)
input_group {
    "Maxima",
    level_1_color = input { default = "#FFFFFF", type = input.color },
    level_1_width = input { default = 2, type = input.line_width }
}
input_group {
    "Minima",
    level_2_color = input { default = "#FFFFFF", type = input.color },
    level_2_width = input { default = 2, type = input.line_width }
}
local function m15(candle)
    c1 = candle.high
    c2 = candle.low
end
local methods = { m15 }
local resolution = "15m"
sec = security (current_ticker_id, resolution)
if sec then
   local method = methods [method_id]
   method (sec)
   plot (c1, "C1",   level_1_color, level_1_width, 0, style.levels, na_mode.continue)
   plot (c2, "C2",   level_2_color, level_2_width, 0, style.levels, na_mode.continue)
end
percentage = input (2, "Percentage", input.double, 0.01, 100, 1.0)  -- FIX: tirei o "/ 100" daqui; reverse_range (mais abaixo) ja divide por 100. Estava dividindo 2x, deixando o limiar de reversao 100x menor (0.02% em vez de 2%), o que faz o ZigZag reverter a qualquer soluco de preco
period = 2
input_group {
    "front.ind.dpo.generalline",
    up_color = input { default = "#02f7aa", type = input.color },
    down_color = input { default = "#f77902", type = input.color },
    width = input { default = 1, type = input.line_width }
}
local reference = make_series ()
reference:set(nz(reference[1], high))
local is_direction_up = make_series ()
is_direction_up:set(nz(is_direction_up[1], true))
local htrack = make_series ()
local ltrack = make_series ()
local pivot = make_series ()
reverse_range = reference * percentage / 100
if get_value (is_direction_up) then
    htrack:set (max(high, nz(htrack[1], high)))
    if close < htrack[1] - reverse_range then
        pivot:set (htrack)
        is_direction_up:set (false)
        reference:set(htrack)
    end
else
    ltrack:set (min(low, nz(ltrack[1], low)))
    if close > ltrack[1] + reverse_range then
        pivot:set (ltrack)
        is_direction_up:set(true)
        reference:set (ltrack)
    end
end
color = is_direction_up() and  up_color or down_color
plot(pivot, 'ZZ', color, width, -1, style.solid_line, na_mode.continue)