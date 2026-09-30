#!/usr/bin/env python3
"""Decodifica o pacote de coletas do Projeto Pamonha/Fábio Santiago Trader.

- Arquivos *.tar.xz.b64x2: base64 duas vezes -> tar.xz -> extrai CSVs originais.
- RAW *.f9raw.xz.b64x2: base64 duas vezes -> F9RAW -> CSV normalizado.
- RAW dividido em part001/part002: decodifica cada parte e concatena os bytes antes de abrir F9RAW.

O formato F9RAW preserva numericamente todas as colunas do RAW, exceto timestamp_utc e
timestamp_brt, que são derivados de at_ns. Quebras de linha e formatação textual decimal podem
ser normalizadas na reconstrução, mas os valores numéricos são preservados.
"""
from __future__ import annotations
import argparse, base64, csv, json, lzma, struct, tarfile
from datetime import datetime, timezone, timedelta
from pathlib import Path

MAGIC=b"F9RAW1\0"
BRT=timezone(timedelta(hours=-3))

def read_b64(path: Path) -> bytes:
    text=path.read_text(encoding="ascii").strip()
    if path.name.endswith(".b64x2"):
        return base64.b64decode(base64.b64decode(text))
    return base64.b64decode(text)

def extract_nonraw(path: Path, outdir: Path) -> None:
    raw=read_b64(path)
    outdir.mkdir(parents=True, exist_ok=True)
    tmp=outdir/"_coletas_nonraw.tar.xz"
    tmp.write_bytes(raw)
    with tarfile.open(tmp, "r:xz") as tf:
        tf.extractall(outdir)
    tmp.unlink(missing_ok=True)

def _rounded_datetime(ns: int, tz: timezone) -> str:
    sec, rem = divmod(ns, 1_000_000_000)
    us=(rem+500)//1000
    if us>=1_000_000:
        sec+=1
        us-=1_000_000
    dt=datetime.fromtimestamp(sec, timezone.utc).replace(microsecond=us).astimezone(tz)
    return dt.isoformat(timespec="microseconds")

def _fmt_scaled(v: int, decimals: int) -> str:
    if decimals <= 0:
        return str(v)
    neg=v<0
    v=abs(v)
    scale=10**decimals
    whole, frac=divmod(v, scale)
    s=f"{whole}.{frac:0{decimals}d}".rstrip("0").rstrip(".")
    if neg:
        s="-"+s
    return s

def decode_f9raw_bytes(comp: bytes, out_csv: Path) -> dict:
    data=lzma.decompress(comp)
    pos=0
    if data[:len(MAGIC)] != MAGIC:
        raise ValueError("Formato F9RAW inválido")
    pos += len(MAGIC)
    (mlen,)=struct.unpack_from("<I",data,pos)
    pos+=4
    meta=json.loads(data[pos:pos+mlen].decode("utf-8"))
    pos+=mlen
    (ncols,)=struct.unpack_from("<I",data,pos)
    pos+=4
    arrays={}
    for _ in range(ncols):
        (nlen,)=struct.unpack_from("<H",data,pos)
        pos+=2
        name=data[pos:pos+nlen].decode("utf-8")
        pos+=nlen
        dlen=data[pos]
        pos+=1
        dtype=data[pos:pos+dlen].decode("ascii")
        pos+=dlen
        (rlen,)=struct.unpack_from("<Q",data,pos)
        pos+=8
        raw=data[pos:pos+rlen]
        pos+=rlen
        if dtype == "int64":
            count=rlen//8
            vals=list(struct.unpack("<"+"q"*count, raw))
            acc=0
            for i,x in enumerate(vals):
                if i==0:
                    acc=x
                else:
                    acc+=x
                vals[i]=acc
            arrays[name]=vals
        elif dtype == "uint8":
            arrays[name]=list(raw)
        else:
            raise ValueError(f"dtype não suportado: {dtype}")

    header=meta["header"]
    rows=meta["rows"]
    price_scales=meta["price_scales"]
    int_cols=set(meta["int_cols"])
    phase_cols=set(meta["phase_cols"])
    phase_maps=meta["phase_maps"]
    at_ns=arrays["at_ns"]

    out_csv.parent.mkdir(parents=True, exist_ok=True)
    with out_csv.open("w",encoding="utf-8",newline="") as f:
        w=csv.writer(f,lineterminator="\n")
        w.writerow(header)
        for i in range(rows):
            row=[]
            for c in header:
                if c == "timestamp_utc":
                    row.append(_rounded_datetime(at_ns[i], timezone.utc))
                elif c == "timestamp_brt":
                    row.append(_rounded_datetime(at_ns[i], BRT))
                elif c in int_cols:
                    row.append(str(arrays[c][i]))
                elif c in price_scales:
                    row.append(_fmt_scaled(arrays[c][i], int(price_scales[c])))
                elif c in phase_cols:
                    row.append(phase_maps[c][arrays[c][i]])
                else:
                    raise KeyError(c)
            w.writerow(row)
    return meta

def decode_raw_b64(parts: list[Path], out_csv: Path) -> dict:
    comp=b"".join(read_b64(p) for p in parts)
    return decode_f9raw_bytes(comp,out_csv)

def main():
    ap=argparse.ArgumentParser()
    sub=ap.add_subparsers(dest="cmd",required=True)
    a=sub.add_parser("extract-small")
    a.add_argument("archive",type=Path)
    a.add_argument("outdir",type=Path)
    b=sub.add_parser("decode-raw")
    b.add_argument("parts",nargs="+",type=Path)
    b.add_argument("--out",required=True,type=Path)
    ns=ap.parse_args()
    if ns.cmd=="extract-small":
        extract_nonraw(ns.archive, ns.outdir)
    else:
        meta=decode_raw_b64(ns.parts,ns.out)
        print(json.dumps(meta,ensure_ascii=False,indent=2))

if __name__=="__main__":
    main()
