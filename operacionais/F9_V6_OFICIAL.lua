-- F9 V6 OFICIAL
-- Base V2. So 2 ajustes: RANGE persistente + H com 1 vela de tolerancia.
instrument { name = "F9 V6", icon="jpg", overlay=true }

input_group {
    "Base",
    doch_time = input { default="10", type=input.string },
    emaa_per  = input { default="10", type=input.string }
}
input_group {
    "Candles",
    positivo = input { default="#0bd104", type=input.color },
    negativo = input { default="#f70202", type=input.color },
    neutro   = input { default="#787b86", type=input.color }
}
input_group {
    "Canal",
    upline_color  = input { default="#FF8C00", type=input.color },
    lowline_color = input { default="#00FF66", type=input.color }
}
input_group {
    "Motor F9",
    eficiencia_min_txt       = input { default="12", type=input.string },
    eficiencia_curta_min_txt = input { default="8", type=input.string },
    forca_min_txt             = input { default="20", type=input.string },
    exaustao_limiar_txt       = input { default="25", type=input.string }
}
input_group {
    "Freio pos-impulso",
    pos_impulso_range_pct_txt    = input { default="120", type=input.string },
    pos_impulso_corpo_pct_txt    = input { default="55", type=input.string },
    pos_impulso_proximidade_txt  = input { default="25", type=input.string },
    pos_impulso_break_corpo_txt  = input { default="20", type=input.string }
}
input_group {
    "Fluxo",
    s8_fluxo_eficiencia_txt = input { default="18", type=input.string },
    s8_ponta_mult_txt       = input { default="4.5", type=input.string },
    s8_ponta_corpo_txt      = input { default="70", type=input.string },
    s8_ponta_pavio_txt      = input { default="30", type=input.string }
}
input_group { "Compra", call_color = input { default="#0bd104", type=input.color } }
input_group { "Venda",  put_color  = input { default="#f70202", type=input.color } }

EMAA  = ema(close,emaa_per)
upper = highest(high,doch_time)
lower = lowest(low,doch_time)
TA = (close>close[1]) and (close>EMAA) and (EMAA>EMAA[1])
TB = (close<close[1]) and (close<EMAA) and (EMAA<EMAA[1])

corpo_atual = abs(close-open)
range_atual = high-low
range_1 = high[1]-low[1]
range_2 = high[2]-low[2]
range_3 = high[3]-low[3]
range_4 = high[4]-low[4]
range_5 = high[5]-low[5]
range_6 = high[6]-low[6]
range_7 = high[7]-low[7]
range_8 = high[8]-low[8]
range_9 = high[9]-low[9]
range_10 = high[10]-low[10]
range_11 = high[11]-low[11]
range_12 = high[12]-low[12]
range_13 = high[13]-low[13]
range_14 = high[14]-low[14]

media_range = (range_atual+range_1+range_2+range_3)/4
media_range_15 = (range_atual+range_1+range_2+range_3+range_4+range_5+range_6+range_7+range_8+range_9+range_10+range_11+range_12+range_13+range_14)/15
media_range_s8 = (range_1+range_2+range_3+range_4+range_5)/5
forca_min = tonumber(forca_min_txt)/100

-- Leitura visual original sem security M1: mais leve.
bar_color = neutro
if TA then
    bar_color = positivo
elseif TB then
    bar_color = negativo
end
plot_candle(open,high,low,close,"ES",bar_color)
plot(upper,"Resistencia",upline_color)
plot(lower,"Suporte",lowline_color)

-- Lateralizacao original.
progresso_liquido = abs(close-close[7])
movimento_total = range_atual+range_1+range_2+range_3+range_4+range_5+range_6+range_7
eficiencia = (movimento_total>0) and (progresso_liquido/movimento_total*100) or 100
lateralizado = eficiencia<tonumber(eficiencia_min_txt)

progresso_liquido_curto = abs(close-close[3])
movimento_total_curto = range_atual+range_1+range_2+range_3
eficiencia_curta = (movimento_total_curto>0) and (progresso_liquido_curto/movimento_total_curto*100) or 100
lateralizado_curto = eficiencia_curta<tonumber(eficiencia_curta_min_txt)

-- Caixotinho fechado: conhecido desde o inicio da vela.
movimento_micro_fechado = range_1+range_2+range_3+range_4+range_5
progresso_micro_fechado = abs(close[1]-close[5])
eficiencia_micro_fechada = (movimento_micro_fechado>0) and (progresso_micro_fechado/movimento_micro_fechado*100) or 100

-- Exaustao antiga do F9, preservada.
distancia_perna = abs(close-close[15])
perna_esticada = (media_range>0) and (distancia_perna>media_range*tonumber(exaustao_limiar_txt)) or false

-- Freio pos-impulso original.
media_range_fechada_8 = (range_2+range_3+range_4+range_5+range_6+range_7+range_8+range_9)/8
corpo_1_fechado = abs(close[1]-open[1])
corpo_1_pct = (range_1>0) and (corpo_1_fechado/range_1*100) or 0
limiar_range_impulso = media_range_fechada_8*tonumber(pos_impulso_range_pct_txt)/100
impulso_alta_fechado = (media_range_fechada_8>0) and (close[1]>open[1]) and
                        (range_1>=limiar_range_impulso) and (corpo_1_pct>=tonumber(pos_impulso_corpo_pct_txt))
impulso_baixa_fechado = (media_range_fechada_8>0) and (close[1]<open[1]) and
                         (range_1>=limiar_range_impulso) and (corpo_1_pct>=tonumber(pos_impulso_corpo_pct_txt))
topo_fechado_pos = highest(high[1],doch_time)
fundo_fechado_pos = lowest(low[1],doch_time)
margem_pos_impulso = media_range_fechada_8*tonumber(pos_impulso_proximidade_txt)/100
chegou_topo_pos = (topo_fechado_pos-high[1])<=margem_pos_impulso
chegou_fundo_pos = (low[1]-fundo_fechado_pos)<=margem_pos_impulso
corpo_break_pos = media_range_fechada_8*tonumber(pos_impulso_break_corpo_txt)/100
rompimento_compra_pos = (close>topo_fechado_pos) and (close>open) and (corpo_atual>=corpo_break_pos)
rompimento_venda_pos = (close<fundo_fechado_pos) and (close<open) and (corpo_atual>=corpo_break_pos)
freio_pos_compra = impulso_alta_fechado and chegou_topo_pos and (not rompimento_compra_pos)
freio_pos_venda = impulso_baixa_fechado and chegou_fundo_pos and (not rompimento_venda_pos)

-- Pavio / borda.
pavio_superior_atual = high-max(open,close)
pavio_inferior_atual = min(open,close)-low
pavio_superior_pct = (range_atual>0) and (pavio_superior_atual/range_atual*100) or 0
pavio_inferior_pct = (range_atual>0) and (pavio_inferior_atual/range_atual*100) or 0
margem_extremo = media_range*0.30
perto_resistencia = (upper-high)<=margem_extremo
perto_suporte = (low-lower)<=margem_extremo
regime_alta_fechado = (close[1]>EMAA[1]) and (EMAA[1]>=EMAA[2])
regime_baixa_fechado = (close[1]<EMAA[1]) and (EMAA[1]<=EMAA[2])

-- Fluxo original S8.
dir_1 = (close[1]>open[1]) and 1 or ((close[1]<open[1]) and -1 or 0)
dir_2 = (close[2]>open[2]) and 1 or ((close[2]<open[2]) and -1 or 0)
dir_3 = (close[3]>open[3]) and 1 or ((close[3]<open[3]) and -1 or 0)
dir_4 = (close[4]>open[4]) and 1 or ((close[4]<open[4]) and -1 or 0)
dir_5 = (close[5]>open[5]) and 1 or ((close[5]<open[5]) and -1 or 0)
troca_12 = (dir_1~=0) and (dir_2~=0) and (dir_1~=dir_2) and 1 or 0
troca_23 = (dir_2~=0) and (dir_3~=0) and (dir_2~=dir_3) and 1 or 0
troca_34 = (dir_3~=0) and (dir_4~=0) and (dir_3~=dir_4) and 1 or 0
troca_45 = (dir_4~=0) and (dir_5~=0) and (dir_4~=dir_5) and 1 or 0
alternancias_5 = troca_12+troca_23+troca_34+troca_45
movimento_fluxo_6 = range_atual+range_1+range_2+range_3+range_4+range_5
progresso_fluxo_6 = abs(close-close[5])
eficiencia_fluxo_6 = (movimento_fluxo_6>0) and (progresso_fluxo_6/movimento_fluxo_6*100) or 100
falso_fluxo_s8 = (alternancias_5>=3) and (eficiencia_fluxo_6<tonumber(s8_fluxo_eficiencia_txt))
distancia_s8 = abs(close-close[5])
perna_forte_s8 = (media_range_s8>0) and (distancia_s8>=media_range_s8*tonumber(s8_ponta_mult_txt))
corpo_rel_s8 = (media_range_s8>0) and (corpo_atual/media_range_s8*100) or 100
perdeu_corpo_s8 = corpo_rel_s8<tonumber(s8_ponta_corpo_txt)
rejeita_compra_s8 = pavio_superior_pct>=tonumber(s8_ponta_pavio_txt)
rejeita_venda_s8 = pavio_inferior_pct>=tonumber(s8_ponta_pavio_txt)
ponta_compra_s8 = perna_forte_s8 and perto_resistencia and (perdeu_corpo_s8 or rejeita_compra_s8)
ponta_venda_s8 = perna_forte_s8 and perto_suporte and (perdeu_corpo_s8 or rejeita_venda_s8)

-- S9 Lite original.
s9lite_alta_madura = regime_alta_fechado and perna_forte_s8 and perto_resistencia
s9lite_baixa_madura = regime_baixa_fechado and perna_forte_s8 and perto_suporte
s9lite_pausa_alta = (close[1]<=close[2]+media_range_s8*0.18) or rejeita_compra_s8
s9lite_pausa_baixa = (close[1]>=close[2]-media_range_s8*0.18) or rejeita_venda_s8
s9lite_retomou_alta = close>high[1] and close>open and corpo_atual>media_range_s8*0.40
s9lite_retomou_baixa = close<low[1] and close<open and corpo_atual>media_range_s8*0.40
s9lite_bloqueia_compra = s9lite_alta_madura and s9lite_pausa_alta and (not s9lite_retomou_alta)
s9lite_bloqueia_venda = s9lite_baixa_madura and s9lite_pausa_baixa and (not s9lite_retomou_baixa)

-- Trava minima antiga do F9.
f9_margem_extremo = media_range_s8*0.30
f9_topo_fechado = highest(high[1],doch_time)
f9_fundo_fechado = lowest(low[1],doch_time)
f9_topo_repetido = ((f9_topo_fechado-high[1])<=f9_margem_extremo) and ((f9_topo_fechado-high[2])<=f9_margem_extremo)
f9_fundo_repetido = ((low[1]-f9_fundo_fechado)<=f9_margem_extremo) and ((low[2]-f9_fundo_fechado)<=f9_margem_extremo)
f9_sem_avanco_alta = close[1]<=close[2]+media_range_s8*0.18
f9_sem_avanco_baixa = close[1]>=close[2]-media_range_s8*0.18
f9_rompeu_topo = close>high[1] and close>open and corpo_atual>media_range_s8*0.40
f9_rompeu_fundo = close<low[1] and close<open and corpo_atual>media_range_s8*0.40
f9_bloqueia_compra = regime_alta_fechado and perto_resistencia and f9_topo_repetido and f9_sem_avanco_alta and (not f9_rompeu_topo)
f9_bloqueia_venda = regime_baixa_fechado and perto_suporte and f9_fundo_repetido and f9_sem_avanco_baixa and (not f9_rompeu_fundo)

-- F11 V3 COMPACTA: RANGE persistente por velas fechadas.
lat_base = media_range_s8
lat_mov_fechado = range_1+range_2+range_3+range_4+range_5+range_6+range_7+range_8
lat_prog_fechado = abs(close[1]-close[8])
lat_eff_fechado = (lat_mov_fechado>0) and (lat_prog_fechado/lat_mov_fechado*100) or 100
lat_fechado = (alternancias_5>=3) and (lat_eff_fechado<25)

caixote_lite = (alternancias_5>=3) and (eficiencia_micro_fechada<22)
caixote_micro = (alternancias_5>=2) and (eficiencia_micro_fechada<14)
caixote_compacto = caixote_lite or caixote_micro

lat_topo_6 = highest(high[1],6)
lat_fundo_6 = lowest(low[1],6)

local rg_mem = make_series("F11V3C_RG")
local rt_mem = make_series("F11V3C_RT")
local rb_mem = make_series("F11V3C_RB")
rg_prev = nz(rg_mem[1],0)
rt_prev = nz(rt_mem[1],lat_topo_6)
rb_prev = nz(rb_mem[1],lat_fundo_6)
rg_estado = rg_prev
lat_topo = rt_prev
lat_fundo = rb_prev

if rg_prev==0 and (lat_fechado or caixote_compacto) then
    rg_estado = 1
    lat_topo = lat_topo_6
    lat_fundo = lat_fundo_6
elseif rg_prev==1 then
    rg_sai_up = (close[2]>rt_prev+lat_base*0.05) and (close[1]>rt_prev+lat_base*0.05)
    rg_sai_dn = (close[2]<rb_prev-lat_base*0.05) and (close[1]<rb_prev-lat_base*0.05)
    if rg_sai_up or rg_sai_dn then rg_estado=0 end
end

rg_mem:set(rg_estado)
rt_mem:set(lat_topo)
rb_mem:set(lat_fundo)
rg_em_range = (rg_estado==1)

lat_amplitude = lat_topo-lat_fundo
lat_range_largo = rg_em_range and (lat_base>0) and (lat_amplitude>=lat_base*2.20)

lat_venda = rg_em_range and (not caixote_compacto) and lat_range_largo and
            (high>=lat_topo-lat_base*0.12) and
            (close<lat_topo-lat_base*0.08) and (close<open) and (close<close[1]) and
            ((high-close)>=lat_base*0.45) and (corpo_atual>=lat_base*0.22)
lat_compra = rg_em_range and (not caixote_compacto) and lat_range_largo and
             (low<=lat_fundo+lat_base*0.12) and
             (close>lat_fundo+lat_base*0.08) and (close>open) and (close>close[1]) and
             ((close-low)>=lat_base*0.45) and (corpo_atual>=lat_base*0.22)

-- ============================================================
-- NOVO 2: rompeu a caixa -> segunda vela confirma fora.
-- Se a segunda descansou fora, a terceira pode retomar.
-- ============================================================
pb_mov1 = range_2+range_3+range_4+range_5+range_6+range_7+range_8
pb_eff1 = (pb_mov1>0) and (abs(close[2]-close[8])/pb_mov1*100) or 100
pb_top1 = highest(high[2],7)
pb_bot1 = lowest(low[2],7)
pb_c1 = abs(close[1]-open[1])
pb_ps1 = high[1]-max(open[1],close[1])
pb_pi1 = min(open[1],close[1])-low[1]
pb_up1 = (pb_eff1<18) and (close[1]>pb_top1+lat_base*0.08) and (close[1]>open[1]) and
         (pb_c1>=lat_base*0.35) and ((range_1<=0) or (pb_ps1/range_1*100<40))
pb_dn1 = (pb_eff1<18) and (close[1]<pb_bot1-lat_base*0.08) and (close[1]<open[1]) and
         (pb_c1>=lat_base*0.35) and ((range_1<=0) or (pb_pi1/range_1*100<40))

pb_mov2 = range_3+range_4+range_5+range_6+range_7+range_8+range_9
pb_eff2 = (pb_mov2>0) and (abs(close[3]-close[9])/pb_mov2*100) or 100
pb_top2 = highest(high[3],7)
pb_bot2 = lowest(low[3],7)
pb_c2 = abs(close[2]-open[2])
pb_up2 = (pb_eff2<18) and (close[2]>pb_top2+lat_base*0.08) and (close[2]>open[2]) and (pb_c2>=lat_base*0.35)
pb_dn2 = (pb_eff2<18) and (close[2]<pb_bot2-lat_base*0.08) and (close[2]<open[2]) and (pb_c2>=lat_base*0.35)
pb_rest_up = pb_up2 and (close[1]>pb_top2+lat_base*0.02)
pb_rest_dn = pb_dn2 and (close[1]<pb_bot2-lat_base*0.02)
posrompe_compra = rg_em_range and ((pb_up1 and close>pb_top1+lat_base*0.05) or (pb_rest_up and close>pb_top2+lat_base*0.05)) and
                   (close>open) and (close>close[1]) and (corpo_atual>=lat_base*0.20)
posrompe_venda = rg_em_range and ((pb_dn1 and close<pb_bot1-lat_base*0.05) or (pb_rest_dn and close<pb_bot2-lat_base*0.05)) and
                  (close<open) and (close<close[1]) and (corpo_atual>=lat_base*0.20)

-- ============================================================
-- NOVO 3: H de exaustao fechado e persistente no grafico.
-- H avisa e trava a mesma direcao; nao manda inverter.
-- ============================================================
h_base = lat_base
h_c1 = abs(close[1]-open[1])
h_ps1 = high[1]-max(open[1],close[1])
h_pi1 = min(open[1],close[1])-low[1]
h_cp1 = (range_1>0) and (h_c1/range_1*100) or 0
h_psp1 = (range_1>0) and (h_ps1/range_1*100) or 0
h_pip1 = (range_1>0) and (h_pi1/range_1*100) or 0
h_top3 = max(high[2],max(high[3],high[4]))
h_bot3 = min(low[2],min(low[3],low[4]))
h_perna_up = regime_alta_fechado and (h_base>0) and ((close[1]-close[6])>=h_base*1.50) and (close[1]>close[3])
h_perna_dn = regime_baixa_fechado and (h_base>0) and ((close[6]-close[1])>=h_base*1.50) and (close[1]<close[3])
h_run_up = (close[1]>h_top3+h_base*0.05) and (close[1]>open[1]) and (h_cp1>=55) and (h_psp1<=30)
h_run_dn = (close[1]<h_bot3-h_base*0.05) and (close[1]<open[1]) and (h_cp1>=55) and (h_pip1<=30)
h_raw_topo = h_perna_up and ((f9_topo_fechado-high[1])<=h_base*0.25) and
             ((close[1]<=close[2]+h_base*0.08) or (h_psp1>=30) or (h_cp1<45)) and (not h_run_up)
h_raw_fundo = h_perna_dn and ((low[1]-f9_fundo_fechado)<=h_base*0.25) and
              ((close[1]>=close[2]-h_base*0.08) or (h_pip1>=30) or (h_cp1<45)) and (not h_run_dn)

local h_bar_mem = make_series("F11V3C_H_BAR")
local h_estado_mem = make_series("F11V3C_H_ESTADO")
local h_nivel_mem = make_series("F11V3C_H_NIVEL")
h_agora = get_value(open_time,0)
h_mesma = (get_value(h_bar_mem,-1)==h_agora)
h_prev = nz(h_estado_mem[1],0)
h_prev_nivel = nz(h_nivel_mem[1],0)
if h_mesma then
    h_estado = get_value(h_estado_mem,h_prev)
    h_nivel = get_value(h_nivel_mem,h_prev_nivel)
else
    h_estado = h_prev
    h_nivel = h_prev_nivel
end

h_marca_topo = h_raw_topo and (h_prev~=1)
h_marca_fundo = h_raw_fundo and (h_prev~=-1)
if h_marca_topo then
    h_estado = 1
    h_nivel = high[1]
elseif h_marca_fundo then
    h_estado = -1
    h_nivel = low[1]
end

h_libera_up = (h_estado==1) and (close[1]>h_nivel+h_base*0.05) and
              (close>h_nivel+h_base*0.05) and (close>open) and (close>close[1]) and (corpo_atual>=h_base*0.20)
h_libera_dn = (h_estado==-1) and (close[1]<h_nivel-h_base*0.05) and
              (close<h_nivel-h_base*0.05) and (close<open) and (close<close[1]) and (corpo_atual>=h_base*0.20)
h_virou_dn = (h_estado==1) and regime_baixa_fechado and (close<EMAA) and (close<close[1])
h_virou_up = (h_estado==-1) and regime_alta_fechado and (close>EMAA) and (close>close[1])
if h_libera_up or h_libera_dn or h_virou_dn or h_virou_up then
    h_estado = 0
end
h_bar_mem:set(h_agora)
h_estado_mem:set(h_estado)
h_nivel_mem:set(h_nivel)

-- Motor F9 original fora da caixa.
-- V2: caixote compacto cala os dois lados; H continua sendo trava de exaustao.
base_compra = TA and (not lateralizado) and (not lateralizado_curto) and (not lat_fechado) and (not caixote_compacto) and (not rg_em_range) and
              (corpo_atual>media_range_15*forca_min) and (not perna_esticada) and (not freio_pos_compra) and
              (not falso_fluxo_s8) and (not ponta_compra_s8) and (not s9lite_bloqueia_compra) and (not f9_bloqueia_compra)
base_venda = TB and (not lateralizado) and (not lateralizado_curto) and (not lat_fechado) and (not caixote_compacto) and (not rg_em_range) and
             (corpo_atual>media_range_15*forca_min) and (not perna_esticada) and (not freio_pos_venda) and
             (not falso_fluxo_s8) and (not ponta_venda_s8) and (not s9lite_bloqueia_venda) and (not f9_bloqueia_venda)

-- Pos-rompimento continua podendo falar mesmo quando a caixa anterior era compacta:
-- primeira vela rompe, segunda sustenta/progride e so entao libera a direcao.
candidato_compra = base_compra or lat_compra or posrompe_compra
candidato_venda = base_venda or lat_venda or posrompe_venda
if (h_estado==1) and (not h_marca_topo) then candidato_compra=false end
if (h_estado==-1) and (not h_marca_fundo) then candidato_venda=false end

-- ============================================================
-- F11 V2 / NOVO 4: LATCH REAL DA PRIMEIRA DECISAO DA M1.
-- Depois que a primeira direcao valida nasce, ela permanece gravada ate
-- fechar a M1. A seta nao depende mais do candidato continuar verdadeiro.
-- Isso evita Compra -> Venda / Venda -> Compra na mesma vela e evita
-- que a primeira seta suma quando o preco devolve intravela.
-- ============================================================
local d_bar_mem = make_series("F11V3C_DIR_BAR")
local d_dir_mem = make_series("F11V3C_DIR")
d_agora = get_value(open_time,0)
d_mesma = (get_value(d_bar_mem,-1)==d_agora)

if d_mesma then
    d_dir = get_value(d_dir_mem,0)
else
    d_dir = 0
end

if d_dir==0 then
    if candidato_compra and (not candidato_venda) then
        d_dir = 1
    elseif candidato_venda and (not candidato_compra) then
        d_dir = -1
    end
end

d_bar_mem:set(d_agora)
d_dir_mem:set(d_dir)

-- A decisao latched e a saida final. Nao recalcula o lado depois.
sinal_compra = (d_dir==1)
sinal_venda = (d_dir==-1)

-- H fica registrado na vela que gerou o aviso, mesmo se depois houver rompimento.
plot_shape(h_marca_topo,"H_TOPO",shape_style.diamond,shape_size.large,"#FF9800",shape_location.abovebar,-1,"H","#FFFFFF")
plot_shape(h_marca_fundo,"H_FUNDO",shape_style.diamond,shape_size.large,"#00E5FF",shape_location.belowbar,-1,"H","#FFFFFF")

if sinal_compra then
    plot_shape(1,"Bull_UP",shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"Compra","#fcfc04")
elseif sinal_venda then
    plot_shape(1,"Bear_DOWN",shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"Venda","#fcfc01")
end

-- Fractal estrutural original, preservado.
input_group {
    "Fractal estrutural",
    fractal_top_color = input { default="#ff8c00", type=input.color },
    fractal_bottom_color = input { default="#00ff88", type=input.color },
    fractal_borda_pct_txt = input { default="35", type=input.string },
    fractal_prom_pct_txt = input { default="8", type=input.string },
    fractal_rejeicao_pct_txt = input { default="22", type=input.string },
    fractal_amplitude_mult_txt = input { default="2.2", type=input.string }
}
fr_media_range = (range_1+range_2+range_3+range_4+range_5+range_6+range_7)/7
fr_local_high = highest(high,9)
fr_local_low = lowest(low,9)
fr_amplitude_9 = fr_local_high-fr_local_low
fr_margem_borda = fr_media_range*tonumber(fractal_borda_pct_txt)/100
fr_prom_min = fr_media_range*tonumber(fractal_prom_pct_txt)/100
fr_range_2 = high[2]-low[2]
fr_pavio_sup_2 = high[2]-max(open[2],close[2])
fr_pavio_inf_2 = min(open[2],close[2])-low[2]
fr_pavio_sup_pct_2 = (fr_range_2>0) and (fr_pavio_sup_2/fr_range_2*100) or 0
fr_pavio_inf_pct_2 = (fr_range_2>0) and (fr_pavio_inf_2/fr_range_2*100) or 0
fractal_topo_base = (high[2]>high[1]) and (high[2]>high) and (high[2]>high[3]) and (high[2]>high[4])
fractal_fundo_base = (low[2]<low[1]) and (low[2]<low) and (low[2]<low[3]) and (low[2]<low[4])
fr_topo_na_borda = (fr_local_high-high[2])<=fr_margem_borda
fr_fundo_na_borda = (low[2]-fr_local_low)<=fr_margem_borda
fr_prom_topo = high[2]-max(high[1],high[3])
fr_prom_fundo = min(low[1],low[3])-low[2]
fr_topo_destacado = fr_prom_topo>=fr_prom_min
fr_fundo_destacado = fr_prom_fundo>=fr_prom_min
fr_chegada_topo = (close[2]>close[4]) or ((high[2]-low[4])>=fr_media_range*1.10)
fr_chegada_fundo = (close[2]<close[4]) or ((high[4]-low[2])>=fr_media_range*1.10)
fr_rejeicao_topo = (fr_pavio_sup_pct_2>=tonumber(fractal_rejeicao_pct_txt)) or (close[1]<close[2]) or (close<close[1])
fr_rejeicao_fundo = (fr_pavio_inf_pct_2>=tonumber(fractal_rejeicao_pct_txt)) or (close[1]>close[2]) or (close>close[1])
fr_range_suficiente = (fr_media_range>0) and (fr_amplitude_9>=fr_media_range*tonumber(fractal_amplitude_mult_txt))
fr_lateral_apertada = (alternancias_5>=3) and (eficiencia_fluxo_6<tonumber(s8_fluxo_eficiencia_txt)) and (not fr_range_suficiente)
fr_topo_valido_em_lateral = fr_topo_na_borda and fr_topo_destacado and fr_rejeicao_topo and fr_range_suficiente
fr_fundo_valido_em_lateral = fr_fundo_na_borda and fr_fundo_destacado and fr_rejeicao_fundo and fr_range_suficiente
fractal_topo_forte = fractal_topo_base and fr_topo_na_borda and fr_chegada_topo and fr_rejeicao_topo and
                     (fr_topo_destacado or (fr_pavio_sup_pct_2>=tonumber(fractal_rejeicao_pct_txt))) and
                     ((not fr_lateral_apertada) or fr_topo_valido_em_lateral)
fractal_fundo_forte = fractal_fundo_base and fr_fundo_na_borda and fr_chegada_fundo and fr_rejeicao_fundo and
                      (fr_fundo_destacado or (fr_pavio_inf_pct_2>=tonumber(fractal_rejeicao_pct_txt))) and
                      ((not fr_lateral_apertada) or fr_fundo_valido_em_lateral)
plot_shape(fractal_topo_forte,"Fractal_Topo_Estrutural",shape_style.triangledown,shape_size.large,
           fractal_top_color,shape_location.abovebar,-2,"F",fractal_top_color)
plot_shape(fractal_fundo_forte,"Fractal_Fundo_Estrutural",shape_style.triangleup,shape_size.large,
           fractal_bottom_color,shape_location.belowbar,-2,"F",fractal_bottom_color)

-- Maxima/minima M15 original, mantidas.
input_group {
    "M15",
    level_1_color = input { default="#FF3EB5", type=input.color },
    level_2_color = input { default="#FF3EB5", type=input.color },
    level_width = input { default=2, type=input.line_width }
}
local function m15(candle)
    c1 = candle.high
    c2 = candle.low
end
sec15 = security(current_ticker_id,"15m")
if sec15 then
    m15(sec15)
    plot(c1,"C1",level_1_color,level_width,0,style.levels,na_mode.continue)
    plot(c2,"C2",level_2_color,level_width,0,style.levels,na_mode.continue)
end