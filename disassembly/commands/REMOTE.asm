; Memory locations
l00d0               = &00d0
l00d1               = &00d1
l00d2               = &00d2
l00d3               = &00d3
l00d4               = &00d4
l00d5               = &00d5
l00d6               = &00d6
l00d7               = &00d7
l00ed               = &00ed
l00ee               = &00ee
l00ef               = &00ef
l00f0               = &00f0
l00f6               = &00f6
la690               = &a690
la6f1               = &a6f1
la799               = &a799
la818               = &a818
la861               = &a861
la873               = &a873
lad2a               = &ad2a
lad3e               = &ad3e
kern_print_string   = &f7d1
kern_syn_error      = &fa7d
kern_nvrdch         = &fe94
oswrch              = &fff4

    org &2800

.START
.pydis_start
    ldx #&d2                                                          ; 2800: a2 d2       ..
    ldy #7                                                            ; 2802: a0 07       ..
    jsr la873                                                         ; 2804: 20 73 a8     s.
    bne c280c                                                         ; 2807: d0 03       ..
    jmp kern_syn_error                                                ; 2809: 4c 7d fa    L}.

.c280c
    jsr la6f1                                                         ; 280c: 20 f1 a6     ..
.c280f
    lda #&9c                                                          ; 280f: a9 9c       ..
    sta l00d0                                                         ; 2811: 85 d0       ..
    lda #0                                                            ; 2813: a9 00       ..
    sta l00d1                                                         ; 2815: 85 d1       ..
    sta l00d4                                                         ; 2817: 85 d4       ..
    sta l00d5                                                         ; 2819: 85 d5       ..
    sta l00d6                                                         ; 281b: 85 d6       ..
    lda #2                                                            ; 281d: a9 02       ..
    sta l00d7                                                         ; 281f: 85 d7       ..
    lda #&ff                                                          ; 2821: a9 ff       ..
    ldy #&14                                                          ; 2823: a0 14       ..
    jsr la818                                                         ; 2825: 20 18 a8     ..
    ldx l00d2                                                         ; 2828: a6 d2       ..
    ldy l00d3                                                         ; 282a: a4 d3       ..
    jsr lad2a                                                         ; 282c: 20 2a ad     *.
.c282f
    lda #&7f                                                          ; 282f: a9 7f       ..
    sta l00ed                                                         ; 2831: 85 ed       ..
    lda #0                                                            ; 2833: a9 00       ..
    sta l00ee                                                         ; 2835: 85 ee       ..
    lda #&ed                                                          ; 2837: a9 ed       ..
    ldx #0                                                            ; 2839: a2 00       ..
    jsr la861                                                         ; 283b: 20 61 a8     a.
.loop_c283e
    jsr la799                                                         ; 283e: 20 99 a7     ..
    beq c2868                                                         ; 2841: f0 25       .%
    lda l00ed                                                         ; 2843: a5 ed       ..
    bpl loop_c283e                                                    ; 2845: 10 f7       ..
    lda l00ee                                                         ; 2847: a5 ee       ..
    cmp #&c1                                                          ; 2849: c9 c1       ..
    beq c2859                                                         ; 284b: f0 0c       ..
    cmp #&c0                                                          ; 284d: c9 c0       ..
    beq c2873                                                         ; 284f: f0 22       ."
    lda l00f6                                                         ; 2851: a5 f6       ..
    jsr oswrch                                                        ; 2853: 20 f4 ff     ..
    jmp c282f                                                         ; 2856: 4c 2f 28    L/(

.c2859
    jsr kern_nvrdch                                                   ; 2859: 20 94 fe     ..
    sta l00f6                                                         ; 285c: 85 f6       ..
    lda #&80                                                          ; 285e: a9 80       ..
    sta l00ed                                                         ; 2860: 85 ed       ..
    jsr lad3e                                                         ; 2862: 20 3e ad     >.
    jmp c282f                                                         ; 2865: 4c 2f 28    L/(

.c2868
    lda l00ef                                                         ; 2868: a5 ef       ..
    sta l00d2                                                         ; 286a: 85 d2       ..
    lda l00f0                                                         ; 286c: a5 f0       ..
    sta l00d3                                                         ; 286e: 85 d3       ..
    jmp c280f                                                         ; 2870: 4c 0f 28    L.(

.c2873
    jmp la690                                                         ; 2873: 4c 90 a6    L..

.pydis_end

save pydis_start, pydis_end
