; Memory locations
blkd_d0_flag                                    = &00d0
command_line                                    = &0100
fs_cmd_reply_port                               = &0116
fs_cmd_function_or_command_code                 = &0117
fs_cmd_handle_root_or_return_code               = &0118
fs_cmd_handle_cwd                               = &0119
fs_cmd_param0                                   = &011b
fs_cmd_param1                                   = &011c
fs_cmd_param2                                   = &011d
fs_cmd_param3                                   = &011e
econet_file_server_send_command_wait_response   = &a658
econet_wait_response                            = &a670
econet_file_server_send_command                 = &a6bc
econet_osasci_string_011a                       = &a788
econet_fill_0110_013d_0d                        = &a7c3
econet_file_server_init_command_y               = &a7f7
econet_set_fileserver_stn_in_d0                 = &a80d
econet_error_a                                  = &a83c
econet_set_rxcbv_to_d0                          = &a85d
kern_print_string                               = &f7d1
osasci                                          = &ffe9
oscrlf                                          = &ffed

    org &2800

.START
.pydis_start
    ldy #&ff
.loop_c2802
    iny
    lda command_line+4,y
    cmp #&20
    beq loop_c2802
    ldx #0
.loop_c280c
    lda command_line+4,y
    sta pydis_end,x
    sta fs_cmd_param0,x
    iny
    inx
    cmp #&0d
    bne loop_c280c
    tya
    clc
    adc #5
    ldy #4
    jsr econet_file_server_send_command_wait_response
    jsr sub_c2899
    jsr oscrlf
    lda #0
.c282c
    pha
    sta fs_cmd_param1
    lda #1
    sta fs_cmd_param0
    lda #1
    sta fs_cmd_param2
    ldx #0
.loop_c283c
    lda pydis_end,x
    sta fs_cmd_param3,x
    inx
    cmp #&0d
    bne loop_c283c
    txa
    clc
    adc #8
    ldy #3
    jsr econet_file_server_init_command_y
    jsr econet_file_server_send_command
    ldx #8
.loop_c2855
    lda l2890,x
    sta blkd_d0_flag,x
    dex
    bpl loop_c2855
    jsr econet_set_fileserver_stn_in_d0
    jsr econet_set_rxcbv_to_d0
    jsr econet_wait_response
    lda fs_cmd_function_or_command_code
    beq c287d
    ldx #2
    pha
.loop_c286e
    lda fs_cmd_reply_port,x
    sta fs_cmd_handle_cwd,x
    inx
    cmp #&0d
    bne loop_c286e
    pla
    jmp econet_error_a

.c287d
    lda fs_cmd_handle_root_or_return_code
    beq c288c
    jsr econet_osasci_string_011a
    pla
    clc
    adc #1
    jmp c282c

.c288c
    pla
    jmp econet_fill_0110_013d_0d

.l2890
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0

.sub_c2899
    ldx #0
.loop_c289b
    lda fs_cmd_param0,x
    bmi c28a6
    jsr osasci
    inx
    bne loop_c289b
.c28a6
    rts

.pydis_end

save pydis_start, pydis_end
