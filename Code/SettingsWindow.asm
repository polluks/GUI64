CreateSettingsWindow
                lda #<Wnd_Settings
                sta $fb
                lda #>Wnd_Settings
                sta $fc
                jsr CreateWindow
                ;
                ldx #4
-               ;stx Param
                txa
                jsr SelectControl
                lda CSTM_ActiveClr,x
                sta ControlColor
                jsr UpdateControl
                dex
                bpl -
                +SelectControl 5
                +ControlSetStringList <Str_Settings_RBG, >Str_Settings_RBG, 2
                +ControlSetHilIndex CSTM_DeskPattern
                +SelectControl 13
                +ControlSetID ID_BTN_APPLY
                +SelectControl 14
                +ControlSetID ID_BTN_OK
                rts

; Needs wndParam filled with exit code
SettingsWndProc jsr StdWndProc
                ;
                lda wndParam
                cmp #EC_LBTNRELEASE
                bne ++
                jsr IsInCurControl
                lda res
                beq ++
                ; Mouse button released
                lda ControlID
                cmp #ID_BTN_OK
                bne +
                ; "OK" was pressed
                jsr ApplySettings
                jsr KillCurWindow
                jsr RepaintAll
                jmp PaintTaskbar
+               cmp #ID_BTN_APPLY
                bne +
ApplySettings   ; "Apply" was pressed
                ; Set colors
                lda WindowCtrlPtr
                sta $fb
                lda WindowCtrlPtr+1
                sta $fc
                ldx #0
                ldy #CTRLSTRUCT_COLOR
                ;
-               lda ($fb),y
                sta CSTM_ActiveClr,x
                tya
                clc
                adc #16
                tay
                inx
                cpx #5
                bcc -
                ; Set desktop pattern
                tya
                clc
                adc #6
                tay
                lda ($fb),y
                sta CSTM_DeskPattern
                jsr SetBkgPattern
                ;
                jsr RepaintAll
+               rts
++              rts
