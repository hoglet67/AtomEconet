; Memory locations
l00d0               = &00d0
l0117               = &0117
l0118               = &0118
l0119               = &0119
l011a               = &011a
l011b               = &011b
l011c               = &011c
la670               = &a670
la6bc               = &a6bc
la7c3               = &a7c3
la7f7               = &a7f7
la80d               = &a80d
la85d               = &a85d
kern_print_string   = &f7d1
oscrlf              = &ffed
oswrch              = &fff4

    org &2800

.START
.pydis_start
    lda #0                                                            ; 2800: a9 00       ..
    sta pydis_end                                                     ; 2802: 8d fb 28    ..(
.c2805
    lda pydis_end                                                     ; 2805: ad fb 28    ..(
    sta l011b                                                         ; 2808: 8d 1b 01    ...
    lda #5                                                            ; 280b: a9 05       ..
    sta l011c                                                         ; 280d: 8d 1c 01    ...
    lda #7                                                            ; 2810: a9 07       ..
    ldy #&0f                                                          ; 2812: a0 0f       ..
    jsr la7f7                                                         ; 2814: 20 f7 a7     ..
    jsr la6bc                                                         ; 2817: 20 bc a6     ..
    ldx #8                                                            ; 281a: a2 08       ..
.loop_c281c
    lda l28f2,x                                                       ; 281c: bd f2 28    ..(
    sta l00d0,x                                                       ; 281f: 95 d0       ..
    dex                                                               ; 2821: ca          .
    bpl loop_c281c                                                    ; 2822: 10 f8       ..
    jsr la80d                                                         ; 2824: 20 0d a8     ..
    jsr la85d                                                         ; 2827: 20 5d a8     ].
    jsr la670                                                         ; 282a: 20 70 a6     p.
    lda l0117                                                         ; 282d: ad 17 01    ...
    bne c2891                                                         ; 2830: d0 5f       ._
    ldy l0118                                                         ; 2832: ac 18 01    ...
    beq c2891                                                         ; 2835: f0 5a       .Z
    ldx #0                                                            ; 2837: a2 00       ..
.c2839
    lda l0119,x                                                       ; 2839: bd 19 01    ...
    pha                                                               ; 283c: 48          H
    lda l011a,x                                                       ; 283d: bd 1a 01    ...
    pha                                                               ; 2840: 48          H
    ldy #4                                                            ; 2841: a0 04       ..
.loop_c2843
    lda l011b,x                                                       ; 2843: bd 1b 01    ...
    jsr oswrch                                                        ; 2846: 20 f4 ff     ..
    inx                                                               ; 2849: e8          .
    dey                                                               ; 284a: 88          .
    bne loop_c2843                                                    ; 284b: d0 f6       ..
    lda #&20                                                          ; 284d: a9 20       .
    jsr oswrch                                                        ; 284f: 20 f4 ff     ..
    pla                                                               ; 2852: 68          h
    beq c285c                                                         ; 2853: f0 07       ..
    jsr sub_c28a3                                                     ; 2855: 20 a3 28     .(
    lda #1                                                            ; 2858: a9 01       ..
    bne c285e                                                         ; 285a: d0 02       ..
.c285c
    lda #4                                                            ; 285c: a9 04       ..
.c285e
    jsr sub_c2894                                                     ; 285e: 20 94 28     .(
    pla                                                               ; 2861: 68          h
    jsr sub_c28a3                                                     ; 2862: 20 a3 28     .(
    lda #4                                                            ; 2865: a9 04       ..
    jsr sub_c2894                                                     ; 2867: 20 94 28     .(
    lda l011b,x                                                       ; 286a: bd 1b 01    ...
    php                                                               ; 286d: 08          .
    lda #&55                                                          ; 286e: a9 55       .U
    plp                                                               ; 2870: 28          (
    beq c2875                                                         ; 2871: f0 02       ..
    lda #&73                                                          ; 2873: a9 73       .s
.c2875
    jsr oswrch                                                        ; 2875: 20 f4 ff     ..
    txa                                                               ; 2878: 8a          .
    clc                                                               ; 2879: 18          .
    adc #3                                                            ; 287a: 69 03       i.
    tax                                                               ; 287c: aa          .
    jsr oscrlf                                                        ; 287d: 20 ed ff     ..
    dec l0118                                                         ; 2880: ce 18 01    ...
    bne c2839                                                         ; 2883: d0 b4       ..
    clc                                                               ; 2885: 18          .
    lda pydis_end                                                     ; 2886: ad fb 28    ..(
    adc #5                                                            ; 2889: 69 05       i.
    sta pydis_end                                                     ; 288b: 8d fb 28    ..(
    jmp c2805                                                         ; 288e: 4c 05 28    L.(

.c2891
    jmp la7c3                                                         ; 2891: 4c c3 a7    L..

.sub_c2894
    sta l28a2                                                         ; 2894: 8d a2 28    ..(
    lda #&20                                                          ; 2897: a9 20       .
.loop_c2899
    jsr oswrch                                                        ; 2899: 20 f4 ff     ..
    dec l28a2                                                         ; 289c: ce a2 28    ..(
    bne loop_c2899                                                    ; 289f: d0 f8       ..
    rts                                                               ; 28a1: 60          `

.l28a2
    equb 0                                                            ; 28a2: 00          .

.sub_c28a3
    sta l28a2                                                         ; 28a3: 8d a2 28    ..(
    lda #0                                                            ; 28a6: a9 00       ..
    sta l28f1                                                         ; 28a8: 8d f1 28    ..(
    txa                                                               ; 28ab: 8a          .
    pha                                                               ; 28ac: 48          H
    tya                                                               ; 28ad: 98          .
    pha                                                               ; 28ae: 48          H
    ldx #&2f                                                          ; 28af: a2 2f       ./
    lda l28a2                                                         ; 28b1: ad a2 28    ..(
.loop_c28b4
    sbc #&64                                                          ; 28b4: e9 64       .d
    inx                                                               ; 28b6: e8          .
    bcs loop_c28b4                                                    ; 28b7: b0 fb       ..
    adc #&64                                                          ; 28b9: 69 64       id
    pha                                                               ; 28bb: 48          H
    txa                                                               ; 28bc: 8a          .
    jsr sub_c28de                                                     ; 28bd: 20 de 28     .(
    ldx #&2f                                                          ; 28c0: a2 2f       ./
    pla                                                               ; 28c2: 68          h
.loop_c28c3
    sbc #&0a                                                          ; 28c3: e9 0a       ..
    inx                                                               ; 28c5: e8          .
    bcs loop_c28c3                                                    ; 28c6: b0 fb       ..
    adc #&0a                                                          ; 28c8: 69 0a       i.
    pha                                                               ; 28ca: 48          H
    txa                                                               ; 28cb: 8a          .
    jsr sub_c28de                                                     ; 28cc: 20 de 28     .(
    dec l28f1                                                         ; 28cf: ce f1 28    ..(
    pla                                                               ; 28d2: 68          h
    clc                                                               ; 28d3: 18          .
    adc #&30                                                          ; 28d4: 69 30       i0
    jsr sub_c28de                                                     ; 28d6: 20 de 28     .(
    pla                                                               ; 28d9: 68          h
    tay                                                               ; 28da: a8          .
    pla                                                               ; 28db: 68          h
    tax                                                               ; 28dc: aa          .
    rts                                                               ; 28dd: 60          `

.sub_c28de
    cmp #&30                                                          ; 28de: c9 30       .0
    bne c28eb                                                         ; 28e0: d0 09       ..
    bit l28f1                                                         ; 28e2: 2c f1 28    ,.(
    bmi c28ee                                                         ; 28e5: 30 07       0.
    lda #&20                                                          ; 28e7: a9 20       .
    bne c28ee                                                         ; 28e9: d0 03       ..
.c28eb
    dec l28f1                                                         ; 28eb: ce f1 28    ..(
.c28ee
    jmp oswrch                                                        ; 28ee: 4c f4 ff    L..

.l28f1
    equb 0                                                            ; 28f1: 00          .
.l28f2
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0                  ; 28f2: 7f 88 00... ...
.pydis_end

save pydis_start, pydis_end
