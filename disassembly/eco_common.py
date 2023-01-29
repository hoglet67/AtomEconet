from commands import *

# =======================================================================
# Custom Label Makes
# =======================================================================

def our_label_maker(addr, context, suggestion):
    # TODO: I haven't worried about runtime vs binary addrs here; this only
    # matters if move() is used, but if this code gets promoted into the
    # "standard library" this needs thinking about.
    if disassembly.is_code(context - 1):
        opcode_value = memory[context - 1]
        opcode_obj = trace.cpu.opcodes.get(opcode_value)
        if opcode_obj is not None:
            if opcode_obj.mnemonic in ("STA", "STX", "STY"):
                if addr == 0xb400:
                    return "reg_adlc_control1"
                if addr == 0xb401:
                    return "reg_adlc_control23"
                if addr == 0xb402:
                    return "reg_adlc_txdata"
                if addr == 0xb403:
                    return "reg_adlc_control4"

    return None

# =======================================================================
# Labels that need to be common between ROM and Library Commands
# =======================================================================

def add_common_labels():

    set_label_maker_hook(our_label_maker)

    optional_label(0xb400, "reg_adlc_status1")
    optional_label(0xb401, "reg_adlc_status2")
    optional_label(0xb402, "reg_adlc_rxdata")
    optional_label(0xb404, "reg_stationid")

    label(0x0100, "command_line")
    for i in range(5):
        expr_label(0x0100+i, "command_line+"+str(i))


    # Read variants
    optional_label(0x0116, "fs_cmd_reply_port")
    optional_label(0x0117, "fs_cmd_function_or_command_code")
    optional_label(0x0118, "fs_cmd_handle_root_or_return_code")
    optional_label(0x0119, "fs_cmd_handle_cwd")
    optional_label(0x011A, "fs_cmd_handle_lib")
    optional_label(0x011B, "fs_cmd_param0")
    optional_label(0x011C, "fs_cmd_param1")
    optional_label(0x011D, "fs_cmd_param2")
    optional_label(0x011E, "fs_cmd_param3")
    optional_label(0x011F, "fs_cmd_param4")

    optional_label(0xa658, "econet_file_server_send_command_wait_response")
    optional_label(0xa670, "econet_wait_response")
    optional_label(0xa690, "econet_clear_rxcbv_exists_flag")
    optional_label(0xa6bc, "econet_file_server_send_command")
    optional_label(0xa6f1, "econet_check_end_of_line")
    optional_label(0xa788, "econet_osasci_string_011a")
    optional_label(0xa799, "econet_test_escape_in_z")
    optional_label(0xa7c3, "econet_fill_0110_013d_0d")
    optional_label(0xa7f7, "econet_file_server_init_command_y")
    optional_label(0xa80d, "econet_set_fileserver_stn_in_d0")
    optional_label(0xa818, "econet_transmit_blk_d0_with_retries")
    optional_label(0xa81a, "econet_transmit_blk_x_with_retries")
    optional_label(0xa83c, "econet_error_a")
    optional_label(0xa848, "econey_delay_approx_y_ms")
    optional_label(0xa85d, "econet_set_rxcbv_to_d0")
    optional_label(0xa861, "econet_set_rxcbv_to_x")
    optional_label(0xa873, "econet_read_stn_or_user")
    optional_label(0xad2a, "econet_init_blk_ed")
    optional_label(0xad3e, "econet_transmit_blk_ed_with_retries")

    hook_subroutine(0xF7D1, "kern_print_string", stringhi_hook)
    optional_label(0xffe9, "osasci")
    optional_label(0xffed, "oscrlf")
    optional_label(0xfff4, "oswrch")
    optional_label(0xfff7, "oscli")
    optional_label(0xf876, "kern_skip_spaces")
    optional_label(0xf8ef, "kern_cli_handler")
    optional_label(0xfa7d, "kern_syn_error")
    optional_label(0xfe55, "kern_nvwrch")
    optional_label(0xfe94, "kern_nvrdch")

    optional_label(0xb000, "pia")

    optional_label(0xc2ca, "basic_warm_start")

    optional_label(0x023b, "prot_mask")

    optional_label(0x00d0, "blkd_d0_flag")
    optional_label(0x00d1, "blkd_d1_port")
    optional_label(0x00d2, "blkd_d2_stn_lo")
    optional_label(0x00d3, "blkd_d3_stn_hi")
    optional_label(0x00d4, "blkd_d4_buffer_start_lo")
    optional_label(0x00d5, "blkd_d5_buffer_start_hi")
    optional_label(0x00d6, "blkd_d6_buffer_end_lo")
    optional_label(0x00d7, "blkd_d7_buffer_end_hi")
    optional_label(0x00d8, "blkd_d8_imm0")
    optional_label(0x00d9, "blkd_d9_imm1")
    #optional_label(0x00da, "blkd_da_imm2")

    optional_label(0x00ed, "blke_ed_flag")
    optional_label(0x00ee, "blke_ee_port")
    optional_label(0x00ef, "blke_ef_stn_lo")
    optional_label(0x00f0, "blke_f0_stn_hi")
    optional_label(0x00f1, "blke_f1_buffer_start_lo")
    optional_label(0x00f2, "blke_f2_buffer_start_hi")
    optional_label(0x00f3, "blke_f3_buffer_end_lo")
    optional_label(0x00f4, "blke_f4_buffer_end_hi")
    optional_label(0x00f5, "blke_f5_imm0")
    optional_label(0x00f6, "blke_f6_imm1")
    #optional_label(0x00f7, "blke_f7_imm2")
