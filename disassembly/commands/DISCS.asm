; Memory locations
blkd_d0_flag                        = &00d0
command_line                        = &0100
fs_cmd_reply_port                   = &0116
fs_cmd_function_or_command_code     = &0117
fs_cmd_handle_root_or_return_code   = &0118
fs_cmd_handle_cwd                   = &0119
fs_cmd_handle_lib                   = &011a
fs_cmd_param0                       = &011b
fs_cmd_param1                       = &011c
econet_wait_response                = &a670
econet_file_server_send_command     = &a6bc
econet_file_server_init_command_y   = &a7f7
econet_set_fileserver_stn_in_d0     = &a80d
econet_error_a                      = &a83c
econet_set_rxcbv_to_d0              = &a85d
kern_print_string                   = &f7d1
oscrlf                              = &ffed
oswrch                              = &fff4

    org &2800

.START
.pydis_start
    jsr kern_print_string
    equs "DISC NAME         DRIVE"

    nop
    jsr oscrlf
    jsr oscrlf
    lda #0
    sta pydis_end
.c2826
    lda pydis_end
    sta fs_cmd_param0
    lda #&b1
    sta fs_cmd_param1
    lda #7
    ldy #&0e
    jsr econet_file_server_init_command_y
    jsr econet_file_server_send_command
    ldx #8
.loop_c283d
    lda l28a8,x
    sta blkd_d0_flag,x
    dex
    bpl loop_c283d
    jsr econet_set_fileserver_stn_in_d0
    jsr econet_set_rxcbv_to_d0
    jsr econet_wait_response
    lda fs_cmd_function_or_command_code
    pha
    beq c2865
    ldx #2
.loop_c2856
    lda fs_cmd_reply_port,x
    sta fs_cmd_handle_cwd,x
    inx
    cmp #&0d
    bne loop_c2856
    pla
    jmp econet_error_a

.c2865
    pla
    ldy fs_cmd_handle_root_or_return_code
    beq c28a7
    ldx #0
.c286d
    lda fs_cmd_handle_cwd,x
    pha
    ldy #&10
.loop_c2873
    lda fs_cmd_handle_lib,x
    jsr oswrch
    inx
    dey
    bne loop_c2873
    lda #&20
    jsr oswrch
    jsr oswrch
    jsr oswrch
    jsr oswrch
    pla
    clc
    adc #&30
    jsr oswrch
    jsr oscrlf
    inx
    dec fs_cmd_handle_root_or_return_code
    bne c286d
    clc
    lda pydis_end
    adc #&b1
    sta pydis_end
    jmp c2826

.c28a7
    rts

.l28a8
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0
.pydis_end

save pydis_start, pydis_end
