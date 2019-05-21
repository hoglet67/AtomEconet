L0000   = $0000
L0001   = $0001
L0002   = $0002
L0003   = $0003
L0004   = $0004
L0006   = $0006
L0007   = $0007
L0008   = $0008
L0009   = $0009
L00B0   = $00B0
L00B1   = $00B1
L00B2   = $00B2
L00B3   = $00B3
L00B4   = $00B4
L00B5   = $00B5
L00B6   = $00B6
L00B7   = $00B7
L00B8   = $00B8
L00B9   = $00B9
L00BA   = $00BA
L00BB   = $00BB
L00BC   = $00BC
L00BD   = $00BD
L00BE   = $00BE
L00BF   = $00BF
L00C0   = $00C0
L00C1   = $00C1
L00C2   = $00C2
L00CA   = $00CA
L00D0   = $00D0
L00D1   = $00D1
L00D2   = $00D2
L00D3   = $00D3
L00D4   = $00D4
L00D5   = $00D5
L00D6   = $00D6
L00D7   = $00D7
L00D8   = $00D8
L00D9   = $00D9
L00DA   = $00DA
L00DB   = $00DB
L00DC   = $00DC
L00ED   = $00ED
L00EE   = $00EE
L00EF   = $00EF
L00F0   = $00F0
L00F1   = $00F1
L00F6   = $00F6
L00FE   = $00FE
L00FF   = $00FF
L0100   = $0100
L0101   = $0101
L0102   = $0102
L0103   = $0103
L0110   = $0110
L0111   = $0111
L0112   = $0112
L0113   = $0113
L0114   = $0114
L0115   = $0115
L0116   = $0116
L0117   = $0117
L0118   = $0118
L0119   = $0119
L011A   = $011A
L011B   = $011B
L011C   = $011C
L011D   = $011D
L011F   = $011F
L0120   = $0120
L0123   = $0123
L0124   = $0124
L013C   = $013C
L013D   = $013D
L013E   = $013E
L013F   = $013F
L0148   = $0148
L0157   = $0157
L0204   = $0204
L0205   = $0205
L0206   = $0206
L0208   = $0208
L020A   = $020A
L020B   = $020B
L021C   = $021C
L021D   = $021D
L0223   = $0223
L0224   = $0224
L0225   = $0225
L0226   = $0226
L0227   = $0227
L0228   = $0228
L0229   = $0229
L022A   = $022A
L022B   = $022B
L022C   = $022C
L022D   = $022D
L022E   = $022E
L022F   = $022F
L0230   = $0230
L0231   = $0231
L0236   = $0236
L0237   = $0237
L0238   = $0238
L0239   = $0239
L023A   = $023A
L023B   = $023B
L023D   = $023D
L800A   = $800A
L8015   = $8015
L8016   = $8016
L801D   = $801D
L801E   = $801E
L801F   = $801F
LB000   = $B000
LB001   = $B001
LB400   = $B400
LB401   = $B401
LB402   = $B402
LB403   = $B403
LB404   = $B404
DIRCMD  = $C2CA
PRNSTR  = $F7D1
SKPSPC  = $F876
SYNERR  = $FA7D
WRCHAR  = $FE55
RDCHAR  = $FE94
OSVECS  = $FF9C
LFFA1   = $FFA1
OSSHUT  = $FFCB
OSFIND  = $FFCE
OSBPUT  = $FFD1
OSBGET  = $FFD4
OSSTAR  = $FFD7
OSRDAR  = $FFDA
OSSAVE  = $FFDD
OSLOAD  = $FFE0
OSRDCH  = $FFE3
OSECHO  = $FFE6
OSASCI  = $FFE9
OSCRLF  = $FFED
OSWRCH  = $FFF4
OSCLI   = $FFF7

        org     $A000
.BeebDisStartAddr
        BIT     LB001
        BMI     LA00F

        JSR     LA095

        LDA     #$C0
        STA     LB400
        PLA
        RTI

.LA00F
        TYA
        PHA
        TXA
        PHA
        LDX     #$08
.LA015
        LDA     LA07C,X
        STA     L0237,X
        DEX
        BNE     LA015

        LDA     L0204
        STA     L021C
        LDA     L0205
        STA     L021D
        LDA     #$DC
        STA     L0204
        LDA     #$A0
        STA     L0205
        JSR     LA095

        LDX     #$0B
.LA039
        LDA     LA084,X
        STA     L800A,X
        DEX
        BNE     LA039

        CLD
        LDA     LB404
        LDX     #$2F
        SEC
.LA049
        SBC     #$64
        INX
        BCS     LA049

        ADC     #$64
        STX     L801D
        LDX     #$2F
.LA055
        SBC     #$0A
        INX
        BCS     LA055

        ADC     #$3A
        STX     L801E
        STA     L801F
        LDA     #$20
        AND     LB401
        BEQ     LA074

        LDX     #$05
.LA06B
        LDA     LA08F,X
        STA     L8016,X
        DEX
        BNE     LA06B

.LA074
        JSR     LA700

        PLA
        TAX
        PLA
        TAY
        PLA
.LA07C
        RTI

        EQUB    $BA,$A0,$00,$00,$02

.LA082
        JMP     LA2EE

LA084 = LA082+2
        EQUB    $05,$03,$0F,$0E,$05,$14,$20,$33
        EQUB    $2E,$35

.LA08F
        EQUB    $30,$8E,$8F,$83,$8C,$8B

.LA095
        LDA     #$C2
        STA     L00B2
        LDA     #$FF
        STA     L00B3
        LDA     #$01
        STA     L00B0
.LA0A1
        LDA     #$C1
        STA     LB400
        LDA     #$1E
        STA     LB403
        LDA     #$80
        STA     LB401
.LA0B0
        LDA     #$02
        STA     LB400
.LA0B5
        LDA     #$63
        STA     LB401
.LA0BA
        RTS

.LA0BB
        LDA     #$10
.LA0BD
        BIT     LB400
        BEQ     LA0BD

        RTS

.LA0C3
        JMP     (L021C)

.LA0C6
        LDA     #$04
        AND     LB401
        BNE     LA0D0

.LA0CD
        JSR     LA0A1

.LA0D0
        JSR     LA0B5

        PLA
        RTI

.LA0D5
        LDA     #$22
        STA     LB400
        PLA
        RTI

.LA0DC
        BIT     LB400
        BPL     LA0C3

        LDA     #$01
        BIT     LB401
        BEQ     LA0C6

        LDA     LB402
        CMP     LB404
        BNE     LA0D5

        LDA     #$01
.LA0F2
        BIT     LB400
        BPL     LA0F2

        BEQ     LA0CD

        LDA     LB402
        BNE     LA0D5

        TYA
        PHA
        TXA
        PHA
        TSX
        STX     L00FF
        LDX     #$00
        LDY     #$F4
        JSR     LA295

        LDA     L00B9
        BNE     LA120

        LDA     #$B6
        STA     L00B4
        LDA     #$00
        STA     L00B5
        LDY     #$02
        JSR     LA53D

.LA11D
        JMP     LA242

.LA120
        LDA     L0230
        STA     L00B4
        LDA     L0231
        STA     L00B5
        JSR     LA1AA

        TYA
        PHA
        JSR     LA24B

        JSR     LA1DE

        LDY     L00B1
        JSR     LA295

        JSR     LA24B

        PLA
        TAY
        DEY
        LDA     L00B3
        STA     (L00B4),Y
        DEY
        LDA     L00B2
        STA     (L00B4),Y
        DEY
        DEY
        DEY
        LDA     L00B7
        STA     (L00B4),Y
        DEY
        LDA     L00B6
        STA     (L00B4),Y
        DEY
        LDA     L00B9
        STA     (L00B4),Y
        DEY
        LDA     L00B8
        ORA     #$80
        STA     (L00B4),Y
        BNE     LA11D

.LA163
        LDA     #$FD
        PHA
        LDA     #$00
        PHA
        PHA
        LDY     #$E7
.LA16C
        LDA     #$04
        BIT     LB401
        BEQ     LA182

        LDA     LB400
        LDA     #$67
        STA     LB401
        LDA     #$10
        BIT     LB400
        BNE     LA19C

.LA182
        LDA     #$67
        STA     LB401
        TSX
        INC     L0101,X
        BNE     LA16C

        INC     L0102,X
        BNE     LA16C

        INC     L0103,X
        BNE     LA16C

        LDX     #$80
        JMP     LA3A6

.LA19C
        STY     LB401
        LDY     #$44
        STY     LB400
        LDX     #$80
        PLA
        PLA
        PLA
        RTS

.LA1AA
        BIT     L023A
        BPL     LA1DB

        LDY     #$00
.LA1B1
        LDA     (L00B4),Y
        BEQ     LA1DB

        BMI     LA228

        INY
        LDA     (L00B4),Y
        BEQ     LA1C0

        CMP     L00B9
        BNE     LA229

.LA1C0
        INY
        LDA     (L00B4),Y
        BNE     LA1CC

        INY
        LDA     (L00B4),Y
        BEQ     LA1D7

        BNE     LA1D3

.LA1CC
        CMP     L00B6
        BNE     LA22A

        INY
        LDA     (L00B4),Y
.LA1D3
        CMP     L00B7
        BNE     LA22B

.LA1D7
        INY
        JMP     LA443

.LA1DB
        JMP     LA235

.LA1DE
        BIT     LB400
        BPL     LA1DE

        LDA     #$01
        BIT     LB401
        BEQ     LA212

        LDA     LB402
        BEQ     LA1F4

        CMP     LB404
        BNE     LA211

.LA1F4
        JSR     LA218

        LDA     LB402
        BNE     LA210

        LDA     LB402
        CMP     L00B6
        BNE     LA20F

        JSR     LA218

        LDA     LB402
        CMP     L00B7
        BNE     LA20E

        RTS

.LA20E
        INX
.LA20F
        INX
.LA210
        INX
.LA211
        INX
.LA212
        TXA
        BPL     LA235

        JMP     LA39C

.LA218
        LDA     #$01
.LA21A
        BIT     LB400
        BPL     LA21A

        BEQ     LA222

        RTS

.LA222
        TXA
        BEQ     LA23F

        JMP     LA3A6

.LA228
        INY
.LA229
        INY
.LA22A
        INY
.LA22B
        INY
        INY
        INY
        INY
        INY
        BEQ     LA235

        JMP     LA1B1

.LA235
        INX
        INX
        INX
        INX
.LA239
        INX
        INX
.LA23B
        INX
.LA23C
        INX
.LA23D
        INX
        INX
.LA23F
        LDX     L00FF
        TXS
.LA242
        JSR     LA095

        PLA
        TAX
        PLA
        TAY
        PLA
        RTI

.LA24B
        LDA     #$44
        STA     LB400
        LDA     LB400
        LDA     #$D7
        STA     LB401
        LDA     L00B6
.LA25A
        BIT     LB400
        BPL     LA25A

        BVC     LA239

        STA     LB402
        LDA     L00B7
        STA     LB402
.LA269
        BIT     LB400
        BPL     LA269

        BVC     LA239

        LDA     LB404
        STA     LB402
        LDA     #$00
        STA     LB402
        LDA     #$3B
        STA     LB401
.LA280
        BIT     LB400
        BPL     LA280

        BVC     LA239

        LDA     #$02
        STA     LB400
        JMP     LA0B5

.LA28F
        TXA
        BEQ     LA23D

        JMP     LA3A4

.LA295
        LDA     LB400
        LDA     #$43
        STA     LB401
.LA29D
        LDA     #$01
.LA29F
        BIT     LB400
        BPL     LA29F

        BEQ     LA2BC

        LDA     LB402
        STA     (L00B2),Y
        INY
        BEQ     LA2B6

        LDA     LB402
        STA     (L00B2),Y
        INY
        BNE     LA29D

.LA2B6
        INC     L00B3
        DEC     L00B0
        BNE     LA29D

.LA2BC
        TXA
        BNE     LA2C6

        LDA     #$84
        STA     LB401
        BNE     LA2CB

.LA2C6
        LDA     #$04
        STA     LB401
.LA2CB
        LDA     #$02
        BIT     LB401
        BEQ     LA28F

        CLC
        BPL     LA2E0

        TYA
        ORA     L00B0
        BEQ     LA28F

        LDA     LB402
        STA     (L00B2),Y
        SEC
.LA2E0
        CLD
        TYA
        ADC     L00B2
        STA     L00B2
        LDY     L00B3
        BCC     LA2EB

        INY
.LA2EB
        STY     L00B3
        RTS

.LA2EE
        PHP
        PHA
        TYA
        PHA
        TXA
        PHA
        CLD
        SEI
        STX     L00B4
        STY     L00B5
        TSX
        STX     L00FF
        LDA     #$20
        AND     LB401
        BEQ     LA307

        JMP     LA39B

.LA307
        JSR     LA163

        LDY     #$04
        JSR     LA443

        LDY     #$01
        LDA     (L00B4),Y
        BNE     LA31C

        TAY
        JSR     LA494

        JMP     LA32C

.LA31C
        JSR     LA40D

        SEC
        JSR     LA351

        JSR     LA415

        CLC
        LDY     L00B1
        JSR     LA336

.LA32C
        LDY     #$00
        TXA
        STA     (L00B4),Y
        JMP     LA3B0

.LA334
        INC     L00B3
.LA336
        LDA     (L00B2),Y
.LA338
        BIT     LB400
        BPL     LA338

        BVC     LA36A

        STA     LB402
        INY
        BEQ     LA34D

        LDA     (L00B2),Y
        STA     LB402
        INY
        BNE     LA336

.LA34D
        DEC     L00B0
        BNE     LA334

.LA351
        LDA     #$3F
        STA     LB401
.LA356
        BIT     LB400
        BPL     LA356

        BVC     LA36A

        TXA
        BMI     LA363

        JMP     LA0B0

.LA363
        LDA     #$00
        STA     LB400
        BEQ     LA3BA

.LA36A
        TXA
        BNE     LA3A3

        JMP     LA23C

.LA370
        LDY     LB404
.LA373
        PHA
        PHA
        PHA
        PLA
        PLA
        PLA
        INY
        BNE     LA373

        TXA
        BNE     LA3A2

        JMP     LA23B

.LA382
        JSR     LA385

.LA385
        JSR     LA388

.LA388
        LDA     (L00B4),Y
        BCC     LA38F

        LDA     L00B6,Y
.LA38F
        BIT     LB400
        BPL     LA38F

        BVC     LA370

        INY
.LA397
        STA     LB402
        RTS

.LA39B
        INX
.LA39C
        INX
        INX
        INX
        INX
        INX
.LA3A1
        INX
.LA3A2
        INX
.LA3A3
        INX
.LA3A4
        INX
        INX
.LA3A6
        LDY     #$00
        TXA
        ORA     #$40
        STA     (L00B4),Y
        LDX     L00FF
        TXS
.LA3B0
        JSR     LA095

        PLA
        TAX
        PLA
        TAY
        PLA
        PLP
        RTS

.LA3BA
        LDA     #$82
        STA     LB400
        PHP
        TXA
        ORA     #$20
        TAX
        LDA     #$01
.LA3C6
        BIT     LB400
        BPL     LA3C6

        BIT     LB401
        BEQ     LA3A1

        LDA     LB402
        CMP     LB404
        BNE     LA3A1

.LA3D8
        LDA     LB401
        BEQ     LA3D8

        BPL     LA3A1

        LDA     LB402
        BNE     LA3A1

.LA3E4
        LDA     LB401
        BEQ     LA3E4

        BPL     LA3A1

        LDA     LB402
        LDA     LB402
        LDA     #$02
        BIT     LB401
        BEQ     LA3A1

        JSR     LA0BB

        TXA
        ORA     #$10
        TAX
        PLP
        BCC     LA40C

.LA402
        LDA     #$44
        STA     LB400
        LDA     #$E7
        STA     LB401
.LA40C
        RTS

.LA40D
        JSR     LA415

        LDY     #$00
        JMP     LA385

.LA415
        LDY     #$02
        CLC
.LA418
        JSR     LA385

        LDA     LB404
        JSR     LA38F

        LDA     #$00
        JMP     LA397

.LA426
        SEC
        LDA     L00BA
.LA429
        SBC     L00BE
LA42A = LA429+1
        STA     L00B1
        LDA     L00BB
        SBC     #$00
.LA431
        STA     L00B3
LA432 = LA431+1
        LDA     L00BE
        STA     L00B2
        LDA     L00BF
        SEC
        SBC     L00B3
        STA     L00B0
        INY
        INY
        INY
        INY
        RTS

.LA443
        SEC
        LDA     (L00B4),Y
        INY
        INY
        SBC     (L00B4),Y
        STA     L00B1
        DEY
        LDA     (L00B4),Y
        SBC     #$00
        STA     L00B3
        INY
        LDA     (L00B4),Y
        STA     L00B2
        INY
        LDA     (L00B4),Y
        SEC
        SBC     L00B3
        STA     L00B0
        INY
        LDA     (L00B4),Y
        STA     L00BA
        INY
        LDA     (L00B4),Y
        STA     L00BB
        INY
        LDA     (L00B4),Y
        STA     L00BC
        INY
        LDA     (L00B4),Y
        STA     L00BD
        SEC
        LDA     L00BA
        SBC     L00B1
        STA     L00BE
        LDA     L00BB
        SBC     #$00
        CLC
        ADC     L00B0
        STA     L00BF
        LDA     L00BC
        ADC     #$00
        STA     L00C0
        LDA     L00BD
        ADC     #$00
        STA     L00C1
        DEY
        DEY
        DEY
        RTS

.LA494
        LDA     (L00B4),Y
        TAY
        CPY     #$81
        BCC     LA4A8

        CPY     #$89
        BCS     LA4A8

        LDA     LA432,Y
        PHA
        LDA     LA42A,Y
        PHA
        RTS

.LA4A8
        JMP     LA39B

        EQUB    $BA,$F6,$18,$18,$18,$34,$34,$BA
        EQUB    $A4,$A4,$A5,$A5,$A5,$A5,$A5,$A4

.LA4BB
        LDY     #$04
        JSR     LA443

        JSR     LA40D

        LDY     #$04
        SEC
        JSR     LA382

        LDY     #$08
        SEC
        JSR     LA382

        LDA     #$3F
        STA     LB401
.LA4D4
        BIT     LB400
        BPL     LA4D4

        BVS     LA4DE

        JMP     LA3A3

.LA4DE
        JSR     LA0B0

        JSR     LA0A1

        LDY     #$02
        LDA     (L00B4),Y
        STA     L00B6
        INY
        LDA     (L00B4),Y
        STA     L00B7
        JSR     LA1DE

.LA4F2
        LDY     L00B1
        JMP     LA295

.LA4F7
        LDY     #$04
.LA4F9
        JSR     LA443

LA4FA = LA4F9+1
        JSR     LA40D

        LDY     #$04
        SEC
        JSR     LA382

        LDY     #$08
        SEC
        JSR     LA382

        SEC
        JSR     LA351

        JSR     LA415

        CLC
        LDY     L00B1
        JSR     LA336

        RTS

.LA519
        LDY     #$04
        JSR     LA443

        JSR     LA40D

        LDY     #$08
        CLC
        JSR     LA382

        SEC
        JSR     LA351

        JSR     LA415

        CLC
        LDY     L00B1
        JSR     LA336

        RTS

.LA535
        JSR     LA40D

        CLC
        JSR     LA351

        RTS

.LA53D
        LDY     L00B8
        CPY     #$81
        BCC     LA56D

        CPY     #$89
        BCS     LA56D

        CPY     #$87
        BCS     LA562

        LDA     L00B6
        CMP     #$F0
        BCS     LA562

        TYA
        SEC
        SBC     #$81
        TAY
        LDA     L023B
.LA559
        ROR     A
        DEY
        BPL     LA559

        BCC     LA562

        JMP     LA56E

.LA562
        LDY     L00B8
        LDA     LA4FA,Y
        PHA
        LDA     LA4F2,Y
        PHA
        RTS

.LA56D
        INX
.LA56E
        INX
        TXA
        JMP     LA235

        EQUB    $93,$AC,$D5,$C0,$C9,$13,$2F,$82
        EQUB    $A5,$A5,$A5,$A5,$A5,$A6,$A6,$A5

.LA583
        CLC
        LDA     #$12
        STA     L00BA
        LDA     #$A7
        STA     L00BB
        LDA     #$16
        STA     L00BE
        LDA     #$A7
        STA     L00BF
.LA594
        LDY     #$04
        JSR     LA426

        LDA     LB400
        JSR     LA402

        LDY     #$00
        SEC
        JSR     LA418

        LDY     L00B1
        JSR     LA336

        JMP     LA0BB

.LA5AD
        LDY     #$04
        JSR     LA426

        JSR     LA24B

        JSR     LA1DE

        LDY     L00B1
        JSR     LA295

        JSR     LA24B

        RTS

.LA5C1
        LDA     L0238
        LDY     L0239
        JMP     LA5CE

.LA5CA
        LDA     #$0C
        LDY     #$A7
.LA5CE
        STY     L00BB
        LDY     L00BA
        STY     L00BC
        STA     L00BA
.LA5D6
        LDA     #$F8
        STA     L00B1
        LDA     #$01
        STA     L00B0
        LDA     #$CA
        STA     L00B2
        LDA     #$FF
        STA     L00B3
        JSR     LA24B

        JSR     LA1DE

        LDY     L00B1
        JSR     LA295

        JSR     LA24B

        LDA     #$1C
        ORA     L023B
        STA     L023B
        JSR     LA095

        CLI
        LDA     L00B8
        CMP     #$83
        BEQ     LA60B

        LDA     L00BC
        JMP     LA60D

.LA60B
        LDA     L00C2
.LA60D
        LDY     L00B7
        LDX     L00B6
        JMP     (L00BA)

.LA614
        JSR     LA24B

        LDA     #$40
        BIT     L023A
        BNE     LA62F

        ORA     L023A
        STA     L023A
        JSR     LA095

        CLI
        LDA     #$40
.LA62A
        BIT     L023A
        BNE     LA62A

.LA62F
        RTS

.LA630
        JSR     LA24B

        LDA     #$BF
        AND     L023A
        STA     L023A
        RTS

        EQUS    "CB5 8AF",$0D

        EQUB    $3B,$2A,$20,$20,$20,$20,$20,$20
        EQUB    $20,$20,$20,$20,$20,$20,$20,$20
        EQUB    $20,$45,$6E,$67

.LA658
        JSR     LA7F7

.LA65B
        JSR     LA6BC

.LA65E
        JSR     LA66D

        LDA     L011A
        BEQ     LA669

        JMP     LA83C

.LA669
        LDA     L0119
        RTS

.LA66D
        JSR     LA69B

.LA670
        LDY     #$D0
        LDA     #$0F
.LA674
        STA     L00DC
        LDA     #$00
        STA     L00DB
.LA67A
        LDA     L0000,Y
        BMI     LA690

        INC     L00DA
        BNE     LA67A

        INC     L00DB
        BNE     LA67A

        DEC     L00DC
        BNE     LA67A

        LDA     #$02
        JMP     LA83C

.LA690
        PHA
        LDA     L023A
        AND     #$7F
        STA     L023A
        PLA
        RTS

.LA69B
        LDX     #$08
.LA69D
        LDA     LA6B3,X
        STA     L00D0,X
        DEX
        BPL     LA69D

        JSR     LA80D

        JMP     LA85D

.LA6AB
        EQUB    $80,$99,$00,$00,$16,$01,$66,$01

.LA6B3
        EQUB    $7F,$88,$00,$00,$19,$01,$FF,$FF

        EQUB    $00

.LA6BC
        LDY     #$07
.LA6BE
        LDX     LA6AB,Y
        STX     L00D0,Y
        DEY
        BPL     LA6BE

        JSR     LA80D

        LDA     #$60
        LDY     #$30
        JMP     LA818

.LA6D0
        JSR     LAFF1

        LSR     L00FE
        JMP     LA83C

.LA6D8
        LDX     #$03
.LA6DA
        LDA     LA774,X
        STA     L0208,X
        DEX
        BPL     LA6DA

        RTS

.LA6E4
        EQUB    $00,$00,$F9,$A8,$FE,$00,$EB,$00

.LA6EC
        EQUB    $48,$01,$4D,$01

        EQUB    $00

.LA6F1
        PHA
        JSR     SKPSPC

        CMP     #$0D
        BEQ     LA6FC

        JMP     SYNERR

.LA6FC
        PLA
        RTS

        EQUS    $04,$04

.LA700
        JMP     LA732

        JMP     LA750

        JMP     LA75C

        JMP     LA658

.LA70C
        JMP     LA716

        JMP     LA81A

.LA712
        EQUS    $02,$00,"P4"

.LA716
        PHA
        LDA     L023B
        AND     #$E3
        STA     L023B
        PLA
        CMP     #$01
        BNE     LA72B

        STX     L0228
        STY     L0229
.LA72A
        RTS

.LA72B
        CMP     #$02
        BNE     LA72A

        JMP     LAD6B

.LA732
        LDA     #$70
        EOR     #$60
        STA     L8015
        LDX     #$15
.LA73B
        LDA     LA772,X
        STA     L0206,X
        DEX
        BPL     LA73B

.LA744
        LDX     #$07
.LA746
        LDA     LA6E4,X
        STA     L0228,X
        DEX
        BPL     LA746

        RTS

.LA750
        LDX     #$15
.LA752
        LDA     OSVECS,X
        STA     L0206,X
        DEX
        BPL     LA752

        RTS

.LA75C
        LDX     #$10
.LA75E
        LDA     LFFA1,X
        STA     L020B,X
        DEX
        BNE     LA75E

        INX
        JSR     LA6DA

        JSR     LA744

        LDX     #$01
        BNE     LA752

.LA772
        EQUB    $F9,$AC

.LA774
        EQUB    $48,$AF,$93,$AE,$95,$AA,$BB,$A9
        EQUB    $C3,$AB,$A3,$AB,$7B,$AB,$5E,$AB
        EQUB    $25,$AB,$E5,$AB

.LA788
        LDX     #$00
.LA78A
        LDA     L011A,X
        BMI     LA79E

        BNE     LA793

        LDA     #$0D
.LA793
        JSR     OSASCI

        INX
        BNE     LA78A

.LA799
        LDA     #$20
        BIT     LB001
.LA79E
        RTS

.LA79F
        LDY     #$00
.LA7A1
        LDA     L0100,Y
        INY
        CMP     #$0D
        BNE     LA7A1

.LA7A9
        LDA     L0100,Y
        STA     L011B,Y
        DEY
        BPL     LA7A9

        INY
        JSR     LA658

        BEQ     LA7C3

        ASL     A
        TAX
        LDA     LA7CF,X
        PHA
        LDA     LA7CE,X
        PHA
        RTS

.LA7C3
        LDX     #$2F
        PHA
        LDA     #$0D
.LA7C8
        STA     L0110,X
        DEX
        BPL     LA7C8

.LA7CE
        PLA
.LA7CF
        RTS

        EQUB    $9E,$A9,$71,$AA,$11,$AC,$89,$AC
        EQUB    $39,$A9,$39,$A9,$BE,$AC,$B1,$AC
        EQUB    $C5,$AC

.LA7E2
        LDA     #$05
.LA7E4
        TAY
.LA7E5
        LDA     (L0000,X)
        STA     L0116,Y
        CMP     #$0D
        BEQ     LA80C

        INY
        INC     L0000,X
        BNE     LA7E5

        INC     L0001,X
        BNE     LA7E5

.LA7F7
        LDX     #$88
        STX     L0116
        STY     L0117
        PHA
        LDX     #$02
.LA802
        LDA     L0224,X
        STA     L0118,X
        DEX
        BPL     LA802

        PLA
.LA80C
        RTS

.LA80D
        LDA     L022C
        STA     L00D2
        LDA     L022D
        STA     L00D3
        RTS

.LA818
        LDX     #$D0
.LA81A
        PHA
        TYA
        PHA
        LDA     L0000,X
        PHA
        LDY     #$00
        JSR     L023D

        LDA     L0000,X
        ROL     A
        BPL     LA843

        PLA
        STA     L0000,X
        PLA
        TAY
        PLA
        CLC
        SBC     #$00
        BEQ     LA83A

        JSR     LA848

        BNE     LA81A

.LA83A
        LDA     #$01
.LA83C
        LDX     #$19
        LDY     #$01
        JMP     (L022A)

.LA843
        PLA
        PLA
        TAY
        PLA
        RTS

.LA848
        CPY     #$00
        BEQ     LA85C

        PHA
        TXA
        PHA
        LDX     #$00
        TYA
.LA852
        DEX
        BNE     LA852

        DEY
        BNE     LA852

        TAY
        PLA
        TAX
        PLA
.LA85C
        RTS

.LA85D
        LDA     #$D0
        LDX     #$00
.LA861
        JSR     LA690

        STA     L0230
        STX     L0231
        LDA     L023A
        ORA     #$80
        STA     L023A
        RTS

.LA873
        LDA     #$00
        STA     L0000,X
        STA     L0001,X
        JSR     SKPSPC

        LDA     L0100,Y
        CMP     #$3A
        BCS     LA8BD

        SBC     #$2F
        BMI     LA8BD

.LA887
        LDA     L0100,Y
        CMP     #$3A
        BCS     LA8B8

        SBC     #$2F
        BMI     LA8B8

        INY
        PHA
        LDA     L0001,X
        PHA
        LDA     L0000,X
        ASL     A
        ROL     L0001,X
        ASL     A
        ROL     L0001,X
        ADC     L0000,X
        STA     L0000,X
        PLA
        ADC     L0001,X
        ASL     L0000,X
        ROL     A
        STA     L0001,X
        PLA
        ADC     L0000,X
        STA     L0000,X
        BCC     LA887

        INC     L0001,X
        BEQ     LA8F0

        BNE     LA887

.LA8B8
        LDA     L0000,X
        ORA     L0001,X
        RTS

.LA8BD
        TXA
        PHA
        LDX     #$00
.LA8C1
        LDA     L0100,Y
        CMP     #$20
        BEQ     LA8D3

        CMP     #$0D
        BEQ     LA8D3

        STA     L011B,X
        INX
        INY
        BNE     LA8C1

.LA8D3
        LDA     #$0D
        STA     L011B,X
        TYA
        PHA
        LDY     #$18
        JSR     LA658

        PLA
        TAY
        PLA
        TAX
        LDA     L011C
        STA     L0000,X
        LDA     L011D
        STA     L0001,X
        JMP     LA8B8

.LA8F0
        JSR     PRNSTR

        EQUS    "STN?"

.LA8F7
        NOP
        BRK
.LA8F9
        CMP     #$10
        BCS     LA922

        CMP     #$01
        BEQ     LA90F

        JSR     PRNSTR

        EQUS    "NO REPLY"

.LA90C
        NOP
        BMI     LA936

.LA90F
        JSR     PRNSTR

        EQUS    "NOT LISTENING"

.LA91F
        NOP
        BMI     LA936

.LA922
        TYA
        PHA
        LDY     #$02
.LA926
        STX     L00D0
        PLA
        PHA
        STA     L00D1
        LDA     (L00D0),Y
        JSR     OSASCI

        INY
        CMP     #$0D
        BNE     LA926

.LA936
        JSR     LA690

        BRK
.LA93A
        LDX     #$02
.LA93C
        LDA     L011B,X
        STA     L0224,X
        DEX
        BPL     LA93C

        JMP     LA7C3

.LA948
        STA     L00DA
        STY     L0113
        STA     L0114
        LDY     #$99
        STY     L0112
        STY     L00D1
        JSR     LA80D

        LDA     #$12
        STA     L00D4
        LDA     #$01
        STA     L00D5
        LDA     L0227
        LDX     #$08
.LA967
        LSR     L00DA
        BCS     LA96F

        LSR     A
        DEX
        BNE     LA967

.LA96F
        LDY     #$02
        LDX     #$04
.LA973
        ORA     #$80
        STA     L00D0
        CLC
        TXA
        ADC     L00D4
        STA     L00D6
        LDA     L00D5
        ADC     #$00
        STA     L00D7
        LDA     #$FF
        JSR     LA818

        LDX     #$7F
        STX     L00D0
        LDX     #$FF
        STX     L00D6
        STX     L00D7
        INX
        STX     L00D8
        JSR     LA85D

        JSR     LA670

        LDA     L0112
        RTS

.LA99F
        CLC
        LDA     L011B
        STA     L013C
        ADC     L0123
        STA     L013E
        LDA     L011C
        STA     L013D
        ADC     L0124
        STA     L013F
        JMP     LAA00

.LA9BB
        LDA     #$10
        JSR     LA7E4

        LDA     L0006,X
        STA     L013C
        LDA     L0007,X
        STA     L013D
        LDA     L0008,X
        STA     L013E
        SEC
        SBC     L0006,X
        STA     L0006,X
        LDA     L0009,X
        STA     L013F
        SBC     L0007,X
        STA     L0007,X
        LDA     #$00
        STA     L0008,X
        LDY     #$0A
        LDA     #$00
.LA9E5
        STA     L011B,Y
        DEY
        BPL     LA9E5

        INY
.LA9EC
        LDA     L0002,X
        STA     L011B,Y
        LDA     L0003,X
        STA     L011C,Y
        INY
        INY
        INY
        INY
        INX
        INX
        CPY     #$0C
        BNE     LA9EC

.LAA00
        LDY     #$01
        JSR     LA7F7

        LDA     #$77
        STA     L0118
        JSR     LA65B

        LDA     #$00
        STA     L0120
.LAA12
        LDA     L013C
        STA     L00D4
        CLC
        ADC     L011C
        STA     L00D6
        LDA     L013D
        STA     L00D5
        ADC     L011D
        STA     L00D7
        BCS     LAA35

        LDA     L00D6
        CMP     L013E
        LDA     L00D7
        SBC     L013F
        BCC     LAA42

.LAA35
        LDA     L013E
        STA     L00D6
        LDA     L013F
        STA     L00D7
        INC     L0120
.LAA42
        LDA     L011B
        STA     L00D1
        LDX     #$D0
        LDY     #$0A
        LDA     #$FF
        JSR     LA81A

        LDA     L0120
        BNE     LAA6C

        LDA     L00D6
        STA     L013C
        LDA     L00D7
        STA     L013D
        JSR     LA69B

        LDA     #$77
        STA     L00D1
        JSR     LA670

        JMP     LAA12

.LAA6C
        JSR     LA65E

        JMP     LA7C3

.LAA72
        LDA     L011B
        STA     L013D
        LDA     L011C
        STA     L013E
        LDA     L011F
        STA     L013F
        LDX     #$00
.LAA86
        LDA     L0120,X
        STA     L011B,X
        INX
        CMP     #$0D
        BNE     LAA86

        TXA
        CLC
        BCC     LAAA7

.LAA95
        LDA     L0002,X
        STA     L013D
        LDA     L0003,X
        STA     L013E
        LDA     L0004,X
        STA     L013F
        JSR     LA7E2

.LAAA7
        LDY     #$02
.LAAA9
        JSR     LA7F7

        LDX     #$2D
        STX     L0118
        JSR     LA65B

        BIT     L013F
        BPL     LAAC6

        LDA     L013D
        STA     L00D4
        LDA     L013E
        STA     L00D5
        JMP     LAAD2

.LAAC6
        LDA     L011B
        STA     L00D4
        LDA     L011C
        STA     L00D5
        LDA     #$08
.LAAD2
        PHA
        CLC
        LDA     L00D4
        ADC     L0123
        STA     L0123
        LDA     L00D5
        ADC     L0124
        STA     L0124
        LDA     #$2D
        STA     L00D1
.LAAE8
        LDA     #$FF
        STA     L00D6
        STA     L00D7
        LDA     #$7F
        STA     L00D0
        JSR     LA85D

        LDY     #$D0
        PLA
        JSR     LA674

        LDA     L00D6
        CMP     L0123
        LDA     L00D7
        SBC     L0124
        BCS     LAB15

        LDA     L00D6
        STA     L00D4
        LDA     L00D7
        STA     L00D5
        LDA     #$08
        PHA
        JMP     LAAE8

.LAB15
        JSR     LA65E

        LDA     L011F
        STA     L00D0
        LDA     L0120
        STA     L00D1
        JMP     LA7C3

.LAB25
        LDA     #$00
        STA     L011C
        ROL     A
        STA     L011B
        LDA     #$07
        JSR     LA7E4

        LDY     #$06
        JSR     LA7F7

        JSR     LA6BC

        JSR     LA66D

        LDA     L011A
        BEQ     LAB4E

        CMP     #$43
        BEQ     LAB4A

        JMP     LA83C

.LAB4A
        LDA     #$00
        BEQ     LAB5B

.LAB4E
        CLC
        SBC     L011B
        AND     L0227
        STA     L0227
        LDA     L011B
.LAB5B
        JMP     LA7C3

.LAB5E
        STA     L0115
        TXA
        PHA
        TYA
        PHA
        LDA     L0115
        PHA
        TYA
        LDY     #$09
        JSR     LA948

        LDA     L0113
        BNE     LAB89

        PLA
        STA     L0114
        JMP     LAB95

.LAB7B
        TXA
        PHA
        TYA
        PHA
        LDY     #$08
        JSR     LA948

        LDA     L0113
        BEQ     LAB90

.LAB89
        LDX     #$12
        LDY     #$01
        JMP     (L022A)

.LAB90
        LDA     L0115
        ASL     A
        ASL     A
.LAB95
        PLA
        TAY
        EOR     L0227
        STA     L0227
        PLA
        TAX
        LDA     L0114
        RTS

.LABA3
        TXA
        PHA
        STY     L011B
        LDY     #$00
        STY     L011C
.LABAD
        LDA     L0000,X
        STA     L011D,Y
        INX
        INY
        CPY     #$03
        BNE     LABAD

        LDY     #$0D
        JSR     LA658

        PLA
        TAX
        LDY     L011B
        RTS

.LABC3
        STY     L011B
        STA     L011C
        TYA
        PHA
        TXA
        PHA
        LDY     #$0C
        JSR     LA658

        PLA
        TAX
        INX
        INX
        LDY     #$02
.LABD8
        LDA     L011B,Y
        STA     L0000,X
        DEX
        DEY
        BPL     LABD8

        INX
        PLA
        TAY
        RTS

.LABE5
        TYA
        PHA
        STA     L011B
        LDY     #$07
        JSR     LA658

        PLA
        TAY
        RTS

.LABF2
        JSR     SKPSPC

        LDA     L0100,Y
        CMP     #$30
        BCC     LAC0F

        CMP     #$3A
        BCS     LAC0F

        LDX     #$D0
        JSR     LA873

        LDA     L00D0
        STA     L022C
        LDA     L00D1
        STA     L022D
.LAC0F
        JMP     LA79F

.LAC12
        LDY     #$00
.LAC14
        LDA     L011B,Y
        STA     L0148,Y
        INY
        CMP     #$0D
        BNE     LAC14

        LDY     #$04
        JSR     LA658

        JSR     LACA4

        JSR     OSCRLF

        LDA     #$00
.LAC2C
        PHA
        STA     L011C
        LDA     #$03
        STA     L011B
        LDA     #$02
        STA     L011D
        LDA     #$48
        STA     L00D0
        LDA     #$01
        STA     L00D1
        LDX     #$D0
        LDA     #$08
        JSR     LA7E4

        LDY     #$03
        JSR     LA7F7

        JSR     LA6BC

        LDX     #$08
.LAC53
        LDA     LAC81,X
        STA     L00D0,X
        DEX
        BPL     LAC53

        JSR     LA80D

        JSR     LA85D

        JSR     LA670

        LDA     L0117
        BEQ     LAC70

        LDX     #$16
        LDY     #$01
        JMP     (L022A)

.LAC70
        LDA     L0118
        BEQ     LAC7F

        JSR     LA788

        PLA
        CLC
        ADC     #$02
        JMP     LAC2C

.LAC7F
        PLA
        RTS

.LAC81
        EQUB    $7F,$88,$00,$00,$16,$01,$FF,$FF
        EQUB    $00

.LAC8A
        LDA     #$0D
        STA     L0157
        LDX     #$00
.LAC91
        LDA     L011B,X
        JSR     OSASCI

        INX
        CPX     #$1C
        BNE     LAC91

        JSR     OSCRLF

        INX
        INX
        INX
        BNE     LACA6

.LACA4
        LDX     #$00
.LACA6
        LDA     L011B,X
        BMI     LACB1

        JSR     OSASCI

        INX
        BNE     LACA6

.LACB1
        RTS

.LACB2
        LDA     #$00
        STA     L013F
        LDY     #$05
        JSR     LAAA9

        JMP     (L00D0)

.LACBF
        LDA     L011B
        STA     L0225
        RTS

.LACC6
        LDA     L011B
        STA     L0226
        RTS

.LACCD
        EQUS    "."

.LACCE
        EQUB    $A7,$9E

        EQUS    "GO"

        EQUB    $F8,$EE

        EQUS    "I."

        EQUB    $A7,$9E

        EQUS    "I AM"

        EQUB    $AB,$F1

        EQUS    "NOTIFY"

        EQUB    $AD,$D7

        EQUS    "COS"

        EQUB    $A7,$4F

        EQUS    "ROFF"

        EQUB    $AD,$83

        EQUB    $A7,$9E

.LACF3
        LDX     #$0C
        CLD
        JMP     LACFC

.LACF9
        LDX     #$FF
        CLD
.LACFC
        LDY     #$00
        JSR     SKPSPC

        DEY
.LAD02
        INY
        INX
.LAD04
        LDA     LACCD,X
        BMI     LAD21

        CMP     L0100,Y
        BEQ     LAD02

        DEX
.LAD0F
        INX
        LDA     LACCD,X
        BPL     LAD0F

        INX
        LDA     L0100,Y
        CMP     #$2E
        BNE     LACFC

        INY
        DEX
        BCS     LAD04

.LAD21
        PHA
        LDA     LACCE,X
        PHA
        CLC
        LDX     #$00
        RTS

.LAD2A
        STX     L00EF
        STY     L00F0
        LDX     #$04
.LAD30
        LDA     LAD39,X
        STA     L00F1,X
        DEX
        BPL     LAD30

        RTS

.LAD39
        EQUB    $F6,$00,$F7,$00,$00

.LAD3E
        LDA     #$62
        STA     L022A
        LDA     #$AD
        STA     L022B
        LDA     #$80
        STA     L00ED
        LDA     #$FF
        LDY     #$14
        LDX     #$ED
        JSR     LA81A

.LAD55
        PHA
        LDA     #$F9
        STA     L022A
        LDA     #$A8
        STA     L022B
        PLA
        RTS

.LAD62
        JSR     LAD55

        JSR     LA6D8

        JMP     LA90F

.LAD6B
        JSR     LAD2A

        LDX     #$03
.LAD70
        LDA     LAD80,X
        STA     L0208,X
        DEX
        BPL     LAD70

        INX
        STX     LB000
        JMP     DIRCMD

.LAD80
        EQUB    $C2,$AD,$9E,$AD

.LAD84
        LDA     L020A
        CMP     #$9E
        BNE     LAD9D

        LDA     #$C0
        STA     L00EE
        JSR     LAD3E

        JSR     LA6D8

        JSR     LA690

        LDA     #$00
        STA     LB000
.LAD9D
        RTS

.LAD9E
        TXA
        PHA
        TYA
        PHA
        LDA     #$C1
        STA     L00EE
        JSR     LAD3E

        LDA     #$7F
        STA     L00ED
        LDA     #$ED
        LDX     #$00
        JSR     LA861

.LADB4
        LDA     L00ED
        BPL     LADB4

        JSR     LA690

        PLA
        TAY
        PLA
        TAX
        LDA     L00F6
        RTS

.LADC2
        STA     L00F6
        TXA
        PHA
        TYA
        PHA
        LDA     #$C2
        STA     L00EE
        JSR     LAD3E

        PLA
        TAY
        PLA
        TAX
        LDA     L00F6
        JMP     WRCHAR

.LADD8
        LDX     #$DA
        JSR     LA873

        BNE     LADE2

        JMP     LA8F0

.LADE2
        JSR     SKPSPC

        LDX     #$00
.LADE7
        LDA     L0100,Y
        STA     L0100,X
        INX
        INY
        CMP     #$0D
        BNE     LADE7

        TXA
        PHA
        LDX     #$09
.LADF7
        LDA     LAF3E,X
        STA     L00D0,X
        DEX
        BPL     LADF7

        LDA     L00DA
        STA     L00D2
        LDA     L00DB
        STA     L00D3
        LDA     #$20
        LDY     #$14
        JSR     LA818

        LDA     L00DA
        BEQ     LAE1B

        JSR     PRNSTR

        EQUS    "BUSY"

.LAE19
        NOP
        BRK
.LAE1B
        LDX     #$00
        STX     L00D9
        INX
        STX     L00D8
        LDX     #$03
.LAE24
        LDA     LAF39,X
        STA     L00D4,X
        DEX
        BPL     LAE24

        LDA     #$85
        STA     L00D0
        LDA     #$20
        LDY     #$14
        JSR     LA818

        LDX     #$04
.LAE39
        LDA     LAF39,X
        STA     L00D4,X
        DEX
        BPL     LAE39

        LDA     #$7F
        STA     L00D0
        JSR     LA85D

.LAE48
        JSR     LA799

        BEQ     LAE8E

        LDA     L00D0
        BPL     LAE48

        JSR     LA690

        LDA     #$00
        STA     L00D4
        LDA     #$01
        STA     L00D5
        PLA
        STA     L00DB
        LDA     #$00
        PHA
.LAE62
        LDA     L00DA
        CLC
        ADC     L00D4
        STA     L00D6
        LDA     #$00
        ADC     L00D5
        STA     L00D7
        LDA     #$80
        STA     L00D0
        LDA     #$FF
        LDY     #$02
        JSR     LA818

        PLA
        CLC
        ADC     L00DA
        CMP     L00DB
        BCS     LAE92

        PHA
        LDA     L00D6
        STA     L00D4
        LDA     L00D7
        STA     L00D5
        JMP     LAE62

.LAE8E
        JSR     LA690

        PLA
.LAE92
        RTS

.LAE93
        JSR     RDCHAR

        CMP     #$0D
        BNE     LAE92

        TXA
        PHA
        TYA
        PHA
        LDA     L0228
        BNE     LAEA6

        JMP     LAF2E

.LAEA6
        PHA
        LDX     #$07
.LAEA9
        LDA     LAF35,X
        STA     L00D0,X
        DEX
        BPL     LAEA9

        PLA
        STA     L00D2
        LDA     L0229
        STA     L00D3
        LDA     #$27
        STA     L022A
        LDA     #$AF
        STA     L022B
        LDA     #$05
        STA     L00DA
        LDA     #$10
        LDY     #$32
        JSR     LA818

        LDX     #$04
.LAED0
        LDA     LA6EC,X
        STA     L00D4,X
        DEX
        BPL     LAED0

        JSR     OSCRLF

        LDA     L00D2
        LDX     #$2F
        SEC
.LAEE0
        SBC     #$64
        INX
        BCS     LAEE0

        ADC     #$64
        PHA
        TXA
        JSR     OSWRCH

        PLA
        LDX     #$2F
        SEC
.LAEF0
        SBC     #$0A
        INX
        BCS     LAEF0

        ADC     #$3A
        PHA
        TXA
        JSR     OSWRCH

        PLA
        JSR     OSWRCH

        JSR     PRNSTR

        EQUS    ": "

        EQUB    $EA,$A9,$7F,$85,$D0,$20,$5D,$A8
        EQUB    $A9,$01,$A0,$D0,$20,$74,$A6,$A2
        EQUB    $00,$BD,$48,$01,$20,$E9,$FF,$C9
        EQUB    $0D,$F0,$09,$E8,$E0,$05,$90,$F1
        EQUB    $B0,$DF

.LAF27
        PLA
        PLA
        LDX     #$03
        JSR     LA746

.LAF2E
        PLA
        TAY
        PLA
        TAX
        LDA     #$0D
        RTS

.LAF35
        EQUB    $80,$AA,$00,$00

.LAF39
        EQUB    $DA,$00,$DB,$00,$00

.LAF3E
        EQUB    $81,$00,$00,$00,$DA,$00,$DB,$00
        EQUB    $28,$02

.LAF48
        BIT     L00FE
        BMI     LAF61

        CMP     #$02
        BEQ     LAF53

        JMP     LAFEE

.LAF53
        ROR     L00FE
        LDA     #$05
        STA     L0236
        LDA     #$00
        STA     L0223
        STA     L00CA
.LAF61
        STA     L0112
        PHA
        TXA
        PHA
        TYA
        PHA
        LDA     L0112
        LDX     L0236
        STA     L00CA,X
        INX
        STX     L0236
        CMP     #$03
        BNE     LAF7F

        LDY     L0223
        CLC
        BEQ     LAF83

.LAF7F
        CPX     #$06
        BCC     LAFE5

.LAF83
        LDX     #$0F
.LAF85
        LDA     L00D0,X
        PHA
        DEX
        BPL     LAF85

        LDA     L022E
        STA     L00D2
        LDA     L022F
        STA     L00D3
        LDA     #$D1
        STA     L00D1
        LDA     L022A
        STA     L0110
        LDA     L022B
        STA     L0111
        LDA     #$D0
        STA     L022A
        LDA     #$A6
        STA     L022B
        LDA     #$CA
        STA     L00D4
        LDA     #$00
        STA     L00D5
        LDA     L0227
        EOR     #$01
        STA     L0227
        AND     #$01
        BCS     LAFC5

        ORA     #$04
.LAFC5
        PHA
        LDX     L0236
        LDY     #$02
        JSR     LA973

        JSR     LAFF1

        LDA     #$00
        STA     L0236
        TAX
        PLA
        TAY
.LAFD9
        PLA
        STA     L00D0,X
        INX
        CPX     #$10
        BNE     LAFD9

        TYA
        ROR     A
        ROR     A
        ROR     A
.LAFE5
        PLA
        TAY
        PLA
        TAX
        PLA
        BCC     LAFEE

        LSR     L00FE
.LAFEE
        JMP     WRCHAR

.LAFF1
        LDX     L0110
        STX     L022A
        LDX     L0111
        STX     L022B
        RTS

        EQUS    "AR"

.BeebDisEndAddr
SAVE "AtomEco350.bin",BeebDisStartAddr,BeebDisEndAddr

