instrument{name="F10 V11",icon="jpg",overlay=true}
input_group{"Periodo Max/Min",doch_time=input{default="10",type=input.string}}
input_group{"Periodo da Micro Tendencia",emaa_per=input{default="10",type=input.string}}
input_group{"Candles",
positivo=input{default="#39FF14",type=input.color},
negativo=input{default="#FF0000",type=input.color},
neutro=input{default="#FFFFFF",type=input.color}}
input_group{"Canal",
upline_color=input{default="#FF8C00",type=input.color},
lowline_color=input{default="#00FF66",type=input.color}}
EMAA=ema(close,emaa_per)
upper=highest(high,doch_time)
lower=lowest(low,doch_time)
TA=((close>close[1])and(close>EMAA)and(EMAA>EMAA[1]))
TB=((close<close[1])and(close<EMAA)and(EMAA<EMAA[1]))
input_group{"Qualidade Fixa do Sinal",
micro_eficiencia_txt=input{default="35",type=input.string},
micro_corpo_pct_txt=input{default="45",type=input.string},
micro_tamanho_pct_txt=input{default="60",type=input.string}}
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
micro_lateralizado_fixo=eficiencia_micro_fechada<tonumber(micro_eficiencia_txt)
micro_corpo_atual_pct=(range_atual>0)and(corpo_atual/range_atual*100)or 100
micro_vela_atual_fraca=(micro_corpo_atual_pct<tonumber(micro_corpo_pct_txt))and(media_micro_fechada>0)and(corpo_atual<media_micro_fechada*tonumber(micro_tamanho_pct_txt)/100)
bar_color=neutro
if(TA==true)then bar_color=positivo elseif(TB==true)then bar_color=negativo end
plot_candle(open,high,low,close,"ES",bar_color)
plot(upper,"Resistencia",upline_color)
plot(lower,"Suporte",lowline_color)
range_1=high[1]-low[1]
range_2=high[2]-low[2]
range_3=high[3]-low[3]
range_4=high[4]-low[4]
range_5=high[5]-low[5]
range_6=high[6]-low[6]
range_7=high[7]-low[7]
media_range=(range_atual+range_1+range_2+range_3)/4
range_8=high[8]-low[8]
range_9=high[9]-low[9]
range_10=high[10]-low[10]
range_11=high[11]-low[11]
range_12=high[12]-low[12]
range_13=high[13]-low[13]
range_14=high[14]-low[14]
media_range_15=(range_atual+range_1+range_2+range_3+range_4+range_5+range_6+range_7+range_8+range_9+range_10+range_11+range_12+range_13+range_14)/15
input_group{"Lateralizacao e Forca Minima",
eficiencia_min_txt=input{default="12",type=input.string},
forca_min_txt=input{default="20",type=input.string}}
progresso_liquido=abs(close-close[7])
movimento_total=range_atual+range_1+range_2+range_3+range_4+range_5+range_6+range_7
eficiencia=(movimento_total>0)and(progresso_liquido/movimento_total*100)or 100
lateralizado=eficiencia<tonumber(eficiencia_min_txt)
forca_min=tonumber(forca_min_txt)/100
input_group{"Lateralizacao rapida",eficiencia_curta_min_txt=input{default="8",type=input.string}}
progresso_liquido_curto=abs(close-close[3])
movimento_total_curto=range_atual+range_1+range_2+range_3
eficiencia_curta=(movimento_total_curto>0)and(progresso_liquido_curto/movimento_total_curto*100)or 100
lateralizado_curto=eficiencia_curta<tonumber(eficiencia_curta_min_txt)
micro_contexto_fraco_final=micro_vela_atual_fraca
input_group{"Exaustao de perna",exaustao_limiar_txt=input{default="25",type=input.string}}
distancia_perna=abs(close-close[15])
perna_esticada=(media_range>0)and(distancia_perna>media_range*tonumber(exaustao_limiar_txt))or false
input_group{"Freio pos-impulso S6",
pos_impulso_range_pct_txt=input{default="120",type=input.string},
pos_impulso_corpo_pct_txt=input{default="55",type=input.string},
pos_impulso_proximidade_txt=input{default="25",type=input.string},
pos_impulso_break_corpo_txt=input{default="20",type=input.string},
pos_impulso_break_margem_txt=input{default="0",type=input.string}}
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
input_group{"Aviso de Extremo",
extremo_pavio_pct_txt=input{default="35",type=input.string},
extremo_proximidade_txt=input{default="30",type=input.string},
extremo_corpo_media_txt=input{default="85",type=input.string}}
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
input_group{"S6 Transicao",
transicao_pavio_pct_txt=input{default="30",type=input.string},
transicao_buffer_pct_txt=input{default="4",type=input.string}}
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
input_group{"S8 Fluxo",
s8_fluxo_eficiencia_txt=input{default="18",type=input.string},
s8_ponta_mult_txt=input{default="4.5",type=input.string},
s8_ponta_corpo_txt=input{default="70",type=input.string},
s8_ponta_pavio_txt=input{default="30",type=input.string}}
dir_1=(close[1]>open[1])and 1 or((close[1]<open[1])and -1 or 0)
dir_2=(close[2]>open[2])and 1 or((close[2]<open[2])and -1 or 0)
dir_3=(close[3]>open[3])and 1 or((close[3]<open[3])and -1 or 0)
dir_4=(close[4]>open[4])and 1 or((close[4]<open[4])and -1 or 0)
dir_5=(close[5]>open[5])and 1 or((close[5]<open[5])and -1 or 0)
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
f9_margem_extremo=media_range_s8*0.35
f9_topo_fechado=highest(high[1],doch_time)
f9_fundo_fechado=lowest(low[1],doch_time)
f9_ultima_no_topo=(f9_topo_fechado-high[1])<=f9_margem_extremo
f9_ultima_no_fundo=(low[1]-f9_fundo_fechado)<=f9_margem_extremo
f9_rompeu_topo=close>high[1]and close>open and corpo_atual>media_range_s8*0.40
f9_rompeu_fundo=close<low[1]and close<open and corpo_atual>media_range_s8*0.40
f9_bloqueia_compra=regime_alta_fechado and perto_resistencia and f9_ultima_no_topo and(not f9_rompeu_topo)
f9_bloqueia_venda=regime_baixa_fechado and perto_suporte and f9_ultima_no_fundo and(not f9_rompeu_fundo)
f9_reacao_fundo=(trans_reacao_alta_1 and f9_ultima_no_fundo)or(close[2]>open[2]and low[2]-lowest(low[2],doch_time)<=f9_margem_extremo)
f9_reacao_topo=(trans_reacao_baixa_1 and f9_ultima_no_topo)or(close[2]<open[2]and highest(high[2],doch_time)-high[2]<=f9_margem_extremo)
f9_bloqueia_reentrada_venda=regime_baixa_fechado and perto_suporte and f9_reacao_fundo and(not(close<lowest(low[1],3)and close<open and corpo_atual>media_range_s8*0.40))
f9_bloqueia_reentrada_compra=regime_alta_fechado and perto_resistencia and f9_reacao_topo and(not(close>highest(high[1],3)and close>open and corpo_atual>media_range_s8*0.40))
sinal_compra_base=TA and(not lateralizado)and(not lateralizado_curto)and(corpo_atual>media_range_15*forca_min)and(not perna_esticada)and(not freio_pos_compra)and(not falso_fluxo_s8)and(not ponta_compra_s8)and(not s9lite_bloqueia_compra)and(not f9_bloqueia_compra)and(not f9_bloqueia_reentrada_compra)
sinal_venda_base=TB and(not lateralizado)and(not lateralizado_curto)and(corpo_atual>media_range_15*forca_min)and(not perna_esticada)and(not freio_pos_venda)and(not falso_fluxo_s8)and(not ponta_venda_s8)and(not s9lite_bloqueia_venda)and(not f9_bloqueia_venda)and(not f9_bloqueia_reentrada_venda)
input_group{"Rearme apos inversao",
rearme_memoria_velas_txt=input{default="3",type=input.string},
rearme_quebra_corpo_pct_txt=input{default="25",type=input.string},
rearme_obs_cor=input{default="#8E24AA",type=input.color}}
local rearme_ultima_dir=make_series()
local rearme_hold_dir=make_series()
local rearme_hold_restante=make_series()
rearme_dir_anterior=nz(rearme_ultima_dir[1],0)
rearme_hold_anterior=nz(rearme_hold_dir[1],0)
rearme_restante_anterior=nz(rearme_hold_restante[1],0)
rearme_corpo_quebra=media_range_s8*tonumber(rearme_quebra_corpo_pct_txt)/100
rearme_quebra_para_venda=close<low[1]and close<open and corpo_atual>rearme_corpo_quebra and pavio_inferior_pct<40
rearme_quebra_para_compra=close>high[1]and close>open and corpo_atual>rearme_corpo_quebra and pavio_superior_pct<40
troca_antecipada_venda=(rearme_dir_anterior==1)and transicao_alta_para_baixa and TB and rearme_quebra_para_venda and(not falso_fluxo_s8)and(not perna_esticada)and(not freio_pos_venda)and(not ponta_venda_s8)and(not s9lite_bloqueia_venda)and(not f9_bloqueia_venda)and(not f9_bloqueia_reentrada_venda)
troca_antecipada_compra=(rearme_dir_anterior==-1)and transicao_baixa_para_alta and TA and rearme_quebra_para_compra and(not falso_fluxo_s8)and(not perna_esticada)and(not freio_pos_compra)and(not ponta_compra_s8)and(not s9lite_bloqueia_compra)and(not f9_bloqueia_compra)and(not f9_bloqueia_reentrada_compra)
candidato_compra=sinal_compra_base or troca_antecipada_compra
candidato_venda=sinal_venda_base or troca_antecipada_venda
rearme_bloqueia_venda=false
rearme_bloqueia_compra=false

-- F10 V4: rearme rapido condicionado.
-- Nao reduz a memoria de 3 velas. So abre excecao na 3a vela
-- quando a estrutura antiga voltou com eficiencia, sem quebrar
-- o descanso e longe do extremo/H.
rr_mov_fechado=range_1+range_2+range_3+range_4+range_5
rr_prog_up=close[1]-close[5]
rr_prog_dn=close[5]-close[1]
rr_eff_up=(rr_mov_fechado>0)and(rr_prog_up/rr_mov_fechado*100)or 0
rr_eff_dn=(rr_mov_fechado>0)and(rr_prog_dn/rr_mov_fechado*100)or 0
rr_eff_min=tonumber(s8_fluxo_eficiencia_txt)

rr_descanso_up=regime_alta_fechado and(close[1]>EMAA[1])and
              (low[1]>=min(low[2],low[3])-media_range_s8*0.10)and
              ((abs(close[1]-open[1])<=media_range_s8*0.65)or
               (close[1]<=close[2]+media_range_s8*0.20))

rr_descanso_dn=regime_baixa_fechado and(close[1]<EMAA[1])and
              (high[1]<=max(high[2],high[3])+media_range_s8*0.10)and
              ((abs(close[1]-open[1])<=media_range_s8*0.65)or
               (close[1]>=close[2]-media_range_s8*0.20))

rr_retomou_up=TA and(close>close[1]+media_range_s8*0.15)and
              (corpo_atual>=media_range_s8*0.25)and(pavio_superior_pct<45)

rr_retomou_dn=TB and(close<close[1]-media_range_s8*0.15)and
              (corpo_atual>=media_range_s8*0.25)and(pavio_inferior_pct<45)

rr_longe_topo=(not f9_ultima_no_topo)and(not s9lite_alta_madura)and(not aviso_extremo_compra)
rr_longe_fundo=(not f9_ultima_no_fundo)and(not s9lite_baixa_madura)and(not aviso_extremo_venda)

rearme_rapido_compra=(rearme_restante_anterior==1)and(rearme_hold_anterior==-1)and
                     candidato_compra and(rr_eff_up>=rr_eff_min)and(alternancias_5<=2)and
                     rr_descanso_up and rr_retomou_up and rr_longe_topo and
                     (not falso_fluxo_s8)and(not perna_esticada)

rearme_rapido_venda=(rearme_restante_anterior==1)and(rearme_hold_anterior==1)and
                    candidato_venda and(rr_eff_dn>=rr_eff_min)and(alternancias_5<=2)and
                    rr_descanso_dn and rr_retomou_dn and rr_longe_fundo and
                    (not falso_fluxo_s8)and(not perna_esticada)

if rearme_restante_anterior>0 then
if(rearme_hold_anterior==1)and candidato_venda and(not rearme_quebra_para_venda)and(not rearme_rapido_venda)then
rearme_bloqueia_venda=true
elseif(rearme_hold_anterior==-1)and candidato_compra and(not rearme_quebra_para_compra)and(not rearme_rapido_compra)then
rearme_bloqueia_compra=true
end
end
sinal_compra=candidato_compra and(not rearme_bloqueia_compra)
sinal_venda=candidato_venda and(not rearme_bloqueia_venda)
micro_caixote=micro_lateralizado_fixo and(eficiencia_curta<18)and(not perna_forte_s8)
cx_libera_compra=s9lite_retomou_alta and regime_alta_fechado and TA
cx_libera_venda=s9lite_retomou_baixa and regime_baixa_fechado and TB
sinal_compra=sinal_compra and((not micro_caixote)or cx_libera_compra)
sinal_venda=sinal_venda and((not micro_caixote)or cx_libera_venda)
cont_compra=(not sinal_compra)and(not micro_caixote)and cx_libera_compra and(not falso_fluxo_s8)and(not perna_esticada)and(not freio_pos_compra)and(not ponta_compra_s8)and(not f9_bloqueia_compra)
cont_venda=(not sinal_venda)and(not micro_caixote)and cx_libera_venda and(not falso_fluxo_s8)and(not perna_esticada)and(not freio_pos_venda)and(not ponta_venda_s8)and(not f9_bloqueia_venda)
sinal_compra=sinal_compra or cont_compra
sinal_venda=sinal_venda or cont_venda
hb=(range_1+range_2+range_3+range_4+range_5)/5
hc=(range_atual>0)and(corpo_atual/range_atual*100)or 0
ht=max(high[1],max(high[2],high[3]))
hf=min(low[1],min(low[2],low[3]))
hpa=(hb>0)and((close[1]-close[6])>=hb*1.50)and(close[1]>close[3])
hpb=(hb>0)and((close[6]-close[1])>=hb*1.50)and(close[1]<close[3])
hes=(high>=ht)and((high-ht)<=hb*0.20)
heb=(low<=hf)and((hf-low)<=hb*0.20)
hfs=(high[1]>=max(high[2],high[3]))and(high<=high[1]+hb*0.05)
hfb=(low[1]<=min(low[2],low[3]))and(low>=low[1]-hb*0.05)
hru=(close>ht+hb*0.05)and(close>open)and(hc>=55)and(pavio_superior_pct<=30)
hrd=(close<hf-hb*0.05)and(close<open)and(hc>=55)and(pavio_inferior_pct<=30)
hps=(close<=close[1]+hb*0.08)or(pavio_superior_pct>=30)or(hc<45)
hpbx=(close>=close[1]-hb*0.08)or(pavio_inferior_pct>=30)or(hc<45)
hrs=hpa and perto_resistencia and(hes or hfs)and hps and(not hru)
hrb=hpb and perto_suporte and(heb or hfb)and hpbx and(not hrd)
local hl=make_series()
local htl=make_series()
local hfl=make_series()
local hage=make_series()
hl:set(nz(hl[1],0))
htl:set(nz(htl[1],ht))
hfl:set(nz(hfl[1],hf))
hage:set(nz(hage[1],0))
h0=nz(hl[1],0)
ha0=nz(hage[1],0)
hs=hrs and(h0~=1)
hy=hrb and(h0~=-1)
hbu=(h0==1)and(close>get_value(htl)+hb*0.15)and(close>open)and(corpo_atual>=hb*0.40)and(pavio_superior_pct<40)
hbd=(h0==-1)and(close<get_value(hfl)-hb*0.15)and(close<open)and(corpo_atual>=hb*0.40)and(pavio_inferior_pct<40)
if hs then htl:set(max(high,high[1]));hl:set(1);hage:set(0) elseif hy then hfl:set(min(low,low[1]));hl:set(-1);hage:set(0) elseif hbu or hbd then hl:set(0);hage:set(0) elseif h0~=0 then if ha0>=2 then hl:set(0);hage:set(0) else hage:set(ha0+1) end else hage:set(0) end
sinal_compra=sinal_compra and(not(((h0==1)and(not hbu))or hs))
sinal_venda=sinal_venda and(not(((h0==-1)and(not hbd))or hy))
dr=high[1]-low[1]
dc=abs(close[1]-open[1])
ds=high[1]-max(open[1],close[1])
di=min(open[1],close[1])-low[1]
dj=(dr>0)and(dc/dr<=.12)and(ds>0)and(di>0)and(ds<=di*1.8)and(di<=ds*1.8)
sinal_compra=sinal_compra and(not dj)
sinal_venda=sinal_venda and(not dj)
fim_perna_compra=regime_alta_fechado and perto_resistencia and(pavio_superior_pct>=22)and(not(close>high[1]and close>open and corpo_atual>media_range_s8*0.40))
fim_perna_venda=regime_baixa_fechado and perto_suporte and(pavio_inferior_pct>=22)and(not(close<low[1]and close<open and corpo_atual>media_range_s8*0.40))
pavio_dominante_compra=(range_atual>0)and(pavio_superior_pct>=25)and(pavio_superior_atual>=pavio_inferior_atual*1.3)
pavio_dominante_venda=(range_atual>0)and(pavio_inferior_pct>=25)and(pavio_inferior_atual>=pavio_superior_atual*1.3)
preco_virou_contra_venda=(rearme_dir_anterior==-1)and(close>close[3])and(close>EMAA)
preco_virou_contra_compra=(rearme_dir_anterior==1)and(close<close[3])and(close<EMAA)
sinal_compra=sinal_compra and(not fim_perna_compra)and(not pavio_dominante_compra)and(not preco_virou_contra_compra)
sinal_venda=sinal_venda and(not fim_perna_venda)and(not pavio_dominante_venda)and(not preco_virou_contra_venda)
-- TRAVA DA PRIMEIRA DIRECAO DA M1, SEM SECURITY DE 1S.
-- A primeira direcao valida fica fixa ate o fechamento da vela.
ot=get_value(open_time,0)
if sb~=ot then sb=ot;sd=0;hm=0 end
if sd==0 then
if sinal_compra and(not sinal_venda)then sd=1
elseif sinal_venda and(not sinal_compra)then sd=-1 end
end
sinal_compra=sd==1
sinal_venda=sd==-1
-- H visual persistente na vela: apareceu, permanece desenhado ate fechar.
if hm==0 then
if hs then hm=1 elseif hy then hm=-1 end
end
rearme_dir_atual=rearme_dir_anterior
if sinal_compra then
rearme_dir_atual=1
elseif sinal_venda then
rearme_dir_atual=-1
end
rearme_trocou=(rearme_dir_anterior~=0)and(rearme_dir_atual~=0)and(rearme_dir_atual~=rearme_dir_anterior)
if rearme_trocou then
rearme_hold_dir:set(rearme_dir_atual)
rearme_hold_restante:set(tonumber(rearme_memoria_velas_txt))
else
rearme_hold_dir:set(rearme_hold_anterior)
if rearme_restante_anterior>0 then
rearme_hold_restante:set(rearme_restante_anterior-1)
else
rearme_hold_restante:set(0)
end
end
rearme_ultima_dir:set(rearme_dir_atual)
input_group{"S9 Alerta",
s9_extremo_pct_txt=input{default="30",type=input.string},
s9_progresso_pct_txt=input{default="18",type=input.string}}
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
plot_shape(hm==1,"HS",shape_style.arrowdown,shape_size.large,"#FF9800",shape_location.abovebar,0,"H","#FFFFFF")
plot_shape(hm==-1,"HB",shape_style.arrowup,shape_size.large,"#00E5FF",shape_location.belowbar,0,"H","#FFFFFF")
input_group{"UP COLOR",call_color=input{default="#0bd104",type=input.color}}
input_group{"DOWN COLOR",put_color=input{default="#f70202",type=input.color}}
if sinal_compra then
if micro_contexto_fraco_final or aviso_extremo_compra or transicao_freia_compra or s9_alerta_topo_compra then
plot_shape(1,'Bull_UP_FRACO',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"Compra","#fcfc04")
else
plot_shape(1,'Bull_UP',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"Compra","#fcfc04")
end
elseif sinal_venda then
if micro_contexto_fraco_final or aviso_extremo_venda or transicao_freia_venda or s9_alerta_fundo_venda then
plot_shape(1,'Bear_DOWN_FRACO',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"Venda","#fcfc01")
else
plot_shape(1,'Bear_DOWN',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"Venda","#fcfc01")
end
end
method_id=input(1,"Type",input.string_selection,{"M1 "})
input_group{"Maxima",level_1_color=input{default="#FF3EB5",type=input.color},level_1_width=input{default=2,type=input.line_width}}
input_group{"Minima",level_2_color=input{default="#FF3EB5",type=input.color},level_2_width=input{default=2,type=input.line_width}}
local function m15(candle) c1=candle.high c2=candle.low end
sec=security(current_ticker_id,"15m")
if sec then local methods={m15} methods[method_id](sec) plot(c1,"C1",level_1_color,level_1_width,0,style.levels,na_mode.continue) plot(c2,"C2",level_2_color,level_2_width,0,style.levels,na_mode.continue) end
aviso_rearme_venda=rearme_bloqueia_venda
aviso_rearme_compra=rearme_bloqueia_compra
plot_shape(aviso_rearme_venda,"Rv",shape_style.diamond,shape_size.tiny,rearme_obs_cor,shape_location.abovebar,0,"R?",rearme_obs_cor)
plot_shape(aviso_rearme_compra,"Rc",shape_style.diamond,shape_size.tiny,rearme_obs_cor,shape_location.belowbar,0,"R?",rearme_obs_cor)