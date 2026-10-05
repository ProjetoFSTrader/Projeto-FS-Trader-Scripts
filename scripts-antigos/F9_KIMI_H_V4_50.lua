instrument{name="F9 H V3",icon="jpg",overlay=true}
input_group{"F9",doch_time=input{default="10",type=input.string},emaa_per=input{default="10",type=input.string}}
input_group{"Candles",positivo=input{default="#0bd104",type=input.color},negativo=input{default="#f70202",type=input.color},neutro=input{default="#4FA3C7",type=input.color}}
input_group{"Canal",upline_color=input{default="#FF8C00",type=input.color},lowline_color=input{default="#00FF66",type=input.color}}
input_group{"Sinais",call_color=input{default="#0bd104",type=input.color},put_color=input{default="#f70202",type=input.color},h_color=input{default="#7C6CFF",type=input.color}}
EMAA=ema(close,emaa_per)
upper=highest(high,doch_time)
lower=lowest(low,doch_time)
TA=(close>close[1])and(close>EMAA)and(EMAA>EMAA[1])
TB=(close<close[1])and(close<EMAA)and(EMAA<EMAA[1])
ca=abs(close-open)
ra=high-low
sec=security(current_ticker_id,"1m")
if sec then
 local bc
 if TA then bc=positivo elseif TB then bc=negativo else bc=neutro end
 plot_candle(open,high,low,close,"ES",bc)
 plot(upper,"Resistencia",upline_color)
 plot(lower,"Suporte",lowline_color)
end
r1=high[1]-low[1]
r2=high[2]-low[2]
r3=high[3]-low[3]
r4=high[4]-low[4]
r5=high[5]-low[5]
r6=high[6]-low[6]
r7=high[7]-low[7]
r8=high[8]-low[8]
r9=high[9]-low[9]
r10=high[10]-low[10]
r11=high[11]-low[11]
r12=high[12]-low[12]
r13=high[13]-low[13]
r14=high[14]-low[14]
mra=(ra+r1+r2+r3)/4
mr15=(ra+r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14)/15
pl=abs(close-close[7])
mt=ra+r1+r2+r3+r4+r5+r6+r7
eficiencia=(mt>0)and(pl/mt*100)or 100
lat=eficiencia<12
plc=abs(close-close[3])
mtc=ra+r1+r2+r3
efc=(mtc>0)and(plc/mtc*100)or 100
latc=efc<8
dp=abs(close-close[15])
pe=(mra>0)and(dp>mra*50)or false
mr8=(r2+r3+r4+r5+r6+r7+r8+r9)/8
c1f=abs(close[1]-open[1])
c1p=(r1>0)and(c1f/r1*100)or 0
iaf=(mr8>0)and(close[1]>open[1])and(r1>=mr8*1.20)and(c1p>=55)
ibf=(mr8>0)and(close[1]<open[1])and(r1>=mr8*1.20)and(c1p>=55)
tfp=highest(high[1],doch_time)
ffp=lowest(low[1],doch_time)
ctp=(tfp-high[1])<=mr8*0.25
cfp=(low[1]-ffp)<=mr8*0.25
rcp=(close>tfp)and(close>open)and(ca>=mr8*0.20)
rvp=(close<ffp)and(close<open)and(ca>=mr8*0.20)
fpc=iaf and ctp and(not rcp)
fpv=ibf and cfp and(not rvp)
psa=high-max(open,close)
pia=min(open,close)-low
pus=(ra>0)and(psa/ra*100)or 0
pis=(ra>0)and(pia/ra*100)or 0
pr=(upper-high)<=mra*0.30
pu=(low-lower)<=mra*0.30
raf=(close[1]>EMAA[1])and(EMAA[1]>=EMAA[2])
rbf=(close[1]<EMAA[1])and(EMAA[1]<=EMAA[2])
d1=(close[1]>open[1])and 1 or((close[1]<open[1])and-1 or 0)
d2=(close[2]>open[2])and 1 or((close[2]<open[2])and-1 or 0)
d3=(close[3]>open[3])and 1 or((close[3]<open[3])and-1 or 0)
d4=(close[4]>open[4])and 1 or((close[4]<open[4])and-1 or 0)
d5=(close[5]>open[5])and 1 or((close[5]<open[5])and-1 or 0)
t12=(d1~=0)and(d2~=0)and(d1~=d2)and 1 or 0
t23=(d2~=0)and(d3~=0)and(d2~=d3)and 1 or 0
t34=(d3~=0)and(d4~=0)and(d3~=d4)and 1 or 0
t45=(d4~=0)and(d5~=0)and(d4~=d5)and 1 or 0
al5=t12+t23+t34+t45
mf6=ra+r1+r2+r3+r4+r5
pf6=abs(close-close[5])
ef6=(mf6>0)and(pf6/mf6*100)or 100
ff8=(al5>=3)and(ef6<18)
mr5=(r1+r2+r3+r4+r5)/5
d8=abs(close-close[5])
pf8=(mr5>0)and(d8>=mr5*4.5)
cr8=(mr5>0)and(ca/mr5*100)or 100
pc8=cr8<70
rc8=pus>=30
rv8=pis>=30
p8c=pf8 and pr and(pc8 or rc8)
p8v=pf8 and pu and(pc8 or rv8)
sam=raf and pf8 and pr
sbm=rbf and pf8 and pu
spa=(close[1]<=close[2]+mr5*0.18)or rc8
spb=(close[1]>=close[2]-mr5*0.18)or rv8
sra=close>high[1]and close>open and ca>mr5*0.40
srb=close<low[1]and close<open and ca>mr5*0.40
sbc=sam and spa and(not sra)
sbv=sbm and spb and(not srb)
f9m=mr5*0.30
f9t=highest(high[1],doch_time)
f9f=lowest(low[1],doch_time)
f9tr=((f9t-high[1])<=f9m)and((f9t-high[2])<=f9m)
f9fr=((low[1]-f9f)<=f9m)and((low[2]-f9f)<=f9m)
f9sa=close[1]<=close[2]+mr5*0.18
f9sb=close[1]>=close[2]-mr5*0.18
f9rt=close>high[1]and close>open and ca>mr5*0.40
f9rf=close<low[1]and close<open and ca>mr5*0.40
f9bc=raf and pr and f9tr and f9sa and(not f9rt)
f9bv=rbf and pu and f9fr and f9sb and(not f9rf)
cx=(ra>0)and(ca/ra*100)or 100
local su=make_series()
local sd=make_series()
su:set((close[1]>open[1])and(nz(su[1],0)+1)or 0)
sd:set((close[1]<open[1])and(nz(sd[1],0)+1)or 0)
djc=(cx<30)and(pus>25)and(pis>25)and pr
djv=(cx<30)and(pus>25)and(pis>25)and pu
exc=(get_value(su)>=3)and(ca<mra*0.6)and pr
exv=(get_value(sd)>=3)and(ca<mra*0.6)and pu
ulc=(get_value(su)>=3)and((high-close)>mra*0.7)and(close>close[1])
ulv=(get_value(sd)>=3)and((close-low)>mra*0.7)and(close<close[1])
ipc=ca>=mra*1.1 and close>open and pus<40
ipv=ca>=mra*1.1 and close<open and pis<40
sc=TA and(not lat)and(not latc)and(ca>mr15*0.20)and(not pe)and(not fpc)and(not ff8)and(not p8c)and(not sbc)and(not f9bc)and(not(djc or exc or ulc)or ipc)
sv=TB and(not lat)and(not latc)and(ca>mr15*0.20)and(not pe)and(not fpv)and(not ff8)and(not p8v)and(not sbv)and(not f9bv)and(not(djv or exv or ulv)or ipv)
h_base=mr5
hcp=(ra>0)and(ca/ra*100)or 0
htp=max(high[1],max(high[2],high[3]))
hfp=min(low[1],min(low[2],low[3]))
hpa=raf and(h_base>0)and((close[1]-close[6])>=h_base*2.25)
hpb=rbf and(h_base>0)and((close[6]-close[1])>=h_base*2.25)
het=(high>=htp)and((high-htp)<=h_base*0.20)
hef=(low<=hfp)and((hfp-low)<=h_base*0.20)
hft=(high[1]>=max(high[2],high[3]))and(high<=high[1]+h_base*0.05)
hff=(low[1]<=min(low[2],low[3]))and(low>=low[1]-h_base*0.05)
hru=(close>htp+h_base*0.05)and(close>open)and(hcp>=55)and(pus<=30)
hrd=(close<hfp-h_base*0.05)and(close<open)and(hcp>=55)and(pis<=30)
hrt=hpa and pr and(het or hft)and(not hru)
hrf=hpb and pu and(hef or hff)and(not hrd)
local hlk=make_series()
local htl=make_series()
local hfl=make_series()
hlk:set(nz(hlk[1],0))
htl:set(nz(htl[1],htp))
hfl:set(nz(hfl[1],hfp))
hl0=nz(hlk[1],0)
h_topo=hrt and(hl0~=1)
h_fundo=hrf and(hl0~=-1)
hrtp=(hl0==1)and(close>get_value(htl)+h_base*0.15)and(close>open)and(ca>=h_base*0.40)and(pus<40)
hrfp=(hl0==-1)and(close<get_value(hfl)-h_base*0.15)and(close<open)and(ca>=h_base*0.40)and(pis<40)
if h_topo then htl:set(max(high,high[1]));hlk:set(1)
elseif h_fundo then hfl:set(min(low,low[1]));hlk:set(-1)
elseif hrtp or hrfp then hlk:set(0) end
-- V3: veta somente a 3a vela depois de H ou do primeiro arranque novo.
local v3c=make_series()
local v3u=make_series()
v3u:set(nz(v3u[1],0))
if h_topo or h_fundo then v3u:set(0) end
v3b=(hl0==1)and(get_value(v3u)==0)and(close<open)and(close<low[1])and(ca>=h_base*0.40)
v3a=(hl0==-1)and(get_value(v3u)==0)and(close>open)and(close>high[1])and(ca>=h_base*0.40)
if v3a or v3b then v3u:set(1) end
v3n=h_topo or h_fundo or hrtp or hrfp or v3a or v3b
v3c:set(v3n and 0 or min(nz(v3c[1],9)+1,9))
v3x=get_value(v3c)==3
scf=sc and(not v3x)
svf=sv and(not v3x)
if h_topo then plot_shape(1,'H_FINAL_TOPO',shape_style.diamond,shape_size.huge,h_color,shape_location.abovebar,0,"H","#FFFFFF")
elseif h_fundo then plot_shape(1,'H_FINAL_FUNDO',shape_style.diamond,shape_size.huge,h_color,shape_location.belowbar,0,"H","#FFFFFF")
elseif scf then plot_shape(1,'Bull_UP',shape_style.arrowup,shape_size.large,call_color,shape_location.belowbar,0,"Compra","#fcfc04")
elseif svf then plot_shape(1,'Bear_DOWN',shape_style.arrowdown,shape_size.large,put_color,shape_location.abovebar,0,"Venda","#fcfc01") end
input_group{"Maxima",level_1_color=input{default="#FF3EB5",type=input.color},level_1_width=input{default=2,type=input.line_width}}
input_group{"Minima",level_2_color=input{default="#FF3EB5",type=input.color},level_2_width=input{default=2,type=input.line_width}}
sec=security(current_ticker_id,"15m")
if sec then plot(sec.high,"C1",level_1_color,level_1_width,0,style.levels,na_mode.continue);plot(sec.low,"C2",level_2_color,level_2_width,0,style.levels,na_mode.continue) end