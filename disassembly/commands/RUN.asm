; Memory locations
l0100               = &0100
kern_print_string   = &f7d1
kern_skip_spaces    = &f876
oscli               = &fff7

    org &2800

.START
.pydis_start
    ldy #0                                                            ; 2800: a0 00       ..
    jsr kern_skip_spaces                                              ; 2802: 20 76 f8     v.
    dey                                                               ; 2805: 88          .
.loop_c2806
    iny                                                               ; 2806: c8          .
    lda l0100,y                                                       ; 2807: b9 00 01    ...
    cmp #&0d                                                          ; 280a: c9 0d       ..
    beq c2826                                                         ; 280c: f0 18       ..
    cmp #&20                                                          ; 280e: c9 20       .
    bne loop_c2806                                                    ; 2810: d0 f4       ..
    jsr kern_skip_spaces                                              ; 2812: 20 76 f8     v.
    ldx #0                                                            ; 2815: a2 00       ..
.loop_c2817
    lda l0100,y                                                       ; 2817: b9 00 01    ...
    sta l0100,x                                                       ; 281a: 9d 00 01    ...
    iny                                                               ; 281d: c8          .
    inx                                                               ; 281e: e8          .
    cmp #&0d                                                          ; 281f: c9 0d       ..
    bne loop_c2817                                                    ; 2821: d0 f4       ..
    jmp oscli                                                         ; 2823: 4c f7 ff    L..

.c2826
    rts                                                               ; 2826: 60          `

.pydis_end

save pydis_start, pydis_end
