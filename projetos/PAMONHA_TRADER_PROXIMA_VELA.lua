instrument { name = "Elite Blitz Pre e Confirma", icon="jpg", overlay = true }

input_group {
    "Compra", 
    comprar_color = input {default = "green", type = input.color} 
}

input_group {
    "Periodo Max/Min", 
    doch_time = input {default = "10", type = input.string} 
}

input_group {
    "Periodo da Micro Tendencia", 
    emaa_per = input {default = "10", type = input.string} 
}

input_group {
    "Periodo da  Macro Tendencia", 
    emab_per = input {default = "100", type = input.string} 
}

input_group {
    "Media Rapida", 
    emac_per = input {default = "3", type = input.string} 
}

input_group {
    "Media Lenta", 
    emad_per = input {default = "13", type = input.string} 
}

input_group {
    "Venda", 
    vender_color = input {default = "#fcf805", type = input.color} 
}

input_group {
    "Candles",
    positivo = input { default = "#0bd104",type = input.color },
    negativo = input { default = "#f70202",  type = input.color },
}

--PARAMETROS

EMAA   = ema(close,emaa_per)
EMAB   = ema(close,emab_per)
EMAC   = ema(hlc3,emac_per)
EMAD   = ema(hlc3,emad_per)
upper  = highest (high, doch_time)
lower  = lowest  (low,  doch_time)

--CALCULOS

TA    = ((close > close[1]) and (close > EMAA) and (EMAA > EMAA[1]))
TB    = ((close < close[1]) and (close < EMAA) and (EMAA < EMAA[1]))
ENC   = ((EMAC[1] < EMAD[1]) and (EMAC > EMAD))
ENV   = ((EMAC[1] > EMAD[1]) and (EMAC < EMAD))

sec = security (current_ticker_id, "1m")
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

input_group { "CALL - UP COLOR", call_color = input { default="#fcfc04", type = input.color } }
input_group { "PUT - DOWN COLOR", put_color = input { default="#fcfc01", type = input.color } }

-- A bolinha e neutra: prepara as duas direcoes, sem escolher compra/venda.
-- 0 = livre; 1..3 = bolinha aguardando ate tres velas de confirmacao.
-- O estado so e armado pela bolinha de uma vela anterior.
local elite_wait = make_series()
local elite_wait_prev = get_value(nz(elite_wait[1], 0))
local elite_armed = elite_wait_prev >= 1 and elite_wait_prev <= 3
local elite_range1 = high[1] - low[1]
local elite_range2 = high[2] - low[2]
local elite_base = max(elite_range1, elite_range2)
local elite_range = high - low

-- Preserva os dois engolfos do Elite. O primeiro movimento depois de uma
-- vela contraria pode avisar reversao; um novo rompimento pode avisar retomada.
local elite_engulf_up = (close[1] < open[1]) and (close > open) and
    (close > high[1]) and (close[2] >= open)
local elite_engulf_down = (close[1] > open[1]) and (close < open) and
    (close < low[1]) and (close[2] <= open)
local elite_turn_up = (close[1] <= open[1]) and (close > open) and
    (close > close[1]) and (elite_base > 0) and
    ((close - open) >= elite_base * 0.40) and
    (close > (open[1] + close[1]) / 2)
local elite_turn_down = (close[1] >= open[1]) and (close < open) and
    (close < close[1]) and (elite_base > 0) and
    ((open - close) >= elite_base * 0.40) and
    (close < (open[1] + close[1]) / 2)
local elite_resume_up = (close[1] > open[1]) and (close > open) and
    (elite_range > 0) and (close > max(high[1], high[2])) and
    ((close - open) >= elite_range * 0.45) and
    ((high - close) <= elite_range * 0.25) and
    (close[1] <= high[2])
local elite_resume_down = (close[1] < open[1]) and (close < open) and
    (elite_range > 0) and (close < min(low[1], low[2])) and
    ((open - close) >= elite_range * 0.45) and
    ((close - low) <= elite_range * 0.25) and
    (close[1] >= low[2])

-- O preco da vela ATUAL escolhe a direcao. Progresso e corpo minimo
-- evitam Compra numa vela vermelha e Venda numa vela verde/indecisa.
-- A tendencia original (TA/TB) antecipa a continuacao sem exigir que a
-- vela atual feche; sem ela, exige romper a maxima/minima anterior.
-- O pavio contra a direcao tem limite menor que o corpo minimo: uma vela
-- que ja teve Compra nao consegue exibir Venda apos virar (e vice-versa).
local elite_buy = elite_armed and (elite_base > 0) and (close > open) and
    (close > close[1]) and ((close - open) >= elite_base * 0.28) and
    ((open - low) <= elite_base * 0.26) and
    (elite_range > 0) and (close >= low + elite_range * 0.65) and
    ((close > high[1]) or
     ((TA == true) and (close > close[1] + elite_base * 0.30)))
local elite_sell = elite_armed and (elite_base > 0) and (close < open) and
    (close < close[1]) and ((open - close) >= elite_base * 0.28) and
    ((high - open) <= elite_base * 0.26) and
    (elite_range > 0) and (close <= high - elite_range * 0.65) and
    ((close < low[1]) or
     ((TB == true) and (close < close[1] - elite_base * 0.30)))

-- Uma bolinha gera no maximo UMA seta. Enquanto aguarda, bolinhas repetidas
-- nao aparecem. Depois de tres velas sem confirmacao, a bolinha expira.
local elite_dot_up = (elite_wait_prev == 0) and not elite_buy and not elite_sell and
    (elite_engulf_up or elite_turn_up or elite_resume_up)
local elite_dot_down = (elite_wait_prev == 0) and not elite_buy and not elite_sell and
    not elite_dot_up and (elite_engulf_down or elite_turn_down or elite_resume_down)

if elite_buy or elite_sell then
    elite_wait:set(0)
elseif elite_dot_up or elite_dot_down then
    elite_wait:set(1)
elseif elite_armed and elite_wait_prev < 3 then
    elite_wait:set(elite_wait_prev + 1)
else
    elite_wait:set(0)
end

plot_shape(conditional(elite_dot_up),
    'Bull_Engulfing', shape_style.circle, shape_size.huge,
    call_color, shape_location.belowbar, 0, "Alert", "A")
plot_shape(conditional(elite_dot_down),
    'Bear_Engulfing', shape_style.circle, shape_size.huge,
    put_color, shape_location.abovebar, 0, "Alert", "A")

input_group { "UP - UP COLOR", call_color = input { default="#0bd104", type = input.color } }
input_group { "DOWN - DOWN COLOR", put_color = input { default="#f70202", type = input.color } }

plot_shape(conditional(elite_buy),
    'Bull_UP', shape_style.arrowup, shape_size.huge,
    call_color, shape_location.belowbar, 0, "compra", "#fcfc04")
plot_shape(conditional(elite_sell),
    'Bear_DOWN', shape_style.arrowdown, shape_size.huge,
    put_color, shape_location.abovebar, 0, "Venda", "#fcfc01")


method_id = input (2, "Type", input.string_selection, { "M1 " })

--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOdsdgvxcvIFSDFJFBNWE9RHIEF
--IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOdsdgvxcvIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDxcvxgdfSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--   
--IQ OPTION JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--IQOPTION HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--IQOPTION JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--IQOPTION HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS-- 
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors ()JN6BT%R$%J()7654jHGGJGU$#@#$@#%$@#NMLKJHJCGRCH
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--           
-- start lines 
--colors
--linecolors 28739124   
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors ()JN6BT%R$%J()7654jHGGJGU$#@#$@#%$@#NMLKJHJCGRCH
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  -         
-- start lines 
--colors
--linecolors 28739124   
input_group {
    "Maxima",
    level_1_color = input { default = "#b59704", type = input.color },
    level_1_width = input { default = 2, type = input.line_width }
}
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
input_group {
    "Minima",
    level_2_color = input { default = "#b59704", type = input.color },
    level_2_width = input { default = 2, type = input.line_width }
}
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
local function m15(candle)
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
    c1 = candle.high
    c2 = candle.low
end
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
local methods = { m15 }
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOdsdgvxcvIFSDFJFBNWE9RHIEF
--IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOdsdgvxcvIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDxcvxgdfSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--   
--IQ OPTION JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--IQOPTION HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--IQOPTION JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--IQOPTION HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS-- 
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors ()JN6BT%R$%J()7654jHGGJGU$#@#$@#%$@#NMLKJHJCGRCH
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--           
-- start lines 
--colors
--linecolors 28739124   
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors ()JN6BT%R$%J()7654jHGGJGU$#@#$@#%$@#NMLKJHJCGRCH
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  -         
-- start lines 
--colors
--linecolors 28739124   
local resolution = "15m"
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
sec = security (current_ticker_id, resolution)
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOdsdgvxcvIFSDFJFBNWE9RHIEF
--IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOdsdgvxcvIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDxcvxgdfSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--   
--IQ OPTION JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors
--linecolors 28739124   
--IQOPTION HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--IQOPTION JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--IQOPTION HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS-- 
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors ()JN6BT%R$%J()7654jHGGJGU$#@#$@#%$@#NMLKJHJCGRCH
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--           
-- start lines 
--colors
--linecolors 28739124   
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4dgeh5WOIFSDFJFBNWE9RHIEF
-- start lines 
--colors ()JN6BT%R$%J()7654jHGGJGU$#@#$@#%$@#NMLKJHJCGRCH
--linecolors 28739124   
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--  -         
-- start lines 
--colors
--linecolors 28739124   
if sec then
   local method = methods [method_id]
   method (sec)
--IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
   plot (c1, "C1",   level_1_color, level_1_width, 0, style.levels, na_mode.continue)
   plot (c2, "C2",   level_2_color, level_2_width, 0, style.levels, na_mode.continue) --IQ OPTION SCRIPT HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--IQ OPTION SCRIPT HAOAN,
--SD 9870DFS DS87SDF BDSJBJSDF8 DFNS----IQ OPTION LOGIN JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--SDJKO3Q384EF8JSDFEESRJSDFFDSDFSD56D6843543SDF
--hgy&y*(&(&(y9H78YG9U8HO8V6RfghyujgfjhfgCHBVKUYTKKBLLHBLIY--JNASDU8Q737YQ!@#$%&()H9DS8AJDLKAMSDLKW4bnfgkguyloWOIFSDFJFBNWE9RHIEF
--HAOAN,SD 9870DFS DS87SDF BDSJBJSDF8 DFNS--
--JNASDU8Q737YQ!@#$%&*()H9DS8AJDLKAMSDLKW4WOIFSDFJFBNWE9RHIEF 
end
percentage = input (3, "Percentage", input.double, 0.01, 100, 1.0) / 100
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