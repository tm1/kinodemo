unit Alp32;

interface

uses
 SysUtils;

{-----------------------------------------------------------------------}
{  QStrings functions                                                   }
{  are copied from Andrew N. Driazgov QSTRINGS.PAS unit                 }
{-----------------------------------------------------------------------}
procedure _Move(Source, Dest: Pointer; Count: Cardinal);
procedure _ReverseByteArr(P: Pointer; Count: Cardinal);
procedure _StrToAnsi(var S: string);
function  _PStrToAnsi(P: PChar): PChar;
procedure _PdxToSmall(pData: Pointer);
procedure _SmallToPdx(pData: Pointer);
procedure _PdxToInt(pData: Pointer);
procedure _IntToPdx(pData: Pointer);
procedure _PdxToDouble(pData: Pointer);
procedure _DoubleToPdx(pData: Pointer);

implementation

const
  ToAnsiChars: array[0..255] of Char =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$A4,
     #$10,#$11,#$12,#$13,#$B6,#$A7,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$2D,#$2D,#$2D,#$A6,#$2B,#$A6,#$A6,#$AC,#$AC,#$A6,#$A6,#$AC,#$2D,#$2D,#$2D,#$AC,
     #$4C,#$2B,#$54,#$2B,#$2D,#$2B,#$A6,#$A6,#$4C,#$E3,#$A6,#$54,#$A6,#$3D,#$2B,#$A6,
     #$A6,#$54,#$54,#$4C,#$4C,#$2D,#$E3,#$2B,#$2B,#$2D,#$2D,#$2D,#$2D,#$A6,#$A6,#$2D,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF,
     #$A8,#$B8,#$AA,#$BA,#$AF,#$BF,#$A1,#$A2,#$B0,#$95,#$B7,#$76,#$B9,#$A4,#$A6,#$A0);


procedure IntCopy16;
asm
        MOV     EAX,[ESI]
        MOV     [EDI],EAX
        MOV     EAX,[ESI+4]
        MOV     [EDI+4],EAX
        MOV     EAX,[ESI+8]
        MOV     [EDI+8],EAX
        MOV     EAX,[ESI+12]
        MOV     [EDI+12],EAX
        MOV     EAX,[ESI+16]
        MOV     [EDI+16],EAX
        MOV     EAX,[ESI+20]
        MOV     [EDI+20],EAX
        MOV     EAX,[ESI+24]
        MOV     [EDI+24],EAX
        MOV     EAX,[ESI+28]
        MOV     [EDI+28],EAX
        MOV     EAX,[ESI+32]
        MOV     [EDI+32],EAX
        MOV     EAX,[ESI+36]
        MOV     [EDI+36],EAX
        MOV     EAX,[ESI+40]
        MOV     [EDI+40],EAX
        MOV     EAX,[ESI+44]
        MOV     [EDI+44],EAX
        MOV     EAX,[ESI+48]
        MOV     [EDI+48],EAX
        MOV     EAX,[ESI+52]
        MOV     [EDI+52],EAX
        MOV     EAX,[ESI+56]
        MOV     [EDI+56],EAX
        MOV     EAX,[ESI+60]
        MOV     [EDI+60],EAX
end;

procedure _Move(Source, Dest: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     EDX,ECX
        MOV     ESI,EAX
        TEST    EDI,3
        JNE     @@cl
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,16
        JBE     @@cw0
@@lp0:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp0
@@cw0:  JMP     DWORD PTR @@wV[ECX*4]
@@cl:   MOV     EAX,EDI
        MOV     EDX,3
        SUB     ECX,4
        JB      @@bc
        AND     EAX,3
        ADD     ECX,EAX
        JMP     DWORD PTR @@lV[EAX*4-4]
@@bc:   JMP     DWORD PTR @@tV[ECX*4+16]
@@lV:   DD      @@l1, @@l2, @@l3
@@l1:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        SHR     ECX,2
        MOV     [EDI+2],AL
        ADD     ESI,3
        ADD     EDI,3
        CMP     ECX,16
        JBE     @@cw1
@@lp1:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp1
@@cw1:  JMP     DWORD PTR @@wV[ECX*4]
@@l2:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        SHR     ECX,2
        MOV     [EDI+1],AL
        ADD     ESI,2
        ADD     EDI,2
        CMP     ECX,16
        JBE     @@cw2
@@lp2:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp2
@@cw2:  JMP     DWORD PTR @@wV[ECX*4]
@@l3:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        INC     ESI
        SHR     ECX,2
        INC     EDI
        CMP     ECX,16
        JBE     @@cw3
@@lp3:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp3
@@cw3:  JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w0, @@w1, @@w2, @@w3
        DD      @@w4, @@w5, @@w6, @@w7
        DD      @@w8, @@w9, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
        DD      @@w16
@@w16:  MOV     EAX,[ESI+ECX*4-64]
        MOV     [EDI+ECX*4-64],EAX
@@w15:  MOV     EAX,[ESI+ECX*4-60]
        MOV     [EDI+ECX*4-60],EAX
@@w14:  MOV     EAX,[ESI+ECX*4-56]
        MOV     [EDI+ECX*4-56],EAX
@@w13:  MOV     EAX,[ESI+ECX*4-52]
        MOV     [EDI+ECX*4-52],EAX
@@w12:  MOV     EAX,[ESI+ECX*4-48]
        MOV     [EDI+ECX*4-48],EAX
@@w11:  MOV     EAX,[ESI+ECX*4-44]
        MOV     [EDI+ECX*4-44],EAX
@@w10:  MOV     EAX,[ESI+ECX*4-40]
        MOV     [EDI+ECX*4-40],EAX
@@w9:   MOV     EAX,[ESI+ECX*4-36]
        MOV     [EDI+ECX*4-36],EAX
@@w8:   MOV     EAX,[ESI+ECX*4-32]
        MOV     [EDI+ECX*4-32],EAX
@@w7:   MOV     EAX,[ESI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
@@w6:   MOV     EAX,[ESI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
@@w5:   MOV     EAX,[ESI+ECX*4-20]
        MOV     [EDI+ECX*4-20],EAX
@@w4:   MOV     EAX,[ESI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
@@w3:   MOV     EAX,[ESI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
@@w2:   MOV     EAX,[ESI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
@@w1:   MOV     EAX,[ESI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        SHL     ECX,2
        ADD     ESI,ECX
        ADD     EDI,ECX
@@w0:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@t0, @@t1, @@t2, @@t3
@@t3:   MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
@@t2:   MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
@@t1:   MOV     AL,[ESI]
        MOV     [EDI],AL
@@t0:   POP     ESI
        POP     EDI
end;{ proc }

procedure _ReverseByteArr(P: Pointer; Count: Cardinal);
asm
        LEA     ECX,[EAX+EDX-1]
@@lp:   CMP     EAX,ECX
        JGE     @@qt
        MOV     DH,BYTE PTR [EAX]
        MOV     DL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],DH
        MOV     BYTE PTR [EAX],DL
        INC     EAX
        DEC     ECX
        JMP     @@lp
@@qt:
end;{ proc }

procedure _StrToAnsi(var S: string);
asm
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@2
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToAnsiChars]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ECX
        JNS     @@1
@@2:
end;

function _PStrToAnsi(P: PChar): PChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToAnsiChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;{ func }

procedure _PdxToSmall(pData: Pointer);
begin
 _ReverseByteArr(pData, 2);
 SmallInt(pData^) := Smallint(pData^) - Low(SmallInt);
end;

procedure _SmallToPdx(pData: Pointer);
begin
 SmallInt( pData^ ) := SmallInt( pData^ ) + Low(SmallInt);
 _ReverseByteArr(pData, 2);
end;

procedure _PdxToInt(pData: Pointer);
begin
 _ReverseByteArr(pData, 4);
 Integer(pData^) := Integer(pData^) - Low(Integer);
end;

procedure _IntToPdx(pData: Pointer);
begin
 Integer( pData^ ) := Integer( pData^ ) + Low(Integer);
 _ReverseByteArr(pData, 4);
end;

procedure _PdxToDouble(pData: Pointer);
var
 I: Integer;
begin
 if( PByteArray(pData)^[0] < $80 )then
 begin
  for I := 0 to 7 do
   PByteArray(pData)^[I] := PByteArray(pData)^[I] xor 255;
  _ReverseByteArr(pData, 8);
 end{ if }else
 begin
  _ReverseByteArr(pData, 8);
  Double(pData^) := Abs(Double(pData^));
 end;
end;{ proc }

procedure _DoubleToPdx(pData: Pointer);
var
 I: Integer;
begin
 if( Double(pData^) < 0 )then
 begin
  for I := 0 to 7 do
   PByteArray(pData)^[I] := PByteArray(pData)^[I] xor 255;
 end else
  Double(pData^) := -Double(pData^);
  _ReverseByteArr(pData, 8);
end;{ proc }

end.
