; Memory locations
l00d0               = &00d0
l00d2               = &00d2
l00d3               = &00d3
l00d4               = &00d4
l00d5               = &00d5
l00d6               = &00d6
l00d7               = &00d7
l00d8               = &00d8
l00d9               = &00d9
l00da               = &00da
l00db               = &00db
la6f1               = &a6f1
la81a               = &a81a
la848               = &a848
la873               = &a873
lb000               = &b000
kern_print_string   = &f7d1
kern_syn_error      = &fa7d

    org &2800

.START
.pydis_start
    php                                                               ; 2800: 08          .
    ldx #&da                                                          ; 2801: a2 da       ..
    ldy #4                                                            ; 2803: a0 04       ..
    jsr la873                                                         ; 2805: 20 73 a8     s.
    bne c280d                                                         ; 2808: d0 03       ..
    jmp kern_syn_error                                                ; 280a: 4c 7d fa    L}.

.c280d
    jsr la6f1                                                         ; 280d: 20 f1 a6     ..
    ldx #9                                                            ; 2810: a2 09       ..
.loop_c2812
    lda l2872,x                                                       ; 2812: bd 72 28    .r(
    sta l00d0,x                                                       ; 2815: 95 d0       ..
    dex                                                               ; 2817: ca          .
    bpl loop_c2812                                                    ; 2818: 10 f8       ..
    lda l00da                                                         ; 281a: a5 da       ..
    sta l00d2                                                         ; 281c: 85 d2       ..
    lda l00db                                                         ; 281e: a5 db       ..
    sta l00d3                                                         ; 2820: 85 d3       ..
    ldx #&d0                                                          ; 2822: a2 d0       ..
    ldy #&14                                                          ; 2824: a0 14       ..
    lda #&ff                                                          ; 2826: a9 ff       ..
    jsr la81a                                                         ; 2828: 20 1a a8     ..
    lda l00db                                                         ; 282b: a5 db       ..
    and #&f0                                                          ; 282d: 29 f0       ).
    bne c2836                                                         ; 282f: d0 05       ..
    lda #&82                                                          ; 2831: a9 82       ..
    jmp c283f                                                         ; 2833: 4c 3f 28    L?(

.c2836
    lsr a                                                             ; 2836: 4a          J
    lsr a                                                             ; 2837: 4a          J
    lsr a                                                             ; 2838: 4a          J
    lsr a                                                             ; 2839: 4a          J
    lsr a                                                             ; 283a: 4a          J
    tax                                                               ; 283b: aa          .
    lda l286a,x                                                       ; 283c: bd 6a 28    .j(
.c283f
    sta l00d7                                                         ; 283f: 85 d7       ..
    ldx #0                                                            ; 2841: a2 00       ..
    stx l00d4                                                         ; 2843: 86 d4       ..
    stx l00d6                                                         ; 2845: 86 d6       ..
    stx l00d8                                                         ; 2847: 86 d8       ..
    lda #&80                                                          ; 2849: a9 80       ..
    sta l00d9                                                         ; 284b: 85 d9       ..
    sta l00d5                                                         ; 284d: 85 d5       ..
    lda #&84                                                          ; 284f: a9 84       ..
    sta l00d0                                                         ; 2851: 85 d0       ..
    ldx #&d0                                                          ; 2853: a2 d0       ..
    ldy #&14                                                          ; 2855: a0 14       ..
    lda #&ff                                                          ; 2857: a9 ff       ..
    jsr la81a                                                         ; 2859: 20 1a a8     ..
    lda #&f0                                                          ; 285c: a9 f0       ..
    and l00db                                                         ; 285e: 25 db       %.
    sta lb000                                                         ; 2860: 8d 00 b0    ...
    ldy #&d0                                                          ; 2863: a0 d0       ..
    jsr la848                                                         ; 2865: 20 48 a8     H.
    plp                                                               ; 2868: 28          (
    rts                                                               ; 2869: 60          `

.l286a
    equb &84, &84, &88, &86, &8c, &8c, &98, &98                       ; 286a: 84 84 88... ...
.l2872
    equb &84,   0,   0,   0, &db,   0, &dc,   0,   0, &b0             ; 2872: 84 00 00... ...
.pydis_end

save pydis_start, pydis_end
