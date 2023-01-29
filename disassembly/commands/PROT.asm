; Memory locations
command_line        = &0100
prot_mask           = &023b
kern_print_string   = &f7d1

    org &2800

.START
.pydis_start
    lda #7
    sta prot_mask
    rts

.pydis_end

save pydis_start, pydis_end
