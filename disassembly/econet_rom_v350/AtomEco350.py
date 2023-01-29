from commands import *

from eco_common import *

# =======================================================================
# py8dis configuration
# =======================================================================

config.set_label_references(False)
config.set_show_char_literals(False)
config.set_show_autogenerated_labels(False)
#config.set_hex_dump(False)

# =======================================================================
# Load the program to be disassembled
# =======================================================================

load(0xa000, "AtomEco350.rom", "6502", "f499ed413146f59ed67e24e74a8188c2")

# =======================================================================
# Common with Library Code
# =======================================================================

add_common_labels()

# =======================================================================
# Labels
# =======================================================================

label(0xb000, "pia")
expr_label(0xb001, "pia + 1")
expr_label(0xb002, "pia + 2")
expr_label(0xb003, "pia + 3")

label(0x8000, "screen")
expr_label(0x800a, "screen + 10")
expr_label(0x8015, "screen + 21")
expr_label(0x8016, "screen + 22")
expr_label(0x801a, "screen + 26")
expr_label(0x801d, "screen + 29")
expr_label(0x801e, "screen + 30")
expr_label(0x801f, "screen + 31")

label(0xff9a, "kern_vectors")
expr_label(0xff9c, "kern_vectors + 2")
expr_label(0xffa1, "kern_vectors + 7")

label(0x0204, "irqvec")
expr_label(0x0205, "irqvec + 1")
label(0x0206, "comvec")
expr_label(0x0207, "comvec + 1")
label(0x0208, "wrcvec")
expr_label(0x0209, "wrcvec + 1")
label(0x020a, "rdcvec")
expr_label(0x020b, "rdcvec + 1")

# =======================================================================
# Internal symbols
# =======================================================================

entry(0xa000, "initialize")

entry(0xa0dc, "irq_handler")
expr(0xa02b, "<irq_handler")
expr(0xa030, ">irq_handler")

entry(0x021c, "irqvecl_old")
entry(0x021d, "irqvech_old")

label(0xa0ba, "do_rts")
pc=0xa07d
label(pc, "init_0238_023F")
expr_label(pc-1, "init_0238_023F-1")
wordentry(pc)
entry(pc + 5)

label(0xa085, "banner_version")
expr_label(0xa084, "banner_version-1")

label(0xa090, "banner_noclk")
expr_label(0xa08f, "banner_noclk-1")

# There is a curious block of JMP instructions at A700
#
# Investigate to see how they are reached
#
# May be an undocumented external entry point
#
# Preceded by two bytes of junk

entry(0xa700, "function0") # reached via JSR at a074
entry(0xa703, "function1") # ???
entry(0xa706, "function2") # ???
entry(0xa709, "function3") # ???
entry(0xa70c, "function4") # Reached via JMP (l00ba)
entry(0xa70f, "function5") # ???

entry(0xa712, "function6") # This looks like data
entry(0xa716, "function7") # Reached via JMP at function 4, also l00be

expr(0xa5cb, "<function4")
expr(0xa5cd, ">function4")

expr(0xa585, "<function6")
expr(0xa589, ">function6")

expr(0xa58d, "<function7")
expr(0xa591, ">function7")

# Other indirect code addresses

# Used via 022A/B
entry(0xa6d0, "error_handler1")
expr(0xafa6, "<error_handler1")
expr(0xafab, ">error_handler1")

# Used via 022A/B
entry(0xa8f9, "error_handler2")
expr(0xa6e6, "<error_handler2")
expr(0xa6e7, ">error_handler2")
expr(0xad57, "<error_handler2")
expr(0xad5c, ">error_handler2")

# Used via 022A/B
entry(0xad62, "error_handler3")
expr(0xad3f, "<error_handler3")
expr(0xad44, ">error_handler3")

# Used via 022A/B
entry(0xaf27, "error_handler4")
expr(0xaeba, "<error_handler4")
expr(0xaebf, ">error_handler4")


# Command Table at 0xACCD

pc = 0xaccd
label(pc, "command_table")
expr_label(pc + 1, "command_table + 1")
for i in range(7):
    pc = stringhi(pc)
    pc = code_ptr(pc + 1, pc, 1)
pc = code_ptr(pc + 1, pc, 1 )

entry(0xabf2, "cmd_I_AM")
entry(0xadd8, "cmd_NOTIFY")
entry(0xa750, "cmd_COS")
entry(0xad84, "cmd_ROFF")
entry(0xa79f, "cmd_UNKNOWN")

# Tx Cmd table at A42A

pc = 0xa4ab
label(pc, "tx_cmd_table_lo")
label(pc + 8, "tx_cmd_table_hi")

expr_label(0xa42a, "tx_cmd_table_lo-&81")
expr_label(0xa432, "tx_cmd_table_hi-&81")

for i in range(8):
    code_ptr(pc, pc + 8, 1)
    pc = pc + 1

label(0xa4bb, "tx_cmd_81_88_peek")
label(0xa4f7, "tx_cmd_82_poke")
label(0xa519, "tx_cmd_83_84_85_remote")
label(0xa535, "tx_cmd_86_87_halt_resume")

# Rx Cmd table at A573

pc = 0xa573
label(pc, "rx_cmd_table_lo")
label(pc + 8, "rx_cmd_table_hi")

expr_label(0xa4f2, "rx_cmd_table_lo-&81")
expr_label(0xa4fa, "rx_cmd_table_hi-&81")

for i in range(8):
    code_ptr(pc, pc + 8, 1)
    pc = pc + 1

label(0xa594, "rx_cmd_81_peek")
label(0xa5ad, "rx_cmd_82_poke")
label(0xa5d6, "rx_cmd_83_jsr")
label(0xa5c1, "rx_cmd_84_user_proc")
label(0xa5ca, "rx_cmd_85_os_proc")
label(0xa614, "rx_cmd_86_halt")
label(0xa630, "rx_cmd_87_resume")
label(0xa583, "rx_cmd_88_machine_peek")

# Vector Table at A772

pc=0xa772
label(pc, "vectors")
expr_label(pc + 2, "vectors + 2")
wordentry(pc, 11)

label(0xacf9, "eco_cli")
label(0xaf48, "eco_wrch")
label(0xae93, "eco_rdch")
label(0xaa95, "eco_load")
label(0xa9bb, "eco_save")
label(0xabc3, "eco_rdar")
label(0xaba3, "eco_star")
label(0xab7b, "eco_bget")
label(0xab5e, "eco_bput")
label(0xab25, "eco_find")
label(0xabe5, "eco_shut")

# Jump Table at A7D0

pc = 0xa7d0
label(pc, "fserv_table")

expr_label(0xa7ce, "fserv_table - 2")
expr_label(0xa7cf, "fserv_table - 1")

for i in range(9):
    pc = code_ptr(pc, pc + 1, 1)

label(0xa99f, "fserv_01_save")
label(0xaa72, "fserv_02_load")
label(0xac12, "fserv_03")
label(0xac8a, "fserv_04_info")
label(0xa93a, "fserv_05_sdisc_06_iam")
label(0xacbf, "fserv_07_dir")
label(0xacb2, "fserv_08_unrecognised")
label(0xacc6, "fserv_09_lib")

# Vector Table at AD80

pc = 0xad80
label(pc, "vectors_remote")
wordentry(pc, 2)
label(0xad6b, "start_remote")
label(0xadc2, "remote_wrch")
label(0xad9e, "remote_rdch")

# Unreachable code

entry(0xa6f1, "unreachable1")
entry(0xacf3, "unreachable2")

# Initializatiom data

label(0xa6ab, "init_00d0_00d7")
label(0xa6b3, "init_00d0_00d8")
label(0xa6ec, "init_00d4_00d9")
label(0xa6e4, "init_0228_022f")
label(0xac81, "init_00d0_00d8_alt1")
label(0xad39, "init_00f1_00f5")

label(0xaf35, "init_00d0_00d7_alt2")
label(0xaf39, "init_00d4_00d8_alt2")
label(0xaf3e, "init_0d00_0d09_alt2")

# Cosmetic

expr(0xa047, "'0' - 1")
expr(0xa054, "'0' - 1")
expr(0xa04a, "100")
expr(0xa04f, "100")


# Better labels

# Low Level uses #B0-#CF
#label(0x00b0, "")
#label(0x00b1, "")
#label(0x00b2, "")
#label(0x00b3, "")
#label(0x00b4, "")
#label(0x00b5, "")
#label(0x00b6, "")
#label(0x00b7, "")
#label(0x00b8, "")
#label(0x00b9, "")
#label(0x00ba, "")
#label(0x00bb, "")
#label(0x00bc, "")
#label(0x00bd, "")
#label(0x00be, "")
#label(0x00bf, "")
#label(0x00c0, "")
#label(0x00c1, "")
#label(0x00c2, "")
#label(0x00ca, "")

# High Level uses #D0-#DD
#label(0x00d0, "")
#label(0x00d1, "")
#label(0x00d2, "")
#label(0x00d3, "")
#label(0x00d4, "")
#label(0x00d5, "")
#label(0x00d6, "")
#label(0x00d7, "")
#label(0x00d8, "")
#label(0x00d9, "")
#label(0x00da, "")
#label(0x00db, "")
#label(0x00dc, "")


#Remove uses #ED-#F7
#label(0x00ed, "")
#label(0x00ee, "")
#label(0x00ef, "")
#label(0x00f0, "")
#label(0x00f1, "")
#label(0x00f6, "")


label(0x00fe, "char_not_sent_to_printer")
label(0x00ff, "temp_sp")




#label(0x0223, "")
label(0x0224, "handle_urd") # User Root Directory
label(0x0225, "handle_csd") # Current Selected Directory
label(0x0226, "handle_lib") # Library Directory
label(0x0227, "sequenceno")
label(0x0228, "notifying_stn")
expr_label(0x0229, "notifying_stn + 1")
label(0x022a, "error_handler")
expr_label(0x022b, "error_handler + 1")
label(0x022c, "fileserver_stn")
expr_label(0x022d, "fileserver_stn + 1")
label(0x022e, "printserver_stn")
expr_label(0x022f, "printserver_stn + 1")
label(0x0230, "rxcbv")
expr_label(0x0231, "rxcbv + 1")
label(0x0236, "internal0")
label(0x0237, "internal1")
label(0x0238, "proc_jmp_ind")
expr_label(0x0239, "proc_jmp_ind + 1")
label(0x023a, "flags")
label(0x023d, "transmit")

label(0xa2ee, "transmit_handler")

# TODO:

# There is a lump of string data at A63C-A657 that doesn't seem to be used


# Use all the information provided to actually disassemble the program.
go()
