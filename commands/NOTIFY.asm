include "econet.inc"

command_line                        = &0100
blkd_d0_flag                        = &00d0
blkd_d1_port                        = &00d1
blkd_d2_stn_lo                      = &00d2
blkd_d3_stn_hi                      = &00d3
blkd_d4_buffer_start_lo             = &00d4
blkd_d5_buffer_start_hi             = &00d5
blkd_d6_buffer_end_lo               = &00d6
blkd_d7_buffer_end_hi               = &00d7
blkd_d8_imm0                        = &00d8
blkd_d9_imm1                        = &00d9
l00da                               = &00da
l00db                               = &00db
kern_print_string                   = &f7d1
kern_skip_spaces                    = &f876

    org &2800

.START
.pydis_start

.cmd_NOTIFY
    ldx #&da
    ldy #7
    jsr econet_read_stn_or_user
    bne cade2
    jmp econet_syn_error

.cade2
    jsr kern_skip_spaces
    ldx #0
.loop_cade7
    lda command_line,y
    sta command_line,x
    inx
    iny
    cmp #&0d
    bne loop_cade7
    txa
    pha
    ldx #9
.loop_cadf7
    lda init_0d00_0d09_alt2,x
    sta blkd_d0_flag,x
    dex
    bpl loop_cadf7
    lda l00da
    sta blkd_d2_stn_lo
    lda l00db
    sta blkd_d3_stn_hi
    lda #&20
    ldy #&14
    jsr econet_transmit_blk_d0_with_retries
    lda l00da
    beq cae1b
    jsr kern_print_string
    equs "BUSY"
    nop
    brk

.cae1b
    ldx #0
    stx blkd_d9_imm1
    inx
    stx blkd_d8_imm0
    ldx #3
.loop_cae24
    lda init_00d4_00d8_alt2,x
    sta blkd_d4_buffer_start_lo,x
    dex
    bpl loop_cae24
    lda #&85
    sta blkd_d0_flag
    lda #&20
    ldy #&14
    jsr econet_transmit_blk_d0_with_retries
    ldx #4
.loop_cae39
    lda init_00d4_00d8_alt2,x
    sta blkd_d4_buffer_start_lo,x
    dex
    bpl loop_cae39
    lda #&7f
    sta blkd_d0_flag
    jsr econet_set_rxcbv_to_d0
.loop_cae48
    jsr econet_test_escape_in_z
    beq cae8e
    lda blkd_d0_flag
    bpl loop_cae48
    jsr econet_clear_rxcbv_exists_flag
    lda #0
    sta blkd_d4_buffer_start_lo
    lda #1
    sta blkd_d5_buffer_start_hi
    pla
    sta l00db
    lda #0
    pha
.cae62
    lda l00da
    clc
    adc blkd_d4_buffer_start_lo
    sta blkd_d6_buffer_end_lo
    lda #0
    adc blkd_d5_buffer_start_hi
    sta blkd_d7_buffer_end_hi
    lda #&80
    sta blkd_d0_flag
    lda #&ff
    ldy #2
    jsr econet_transmit_blk_d0_with_retries
    pla
    clc
    adc l00da
    cmp l00db
    bcs cae92
    pha
    lda blkd_d6_buffer_end_lo
    sta blkd_d4_buffer_start_lo
    lda blkd_d7_buffer_end_hi
    sta blkd_d5_buffer_start_hi
    jmp cae62

.cae8e
    jsr econet_clear_rxcbv_exists_flag
    pla

.cae92
    rts

.init_00d4_00d8_alt2
    equb &da,   0, &db,   0,   0
.init_0d00_0d09_alt2
    equb &81,   0,   0,   0, &da,   0, &db,   0, &28,   2

.pydis_end

save pydis_start, pydis_end
