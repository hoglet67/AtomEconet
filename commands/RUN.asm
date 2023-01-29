; Memory locations
command_line        = &0100
kern_print_string   = &f7d1
kern_skip_spaces    = &f876
oscli               = &fff7

    org &2800

.START
.pydis_start
    ldy #0
    jsr kern_skip_spaces
    dey
.loop_c2806
    iny
    lda command_line,y
    cmp #&0d
    beq c2826
    cmp #&20
    bne loop_c2806
    jsr kern_skip_spaces
    ldx #0
.loop_c2817
    lda command_line,y
    sta command_line,x
    iny
    inx
    cmp #&0d
    bne loop_c2817
    jmp oscli

.c2826
    rts

.pydis_end

save pydis_start, pydis_end
