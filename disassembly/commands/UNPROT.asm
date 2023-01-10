; Memory locations
l023b               = &023b
kern_print_string   = &f7d1

    org &2800

.START
.pydis_start
    lda #0                                                            ; 2800: a9 00       ..
    sta l023b                                                         ; 2802: 8d 3b 02    .;.
    rts                                                               ; 2805: 60          `

.pydis_end

save pydis_start, pydis_end
