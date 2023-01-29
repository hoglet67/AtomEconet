; Memory locations
blkd_d0_flag                        = &00d0
blkd_d1_port                        = &00d1
blkd_d2_stn_lo                      = &00d2
blkd_d3_stn_hi                      = &00d3
blkd_d4_buffer_start_lo             = &00d4
blkd_d5_buffer_start_hi             = &00d5
blkd_d6_buffer_end_lo               = &00d6
blkd_d7_buffer_end_hi               = &00d7
blke_ed_flag                        = &00ed
blke_ee_port                        = &00ee
blke_ef_stn_lo                      = &00ef
blke_f0_stn_hi                      = &00f0
blke_f6_imm1                        = &00f6
command_line                        = &0100
econet_clear_rxcbv_exists_flag      = &a690
econet_check_end_of_line            = &a6f1
econet_test_escape_in_z             = &a799
econet_transmit_blk_d0_with_retries = &a818
econet_set_rxcbv_to_x               = &a861
econet_read_stn_or_user             = &a873
econet_init_blk_ed                  = &ad2a
econet_transmit_blk_ed_with_retries = &ad3e
kern_print_string                   = &f7d1
kern_syn_error                      = &fa7d
kern_nvrdch                         = &fe94
oswrch                              = &fff4

    org &2800

.START
.pydis_start
    ldx #&d2
    ldy #7
    jsr econet_read_stn_or_user
    bne c280c
    jmp kern_syn_error

.c280c
    jsr econet_check_end_of_line
.c280f
    lda #&9c
    sta blkd_d0_flag
    lda #0
    sta blkd_d1_port
    sta blkd_d4_buffer_start_lo
    sta blkd_d5_buffer_start_hi
    sta blkd_d6_buffer_end_lo
    lda #2
    sta blkd_d7_buffer_end_hi
    lda #&ff
    ldy #&14
    jsr econet_transmit_blk_d0_with_retries
    ldx blkd_d2_stn_lo
    ldy blkd_d3_stn_hi
    jsr econet_init_blk_ed
.c282f
    lda #&7f
    sta blke_ed_flag
    lda #0
    sta blke_ee_port
    lda #&ed
    ldx #0
    jsr econet_set_rxcbv_to_x
.loop_c283e
    jsr econet_test_escape_in_z
    beq c2868
    lda blke_ed_flag
    bpl loop_c283e
    lda blke_ee_port
    cmp #&c1
    beq c2859
    cmp #&c0
    beq c2873
    lda blke_f6_imm1
    jsr oswrch
    jmp c282f

.c2859
    jsr kern_nvrdch
    sta blke_f6_imm1
    lda #&80
    sta blke_ed_flag
    jsr econet_transmit_blk_ed_with_retries
    jmp c282f

.c2868
    lda blke_ef_stn_lo
    sta blkd_d2_stn_lo
    lda blke_f0_stn_hi
    sta blkd_d3_stn_hi
    jmp c280f

.c2873
    jmp econet_clear_rxcbv_exists_flag

.pydis_end

save pydis_start, pydis_end
