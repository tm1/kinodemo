{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uNetSrv.pas
Version      :
Description  :
Creation     : 13.10.2002 21:56:22
Installation :


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uNetSrv;

interface
uses
  uRescons;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// TCP
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_TCP_Logging_Srv(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_TCP_HandShake_Srv(Sender: TObject; Socket: Integer): Integer; // ready
  // NetDataCmd is plain command
  function Process_TCP_DataStream_Srv(Socket: Integer; NetDataStream: string): Integer; // ready
  function Process_TCP_NetData_Srv(Sender: TObject; Socket: Integer; NetData: string): Integer; // ready
  function Process_TCP_Farewell_Srv(Sender: TObject; Socket: Integer): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_TCP_Error_Srv(Sender: TObject; Error: Integer; Msg: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// UDP
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_UDP_Logging_Srv(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_UDP_HandShake_Srv(Sender: TObject; Socket: Integer; NetData: string): Integer;
  function Process_UDP_NetData_Srv(Sender: TObject; Socket: Integer; NetData: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Process_UDP_Error_Srv(Sender: TObject; Error: Integer; Msg: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Common
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function ParseCommand_Srv(Command: string): TNetCmd_Srv; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function RegNetUser_Srv(Socket: Integer; UserHash: string; var UserName: string): Boolean; // ready
  function CheckNetUserState_Srv(Socket: Integer): Byte; // ready
  function UnregNetUser_Srv(Socket: Integer): Boolean; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  function CheckNetHash_Srv(Socket: Integer; HashString: string): Boolean;
  function GenerateHashKey1(Socket: Integer; NetHostAddress, NetHostPort: string): string; // ready
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
  Procedure: Process_TCP_Logging_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; Flags: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_Logging_Srv(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
const
  ProcName: string = 'Process_TCP_Logging_Srv';
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
    with TCPServer1 do
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
  Procedure: Process_TCP_HandShake_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_HandShake_Srv(Sender: TObject; Socket: Integer): Integer; // ready
const
  ProcName: string = 'Process_TCP_HandShake_Srv';
var
  NetHostAddress, NetHostPort, HashKey1, s: string;
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain.TCPServer1) then
  with fmMain.TCPServer1 do
  begin
    NetHostAddress := PeerToAddress(Socket);
    NetHostPort := PeerToPort(Socket);
{$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Host = [' + NetHostAddress + '] ' + NetHostPort + '.');
{$ENDIF}
    HashKey1 := GenerateHashKey1(Socket, NetHostAddress, NetHostPort);    
    if Assigned(NetUserList) then
      try
        s := 'a_' + NetHostAddress + '_' + NetHostPort + '=' + HashKey1;
{$IFDEF uNet_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: s = [' + s + ']');
{$ENDIF}
        NetUserList.AddObject(s, Pointer(Socket));
{$IFDEF uNet_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: NetUsrLst.Count = (' + IntToStr(NetUserList.Count) + ')')
{$ENDIF}
      except
        DEBUGMess(0, '[' + ProcName + ']: Error - NetUsrLst.Add fail.');
      end;
    Write(Socket, NET_CMD_Clt_Array[nccOKAnswer] + Space + Srv_Mess + ' ready <' + HashKey1 + '>' + LineFeed);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_DataStream_Srv
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_DataStream_Srv(Socket: Integer; NetDataStream: string): Integer; // ready
const
  ProcName: string = 'Process_TCP_DataStream_Srv';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// NetDataCmd is plain command
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
{$IFDEF uNet_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: NetDatStr = [' + NetDataStream + ']');
{$ENDIF}
  if Check_DataStream(NetDataStream) > -1 then
  begin
{$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Check passed.');
{$ENDIF}
    Result := Perform_Net_Commmand(NetDataStream);
{$IFDEF uNet_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: PfmNetCmd.Result = ' + IntToStr(Result));
{$ENDIF}
    Result := 0;
    BroadcastSend(NetDataStream, False, Socket, 3);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_NetData_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender, Socket, NetData
  Result:    integer
-----------------------------------------------------------------------------}
function Process_TCP_NetData_Srv(Sender: TObject; Socket: Integer; NetData: string): Integer; // ready
const
  ProcName: string = 'Process_TCP_NetData_Srv';
var
  NetHostName, NetHostAddress, NetHostPort: string;
  len, len_cmd: Integer;
  cmd, usr, datastream: string;
  last1, last2: Char;
  pcmd: TNetCmd_Srv;
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain.TCPServer1) and (Length(NetData) > 0) then
  with fmMain.TCPServer1 do
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
    pcmd := ParseCommand_Srv(cmd);
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
    DEBUGMess(0, '[' + ProcName + ']: pcmd = [' + NET_CMD_Srv_Array[pcmd] + ']');
{!$ENDIF}
    case pcmd of
    ncsUnknown:
    begin
      Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Invalid command; valid commands: ' + NET_CMD_Srv_Array[ncsQuit] + ', ' + NET_CMD_Srv_Array[ncsAuthLogin] + ', ' + NET_CMD_Srv_Array[ncsData] + '.' + LineFeed);
    end;
    ncsQuit:
    begin
      if (last1 = LineFeed) then
      begin
        Process_TCP_Farewell_Srv(Sender, Socket);
        Disconnect(Socket);
      end
      else
        Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Extra symbols present. Command ignored.' + LineFeed);
    end;
    ncsAuthLogin:
    begin
      if (Length(cmd) > 0) and (last1 = Space) and (last2 = LineFeed) then
      begin
        case CheckNetUserState_Srv(Socket) of
        1:
          if RegNetUser_Srv(Socket, cmd, usr) then
          begin
{$IFDEF uNet_DEBUG}
            DEBUGMess(0, '[' + ProcName + ']: ' + usr + ' logged in.');
{$ENDIF}
            Write(Socket, NET_CMD_Clt_Array[nccOKAnswer] + Space + 'Hello, ' + usr + '. You may use DATA.' + LineFeed);
          end
          else
          begin
{$IFDEF uNet_DEBUG}
            DEBUGMess(0, '[' + ProcName + ']: Authentication failed.');
{$ENDIF}
            Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Authentication failed.' + LineFeed);
          end;
        2:
          Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Already log in.' + LineFeed);
        else
          Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Unknown.' + LineFeed);
        end;
      end
      else
        Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + '<userhash> is missed.' + LineFeed);
    end;
    ncsData:
    begin
      if (Length(cmd) > 0) and (last1 = Space) and (last2 = LineFeed) then
      begin
        case CheckNetUserState_Srv(Socket) of
        1:
          Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Log in first.' + LineFeed);
        2:
        begin
          len_cmd := Length(cmd);
          if FmtHex2Str(cmd, datastream) then
          begin
            if Process_TCP_Datastream_Srv(Socket, datastream) > -1 then
              Write(Socket, NET_CMD_Clt_Array[nccOKAnswer] + Space + 'Received ' + IntToStr(len_cmd) + ' bytes.' + LineFeed)
            else
              Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Received ' + IntToStr(len_cmd) + ' bytes. Wrong <datastream> format.' + LineFeed);
          end
          else
            Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Received ' + IntToStr(len_cmd) + ' bytes. Invalid symbols in <datastream>.' + LineFeed);
        end;
        else
          Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Unknown.' + LineFeed);
        end;
      end
      else
        Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + '<datastream> is missed.' + LineFeed);
    end;
    ncsOKAnswer:
    begin
      {ignore}
    end;
    ncsERRAnswer:
    begin
      {ignore}
    end;
    ncsHost:
    begin
      case CheckNetUserState_Srv(Socket) of
      1:
        Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Log in first.' + LineFeed);
      2:
      begin
        NetHostName := PeerToName(Socket);
        NetHostAddress := PeerToAddress(Socket);
        NetHostPort := PeerToPort(Socket);
{$IFDEF uNet_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Host = ' + NetHostName + ' [' + NetHostAddress + '] ' + NetHostPort + ' (?)');
{$ENDIF}
        Write(Socket, NET_CMD_Clt_Array[nccOKAnswer] + Space + 'Client is ' + NetHostName + ' [' + NetHostAddress + '] ' + NetHostPort + ' (?)' + LineFeed);
      end;
      else
        Write(Socket, NET_CMD_Clt_Array[nccERRAnswer] + Space + 'Unknown.' + LineFeed);
      end;
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
  Procedure: Process_TCP_Farewell_Srv
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_Farewell_Srv(Sender: TObject; Socket: Integer): Integer; // ready
const
  ProcName: string = 'Process_TCP_Farewell_Srv';
begin
{$IFDEF uNet_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := 0;
  if (Socket <> SBST_INVALID_SOCKET) and Assigned(fmMain.TCPServer1) then
  with fmMain.TCPServer1 do
  begin
    UnregNetUser_Srv(Socket);
{$IFDEF uNet_DEBUG}
    if Assigned(NetUserList) then
      try
        DEBUGMess(0, '[' + ProcName + ']: NetUsrLst.Count = (' + IntToStr(NetUserList.Count) + ')')
      except
        DEBUGMess(0, '[' + ProcName + ']: Error - NetUsrLst.Count read...')
      end;
{$ENDIF}
    Write(Socket, NET_CMD_Clt_Array[nccOKAnswer] + Srv_Mess + ' signing off.' + LineFeed);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uNet_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Process_TCP_Error_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_TCP_Error_Srv(Sender: TObject; Error: Integer; Msg: string): Integer;
const
  ProcName: string = 'Process_TCP_Error_Srv';
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
  Procedure: Process_UDP_Logging_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; Flags: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_Logging_Srv(Sender: TObject; Socket: Integer; Flags: Integer): Integer; // ready
const
  ProcName: string = 'Process_UDP_Logging_Srv';
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
  with fmMain.TCPServer1 do
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
  Procedure: Process_UDP_HandShake_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_HandShake_Srv(Sender: TObject; Socket: Integer; NetData: string): Integer;
const
  ProcName: string = 'Process_UDP_HandShake_Srv';
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
  Procedure: Process_UDP_NetData_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Socket: Integer; NetData: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_NetData_Srv(Sender: TObject; Socket: Integer; NetData: string): Integer;
const
  ProcName: string = 'Process_UDP_NetData_Srv';
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
  Procedure: Process_UDP_Error_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Process_UDP_Error_Srv(Sender: TObject; Error: Integer; Msg: string): Integer;
const
  ProcName: string = 'Process_UDP_Error_Srv';
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
  Procedure: ParseCommand_Srv
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: Command: string
  Result:    TNetCmd_Srv
-----------------------------------------------------------------------------}
function ParseCommand_Srv(Command: string): TNetCmd_Srv; // ready
var
  len: Integer;
  cmd: string;
  i_cmdSrv: TNetCmd_Srv;
begin
  Result := ncsUnknown;
  len := Length(Command);
  if (len > 0) then
  begin
    cmd := UpperCase(Command);
    if (cmd = 'Q') or (cmd = 'X') then
      Result := ncsQuit
    else
      for i_cmdSrv := Low(TNetCmd_Srv) to High(TNetCmd_Srv) do
        if NET_CMD_Srv_Array[i_cmdSrv] = cmd then
        begin
          Result := i_cmdSrv;
          Break;
        end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: RegNetUser_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Socket: Integer; UserName: string
  Result:    Boolean
-----------------------------------------------------------------------------}
function RegNetUser_Srv(Socket: Integer; UserHash: string; var UserName: string): Boolean; // ready
var
  i, _index, len: Integer;
  s: string;
begin
  Result := False;
  if Assigned(NetUserList) then
  begin
    _index := -1;
    for i := 0 to NetUserList.Count - 1 do
    begin
      if NetUserList.Objects[i] = Pointer(Socket) then
      begin
        _index := i;
        Break;
      end;
    end;
    if _index > -1 then
    begin
      s := NetUserList.Strings[_index];
      len := Length(s);
      i := Pos('=', s);
      if i > 0 then
      begin
        s := Copy(s, i + 1, len - i);
        if (UserHash = s) then
        begin
          UserName := 'Guest';
          Result := True;
        end
        else
          if (UserHash = 't-mf') then
          begin
            UserName := 'master';
            Result := True;
          end;
        if Result then
        begin
          s := NetUserList.Strings[_index];
          if Length(s) > 0 then
          begin
            s[1] := 'b';
            NetUserList.Strings[_index] := s;
          end;
        end;
      end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: CheckNetHash_Srv
  Author:    n0mad
  Date:      15-окт-2002
  Arguments: Socket: Integer; HashString: string
  Result:    Boolean
-----------------------------------------------------------------------------}
{function CheckNetHash_Srv(Socket: Integer; HashString: string): Boolean;
var
  i, _index: Integer;
begin
  Result := False;
  if Assigned(NetUserList) then
  begin
    _index := -1;
    for i := 0 to NetUserList.Count - 1 do
    begin
      if NetUserList.Objects[i] = Pointer(Socket) then
      begin
        _index := i;
        Break;
      end;
    end;
    if _index > -1 then
    begin

    end;
  end;
end;}

{-----------------------------------------------------------------------------
  Procedure: GenerateHashKey1
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Socket, NetHostAddress, NetHostPort
  Result:    string
-----------------------------------------------------------------------------}
function GenerateHashKey1(Socket: Integer; NetHostAddress, NetHostPort: string): string; // ready
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
  Procedure: CheckNetUserState_Srv
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Socket: Integer
  Result:    Byte
-----------------------------------------------------------------------------}
function CheckNetUserState_Srv(Socket: Integer): Byte; // ready
var
  i, _index, len: Integer;
  s: string;
begin
  Result := 0;
  if Assigned(NetUserList) then
  begin
    _index := -1;
    for i := 0 to NetUserList.Count - 1 do
    begin
      if NetUserList.Objects[i] = Pointer(Socket) then
      begin
        _index := i;
        Break;
      end;
    end; // for
    if _index > -1 then
    begin
      s := NetUserList.Strings[_index];
      len := Length(s);
      if len > 0 then
        case s[1] of
        'a':
          Result := 1;
        'b':
          Result := 2;
        else
          Result := 255;
        end; // case
    end; // if index > -1 then
  end; // if Assigned(NetUserList) then
end;

{-----------------------------------------------------------------------------
  Procedure: UnregNetUser_Srv
  Author:    n0mad
  Date:      16-окт-2002
  Arguments: Socket: Integer
  Result:    Boolean
-----------------------------------------------------------------------------}
function UnregNetUser_Srv(Socket: Integer): Boolean; // ready
var
  i, _index: Integer;
begin
  Result := false;
  if Assigned(NetUserList) then
  begin
    _index := -1;
    for i := 0 to NetUserList.Count - 1 do
    begin
      if NetUserList.Objects[i] = Pointer(Socket) then
      begin
        _index := i;
        Break;
      end;
    end; // for
    if _index > -1 then
    begin
      NetUserList.Delete(_index);
    end; // if index > -1 then
  end; // if Assigned(NetUserList) then
end;

{$IFDEF uNetSrv_DEBUG}
initialization
  DEBUGMess(0, 'uNetSrv.Init');
{$ENDIF}

{$IFDEF uNetSrv_DEBUG}
finalization
  DEBUGMess(0, 'uNetSrv.Final');
{$ENDIF}

end.
