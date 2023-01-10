; Memory locations
l00d0               = &00d0
l0116               = &0116
l0117               = &0117
l0118               = &0118
l0119               = &0119
l011a               = &011a
l011b               = &011b
l011c               = &011c
la670               = &a670
la6bc               = &a6bc
la7f7               = &a7f7
la80d               = &a80d
la83c               = &a83c
la85d               = &a85d
kern_print_string   = &f7d1
oscrlf              = &ffed
oswrch              = &fff4

    org &2800

.START
.pydis_start
    jsr kern_print_string                                             ; 2800: 20 d1 f7     ..
    equs "DISC NAME         DRIVE"                                    ; 2803: 44 49 53... DIS

    nop                                                               ; 281a: ea          .
    jsr oscrlf                                                        ; 281b: 20 ed ff     ..
    jsr oscrlf                                                        ; 281e: 20 ed ff     ..
    lda #0                                                            ; 2821: a9 00       ..
    sta pydis_end                                                     ; 2823: 8d b1 28    ..(
.c2826
    lda pydis_end                                                     ; 2826: ad b1 28    ..(
    sta l011b                                                         ; 2829: 8d 1b 01    ...
    lda #&b1                                                          ; 282c: a9 b1       ..
    sta l011c                                                         ; 282e: 8d 1c 01    ...
    lda #7                                                            ; 2831: a9 07       ..
    ldy #&0e                                                          ; 2833: a0 0e       ..
    jsr la7f7                                                         ; 2835: 20 f7 a7     ..
    jsr la6bc                                                         ; 2838: 20 bc a6     ..
    ldx #8                                                            ; 283b: a2 08       ..
.loop_c283d
    lda l28a8,x                                                       ; 283d: bd a8 28    ..(
    sta l00d0,x                                                       ; 2840: 95 d0       ..
    dex                                                               ; 2842: ca          .
    bpl loop_c283d                                                    ; 2843: 10 f8       ..
    jsr la80d                                                         ; 2845: 20 0d a8     ..
    jsr la85d                                                         ; 2848: 20 5d a8     ].
    jsr la670                                                         ; 284b: 20 70 a6     p.
    lda l0117                                                         ; 284e: ad 17 01    ...
    pha                                                               ; 2851: 48          H
    beq c2865                                                         ; 2852: f0 11       ..
    ldx #2                                                            ; 2854: a2 02       ..
.loop_c2856
    lda l0116,x                                                       ; 2856: bd 16 01    ...
    sta l0119,x                                                       ; 2859: 9d 19 01    ...
    inx                                                               ; 285c: e8          .
    cmp #&0d                                                          ; 285d: c9 0d       ..
    bne loop_c2856                                                    ; 285f: d0 f5       ..
    pla                                                               ; 2861: 68          h
    jmp la83c                                                         ; 2862: 4c 3c a8    L<.

.c2865
    pla                                                               ; 2865: 68          h
    ldy l0118                                                         ; 2866: ac 18 01    ...
    beq c28a7                                                         ; 2869: f0 3c       .<
    ldx #0                                                            ; 286b: a2 00       ..
.c286d
    lda l0119,x                                                       ; 286d: bd 19 01    ...
    pha                                                               ; 2870: 48          H
    ldy #&10                                                          ; 2871: a0 10       ..
.loop_c2873
    lda l011a,x                                                       ; 2873: bd 1a 01    ...
    jsr oswrch                                                        ; 2876: 20 f4 ff     ..
    inx                                                               ; 2879: e8          .
    dey                                                               ; 287a: 88          .
    bne loop_c2873                                                    ; 287b: d0 f6       ..
    lda #&20                                                          ; 287d: a9 20       .
    jsr oswrch                                                        ; 287f: 20 f4 ff     ..
    jsr oswrch                                                        ; 2882: 20 f4 ff     ..
    jsr oswrch                                                        ; 2885: 20 f4 ff     ..
    jsr oswrch                                                        ; 2888: 20 f4 ff     ..
    pla                                                               ; 288b: 68          h
    clc                                                               ; 288c: 18          .
    adc #&30                                                          ; 288d: 69 30       i0
    jsr oswrch                                                        ; 288f: 20 f4 ff     ..
    jsr oscrlf                                                        ; 2892: 20 ed ff     ..
    inx                                                               ; 2895: e8          .
    dec l0118                                                         ; 2896: ce 18 01    ...
    bne c286d                                                         ; 2899: d0 d2       ..
    clc                                                               ; 289b: 18          .
    lda pydis_end                                                     ; 289c: ad b1 28    ..(
    adc #&b1                                                          ; 289f: 69 b1       i.
    sta pydis_end                                                     ; 28a1: 8d b1 28    ..(
    jmp c2826                                                         ; 28a4: 4c 26 28    L&(

.c28a7
    rts                                                               ; 28a7: 60          `

.l28a8
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0                  ; 28a8: 7f 88 00... ...
.pydis_end

save pydis_start, pydis_end
