instrument{name="B3 SELETIVO",icon="jpg",overlay=true}
input_group{ "Periodo Max/Min", doch_time=input{default="10",type=input.string} }
input_group{ "Periodo da Micro Tendencia", emaa_per=input{default="10",type=input.string} }
input_group{ "Candles", positivo=input{default="#00FF00",type=input.color}, negativo=input{default="#FF2A00",type=input.color}, neutro=input{default="#FFFFFF",type=input.color}, }
input_group{ "Canal (Resistencia/Suporte)", upline_color=input{default="#FF8C00",type=input.color}, lowline_color=input{default="#00FF66",type=input.color} }
EMAA=ema(close,emaa_per)
upper=highest(high,doch_time)
lower=lowest(low,doch_time)
input_group{ "Qualidade Fixa do Sinal", micro_eficiencia_txt=input{default="35",type=input.string}, micro_corpo_pct_txt=input{default="45",type=input.string}, micro_tamanho_pct_txt=input{default="60",type=input.string}, }
corpo_atual=abs(close-open)
range_atual=high-low
micro_range_1f=high[1]-low[1]
micro_range_2f=high[2]-low[2]
micro_range_3f=high[3]-low[3]
micro_range_4f=high[4]-low[4]
micro_range_5f=high[5]-low[5]
movimento_micro_fechado=micro_range_1f+micro_range_2f+micro_range_3f+micro_range_4f+micro_range_5f
media_micro_fechada=movimento_micro_fechado/5
progresso_micro_fechado=abs(close[1]-close[5])
eficiencia_micro_fechada=(movimento_micro_fechado>0)and(progresso_micro_fechado/movimento_micro_fechado*100)or 100
micro_corpo_atual_pct=(range_atual>0)and(corpo_atual/range_atual*100)or 100
micro_vela_atual_fraca=(micro_corpo_atual_pct<tonumber(micro_corpo_pct_txt))and(media_micro_fechada>0)and(corpo_atual<media_micro_fechada*tonumber(micro_tamanho_pct_txt)/100)
sec=security(current_ticker_id,"1m")
if sec then
local bar_color
if(close>open)then
bar_color=positivo
elseif(close<open)then
bar_color=negativo
else
bar_color=neutro
end
plot_candle(open,high,low,close,"ES",bar_color)
plot(upper,"Resistencia",upline_color)
plot(lower,"Suporte",lowline_color)
end
range_1=high[1]-low[1]
range_2=high[2]-low[2]
range_3=high[3]-low[3]
range_4=high[4]-low[4]
range_5=high[5]-low[5]
range_6=high[6]-low[6]
range_7=high[7]-low[7]
media_range=(range_atual+range_1+range_2+range_3)/4
ed=EMAA-EMAA[1]
ep=EMAA[1]-EMAA[2]
ez=media_range*0.05
eu=(ed>ez)and(not((ep>0)and(ed<ep*0.55)and(close<=close[1]+media_range*0.18)))and(not((close[1]<open[1])and(abs(close[1]-open[1])>=media_range*0.28)))
eb=(ed<-ez)and(not((ep<0)and(abs(ed)<abs(ep)*0.55)and(close>=close[1]-media_range*0.18)))and(not((close[1]>open[1])and(abs(close[1]-open[1])>=media_range*0.28)))
TA=(close>close[1])and(close>EMAA)and eu
TB=(close<close[1])and(close<EMAA)and eb
range_8=high[8]-low[8]
range_9=high[9]-low[9]
range_10=high[10]-low[10]
range_11=high[11]-low[11]
range_12=high[12]-low[12]
range_13=high[13]-low[13]
range_14=high[14]-low[14]
media_range_15=(range_atual+range_1+range_2+range_3+range_4+range_5+range_6+range_7+range_8+range_9+range_10+range_11+range_12+range_13+range_14)/15
input_group{ "Lateralizacao e Forca Minima", eficiencia_min_txt=input{default="12",type=input.string}, forca_min_txt=input{default="20",type=input.string} }
progresso_liquido=abs(close-close[7])
movimento_total=range_atual+range_1+range_2+range_3+range_4+range_5+range_6+range_7
eficiencia=(movimento_total>0)and(progresso_liquido/movimento_total*100)or 100
lateralizado=eficiencia<tonumber(eficiencia_min_txt)
forca_min=tonumber(forca_min_txt)/100
input_group{ "Lateralizacao rapida (janela curta, pega caixotinho cedo)", eficiencia_curta_min_txt=input{default="8",type=input.string} }
progresso_liquido_curto=abs(close-close[3])
movimento_total_curto=range_atual+range_1+range_2+range_3
eficiencia_curta=(movimento_total_curto>0)and(progresso_liquido_curto/movimento_total_curto*100)or 100
lateralizado_curto=eficiencia_curta<tonumber(eficiencia_curta_min_txt)
micro_contexto_fraco_final=micro_vela_atual_fraca
input_group{ "Exaustao de perna (limiar em multiplos do range medio)", exaustao_limiar_txt=input{default="25",type=input.string} }
distancia_perna=abs(close-close[15])
perna_esticada=(media_range>0)and(distancia_perna>media_range*tonumber(exaustao_limiar_txt))or false
input_group{ "Freio pos-impulso S6 (apenas 1 vela)", pos_impulso_range_pct_txt=input{default="120",type=input.string}, pos_impulso_corpo_pct_txt=input{default="55",type=input.string}, pos_impulso_proximidade_txt=input{default="25",type=input.string}, pos_impulso_break_corpo_txt=input{default="20",type=input.string}, pos_impulso_break_margem_txt=input{default="0",type=input.string} }
media_range_fechada_8=(range_2+range_3+range_4+range_5+range_6+range_7+range_8+range_9)/8
corpo_1_fechado=abs(close[1]-open[1])
corpo_1_pct=(range_1>0)and(corpo_1_fechado/range_1*100)or 0
limiar_range_impulso=media_range_fechada_8*tonumber(pos_impulso_range_pct_txt)/100
impulso_alta_fechado=(media_range_fechada_8>0)and(close[1]>open[1])and(range_1>=limiar_range_impulso)and(corpo_1_pct>=tonumber(pos_impulso_corpo_pct_txt))
impulso_baixa_fechado=(media_range_fechada_8>0)and(close[1]<open[1])and(range_1>=limiar_range_impulso)and(corpo_1_pct>=tonumber(pos_impulso_corpo_pct_txt))
topo_fechado_pos=highest(high[1],doch_time)
fundo_fechado_pos=lowest(low[1],doch_time)
margem_pos_impulso=media_range_fechada_8*tonumber(pos_impulso_proximidade_txt)/100
chegou_topo_pos=(topo_fechado_pos-high[1])<=margem_pos_impulso
chegou_fundo_pos=(low[1]-fundo_fechado_pos)<=margem_pos_impulso
margem_break_pos=media_range_fechada_8*tonumber(pos_impulso_break_margem_txt)/100
corpo_break_pos=media_range_fechada_8*tonumber(pos_impulso_break_corpo_txt)/100
rompimento_compra_pos=(close>topo_fechado_pos+margem_break_pos)and(close>open)and(corpo_atual>=corpo_break_pos)
rompimento_venda_pos=(close<fundo_fechado_pos-margem_break_pos)and(close<open)and(corpo_atual>=corpo_break_pos)
freio_pos_compra=impulso_alta_fechado and chegou_topo_pos and(not rompimento_compra_pos)
freio_pos_venda=impulso_baixa_fechado and chegou_fundo_pos and(not rompimento_venda_pos)
input_group{ "Aviso de Extremo (somente recolore para lilas)", extremo_pavio_pct_txt=input{default="35",type=input.string}, extremo_proximidade_txt=input{default="30",type=input.string}, extremo_corpo_media_txt=input{default="85",type=input.string} }
pavio_superior_atual=high-max(open,close)
pavio_inferior_atual=min(open,close)-low
pavio_superior_pct=(range_atual>0)and(pavio_superior_atual/range_atual*100)or 0
pavio_inferior_pct=(range_atual>0)and(pavio_inferior_atual/range_atual*100)or 0
margem_extremo=media_range*tonumber(extremo_proximidade_txt)/100
perto_resistencia=(upper-high)<=margem_extremo
perto_suporte=(low-lower)<=margem_extremo
corpo_curto_extremo=(media_micro_fechada>0)and(corpo_atual<=media_micro_fechada*tonumber(extremo_corpo_media_txt)/100)
aviso_extremo_compra=perto_resistencia and corpo_curto_extremo and(pavio_superior_pct>=tonumber(extremo_pavio_pct_txt))
aviso_extremo_venda=perto_suporte and corpo_curto_extremo and(pavio_inferior_pct>=tonumber(extremo_pavio_pct_txt))
input_group{ "S6 - Transicao de Regime", transicao_pavio_pct_txt=input{default="30",type=input.string}, transicao_buffer_pct_txt=input{default="4",type=input.string} }
regime_alta_fechado=(close[1]>EMAA[1])and(EMAA[1]>=EMAA[2])
regime_baixa_fechado=(close[1]<EMAA[1])and(EMAA[1]<=EMAA[2])
trans_range_1=high[1]-low[1]
trans_pavio_sup_1=high[1]-max(open[1],close[1])
trans_pavio_inf_1=min(open[1],close[1])-low[1]
trans_pavio_sup_pct_1=(trans_range_1>0)and(trans_pavio_sup_1/trans_range_1*100)or 0
trans_pavio_inf_pct_1=(trans_range_1>0)and(trans_pavio_inf_1/trans_range_1*100)or 0
trans_reacao_alta_1=((close[1]>open[1])or(trans_pavio_inf_pct_1>=tonumber(transicao_pavio_pct_txt)))and((low[1]>=low[2])or(close[1]>close[2]))
trans_reacao_baixa_1=((close[1]<open[1])or(trans_pavio_sup_pct_1>=tonumber(transicao_pavio_pct_txt)))and((high[1]<=high[2])or(close[1]<close[2]))
trans_base=(range_1+range_2+range_3+range_4+range_5)/5
trans_buffer=trans_base*tonumber(transicao_buffer_pct_txt)/100
trans_topo_2=max(high[1],high[2])
trans_fundo_2=min(low[1],low[2])
transicao_baixa_para_alta=regime_baixa_fechado and trans_reacao_alta_1 and(close>=trans_fundo_2-trans_buffer)
transicao_alta_para_baixa=regime_alta_fechado and trans_reacao_baixa_1 and(close<=trans_topo_2+trans_buffer)
transicao_freia_venda=transicao_baixa_para_alta
transicao_freia_compra=transicao_alta_para_baixa
input_group{ "S8 - Ajuste fino de fluxo", s8_fluxo_eficiencia_txt=input{default="18",type=input.string}, s8_ponta_mult_txt=input{default="4.5",type=input.string}, s8_ponta_corpo_txt=input{default="70",type=input.string}, s8_ponta_pavio_txt=input{default="30",type=input.string} }
dir_1=(close[1]>open[1])and 1 or((close[1]<open[1])and-1 or 0)
dir_2=(close[2]>open[2])and 1 or((close[2]<open[2])and-1 or 0)
dir_3=(close[3]>open[3])and 1 or((close[3]<open[3])and-1 or 0)
dir_4=(close[4]>open[4])and 1 or((close[4]<open[4])and-1 or 0)
dir_5=(close[5]>open[5])and 1 or((close[5]<open[5])and-1 or 0)
troca_12=(dir_1~=0)and(dir_2~=0)and(dir_1~=dir_2)and 1 or 0
troca_23=(dir_2~=0)and(dir_3~=0)and(dir_2~=dir_3)and 1 or 0
troca_34=(dir_3~=0)and(dir_4~=0)and(dir_3~=dir_4)and 1 or 0
troca_45=(dir_4~=0)and(dir_5~=0)and(dir_4~=dir_5)and 1 or 0
alternancias_5=troca_12+troca_23+troca_34+troca_45
movimento_fluxo_6=range_atual+range_1+range_2+range_3+range_4+range_5
progresso_fluxo_6=abs(close-close[5])
eficiencia_fluxo_6=(movimento_fluxo_6>0)and(progresso_fluxo_6/movimento_fluxo_6*100)or 100
falso_fluxo_s8=(alternancias_5>=3)and(eficiencia_fluxo_6<tonumber(s8_fluxo_eficiencia_txt))
media_range_s8=(range_1+range_2+range_3+range_4+range_5)/5
distancia_s8=abs(close-close[5])
perna_forte_s8=(media_range_s8>0)and(distancia_s8>=media_range_s8*tonumber(s8_ponta_mult_txt))
corpo_rel_s8=(media_range_s8>0)and(corpo_atual/media_range_s8*100)or 100
perdeu_corpo_s8=corpo_rel_s8<tonumber(s8_ponta_corpo_txt)
rejeita_compra_s8=pavio_superior_pct>=tonumber(s8_ponta_pavio_txt)
rejeita_venda_s8=pavio_inferior_pct>=tonumber(s8_ponta_pavio_txt)
ponta_compra_s8=perna_forte_s8 and perto_resistencia and(perdeu_corpo_s8 or rejeita_compra_s8)
ponta_venda_s8=perna_forte_s8 and perto_suporte and(perdeu_corpo_s8 or rejeita_venda_s8)
s9lite_alta_madura=regime_alta_fechado and perna_forte_s8 and perto_resistencia
s9lite_baixa_madura=regime_baixa_fechado and perna_forte_s8 and perto_suporte
s9lite_pausa_alta=(close[1]<=close[2]+media_range_s8*0.18)or rejeita_compra_s8
s9lite_pausa_baixa=(close[1]>=close[2]-media_range_s8*0.18)or rejeita_venda_s8
s9lite_retomou_alta=close>high[1]and close>open and corpo_atual>media_range_s8*0.40
s9lite_retomou_baixa=close<low[1]and close<open and corpo_atual>media_range_s8*0.40
s9lite_bloqueia_compra=s9lite_alta_madura and s9lite_pausa_alta and(not s9lite_retomou_alta)
s9lite_bloqueia_venda=s9lite_baixa_madura and s9lite_pausa_baixa and(not s9lite_retomou_baixa)
f9_margem_extremo=media_range_s8*0.30
f9_topo_fechado=highest(high[1],doch_time)
f9_fundo_fechado=lowest(low[1],doch_time)
f9_topo_repetido=((f9_topo_fechado-high[1])<=f9_margem_extremo)and((f9_topo_fechado-high[2])<=f9_margem_extremo)
f9_fundo_repetido=((low[1]-f9_fundo_fechado)<=f9_margem_extremo)and((low[2]-f9_fundo_fechado)<=f9_margem_extremo)
f9_sem_avanco_alta=close[1]<=close[2]+media_range_s8*0.18
f9_sem_avanco_baixa=close[1]>=close[2]-media_range_s8*0.18
f9_rompeu_topo=close>high[1]and close>open and corpo_atual>media_range_s8*0.40
f9_rompeu_fundo=close<low[1]and close<open and corpo_atual>media_range_s8*0.40
f9_bloqueia_compra=regime_alta_fechado and perto_resistencia and f9_topo_repetido and f9_sem_avanco_alta and(not f9_rompeu_topo)
f9_bloqueia_venda=regime_baixa_fechado and perto_suporte and f9_fundo_repetido and f9_sem_avanco_baixa and(not f9_rompeu_fundo)
v2_EMAA=ema(close,10)
v2_range_1=high[1]-low[1]
v2_range_2=high[2]-low[2]
v2_range_3=high[3]-low[3]
v2_range_4=high[4]-low[4]
v2_range_5=high[5]-low[5]
v2_range_medio=(v2_range_1+v2_range_2+v2_range_3+v2_range_4+v2_range_5)/5
v2_corpo_1=abs(close[1]-open[1])
v2_pavio_sup_1=high[1]-max(open[1],close[1])
v2_pavio_inf_1=min(open[1],close[1])-low[1]
v2_alta=close[1]>v2_EMAA[1]and v2_EMAA[1]>v2_EMAA[2]
v2_baixa=close[1]<v2_EMAA[1]and v2_EMAA[1]<v2_EMAA[2]
v2_sobreposicao_3=max(low[1],max(low[2],low[3]))<=min(high[1],min(high[2],high[3]))
v2_deslocamento_3=abs(close[1]-close[3])
v2_ema_plana=abs(v2_EMAA[1]-v2_EMAA[3])<v2_range_medio*0.25
v2_lateral=v2_sobreposicao_3 and v2_deslocamento_3<v2_range_medio*0.70 and v2_ema_plana
local v2_perna=make_series()
local v2_inicio_perna=make_series()
v2_perna:set(nz(v2_perna[1],0))
v2_inicio_perna:set(nz(v2_inicio_perna[1],close[1]))
if v2_lateral then
v2_perna:set(0)
elseif v2_alta and get_value(v2_perna)~=1 then
v2_perna:set(1)
v2_inicio_perna:set(low[1])
elseif v2_baixa and get_value(v2_perna)~=-1 then
v2_perna:set(-1)
v2_inicio_perna:set(high[1])
end
local v2_ultimo_topo=make_series()
local v2_ultimo_fundo=make_series()
local v2_bloqueia_compra=make_series()
local v2_bloqueia_venda=make_series()
local v7_ultimo_fim=make_series()
v2_ultimo_topo:set(nz(v2_ultimo_topo[1],high[1]))
v2_ultimo_fundo:set(nz(v2_ultimo_fundo[1],low[1]))
v2_bloqueia_compra:set(nz(v2_bloqueia_compra[1],0))
v2_bloqueia_venda:set(nz(v2_bloqueia_venda[1],0))
v7_ultimo_fim:set(nz(v7_ultimo_fim[1],0))
v7_topo_local=high[2]>=high[3] and high[2]>high[1]
v7_fundo_local=low[2]<=low[3] and low[2]<low[1]
v7_chegada_topo=close[2]>close[4] or high[2]-low[4]>=v2_range_medio*1.10
v7_chegada_fundo=close[2]<close[4] or high[4]-low[2]>=v2_range_medio*1.10
v7_perdeu_alta=close[1]<close[2] or low[1]<low[2]
v7_perdeu_baixa=close[1]>close[2] or high[1]>high[2]
v2_topo_provavel=v7_topo_local and v7_chegada_topo and v7_perdeu_alta
v2_fundo_provavel=v7_fundo_local and v7_chegada_fundo and v7_perdeu_baixa
v2_rompimento_topo=v2_alta and close[1]>get_value(v2_ultimo_topo)+v2_range_medio*0.15 and v2_corpo_1>=v2_range_medio*0.35 and v2_pavio_sup_1<v2_range_1*0.40
v2_rompimento_fundo=v2_baixa and close[1]<get_value(v2_ultimo_fundo)-v2_range_medio*0.15 and v2_corpo_1>=v2_range_medio*0.35 and v2_pavio_inf_1<v2_range_1*0.40
v2_nova_perna_baixa=v2_baixa and close[1]<close[2] and low[1]<low[2]
v2_nova_perna_alta=v2_alta and close[1]>close[2] and high[1]>high[2]
v2_rearme_compra=get_value(v2_bloqueia_compra)==1 and(v2_rompimento_topo or v2_nova_perna_baixa)
v2_rearme_venda=get_value(v2_bloqueia_venda)==1 and(v2_rompimento_fundo or v2_nova_perna_alta)
v2_topo_evento=v2_topo_provavel and get_value(v2_bloqueia_compra)==0 and get_value(v7_ultimo_fim)~=1
v2_fundo_evento=v2_fundo_provavel and get_value(v2_bloqueia_venda)==0 and get_value(v7_ultimo_fim)~=-1
if v2_topo_evento then
v2_ultimo_topo:set(high[2])
v2_bloqueia_compra:set(1)
v2_bloqueia_venda:set(0)
v7_ultimo_fim:set(1)
elseif v2_rearme_compra then
v2_bloqueia_compra:set(0)
v2_inicio_perna:set(low[1])
end
if v2_fundo_evento then
v2_ultimo_fundo:set(low[2])
v2_bloqueia_venda:set(1)
v2_bloqueia_compra:set(0)
v7_ultimo_fim:set(-1)
elseif v2_rearme_venda then
v2_bloqueia_venda:set(0)
v2_inicio_perna:set(high[1])
end
sinal_compra=TA and(not lateralizado)and(not lateralizado_curto)and(corpo_atual>media_range_15*forca_min)and(not perna_esticada)and(not freio_pos_compra)and(not falso_fluxo_s8)and(not ponta_compra_s8)and(not s9lite_bloqueia_compra)and(not f9_bloqueia_compra)
sinal_venda=TB and(not lateralizado)and(not lateralizado_curto)and(corpo_atual>media_range_15*forca_min)and(not perna_esticada)and(not freio_pos_venda)and(not falso_fluxo_s8)and(not ponta_venda_s8)and(not s9lite_bloqueia_venda)and(not f9_bloqueia_venda)
f9h_base=(range_1+range_2+range_3+range_4+range_5)/5
cpH=(range_atual>0)and(corpo_atual/range_atual*100)or 0
tpH=max(high[1],max(high[2],high[3]))
fpH=min(low[1],min(low[2],low[3]))
f9h_perna_alta=regime_alta_fechado and(f9h_base>0)and((close[1]-close[6])>=f9h_base*1.50)
f9h_perna_baixa=regime_baixa_fechado and(f9h_base>0)and((close[6]-close[1])>=f9h_base*1.50)
f9h_ext_fraca_topo=(high>=tpH)and((high-tpH)<=f9h_base*0.20)
f9h_ext_fraca_fundo=(low<=fpH)and((fpH-low)<=f9h_base*0.20)
f9h_falha_topo=(high[1]>=max(high[2],high[3]))and(high<=high[1]+f9h_base*0.05)
f9h_falha_fundo=(low[1]<=min(low[2],low[3]))and(low>=low[1]-f9h_base*0.05)
f9h_run_up=(close>tpH+f9h_base*0.05)and(close>open)and(cpH>=55)and(pavio_superior_pct<=30)
f9h_run_dn=(close<fpH-f9h_base*0.05)and(close<open)and(cpH>=55)and(pavio_inferior_pct<=30)
f9h_raw_sell=f9h_perna_alta and perto_resistencia and(f9h_ext_fraca_topo or f9h_falha_topo)and(not f9h_run_up)
f9h_raw_buy=f9h_perna_baixa and perto_suporte and(f9h_ext_fraca_fundo or f9h_falha_fundo)and(not f9h_run_dn)
f9h_hsell=f9h_raw_sell
f9h_hbuy=f9h_raw_buy
hmS=false; hmB=false
s5=security(current_ticker_id,"5s")
if s5 then
local mt=get_value(open_time); local b=get_value(f9h_base); local tp=get_value(tpH); local fp=get_value(fpH)
local h1=get_value(high[1]); local l1=get_value(low[1]); local h23=get_value(max(high[2],high[3])); local l23=get_value(min(low[2],low[3]))
for i=11,1,-1 do
local t5=get_value(s5.open_time[i])
if t5 and t5>=mt then
local o=get_value(s5.open[i]); local c=get_value(s5.close[i]); local h=get_value(s5.high[i]); local l=get_value(s5.low[i])
if o and c and h and l and b and b>0 then
local r=h-l; local cp=(r>0)and(abs(c-o)/r*100)or 0; local ps=(r>0)and((h-max(o,c))/r*100)or 0; local pi=(r>0)and((min(o,c)-l)/r*100)or 0
local hs=f9h_perna_alta and perto_resistencia and(((h>=tp)and((h-tp)<=b*0.20))or((h1>=h23)and(h<=h1+b*0.05)))and(not((c>tp+b*0.05)and(c>o)and(cp>=55)and(ps<=30)))
local hb=f9h_perna_baixa and perto_suporte and(((l<=fp)and((fp-l)<=b*0.20))or((l1<=l23)and(l>=l1-b*0.05)))and(not((c<fp-b*0.05)and(c<o)and(cp>=55)and(pi<=30)))
if hs then hmS=true end
if hb then hmB=true end
end
end
end
end
if f9h_hsell then hmS=true end
if f9h_hbuy then hmB=true end
rvV=hmS and(not hmB)and(((close<open)and(close<low[1])and(corpo_atual>=f9h_base*0.40)and(pavio_inferior_pct<=40))or((close[1]<open[1])and(close<open)and(close<close[1])and(low<low[1])and(corpo_atual>=f9h_base*0.22)))
rvC=hmB and(not hmS)and(((close>open)and(close>high[1])and(corpo_atual>=f9h_base*0.40)and(pavio_superior_pct<=40))or((close[1]>open[1])and(close>open)and(close>close[1])and(high>high[1])and(corpo_atual>=f9h_base*0.22)))
cT=(range_atual>0)and((high-close)/range_atual*100)or 100; cB=(range_atual>0)and((close-low)/range_atual*100)or 100
ov3=v2_sobreposicao_3 and(v2_deslocamento_3<v2_range_medio*0.70)
paC=(close>close[1])and(high>high[1])and(close>open)and(cpH>=35)and(cT<=40)and(pavio_superior_pct<=45)and(not(ov3 and corpo_atual<media_range_s8*0.45))
paV=(close<close[1])and(low<low[1])and(close<open)and(cpH>=35)and(cB<=40)and(pavio_inferior_pct<=45)and(not(ov3 and corpo_atual<media_range_s8*0.45))
okC=(not hmS)and(((not transicao_freia_compra)and(not aviso_extremo_compra))or paC)
okV=(not hmB)and(((not transicao_freia_venda)and(not aviso_extremo_venda))or paV)
sinal_compra_final=(sinal_compra and get_value(v2_bloqueia_compra)==0 and okC)or(rvC and get_value(v2_bloqueia_compra)==0)
sinal_venda_final=(sinal_venda and get_value(v2_bloqueia_venda)==0 and okV)or(rvV and get_value(v2_bloqueia_venda)==0)
input_group{ "S9 - Alerta de topo/fundo repetido", s9_extremo_pct_txt=input{default="30",type=input.string}, s9_progresso_pct_txt=input{default="18",type=input.string} }
s9_base=(range_1+range_2+range_3+range_4+range_5)/5
s9_margem=s9_base*tonumber(s9_extremo_pct_txt)/100
s9_progresso=s9_base*tonumber(s9_progresso_pct_txt)/100
s9_topo_fechado=highest(high[1],doch_time)
s9_fundo_fechado=lowest(low[1],doch_time)
s9_2_topo=((s9_topo_fechado-high[1])<=s9_margem)and((s9_topo_fechado-high[2])<=s9_margem)
s9_2_fundo=((low[1]-s9_fundo_fechado)<=s9_margem)and((low[2]-s9_fundo_fechado)<=s9_margem)
s9_sem_avanco_alta=close[1]<=close[2]+s9_progresso
s9_sem_avanco_baixa=close[1]>=close[2]-s9_progresso
s9_alerta_topo_compra=regime_alta_fechado and s9_2_topo and s9_sem_avanco_alta and perto_resistencia
s9_alerta_fundo_venda=regime_baixa_fechado and s9_2_fundo and s9_sem_avanco_baixa and perto_suporte
input_group{"S10 Caixa",s10_caixa_color=input{default="#B388FF",type=input.color}}
s10_caixa_h=upper-lower
s10_par=(dir_1==dir_2)and(dir_3==dir_4)and(dir_1~=0)and(dir_3~=0)and(dir_1~=dir_3)
s10_caixa=(lateralizado or lateralizado_curto or falso_fluxo_s8 or s10_par or(eficiencia<18))and(s10_caixa_h>=media_range*2.2)and(s10_caixa_h<=media_range_15*6)and(close<=upper+media_range*0.12)and(close>=lower-media_range*0.12)and(not micro_vela_atual_fraca)and(range_atual>=media_range*0.80)
s10_teto=perto_resistencia or((upper-close)<=media_range*0.38)
s10_piso=perto_suporte or((close-lower)<=media_range*0.38)
s10_rompe_up=(close>upper)and(close>open)and(cpH>=55)and(pavio_superior_pct<=30)
s10_rompe_dn=(close<lower)and(close<open)and(cpH>=55)and(pavio_inferior_pct<=30)
s10_upthrust=(high>upper)and(close<=upper)and((close<=open)or(pavio_superior_pct>=30))
s10_spring=(low<lower)and(close>=lower)and((close>=open)or(pavio_inferior_pct>=30))
s10_fade_v=s10_teto and(not s10_rompe_up)and((close>open)or(pavio_superior_pct>=30)or s9_2_topo)
s10_fade_c=s10_piso and(not s10_rompe_dn)and((close<open)or(pavio_inferior_pct>=30)or s9_2_fundo)
local s10_wait=make_series()
s10_wait:set(nz(s10_wait[1],0))
s10_livre=get_value(s10_wait)<=0
s10_venda=s10_livre and s10_caixa and(not s10_rompe_up)and(s10_upthrust or s10_fade_v)and(not sinal_venda_final)
s10_compra=s10_livre and s10_caixa and(not s10_rompe_dn)and(s10_spring or s10_fade_c)and(not sinal_compra_final)
if s10_compra or s10_venda then
s10_wait:set(3)
else
s10_wait:set((get_value(s10_wait)>0)and(get_value(s10_wait)-1)or 0)
end
input_group{"UP - UP COLOR",call_color=input{default="#00FF00",type=input.color}}
input_group{"DOWN - DOWN COLOR",put_color=input{default="#FF2A00",type=input.color}}
input_group{"F11 V6 - Vela H",f11_l_color=input{default="#FF9800",type=input.color}}
hVis=hmS or hmB
if hVis then
plot_candle(open,high,low,close,"F11_L",f11_l_color)
end
if hmS then
plot_shape(1,'F9H_HSELL',shape_style.arrowdown,shape_size.large,f11_l_color,shape_location.abovebar,0,"H","#FFFFFF")
elseif hmB then
plot_shape(1,'F9H_HBUY',shape_style.arrowup,shape_size.large,f11_l_color,shape_location.belowbar,0,"H","#FFFFFF")
end
if v2_topo_evento then
plot_shape(1,'V2_TOPO_BLOQUEIO',shape_style.circle,shape_size.large,"#FFFF00",shape_location.abovebar,-2,"FIM COMPRA","#FFFF00")
elseif v2_fundo_evento then
plot_shape(1,'V2_FUNDO_BLOQUEIO',shape_style.circle,shape_size.large,"#00FFFF",shape_location.belowbar,-2,"FIM VENDA","#00FFFF")
end
if sinal_compra_final then
if micro_contexto_fraco_final or aviso_extremo_compra or transicao_freia_compra or s9_alerta_topo_compra then
plot_shape(1,'Bull_UP_FRACO',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"Compra","#fcfc04")
else
plot_shape(1,'Bull_UP',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"Compra","#fcfc04")
end
else
if sinal_venda_final then
if micro_contexto_fraco_final or aviso_extremo_venda or transicao_freia_venda or s9_alerta_fundo_venda then
plot_shape(1,'Bear_DOWN_FRACO',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"Venda","#fcfc01")
else
plot_shape(1,'Bear_DOWN',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"Venda","#fcfc01")
end
end
end
if s10_compra then
plot_shape(1,'S10_CX_C',shape_style.diamond,shape_size.large,s10_caixa_color,shape_location.belowbar,0,"CX","#FFFFFF")
elseif s10_venda then
plot_shape(1,'S10_CX_V',shape_style.diamond,shape_size.large,s10_caixa_color,shape_location.abovebar,0,"CX","#FFFFFF")
end
method_id=input(1,"Type",input.string_selection,{"M1 "})
input_group{ "Maxima", level_1_color=input{default="#FF3EB5",type=input.color}, level_1_width=input{default=2,type=input.line_width} }
input_group{ "Minima", level_2_color=input{default="#FF3EB5",type=input.color}, level_2_width=input{default=2,type=input.line_width} }
local function m15(candle)
c1=candle.high
c2=candle.low
end
local methods={m15}
local resolution="15m"
sec=security(current_ticker_id,resolution)
if sec then
local method=methods[method_id]
method(sec)
plot(c1,"C1",level_1_color,level_1_width,0,style.levels,na_mode.continue)
plot(c2,"C2",level_2_color,level_2_width,0,style.levels,na_mode.continue)
end