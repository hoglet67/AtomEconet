; Memory locations
blkd_d0_flag                        = &00d0
command_line                        = &0100
fs_cmd_function_or_command_code     = &0117
fs_cmd_handle_root_or_return_code   = &0118
fs_cmd_handle_cwd                   = &0119
fs_cmd_handle_lib                   = &011a
fs_cmd_param0                       = &011b
fs_cmd_param1                       = &011c
econet_wait_response                = &a670
econet_file_server_send_command     = &a6bc
econet_fill_0110_013d_0d            = &a7c3
econet_file_server_init_command_y   = &a7f7
econet_set_fileserver_stn_in_d0     = &a80d
econet_set_rxcbv_to_d0              = &a85d
kern_print_string                   = &f7d1
oscrlf                              = &ffed
oswrch                              = &fff4

    org &2800

.START
.pydis_start
    lda #0
    sta pydis_end
.c2805
    lda pydis_end
    sta fs_cmd_param0
    lda #5
    sta fs_cmd_param1
    lda #7
    ldy #&0f
    jsr econet_file_server_init_command_y
    jsr econet_file_server_send_command
    ldx #8
.loop_c281c
    lda l28f2,x
    sta blkd_d0_flag,x
    dex
    bpl loop_c281c
    jsr econet_set_fileserver_stn_in_d0
    jsr econet_set_rxcbv_to_d0
    jsr econet_wait_response
    lda fs_cmd_function_or_command_code
    bne c2891
    ldy fs_cmd_handle_root_or_return_code
    beq c2891
    ldx #0
.c2839
    lda fs_cmd_handle_cwd,x
    pha
    lda fs_cmd_handle_lib,x
    pha
    ldy #4
.loop_c2843
    lda fs_cmd_param0,x
    jsr oswrch
    inx
    dey
    bne loop_c2843
    lda #&20
    jsr oswrch
    pla
    beq c285c
    jsr sub_c28a3
    lda #1
    bne c285e
.c285c
    lda #4
.c285e
    jsr sub_c2894
    pla
    jsr sub_c28a3
    lda #4
    jsr sub_c2894
    lda fs_cmd_param0,x
    php
    lda #&55
    plp
    beq c2875
    lda #&73
.c2875
    jsr oswrch
    txa
    clc
    adc #3
    tax
    jsr oscrlf
    dec fs_cmd_handle_root_or_return_code
    bne c2839
    clc
    lda pydis_end
    adc #5
    sta pydis_end
    jmp c2805

.c2891
    jmp econet_fill_0110_013d_0d

.sub_c2894
    sta l28a2
    lda #&20
.loop_c2899
    jsr oswrch
    dec l28a2
    bne loop_c2899
    rts

.l28a2
    equb 0

.sub_c28a3
    sta l28a2
    lda #0
    sta l28f1
    txa
    pha
    tya
    pha
    ldx #&2f
    lda l28a2
.loop_c28b4
    sbc #&64
    inx
    bcs loop_c28b4
    adc #&64
    pha
    txa
    jsr sub_c28de
    ldx #&2f
    pla
.loop_c28c3
    sbc #&0a
    inx
    bcs loop_c28c3
    adc #&0a
    pha
    txa
    jsr sub_c28de
    dec l28f1
    pla
    clc
    adc #&30
    jsr sub_c28de
    pla
    tay
    pla
    tax
    rts

.sub_c28de
    cmp #&30
    bne c28eb
    bit l28f1
    bmi c28ee
    lda #&20
    bne c28ee
.c28eb
    dec l28f1
.c28ee
    jmp oswrch

.l28f1
    equb 0
.l28f2
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0
.pydis_end

save pydis_start, pydis_end
