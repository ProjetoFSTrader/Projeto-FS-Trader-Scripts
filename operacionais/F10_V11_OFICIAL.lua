instrument{name="FS Trader F10 V11",icon="jpg",overlay=true}
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
co=abs(close-open)
ra=high-low
micro_range_1f=high[1]-low[1]
micro_range_2f=high[2]-low[2]
micro_range_3f=high[3]-low[3]
micro_range_4f=high[4]-low[4]
micro_range_5f=high[5]-low[5]
movimento_micro_fechado=micro_range_1f+micro_range_2f+micro_range_3f+micro_range_4f+micro_range_5f
mm5=movimento_micro_fechado/5
progresso_micro_fechado=abs(close[1]-close[5])
eficiencia_micro_fechada=(movimento_micro_fechado>0)and(progresso_micro_fechado/movimento_micro_fechado*100)or 100
mlat=eficiencia_micro_fechada<tonumber(micro_eficiencia_txt)
micro_corpo_atual_pct=(ra>0)and(co/ra*100)or 100
micro_vela_atual_fraca=(micro_corpo_atual_pct<tonumber(micro_corpo_pct_txt))and(mm5>0)and(co<mm5*tonumber(micro_tamanho_pct_txt)/100)
bar_color=neutro
if(TA==true)then bar_color=positivo elseif(TB==true)then bar_color=negativo end
plot_candle(open,high,low,close,"ES",bar_color)
plot(upper,"Resistencia",upline_color)
plot(lower,"Suporte",lowline_color)
r1=high[1]-low[1]
r2=high[2]-low[2]
r3=high[3]-low[3]
r4=high[4]-low[4]
r5=high[5]-low[5]
r6=high[6]-low[6]
r7=high[7]-low[7]
mr=(ra+r1+r2+r3)/4
r8=high[8]-low[8]
r9=high[9]-low[9]
r10=high[10]-low[10]
r11=high[11]-low[11]
r12=high[12]-low[12]
r13=high[13]-low[13]
r14=high[14]-low[14]
mr15=(ra+r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14)/15
input_group{"Lateralizacao e Forca Minima",
eficiencia_min_txt=input{default="12",type=input.string},
forca_min_txt=input{default="20",type=input.string}}
progresso_liquido=abs(close-close[7])
movimento_total=ra+r1+r2+r3+r4+r5+r6+r7
ef=(movimento_total>0)and(progresso_liquido/movimento_total*100)or 100
lat=ef<tonumber(eficiencia_min_txt)
forca_min=tonumber(forca_min_txt)/100
input_group{"Lateralizacao rapida",eficiencia_curta_min_txt=input{default="8",type=input.string}}
progresso_liquido_curto=abs(close-close[3])
movimento_total_curto=ra+r1+r2+r3
efc=(movimento_total_curto>0)and(progresso_liquido_curto/movimento_total_curto*100)or 100
latc=efc<tonumber(eficiencia_curta_min_txt)
mcf=micro_vela_atual_fraca
input_group{"Exaustao de perna",exaustao_limiar_txt=input{default="25",type=input.string}}
distancia_perna=abs(close-close[15])
est=(mr>0)and(distancia_perna>mr*tonumber(exaustao_limiar_txt))or false
input_group{"Freio pos-impulso S6",
pos_impulso_range_pct_txt=input{default="120",type=input.string},
pos_impulso_corpo_pct_txt=input{default="55",type=input.string},
pos_impulso_proximidade_txt=input{default="25",type=input.string},
pos_impulso_break_corpo_txt=input{default="20",type=input.string},
pos_impulso_break_margem_txt=input{default="0",type=input.string}}
m8=(r2+r3+r4+r5+r6+r7+r8+r9)/8
corpo_1_fechado=abs(close[1]-open[1])
corpo_1_pct=(r1>0)and(corpo_1_fechado/r1*100)or 0
limiar_range_impulso=m8*tonumber(pos_impulso_range_pct_txt)/100
impulso_alta_fechado=(m8>0)and(close[1]>open[1])and(r1>=limiar_range_impulso)and(corpo_1_pct>=tonumber(pos_impulso_corpo_pct_txt))
impulso_baixa_fechado=(m8>0)and(close[1]<open[1])and(r1>=limiar_range_impulso)and(corpo_1_pct>=tonumber(pos_impulso_corpo_pct_txt))
topo_fechado_pos=highest(high[1],doch_time)
fundo_fechado_pos=lowest(low[1],doch_time)
margem_pos_impulso=m8*tonumber(pos_impulso_proximidade_txt)/100
chegou_topo_pos=(topo_fechado_pos-high[1])<=margem_pos_impulso
chegou_fundo_pos=(low[1]-fundo_fechado_pos)<=margem_pos_impulso
margem_break_pos=m8*tonumber(pos_impulso_break_margem_txt)/100
corpo_break_pos=m8*tonumber(pos_impulso_break_corpo_txt)/100
rompimento_compra_pos=(close>topo_fechado_pos+margem_break_pos)and(close>open)and(co>=corpo_break_pos)
rompimento_venda_pos=(close<fundo_fechado_pos-margem_break_pos)and(close<open)and(co>=corpo_break_pos)
fc=impulso_alta_fechado and chegou_topo_pos and(not rompimento_compra_pos)
fv=impulso_baixa_fechado and chegou_fundo_pos and(not rompimento_venda_pos)
input_group{"Aviso de Extremo",
extremo_pavio_pct_txt=input{default="35",type=input.string},
extremo_proximidade_txt=input{default="30",type=input.string},
extremo_corpo_media_txt=input{default="85",type=input.string}}
ps=high-max(open,close)
pi=min(open,close)-low
psp=(ra>0)and(ps/ra*100)or 0
pip=(ra>0)and(pi/ra*100)or 0
margem_extremo=mr*tonumber(extremo_proximidade_txt)/100
pr=(upper-high)<=margem_extremo
pf=(low-lower)<=margem_extremo
corpo_curto_extremo=(mm5>0)and(co<=mm5*tonumber(extremo_corpo_media_txt)/100)
aeC=pr and corpo_curto_extremo and(psp>=tonumber(extremo_pavio_pct_txt))
aeV=pf and corpo_curto_extremo and(pip>=tonumber(extremo_pavio_pct_txt))
input_group{"S6 Transicao",
transicao_pavio_pct_txt=input{default="30",type=input.string},
transicao_buffer_pct_txt=input{default="4",type=input.string}}
rgA=(close[1]>EMAA[1])and(EMAA[1]>=EMAA[2])
rgB=(close[1]<EMAA[1])and(EMAA[1]<=EMAA[2])
trans_range_1=high[1]-low[1]
trans_pavio_sup_1=high[1]-max(open[1],close[1])
trans_pavio_inf_1=min(open[1],close[1])-low[1]
trans_pavio_sup_pct_1=(trans_range_1>0)and(trans_pavio_sup_1/trans_range_1*100)or 0
trans_pavio_inf_pct_1=(trans_range_1>0)and(trans_pavio_inf_1/trans_range_1*100)or 0
trans_reacao_alta_1=((close[1]>open[1])or(trans_pavio_inf_pct_1>=tonumber(transicao_pavio_pct_txt)))and((low[1]>=low[2])or(close[1]>close[2]))
trans_reacao_baixa_1=((close[1]<open[1])or(trans_pavio_sup_pct_1>=tonumber(transicao_pavio_pct_txt)))and((high[1]<=high[2])or(close[1]<close[2]))
trans_base=(r1+r2+r3+r4+r5)/5
trans_buffer=trans_base*tonumber(transicao_buffer_pct_txt)/100
trans_topo_2=max(high[1],high[2])
trans_fundo_2=min(low[1],low[2])
tBA=rgB and trans_reacao_alta_1 and(close>=trans_fundo_2-trans_buffer)
tAB=rgA and trans_reacao_baixa_1 and(close<=trans_topo_2+trans_buffer)
transicao_freia_venda=tBA
transicao_freia_compra=tAB
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
alt=troca_12+troca_23+troca_34+troca_45
movimento_fluxo_6=ra+r1+r2+r3+r4+r5
progresso_fluxo_6=abs(close-close[5])
eficiencia_fluxo_6=(movimento_fluxo_6>0)and(progresso_fluxo_6/movimento_fluxo_6*100)or 100
falso=(alt>=3)and(eficiencia_fluxo_6<tonumber(s8_fluxo_eficiencia_txt))
m5=(r1+r2+r3+r4+r5)/5
distancia_s8=abs(close-close[5])
pfs=(m5>0)and(distancia_s8>=m5*tonumber(s8_ponta_mult_txt))
corpo_rel_s8=(m5>0)and(co/m5*100)or 100
perdeu_corpo_s8=corpo_rel_s8<tonumber(s8_ponta_corpo_txt)
rejeita_compra_s8=psp>=tonumber(s8_ponta_pavio_txt)
rejeita_venda_s8=pip>=tonumber(s8_ponta_pavio_txt)
ptC=pfs and pr and(perdeu_corpo_s8 or rejeita_compra_s8)
ptV=pfs and pf and(perdeu_corpo_s8 or rejeita_venda_s8)
s9a=rgA and pfs and pr
s9b=rgB and pfs and pf
s9pa=(close[1]<=close[2]+m5*0.18)or rejeita_compra_s8
s9pb=(close[1]>=close[2]-m5*0.18)or rejeita_venda_s8
s9ra=close>high[1]and close>open and co>m5*0.40
s9rb=close<low[1]and close<open and co>m5*0.40
s9bc=s9a and s9pa and(not s9ra)
s9bv=s9b and s9pb and(not s9rb)
f9_margem_extremo=m5*0.35
f9_topo_fechado=highest(high[1],doch_time)
f9_fundo_fechado=lowest(low[1],doch_time)
f9ut=(f9_topo_fechado-high[1])<=f9_margem_extremo
f9uf=(low[1]-f9_fundo_fechado)<=f9_margem_extremo
f9_rompeu_topo=close>high[1]and close>open and co>m5*0.40
f9_rompeu_fundo=close<low[1]and close<open and co>m5*0.40
f9bC=rgA and pr and f9ut and(not f9_rompeu_topo)
f9bV=rgB and pf and f9uf and(not f9_rompeu_fundo)
f9_reacao_fundo=(trans_reacao_alta_1 and f9uf)or(close[2]>open[2]and low[2]-lowest(low[2],doch_time)<=f9_margem_extremo)
f9_reacao_topo=(trans_reacao_baixa_1 and f9ut)or(close[2]<open[2]and highest(high[2],doch_time)-high[2]<=f9_margem_extremo)
f9rV=rgB and pf and f9_reacao_fundo and(not(close<lowest(low[1],3)and close<open and co>m5*0.40))
f9rC=rgA and pr and f9_reacao_topo and(not(close>highest(high[1],3)and close>open and co>m5*0.40))
bC=TA and(not lat)and(not latc)and(co>mr15*forca_min)and(not est)and(not fc)and(not falso)and(not ptC)and(not s9bc)and(not f9bC)and(not f9rC)
bV=TB and(not lat)and(not latc)and(co>mr15*forca_min)and(not est)and(not fv)and(not falso)and(not ptV)and(not s9bv)and(not f9bV)and(not f9rV)
input_group{"Rearme apos inversao",
rearme_memoria_velas_txt=input{default="3",type=input.string},
rearme_quebra_corpo_pct_txt=input{default="25",type=input.string},
rearme_obs_cor=input{default="#8E24AA",type=input.color}}
local rearme_ultima_dir=make_series()
local rearme_hold_dir=make_series()
local rearme_hold_restante=make_series()
rd0=nz(rearme_ultima_dir[1],0)
rh0=nz(rearme_hold_dir[1],0)
rr0=nz(rearme_hold_restante[1],0)
rearme_corpo_quebra=m5*tonumber(rearme_quebra_corpo_pct_txt)/100
rqV=close<low[1]and close<open and co>rearme_corpo_quebra and pip<40
rqC=close>high[1]and close>open and co>rearme_corpo_quebra and psp<40
troca_antecipada_venda=(rd0==1)and tAB and TB and rqV and(not falso)and(not est)and(not fv)and(not ptV)and(not s9bv)and(not f9bV)and(not f9rV)
troca_antecipada_compra=(rd0==-1)and tBA and TA and rqC and(not falso)and(not est)and(not fc)and(not ptC)and(not s9bc)and(not f9bC)and(not f9rC)
cC=bC or troca_antecipada_compra
cV=bV or troca_antecipada_venda
rbV=false
rbC=false
rr_mov_fechado=r1+r2+r3+r4+r5
rr_prog_up=close[1]-close[5]
rr_prog_dn=close[5]-close[1]
rr_eff_up=(rr_mov_fechado>0)and(rr_prog_up/rr_mov_fechado*100)or 0
rr_eff_dn=(rr_mov_fechado>0)and(rr_prog_dn/rr_mov_fechado*100)or 0
rr_eff_min=tonumber(s8_fluxo_eficiencia_txt)
rr_descanso_up=rgA and(close[1]>EMAA[1])and
(low[1]>=min(low[2],low[3])-m5*0.10)and
((abs(close[1]-open[1])<=m5*0.65)or
(close[1]<=close[2]+m5*0.20))
rr_descanso_dn=rgB and(close[1]<EMAA[1])and
(high[1]<=max(high[2],high[3])+m5*0.10)and
((abs(close[1]-open[1])<=m5*0.65)or
(close[1]>=close[2]-m5*0.20))
rr_retomou_up=TA and(close>close[1]+m5*0.15)and
(co>=m5*0.25)and(psp<45)
rr_retomou_dn=TB and(close<close[1]-m5*0.15)and
(co>=m5*0.25)and(pip<45)
rr_longe_topo=(not f9ut)and(not s9a)and(not aeC)
rr_longe_fundo=(not f9uf)and(not s9b)and(not aeV)
rpC=(rr0==1)and(rh0==-1)and
cC and(rr_eff_up>=rr_eff_min)and(alt<=2)and
rr_descanso_up and rr_retomou_up and rr_longe_topo and
(not falso)and(not est)
rpV=(rr0==1)and(rh0==1)and
cV and(rr_eff_dn>=rr_eff_min)and(alt<=2)and
rr_descanso_dn and rr_retomou_dn and rr_longe_fundo and
(not falso)and(not est)
if rr0>0 then
if(rh0==1)and cV and(not rqV)and(not rpV)then
rbV=true
elseif(rh0==-1)and cC and(not rqC)and(not rpC)then
rbC=true
end
end
sC=cC and(not rbC)
sV=cV and(not rbV)
cx_f9_topo=highest(high[1],4)
cx_f9_fundo=lowest(low[1],4)
cx_f9_amp=cx_f9_topo-cx_f9_fundo
cx_f9_mov=r1+r2+r3+r4
cx_f9_ef=(cx_f9_mov>0)and(abs(close[1]-close[4])/cx_f9_mov*100)or 100
cx_f9=(m5>0)and(cx_f9_amp<=m5*2.10)and((alt>=2)or(cx_f9_ef<20))
cx_f9_rompe_compra=(close>cx_f9_topo)and(close>open)and(co>=m5*0.25)
cx_f9_rompe_venda=(close<cx_f9_fundo)and(close<open)and(co>=m5*0.25)
cont_compra=(not sC)and(not cx_f9)and(not rbC)and
TA and(not lat)and(not latc)and
(co>mr15*forca_min)and(not est)and
(not fc)and(not falso)and(not ptC)and
(not s9bc)
cont_venda=(not sV)and(not cx_f9)and(not rbV)and
TB and(not lat)and(not latc)and
(co>mr15*forca_min)and(not est)and
(not fv)and(not falso)and(not ptV)and
(not s9bv)
sC=sC or cont_compra
sV=sV or cont_venda
if cx_f9 then
sC=sC and cx_f9_rompe_compra
sV=sV and cx_f9_rompe_venda
end
hb=(r1+r2+r3+r4+r5)/5
hc=(ra>0)and(co/ra*100)or 0
ht=max(high[1],max(high[2],high[3]))
hf=min(low[1],min(low[2],low[3]))
hpa=(hb>0)and((close[1]-close[6])>=hb*1.50)and(close[1]>close[3])
hpb=(hb>0)and((close[6]-close[1])>=hb*1.50)and(close[1]<close[3])
hes=(high>=ht)and((high-ht)<=hb*0.20)
heb=(low<=hf)and((hf-low)<=hb*0.20)
hfs=(high[1]>=max(high[2],high[3]))and(high<=high[1]+hb*0.05)
hfb=(low[1]<=min(low[2],low[3]))and(low>=low[1]-hb*0.05)
hru=(close>ht+hb*0.05)and(close>open)and(hc>=55)and(psp<=30)
hrd=(close<hf-hb*0.05)and(close<open)and(hc>=55)and(pip<=30)
hps=(close<=close[1]+hb*0.08)or(psp>=30)or(hc<45)
hpbx=(close>=close[1]-hb*0.08)or(pip>=30)or(hc<45)
hrs=hpa and pr and(hes or hfs)and hps and(not hru)
hrb=hpb and pf and(heb or hfb)and hpbx and(not hrd)
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
hbu=(h0==1)and(close>get_value(htl)+hb*0.15)and(close>open)and(co>=hb*0.40)and(psp<40)
hbd=(h0==-1)and(close<get_value(hfl)-hb*0.15)and(close<open)and(co>=hb*0.40)and(pip<40)
if hs then htl:set(max(high,high[1]));hl:set(1);hage:set(0) elseif hy then hfl:set(min(low,low[1]));hl:set(-1);hage:set(0) elseif hbu or hbd then hl:set(0);hage:set(0) elseif h0~=0 then if ha0>=2 then hl:set(0);hage:set(0) else hage:set(ha0+1) end else hage:set(0) end
sC=sC and(not(((h0==1)and(not hbu))or hs))
sV=sV and(not(((h0==-1)and(not hbd))or hy))
dr=high[1]-low[1]
dc=abs(close[1]-open[1])
ds=high[1]-max(open[1],close[1])
di=min(open[1],close[1])-low[1]
dj=(dr>0)and(dc/dr<=.12)and(ds>0)and(di>0)and(ds<=di*1.8)and(di<=ds*1.8)
sC=sC and(not dj)
sV=sV and(not dj)
fim_perna_compra=rgA and pr and(psp>=35)and(not(close>high[1]and close>open and co>m5*0.40))
fim_perna_venda=rgB and pf and(pip>=35)and(not(close<low[1]and close<open and co>m5*0.40))
pavio_dominante_compra=(ra>0)and(psp>=38)and(ps>=pi*1.3)
pavio_dominante_venda=(ra>0)and(pip>=38)and(pi>=ps*1.3)
preco_virou_contra_venda=(rd0==-1)and(close>close[3])and(close>EMAA)
preco_virou_contra_compra=(rd0==1)and(close<close[3])and(close<EMAA)
sC=sC and(not fim_perna_compra)and(not pavio_dominante_compra)and(not preco_virou_contra_compra)
sV=sV and(not fim_perna_venda)and(not pavio_dominante_venda)and(not preco_virou_contra_venda)
d1=r1;d2=r2;d3=r3
ds1=high[1]-max(open[1],close[1]);ds2=high[2]-max(open[2],close[2]);ds3=high[3]-max(open[3],close[3])
di1=min(open[1],close[1])-low[1];di2=min(open[2],close[2])-low[2];di3=min(open[3],close[3])-low[3]
dpS1=(d1>0)and(ds1/d1*100)or 0;dpS2=(d2>0)and(ds2/d2*100)or 0;dpS3=(d3>0)and(ds3/d3*100)or 0
dpI1=(d1>0)and(di1/d1*100)or 0;dpI2=(d2>0)and(di2/d2*100)or 0;dpI3=(d3>0)and(di3/d3*100)or 0
dBc=(close>open)and(co>=m5*.25);dBv=(close<open)and(co>=m5*.25)
dbC=((dpS1>=38)and(not(dBc and close>high[1])))or((dpS2>=38)and(not(dBc and close>high[2])))or((dpS3>=38)and(not(dBc and close>high[3])))
dbV=((dpI1>=38)and(not(dBv and close<low[1])))or((dpI2>=38)and(not(dBv and close<low[2])))or((dpI3>=38)and(not(dBv and close<low[3])))
sC=sC and(not dbC);sV=sV and(not dbV)
ot=get_value(open_time,0)
if sb~=ot then sb=ot;sd=0;hm=0 end
if sd==0 then
if sC and(not sV)then sd=1
elseif sV and(not sC)then sd=-1 end
end
sC=sd==1
sV=sd==-1
if hm==0 then
if hs then hm=1 elseif hy then hm=-1 end
end
rd=rd0
if sC then
rd=1
elseif sV then
rd=-1
end
rearme_trocou=(rd0~=0)and(rd~=0)and(rd~=rd0)
if rearme_trocou then
rearme_hold_dir:set(rd)
rearme_hold_restante:set(tonumber(rearme_memoria_velas_txt))
else
rearme_hold_dir:set(rh0)
if rr0>0 then
rearme_hold_restante:set(rr0-1)
else
rearme_hold_restante:set(0)
end
end
rearme_ultima_dir:set(rd)
input_group{"S9 Alerta",
s9_extremo_pct_txt=input{default="30",type=input.string},
s9_progresso_pct_txt=input{default="18",type=input.string}}
s9_base=(r1+r2+r3+r4+r5)/5
s9_margem=s9_base*tonumber(s9_extremo_pct_txt)/100
s9_progresso=s9_base*tonumber(s9_progresso_pct_txt)/100
s9_topo_fechado=highest(high[1],doch_time)
s9_fundo_fechado=lowest(low[1],doch_time)
s9_2_topo=((s9_topo_fechado-high[1])<=s9_margem)and((s9_topo_fechado-high[2])<=s9_margem)
s9_2_fundo=((low[1]-s9_fundo_fechado)<=s9_margem)and((low[2]-s9_fundo_fechado)<=s9_margem)
s9_sem_avanco_alta=close[1]<=close[2]+s9_progresso
s9_sem_avanco_baixa=close[1]>=close[2]-s9_progresso
s9_alerta_topo_compra=rgA and s9_2_topo and s9_sem_avanco_alta and pr
s9_alerta_fundo_venda=rgB and s9_2_fundo and s9_sem_avanco_baixa and pf
plot_shape(hm==1,"HS",shape_style.arrowdown,shape_size.large,"#FF9800",shape_location.abovebar,0,"H","#FFFFFF")
plot_shape(hm==-1,"HB",shape_style.arrowup,shape_size.large,"#00E5FF",shape_location.belowbar,0,"H","#FFFFFF")
input_group{"UP COLOR",call_color=input{default="#0bd104",type=input.color}}
input_group{"DOWN COLOR",put_color=input{default="#f70202",type=input.color}}
if sC then
if mcf or aeC or transicao_freia_compra or s9_alerta_topo_compra then
plot_shape(1,'Bull_UP_FRACO',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"C\nFS","#fcfc04")
else
plot_shape(1,'Bull_UP',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"C\nFS","#fcfc04")
end
elseif sV then
if mcf or aeV or transicao_freia_venda or s9_alerta_fundo_venda then
plot_shape(1,'Bear_DOWN_FRACO',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"V\nFS","#fcfc01")
else
plot_shape(1,'Bear_DOWN',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"V\nFS","#fcfc01")
end
end
method_id=input(1,"Type",input.string_selection,{"M1 "})
input_group{"Maxima",level_1_color=input{default="#FF3EB5",type=input.color},level_1_width=input{default=2,type=input.line_width}}
input_group{"Minima",level_2_color=input{default="#FF3EB5",type=input.color},level_2_width=input{default=2,type=input.line_width}}
local function m15(candle) c1=candle.high c2=candle.low end
sec=security(current_ticker_id,"15m")
if sec then local methods={m15} methods[method_id](sec) plot(c1,"C1",level_1_color,level_1_width,0,style.levels,na_mode.continue) plot(c2,"C2",level_2_color,level_2_width,0,style.levels,na_mode.continue) end
aviso_rearme_venda=rbV
aviso_rearme_compra=rbC
plot_shape(aviso_rearme_venda,"Rv",shape_style.diamond,shape_size.tiny,rearme_obs_cor,shape_location.abovebar,0,"R?",rearme_obs_cor)
plot_shape(aviso_rearme_compra,"Rc",shape_style.diamond,shape_size.tiny,rearme_obs_cor,shape_location.belowbar,0,"R?",rearme_obs_cor)