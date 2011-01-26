{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      :
Author       : n0mad
Module       : uNetClt.pas
Version      :
Description  :
Creation     : 16.10.2002 21:56:22
Installation :


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uNetClt;

interface
uses
  uRescons;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// TCP
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_TCP_Logging_Clt(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_TCP_HandShake_Clt(Sender: TObject; Socket: Integer): Integer; // ready
  function Process_TCP_DataStream_Clt(Socket: Integer; NetDataStream: string): Integer;
  function Process_TCP_NetData_Clt(Sender: TObject; Socket: Integer; NetData: string): Integer;
  function Process_TCP_Farewell_Clt(Sender: TObject; Socket: Integer): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_TCP_Error_Clt(Sender: TObject; Error: Integer; Msg: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// UDP
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_UDP_Logging_Clt(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_UDP_HandShake_Clt(Sender: TObject; Socket: Integer; NetData: string): Integer;
  function Process_UDP_NetData_Clt(Sender: TObject; Socket: Integer; NetData: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_UDP_Error_Clt(Sender: TObject; Error: Integer; Msg: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Common
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function ParseCommand_Clt(Command: string): TNetCmd_Clt; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function CheckNetUserState_Clt(Socket: Integer): Byte;
  function GenerateHashKey2(Socket: Integer; NetHostAddress, NetHostPort: string): string;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uNet_DEBUG}
{$ENDIF}

uses
  Bugger,
  uTools,
  uMain,
  uNetCmd,
  SysUtils;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_Logging_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; Flags: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_Logging_Clt(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
const
  ProcName: string = 'Process_TCP_Logging_Clt';
var
  NetHostName, NetHostAddress, NetHostPort: string;
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
{$IFDEF uNet_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Socket = (' + IntToStr(Socket) + ')');
{$ENDIF}
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain) then
  with fmMain do
  begin
    if (Flags and 1) = 0 then
      NetHostName := '';
    with TCPClient1 do
    begin
      NetHostAddress := PeerToAddress(Socket);
      NetHostPort := PeerToPort(Socket);
      if (Flags and 1) = 1 then
        NetHostName := PeerToName(Socket) + Space;
    end;
{$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Host = ' + NetHostName + '[' + NetHostAddress + '] ' + NetHostPort + ' (?)');
{$ENDIF}
    Result := 0;
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_HandShake_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_HandShake_Clt(Sender: TObject; Socket: Integer): Integer; // ready
const
  ProcName: string = 'Process_TCP_HandShake_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain.TCPClient1) then
  with fmMain.TCPClient1 do
  begin
    // Write('HELLO' + LineFeed);
    Write(NET_CMD_Srv_Array[ncsAuthLogin] + Space + 't-mf' + LineFeed);
    // Write(NET_CMD_Srv_Array[ncsHost] + LineFeed);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_DataStream_Clt
  Author:    n0mad
  Date:      17-окт-2002
  Arguments: Socket: Integer; NetDataStream: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_DataStream_Clt(Socket: Integer; NetDataStream: string): Integer;
const
  ProcName: string = 'Process_TCP_DataStream_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
{!$IFDEF uNet_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: NetDatStr = [' + NetDataStream + ']');
{!$ENDIF}
  if Check_DataStream(NetDataStream) > -1 then
  begin
{!$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Check passed.');
{!$ENDIF}
    Result := Perform_Net_Commmand(NetDataStream);
{!$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: PfmNetCmd.Result = ' + IntToStr(Result));
{!$ENDIF}
    Result := 0;
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_NetData_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_NetData_Clt(Sender: TObject; Socket: Integer; NetData: string): Integer;
const
  ProcName: string = 'Process_TCP_NetData_Clt';
var
  len, len_cmd: Integer;
  cmd,
  // usr,
  datastream: string;
  last1, last2: Char;
  pcmd: TNetCmd_Clt;
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain.TCPClient1) and (Length(NetData) > 0) then
  with fmMain.TCPClient1 do
  begin
{$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Data(' + IntToStr(Length(NetData)) + ') = [' + NetData + ']');
{$ENDIF}
    len := Length(NetData);
    if len > 5 then
      len_cmd := 5
    else
      len_cmd := len;
    cmd := Copy(NetData, 1, len_cmd - 1);
    last1 := NetData[len_cmd];
    pcmd := ParseCommand_Clt(cmd);
    if len > 6 then
    begin
      cmd := Copy(NetData, 6, len - 6);
      last2 := NetData[len];
    end
    else
    begin
      cmd := '';
      last2 := #0;
    end;
{!$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: pcmd = [' + NET_CMD_Clt_Array[pcmd] + ']');
{!$ENDIF}
    case pcmd of
    nccUnknown:
    begin
      Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + 'Invalid response.' + LineFeed);
    end;
    nccQuit:
    begin
      if (last1 = LineFeed) then
      begin
        Process_TCP_Farewell_Clt(Sender, Socket);
        fmMain.TCPClient1.Close;
      end
      else
        Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + 'Extra symbols present. Command ignored.' + LineFeed);
    end;
    nccBroadcast:
    begin
      if (Length(cmd) > 0) and (last1 = Space) and (last2 = LineFeed) then
      begin
        case CheckNetUserState_Clt(Socket) of
        1:
          Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + 'Not yet.' + LineFeed);
        2:
        begin
          len_cmd := Length(cmd);
          if FmtHex2Str(cmd, datastream) then
          begin
            if Process_TCP_Datastream_Clt(Socket, datastream) > -1 then
              Write(NET_CMD_Srv_Array[ncsOKAnswer] + Space + 'Received ' + IntToStr(len_cmd) + ' bytes.' + LineFeed)
            else
              Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + 'Received ' + IntToStr(len_cmd) + ' bytes. Wrong <datastream> format.' + LineFeed);
          end
          else
            Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + 'Received ' + IntToStr(len_cmd) + ' bytes. Invalid symbols in <datastream>.' + LineFeed);
        end;
        else
          Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + 'Unknown.' + LineFeed);
        end;
      end
      else
        Write(NET_CMD_Srv_Array[ncsERRAnswer] + Space + '<datastream> is missed.' + LineFeed);
    end;
    nccOKAnswer:
    begin
      {ignore}
    end;
    nccERRAnswer:
    begin
      {ignore}
    end;
    nccPing:
    begin
      Write(NET_CMD_Srv_Array[ncsOKAnswer] + Space + 'PONG' + LineFeed);
    end;
    else // case
    end; // case
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_Farewell_Clt
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_Farewell_Clt(Sender: TObject; Socket: Integer): Integer; // ready
const
  ProcName: string = 'Process_TCP_Farewell_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain.TCPClient1) then
  with fmMain.TCPClient1 do
  begin
    Write(NET_CMD_Srv_Array[ncsQuit] + LineFeed);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_Error_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_Error_Clt(Sender: TObject; Error: Integer; Msg: string): Integer;
const
  ProcName: string = 'Process_TCP_Error_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_UDP_Logging_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; Flags: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_Logging_Clt(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
const
  ProcName: string = 'Process_UDP_Logging_Clt';
var
  NetHostName, NetHostAddress, NetHostPort: string;
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
{$IFDEF uNet_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Socket = (' + IntToStr(Socket) + ')');
{$ENDIF}
  if Socket <> SBST_INVALID_SOCKET then
  with fmMain.UDPClient1 do
  begin
    if (Flags and 1) = 1 then
      NetHostName := PeerToName(Socket) + ' '
    else
      NetHostName := '';
    NetHostAddress := PeerToAddress(Socket);
    NetHostPort := PeerToPort(Socket);
{$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Host = ' + NetHostName + '[' + NetHostAddress + '] ' + NetHostPort + ' (?)');
{$ENDIF}
    Result := 0;
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_UDP_HandShake_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_HandShake_Clt(Sender: TObject; Socket: Integer; NetData: string): Integer;
const
  ProcName: string = 'Process_UDP_HandShake_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_UDP_NetData_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_NetData_Clt(Sender: TObject; Socket: Integer; NetData: string): Integer;
const
  ProcName: string = 'Process_UDP_NetData_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_UDP_Error_Clt
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_Error_Clt(Sender: TObject; Error: Integer; Msg: string): Integer;
const
  ProcName: string = 'Process_UDP_Error_Clt';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: ParseCommand_Clt
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: Command: string
  Result:    TNetCmd_Clt
-----------------------------------------------------------------------------}
function ParseCommand_Clt(Command: string): TNetCmd_Clt; // ready
var
  len: Integer;
  cmd: string;
  i_cmdClt: TNetCmd_Clt;
begin
  Result := nccUnknown;
  len := Length(Command);
  if (len > 0) then
  begin
    cmd := UpperCase(Command);
    if (cmd = 'Q') or (cmd = 'X') then
      Result := nccQuit
    else
      for i_cmdClt := Low(TNetCmd_Clt) to High(TNetCmd_Clt) do
        if NET_CMD_Clt_Array[i_cmdClt] = cmd then
        begin
          Result := i_cmdClt;
          Break;
        end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: GenerateHashKey2
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Socket, NetHostAddress, NetHostPort
  Result:    string
-----------------------------------------------------------------------------}
function GenerateHashKey2(Socket: Integer; NetHostAddress, NetHostPort: string): string;
var
  s1, s2, s3: string;
  curtime: TDateTime;
  Hour, Min, Sec, MSec: Word;
  Year, Month, Day: Word;
begin
  Randomize;
  curtime := Now;
  DecodeDate(curtime, Year, Month, Day);
  DecodeTime(curtime, Hour, Min, Sec, MSec);
  s1 := FormatTextToMax(IntToStr(Hour), 2, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(Min), 2, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(Sec), 2, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(MSec), 4, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(Year), 2, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(Month), 2, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(Day), 2, Char(32 + Random(224)), False);
  // 2 + 2 + 2 + 4 + 2 + 2 + 2 = 16
  s2 := FormatTextToMax(IntToStr(Socket), 4, Char(32 + Random(224)), False)
    + FormatTextToMax(NetHostPort, 5, Char(32 + Random(224)), False)
    + FormatTextToMax(NetHostAddress, 15, Char(32 + Random(224)), False);
  // 4 + 5 + 15 = 24
  s3 := FormatTextToMax(IntToStr(HInstance), 8, Char(32 + Random(224)), False)
    + FormatTextToMax(IntToStr(MainThreadID), 8, Char(32 + Random(224)), False);
  // 8 + 8 = 16
  s1 := XorStr(XorStr(s1 + s2 + s3, XR_Key), Char(1 + Random(255)));
  // 16 + 24 + 16 = 56
  FmtStr2Hex(s1, s2);
  Result := s2;
end;

{-----------------------------------------------------------------------------
  Procedure: CheckNetUserState_Clt
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Socket: Integer
  Result:    Byte
-----------------------------------------------------------------------------}
function CheckNetUserState_Clt(Socket: Integer): Byte;
begin
  Result := 2;
end;

{$IFDEF uNetClt_DEBUG}
initialization
  DEBUGMess(0, 'uNetClt.Init');
{$ENDIF}

{$IFDEF uNetClt_DEBUG}
finalization
  DEBUGMess(0, 'uNetClt.Final');
{$ENDIF}

end.
