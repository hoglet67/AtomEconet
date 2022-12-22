from commands import *

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

set_label_maker_hook(our_label_maker)

label(0xb400, "reg_adlc_status1")
label(0xb401, "reg_adlc_status2")
label(0xb402, "reg_adlc_rxdata")

label(0xb404, "reg_stationid")

# =======================================================================
# External Symbols
# =======================================================================

label(0x0204, "irqvec")
expr_label(0x0205, "irqvec + 1")
label(0x0206, "comvec")
expr_label(0x0207, "comvec + 1")
label(0x0208, "wrcvec")
expr_label(0x0209, "wrcvec + 1")
label(0x020a, "rdcvec")
expr_label(0x020b, "rdcvec + 1")

label(0xffe9, "osasci")
label(0xffed, "oscrlf")
label(0xfff4, "oswrch")

label(0x8000, "screen")
expr_label(0x800a, "screen + 10")
expr_label(0x8015, "screen + 21")
expr_label(0x8016, "screen + 22")
expr_label(0x801a, "screen + 26")
expr_label(0x801d, "screen + 29")
expr_label(0x801e, "screen + 30")
expr_label(0x801f, "screen + 31")

label(0xb000, "pia")
expr_label(0xb001, "pia + 1")
expr_label(0xb002, "pia + 2")
expr_label(0xb003, "pia + 3")


label(0xc2ca, "basic_warm_start")

hook_subroutine(0xF7D1, "kern_print_string", stringhi_hook)
label(0xf876, "kern_skip_spaces")
label(0xf8ef, "kern_cli_handler")
label(0xfa7d, "kern_syn_error")
label(0xfe55, "kern_nvwrch")
label(0xfe94, "kern_nvrdch")
label(0xff9a, "kern_vectors")
expr_label(0xff9c, "kern_vectors + 2")
expr_label(0xffa1, "kern_vectors + 7")

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
entry(0xa6d0, "handler1")
expr(0xafa6, "<handler1")
expr(0xafab, ">handler1")

# Used via 022A/B
entry(0xa8f9, "handler2")
expr(0xa6e6, "<handler2")
expr(0xa6e7, ">handler2")
expr(0xad57, "<handler2")
expr(0xad5c, ">handler2")

# Used via 022A/B
entry(0xad62, "handler3")
expr(0xad3f, "<handler3")
expr(0xad44, ">handler3")

# Used via 022A/B
entry(0xaf27, "handler4")
expr(0xaeba, "<handler4")
expr(0xaebf, ">handler4")


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

# Jump table at A42A

pc = 0xa4ab
label(pc, "jump1_table_lo")
label(pc + 8, "jump1_table_hi")

expr_label(0xa42a, "jump1_table_lo-&81")
expr_label(0xa432, "jump1_table_hi-&81")

for i in range(8):
    code_ptr(pc, pc + 8, 1)
    pc = pc + 1

label(0xa4bb, "jump1_81_88")
label(0xa4f7, "jump1_82")
label(0xa519, "jump1_83_84_85")
label(0xa535, "jump1_86_87")

# Jump table at A573

pc = 0xa573
label(pc, "jump2_table_lo")
label(pc + 8, "jump2_table_hi")

expr_label(0xa4f2, "jump2_table_lo-&81")
expr_label(0xa4fa, "jump2_table_hi-&81")

for i in range(8):
    code_ptr(pc, pc + 8, 1)
    pc = pc + 1

label(0xa594, "jump2_81")
label(0xa5ad, "jump2_82")
label(0xa5d6, "jump2_83")
label(0xa5c1, "jump2_84")
label(0xa5ca, "jump2_85")
label(0xa614, "jump2_86")
label(0xa630, "jump2_87")
label(0xa583, "jump2_88")

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
label(pc, "jump3_table")

expr_label(0xa7ce, "jump3_table - 2")
expr_label(0xa7cf, "jump3_table - 1")

for i in range(9):
    pc = code_ptr(pc, pc + 1, 1)

label(0xa99f, "jump3_00")
label(0xaa72, "jump3_01")
label(0xac12, "jump3_02")
label(0xac8a, "jump3_03")
label(0xa93a, "jump3_04_05")
label(0xacbf, "jump3_06")
label(0xacb2, "jump3_07")
label(0xacc6, "jump3_08")

# Vector Table at AD80

pc = 0xad80
label(pc, "vectors2")
wordentry(pc, 2)
label(0xadc2, "eco_wrch2")
label(0xad9e, "eco_rdch2")

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


# TODO:

# There is a lump of string data at A63C-A657 that doesn't seem to be used


# Use all the information provided to actually disassemble the program.
go()
