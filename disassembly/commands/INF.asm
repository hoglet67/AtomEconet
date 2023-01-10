; Memory locations
l00d0               = &00d0
l0104               = &0104
l0116               = &0116
l0117               = &0117
l0118               = &0118
l0119               = &0119
l011b               = &011b
l011c               = &011c
l011d               = &011d
l011e               = &011e
la658               = &a658
la670               = &a670
la6bc               = &a6bc
la788               = &a788
la7c3               = &a7c3
la7f7               = &a7f7
la80d               = &a80d
la83c               = &a83c
la85d               = &a85d
kern_print_string   = &f7d1
osasci              = &ffe9
oscrlf              = &ffed

    org &2800

.START
.pydis_start
    ldy #&ff                                                          ; 2800: a0 ff       ..
.loop_c2802
    iny                                                               ; 2802: c8          .
    lda l0104,y                                                       ; 2803: b9 04 01    ...
    cmp #&20                                                          ; 2806: c9 20       .
    beq loop_c2802                                                    ; 2808: f0 f8       ..
    ldx #0                                                            ; 280a: a2 00       ..
.loop_c280c
    lda l0104,y                                                       ; 280c: b9 04 01    ...
    sta pydis_end,x                                                   ; 280f: 9d a7 28    ..(
    sta l011b,x                                                       ; 2812: 9d 1b 01    ...
    iny                                                               ; 2815: c8          .
    inx                                                               ; 2816: e8          .
    cmp #&0d                                                          ; 2817: c9 0d       ..
    bne loop_c280c                                                    ; 2819: d0 f1       ..
    tya                                                               ; 281b: 98          .
    clc                                                               ; 281c: 18          .
    adc #5                                                            ; 281d: 69 05       i.
    ldy #4                                                            ; 281f: a0 04       ..
    jsr la658                                                         ; 2821: 20 58 a6     X.
    jsr sub_c2899                                                     ; 2824: 20 99 28     .(
    jsr oscrlf                                                        ; 2827: 20 ed ff     ..
    lda #0                                                            ; 282a: a9 00       ..
.c282c
    pha                                                               ; 282c: 48          H
    sta l011c                                                         ; 282d: 8d 1c 01    ...
    lda #1                                                            ; 2830: a9 01       ..
    sta l011b                                                         ; 2832: 8d 1b 01    ...
    lda #1                                                            ; 2835: a9 01       ..
    sta l011d                                                         ; 2837: 8d 1d 01    ...
    ldx #0                                                            ; 283a: a2 00       ..
.loop_c283c
    lda pydis_end,x                                                   ; 283c: bd a7 28    ..(
    sta l011e,x                                                       ; 283f: 9d 1e 01    ...
    inx                                                               ; 2842: e8          .
    cmp #&0d                                                          ; 2843: c9 0d       ..
    bne loop_c283c                                                    ; 2845: d0 f5       ..
    txa                                                               ; 2847: 8a          .
    clc                                                               ; 2848: 18          .
    adc #8                                                            ; 2849: 69 08       i.
    ldy #3                                                            ; 284b: a0 03       ..
    jsr la7f7                                                         ; 284d: 20 f7 a7     ..
    jsr la6bc                                                         ; 2850: 20 bc a6     ..
    ldx #8                                                            ; 2853: a2 08       ..
.loop_c2855
    lda l2890,x                                                       ; 2855: bd 90 28    ..(
    sta l00d0,x                                                       ; 2858: 95 d0       ..
    dex                                                               ; 285a: ca          .
    bpl loop_c2855                                                    ; 285b: 10 f8       ..
    jsr la80d                                                         ; 285d: 20 0d a8     ..
    jsr la85d                                                         ; 2860: 20 5d a8     ].
    jsr la670                                                         ; 2863: 20 70 a6     p.
    lda l0117                                                         ; 2866: ad 17 01    ...
    beq c287d                                                         ; 2869: f0 12       ..
    ldx #2                                                            ; 286b: a2 02       ..
    pha                                                               ; 286d: 48          H
.loop_c286e
    lda l0116,x                                                       ; 286e: bd 16 01    ...
    sta l0119,x                                                       ; 2871: 9d 19 01    ...
    inx                                                               ; 2874: e8          .
    cmp #&0d                                                          ; 2875: c9 0d       ..
    bne loop_c286e                                                    ; 2877: d0 f5       ..
    pla                                                               ; 2879: 68          h
    jmp la83c                                                         ; 287a: 4c 3c a8    L<.

.c287d
    lda l0118                                                         ; 287d: ad 18 01    ...
    beq c288c                                                         ; 2880: f0 0a       ..
    jsr la788                                                         ; 2882: 20 88 a7     ..
    pla                                                               ; 2885: 68          h
    clc                                                               ; 2886: 18          .
    adc #1                                                            ; 2887: 69 01       i.
    jmp c282c                                                         ; 2889: 4c 2c 28    L,(

.c288c
    pla                                                               ; 288c: 68          h
    jmp la7c3                                                         ; 288d: 4c c3 a7    L..

.l2890
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0                  ; 2890: 7f 88 00... ...

.sub_c2899
    ldx #0                                                            ; 2899: a2 00       ..
.loop_c289b
    lda l011b,x                                                       ; 289b: bd 1b 01    ...
    bmi c28a6                                                         ; 289e: 30 06       0.
    jsr osasci                                                        ; 28a0: 20 e9 ff     ..
    inx                                                               ; 28a3: e8          .
    bne loop_c289b                                                    ; 28a4: d0 f5       ..
.c28a6
    rts                                                               ; 28a6: 60          `

.pydis_end

save pydis_start, pydis_end
