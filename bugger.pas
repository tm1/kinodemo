{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : bugger.pas
Version      : 
Description  : 
Creation     : 12.10.2002 8:59:24
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit bugger;

// ****************************************************************************
interface
  uses Dialogs, SysUtils;
  
const
  DEBUGProjectName: string = 'demo4_run';
  DEBUGFileName: string = '.\demoX_run.log';
  DEBUGToFile: boolean = true;
  DEBUGSaveToFile: boolean = false;
  DEBUGShowScr: boolean = false;
  DEBUGShowPrn: boolean = false;
  DEBUGNewLogFile: boolean = true;
// ****************************************************************************
  procedure DEBUGMess(Shift: integer; Mess: string);
  procedure DEBUGSave(FName, Data: string; DateStamp: boolean);

implementation
const
  DEBUG_Shift: integer = 0;
  DEBUG_Shift_Delta: byte = 2;
  CRLF: string = #13#10;
// ****************************************************************************
procedure DEBUGMess(Shift: integer; Mess: string);
var
  fh, i, j, last: integer;
  tmp: AnsiString;
begin
  if DEBUGToFile then
  begin
    try
      tmp := Mess;
    except
      exit;
    end;
    fh := 0;
    try
      if FileExists(DEBUGFileName) then
      begin
        fh := FileOpen(DEBUGFileName, fmOpenReadWrite or fmShareDenyWrite);
        FileSeek(fh, 0, 2);
      end
      else
        fh := FileCreate(DEBUGFileName);
      if fh > 0 then
      begin
        DateSeparator := '-';
        tmp := '[' + DateToStr(Now) + ']-(' + TimeToStr(Time) + ')-  ';
        FileWrite(fh, tmp[1], Length(tmp));
        {--------------------------------}
        if Shift < 0 then
          dec(DEBUG_Shift);
        {--------------------------------}
        last := -1;
        tmp := StringOfChar(' ', DEBUG_Shift * DEBUG_Shift_Delta);
        for i := 0 to DEBUG_Shift div 2 do
        begin
          j := (2 * i) * DEBUG_Shift_Delta + 1;
          if (j > 0) and (j <= length(tmp)) then
          begin
            tmp[j] := '|';
            last := j;
          end;
        end;
        j := last;
        if (j > 0) and (j <= length(tmp)) then
          if (Shift > 0) then
            tmp[j] := '>'
          else
            if (Shift < 0) then
              tmp[j] := '<'
            else
              tmp[j] := ':';
        tmp := tmp +  Mess + CRLF;
        {--------------------------------}
        if Shift > 0 then
          inc(DEBUG_Shift);
        {--------------------------------}
        FileWrite(fh, tmp[1], Length(tmp));
      end;
    finally
      FileClose(fh);
    end;
  end;
  if DEBUGShowScr then
    ShowMessage(Mess);
end;

procedure DEBUGSave(FName, Data: string; DateStamp: boolean);
var
  fh: integer;
  tmp: AnsiString;
begin
  if DEBUGSaveToFile then
  begin
    try
      tmp := Data;
      tmp := FName;
    except
      exit;
    end;
    fh := 0;
    try
      tmp := '';
      if DateStamp then
      begin
        DateSeparator := '-';
        TimeSeparator := '-';
        tmp := '(' + DateToStr(Now) + '`' + TimeToStr(Time) + ')';
      end;
      fh := FileCreate(tmp + FName);
      if fh > 0 then
      begin
        tmp := Data;
        FileWrite(fh, tmp[1], Length(tmp));
      end;
    finally
      FileClose(fh);
    end;
  end;
end;

initialization
  if DEBUGNewLogFile then
  begin
    DateSeparator := '-';
    TimeSeparator := '-';
    DEBUGFileName := DEBUGProjectName + '_(' + DateToStr(Now) + '_' + TimeToStr(Time) + ').log';
  end
  else
    DEBUGFileName := DEBUGProjectName + '.log';
  DEBUGMess(0, StringOfChar('-', 10) + StringOfChar('=', 10) + '[Start]' + StringOfChar('=', 10) + StringOfChar('-', 10));
  DEBUGMess(0, 'DEBUGFileName = ' + DEBUGFileName);
  DEBUGMess(0, 'Bugger.Init');

finalization
  DEBUGMess(0, 'Bugger.Final');
  DEBUGMess(0, StringOfChar('-', 10) + StringOfChar('=', 10) + '[Finish]' + StringOfChar('=', 10) + StringOfChar('-', 10));

end.
