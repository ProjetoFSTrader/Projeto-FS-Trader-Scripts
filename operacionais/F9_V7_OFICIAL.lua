instrument{name="FS Trader F9 V7",icon="jpg",overlay=true}
EMAA=ema(close,10);upper=highest(high,10);lower=lowest(low,10);TA=(close>close[1])and(close>EMAA)and(EMAA>EMAA[1]);TB=(close<close[1])and(close<EMAA)and(EMAA<EMAA[1])
ra=high-low;r1=high[1]-low[1];r2=high[2]-low[2];r3=high[3]-low[3];r4=high[4]-low[4];r5=high[5]-low[5];r6=high[6]-low[6];r7=high[7]-low[7]
r8=high[8]-low[8];r9=high[9]-low[9];r10=high[10]-low[10];r11=high[11]-low[11];r12=high[12]-low[12];r13=high[13]-low[13];r14=high[14]-low[14]
co=abs(close-open);mr=(ra+r1+r2+r3)/4;mr15=(ra+r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14)/15;m5=(r1+r2+r3+r4+r5)/5
mt=ra+r1+r2+r3+r4+r5+r6+r7;ef=(mt>0)and(abs(close-close[7])/mt*100)or 100;lat=ef<12;mc=ra+r1+r2+r3;efc=(mc>0)and(abs(close-close[3])/mc*100)or 100;latc=efc<8
est=(mr>0)and(abs(close-close[15])>mr*25)or false;m8=(r2+r3+r4+r5+r6+r7+r8+r9)/8;c1=abs(close[1]-open[1]);cp1=(r1>0)and(c1/r1*100)or 0
ia=(m8>0)and(close[1]>open[1])and(r1>=m8*1.20)and(cp1>=55);ib=(m8>0)and(close[1]<open[1])and(r1>=m8*1.20)and(cp1>=55);top=highest(high[1],10);bot=lowest(low[1],10)
ct=(top-high[1])<=m8*.25;cf=(low[1]-bot)<=m8*.25;rc=(close>top)and(close>open)and(co>=m8*.20);rv=(close<bot)and(close<open)and(co>=m8*.20);fc=ia and ct and(not rc);fv=ib and cf and(not rv)
ps=high-max(open,close);pi=min(open,close)-low;psp=(ra>0)and(ps/ra*100)or 0;pip=(ra>0)and(pi/ra*100)or 0;mx=mr*.30;pr=(upper-high)<=mx;pf=(low-lower)<=mx
d1=(close[1]>open[1])and 1 or((close[1]<open[1])and-1 or 0);d2=(close[2]>open[2])and 1 or((close[2]<open[2])and-1 or 0);d3=(close[3]>open[3])and 1 or((close[3]<open[3])and-1 or 0)
d4=(close[4]>open[4])and 1 or((close[4]<open[4])and-1 or 0);d5=(close[5]>open[5])and 1 or((close[5]<open[5])and-1 or 0)
alt=((d1~=0)and(d2~=0)and(d1~=d2)and 1 or 0)+((d2~=0)and(d3~=0)and(d2~=d3)and 1 or 0)+((d3~=0)and(d4~=0)and(d3~=d4)and 1 or 0)+((d4~=0)and(d5~=0)and(d4~=d5)and 1 or 0)
mf=ra+r1+r2+r3+r4+r5;eff=(mf>0)and(abs(close-close[5])/mf*100)or 100;falso=(alt>=3)and(eff<18);rgA=(close[1]>EMAA[1])and(EMAA[1]>=EMAA[2]);rgB=(close[1]<EMAA[1])and(EMAA[1]<=EMAA[2])
sC=TA and(not lat)and(not latc)and(co>mr15*.20)and(not est)and(not fc)and(not falso);sV=TB and(not lat)and(not latc)and(co>mr15*.20)and(not est)and(not fv)and(not falso)
hb=m5;hc=(ra>0)and(co/ra*100)or 0;ht=max(high[1],max(high[2],high[3]));hf=min(low[1],min(low[2],low[3]))
hpa=(hb>0)and((close[1]-close[6])>=hb*1.50)and(close[1]>close[3]);hpb=(hb>0)and((close[6]-close[1])>=hb*1.50)and(close[1]<close[3])
hes=(high>=ht)and((high-ht)<=hb*.20);heb=(low<=hf)and((hf-low)<=hb*.20);hfs=(high[1]>=max(high[2],high[3]))and(high<=high[1]+hb*.05);hfb=(low[1]<=min(low[2],low[3]))and(low>=low[1]-hb*.05)
hru=(close>ht+hb*.05)and(close>open)and(hc>=55)and(psp<=30);hrd=(close<hf-hb*.05)and(close<open)and(hc>=55)and(pip<=30)
hps=(close<=close[1]+hb*.08)or(psp>=30)or(hc<45);hpx=(close>=close[1]-hb*.08)or(pip>=30)or(hc<45);hrs=hpa and pr and(hes or hfs)and hps and(not hru);hrb=hpb and pf and(heb or hfb)and hpx and(not hrd)
local hl=make_series();local htl=make_series();local hfl=make_series();local hg=make_series();hl:set(nz(hl[1],0));htl:set(nz(htl[1],ht));hfl:set(nz(hfl[1],hf));hg:set(nz(hg[1],0))
h0=nz(hl[1],0);ha=nz(hg[1],0);hs=hrs and(h0~=1);hy=hrb and(h0~=-1);hbu=(h0==1)and(close>get_value(htl)+hb*.15)and(close>open)and(co>=hb*.40)and(psp<40);hbd=(h0==-1)and(close<get_value(hfl)-hb*.15)and(close<open)and(co>=hb*.40)and(pip<40)
if hs then htl:set(max(high,high[1]));hl:set(1);hg:set(0) elseif hy then hfl:set(min(low,low[1]));hl:set(-1);hg:set(0) elseif hbu or hbd then hl:set(0);hg:set(0) elseif h0~=0 then if ha>=2 then hl:set(0);hg:set(0) else hg:set(ha+1) end else hg:set(0) end
sC=sC and(not((h0==1)and(not hbu)));sV=sV and(not((h0==-1)and(not hbd)))
p1s=high[1]-max(open[1],close[1]);p1i=min(open[1],close[1])-low[1];p1sp=(r1>0)and(p1s/r1*100)or 0;p1ip=(r1>0)and(p1i/r1*100)or 0
uf=(low[1]-lowest(low[1],10))<=m5*.35;ut=(highest(high[1],10)-high[1])<=m5*.35
rejV=rgB and uf and(p1ip>=40)and((close[6]-close[1])>=m5*1.25)and(not(close<low[1]-m5*.05 and close<open and co>=m5*.20))
rejC=rgA and ut and(p1sp>=40)and((close[1]-close[6])>=m5*1.25)and(not(close>high[1]+m5*.05 and close>open and co>=m5*.20));sV=sV and(not rejV);sC=sC and(not rejC)
local ld=make_series();ant=nz(ld[1],0);cxh=highest(high[1],4);cxl=lowest(low[1],4);cxa=cxh-cxl;cxb=(m5>0)and(cxa<=m5*2.10)and((alt>=2)or(eff<20))
brC=(close>cxh)and(close>open)and(co>=m5*.25);brV=(close<cxl)and(close<open)and(co>=m5*.25);if cxb then if(ant==-1)and sC and(not brC)then sC=false elseif(ant==1)and sV and(not brV)then sV=false end end

-- descanso por pavio grande: memoria curta de 3 velas fechadas
d2s=high[2]-max(open[2],close[2]);d2i=min(open[2],close[2])-low[2];d3s=high[3]-max(open[3],close[3]);d3i=min(open[3],close[3])-low[3]
d2sp=(r2>0)and(d2s/r2*100)or 0;d2ip=(r2>0)and(d2i/r2*100)or 0;d3sp=(r3>0)and(d3s/r3*100)or 0;d3ip=(r3>0)and(d3i/r3*100)or 0
dc1=(close>high[1])and(close>open)and(co>=m5*.25);dc2=(close>high[2])and(close>open)and(co>=m5*.25);dc3=(close>high[3])and(close>open)and(co>=m5*.25)
dv1=(close<low[1])and(close<open)and(co>=m5*.25);dv2=(close<low[2])and(close<open)and(co>=m5*.25);dv3=(close<low[3])and(close<open)and(co>=m5*.25)
dbC=((p1sp>=38)and(not dc1))or((d2sp>=38)and(not dc2))or((d3sp>=38)and(not dc3))
dbV=((p1ip>=38)and(not dv1))or((d2ip>=38)and(not dv2))or((d3ip>=38)and(not dv3))
sC=sC and(not dbC);sV=sV and(not dbV)

ot=get_value(open_time,0);if sb~=ot then sb=ot;sd=0 end
if sd==0 then if sC and(not sV)then sd=1 elseif sV and(not sC)then sd=-1 end end;sC=sd==1;sV=sd==-1
nova=ant;if sC then nova=1 elseif sV then nova=-1 end;ld:set(nova)
fr=(r1+r2+r3+r4+r5+r6+r7)/7;fh=highest(high,9);fl=lowest(low,9);fa=fh-fl;fm=fr*.35;fp=fr*.08;fr2=high[2]-low[2];fps=(fr2>0)and((high[2]-max(open[2],close[2]))/fr2*100)or 0;fpi=(fr2>0)and((min(open[2],close[2])-low[2])/fr2*100)or 0
ft=(high[2]>high[1])and(high[2]>high)and(high[2]>high[3])and(high[2]>high[4]);fb=(low[2]<low[1])and(low[2]<low)and(low[2]<low[3])and(low[2]<low[4]);ftp=(fh-high[2])<=fm;fbp=(low[2]-fl)<=fm
ftd=(high[2]-max(high[1],high[3]))>=fp;fbd=(min(low[1],low[3])-low[2])>=fp;ftr=(fps>=22)or(close[1]<close[2])or(close<close[1]);fbr=(fpi>=22)or(close[1]>close[2])or(close>close[1]);fam=(fr>0)and(fa>=fr*2.2);flat=(alt>=3)and(eff<18)and(not fam)
ftok=ft and ftp and((close[2]>close[4])or((high[2]-low[4])>=fr*1.10))and ftr and(ftd or fps>=22)and((not flat)or(ftp and ftd and ftr and fam))
fbok=fb and fbp and((close[2]<close[4])or((high[4]-low[2])>=fr*1.10))and fbr and(fbd or fpi>=22)and((not flat)or(fbp and fbd and fbr and fam))
bar="#787b86";if TA then bar="#0bd104" elseif TB then bar="#f70202" end;plot_candle(open,high,low,close,"ES",bar);plot(upper,"Resistencia","#FF8C00");plot(lower,"Suporte","#00FF66")
plot_shape(hs,"HS",shape_style.diamond,shape_size.large,"#FF9800",shape_location.abovebar,0,"H","#FFFFFF");plot_shape(hy,"HB",shape_style.diamond,shape_size.large,"#00E5FF",shape_location.belowbar,0,"H","#FFFFFF")
if sC then plot_shape(1,"BUY",shape_style.arrowup,shape_size.large,"#0bd104",shape_location.belowbar,0,"C\nFS","#fcfc04") elseif sV then plot_shape(1,"SELL",shape_style.arrowdown,shape_size.large,"#f70202",shape_location.abovebar,0,"V\nFS","#fcfc01") end
plot_shape(ftok,"F_TOP",shape_style.triangledown,shape_size.large,"#ff8c00",shape_location.abovebar,-2,"F","#ff8c00");plot_shape(fbok,"F_BOT",shape_style.triangleup,shape_size.large,"#00ff88",shape_location.belowbar,-2,"F","#00ff88")
local function m15(c)c1=c.high;c2=c.low end;sc=security(current_ticker_id,"15m");if sc then m15(sc);plot(c1,"C1","#FF3EB5",2,0,style.levels,na_mode.continue);plot(c2,"C2","#FF3EB5",2,0,style.levels,na_mode.continue)end