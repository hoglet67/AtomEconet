; Memory locations
blkd_d0_flag                        = &00d0
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
command_line                        = &0100
pia                                 = &b000
kern_print_string                   = &f7d1
kern_syn_error                      = &fa7d

include "econet.inc"

    org &2800

.START
.pydis_start
    php
    ldx #&da
    ldy #4
    jsr econet_read_stn_or_user
    bne c280d
    jmp kern_syn_error

.c280d
    jsr econet_check_end_of_line
    ldx #9
.loop_c2812
    lda l2872,x
    sta blkd_d0_flag,x
    dex
    bpl loop_c2812
    lda l00da
    sta blkd_d2_stn_lo
    lda l00db
    sta blkd_d3_stn_hi
    ldx #&d0
    ldy #&14
    lda #&ff
    jsr econet_transmit_blk_x_with_retries
    lda l00db
    and #&f0
    bne c2836
    lda #&82
    jmp c283f

.c2836
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    tax
    lda l286a,x
.c283f
    sta blkd_d7_buffer_end_hi
    ldx #0
    stx blkd_d4_buffer_start_lo
    stx blkd_d6_buffer_end_lo
    stx blkd_d8_imm0
    lda #&80
    sta blkd_d9_imm1
    sta blkd_d5_buffer_start_hi
    ;; The PEEK command changed from 84 in Econet v2 to 81 in Econet v3
    lda #&81
    sta blkd_d0_flag
    ldx #&d0
    ldy #&14
    lda #&ff
    jsr econet_transmit_blk_x_with_retries
    lda #&f0
    and l00db
    sta pia
    ldy #&d0
    jsr econet_delay_approx_y_ms
    plp
    rts

.l286a
    equb &84, &84, &88, &86, &8c, &8c, &98, &98
.l2872
    ;; The PEEK command changed from 84 in Econet v2 to 81 in Econet v3
    equb &81,   0,   0,   0, &db,   0, &dc,   0,   0, &b0
.pydis_end

save pydis_start, pydis_end
