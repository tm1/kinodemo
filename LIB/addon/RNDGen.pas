unit RNDGen;

{| RNDGen 1.2 from 25 Aug 2001
 | Copyright (c) 2000-2001 SoftLab MIL-TEC Ltd
 | Web    http://www.softcomplete.com
 | Email  support@softcomplete.com
 | True random generator for Delphi and C++ Builder
 |
 | ------------------- History -------------------
 |
 |  1.2 from 25 Aug 2001
 |    - improved initialization
 |
 |  1.1 from 19 Jun 2001
 |    - add GetRNDByte
 |    - add GetRNDInt (work like delphi random)
 |
 |  1.0 from 11 Dec 2000
 |    Initial release
 |
 |}

interface

uses
  Windows, Messages, SysUtils, Classes;

function MakeRND(Len: integer): string;
procedure FillRND(Buff: Pointer; Len: integer);

function GetRNDByte: Byte;
// create random integer in range 0 <= X < Range
// like standart delphi random
function GetRNDInt(Range: integer = 0): integer;

implementation

var whKeyboard,whMouse: HHook;
    hTimer: integer;
    FLock: Boolean;
    htTime,htMouse,htKbd: TLargeInteger;
    // sapphire part
    rotor,                            { Rotor and ratchet are used to help }
    ratchet,                          { Continually shuffle the "cards."   }
    avalanche,                        { Data dependent index. }
    last_plain,                       { Previous plain text byte. }
    last_cipher: byte;                { Previous cipher text byte. }
    cards: array[0..255] of byte;     { Array to hold a permutation of all }

procedure PoolByte(b: Byte);
var swaptemp: byte;
begin
  ratchet := (ratchet + cards[rotor]) and $FF;
  if rotor<255 then
  inc(rotor) else
  dec(rotor);
  swaptemp := cards[last_cipher];      { Round-robin swap. }
  cards[last_cipher] := cards[ratchet];
  cards[ratchet] := cards[last_plain];
  cards[last_plain] := cards[rotor];
  cards[rotor] := swaptemp;
  avalanche := (avalanche + cards[swaptemp]) and $FF;
  last_cipher := b xor
    cards[(cards[ratchet] + cards[rotor]) and $FF] xor
    cards[cards[(cards[last_plain] + cards[last_cipher] +
    cards[avalanche]) and $FF]];
  last_plain := b;
end;

procedure PoolInt(Value: integer);
var j: integer;
begin
  for j:=1 to 4 do begin
    PoolByte(Value and $FF);
    Value:=Value shr 8;
  end;
end;

function MouseHookCallBack(Code: integer; Msg: WPARAM; MouseHook: LPARAM): LRESULT; stdcall;
var hLast: TLargeInteger;
begin
  QueryPerformanceCounter(hLast);
  if not FLock then
    PoolByte((hLast-htMouse) and $FF);
  htMouse:=hLast;
  Result := CallNextHookEx(whMouse,Code,Msg,MouseHook);
end;

function KeyboardHookCallBack(Code: integer; Msg: WPARAM; KeyboardHook: LPARAM): LRESULT; stdcall;
var hLast: TLargeInteger;
begin
  QueryPerformanceCounter(hLast);
  if not FLock then
    PoolByte((hLast-htKbd) and $FF);
  htKbd:=hLast;
  Result := CallNextHookEx(whKeyboard,Code,Msg,KeyboardHook);
end;

function TimerCallback(hwnd: THandle; uMsg,idEvent: WORD; dwTime: DWORD): LRESULT stdcall;
var hLast: TLargeInteger;
begin
  QueryPerformanceCounter(hLast);
  if not FLock then
    PoolByte((hLast-htTime) and $FF);
  htTime:=hLast;
  Result:=1;
end;

function HookActive: Boolean;
begin
  Result := whKeyboard <> 0;
end;

procedure CreateHooks;
begin
  if not HookActive then begin
    whMouse := SetWindowsHookEx(WH_MOUSE,MouseHookCallBack,
    		    0,GetCurrentThreadID);
    whKeyboard := SetWindowsHookEx(WH_KEYBOARD,KeyboardHookCallBack,
    		    0,GetCurrentThreadID);
    hTimer:=SetTimer(0,1,1,TFarProc(@TimerCallback));
   end;
end;

procedure RemoveHooks;
begin
  if HookActive then try
    UnhookWindowsHookEx(whKeyboard);
    UnhookWindowsHookEx(whMouse);
    KillTimer(0, hTimer);
  finally
    whKeyboard := 0;
    whMouse := 0;
  end;
end;

function GetRNDByte: Byte;
begin
  PoolByte(0);
  Result:=last_cipher;
end;

function GetRNDInt(Range: integer): integer;
begin
  FillRND(@Result,SizeOf(Result));
  Result:=Result and $7FFFFFFF; // >= 0
  if Range > 0 then
    Result:=Result mod Range;
end;

function MakeRND(Len: integer): string;
var i: integer;
begin
  FLock:=True;
  try
    SetLength(Result,Len);
    for i := 1 to Len do begin
      PoolByte(0);
      Result[i]:=Chr(last_cipher);
    end;
  finally
    FLock:=False;
  end;
end;

procedure FillRND(Buff: Pointer; Len: integer); 
var i: integer;
    p: PByte;
begin
  p:=PByte(Buff);
  FLock:=True;
  try
    for i := 1 to Len do begin
      PoolByte(0);
      p^:=last_cipher;
      Inc(p);
    end;
  finally
    FLock:=False;
  end;
end;

procedure HashInit;
var i,j: integer;
    MemStat : TMemoryStatus;
begin
  rotor := 1;           { Make sure we start key in a known place. }
  ratchet := 3;
  avalanche := 5;
  last_plain := 7;
  last_cipher := 11;
  j := 255;
  for i := 0 to 255 do  { Start with cards all in inverse order. }
    begin
      cards[i] := j;
      dec(j);
    end;
  for i := 255 downto 0 do PoolByte(i);
  MemStat.dwLength := sizeof(TMemoryStatus);
  GlobalMemoryStatus(MemStat);
  PoolInt(MemStat.dwAvailPhys);
  PoolInt(MemStat.dwAvailPageFile);
  PoolInt(MemStat.dwAvailVirtual);
  PoolInt(Round(Date));
  PoolInt(Round(Frac(Now)*$7FFFFFFF));
  for i := 0 to 255 do begin
    Sleep(0);
    TimerCallback(0,0,0,0);
  end;
  PoolInt(Round(Frac(Now)*$7FFFFFFF));
end;

initialization
  whKeyboard:=0;
  whMouse:=0;
  FLock:=True;
  HashInit;
  QueryPerformanceCounter(htTime);
  QueryPerformanceCounter(htMouse);
  QueryPerformanceCounter(htKbd);
  CreateHooks;
  FLock:=False;
finalization
  FLock:=True;
  RemoveHooks;
end.
