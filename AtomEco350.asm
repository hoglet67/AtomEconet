BASE =? &A000

IO =? &B400

ATOMMCHDR =? FALSE

; Memory locations
l0000                               = &0000
l0001                               = &0001
l0002                               = &0002
l0003                               = &0003
l0004                               = &0004
l0006                               = &0006
l0007                               = &0007
l0008                               = &0008
l0009                               = &0009
l00b0                               = &00b0
l00b1                               = &00b1
l00b2                               = &00b2
l00b3                               = &00b3
l00b4                               = &00b4
l00b5                               = &00b5
l00b6                               = &00b6
l00b7                               = &00b7
l00b8                               = &00b8
l00b9                               = &00b9
l00ba                               = &00ba
l00bb                               = &00bb
l00bc                               = &00bc
l00bd                               = &00bd
l00be                               = &00be
l00bf                               = &00bf
l00c0                               = &00c0
l00c1                               = &00c1
l00c2                               = &00c2
l00ca                               = &00ca
blkd_d0_flag                        = &00d0
blkd_d1_port                        = &00d1
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
l00dc                               = &00dc
blke_ed_flag                        = &00ed
blke_ee_port                        = &00ee
blke_ef_stn_lo                      = &00ef
blke_f0_stn_hi                      = &00f0
blke_f1_buffer_start_lo             = &00f1
blke_f6_imm1                        = &00f6
char_not_sent_to_printer            = &00fe
temp_sp                             = &00ff
command_line                        = &0100
l0110                               = &0110
l0111                               = &0111
l0112                               = &0112
l0113                               = &0113
l0114                               = &0114
l0115                               = &0115
fs_cmd_reply_port                   = &0116
fs_cmd_function_or_command_code     = &0117
fs_cmd_handle_root_or_return_code   = &0118
fs_cmd_handle_cwd                   = &0119
fs_cmd_handle_lib                   = &011a
fs_cmd_param0                       = &011b
fs_cmd_param1                       = &011c
fs_cmd_param2                       = &011d
fs_cmd_param4                       = &011f
l0120                               = &0120
l0123                               = &0123
l0124                               = &0124
l013c                               = &013c
l013d                               = &013d
l013e                               = &013e
l013f                               = &013f
l0148                               = &0148
l0157                               = &0157
irqvec                              = &0204
comvec                              = &0206
wrcvec                              = &0208
rdcvec                              = &020a
irqvecl_old                         = &021c
irqvech_old                         = &021d
l0223                               = &0223
handle_urd                          = &0224
handle_csd                          = &0225
handle_lib                          = &0226
sequenceno                          = &0227
notifying_stn                       = &0228
error_handler                       = &022a
fileserver_stn                      = &022c
printserver_stn                     = &022e
rxcbv                               = &0230
internal0                           = &0236
internal1                           = &0237
proc_jmp_ind                        = &0238
flags                               = &023a
prot_mask                           = &023b
transmit                            = &023d
fkidx                               = &03ca         ; B - fake key index
l48ac                               = &48ac
screen                              = &8000
pia                                 = &b000
reg_adlc_control1                   = IO
reg_adlc_status1                    = IO
reg_adlc_control23                  = IO + 1
reg_adlc_status2                    = IO + 1
reg_adlc_rxdata                     = IO + 2
reg_adlc_txdata                     = IO + 2
reg_adlc_control4                   = IO + 3
reg_stationid                       = IO + 4
basic_warm_start                    = &c2ca
kern_print_string                   = &f7d1
kern_skip_spaces                    = &f876
kern_cli_handler                    = &f8ef
kern_syn_error                      = &fa7d
kern_nvwrch                         = &fe55
kern_nvrdch                         = &fe94
kern_vectors                        = &ff9a
osasci                              = &ffe9
oscrlf                              = &ffed
oswrch                              = &fff4

if ATOMMCHDR
    org BASE-22
.pydis_start
    EQUS "ECO350"+STR$~(BASE DIV &1000)
    org BASE-6
    EQUW BASE
    EQUW BASE
    EQUW &1000
ELSE
    org BASE
.pydis_start
ENDIF

    guard BASE + $1000

.initialize
    bit pia + 1                                                       ; a000: 2c 01 b0    ,..
IF (BASE = &A000)
    ;; the original Econet ROM uses SHIFT to bypass initialization
    bmi ca00f                                                         ; a003: 30 0a       0.
ELSE
    ;; our E000 version uses CTRL, like AtoMMC
    bvs ca00f                                                         ; a003: 30 0a       0.
ENDIF
    jsr sub_ca095                                                     ; a005: 20 95 a0     ..
    lda #&c0                                                          ; a008: a9 c0       ..
    sta reg_adlc_control1                                             ; a00a: 8d 00 b4    ...
IF (BASE = &A000)
    pla                                                               ; a00d: 68          h
    rti                                                               ; a00e: 40          @
ELSE
    bne warm_start_basic
ENDIF

.ca00f
    tya                                                               ; a00f: 98          .
    pha                                                               ; a010: 48          H
    txa                                                               ; a011: 8a          .
    pha                                                               ; a012: 48          H
    ldx #8                                                            ; a013: a2 08       ..
.loop_ca015
    lda init_0238_023F-1,x                                            ; a015: bd 7c a0    .|.
    sta internal1,x                                                   ; a018: 9d 37 02    .7.
    dex                                                               ; a01b: ca          .
    bne loop_ca015                                                    ; a01c: d0 f7       ..
IF (BASE <> &a000)
    ;; Zero the fake key index, used by the Shift-BREAK *MENU code
    stx fkidx
ENDIF
    lda irqvec                                                        ; a01e: ad 04 02    ...
    sta irqvecl_old                                                   ; a021: 8d 1c 02    ...
    lda irqvec + 1                                                    ; a024: ad 05 02    ...
    sta irqvech_old                                                   ; a027: 8d 1d 02    ...
    lda #<irq_handler                                                 ; a02a: a9 dc       ..
    sta irqvec                                                        ; a02c: 8d 04 02    ...
    lda #>irq_handler                                                 ; a02f: a9 a0       ..
    sta irqvec + 1                                                    ; a031: 8d 05 02    ...
    jsr sub_ca095                                                     ; a034: 20 95 a0     ..
    ldx #&0b                                                          ; a037: a2 0b       ..
.loop_ca039
    lda banner_version-1,x                                            ; a039: bd 84 a0    ...
    sta screen + 10,x                                                 ; a03c: 9d 0a 80    ...
    dex                                                               ; a03f: ca          .
    bne loop_ca039                                                    ; a040: d0 f7       ..
    cld                                                               ; a042: d8          .
    lda reg_stationid                                                 ; a043: ad 04 b4    ...
    ldx #'0' - 1                                                      ; a046: a2 2f       ./
    sec                                                               ; a048: 38          8
.loop_ca049
    sbc #100                                                          ; a049: e9 64       .d
    inx                                                               ; a04b: e8          .
    bcs loop_ca049                                                    ; a04c: b0 fb       ..
    adc #100                                                          ; a04e: 69 64       id
    stx screen + 29                                                   ; a050: 8e 1d 80    ...
    ldx #'0' - 1                                                      ; a053: a2 2f       ./
.loop_ca055
    sbc #&0a                                                          ; a055: e9 0a       ..
    inx                                                               ; a057: e8          .
    bcs loop_ca055                                                    ; a058: b0 fb       ..
    adc #&3a                                                          ; a05a: 69 3a       i:
    stx screen + 30                                                   ; a05c: 8e 1e 80    ...
    sta screen + 31                                                   ; a05f: 8d 1f 80    ...
    lda #&20                                                          ; a062: a9 20       .
    and reg_adlc_status2                                              ; a064: 2d 01 b4    -..
    beq ca074                                                         ; a067: f0 0b       ..
    ldx #5                                                            ; a069: a2 05       ..
.loop_ca06b
    lda banner_noclk-1,x                                              ; a06b: bd 8f a0    ...
    sta screen + 22,x                                                 ; a06e: 9d 16 80    ...
    dex                                                               ; a071: ca          .
    bne loop_ca06b                                                    ; a072: d0 f7       ..
.ca074
    jsr function0                                                     ; a074: 20 00 a7     ..

IF (BASE <> &A000)
    ;; Test the CTRL key
    bit   pia + 1
    bmi   unpatched
    ;; Revector to fake the entry of *MENU
    lda   #<osrdchmenu
    sta   rdcvec
    lda   #>osrdchmenu
    sta   rdcvec+1
.unpatched
ENDIF
    pla                                                               ; a077: 68          h
    tax                                                               ; a078: aa          .
    pla                                                               ; a079: 68          h
    tay                                                               ; a07a: a8          .
IF (BASE = &A000)
    pla                                                               ; a07b: 68          h
    rti                                                               ; a07c: 40          @
ELSE
.warm_start_basic
    jmp $c2b2

.osrdchmenu
   php
   cld
   stx   $e4
   sty   $e5

   ldx   fkidx
   lda   fakekeys,x
   beq   restore_rdch

   inc   fkidx

   ldx   $e4
;  ldy   $e5  ; not needed, because Y is not changed
   plp
   rts

.restore_rdch
   jsr   function0
   lda   #$0d
   pha
   jmp   $fe5c

.fakekeys
   EQUS "*MENU"
   EQUB 0
ENDIF

.init_0238_023F
    equw do_rts                                                       ; a07d: ba a0       ..
    equb 0, 0, 2                                                      ; a07f: 00 00 02    ...

    jmp transmit_handler                                              ; a082: 4c ee a2    L..

.banner_version
    equb   5,   3, &0f, &0e,   5, &14                                 ; a085: 05 03 0f... ...
    equs " 3.5"                                                       ; a08b: 20 33 2e...  3.
    equb &30                                                          ; a08f: 30          0
.banner_noclk
    equb &8e, &8f, &83, &8c, &8b                                      ; a090: 8e 8f 83... ...

.sub_ca095
    lda #&c2                                                          ; a095: a9 c2       ..
    sta l00b2                                                         ; a097: 85 b2       ..
    lda #&ff                                                          ; a099: a9 ff       ..
    sta l00b3                                                         ; a09b: 85 b3       ..
    lda #1                                                            ; a09d: a9 01       ..
    sta l00b0                                                         ; a09f: 85 b0       ..
.sub_ca0a1
    lda #&c1                                                          ; a0a1: a9 c1       ..
    sta reg_adlc_control1                                             ; a0a3: 8d 00 b4    ...
    lda #&1e                                                          ; a0a6: a9 1e       ..
    sta reg_adlc_control4                                             ; a0a8: 8d 03 b4    ...
    lda #&80                                                          ; a0ab: a9 80       ..
    sta reg_adlc_control23                                            ; a0ad: 8d 01 b4    ...
.ca0b0
    lda #2                                                            ; a0b0: a9 02       ..
    sta reg_adlc_control1                                             ; a0b2: 8d 00 b4    ...
.ca0b5
    lda #&63                                                          ; a0b5: a9 63       .c
    sta reg_adlc_control23                                            ; a0b7: 8d 01 b4    ...
.do_rts
    rts                                                               ; a0ba: 60          `

.ca0bb
    lda #&10                                                          ; a0bb: a9 10       ..
.loop_ca0bd
    bit reg_adlc_control1                                             ; a0bd: 2c 00 b4    ,..
    beq loop_ca0bd                                                    ; a0c0: f0 fb       ..
    rts                                                               ; a0c2: 60          `

.loop_ca0c3
    jmp (irqvecl_old)                                                 ; a0c3: 6c 1c 02    l..

.ca0c6
    lda #4                                                            ; a0c6: a9 04       ..
    and reg_adlc_status2                                              ; a0c8: 2d 01 b4    -..
    bne ca0d0                                                         ; a0cb: d0 03       ..
.ca0cd
    jsr sub_ca0a1                                                     ; a0cd: 20 a1 a0     ..
.ca0d0
    jsr ca0b5                                                         ; a0d0: 20 b5 a0     ..
    pla                                                               ; a0d3: 68          h
    rti                                                               ; a0d4: 40          @

.ca0d5
    lda #&22                                                          ; a0d5: a9 22       ."
    sta reg_adlc_control1                                             ; a0d7: 8d 00 b4    ...
    pla                                                               ; a0da: 68          h
    rti                                                               ; a0db: 40          @

.irq_handler
    bit reg_adlc_control1                                             ; a0dc: 2c 00 b4    ,..
    bpl loop_ca0c3                                                    ; a0df: 10 e2       ..
    lda #1                                                            ; a0e1: a9 01       ..
    bit reg_adlc_status2                                              ; a0e3: 2c 01 b4    ,..
    beq ca0c6                                                         ; a0e6: f0 de       ..
    lda reg_adlc_rxdata                                               ; a0e8: ad 02 b4    ...
    cmp reg_stationid                                                 ; a0eb: cd 04 b4    ...
    bne ca0d5                                                         ; a0ee: d0 e5       ..
    lda #1                                                            ; a0f0: a9 01       ..
.loop_ca0f2
    bit reg_adlc_control1                                             ; a0f2: 2c 00 b4    ,..
    bpl loop_ca0f2                                                    ; a0f5: 10 fb       ..
    beq ca0cd                                                         ; a0f7: f0 d4       ..
    lda reg_adlc_rxdata                                               ; a0f9: ad 02 b4    ...
    bne ca0d5                                                         ; a0fc: d0 d7       ..
    tya                                                               ; a0fe: 98          .
    pha                                                               ; a0ff: 48          H
    txa                                                               ; a100: 8a          .
    pha                                                               ; a101: 48          H
    tsx                                                               ; a102: ba          .
    stx temp_sp                                                       ; a103: 86 ff       ..
    ldx #0                                                            ; a105: a2 00       ..
    ldy #&f4                                                          ; a107: a0 f4       ..
    jsr ca295                                                         ; a109: 20 95 a2     ..
    lda l00b9                                                         ; a10c: a5 b9       ..
    bne ca120                                                         ; a10e: d0 10       ..
    lda #&b6                                                          ; a110: a9 b6       ..
    sta l00b4                                                         ; a112: 85 b4       ..
    lda #0                                                            ; a114: a9 00       ..
    sta l00b5                                                         ; a116: 85 b5       ..
    ldy #2                                                            ; a118: a0 02       ..
    jsr sub_ca53d                                                     ; a11a: 20 3d a5     =.
.ca11d
    jmp ca242                                                         ; a11d: 4c 42 a2    LB.

.ca120
    lda rxcbv                                                         ; a120: ad 30 02    .0.
    sta l00b4                                                         ; a123: 85 b4       ..
    lda rxcbv + 1                                                     ; a125: ad 31 02    .1.
    sta l00b5                                                         ; a128: 85 b5       ..
    jsr sub_ca1aa                                                     ; a12a: 20 aa a1     ..
    tya                                                               ; a12d: 98          .
    pha                                                               ; a12e: 48          H
    jsr sub_ca24b                                                     ; a12f: 20 4b a2     K.
    jsr ca1de                                                         ; a132: 20 de a1     ..
    ldy l00b1                                                         ; a135: a4 b1       ..
    jsr ca295                                                         ; a137: 20 95 a2     ..
    jsr sub_ca24b                                                     ; a13a: 20 4b a2     K.
    pla                                                               ; a13d: 68          h
    tay                                                               ; a13e: a8          .
    dey                                                               ; a13f: 88          .
    lda l00b3                                                         ; a140: a5 b3       ..
    sta (l00b4),y                                                     ; a142: 91 b4       ..
    dey                                                               ; a144: 88          .
    lda l00b2                                                         ; a145: a5 b2       ..
    sta (l00b4),y                                                     ; a147: 91 b4       ..
    dey                                                               ; a149: 88          .
    dey                                                               ; a14a: 88          .
    dey                                                               ; a14b: 88          .
    lda l00b7                                                         ; a14c: a5 b7       ..
    sta (l00b4),y                                                     ; a14e: 91 b4       ..
    dey                                                               ; a150: 88          .
    lda l00b6                                                         ; a151: a5 b6       ..
    sta (l00b4),y                                                     ; a153: 91 b4       ..
    dey                                                               ; a155: 88          .
    lda l00b9                                                         ; a156: a5 b9       ..
    sta (l00b4),y                                                     ; a158: 91 b4       ..
    dey                                                               ; a15a: 88          .
    lda l00b8                                                         ; a15b: a5 b8       ..
    ora #&80                                                          ; a15d: 09 80       ..
    sta (l00b4),y                                                     ; a15f: 91 b4       ..
    bne ca11d                                                         ; a161: d0 ba       ..
.sub_ca163
    lda #&fd                                                          ; a163: a9 fd       ..
    pha                                                               ; a165: 48          H
    lda #0                                                            ; a166: a9 00       ..
    pha                                                               ; a168: 48          H
    pha                                                               ; a169: 48          H
    ldy #&e7                                                          ; a16a: a0 e7       ..
.ca16c
    lda #4                                                            ; a16c: a9 04       ..
    bit reg_adlc_status2                                              ; a16e: 2c 01 b4    ,..
    beq ca182                                                         ; a171: f0 0f       ..
    lda reg_adlc_control1                                             ; a173: ad 00 b4    ...
    lda #&67                                                          ; a176: a9 67       .g
    sta reg_adlc_control23                                            ; a178: 8d 01 b4    ...
    lda #&10                                                          ; a17b: a9 10       ..
    bit reg_adlc_control1                                             ; a17d: 2c 00 b4    ,..
    bne ca19c                                                         ; a180: d0 1a       ..
.ca182
    lda #&67                                                          ; a182: a9 67       .g
    sta reg_adlc_control23                                            ; a184: 8d 01 b4    ...
    tsx                                                               ; a187: ba          .
    inc command_line+1,x                                              ; a188: fe 01 01    ...
    bne ca16c                                                         ; a18b: d0 df       ..
    inc command_line+2,x                                              ; a18d: fe 02 01    ...
    bne ca16c                                                         ; a190: d0 da       ..
    inc command_line+3,x                                              ; a192: fe 03 01    ...
    bne ca16c                                                         ; a195: d0 d5       ..
    ldx #&80                                                          ; a197: a2 80       ..
    jmp ca3a6                                                         ; a199: 4c a6 a3    L..

.ca19c
    sty reg_adlc_control23                                            ; a19c: 8c 01 b4    ...
    ldy #&44                                                          ; a19f: a0 44       .D
    sty reg_adlc_control1                                             ; a1a1: 8c 00 b4    ...
    ldx #&80                                                          ; a1a4: a2 80       ..
    pla                                                               ; a1a6: 68          h
    pla                                                               ; a1a7: 68          h
    pla                                                               ; a1a8: 68          h
    rts                                                               ; a1a9: 60          `

.sub_ca1aa
    bit flags                                                         ; a1aa: 2c 3a 02    ,:.
    bpl ca1db                                                         ; a1ad: 10 2c       .,
    ldy #0                                                            ; a1af: a0 00       ..
.ca1b1
    lda (l00b4),y                                                     ; a1b1: b1 b4       ..
    beq ca1db                                                         ; a1b3: f0 26       .&
    bmi ca228                                                         ; a1b5: 30 71       0q
    iny                                                               ; a1b7: c8          .
    lda (l00b4),y                                                     ; a1b8: b1 b4       ..
    beq ca1c0                                                         ; a1ba: f0 04       ..
    cmp l00b9                                                         ; a1bc: c5 b9       ..
    bne ca229                                                         ; a1be: d0 69       .i
.ca1c0
    iny                                                               ; a1c0: c8          .
    lda (l00b4),y                                                     ; a1c1: b1 b4       ..
    bne ca1cc                                                         ; a1c3: d0 07       ..
    iny                                                               ; a1c5: c8          .
    lda (l00b4),y                                                     ; a1c6: b1 b4       ..
    beq ca1d7                                                         ; a1c8: f0 0d       ..
    bne ca1d3                                                         ; a1ca: d0 07       ..
.ca1cc
    cmp l00b6                                                         ; a1cc: c5 b6       ..
    bne ca22a                                                         ; a1ce: d0 5a       .Z
    iny                                                               ; a1d0: c8          .
    lda (l00b4),y                                                     ; a1d1: b1 b4       ..
.ca1d3
    cmp l00b7                                                         ; a1d3: c5 b7       ..
    bne ca22b                                                         ; a1d5: d0 54       .T
.ca1d7
    iny                                                               ; a1d7: c8          .
    jmp ca443                                                         ; a1d8: 4c 43 a4    LC.

.ca1db
    jmp ca235                                                         ; a1db: 4c 35 a2    L5.

.ca1de
    bit reg_adlc_control1                                             ; a1de: 2c 00 b4    ,..
    bpl ca1de                                                         ; a1e1: 10 fb       ..
    lda #1                                                            ; a1e3: a9 01       ..
    bit reg_adlc_status2                                              ; a1e5: 2c 01 b4    ,..
    beq ca212                                                         ; a1e8: f0 28       .(
    lda reg_adlc_rxdata                                               ; a1ea: ad 02 b4    ...
    beq ca1f4                                                         ; a1ed: f0 05       ..
    cmp reg_stationid                                                 ; a1ef: cd 04 b4    ...
    bne ca211                                                         ; a1f2: d0 1d       ..
.ca1f4
    jsr sub_ca218                                                     ; a1f4: 20 18 a2     ..
    lda reg_adlc_rxdata                                               ; a1f7: ad 02 b4    ...
    bne ca210                                                         ; a1fa: d0 14       ..
    lda reg_adlc_rxdata                                               ; a1fc: ad 02 b4    ...
    cmp l00b6                                                         ; a1ff: c5 b6       ..
    bne ca20f                                                         ; a201: d0 0c       ..
    jsr sub_ca218                                                     ; a203: 20 18 a2     ..
    lda reg_adlc_rxdata                                               ; a206: ad 02 b4    ...
    cmp l00b7                                                         ; a209: c5 b7       ..
    bne ca20e                                                         ; a20b: d0 01       ..
    rts                                                               ; a20d: 60          `

.ca20e
    inx                                                               ; a20e: e8          .
.ca20f
    inx                                                               ; a20f: e8          .
.ca210
    inx                                                               ; a210: e8          .
.ca211
    inx                                                               ; a211: e8          .
.ca212
    txa                                                               ; a212: 8a          .
    bpl ca235                                                         ; a213: 10 20       .
    jmp ca39c                                                         ; a215: 4c 9c a3    L..

.sub_ca218
    lda #1                                                            ; a218: a9 01       ..
.loop_ca21a
    bit reg_adlc_control1                                             ; a21a: 2c 00 b4    ,..
    bpl loop_ca21a                                                    ; a21d: 10 fb       ..
    beq ca222                                                         ; a21f: f0 01       ..
    rts                                                               ; a221: 60          `

.ca222
    txa                                                               ; a222: 8a          .
    beq ca23f                                                         ; a223: f0 1a       ..
    jmp ca3a6                                                         ; a225: 4c a6 a3    L..

.ca228
    iny                                                               ; a228: c8          .
.ca229
    iny                                                               ; a229: c8          .
.ca22a
    iny                                                               ; a22a: c8          .
.ca22b
    iny                                                               ; a22b: c8          .
    iny                                                               ; a22c: c8          .
    iny                                                               ; a22d: c8          .
    iny                                                               ; a22e: c8          .
    iny                                                               ; a22f: c8          .
    beq ca235                                                         ; a230: f0 03       ..
    jmp ca1b1                                                         ; a232: 4c b1 a1    L..

.ca235
    inx                                                               ; a235: e8          .
    inx                                                               ; a236: e8          .
    inx                                                               ; a237: e8          .
    inx                                                               ; a238: e8          .
.ca239
    inx                                                               ; a239: e8          .
    inx                                                               ; a23a: e8          .
.ca23b
    inx                                                               ; a23b: e8          .
.ca23c
    inx                                                               ; a23c: e8          .
.ca23d
    inx                                                               ; a23d: e8          .
    inx                                                               ; a23e: e8          .
.ca23f
    ldx temp_sp                                                       ; a23f: a6 ff       ..
    txs                                                               ; a241: 9a          .
.ca242
    jsr sub_ca095                                                     ; a242: 20 95 a0     ..
    pla                                                               ; a245: 68          h
    tax                                                               ; a246: aa          .
    pla                                                               ; a247: 68          h
    tay                                                               ; a248: a8          .
    pla                                                               ; a249: 68          h
    rti                                                               ; a24a: 40          @

.sub_ca24b
    lda #&44                                                          ; a24b: a9 44       .D
    sta reg_adlc_control1                                             ; a24d: 8d 00 b4    ...
    lda reg_adlc_control1                                             ; a250: ad 00 b4    ...
    lda #&d7                                                          ; a253: a9 d7       ..
    sta reg_adlc_control23                                            ; a255: 8d 01 b4    ...
    lda l00b6                                                         ; a258: a5 b6       ..
.loop_ca25a
    bit reg_adlc_control1                                             ; a25a: 2c 00 b4    ,..
    bpl loop_ca25a                                                    ; a25d: 10 fb       ..
    bvc ca239                                                         ; a25f: 50 d8       P.
    sta reg_adlc_txdata                                               ; a261: 8d 02 b4    ...
    lda l00b7                                                         ; a264: a5 b7       ..
    sta reg_adlc_txdata                                               ; a266: 8d 02 b4    ...
.loop_ca269
    bit reg_adlc_control1                                             ; a269: 2c 00 b4    ,..
    bpl loop_ca269                                                    ; a26c: 10 fb       ..
    bvc ca239                                                         ; a26e: 50 c9       P.
    lda reg_stationid                                                 ; a270: ad 04 b4    ...
    sta reg_adlc_txdata                                               ; a273: 8d 02 b4    ...
    lda #0                                                            ; a276: a9 00       ..
    sta reg_adlc_txdata                                               ; a278: 8d 02 b4    ...
    lda #&3b                                                          ; a27b: a9 3b       .;
    sta reg_adlc_control23                                            ; a27d: 8d 01 b4    ...
.loop_ca280
    bit reg_adlc_control1                                             ; a280: 2c 00 b4    ,..
    bpl loop_ca280                                                    ; a283: 10 fb       ..
    bvc ca239                                                         ; a285: 50 b2       P.
    lda #2                                                            ; a287: a9 02       ..
    sta reg_adlc_control1                                             ; a289: 8d 00 b4    ...
    jmp ca0b5                                                         ; a28c: 4c b5 a0    L..

.ca28f
    txa                                                               ; a28f: 8a          .
    beq ca23d                                                         ; a290: f0 ab       ..
    jmp ca3a4                                                         ; a292: 4c a4 a3    L..

.ca295
    lda reg_adlc_control1                                             ; a295: ad 00 b4    ...
    lda #&43                                                          ; a298: a9 43       .C
    sta reg_adlc_control23                                            ; a29a: 8d 01 b4    ...
.ca29d
    lda #1                                                            ; a29d: a9 01       ..
.loop_ca29f
    bit reg_adlc_control1                                             ; a29f: 2c 00 b4    ,..
    bpl loop_ca29f                                                    ; a2a2: 10 fb       ..
    beq ca2bc                                                         ; a2a4: f0 16       ..
    lda reg_adlc_rxdata                                               ; a2a6: ad 02 b4    ...
    sta (l00b2),y                                                     ; a2a9: 91 b2       ..
    iny                                                               ; a2ab: c8          .
    beq ca2b6                                                         ; a2ac: f0 08       ..
    lda reg_adlc_rxdata                                               ; a2ae: ad 02 b4    ...
    sta (l00b2),y                                                     ; a2b1: 91 b2       ..
    iny                                                               ; a2b3: c8          .
    bne ca29d                                                         ; a2b4: d0 e7       ..
.ca2b6
    inc l00b3                                                         ; a2b6: e6 b3       ..
    dec l00b0                                                         ; a2b8: c6 b0       ..
    bne ca29d                                                         ; a2ba: d0 e1       ..
.ca2bc
    txa                                                               ; a2bc: 8a          .
    bne ca2c6                                                         ; a2bd: d0 07       ..
    lda #&84                                                          ; a2bf: a9 84       ..
    sta reg_adlc_control23                                            ; a2c1: 8d 01 b4    ...
    bne ca2cb                                                         ; a2c4: d0 05       ..
.ca2c6
    lda #4                                                            ; a2c6: a9 04       ..
    sta reg_adlc_control23                                            ; a2c8: 8d 01 b4    ...
.ca2cb
    lda #2                                                            ; a2cb: a9 02       ..
    bit reg_adlc_status2                                              ; a2cd: 2c 01 b4    ,..
    beq ca28f                                                         ; a2d0: f0 bd       ..
    clc                                                               ; a2d2: 18          .
    bpl ca2e0                                                         ; a2d3: 10 0b       ..
    tya                                                               ; a2d5: 98          .
    ora l00b0                                                         ; a2d6: 05 b0       ..
    beq ca28f                                                         ; a2d8: f0 b5       ..
    lda reg_adlc_rxdata                                               ; a2da: ad 02 b4    ...
    sta (l00b2),y                                                     ; a2dd: 91 b2       ..
    sec                                                               ; a2df: 38          8
.ca2e0
    cld                                                               ; a2e0: d8          .
    tya                                                               ; a2e1: 98          .
    adc l00b2                                                         ; a2e2: 65 b2       e.
    sta l00b2                                                         ; a2e4: 85 b2       ..
    ldy l00b3                                                         ; a2e6: a4 b3       ..
    bcc ca2eb                                                         ; a2e8: 90 01       ..
    iny                                                               ; a2ea: c8          .
.ca2eb
    sty l00b3                                                         ; a2eb: 84 b3       ..
    rts                                                               ; a2ed: 60          `

.transmit_handler
    php                                                               ; a2ee: 08          .
    pha                                                               ; a2ef: 48          H
    tya                                                               ; a2f0: 98          .
    pha                                                               ; a2f1: 48          H
    txa                                                               ; a2f2: 8a          .
    pha                                                               ; a2f3: 48          H
    cld                                                               ; a2f4: d8          .
    sei                                                               ; a2f5: 78          x
    stx l00b4                                                         ; a2f6: 86 b4       ..
    sty l00b5                                                         ; a2f8: 84 b5       ..
    tsx                                                               ; a2fa: ba          .
    stx temp_sp                                                       ; a2fb: 86 ff       ..
    lda #&20                                                          ; a2fd: a9 20       .
    and reg_adlc_status2                                              ; a2ff: 2d 01 b4    -..
    beq ca307                                                         ; a302: f0 03       ..
    jmp ca39b                                                         ; a304: 4c 9b a3    L..

.ca307
    jsr sub_ca163                                                     ; a307: 20 63 a1     c.
    ldy #4                                                            ; a30a: a0 04       ..
    jsr ca443                                                         ; a30c: 20 43 a4     C.
    ldy #1                                                            ; a30f: a0 01       ..
    lda (l00b4),y                                                     ; a311: b1 b4       ..
    bne ca31c                                                         ; a313: d0 07       ..
    tay                                                               ; a315: a8          .
    jsr sub_ca494                                                     ; a316: 20 94 a4     ..
    jmp ca32c                                                         ; a319: 4c 2c a3    L,.

.ca31c
    jsr sub_ca40d                                                     ; a31c: 20 0d a4     ..
    sec                                                               ; a31f: 38          8
    jsr sub_ca351                                                     ; a320: 20 51 a3     Q.
    jsr sub_ca415                                                     ; a323: 20 15 a4     ..
    clc                                                               ; a326: 18          .
    ldy l00b1                                                         ; a327: a4 b1       ..
    jsr ca336                                                         ; a329: 20 36 a3     6.
.ca32c
    ldy #0                                                            ; a32c: a0 00       ..
    txa                                                               ; a32e: 8a          .
    sta (l00b4),y                                                     ; a32f: 91 b4       ..
    jmp ca3b0                                                         ; a331: 4c b0 a3    L..

.loop_ca334
    inc l00b3                                                         ; a334: e6 b3       ..
.ca336
    lda (l00b2),y                                                     ; a336: b1 b2       ..
.loop_ca338
    bit reg_adlc_control1                                             ; a338: 2c 00 b4    ,..
    bpl loop_ca338                                                    ; a33b: 10 fb       ..
    bvc ca36a                                                         ; a33d: 50 2b       P+
    sta reg_adlc_txdata                                               ; a33f: 8d 02 b4    ...
    iny                                                               ; a342: c8          .
    beq ca34d                                                         ; a343: f0 08       ..
    lda (l00b2),y                                                     ; a345: b1 b2       ..
    sta reg_adlc_txdata                                               ; a347: 8d 02 b4    ...
    iny                                                               ; a34a: c8          .
    bne ca336                                                         ; a34b: d0 e9       ..
.ca34d
    dec l00b0                                                         ; a34d: c6 b0       ..
    bne loop_ca334                                                    ; a34f: d0 e3       ..
.sub_ca351
    lda #&3f                                                          ; a351: a9 3f       .?
    sta reg_adlc_control23                                            ; a353: 8d 01 b4    ...
.loop_ca356
    bit reg_adlc_control1                                             ; a356: 2c 00 b4    ,..
    bpl loop_ca356                                                    ; a359: 10 fb       ..
    bvc ca36a                                                         ; a35b: 50 0d       P.
    txa                                                               ; a35d: 8a          .
    bmi ca363                                                         ; a35e: 30 03       0.
    jmp ca0b0                                                         ; a360: 4c b0 a0    L..

.ca363
    lda #0                                                            ; a363: a9 00       ..
    sta reg_adlc_control1                                             ; a365: 8d 00 b4    ...
    beq ca3ba                                                         ; a368: f0 50       .P
.ca36a
    txa                                                               ; a36a: 8a          .
    bne ca3a3                                                         ; a36b: d0 36       .6
    jmp ca23c                                                         ; a36d: 4c 3c a2    L<.

.ca370
    ldy reg_stationid                                                 ; a370: ac 04 b4    ...
.loop_ca373
    pha                                                               ; a373: 48          H
    pha                                                               ; a374: 48          H
    pha                                                               ; a375: 48          H
    pla                                                               ; a376: 68          h
    pla                                                               ; a377: 68          h
    pla                                                               ; a378: 68          h
    iny                                                               ; a379: c8          .
    bne loop_ca373                                                    ; a37a: d0 f7       ..
    txa                                                               ; a37c: 8a          .
    bne ca3a2                                                         ; a37d: d0 23       .#
    jmp ca23b                                                         ; a37f: 4c 3b a2    L;.

.sub_ca382
    jsr ca385                                                         ; a382: 20 85 a3     ..
.ca385
    jsr sub_ca388                                                     ; a385: 20 88 a3     ..
.sub_ca388
    lda (l00b4),y                                                     ; a388: b1 b4       ..
    bcc ca38f                                                         ; a38a: 90 03       ..
    lda l00b6,y                                                       ; a38c: b9 b6 00    ...
.ca38f
    bit reg_adlc_control1                                             ; a38f: 2c 00 b4    ,..
    bpl ca38f                                                         ; a392: 10 fb       ..
    bvc ca370                                                         ; a394: 50 da       P.
    iny                                                               ; a396: c8          .
.ca397
    sta reg_adlc_txdata                                               ; a397: 8d 02 b4    ...
    rts                                                               ; a39a: 60          `

.ca39b
    inx                                                               ; a39b: e8          .
.ca39c
    inx                                                               ; a39c: e8          .
    inx                                                               ; a39d: e8          .
    inx                                                               ; a39e: e8          .
    inx                                                               ; a39f: e8          .
    inx                                                               ; a3a0: e8          .
.ca3a1
    inx                                                               ; a3a1: e8          .
.ca3a2
    inx                                                               ; a3a2: e8          .
.ca3a3
    inx                                                               ; a3a3: e8          .
.ca3a4
    inx                                                               ; a3a4: e8          .
    inx                                                               ; a3a5: e8          .
.ca3a6
    ldy #0                                                            ; a3a6: a0 00       ..
    txa                                                               ; a3a8: 8a          .
    ora #&40                                                          ; a3a9: 09 40       .@
    sta (l00b4),y                                                     ; a3ab: 91 b4       ..
    ldx temp_sp                                                       ; a3ad: a6 ff       ..
    txs                                                               ; a3af: 9a          .
.ca3b0
    jsr sub_ca095                                                     ; a3b0: 20 95 a0     ..
    pla                                                               ; a3b3: 68          h
    tax                                                               ; a3b4: aa          .
    pla                                                               ; a3b5: 68          h
    tay                                                               ; a3b6: a8          .
    pla                                                               ; a3b7: 68          h
    plp                                                               ; a3b8: 28          (
    rts                                                               ; a3b9: 60          `

.ca3ba
    lda #&82                                                          ; a3ba: a9 82       ..
    sta reg_adlc_control1                                             ; a3bc: 8d 00 b4    ...
    php                                                               ; a3bf: 08          .
    txa                                                               ; a3c0: 8a          .
    ora #&20                                                          ; a3c1: 09 20       .
    tax                                                               ; a3c3: aa          .
    lda #1                                                            ; a3c4: a9 01       ..
.loop_ca3c6
    bit reg_adlc_control1                                             ; a3c6: 2c 00 b4    ,..
    bpl loop_ca3c6                                                    ; a3c9: 10 fb       ..
    bit reg_adlc_status2                                              ; a3cb: 2c 01 b4    ,..
    beq ca3a1                                                         ; a3ce: f0 d1       ..
    lda reg_adlc_rxdata                                               ; a3d0: ad 02 b4    ...
    cmp reg_stationid                                                 ; a3d3: cd 04 b4    ...
    bne ca3a1                                                         ; a3d6: d0 c9       ..
.loop_ca3d8
    lda reg_adlc_status2                                              ; a3d8: ad 01 b4    ...
    beq loop_ca3d8                                                    ; a3db: f0 fb       ..
    bpl ca3a1                                                         ; a3dd: 10 c2       ..
    lda reg_adlc_rxdata                                               ; a3df: ad 02 b4    ...
    bne ca3a1                                                         ; a3e2: d0 bd       ..
.loop_ca3e4
    lda reg_adlc_status2                                              ; a3e4: ad 01 b4    ...
    beq loop_ca3e4                                                    ; a3e7: f0 fb       ..
    bpl ca3a1                                                         ; a3e9: 10 b6       ..
    lda reg_adlc_rxdata                                               ; a3eb: ad 02 b4    ...
    lda reg_adlc_rxdata                                               ; a3ee: ad 02 b4    ...
    lda #2                                                            ; a3f1: a9 02       ..
    bit reg_adlc_status2                                              ; a3f3: 2c 01 b4    ,..
    beq ca3a1                                                         ; a3f6: f0 a9       ..
    jsr ca0bb                                                         ; a3f8: 20 bb a0     ..
    txa                                                               ; a3fb: 8a          .
    ora #&10                                                          ; a3fc: 09 10       ..
    tax                                                               ; a3fe: aa          .
    plp                                                               ; a3ff: 28          (
    bcc ca40c                                                         ; a400: 90 0a       ..
.sub_ca402
    lda #&44                                                          ; a402: a9 44       .D
    sta reg_adlc_control1                                             ; a404: 8d 00 b4    ...
    lda #&e7                                                          ; a407: a9 e7       ..
    sta reg_adlc_control23                                            ; a409: 8d 01 b4    ...
.ca40c
    rts                                                               ; a40c: 60          `

.sub_ca40d
    jsr sub_ca415                                                     ; a40d: 20 15 a4     ..
    ldy #0                                                            ; a410: a0 00       ..
    jmp ca385                                                         ; a412: 4c 85 a3    L..

.sub_ca415
    ldy #2                                                            ; a415: a0 02       ..
    clc                                                               ; a417: 18          .
.sub_ca418
    jsr ca385                                                         ; a418: 20 85 a3     ..
    lda reg_stationid                                                 ; a41b: ad 04 b4    ...
    jsr ca38f                                                         ; a41e: 20 8f a3     ..
    lda #0                                                            ; a421: a9 00       ..
    jmp ca397                                                         ; a423: 4c 97 a3    L..

.sub_ca426
    sec                                                               ; a426: 38          8
    lda l00ba                                                         ; a427: a5 ba       ..
    sbc l00be                                                         ; a429: e5 be       ..
    sta l00b1                                                         ; a42b: 85 b1       ..
    lda l00bb                                                         ; a42d: a5 bb       ..
    sbc #0                                                            ; a42f: e9 00       ..
    sta l00b3                                                         ; a431: 85 b3       ..
    lda l00be                                                         ; a433: a5 be       ..
    sta l00b2                                                         ; a435: 85 b2       ..
    lda l00bf                                                         ; a437: a5 bf       ..
    sec                                                               ; a439: 38          8
    sbc l00b3                                                         ; a43a: e5 b3       ..
    sta l00b0                                                         ; a43c: 85 b0       ..
    iny                                                               ; a43e: c8          .
    iny                                                               ; a43f: c8          .
    iny                                                               ; a440: c8          .
    iny                                                               ; a441: c8          .
    rts                                                               ; a442: 60          `

.ca443
    sec                                                               ; a443: 38          8
    lda (l00b4),y                                                     ; a444: b1 b4       ..
    iny                                                               ; a446: c8          .
    iny                                                               ; a447: c8          .
    sbc (l00b4),y                                                     ; a448: f1 b4       ..
    sta l00b1                                                         ; a44a: 85 b1       ..
    dey                                                               ; a44c: 88          .
    lda (l00b4),y                                                     ; a44d: b1 b4       ..
    sbc #0                                                            ; a44f: e9 00       ..
    sta l00b3                                                         ; a451: 85 b3       ..
    iny                                                               ; a453: c8          .
    lda (l00b4),y                                                     ; a454: b1 b4       ..
    sta l00b2                                                         ; a456: 85 b2       ..
    iny                                                               ; a458: c8          .
    lda (l00b4),y                                                     ; a459: b1 b4       ..
    sec                                                               ; a45b: 38          8
    sbc l00b3                                                         ; a45c: e5 b3       ..
    sta l00b0                                                         ; a45e: 85 b0       ..
    iny                                                               ; a460: c8          .
    lda (l00b4),y                                                     ; a461: b1 b4       ..
    sta l00ba                                                         ; a463: 85 ba       ..
    iny                                                               ; a465: c8          .
    lda (l00b4),y                                                     ; a466: b1 b4       ..
    sta l00bb                                                         ; a468: 85 bb       ..
    iny                                                               ; a46a: c8          .
    lda (l00b4),y                                                     ; a46b: b1 b4       ..
    sta l00bc                                                         ; a46d: 85 bc       ..
    iny                                                               ; a46f: c8          .
    lda (l00b4),y                                                     ; a470: b1 b4       ..
    sta l00bd                                                         ; a472: 85 bd       ..
    sec                                                               ; a474: 38          8
    lda l00ba                                                         ; a475: a5 ba       ..
    sbc l00b1                                                         ; a477: e5 b1       ..
    sta l00be                                                         ; a479: 85 be       ..
    lda l00bb                                                         ; a47b: a5 bb       ..
    sbc #0                                                            ; a47d: e9 00       ..
    clc                                                               ; a47f: 18          .
    adc l00b0                                                         ; a480: 65 b0       e.
    sta l00bf                                                         ; a482: 85 bf       ..
    lda l00bc                                                         ; a484: a5 bc       ..
    adc #0                                                            ; a486: 69 00       i.
    sta l00c0                                                         ; a488: 85 c0       ..
    lda l00bd                                                         ; a48a: a5 bd       ..
    adc #0                                                            ; a48c: 69 00       i.
    sta l00c1                                                         ; a48e: 85 c1       ..
    dey                                                               ; a490: 88          .
    dey                                                               ; a491: 88          .
    dey                                                               ; a492: 88          .
    rts                                                               ; a493: 60          `

.sub_ca494
    lda (l00b4),y                                                     ; a494: b1 b4       ..
    tay                                                               ; a496: a8          .
    cpy #&81                                                          ; a497: c0 81       ..
    bcc ca4a8                                                         ; a499: 90 0d       ..
    cpy #&89                                                          ; a49b: c0 89       ..
    bcs ca4a8                                                         ; a49d: b0 09       ..
    lda tx_cmd_table_hi-&81,y                                         ; a49f: b9 32 a4    .2.
    pha                                                               ; a4a2: 48          H
    lda tx_cmd_table_lo-&81,y                                         ; a4a3: b9 2a a4    .*.
    pha                                                               ; a4a6: 48          H
    rts                                                               ; a4a7: 60          `

.ca4a8
    jmp ca39b                                                         ; a4a8: 4c 9b a3    L..

.tx_cmd_table_lo
    equb <(tx_cmd_81_88_peek-1)                                       ; a4ab: ba          .
    equb <(tx_cmd_82_poke-1)                                          ; a4ac: f6          .
    equb <(tx_cmd_83_84_85_remote-1)                                  ; a4ad: 18          .
    equb <(tx_cmd_83_84_85_remote-1)                                  ; a4ae: 18          .
    equb <(tx_cmd_83_84_85_remote-1)                                  ; a4af: 18          .
    equb <(tx_cmd_86_87_halt_resume-1)                                ; a4b0: 34          4
    equb <(tx_cmd_86_87_halt_resume-1)                                ; a4b1: 34          4
    equb <(tx_cmd_81_88_peek-1)                                       ; a4b2: ba          .
.tx_cmd_table_hi
    equb >(tx_cmd_81_88_peek-1)                                       ; a4b3: a4          .
    equb >(tx_cmd_82_poke-1)                                          ; a4b4: a4          .
    equb >(tx_cmd_83_84_85_remote-1)                                  ; a4b5: a5          .
    equb >(tx_cmd_83_84_85_remote-1)                                  ; a4b6: a5          .
    equb >(tx_cmd_83_84_85_remote-1)                                  ; a4b7: a5          .
    equb >(tx_cmd_86_87_halt_resume-1)                                ; a4b8: a5          .
    equb >(tx_cmd_86_87_halt_resume-1)                                ; a4b9: a5          .
    equb >(tx_cmd_81_88_peek-1)                                       ; a4ba: a4          .

.tx_cmd_81_88_peek
    ldy #4                                                            ; a4bb: a0 04       ..
    jsr ca443                                                         ; a4bd: 20 43 a4     C.
    jsr sub_ca40d                                                     ; a4c0: 20 0d a4     ..
    ldy #4                                                            ; a4c3: a0 04       ..
    sec                                                               ; a4c5: 38          8
    jsr sub_ca382                                                     ; a4c6: 20 82 a3     ..
    ldy #8                                                            ; a4c9: a0 08       ..
    sec                                                               ; a4cb: 38          8
    jsr sub_ca382                                                     ; a4cc: 20 82 a3     ..
    lda #&3f                                                          ; a4cf: a9 3f       .?
    sta reg_adlc_control23                                            ; a4d1: 8d 01 b4    ...
.loop_ca4d4
    bit reg_adlc_control1                                             ; a4d4: 2c 00 b4    ,..
    bpl loop_ca4d4                                                    ; a4d7: 10 fb       ..
    bvs ca4de                                                         ; a4d9: 70 03       p.
    jmp ca3a3                                                         ; a4db: 4c a3 a3    L..

.ca4de
    jsr ca0b0                                                         ; a4de: 20 b0 a0     ..
    jsr sub_ca0a1                                                     ; a4e1: 20 a1 a0     ..
    ldy #2                                                            ; a4e4: a0 02       ..
    lda (l00b4),y                                                     ; a4e6: b1 b4       ..
    sta l00b6                                                         ; a4e8: 85 b6       ..
    iny                                                               ; a4ea: c8          .
    lda (l00b4),y                                                     ; a4eb: b1 b4       ..
    sta l00b7                                                         ; a4ed: 85 b7       ..
    jsr ca1de                                                         ; a4ef: 20 de a1     ..
    ldy l00b1                                                         ; a4f2: a4 b1       ..
    jmp ca295                                                         ; a4f4: 4c 95 a2    L..

.tx_cmd_82_poke
    ldy #4                                                            ; a4f7: a0 04       ..
    jsr ca443                                                         ; a4f9: 20 43 a4     C.
    jsr sub_ca40d                                                     ; a4fc: 20 0d a4     ..
    ldy #4                                                            ; a4ff: a0 04       ..
    sec                                                               ; a501: 38          8
    jsr sub_ca382                                                     ; a502: 20 82 a3     ..
IF (BASE = &A000)
    ldy #8                                                            ; a505: a0 08       ..
    sec                                                               ; a507: 38          8
ELSE
    sec
.shared_tail
    ldy #8
ENDIF
    jsr sub_ca382                                                     ; a508: 20 82 a3     ..
    sec                                                               ; a50b: 38          8
    jsr sub_ca351                                                     ; a50c: 20 51 a3     Q.
    jsr sub_ca415                                                     ; a50f: 20 15 a4     ..
    clc                                                               ; a512: 18          .
    ldy l00b1                                                         ; a513: a4 b1       ..
IF (BASE = &A000)
    jsr ca336                                                         ; a515: 20 36 a3     6.
    rts                                                               ; a518: 60          `
ELSE
    jmp ca336
ENDIF

.tx_cmd_83_84_85_remote
    ldy #4                                                            ; a519: a0 04       ..
    jsr ca443                                                         ; a51b: 20 43 a4     C.
    jsr sub_ca40d                                                     ; a51e: 20 0d a4     ..
IF (BASE = &A000)
    ldy #8                                                            ; a521: a0 08       ..
    clc                                                               ; a523: 18          .
    jsr sub_ca382                                                     ; a524: 20 82 a3     ..
    sec                                                               ; a527: 38          8
    jsr sub_ca351                                                     ; a528: 20 51 a3     Q.
    jsr sub_ca415                                                     ; a52b: 20 15 a4     ..
    clc                                                               ; a52e: 18          .
    ldy l00b1                                                         ; a52f: a4 b1       ..
    jsr ca336                                                         ; a531: 20 36 a3     6.
    rts                                                               ; a534: 60          `
ELSE
    clc
    bcc shared_tail
ENDIF

.tx_cmd_86_87_halt_resume
    jsr sub_ca40d                                                     ; a535: 20 0d a4     ..
    clc                                                               ; a538: 18          .
IF (BASE = &A000)
    jsr sub_ca351                                                     ; a539: 20 51 a3     Q.
    rts                                                               ; a53c: 60          `
ELSE
    jmp sub_ca351                                                     ; a539: 20 51 a3     Q.
ENDIF

.sub_ca53d
    ldy l00b8                                                         ; a53d: a4 b8       ..
    cpy #&81                                                          ; a53f: c0 81       ..
    bcc ca56d                                                         ; a541: 90 2a       .*
    cpy #&89                                                          ; a543: c0 89       ..
    bcs ca56d                                                         ; a545: b0 26       .&
    cpy #&87                                                          ; a547: c0 87       ..
    bcs ca562                                                         ; a549: b0 17       ..
    lda l00b6                                                         ; a54b: a5 b6       ..
    cmp #&f0                                                          ; a54d: c9 f0       ..
    bcs ca562                                                         ; a54f: b0 11       ..
    tya                                                               ; a551: 98          .
    sec                                                               ; a552: 38          8
    sbc #&81                                                          ; a553: e9 81       ..
    tay                                                               ; a555: a8          .
    lda prot_mask                                                     ; a556: ad 3b 02    .;.
.loop_ca559
    ror a                                                             ; a559: 6a          j
    dey                                                               ; a55a: 88          .
    bpl loop_ca559                                                    ; a55b: 10 fc       ..
    bcc ca562                                                         ; a55d: 90 03       ..
    jmp ca56e                                                         ; a55f: 4c 6e a5    Ln.

.ca562
    ldy l00b8                                                         ; a562: a4 b8       ..
    lda rx_cmd_table_hi-&81,y                                         ; a564: b9 fa a4    ...
    pha                                                               ; a567: 48          H
    lda rx_cmd_table_lo-&81,y                                         ; a568: b9 f2 a4    ...
    pha                                                               ; a56b: 48          H
    rts                                                               ; a56c: 60          `

.ca56d
    inx                                                               ; a56d: e8          .
.ca56e
    inx                                                               ; a56e: e8          .
    txa                                                               ; a56f: 8a          .
    jmp ca235                                                         ; a570: 4c 35 a2    L5.

.rx_cmd_table_lo
    equb <(rx_cmd_81_peek-1)                                          ; a573: 93          .
    equb <(rx_cmd_82_poke-1)                                          ; a574: ac          .
    equb <(rx_cmd_83_jsr-1)                                           ; a575: d5          .
    equb <(rx_cmd_84_user_proc-1)                                     ; a576: c0          .
    equb <(rx_cmd_85_os_proc-1)                                       ; a577: c9          .
    equb <(rx_cmd_86_halt-1)                                          ; a578: 13          .
    equb <(rx_cmd_87_resume-1)                                        ; a579: 2f          /
    equb <(rx_cmd_88_machine_peek-1)                                  ; a57a: 82          .
.rx_cmd_table_hi
    equb >(rx_cmd_81_peek-1)                                          ; a57b: a5          .
    equb >(rx_cmd_82_poke-1)                                          ; a57c: a5          .
    equb >(rx_cmd_83_jsr-1)                                           ; a57d: a5          .
    equb >(rx_cmd_84_user_proc-1)                                     ; a57e: a5          .
    equb >(rx_cmd_85_os_proc-1)                                       ; a57f: a5          .
    equb >(rx_cmd_86_halt-1)                                          ; a580: a6          .
    equb >(rx_cmd_87_resume-1)                                        ; a581: a6          .
    equb >(rx_cmd_88_machine_peek-1)                                  ; a582: a5          .

.rx_cmd_88_machine_peek
    clc                                                               ; a583: 18          .
    lda #<function6                                                   ; a584: a9 12       ..
    sta l00ba                                                         ; a586: 85 ba       ..
    lda #>function6                                                   ; a588: a9 a7       ..
    sta l00bb                                                         ; a58a: 85 bb       ..
    lda #<function7                                                   ; a58c: a9 16       ..
    sta l00be                                                         ; a58e: 85 be       ..
    lda #>function7                                                   ; a590: a9 a7       ..
    sta l00bf                                                         ; a592: 85 bf       ..
.rx_cmd_81_peek
    ldy #4                                                            ; a594: a0 04       ..
    jsr sub_ca426                                                     ; a596: 20 26 a4     &.
    lda reg_adlc_control1                                             ; a599: ad 00 b4    ...
    jsr sub_ca402                                                     ; a59c: 20 02 a4     ..
    ldy #0                                                            ; a59f: a0 00       ..
    sec                                                               ; a5a1: 38          8
    jsr sub_ca418                                                     ; a5a2: 20 18 a4     ..
    ldy l00b1                                                         ; a5a5: a4 b1       ..
    jsr ca336                                                         ; a5a7: 20 36 a3     6.
    jmp ca0bb                                                         ; a5aa: 4c bb a0    L..

.rx_cmd_82_poke
    ldy #4                                                            ; a5ad: a0 04       ..
    jsr sub_ca426                                                     ; a5af: 20 26 a4     &.
    jsr sub_ca24b                                                     ; a5b2: 20 4b a2     K.
    jsr ca1de                                                         ; a5b5: 20 de a1     ..
    ldy l00b1                                                         ; a5b8: a4 b1       ..
    jsr ca295                                                         ; a5ba: 20 95 a2     ..
IF (BASE = &A000)
    jsr sub_ca24b                                                     ; a5bd: 20 4b a2     K.
    rts                                                               ; a5c0: 60          `
ELSE
    jmp sub_ca24b
ENDIF

.rx_cmd_84_user_proc
    lda proc_jmp_ind                                                  ; a5c1: ad 38 02    .8.
    ldy proc_jmp_ind + 1                                              ; a5c4: ac 39 02    .9.
    jmp ca5ce                                                         ; a5c7: 4c ce a5    L..

.rx_cmd_85_os_proc
    lda #<function4                                                   ; a5ca: a9 0c       ..
    ldy #>function4                                                   ; a5cc: a0 a7       ..
.ca5ce
    sty l00bb                                                         ; a5ce: 84 bb       ..
    ldy l00ba                                                         ; a5d0: a4 ba       ..
    sty l00bc                                                         ; a5d2: 84 bc       ..
    sta l00ba                                                         ; a5d4: 85 ba       ..
.rx_cmd_83_jsr
    lda #&f8                                                          ; a5d6: a9 f8       ..
    sta l00b1                                                         ; a5d8: 85 b1       ..
    lda #1                                                            ; a5da: a9 01       ..
    sta l00b0                                                         ; a5dc: 85 b0       ..
    lda #&ca                                                          ; a5de: a9 ca       ..
    sta l00b2                                                         ; a5e0: 85 b2       ..
    lda #&ff                                                          ; a5e2: a9 ff       ..
    sta l00b3                                                         ; a5e4: 85 b3       ..
    jsr sub_ca24b                                                     ; a5e6: 20 4b a2     K.
    jsr ca1de                                                         ; a5e9: 20 de a1     ..
    ldy l00b1                                                         ; a5ec: a4 b1       ..
    jsr ca295                                                         ; a5ee: 20 95 a2     ..
    jsr sub_ca24b                                                     ; a5f1: 20 4b a2     K.
    lda #&1c                                                          ; a5f4: a9 1c       ..
    ora prot_mask                                                     ; a5f6: 0d 3b 02    .;.
    sta prot_mask                                                     ; a5f9: 8d 3b 02    .;.
    jsr sub_ca095                                                     ; a5fc: 20 95 a0     ..
    cli                                                               ; a5ff: 58          X
    lda l00b8                                                         ; a600: a5 b8       ..
    cmp #&83                                                          ; a602: c9 83       ..
    beq ca60b                                                         ; a604: f0 05       ..
    lda l00bc                                                         ; a606: a5 bc       ..
    jmp ca60d                                                         ; a608: 4c 0d a6    L..

.ca60b
    lda l00c2                                                         ; a60b: a5 c2       ..
.ca60d
    ldy l00b7                                                         ; a60d: a4 b7       ..
    ldx l00b6                                                         ; a60f: a6 b6       ..
    jmp (l00ba)                                                       ; a611: 6c ba 00    l..

.rx_cmd_86_halt
    jsr sub_ca24b                                                     ; a614: 20 4b a2     K.
    lda #&40                                                          ; a617: a9 40       .@
    bit flags                                                         ; a619: 2c 3a 02    ,:.
    bne ca62f                                                         ; a61c: d0 11       ..
    ora flags                                                         ; a61e: 0d 3a 02    .:.
    sta flags                                                         ; a621: 8d 3a 02    .:.
    jsr sub_ca095                                                     ; a624: 20 95 a0     ..
    cli                                                               ; a627: 58          X
    lda #&40                                                          ; a628: a9 40       .@
.loop_ca62a
    bit flags                                                         ; a62a: 2c 3a 02    ,:.
    bne loop_ca62a                                                    ; a62d: d0 fb       ..
.ca62f
    rts                                                               ; a62f: 60          `

.rx_cmd_87_resume
    jsr sub_ca24b                                                     ; a630: 20 4b a2     K.
    lda #&bf                                                          ; a633: a9 bf       ..
    and flags                                                         ; a635: 2d 3a 02    -:.
    sta flags                                                         ; a638: 8d 3a 02    .:.
    rts                                                               ; a63b: 60          `

IF (BASE = &A000)
    ;; Save space in other versions - Paul Bond's postcode (!!!)
    equs "CB5 8AF"                                                    ; a63c: 43 42 35... CB5
    equb &0d                                                          ; a643: 0d          .
    equs ";*               Eng"                                       ; a644: 3b 2a 20... ;*
ENDIF

.econet_file_server_send_command_wait_response
    jsr econet_file_server_init_command_y                             ; a658: 20 f7 a7     ..
.sub_ca65b
    jsr econet_file_server_send_command                               ; a65b: 20 bc a6     ..
.sub_ca65e
    jsr sub_ca66d                                                     ; a65e: 20 6d a6     m.
    lda fs_cmd_handle_lib                                             ; a661: ad 1a 01    ...
    beq ca669                                                         ; a664: f0 03       ..
    jmp econet_error_a                                                ; a666: 4c 3c a8    L<.

.ca669
    lda fs_cmd_handle_cwd                                             ; a669: ad 19 01    ...
    rts                                                               ; a66c: 60          `

.sub_ca66d
    jsr sub_ca69b                                                     ; a66d: 20 9b a6     ..
.econet_wait_response
    ldy #&d0                                                          ; a670: a0 d0       ..
    lda #&0f                                                          ; a672: a9 0f       ..
.sub_ca674
    sta l00dc                                                         ; a674: 85 dc       ..
    lda #0                                                            ; a676: a9 00       ..
    sta l00db                                                         ; a678: 85 db       ..
.ca67a
    lda l0000,y                                                       ; a67a: b9 00 00    ...
    bmi econet_clear_rxcbv_exists_flag                                ; a67d: 30 11       0.
    inc l00da                                                         ; a67f: e6 da       ..
    bne ca67a                                                         ; a681: d0 f7       ..
    inc l00db                                                         ; a683: e6 db       ..
    bne ca67a                                                         ; a685: d0 f3       ..
    dec l00dc                                                         ; a687: c6 dc       ..
    bne ca67a                                                         ; a689: d0 ef       ..
    lda #2                                                            ; a68b: a9 02       ..
    jmp econet_error_a                                                ; a68d: 4c 3c a8    L<.

.econet_clear_rxcbv_exists_flag
    pha                                                               ; a690: 48          H
    lda flags                                                         ; a691: ad 3a 02    .:.
    and #&7f                                                          ; a694: 29 7f       ).
    sta flags                                                         ; a696: 8d 3a 02    .:.
    pla                                                               ; a699: 68          h
    rts                                                               ; a69a: 60          `

.sub_ca69b
    ldx #8                                                            ; a69b: a2 08       ..
.loop_ca69d
    lda init_00d0_00d8,x                                              ; a69d: bd b3 a6    ...
    sta blkd_d0_flag,x                                                ; a6a0: 95 d0       ..
    dex                                                               ; a6a2: ca          .
    bpl loop_ca69d                                                    ; a6a3: 10 f8       ..
    jsr econet_set_fileserver_stn_in_d0                               ; a6a5: 20 0d a8     ..
    jmp econet_set_rxcbv_to_d0                                        ; a6a8: 4c 5d a8    L].

.init_00d0_00d7
    equb &80, &99,   0,   0, &16,   1, &66,   1                       ; a6ab: 80 99 00... ...
.init_00d0_00d8
    equb &7f, &88,   0,   0, &19,   1, &ff, &ff,   0                  ; a6b3: 7f 88 00... ...

.econet_file_server_send_command
    ldy #7                                                            ; a6bc: a0 07       ..
.loop_ca6be
    ldx init_00d0_00d7,y                                              ; a6be: be ab a6    ...
    stx blkd_d0_flag,y                                                ; a6c1: 96 d0       ..
    dey                                                               ; a6c3: 88          .
    bpl loop_ca6be                                                    ; a6c4: 10 f8       ..
    jsr econet_set_fileserver_stn_in_d0                               ; a6c6: 20 0d a8     ..
    lda #&60                                                          ; a6c9: a9 60       .`
    ldy #&30                                                          ; a6cb: a0 30       .0
    jmp econet_transmit_blk_d0_with_retries                           ; a6cd: 4c 18 a8    L..

.error_handler1
    jsr sub_caff1                                                     ; a6d0: 20 f1 af     ..
    lsr char_not_sent_to_printer                                      ; a6d3: 46 fe       F.
    jmp econet_error_a                                                ; a6d5: 4c 3c a8    L<.

.sub_ca6d8
    ldx #3                                                            ; a6d8: a2 03       ..
.ca6da
    lda vectors + 2,x                                                 ; a6da: bd 74 a7    .t.
    sta wrcvec,x                                                      ; a6dd: 9d 08 02    ...
    dex                                                               ; a6e0: ca          .
    bpl ca6da                                                         ; a6e1: 10 f7       ..
    rts                                                               ; a6e3: 60          `

.init_0228_022f
    equb               0,               0, <error_handler2            ; a6e4: 00 00 f9    ...
    equb >error_handler2,             &fe,               0            ; a6e7: a8 fe 00    ...
    equb             &eb,               0                             ; a6ea: eb 00       ..
.init_00d4_00d9
    equb &48,   1, &4d,   1,   0                                      ; a6ec: 48 01 4d... H.M

    ;; Not used from the ROM, but used from the *VIEW and *REMOTE commands
.econet_check_end_of_line
    pha                                                               ; a6f1: 48          H
    jsr kern_skip_spaces                                              ; a6f2: 20 76 f8     v.
    cmp #&0d                                                          ; a6f5: c9 0d       ..
    beq ca6fc                                                         ; a6f7: f0 03       ..
    jmp kern_syn_error                                                ; a6f9: 4c 7d fa    L}.

.ca6fc
    pla                                                               ; a6fc: 68          h
    rts                                                               ; a6fd: 60          `

IF (BASE = &A000)
    equb 4, 4                                                         ; a6fe: 04 04       ..
ENDIF

.function0
    jmp ca732                                                         ; a700: 4c 32 a7    L2.

.function1
    jmp cmd_COS                                                       ; a703: 4c 50 a7    LP.

.function2
    jmp ca75c                                                         ; a706: 4c 5c a7    L\.

.function3
    jmp econet_file_server_send_command_wait_response                 ; a709: 4c 58 a6    LX.

.function4
    jmp function7                                                     ; a70c: 4c 16 a7    L..

.function5
    jmp econet_transmit_blk_x_with_retries                            ; a70f: 4c 1a a8    L..

.function6
    equb   2,   0, &50, &34                                           ; a712: 02 00 50... ..P

.function7
    pha                                                               ; a716: 48          H
    lda prot_mask                                                     ; a717: ad 3b 02    .;.
    and #&e3                                                          ; a71a: 29 e3       ).
    sta prot_mask                                                     ; a71c: 8d 3b 02    .;.
    pla                                                               ; a71f: 68          h
    cmp #1                                                            ; a720: c9 01       ..
    bne ca72b                                                         ; a722: d0 07       ..
    stx notifying_stn                                                 ; a724: 8e 28 02    .(.
    sty notifying_stn + 1                                             ; a727: 8c 29 02    .).
.loop_ca72a
    rts                                                               ; a72a: 60          `

.ca72b
    cmp #2                                                            ; a72b: c9 02       ..
    bne loop_ca72a                                                    ; a72d: d0 fb       ..
    jmp start_remote                                                  ; a72f: 4c 6b ad    Lk.

.ca732
    lda #&70                                                          ; a732: a9 70       .p
    eor #&60                                                          ; a734: 49 60       I`
    sta screen + 21                                                   ; a736: 8d 15 80    ...
    ldx #&15                                                          ; a739: a2 15       ..
.loop_ca73b
    lda vectors,x                                                     ; a73b: bd 72 a7    .r.
    sta comvec,x                                                      ; a73e: 9d 06 02    ...
    dex                                                               ; a741: ca          .
    bpl loop_ca73b                                                    ; a742: 10 f7       ..
.sub_ca744
    ldx #7                                                            ; a744: a2 07       ..
.ca746
    lda init_0228_022f,x                                              ; a746: bd e4 a6    ...
    sta notifying_stn,x                                               ; a749: 9d 28 02    .(.
    dex                                                               ; a74c: ca          .
    bpl ca746                                                         ; a74d: 10 f7       ..
    rts                                                               ; a74f: 60          `

.cmd_COS
    ldx #&15                                                          ; a750: a2 15       ..
.ca752
    lda kern_vectors + 2,x                                            ; a752: bd 9c ff    ...
    sta comvec,x                                                      ; a755: 9d 06 02    ...
    dex                                                               ; a758: ca          .
    bpl ca752                                                         ; a759: 10 f7       ..
    rts                                                               ; a75b: 60          `

.ca75c
    ldx #&10                                                          ; a75c: a2 10       ..
.loop_ca75e
    lda kern_vectors + 7,x                                            ; a75e: bd a1 ff    ...
    sta rdcvec + 1,x                                                  ; a761: 9d 0b 02    ...
    dex                                                               ; a764: ca          .
    bne loop_ca75e                                                    ; a765: d0 f7       ..
    inx                                                               ; a767: e8          .
    jsr ca6da                                                         ; a768: 20 da a6     ..
    jsr sub_ca744                                                     ; a76b: 20 44 a7     D.
    ldx #1                                                            ; a76e: a2 01       ..
    bne ca752                                                         ; a770: d0 e0       ..
; overlapping: sbc l48ac,y                                            ; a772: f9 ac 48    ..H
.vectors
    equw  eco_cli, eco_wrch, eco_rdch, eco_load, eco_save, eco_rdar   ; a772: f9 ac 48... ..H
    equw eco_star, eco_bget, eco_bput, eco_find, eco_shut             ; a77e: a3 ab 7b... ..{

.econet_osasci_string_011a
    ldx #0                                                            ; a788: a2 00       ..
.loop_ca78a
    lda fs_cmd_handle_lib,x                                           ; a78a: bd 1a 01    ...
    bmi ca79e                                                         ; a78d: 30 0f       0.
    bne ca793                                                         ; a78f: d0 02       ..
    lda #&0d                                                          ; a791: a9 0d       ..
.ca793
    jsr osasci                                                        ; a793: 20 e9 ff     ..
    inx                                                               ; a796: e8          .
    bne loop_ca78a                                                    ; a797: d0 f1       ..
.econet_test_escape_in_z
    lda #&20                                                          ; a799: a9 20       .
    bit pia + 1                                                       ; a79b: 2c 01 b0    ,..
.ca79e
    rts                                                               ; a79e: 60          `

.cmd_UNKNOWN
    ldy #0                                                            ; a79f: a0 00       ..
.loop_ca7a1
    lda command_line,y                                                ; a7a1: b9 00 01    ...
    iny                                                               ; a7a4: c8          .
    cmp #&0d                                                          ; a7a5: c9 0d       ..
    bne loop_ca7a1                                                    ; a7a7: d0 f8       ..
.loop_ca7a9
    lda command_line,y                                                ; a7a9: b9 00 01    ...
    sta fs_cmd_param0,y                                               ; a7ac: 99 1b 01    ...
    dey                                                               ; a7af: 88          .
    bpl loop_ca7a9                                                    ; a7b0: 10 f7       ..
    iny                                                               ; a7b2: c8          .
    jsr econet_file_server_send_command_wait_response                 ; a7b3: 20 58 a6     X.
    beq econet_fill_0110_013d_0d                                      ; a7b6: f0 0b       ..
    asl a                                                             ; a7b8: 0a          .
    tax                                                               ; a7b9: aa          .
    lda fserv_table - 1,x                                             ; a7ba: bd cf a7    ...
    pha                                                               ; a7bd: 48          H
    lda fserv_table - 2,x                                             ; a7be: bd ce a7    ...
    pha                                                               ; a7c1: 48          H
    rts                                                               ; a7c2: 60          `

.econet_fill_0110_013d_0d
    ldx #&2f                                                          ; a7c3: a2 2f       ./
    pha                                                               ; a7c5: 48          H
    lda #&0d                                                          ; a7c6: a9 0d       ..
.loop_ca7c8
    sta l0110,x                                                       ; a7c8: 9d 10 01    ...
    dex                                                               ; a7cb: ca          .
    bpl loop_ca7c8                                                    ; a7cc: 10 fa       ..
    pla                                                               ; a7ce: 68          h
    rts                                                               ; a7cf: 60          `

.fserv_table
    equw fserv_01_save-1                                              ; a7d0: 9e a9       ..
    equw fserv_02_load-1                                              ; a7d2: 71 aa       q.
    equw fserv_03-1                                                   ; a7d4: 11 ac       ..
    equw fserv_04_info-1                                              ; a7d6: 89 ac       ..
    equw fserv_05_sdisc_06_iam-1                                      ; a7d8: 39 a9       9.
    equw fserv_05_sdisc_06_iam-1                                      ; a7da: 39 a9       9.
    equw fserv_07_dir-1                                               ; a7dc: be ac       ..
    equw fserv_08_unrecognised-1                                      ; a7de: b1 ac       ..
    equw fserv_09_lib-1                                               ; a7e0: c5 ac       ..

.sub_ca7e2
    lda #5                                                            ; a7e2: a9 05       ..
.sub_ca7e4
    tay                                                               ; a7e4: a8          .
.ca7e5
    lda (l0000,x)                                                     ; a7e5: a1 00       ..
    sta fs_cmd_reply_port,y                                           ; a7e7: 99 16 01    ...
    cmp #&0d                                                          ; a7ea: c9 0d       ..
    beq ca80c                                                         ; a7ec: f0 1e       ..
    iny                                                               ; a7ee: c8          .
    inc l0000,x                                                       ; a7ef: f6 00       ..
    bne ca7e5                                                         ; a7f1: d0 f2       ..
    inc l0001,x                                                       ; a7f3: f6 01       ..
    bne ca7e5                                                         ; a7f5: d0 ee       ..
.econet_file_server_init_command_y
    ldx #&88                                                          ; a7f7: a2 88       ..
    stx fs_cmd_reply_port                                             ; a7f9: 8e 16 01    ...
    sty fs_cmd_function_or_command_code                               ; a7fc: 8c 17 01    ...
    pha                                                               ; a7ff: 48          H
    ldx #2                                                            ; a800: a2 02       ..
.loop_ca802
    lda handle_urd,x                                                  ; a802: bd 24 02    .$.
    sta fs_cmd_handle_root_or_return_code,x                           ; a805: 9d 18 01    ...
    dex                                                               ; a808: ca          .
    bpl loop_ca802                                                    ; a809: 10 f7       ..
    pla                                                               ; a80b: 68          h
.ca80c
    rts                                                               ; a80c: 60          `

.econet_set_fileserver_stn_in_d0
    lda fileserver_stn                                                ; a80d: ad 2c 02    .,.
    sta blkd_d2_stn_lo                                                ; a810: 85 d2       ..
    lda fileserver_stn + 1                                            ; a812: ad 2d 02    .-.
    sta blkd_d3_stn_hi                                                ; a815: 85 d3       ..
    rts                                                               ; a817: 60          `

.econet_transmit_blk_d0_with_retries
    ldx #&d0                                                          ; a818: a2 d0       ..
.econet_transmit_blk_x_with_retries
    pha                                                               ; a81a: 48          H
    tya                                                               ; a81b: 98          .
    pha                                                               ; a81c: 48          H
    lda l0000,x                                                       ; a81d: b5 00       ..
    pha                                                               ; a81f: 48          H
    ldy #0                                                            ; a820: a0 00       ..
    jsr transmit                                                      ; a822: 20 3d 02     =.
    lda l0000,x                                                       ; a825: b5 00       ..
    rol a                                                             ; a827: 2a          *
    bpl ca843                                                         ; a828: 10 19       ..
    pla                                                               ; a82a: 68          h
    sta l0000,x                                                       ; a82b: 95 00       ..
    pla                                                               ; a82d: 68          h
    tay                                                               ; a82e: a8          .
    pla                                                               ; a82f: 68          h
    clc                                                               ; a830: 18          .
    sbc #0                                                            ; a831: e9 00       ..
    beq ca83a                                                         ; a833: f0 05       ..
    jsr econet_delay_approx_y_ms                                      ; a835: 20 48 a8     H.
    bne econet_transmit_blk_x_with_retries                            ; a838: d0 e0       ..
.ca83a
    lda #1                                                            ; a83a: a9 01       ..
.econet_error_a
    ldx #&19                                                          ; a83c: a2 19       ..
    ldy #1                                                            ; a83e: a0 01       ..
    jmp (error_handler)                                               ; a840: 6c 2a 02    l*.

.ca843
    pla                                                               ; a843: 68          h
    pla                                                               ; a844: 68          h
    tay                                                               ; a845: a8          .
    pla                                                               ; a846: 68          h
    rts                                                               ; a847: 60          `

.econet_delay_approx_y_ms
    cpy #0                                                            ; a848: c0 00       ..
    beq ca85c                                                         ; a84a: f0 10       ..
    pha                                                               ; a84c: 48          H
    txa                                                               ; a84d: 8a          .
    pha                                                               ; a84e: 48          H
    ldx #0                                                            ; a84f: a2 00       ..
    tya                                                               ; a851: 98          .
.ca852
    dex                                                               ; a852: ca          .
    bne ca852                                                         ; a853: d0 fd       ..
    dey                                                               ; a855: 88          .
    bne ca852                                                         ; a856: d0 fa       ..
    tay                                                               ; a858: a8          .
    pla                                                               ; a859: 68          h
    tax                                                               ; a85a: aa          .
    pla                                                               ; a85b: 68          h
.ca85c
    rts                                                               ; a85c: 60          `

.econet_set_rxcbv_to_d0
    lda #&d0                                                          ; a85d: a9 d0       ..
    ldx #0                                                            ; a85f: a2 00       ..
.econet_set_rxcbv_to_x
    jsr econet_clear_rxcbv_exists_flag                                ; a861: 20 90 a6     ..
    sta rxcbv                                                         ; a864: 8d 30 02    .0.
    stx rxcbv + 1                                                     ; a867: 8e 31 02    .1.
    lda flags                                                         ; a86a: ad 3a 02    .:.
    ora #&80                                                          ; a86d: 09 80       ..
    sta flags                                                         ; a86f: 8d 3a 02    .:.
    rts                                                               ; a872: 60          `

.econet_read_stn_or_user
    lda #0                                                            ; a873: a9 00       ..
    sta l0000,x                                                       ; a875: 95 00       ..
    sta l0001,x                                                       ; a877: 95 01       ..
    jsr kern_skip_spaces                                              ; a879: 20 76 f8     v.
    lda command_line,y                                                ; a87c: b9 00 01    ...
    cmp #&3a                                                          ; a87f: c9 3a       .:
    bcs ca8bd                                                         ; a881: b0 3a       .:
    sbc #&2f                                                          ; a883: e9 2f       ./
    bmi ca8bd                                                         ; a885: 30 36       06
.ca887
    lda command_line,y                                                ; a887: b9 00 01    ...
    cmp #&3a                                                          ; a88a: c9 3a       .:
    bcs ca8b8                                                         ; a88c: b0 2a       .*
    sbc #&2f                                                          ; a88e: e9 2f       ./
    bmi ca8b8                                                         ; a890: 30 26       0&
    iny                                                               ; a892: c8          .
    pha                                                               ; a893: 48          H
    lda l0001,x                                                       ; a894: b5 01       ..
    pha                                                               ; a896: 48          H
    lda l0000,x                                                       ; a897: b5 00       ..
    asl a                                                             ; a899: 0a          .
    rol l0001,x                                                       ; a89a: 36 01       6.
    asl a                                                             ; a89c: 0a          .
    rol l0001,x                                                       ; a89d: 36 01       6.
    adc l0000,x                                                       ; a89f: 75 00       u.
    sta l0000,x                                                       ; a8a1: 95 00       ..
    pla                                                               ; a8a3: 68          h
    adc l0001,x                                                       ; a8a4: 75 01       u.
    asl l0000,x                                                       ; a8a6: 16 00       ..
    rol a                                                             ; a8a8: 2a          *
    sta l0001,x                                                       ; a8a9: 95 01       ..
    pla                                                               ; a8ab: 68          h
    adc l0000,x                                                       ; a8ac: 75 00       u.
    sta l0000,x                                                       ; a8ae: 95 00       ..
    bcc ca887                                                         ; a8b0: 90 d5       ..
    inc l0001,x                                                       ; a8b2: f6 01       ..
    beq ca8f0                                                         ; a8b4: f0 3a       .:
    bne ca887                                                         ; a8b6: d0 cf       ..
.ca8b8
    lda l0000,x                                                       ; a8b8: b5 00       ..
    ora l0001,x                                                       ; a8ba: 15 01       ..
    rts                                                               ; a8bc: 60          `

.ca8bd
    txa                                                               ; a8bd: 8a          .
    pha                                                               ; a8be: 48          H
    ldx #0                                                            ; a8bf: a2 00       ..
.loop_ca8c1
    lda command_line,y                                                ; a8c1: b9 00 01    ...
    cmp #&20                                                          ; a8c4: c9 20       .
    beq ca8d3                                                         ; a8c6: f0 0b       ..
    cmp #&0d                                                          ; a8c8: c9 0d       ..
    beq ca8d3                                                         ; a8ca: f0 07       ..
    sta fs_cmd_param0,x                                               ; a8cc: 9d 1b 01    ...
    inx                                                               ; a8cf: e8          .
    iny                                                               ; a8d0: c8          .
    bne loop_ca8c1                                                    ; a8d1: d0 ee       ..
.ca8d3
    lda #&0d                                                          ; a8d3: a9 0d       ..
    sta fs_cmd_param0,x                                               ; a8d5: 9d 1b 01    ...
    tya                                                               ; a8d8: 98          .
    pha                                                               ; a8d9: 48          H
    ldy #&18                                                          ; a8da: a0 18       ..
    jsr econet_file_server_send_command_wait_response                 ; a8dc: 20 58 a6     X.
    pla                                                               ; a8df: 68          h
    tay                                                               ; a8e0: a8          .
    pla                                                               ; a8e1: 68          h
    tax                                                               ; a8e2: aa          .
    lda fs_cmd_param1                                                 ; a8e3: ad 1c 01    ...
    sta l0000,x                                                       ; a8e6: 95 00       ..
    lda fs_cmd_param2                                                 ; a8e8: ad 1d 01    ...
    sta l0001,x                                                       ; a8eb: 95 01       ..
    jmp ca8b8                                                         ; a8ed: 4c b8 a8    L..

.ca8f0
    jsr kern_print_string                                             ; a8f0: 20 d1 f7     ..
    equs "STN?"                                                       ; a8f3: 53 54 4e... STN

    nop                                                               ; a8f7: ea          .
    brk                                                               ; a8f8: 00          .

.error_handler2
    cmp #&10                                                          ; a8f9: c9 10       ..
    bcs ca922                                                         ; a8fb: b0 25       .%
    cmp #1                                                            ; a8fd: c9 01       ..
    beq ca90f                                                         ; a8ff: f0 0e       ..
    jsr kern_print_string                                             ; a901: 20 d1 f7     ..
    equs "NO REPLY"                                                   ; a904: 4e 4f 20... NO

IF (BASE = &A000)
    nop                                                               ; a90c: ea          .
    bmi ca936                                                         ; a90d: 30 27       0'
ELSE
    ;; Save space in other versions
    bne ca936
ENDIF

.ca90f
    jsr kern_print_string                                             ; a90f: 20 d1 f7     ..
    equs "NOT LISTENING"                                              ; a912: 4e 4f 54... NOT

IF (BASE = &A000)
    nop                                                               ; a91f: ea          .
    bmi ca936                                                         ; a920: 30 14       0.
ELSE
    ;; Save space in other versions
    bne ca936
ENDIF

.ca922
    tya                                                               ; a922: 98          .
    pha                                                               ; a923: 48          H
    ldy #2                                                            ; a924: a0 02       ..
.loop_ca926
    stx blkd_d0_flag                                                  ; a926: 86 d0       ..
    pla                                                               ; a928: 68          h
    pha                                                               ; a929: 48          H
    sta blkd_d1_port                                                  ; a92a: 85 d1       ..
    lda (blkd_d0_flag),y                                              ; a92c: b1 d0       ..
    jsr osasci                                                        ; a92e: 20 e9 ff     ..
    iny                                                               ; a931: c8          .
    cmp #&0d                                                          ; a932: c9 0d       ..
    bne loop_ca926                                                    ; a934: d0 f0       ..
.ca936
    jsr econet_clear_rxcbv_exists_flag                                ; a936: 20 90 a6     ..
    brk                                                               ; a939: 00          .

.fserv_05_sdisc_06_iam
    ldx #2                                                            ; a93a: a2 02       ..
.loop_ca93c
    lda fs_cmd_param0,x                                               ; a93c: bd 1b 01    ...
    sta handle_urd,x                                                  ; a93f: 9d 24 02    .$.
    dex                                                               ; a942: ca          .
    bpl loop_ca93c                                                    ; a943: 10 f7       ..
    jmp econet_fill_0110_013d_0d                                      ; a945: 4c c3 a7    L..

.sub_ca948
    sta l00da                                                         ; a948: 85 da       ..
    sty l0113                                                         ; a94a: 8c 13 01    ...
    sta l0114                                                         ; a94d: 8d 14 01    ...
    ldy #&99                                                          ; a950: a0 99       ..
    sty l0112                                                         ; a952: 8c 12 01    ...
    sty blkd_d1_port                                                  ; a955: 84 d1       ..
    jsr econet_set_fileserver_stn_in_d0                               ; a957: 20 0d a8     ..
    lda #&12                                                          ; a95a: a9 12       ..
    sta blkd_d4_buffer_start_lo                                       ; a95c: 85 d4       ..
    lda #1                                                            ; a95e: a9 01       ..
    sta blkd_d5_buffer_start_hi                                       ; a960: 85 d5       ..
    lda sequenceno                                                    ; a962: ad 27 02    .'.
    ldx #8                                                            ; a965: a2 08       ..
.loop_ca967
    lsr l00da                                                         ; a967: 46 da       F.
    bcs ca96f                                                         ; a969: b0 04       ..
    lsr a                                                             ; a96b: 4a          J
    dex                                                               ; a96c: ca          .
    bne loop_ca967                                                    ; a96d: d0 f8       ..
.ca96f
    ldy #2                                                            ; a96f: a0 02       ..
    ldx #4                                                            ; a971: a2 04       ..
.sub_ca973
    ora #&80                                                          ; a973: 09 80       ..
    sta blkd_d0_flag                                                  ; a975: 85 d0       ..
    clc                                                               ; a977: 18          .
    txa                                                               ; a978: 8a          .
    adc blkd_d4_buffer_start_lo                                       ; a979: 65 d4       e.
    sta blkd_d6_buffer_end_lo                                         ; a97b: 85 d6       ..
    lda blkd_d5_buffer_start_hi                                       ; a97d: a5 d5       ..
    adc #0                                                            ; a97f: 69 00       i.
    sta blkd_d7_buffer_end_hi                                         ; a981: 85 d7       ..
    lda #&ff                                                          ; a983: a9 ff       ..
    jsr econet_transmit_blk_d0_with_retries                           ; a985: 20 18 a8     ..
    ldx #&7f                                                          ; a988: a2 7f       ..
    stx blkd_d0_flag                                                  ; a98a: 86 d0       ..
    ldx #&ff                                                          ; a98c: a2 ff       ..
    stx blkd_d6_buffer_end_lo                                         ; a98e: 86 d6       ..
    stx blkd_d7_buffer_end_hi                                         ; a990: 86 d7       ..
    inx                                                               ; a992: e8          .
    stx blkd_d8_imm0                                                  ; a993: 86 d8       ..
    jsr econet_set_rxcbv_to_d0                                        ; a995: 20 5d a8     ].
    jsr econet_wait_response                                          ; a998: 20 70 a6     p.
    lda l0112                                                         ; a99b: ad 12 01    ...
    rts                                                               ; a99e: 60          `

.fserv_01_save
    clc                                                               ; a99f: 18          .
    lda fs_cmd_param0                                                 ; a9a0: ad 1b 01    ...
    sta l013c                                                         ; a9a3: 8d 3c 01    .<.
    adc l0123                                                         ; a9a6: 6d 23 01    m#.
    sta l013e                                                         ; a9a9: 8d 3e 01    .>.
    lda fs_cmd_param1                                                 ; a9ac: ad 1c 01    ...
    sta l013d                                                         ; a9af: 8d 3d 01    .=.
    adc l0124                                                         ; a9b2: 6d 24 01    m$.
    sta l013f                                                         ; a9b5: 8d 3f 01    .?.
    jmp caa00                                                         ; a9b8: 4c 00 aa    L..

.eco_save
    lda #&10                                                          ; a9bb: a9 10       ..
    jsr sub_ca7e4                                                     ; a9bd: 20 e4 a7     ..
    lda l0006,x                                                       ; a9c0: b5 06       ..
    sta l013c                                                         ; a9c2: 8d 3c 01    .<.
    lda l0007,x                                                       ; a9c5: b5 07       ..
    sta l013d                                                         ; a9c7: 8d 3d 01    .=.
    lda l0008,x                                                       ; a9ca: b5 08       ..
    sta l013e                                                         ; a9cc: 8d 3e 01    .>.
    sec                                                               ; a9cf: 38          8
    sbc l0006,x                                                       ; a9d0: f5 06       ..
    sta l0006,x                                                       ; a9d2: 95 06       ..
    lda l0009,x                                                       ; a9d4: b5 09       ..
    sta l013f                                                         ; a9d6: 8d 3f 01    .?.
    sbc l0007,x                                                       ; a9d9: f5 07       ..
    sta l0007,x                                                       ; a9db: 95 07       ..
    lda #0                                                            ; a9dd: a9 00       ..
    sta l0008,x                                                       ; a9df: 95 08       ..
    ldy #&0a                                                          ; a9e1: a0 0a       ..
    lda #0                                                            ; a9e3: a9 00       ..
.loop_ca9e5
    sta fs_cmd_param0,y                                               ; a9e5: 99 1b 01    ...
    dey                                                               ; a9e8: 88          .
    bpl loop_ca9e5                                                    ; a9e9: 10 fa       ..
    iny                                                               ; a9eb: c8          .
.loop_ca9ec
    lda l0002,x                                                       ; a9ec: b5 02       ..
    sta fs_cmd_param0,y                                               ; a9ee: 99 1b 01    ...
    lda l0003,x                                                       ; a9f1: b5 03       ..
    sta fs_cmd_param1,y                                               ; a9f3: 99 1c 01    ...
    iny                                                               ; a9f6: c8          .
    iny                                                               ; a9f7: c8          .
    iny                                                               ; a9f8: c8          .
    iny                                                               ; a9f9: c8          .
    inx                                                               ; a9fa: e8          .
    inx                                                               ; a9fb: e8          .
    cpy #&0c                                                          ; a9fc: c0 0c       ..
    bne loop_ca9ec                                                    ; a9fe: d0 ec       ..
.caa00
    ldy #1                                                            ; aa00: a0 01       ..
    jsr econet_file_server_init_command_y                             ; aa02: 20 f7 a7     ..
    lda #&77                                                          ; aa05: a9 77       .w
    sta fs_cmd_handle_root_or_return_code                             ; aa07: 8d 18 01    ...
    jsr sub_ca65b                                                     ; aa0a: 20 5b a6     [.
    lda #0                                                            ; aa0d: a9 00       ..
    sta l0120                                                         ; aa0f: 8d 20 01    . .
.caa12
    lda l013c                                                         ; aa12: ad 3c 01    .<.
    sta blkd_d4_buffer_start_lo                                       ; aa15: 85 d4       ..
    clc                                                               ; aa17: 18          .
    adc fs_cmd_param1                                                 ; aa18: 6d 1c 01    m..
    sta blkd_d6_buffer_end_lo                                         ; aa1b: 85 d6       ..
    lda l013d                                                         ; aa1d: ad 3d 01    .=.
    sta blkd_d5_buffer_start_hi                                       ; aa20: 85 d5       ..
    adc fs_cmd_param2                                                 ; aa22: 6d 1d 01    m..
    sta blkd_d7_buffer_end_hi                                         ; aa25: 85 d7       ..
    bcs caa35                                                         ; aa27: b0 0c       ..
    lda blkd_d6_buffer_end_lo                                         ; aa29: a5 d6       ..
    cmp l013e                                                         ; aa2b: cd 3e 01    .>.
    lda blkd_d7_buffer_end_hi                                         ; aa2e: a5 d7       ..
    sbc l013f                                                         ; aa30: ed 3f 01    .?.
    bcc caa42                                                         ; aa33: 90 0d       ..
.caa35
    lda l013e                                                         ; aa35: ad 3e 01    .>.
    sta blkd_d6_buffer_end_lo                                         ; aa38: 85 d6       ..
    lda l013f                                                         ; aa3a: ad 3f 01    .?.
    sta blkd_d7_buffer_end_hi                                         ; aa3d: 85 d7       ..
    inc l0120                                                         ; aa3f: ee 20 01    . .
.caa42
    lda fs_cmd_param0                                                 ; aa42: ad 1b 01    ...
    sta blkd_d1_port                                                  ; aa45: 85 d1       ..
    ldx #&d0                                                          ; aa47: a2 d0       ..
    ldy #&0a                                                          ; aa49: a0 0a       ..
    lda #&ff                                                          ; aa4b: a9 ff       ..
    jsr econet_transmit_blk_x_with_retries                            ; aa4d: 20 1a a8     ..
    lda l0120                                                         ; aa50: ad 20 01    . .
    bne caa6c                                                         ; aa53: d0 17       ..
    lda blkd_d6_buffer_end_lo                                         ; aa55: a5 d6       ..
    sta l013c                                                         ; aa57: 8d 3c 01    .<.
    lda blkd_d7_buffer_end_hi                                         ; aa5a: a5 d7       ..
    sta l013d                                                         ; aa5c: 8d 3d 01    .=.
    jsr sub_ca69b                                                     ; aa5f: 20 9b a6     ..
    lda #&77                                                          ; aa62: a9 77       .w
    sta blkd_d1_port                                                  ; aa64: 85 d1       ..
    jsr econet_wait_response                                          ; aa66: 20 70 a6     p.
    jmp caa12                                                         ; aa69: 4c 12 aa    L..

.caa6c
    jsr sub_ca65e                                                     ; aa6c: 20 5e a6     ^.
    jmp econet_fill_0110_013d_0d                                      ; aa6f: 4c c3 a7    L..

.fserv_02_load
    lda fs_cmd_param0                                                 ; aa72: ad 1b 01    ...
    sta l013d                                                         ; aa75: 8d 3d 01    .=.
    lda fs_cmd_param1                                                 ; aa78: ad 1c 01    ...
    sta l013e                                                         ; aa7b: 8d 3e 01    .>.
    lda fs_cmd_param4                                                 ; aa7e: ad 1f 01    ...
    sta l013f                                                         ; aa81: 8d 3f 01    .?.
    ldx #0                                                            ; aa84: a2 00       ..
.loop_caa86
    lda l0120,x                                                       ; aa86: bd 20 01    . .
    sta fs_cmd_param0,x                                               ; aa89: 9d 1b 01    ...
    inx                                                               ; aa8c: e8          .
    cmp #&0d                                                          ; aa8d: c9 0d       ..
    bne loop_caa86                                                    ; aa8f: d0 f5       ..
    txa                                                               ; aa91: 8a          .
    clc                                                               ; aa92: 18          .
    bcc caaa7                                                         ; aa93: 90 12       ..
.eco_load
    lda l0002,x                                                       ; aa95: b5 02       ..
    sta l013d                                                         ; aa97: 8d 3d 01    .=.
    lda l0003,x                                                       ; aa9a: b5 03       ..
    sta l013e                                                         ; aa9c: 8d 3e 01    .>.
    lda l0004,x                                                       ; aa9f: b5 04       ..
    sta l013f                                                         ; aaa1: 8d 3f 01    .?.
    jsr sub_ca7e2                                                     ; aaa4: 20 e2 a7     ..
.caaa7
    ldy #2                                                            ; aaa7: a0 02       ..
.sub_caaa9
    jsr econet_file_server_init_command_y                             ; aaa9: 20 f7 a7     ..
    ldx #&2d                                                          ; aaac: a2 2d       .-
    stx fs_cmd_handle_root_or_return_code                             ; aaae: 8e 18 01    ...
    jsr sub_ca65b                                                     ; aab1: 20 5b a6     [.
    bit l013f                                                         ; aab4: 2c 3f 01    ,?.
    bpl caac6                                                         ; aab7: 10 0d       ..
    lda l013d                                                         ; aab9: ad 3d 01    .=.
    sta blkd_d4_buffer_start_lo                                       ; aabc: 85 d4       ..
    lda l013e                                                         ; aabe: ad 3e 01    .>.
    sta blkd_d5_buffer_start_hi                                       ; aac1: 85 d5       ..
    jmp caad2                                                         ; aac3: 4c d2 aa    L..

.caac6
    lda fs_cmd_param0                                                 ; aac6: ad 1b 01    ...
    sta blkd_d4_buffer_start_lo                                       ; aac9: 85 d4       ..
    lda fs_cmd_param1                                                 ; aacb: ad 1c 01    ...
    sta blkd_d5_buffer_start_hi                                       ; aace: 85 d5       ..
    lda #8                                                            ; aad0: a9 08       ..
.caad2
    pha                                                               ; aad2: 48          H
    clc                                                               ; aad3: 18          .
    lda blkd_d4_buffer_start_lo                                       ; aad4: a5 d4       ..
    adc l0123                                                         ; aad6: 6d 23 01    m#.
    sta l0123                                                         ; aad9: 8d 23 01    .#.
    lda blkd_d5_buffer_start_hi                                       ; aadc: a5 d5       ..
    adc l0124                                                         ; aade: 6d 24 01    m$.
    sta l0124                                                         ; aae1: 8d 24 01    .$.
    lda #&2d                                                          ; aae4: a9 2d       .-
    sta blkd_d1_port                                                  ; aae6: 85 d1       ..
.caae8
    lda #&ff                                                          ; aae8: a9 ff       ..
    sta blkd_d6_buffer_end_lo                                         ; aaea: 85 d6       ..
    sta blkd_d7_buffer_end_hi                                         ; aaec: 85 d7       ..
    lda #&7f                                                          ; aaee: a9 7f       ..
    sta blkd_d0_flag                                                  ; aaf0: 85 d0       ..
    jsr econet_set_rxcbv_to_d0                                        ; aaf2: 20 5d a8     ].
    ldy #&d0                                                          ; aaf5: a0 d0       ..
    pla                                                               ; aaf7: 68          h
    jsr sub_ca674                                                     ; aaf8: 20 74 a6     t.
    lda blkd_d6_buffer_end_lo                                         ; aafb: a5 d6       ..
    cmp l0123                                                         ; aafd: cd 23 01    .#.
    lda blkd_d7_buffer_end_hi                                         ; ab00: a5 d7       ..
    sbc l0124                                                         ; ab02: ed 24 01    .$.
    bcs cab15                                                         ; ab05: b0 0e       ..
    lda blkd_d6_buffer_end_lo                                         ; ab07: a5 d6       ..
    sta blkd_d4_buffer_start_lo                                       ; ab09: 85 d4       ..
    lda blkd_d7_buffer_end_hi                                         ; ab0b: a5 d7       ..
    sta blkd_d5_buffer_start_hi                                       ; ab0d: 85 d5       ..
    lda #8                                                            ; ab0f: a9 08       ..
    pha                                                               ; ab11: 48          H
    jmp caae8                                                         ; ab12: 4c e8 aa    L..

.cab15
    jsr sub_ca65e                                                     ; ab15: 20 5e a6     ^.
    lda fs_cmd_param4                                                 ; ab18: ad 1f 01    ...
    sta blkd_d0_flag                                                  ; ab1b: 85 d0       ..
    lda l0120                                                         ; ab1d: ad 20 01    . .
    sta blkd_d1_port                                                  ; ab20: 85 d1       ..
    jmp econet_fill_0110_013d_0d                                      ; ab22: 4c c3 a7    L..

.eco_find
    lda #0                                                            ; ab25: a9 00       ..
    sta fs_cmd_param1                                                 ; ab27: 8d 1c 01    ...
    rol a                                                             ; ab2a: 2a          *
    sta fs_cmd_param0                                                 ; ab2b: 8d 1b 01    ...
    lda #7                                                            ; ab2e: a9 07       ..
    jsr sub_ca7e4                                                     ; ab30: 20 e4 a7     ..
    ldy #6                                                            ; ab33: a0 06       ..
    jsr econet_file_server_init_command_y                             ; ab35: 20 f7 a7     ..
    jsr econet_file_server_send_command                               ; ab38: 20 bc a6     ..
    jsr sub_ca66d                                                     ; ab3b: 20 6d a6     m.
    lda fs_cmd_handle_lib                                             ; ab3e: ad 1a 01    ...
    beq cab4e                                                         ; ab41: f0 0b       ..
    cmp #&43                                                          ; ab43: c9 43       .C
    beq cab4a                                                         ; ab45: f0 03       ..
    jmp econet_error_a                                                ; ab47: 4c 3c a8    L<.

.cab4a
    lda #0                                                            ; ab4a: a9 00       ..
    beq cab5b                                                         ; ab4c: f0 0d       ..
.cab4e
    clc                                                               ; ab4e: 18          .
    sbc fs_cmd_param0                                                 ; ab4f: ed 1b 01    ...
    and sequenceno                                                    ; ab52: 2d 27 02    -'.
    sta sequenceno                                                    ; ab55: 8d 27 02    .'.
    lda fs_cmd_param0                                                 ; ab58: ad 1b 01    ...
.cab5b
    jmp econet_fill_0110_013d_0d                                      ; ab5b: 4c c3 a7    L..

.eco_bput
    sta l0115                                                         ; ab5e: 8d 15 01    ...
    txa                                                               ; ab61: 8a          .
    pha                                                               ; ab62: 48          H
    tya                                                               ; ab63: 98          .
    pha                                                               ; ab64: 48          H
    lda l0115                                                         ; ab65: ad 15 01    ...
    pha                                                               ; ab68: 48          H
    tya                                                               ; ab69: 98          .
    ldy #9                                                            ; ab6a: a0 09       ..
    jsr sub_ca948                                                     ; ab6c: 20 48 a9     H.
    lda l0113                                                         ; ab6f: ad 13 01    ...
    bne cab89                                                         ; ab72: d0 15       ..
    pla                                                               ; ab74: 68          h
    sta l0114                                                         ; ab75: 8d 14 01    ...
    jmp cab95                                                         ; ab78: 4c 95 ab    L..

.eco_bget
    txa                                                               ; ab7b: 8a          .
    pha                                                               ; ab7c: 48          H
    tya                                                               ; ab7d: 98          .
    pha                                                               ; ab7e: 48          H
    ldy #8                                                            ; ab7f: a0 08       ..
    jsr sub_ca948                                                     ; ab81: 20 48 a9     H.
    lda l0113                                                         ; ab84: ad 13 01    ...
    beq cab90                                                         ; ab87: f0 07       ..
.cab89
    ldx #&12                                                          ; ab89: a2 12       ..
    ldy #1                                                            ; ab8b: a0 01       ..
    jmp (error_handler)                                               ; ab8d: 6c 2a 02    l*.

.cab90
    lda l0115                                                         ; ab90: ad 15 01    ...
    asl a                                                             ; ab93: 0a          .
    asl a                                                             ; ab94: 0a          .
.cab95
    pla                                                               ; ab95: 68          h
    tay                                                               ; ab96: a8          .
    eor sequenceno                                                    ; ab97: 4d 27 02    M'.
    sta sequenceno                                                    ; ab9a: 8d 27 02    .'.
    pla                                                               ; ab9d: 68          h
    tax                                                               ; ab9e: aa          .
    lda l0114                                                         ; ab9f: ad 14 01    ...
    rts                                                               ; aba2: 60          `

.eco_star
    txa                                                               ; aba3: 8a          .
    pha                                                               ; aba4: 48          H
    sty fs_cmd_param0                                                 ; aba5: 8c 1b 01    ...
    ldy #0                                                            ; aba8: a0 00       ..
    sty fs_cmd_param1                                                 ; abaa: 8c 1c 01    ...
.loop_cabad
    lda l0000,x                                                       ; abad: b5 00       ..
    sta fs_cmd_param2,y                                               ; abaf: 99 1d 01    ...
    inx                                                               ; abb2: e8          .
    iny                                                               ; abb3: c8          .
    cpy #3                                                            ; abb4: c0 03       ..
    bne loop_cabad                                                    ; abb6: d0 f5       ..
    ldy #&0d                                                          ; abb8: a0 0d       ..
    jsr econet_file_server_send_command_wait_response                 ; abba: 20 58 a6     X.
    pla                                                               ; abbd: 68          h
    tax                                                               ; abbe: aa          .
    ldy fs_cmd_param0                                                 ; abbf: ac 1b 01    ...
    rts                                                               ; abc2: 60          `

.eco_rdar
    sty fs_cmd_param0                                                 ; abc3: 8c 1b 01    ...
    sta fs_cmd_param1                                                 ; abc6: 8d 1c 01    ...
    tya                                                               ; abc9: 98          .
    pha                                                               ; abca: 48          H
    txa                                                               ; abcb: 8a          .
    pha                                                               ; abcc: 48          H
    ldy #&0c                                                          ; abcd: a0 0c       ..
    jsr econet_file_server_send_command_wait_response                 ; abcf: 20 58 a6     X.
    pla                                                               ; abd2: 68          h
    tax                                                               ; abd3: aa          .
    inx                                                               ; abd4: e8          .
    inx                                                               ; abd5: e8          .
    ldy #2                                                            ; abd6: a0 02       ..
.loop_cabd8
    lda fs_cmd_param0,y                                               ; abd8: b9 1b 01    ...
    sta l0000,x                                                       ; abdb: 95 00       ..
    dex                                                               ; abdd: ca          .
    dey                                                               ; abde: 88          .
    bpl loop_cabd8                                                    ; abdf: 10 f7       ..
    inx                                                               ; abe1: e8          .
    pla                                                               ; abe2: 68          h
    tay                                                               ; abe3: a8          .
    rts                                                               ; abe4: 60          `

.eco_shut
    tya                                                               ; abe5: 98          .
    pha                                                               ; abe6: 48          H
    sta fs_cmd_param0                                                 ; abe7: 8d 1b 01    ...
    ldy #7                                                            ; abea: a0 07       ..
    jsr econet_file_server_send_command_wait_response                 ; abec: 20 58 a6     X.
    pla                                                               ; abef: 68          h
    tay                                                               ; abf0: a8          .
    rts                                                               ; abf1: 60          `

.cmd_I_AM
    jsr kern_skip_spaces                                              ; abf2: 20 76 f8     v.
    lda command_line,y                                                ; abf5: b9 00 01    ...
    cmp #&30                                                          ; abf8: c9 30       .0
    bcc cac0f                                                         ; abfa: 90 13       ..
    cmp #&3a                                                          ; abfc: c9 3a       .:
    bcs cac0f                                                         ; abfe: b0 0f       ..
    ldx #&d0                                                          ; ac00: a2 d0       ..
    jsr econet_read_stn_or_user                                       ; ac02: 20 73 a8     s.
    lda blkd_d0_flag                                                  ; ac05: a5 d0       ..
    sta fileserver_stn                                                ; ac07: 8d 2c 02    .,.
    lda blkd_d1_port                                                  ; ac0a: a5 d1       ..
    sta fileserver_stn + 1                                            ; ac0c: 8d 2d 02    .-.
.cac0f
    jmp cmd_UNKNOWN                                                   ; ac0f: 4c 9f a7    L..

.fserv_03
    ldy #0                                                            ; ac12: a0 00       ..
.loop_cac14
    lda fs_cmd_param0,y                                               ; ac14: b9 1b 01    ...
    sta l0148,y                                                       ; ac17: 99 48 01    .H.
    iny                                                               ; ac1a: c8          .
    cmp #&0d                                                          ; ac1b: c9 0d       ..
    bne loop_cac14                                                    ; ac1d: d0 f5       ..
    ldy #4                                                            ; ac1f: a0 04       ..
    jsr econet_file_server_send_command_wait_response                 ; ac21: 20 58 a6     X.
    jsr sub_caca4                                                     ; ac24: 20 a4 ac     ..
    jsr oscrlf                                                        ; ac27: 20 ed ff     ..
    lda #0                                                            ; ac2a: a9 00       ..
.cac2c
    pha                                                               ; ac2c: 48          H
    sta fs_cmd_param1                                                 ; ac2d: 8d 1c 01    ...
    lda #3                                                            ; ac30: a9 03       ..
    sta fs_cmd_param0                                                 ; ac32: 8d 1b 01    ...
    lda #2                                                            ; ac35: a9 02       ..
    sta fs_cmd_param2                                                 ; ac37: 8d 1d 01    ...
    lda #&48                                                          ; ac3a: a9 48       .H
    sta blkd_d0_flag                                                  ; ac3c: 85 d0       ..
    lda #1                                                            ; ac3e: a9 01       ..
    sta blkd_d1_port                                                  ; ac40: 85 d1       ..
    ldx #&d0                                                          ; ac42: a2 d0       ..
    lda #8                                                            ; ac44: a9 08       ..
    jsr sub_ca7e4                                                     ; ac46: 20 e4 a7     ..
    ldy #3                                                            ; ac49: a0 03       ..
    jsr econet_file_server_init_command_y                             ; ac4b: 20 f7 a7     ..
    jsr econet_file_server_send_command                               ; ac4e: 20 bc a6     ..
    ldx #8                                                            ; ac51: a2 08       ..
.loop_cac53
    lda init_00d0_00d8_alt1,x                                         ; ac53: bd 81 ac    ...
    sta blkd_d0_flag,x                                                ; ac56: 95 d0       ..
    dex                                                               ; ac58: ca          .
    bpl loop_cac53                                                    ; ac59: 10 f8       ..
    jsr econet_set_fileserver_stn_in_d0                               ; ac5b: 20 0d a8     ..
    jsr econet_set_rxcbv_to_d0                                        ; ac5e: 20 5d a8     ].
    jsr econet_wait_response                                          ; ac61: 20 70 a6     p.
    lda fs_cmd_function_or_command_code                               ; ac64: ad 17 01    ...
    beq cac70                                                         ; ac67: f0 07       ..
    ldx #&16                                                          ; ac69: a2 16       ..
    ldy #1                                                            ; ac6b: a0 01       ..
    jmp (error_handler)                                               ; ac6d: 6c 2a 02    l*.

.cac70
    lda fs_cmd_handle_root_or_return_code                             ; ac70: ad 18 01    ...
    beq cac7f                                                         ; ac73: f0 0a       ..
    jsr econet_osasci_string_011a                                     ; ac75: 20 88 a7     ..
    pla                                                               ; ac78: 68          h
    clc                                                               ; ac79: 18          .
    adc #2                                                            ; ac7a: 69 02       i.
    jmp cac2c                                                         ; ac7c: 4c 2c ac    L,.

.cac7f
    pla                                                               ; ac7f: 68          h
    rts                                                               ; ac80: 60          `

.init_00d0_00d8_alt1
    equb &7f, &88,   0,   0, &16,   1, &ff, &ff,   0                  ; ac81: 7f 88 00... ...

.fserv_04_info
    lda #&0d                                                          ; ac8a: a9 0d       ..
    sta l0157                                                         ; ac8c: 8d 57 01    .W.
    ldx #0                                                            ; ac8f: a2 00       ..
.loop_cac91
    lda fs_cmd_param0,x                                               ; ac91: bd 1b 01    ...
    jsr osasci                                                        ; ac94: 20 e9 ff     ..
    inx                                                               ; ac97: e8          .
    cpx #&1c                                                          ; ac98: e0 1c       ..
    bne loop_cac91                                                    ; ac9a: d0 f5       ..
    jsr oscrlf                                                        ; ac9c: 20 ed ff     ..
    inx                                                               ; ac9f: e8          .
    inx                                                               ; aca0: e8          .
    inx                                                               ; aca1: e8          .
    bne caca6                                                         ; aca2: d0 02       ..
.sub_caca4
    ldx #0                                                            ; aca4: a2 00       ..
.caca6
    lda fs_cmd_param0,x                                               ; aca6: bd 1b 01    ...
    bmi cacb1                                                         ; aca9: 30 06       0.
    jsr osasci                                                        ; acab: 20 e9 ff     ..
    inx                                                               ; acae: e8          .
    bne caca6                                                         ; acaf: d0 f5       ..
.cacb1
    rts                                                               ; acb1: 60          `

.fserv_08_unrecognised
    lda #0                                                            ; acb2: a9 00       ..
    sta l013f                                                         ; acb4: 8d 3f 01    .?.
    ldy #5                                                            ; acb7: a0 05       ..
    jsr sub_caaa9                                                     ; acb9: 20 a9 aa     ..
    jmp (blkd_d0_flag)                                                ; acbc: 6c d0 00    l..

.fserv_07_dir
    lda fs_cmd_param0                                                 ; acbf: ad 1b 01    ...
    sta handle_csd                                                    ; acc2: 8d 25 02    .%.
    rts                                                               ; acc5: 60          `

.fserv_09_lib
    lda fs_cmd_param0                                                 ; acc6: ad 1b 01    ...
    sta handle_lib                                                    ; acc9: 8d 26 02    .&.
    rts                                                               ; accc: 60          `

.command_table
    equs "."                                                          ; accd: 2e          .
    equb >(cmd_UNKNOWN-1)                                             ; acce: a7          .
    equb <(cmd_UNKNOWN-1)                                             ; accf: 9e          .
    equs "GO"                                                         ; acd0: 47 4f       GO
    equb >(kern_cli_handler-1)                                        ; acd2: f8          .
    equb <(kern_cli_handler-1)                                        ; acd3: ee          .
    equs "I."                                                         ; acd4: 49 2e       I.
    equb >(cmd_UNKNOWN-1)                                             ; acd6: a7          .
    equb <(cmd_UNKNOWN-1)                                             ; acd7: 9e          .
    equs "I AM"                                                       ; acd8: 49 20 41... I A
    equb >(cmd_I_AM-1)                                                ; acdc: ab          .
    equb <(cmd_I_AM-1)                                                ; acdd: f1          .
    equs "NOTIFY"                                                     ; acde: 4e 4f 54... NOT
    equb >(cmd_NOTIFY-1)                                              ; ace4: ad          .
    equb <(cmd_NOTIFY-1)                                              ; ace5: d7          .
    equs "COS"                                                        ; ace6: 43 4f 53    COS
    equb >(cmd_COS-1)                                                 ; ace9: a7          .
    equb <(cmd_COS-1)                                                 ; acea: 4f          O
    equs "ROFF"                                                       ; aceb: 52 4f 46... ROF
    equb >(cmd_ROFF-1)                                                ; acef: ad          .
    equb <(cmd_ROFF-1)                                                ; acf0: 83          .
    equb >(cmd_UNKNOWN-1)                                             ; acf1: a7          .
    equb <(cmd_UNKNOWN-1)                                             ; acf2: 9e          .

IF (BASE = &A000)
    ;; Save space in other versions
.unreachable
    ldx #&0c                                                          ; acf3: a2 0c       ..
    cld                                                               ; acf5: d8          .
    jmp cacfc                                                         ; acf6: 4c fc ac    L..
ENDIF

.eco_cli
    ldx #&ff                                                          ; acf9: a2 ff       ..
    cld                                                               ; acfb: d8          .
.cacfc
    ldy #0                                                            ; acfc: a0 00       ..
    jsr kern_skip_spaces                                              ; acfe: 20 76 f8     v.
    dey                                                               ; ad01: 88          .
.loop_cad02
    iny                                                               ; ad02: c8          .
    inx                                                               ; ad03: e8          .
.loop_cad04
    lda command_table,x                                               ; ad04: bd cd ac    ...
    bmi cad21                                                         ; ad07: 30 18       0.
    cmp command_line,y                                                ; ad09: d9 00 01    ...
    beq loop_cad02                                                    ; ad0c: f0 f4       ..
    dex                                                               ; ad0e: ca          .
.loop_cad0f
    inx                                                               ; ad0f: e8          .
    lda command_table,x                                               ; ad10: bd cd ac    ...
    bpl loop_cad0f                                                    ; ad13: 10 fa       ..
    inx                                                               ; ad15: e8          .
    lda command_line,y                                                ; ad16: b9 00 01    ...
    cmp #&2e                                                          ; ad19: c9 2e       ..
    bne cacfc                                                         ; ad1b: d0 df       ..
    iny                                                               ; ad1d: c8          .
    dex                                                               ; ad1e: ca          .
    bcs loop_cad04                                                    ; ad1f: b0 e3       ..
.cad21
    pha                                                               ; ad21: 48          H
    lda command_table + 1,x                                           ; ad22: bd ce ac    ...
    pha                                                               ; ad25: 48          H
    clc                                                               ; ad26: 18          .
    ldx #0                                                            ; ad27: a2 00       ..
    rts                                                               ; ad29: 60          `

.econet_init_blk_ed
    stx blke_ef_stn_lo                                                ; ad2a: 86 ef       ..
    sty blke_f0_stn_hi                                                ; ad2c: 84 f0       ..
    ldx #4                                                            ; ad2e: a2 04       ..
.loop_cad30
    lda init_00f1_00f5,x                                              ; ad30: bd 39 ad    .9.
    sta blke_f1_buffer_start_lo,x                                     ; ad33: 95 f1       ..
    dex                                                               ; ad35: ca          .
    bpl loop_cad30                                                    ; ad36: 10 f8       ..
    rts                                                               ; ad38: 60          `

.init_00f1_00f5
    equb &f6,   0, &f7,   0,   0                                      ; ad39: f6 00 f7... ...

.econet_transmit_blk_ed_with_retries
    lda #<error_handler3                                              ; ad3e: a9 62       .b
    sta error_handler                                                 ; ad40: 8d 2a 02    .*.
    lda #>error_handler3                                              ; ad43: a9 ad       ..
    sta error_handler + 1                                             ; ad45: 8d 2b 02    .+.
    lda #&80                                                          ; ad48: a9 80       ..
    sta blke_ed_flag                                                  ; ad4a: 85 ed       ..
    lda #&ff                                                          ; ad4c: a9 ff       ..
    ldy #&14                                                          ; ad4e: a0 14       ..
    ldx #&ed                                                          ; ad50: a2 ed       ..
    jsr econet_transmit_blk_x_with_retries                            ; ad52: 20 1a a8     ..
.sub_cad55
    pha                                                               ; ad55: 48          H
    lda #<error_handler2                                              ; ad56: a9 f9       ..
    sta error_handler                                                 ; ad58: 8d 2a 02    .*.
    lda #>error_handler2                                              ; ad5b: a9 a8       ..
    sta error_handler + 1                                             ; ad5d: 8d 2b 02    .+.
    pla                                                               ; ad60: 68          h
    rts                                                               ; ad61: 60          `

.error_handler3
    jsr sub_cad55                                                     ; ad62: 20 55 ad     U.
    jsr sub_ca6d8                                                     ; ad65: 20 d8 a6     ..
    jmp ca90f                                                         ; ad68: 4c 0f a9    L..

.start_remote
    jsr econet_init_blk_ed                                            ; ad6b: 20 2a ad     *.
    ldx #3                                                            ; ad6e: a2 03       ..
.loop_cad70
    lda vectors_remote,x                                              ; ad70: bd 80 ad    ...
    sta wrcvec,x                                                      ; ad73: 9d 08 02    ...
    dex                                                               ; ad76: ca          .
    bpl loop_cad70                                                    ; ad77: 10 f7       ..
    inx                                                               ; ad79: e8          .
    stx pia                                                           ; ad7a: 8e 00 b0    ...
    jmp basic_warm_start                                              ; ad7d: 4c ca c2    L..

.vectors_remote
    equw remote_wrch, remote_rdch                                     ; ad80: c2 ad 9e... ...

.cmd_ROFF
    lda rdcvec                                                        ; ad84: ad 0a 02    ...
    cmp #&9e                                                          ; ad87: c9 9e       ..
    bne cad9d                                                         ; ad89: d0 12       ..
    lda #&c0                                                          ; ad8b: a9 c0       ..
    sta blke_ee_port                                                  ; ad8d: 85 ee       ..
    jsr econet_transmit_blk_ed_with_retries                           ; ad8f: 20 3e ad     >.
    jsr sub_ca6d8                                                     ; ad92: 20 d8 a6     ..
    jsr econet_clear_rxcbv_exists_flag                                ; ad95: 20 90 a6     ..
    lda #0                                                            ; ad98: a9 00       ..
    sta pia                                                           ; ad9a: 8d 00 b0    ...
.cad9d
    rts                                                               ; ad9d: 60          `

.remote_rdch
    txa                                                               ; ad9e: 8a          .
    pha                                                               ; ad9f: 48          H
    tya                                                               ; ada0: 98          .
    pha                                                               ; ada1: 48          H
    lda #&c1                                                          ; ada2: a9 c1       ..
    sta blke_ee_port                                                  ; ada4: 85 ee       ..
    jsr econet_transmit_blk_ed_with_retries                           ; ada6: 20 3e ad     >.
    lda #&7f                                                          ; ada9: a9 7f       ..
    sta blke_ed_flag                                                  ; adab: 85 ed       ..
    lda #&ed                                                          ; adad: a9 ed       ..
    ldx #0                                                            ; adaf: a2 00       ..
    jsr econet_set_rxcbv_to_x                                         ; adb1: 20 61 a8     a.
.loop_cadb4
    lda blke_ed_flag                                                  ; adb4: a5 ed       ..
    bpl loop_cadb4                                                    ; adb6: 10 fc       ..
    jsr econet_clear_rxcbv_exists_flag                                ; adb8: 20 90 a6     ..
    pla                                                               ; adbb: 68          h
    tay                                                               ; adbc: a8          .
    pla                                                               ; adbd: 68          h
    tax                                                               ; adbe: aa          .
    lda blke_f6_imm1                                                  ; adbf: a5 f6       ..
    rts                                                               ; adc1: 60          `

.remote_wrch
    sta blke_f6_imm1                                                  ; adc2: 85 f6       ..
    txa                                                               ; adc4: 8a          .
    pha                                                               ; adc5: 48          H
    tya                                                               ; adc6: 98          .
    pha                                                               ; adc7: 48          H
    lda #&c2                                                          ; adc8: a9 c2       ..
    sta blke_ee_port                                                  ; adca: 85 ee       ..
    jsr econet_transmit_blk_ed_with_retries                           ; adcc: 20 3e ad     >.
    pla                                                               ; adcf: 68          h
    tay                                                               ; add0: a8          .
    pla                                                               ; add1: 68          h
    tax                                                               ; add2: aa          .
    lda blke_f6_imm1                                                  ; add3: a5 f6       ..
    jmp kern_nvwrch                                                   ; add5: 4c 55 fe    LU.

.cmd_NOTIFY
    ldx #&da                                                          ; add8: a2 da       ..
    jsr econet_read_stn_or_user                                       ; adda: 20 73 a8     s.
    bne cade2                                                         ; addd: d0 03       ..
    jmp ca8f0                                                         ; addf: 4c f0 a8    L..

.cade2
    jsr kern_skip_spaces                                              ; ade2: 20 76 f8     v.
    ldx #0                                                            ; ade5: a2 00       ..
.loop_cade7
    lda command_line,y                                                ; ade7: b9 00 01    ...
    sta command_line,x                                                ; adea: 9d 00 01    ...
    inx                                                               ; aded: e8          .
    iny                                                               ; adee: c8          .
    cmp #&0d                                                          ; adef: c9 0d       ..
    bne loop_cade7                                                    ; adf1: d0 f4       ..
    txa                                                               ; adf3: 8a          .
    pha                                                               ; adf4: 48          H
    ldx #9                                                            ; adf5: a2 09       ..
.loop_cadf7
    lda init_0d00_0d09_alt2,x                                         ; adf7: bd 3e af    .>.
    sta blkd_d0_flag,x                                                ; adfa: 95 d0       ..
    dex                                                               ; adfc: ca          .
    bpl loop_cadf7                                                    ; adfd: 10 f8       ..
    lda l00da                                                         ; adff: a5 da       ..
    sta blkd_d2_stn_lo                                                ; ae01: 85 d2       ..
    lda l00db                                                         ; ae03: a5 db       ..
    sta blkd_d3_stn_hi                                                ; ae05: 85 d3       ..
    lda #&20                                                          ; ae07: a9 20       .
    ldy #&14                                                          ; ae09: a0 14       ..
    jsr econet_transmit_blk_d0_with_retries                           ; ae0b: 20 18 a8     ..
    lda l00da                                                         ; ae0e: a5 da       ..
    beq cae1b                                                         ; ae10: f0 09       ..
    jsr kern_print_string                                             ; ae12: 20 d1 f7     ..
    equs "BUSY"                                                       ; ae15: 42 55 53... BUS

IF (BASE = &A000)
    ;; Save space in other versions
    nop                                                               ; ae19: ea          .
    brk                                                               ; ae1a: 00          .
ENDIF

.cae1b
    ldx #0                                                            ; ae1b: a2 00       ..
    stx blkd_d9_imm1                                                  ; ae1d: 86 d9       ..
    inx                                                               ; ae1f: e8          .
    stx blkd_d8_imm0                                                  ; ae20: 86 d8       ..
    ldx #3                                                            ; ae22: a2 03       ..
.loop_cae24
    lda init_00d4_00d8_alt2,x                                         ; ae24: bd 39 af    .9.
    sta blkd_d4_buffer_start_lo,x                                     ; ae27: 95 d4       ..
    dex                                                               ; ae29: ca          .
    bpl loop_cae24                                                    ; ae2a: 10 f8       ..
    lda #&85                                                          ; ae2c: a9 85       ..
    sta blkd_d0_flag                                                  ; ae2e: 85 d0       ..
    lda #&20                                                          ; ae30: a9 20       .
    ldy #&14                                                          ; ae32: a0 14       ..
    jsr econet_transmit_blk_d0_with_retries                           ; ae34: 20 18 a8     ..
    ldx #4                                                            ; ae37: a2 04       ..
.loop_cae39
    lda init_00d4_00d8_alt2,x                                         ; ae39: bd 39 af    .9.
    sta blkd_d4_buffer_start_lo,x                                     ; ae3c: 95 d4       ..
    dex                                                               ; ae3e: ca          .
    bpl loop_cae39                                                    ; ae3f: 10 f8       ..
    lda #&7f                                                          ; ae41: a9 7f       ..
    sta blkd_d0_flag                                                  ; ae43: 85 d0       ..
    jsr econet_set_rxcbv_to_d0                                        ; ae45: 20 5d a8     ].
.loop_cae48
    jsr econet_test_escape_in_z                                       ; ae48: 20 99 a7     ..
    beq cae8e                                                         ; ae4b: f0 41       .A
    lda blkd_d0_flag                                                  ; ae4d: a5 d0       ..
    bpl loop_cae48                                                    ; ae4f: 10 f7       ..
    jsr econet_clear_rxcbv_exists_flag                                ; ae51: 20 90 a6     ..
    lda #0                                                            ; ae54: a9 00       ..
    sta blkd_d4_buffer_start_lo                                       ; ae56: 85 d4       ..
    lda #1                                                            ; ae58: a9 01       ..
    sta blkd_d5_buffer_start_hi                                       ; ae5a: 85 d5       ..
    pla                                                               ; ae5c: 68          h
    sta l00db                                                         ; ae5d: 85 db       ..
    lda #0                                                            ; ae5f: a9 00       ..
    pha                                                               ; ae61: 48          H
.cae62
    lda l00da                                                         ; ae62: a5 da       ..
    clc                                                               ; ae64: 18          .
    adc blkd_d4_buffer_start_lo                                       ; ae65: 65 d4       e.
    sta blkd_d6_buffer_end_lo                                         ; ae67: 85 d6       ..
    lda #0                                                            ; ae69: a9 00       ..
    adc blkd_d5_buffer_start_hi                                       ; ae6b: 65 d5       e.
    sta blkd_d7_buffer_end_hi                                         ; ae6d: 85 d7       ..
    lda #&80                                                          ; ae6f: a9 80       ..
    sta blkd_d0_flag                                                  ; ae71: 85 d0       ..
    lda #&ff                                                          ; ae73: a9 ff       ..
    ldy #2                                                            ; ae75: a0 02       ..
    jsr econet_transmit_blk_d0_with_retries                           ; ae77: 20 18 a8     ..
    pla                                                               ; ae7a: 68          h
    clc                                                               ; ae7b: 18          .
    adc l00da                                                         ; ae7c: 65 da       e.
    cmp l00db                                                         ; ae7e: c5 db       ..
    bcs cae92                                                         ; ae80: b0 10       ..
    pha                                                               ; ae82: 48          H
    lda blkd_d6_buffer_end_lo                                         ; ae83: a5 d6       ..
    sta blkd_d4_buffer_start_lo                                       ; ae85: 85 d4       ..
    lda blkd_d7_buffer_end_hi                                         ; ae87: a5 d7       ..
    sta blkd_d5_buffer_start_hi                                       ; ae89: 85 d5       ..
    jmp cae62                                                         ; ae8b: 4c 62 ae    Lb.

.cae8e
    jsr econet_clear_rxcbv_exists_flag                                ; ae8e: 20 90 a6     ..
    pla                                                               ; ae91: 68          h
.cae92
    rts                                                               ; ae92: 60          `

.eco_rdch
    jsr kern_nvrdch                                                   ; ae93: 20 94 fe     ..
    cmp #&0d                                                          ; ae96: c9 0d       ..
    bne cae92                                                         ; ae98: d0 f8       ..
    txa                                                               ; ae9a: 8a          .
    pha                                                               ; ae9b: 48          H
    tya                                                               ; ae9c: 98          .
    pha                                                               ; ae9d: 48          H
    lda notifying_stn                                                 ; ae9e: ad 28 02    .(.
    bne caea6                                                         ; aea1: d0 03       ..
    jmp caf2e                                                         ; aea3: 4c 2e af    L..

.caea6
    pha                                                               ; aea6: 48          H
    ldx #7                                                            ; aea7: a2 07       ..
.loop_caea9
    lda init_00d0_00d7_alt2,x                                         ; aea9: bd 35 af    .5.
    sta blkd_d0_flag,x                                                ; aeac: 95 d0       ..
    dex                                                               ; aeae: ca          .
    bpl loop_caea9                                                    ; aeaf: 10 f8       ..
    pla                                                               ; aeb1: 68          h
    sta blkd_d2_stn_lo                                                ; aeb2: 85 d2       ..
    lda notifying_stn + 1                                             ; aeb4: ad 29 02    .).
    sta blkd_d3_stn_hi                                                ; aeb7: 85 d3       ..
    lda #<error_handler4                                              ; aeb9: a9 27       .'
    sta error_handler                                                 ; aebb: 8d 2a 02    .*.
    lda #>error_handler4                                              ; aebe: a9 af       ..
    sta error_handler + 1                                             ; aec0: 8d 2b 02    .+.
    lda #5                                                            ; aec3: a9 05       ..
    sta l00da                                                         ; aec5: 85 da       ..
    lda #&10                                                          ; aec7: a9 10       ..
    ldy #&32                                                          ; aec9: a0 32       .2
    jsr econet_transmit_blk_d0_with_retries                           ; aecb: 20 18 a8     ..
    ldx #4                                                            ; aece: a2 04       ..
.loop_caed0
    lda init_00d4_00d9,x                                              ; aed0: bd ec a6    ...
    sta blkd_d4_buffer_start_lo,x                                     ; aed3: 95 d4       ..
    dex                                                               ; aed5: ca          .
    bpl loop_caed0                                                    ; aed6: 10 f8       ..
    jsr oscrlf                                                        ; aed8: 20 ed ff     ..
    lda blkd_d2_stn_lo                                                ; aedb: a5 d2       ..
    ldx #&2f                                                          ; aedd: a2 2f       ./
    sec                                                               ; aedf: 38          8
.loop_caee0
    sbc #&64                                                          ; aee0: e9 64       .d
    inx                                                               ; aee2: e8          .
    bcs loop_caee0                                                    ; aee3: b0 fb       ..
    adc #&64                                                          ; aee5: 69 64       id
    pha                                                               ; aee7: 48          H
    txa                                                               ; aee8: 8a          .
    jsr oswrch                                                        ; aee9: 20 f4 ff     ..
    pla                                                               ; aeec: 68          h
    ldx #&2f                                                          ; aeed: a2 2f       ./
    sec                                                               ; aeef: 38          8
.loop_caef0
    sbc #&0a                                                          ; aef0: e9 0a       ..
    inx                                                               ; aef2: e8          .
    bcs loop_caef0                                                    ; aef3: b0 fb       ..
    adc #&3a                                                          ; aef5: 69 3a       i:
    pha                                                               ; aef7: 48          H
    txa                                                               ; aef8: 8a          .
    jsr oswrch                                                        ; aef9: 20 f4 ff     ..
    pla                                                               ; aefc: 68          h
    jsr oswrch                                                        ; aefd: 20 f4 ff     ..
    jsr kern_print_string                                             ; af00: 20 d1 f7     ..
    equs ": "                                                         ; af03: 3a 20       :

IF (BASE = &A000)
    ;; Save space in other versions
    nop                                                               ; af05: ea          .
ENDIF
.loop_caf06
    lda #&7f                                                          ; af06: a9 7f       ..
    sta blkd_d0_flag                                                  ; af08: 85 d0       ..
    jsr econet_set_rxcbv_to_d0                                        ; af0a: 20 5d a8     ].
    lda #1                                                            ; af0d: a9 01       ..
    ldy #&d0                                                          ; af0f: a0 d0       ..
    jsr sub_ca674                                                     ; af11: 20 74 a6     t.
    ldx #0                                                            ; af14: a2 00       ..
.loop_caf16
    lda l0148,x                                                       ; af16: bd 48 01    .H.
    jsr osasci                                                        ; af19: 20 e9 ff     ..
    cmp #&0d                                                          ; af1c: c9 0d       ..
    beq caf29                                                         ; af1e: f0 09       ..
    inx                                                               ; af20: e8          .
    cpx #5                                                            ; af21: e0 05       ..
    bcc loop_caf16                                                    ; af23: 90 f1       ..
    bcs loop_caf06                                                    ; af25: b0 df       ..
.error_handler4
    pla                                                               ; af27: 68          h
    pla                                                               ; af28: 68          h
.caf29
    ldx #3                                                            ; af29: a2 03       ..
    jsr ca746                                                         ; af2b: 20 46 a7     F.
.caf2e
    pla                                                               ; af2e: 68          h
    tay                                                               ; af2f: a8          .
    pla                                                               ; af30: 68          h
    tax                                                               ; af31: aa          .
    lda #&0d                                                          ; af32: a9 0d       ..
    rts                                                               ; af34: 60          `

.init_00d0_00d7_alt2
    equb &80, &aa,   0,   0                                           ; af35: 80 aa 00... ...
.init_00d4_00d8_alt2
    equb &da,   0, &db,   0,   0                                      ; af39: da 00 db... ...
.init_0d00_0d09_alt2
    equb &81,   0,   0,   0, &da,   0, &db,   0, &28,   2             ; af3e: 81 00 00... ...

.eco_wrch
    bit char_not_sent_to_printer                                      ; af48: 24 fe       $.
    bmi caf61                                                         ; af4a: 30 15       0.
    cmp #2                                                            ; af4c: c9 02       ..
    beq caf53                                                         ; af4e: f0 03       ..
    jmp cafee                                                         ; af50: 4c ee af    L..

.caf53
    ror char_not_sent_to_printer                                      ; af53: 66 fe       f.
    lda #5                                                            ; af55: a9 05       ..
    sta internal0                                                     ; af57: 8d 36 02    .6.
    lda #0                                                            ; af5a: a9 00       ..
    sta l0223                                                         ; af5c: 8d 23 02    .#.
    sta l00ca                                                         ; af5f: 85 ca       ..
.caf61
    sta l0112                                                         ; af61: 8d 12 01    ...
    pha                                                               ; af64: 48          H
    txa                                                               ; af65: 8a          .
    pha                                                               ; af66: 48          H
    tya                                                               ; af67: 98          .
    pha                                                               ; af68: 48          H
    lda l0112                                                         ; af69: ad 12 01    ...
    ldx internal0                                                     ; af6c: ae 36 02    .6.
    sta l00ca,x                                                       ; af6f: 95 ca       ..
    inx                                                               ; af71: e8          .
    stx internal0                                                     ; af72: 8e 36 02    .6.
    cmp #3                                                            ; af75: c9 03       ..
    bne caf7f                                                         ; af77: d0 06       ..
    ldy l0223                                                         ; af79: ac 23 02    .#.
    clc                                                               ; af7c: 18          .
    beq caf83                                                         ; af7d: f0 04       ..
.caf7f
    cpx #6                                                            ; af7f: e0 06       ..
    bcc cafe5                                                         ; af81: 90 62       .b
.caf83
    ldx #&0f                                                          ; af83: a2 0f       ..
.loop_caf85
    lda blkd_d0_flag,x                                                ; af85: b5 d0       ..
    pha                                                               ; af87: 48          H
    dex                                                               ; af88: ca          .
    bpl loop_caf85                                                    ; af89: 10 fa       ..
    lda printserver_stn                                               ; af8b: ad 2e 02    ...
    sta blkd_d2_stn_lo                                                ; af8e: 85 d2       ..
    lda printserver_stn + 1                                           ; af90: ad 2f 02    ./.
    sta blkd_d3_stn_hi                                                ; af93: 85 d3       ..
    lda #&d1                                                          ; af95: a9 d1       ..
    sta blkd_d1_port                                                  ; af97: 85 d1       ..
    lda error_handler                                                 ; af99: ad 2a 02    .*.
    sta l0110                                                         ; af9c: 8d 10 01    ...
    lda error_handler + 1                                             ; af9f: ad 2b 02    .+.
    sta l0111                                                         ; afa2: 8d 11 01    ...
    lda #<error_handler1                                              ; afa5: a9 d0       ..
    sta error_handler                                                 ; afa7: 8d 2a 02    .*.
    lda #>error_handler1                                              ; afaa: a9 a6       ..
    sta error_handler + 1                                             ; afac: 8d 2b 02    .+.
    lda #&ca                                                          ; afaf: a9 ca       ..
    sta blkd_d4_buffer_start_lo                                       ; afb1: 85 d4       ..
    lda #0                                                            ; afb3: a9 00       ..
    sta blkd_d5_buffer_start_hi                                       ; afb5: 85 d5       ..
    lda sequenceno                                                    ; afb7: ad 27 02    .'.
    eor #1                                                            ; afba: 49 01       I.
    sta sequenceno                                                    ; afbc: 8d 27 02    .'.
    and #1                                                            ; afbf: 29 01       ).
    bcs cafc5                                                         ; afc1: b0 02       ..
    ora #4                                                            ; afc3: 09 04       ..
.cafc5
    pha                                                               ; afc5: 48          H
    ldx internal0                                                     ; afc6: ae 36 02    .6.
    ldy #2                                                            ; afc9: a0 02       ..
    jsr sub_ca973                                                     ; afcb: 20 73 a9     s.
    jsr sub_caff1                                                     ; afce: 20 f1 af     ..
    lda #0                                                            ; afd1: a9 00       ..
    sta internal0                                                     ; afd3: 8d 36 02    .6.
    tax                                                               ; afd6: aa          .
    pla                                                               ; afd7: 68          h
    tay                                                               ; afd8: a8          .
.loop_cafd9
    pla                                                               ; afd9: 68          h
    sta blkd_d0_flag,x                                                ; afda: 95 d0       ..
    inx                                                               ; afdc: e8          .
    cpx #&10                                                          ; afdd: e0 10       ..
    bne loop_cafd9                                                    ; afdf: d0 f8       ..
    tya                                                               ; afe1: 98          .
    ror a                                                             ; afe2: 6a          j
    ror a                                                             ; afe3: 6a          j
    ror a                                                             ; afe4: 6a          j
.cafe5
    pla                                                               ; afe5: 68          h
    tay                                                               ; afe6: a8          .
    pla                                                               ; afe7: 68          h
    tax                                                               ; afe8: aa          .
    pla                                                               ; afe9: 68          h
    bcc cafee                                                         ; afea: 90 02       ..
    lsr char_not_sent_to_printer                                      ; afec: 46 fe       F.
.cafee
    jmp kern_nvwrch                                                   ; afee: 4c 55 fe    LU.

.sub_caff1
    ldx l0110                                                         ; aff1: ae 10 01    ...
    stx error_handler                                                 ; aff4: 8e 2a 02    .*.
    ldx l0111                                                         ; aff7: ae 11 01    ...
    stx error_handler + 1                                             ; affa: 8e 2b 02    .+.
    rts                                                               ; affd: 60          `

IF (BASE = &A000)
    ;; Save space in other versions
    equb &41, &52                                                     ; affe: 41 52       AR
ENDIF

.pydis_end
IF (BASE = &A000)
    assert '0' - 1 == &2f
    assert 100 == &64
    assert <(cmd_COS-1) == &4f
    assert <(cmd_I_AM-1) == &f1
    assert <(cmd_NOTIFY-1) == &d7
    assert <(cmd_ROFF-1) == &83
    assert <(cmd_UNKNOWN-1) == &9e
    assert <(kern_cli_handler-1) == &ee
    assert <(rx_cmd_81_peek-1) == &93
    assert <(rx_cmd_82_poke-1) == &ac
    assert <(rx_cmd_83_jsr-1) == &d5
    assert <(rx_cmd_84_user_proc-1) == &c0
    assert <(rx_cmd_85_os_proc-1) == &c9
    assert <(rx_cmd_86_halt-1) == &13
    assert <(rx_cmd_87_resume-1) == &2f
    assert <(rx_cmd_88_machine_peek-1) == &82
    assert <(tx_cmd_81_88_peek-1) == &ba
    assert <(tx_cmd_82_poke-1) == &f6
    assert <(tx_cmd_83_84_85_remote-1) == &18
    assert <(tx_cmd_86_87_halt_resume-1) == &34
    assert <error_handler1 == &d0
    assert <error_handler2 == &f9
    assert <error_handler3 == &62
    assert <error_handler4 == &27
    assert <function4 == &0c
    assert <function6 == &12
    assert <function7 == &16
    assert <irq_handler == &dc
    assert >(cmd_COS-1) == &a7
    assert >(cmd_I_AM-1) == &ab
    assert >(cmd_NOTIFY-1) == &ad
    assert >(cmd_ROFF-1) == &ad
    assert >(cmd_UNKNOWN-1) == &a7
    assert >(kern_cli_handler-1) == &f8
    assert >(rx_cmd_81_peek-1) == &a5
    assert >(rx_cmd_82_poke-1) == &a5
    assert >(rx_cmd_83_jsr-1) == &a5
    assert >(rx_cmd_84_user_proc-1) == &a5
    assert >(rx_cmd_85_os_proc-1) == &a5
    assert >(rx_cmd_86_halt-1) == &a6
    assert >(rx_cmd_87_resume-1) == &a6
    assert >(rx_cmd_88_machine_peek-1) == &a5
    assert >(tx_cmd_81_88_peek-1) == &a4
    assert >(tx_cmd_82_poke-1) == &a4
    assert >(tx_cmd_83_84_85_remote-1) == &a5
    assert >(tx_cmd_86_87_halt_resume-1) == &a5
    assert >error_handler1 == &a6
    assert >error_handler2 == &a8
    assert >error_handler3 == &ad
    assert >error_handler4 == &af
    assert >function4 == &a7
    assert >function6 == &a7
    assert >function7 == &a7
    assert >irq_handler == &a0
    assert do_rts == &a0ba
    assert eco_bget == &ab7b
    assert eco_bput == &ab5e
    assert eco_cli == &acf9
    assert eco_find == &ab25
    assert eco_load == &aa95
    assert eco_rdar == &abc3
    assert eco_rdch == &ae93
    assert eco_save == &a9bb
    assert eco_shut == &abe5
    assert eco_star == &aba3
    assert eco_wrch == &af48
    assert fserv_01_save-1 == &a99e
    assert fserv_02_load-1 == &aa71
    assert fserv_03-1 == &ac11
    assert fserv_04_info-1 == &ac89
    assert fserv_05_sdisc_06_iam-1 == &a939
    assert fserv_07_dir-1 == &acbe
    assert fserv_08_unrecognised-1 == &acb1
    assert fserv_09_lib-1 == &acc5
    assert remote_rdch == &ad9e
    assert remote_wrch == &adc2
ENDIF

save pydis_start, initialize + &1000
