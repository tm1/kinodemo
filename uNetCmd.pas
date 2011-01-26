unit uNetCmd;

interface
uses
  uRescons,
  uMain,
  UDP,
  ShpCtrl;

  // TTicketAction = (taClear, taPrepare, taRestore, taReserve, taPrint, taPosTerminal, taPrintOneTicket, taFixCheq);
  // TNtiCmdType = (ntNothing, ntTrack, ntClear, ntPrepare, ntRestore, ntReserve, ntSave);

  function CheckIP(_IP: string): Boolean;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Check_DataStream(NetDataStream: string): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // NetDataCmd is plain command
  function Perform_Net_Commmand(NetDataCmd: string): Integer;
  function Create_Net_Commmand(var NetDataCmd: string; ssT: TTicketControl; NtiCmd: TNtiCmdType): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function _Net_Pack(var _PackStr: string; ssT: TTicketControl): Integer;
  function _Net_UnPack(_PackStr: string; var ssTRec: TTicketRec): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function BroadcastSend(NetData: string; Plain: Boolean; Except_Socket: Integer; SendMode: Byte): Integer; // ready
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function Nti_Track(ttRec: TTicketRec; ssT: TTicketControl): Integer;
  function Nti_Clear(ttRec: TTicketRec; ssT: TTicketControl): Integer;
  function Nti_Prepare(ttRec: TTicketRec; ssT: TTicketControl): Integer;
  function Nti_Restore(ttRec: TTicketRec; ssT: TTicketControl): Integer;
  function Nti_Reserve(ttRec: TTicketRec; ssT: TTicketControl): Integer;
  function Nti_Save(ttRec: TTicketRec; ssT: TTicketControl): Integer;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


implementation
uses
  Bugger,
  uTools,
  uAddon,
  uNetClt,
  uNetSrv,
  SysUtils;

{-----------------------------------------------------------------------------
  Procedure: CheckIP
  Author:    n0mad
  Date:      17-окт-2002
  Arguments: _IP: string
  Result:    Boolean
-----------------------------------------------------------------------------}
function CheckIP(_IP: string): Boolean;
const
  ProcName: string = 'CheckIP';
var
  i: Integer;
  len, p1: Byte;
  s, s1, s2, s3, s4: string;
begin
  Result := False;
  len := Length(_IP);
  DEBUGMess(0, '[' + ProcName + ']: _IP = (' + _IP + ')');
  if (len > 6) and (len < 16) then
  begin
    DEBUGMess(0, '[' + ProcName + ']: Check1 passed.');
    p1 := 0;
    for i := 1 to len do
    begin
      if _IP[i] = '.' then
        Inc(p1);
      if not (_IP[i] in ['0', '1'..'9', '.']) then
        Dec(p1);
    end;
    if (p1 = 3) then
    begin
      DEBUGMess(0, '[' + ProcName + ']: Check2 passed.');
      if Split(_IP, '.', s1, s3) then
        if Split(s3, '.', s2, s) then
          if Split(s, '.', s3, s4) then
            if (Length(s1) > 0) and (Length(s2) > 0) and (Length(s3) > 0) and (Length(s4) > 0) then
            begin
              DEBUGMess(0, '[' + ProcName + ']: Parsed IP = ' + s1 + '.' + s2 + '.' + s3 + '.' + s4);
              try
                i := StrToInt(s1);
                if (i >= 0) and (i < 255) then
                begin
                  i := StrToInt(s2);
                  if (i >= 0) and (i < 255) then
                  begin
                    i := StrToInt(s3);
                    if (i >= 0) and (i < 255) then
                    begin
                      i := StrToInt(s4);
                      if (i > 0) and (i < 255) then
                      begin
                        DEBUGMess(0, '[' + ProcName + ']: Check3 passed.');
                        Result := True;
                      end;
                    end;
                  end;
                end;
              except
              end;
            end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: Check_DataStream
  Author:    n0mad
  Date:      17-окт-2002
  Arguments: NetDataStream: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Check_DataStream(NetDataStream: string): Integer;
const
  ProcName: string = 'Check_DataStream';
var
  s: string;
  n: TNtiCmdType;
begin
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// NetDataCmd is plain command
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  if Length(NetDataStream) > 4 then
  begin
    s := UpperCase(Copy(NetDataStream, 1, 5));
    for n := Low(TNtiCmdType) to High(TNtiCmdType) do
      if (s = NTI_CMD_Array[n] + NTI_DLMT) then
      begin
        Result := 0;
{!$IFDEF uMain_Net_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Valid (' + s + ').');
{!$ENDIF}
        Break;
      end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: Perform_Net_Commmand
  Author:    n0mad
  Date:      17-окт-2002
  Arguments: NetDataCmd: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Perform_Net_Commmand(NetDataCmd: string): Integer;
const
  ProcName: string = 'Perform_Net_Commmand';
var
  s, ndc_1: string;
  i_ncmd, ncmd: TNtiCmdType;
  n1, n2: Integer;
  ttRec: TTicketRec;
  ssTmp: TTicketControl;
begin
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// NetDataCmd is plain command
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Result := -1;
  ssTmp := nil;
  if Length(NetDataCmd) > 4 then
  begin
    s := UpperCase(Copy(NetDataCmd, 1, 5));
    ncmd := ntNothing;
    for i_ncmd := Low(TNtiCmdType) to High(TNtiCmdType) do
      if (s = NTI_CMD_Array[i_ncmd] + NTI_DLMT) then
      begin
        ncmd := i_ncmd;
        Break;
      end;
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: NetCmd = "' + NTI_CMD_Array[i_ncmd] + '"');
{!$ENDIF}
    if ncmd <> ntNothing then
    begin
      ndc_1 := NetDataCmd;
      Delete(ndc_1, 1, 5);
      case ncmd of
      ntTrack, ntClear, ntPrepare, ntRestore, ntReserve, ntSave:
      begin
        if (Length(ndc_1) = 32) and (_Net_UnPack(ndc_1, ttRec) > -1) then
          if Nti_Parse(ttRec, ssTmp) > -1 then
          begin
            case ncmd of
            ntTrack:
              Nti_Track(ttRec, ssTmp);
            ntClear:
              Nti_Clear(ttRec, ssTmp);
            ntPrepare:
              Nti_Prepare(ttRec, ssTmp);
            ntRestore:
              Nti_Restore(ttRec, ssTmp);
            ntReserve:
              Nti_Reserve(ttRec, ssTmp);
            ntSave:
              Nti_Save(ttRec, ssTmp);
            else // case
            end; // case
            Result := 0;
          end;
      end;
      ntClearAll:
      begin
        if (Length(ndc_1) = 4) then
        begin
          try
            s := UpperCase(Copy(s, 1, 2));
            n1 := StrToInt(s);
            s := UpperCase(Copy(s, 3, 2));
            n2 := StrToInt(s);
            if (n1 > 0) and (n2 > 0) then
            begin
              {Nti_ClearAll(n1, n2)};
              Result := 0;
            end;
          except
          end;
        end;
      end;
      else // case
      end; // case
    end;
  end;
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Create_Net_Commmand
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: var NetDataCmd: string; ssT: TTicketControl; NtiCmd: TNtiCmdType
  Result:    Integer
-----------------------------------------------------------------------------}
function Create_Net_Commmand(var NetDataCmd: string; ssT: TTicketControl; NtiCmd: TNtiCmdType): Integer;
const
  ProcName: string = 'Create_Net_Commmand';
var
  s: string;
begin
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// NetDataCmd is plain command
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Result := -1;
  if Assigned(ssT) then
  begin
    NetDataCmd := NTI_CMD_Array[NtiCmd];
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: NetCmd = "' + NetDataCmd + '"');
{!$ENDIF}
    s := '';
    if (Length(NetDataCmd) > 0) and (_Net_Pack(s, ssT) > -1) then
    begin
      NetDataCmd := NetDataCmd + NTI_DLMT;
      if not (NtiCmd in [ntClearAll]) then
        NetDataCmd := NetDataCmd + s;
      case NtiCmd of
      ntTrack:
        {ignore};
      ntClear:
        {ignore};
      ntClearAll:
        {ignore};
      ntPrepare:
        {ignore};
      ntRestore:
        {ignore};
      ntReserve:
        {ignore};
      ntSave:
        {ignore};
      else
      end;
{!$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Done.');
{!$ENDIF}
      Result := 0;
    end;
  end;
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: _Net_Pack
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: var _PackStr: string; ssT: TTicketControl
  Result:    Integer
-----------------------------------------------------------------------------}
function _Net_Pack(var _PackStr: string; ssT: TTicketControl): Integer;
const
  ProcName: string = '_Net_Pack';
var
  s: string;
begin
  Result := -1;
  s := '';
  if Assigned(ssT) then
  with ssT do
  begin
    _PackStr := '';
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + FixFmt(Row, 3, '0');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + FixFmt(Column, 3, '0');
    // len = 6
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + F_OR_T[Selected];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + F_OR_T[Tracked];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + TC_Ch_Array[TC_State];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + Kav;
    // len = 10
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + FixFmt(Ticket_Kod, 10, '0');
    // len = 20
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + '.'; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + FixFmt(Ticket_Tarifpl, 3, '0');
    // len = 24
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + FixFmt(Ticket_Repert, 6, '0');
    // len = 30
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    _PackStr := _PackStr + FixFmt(Ticket_Owner, 2, '0');
    // len = 32
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Done.');
{!$ENDIF}
    Result := 0;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: _Net_UnPack
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: _PackStr: string; ssTRec: TTicketRec
  Result:    Integer
-----------------------------------------------------------------------------}
function _Net_UnPack(_PackStr: string; var ssTRec: TTicketRec): Integer;
const
  ProcName: string = '_Net_UnPack';
var
  ch1: Char;
  n1, i: Integer;
  t1: TTC_State;
begin
  Result := -1;
  if (Length(_PackStr) = 32) then
  begin
    try
      i := 1;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      n1 := StrToInt(Copy(_PackStr, i, 3));
      ssTRec.tr_Row := n1;
      Inc(i, 3);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      n1 := StrToInt(Copy(_PackStr, i, 3));
      ssTRec.tr_Column := n1;
      Inc(i, 3);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      ch1 := _PackStr[i];
      ssTRec.tr_Selected := (ch1 = F_OR_T[True]);
      Inc(i, 1);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      ch1 := _PackStr[i];
      ssTRec.tr_Tracked := (ch1 = F_OR_T[True]);
      Inc(i, 1);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      ch1 := _PackStr[i];
      ssTRec.TC_State := scFree;
      for t1 := Low(TTC_State) to High(TTC_State) do
        if TC_Ch_Array[t1] = ch1 then
        begin
          ssTRec.TC_State := t1;
          Break;
        end;
      Inc(i, 1);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      // ch1 := _PackStr[i];
      Inc(i, 1);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      n1 := StrToInt(Copy(_PackStr, i, 10));
      ssTRec.tr_Kod := n1;
      Inc(i, 10);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      // ch1 := _PackStr[i];
      Inc(i, 1);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      n1 := StrToInt(Copy(_PackStr, i, 3));
      ssTRec.tr_Tarifpl := n1;
      Inc(i, 3);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      n1 := StrToInt(Copy(_PackStr, i, 6));
      ssTRec.tr_Repert := n1;
      Inc(i, 6);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      n1 := StrToInt(Copy(_PackStr, i, 2));
      ssTRec.tr_Owner := n1;
      // Inc(i, 2);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{!$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Done.');
{!$ENDIF}
      Result := 0;
    except
{!$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Error - Can''t to do.');
{!$ENDIF}
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: BroadcastSend
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: NetData: string; Plain: Boolean; Except_Socket: Integer; SendMode: Byte
  Result:    Integer
-----------------------------------------------------------------------------}
function BroadcastSend(NetData: string; Plain: Boolean; Except_Socket: Integer; SendMode: Byte): Integer; // ready
const
  ProcName: string = 'BroadcastSend';
var
  i, len, _count, _socket: Integer;
  s, HexData: string;
begin
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  _count := -1;
  if (Length(NetData) > 0) then
  begin
    if Plain or FmtStr2Hex(NetData, HexData) then
    begin
      _count := 0;
      if ((SendMode and 1) = 1) and Assigned(fmMain.TCPClient1) then
        with fmMain.TCPClient1 do
          if (SocketState in [ssConnected]) then
          begin
            if Plain then
              Write(NetData + LineFeed)
            else
            begin
              Write(NET_CMD_Srv_Array[ncsData] + Space + HexData + LineFeed);
{!$IFDEF NO_DEBUG}
              Write(NET_CMD_Srv_Array[ncsNone] + Space + NetData + LineFeed);
{!$ENDIF}
            end;
{!$IFDEF uMain_Net_DEBUG}
            DEBUGMess(0, '[' + ProcName + ']: Sent to Server.');
{!$ENDIF}
            Inc(_count);
          end;
      if ((SendMode and 2) = 2) and Assigned(fmMain.TCPServer1) and Assigned(NetUserList) then
        with fmMain.TCPServer1 do
          if (SocketState in [ssListening]) then
          begin
            for i := 0 to NetUserList.Count - 1 do
            begin
              s := NetUserList.Strings[i];
              len := Length(s);
              if len > 0 then
                case s[1] of
                'a':
                  {ignore};
                'b':
                begin
                  _socket := Integer(NetUserList.Objects[i]);
                  if (_socket <> SBST_INVALID_SOCKET) and (_socket <> Except_Socket) then
                  begin
                    if Plain then
                      Write(_socket, NetData + LineFeed)
                    else
                    begin
                      Write(_socket, NET_CMD_Clt_Array[nccBroadcast] + Space + HexData + LineFeed);
{!$IFDEF NO_DEBUG}
                      Write(_socket, NET_CMD_Clt_Array[nccNone] + Space + NetData + LineFeed);
{!$ENDIF}
                    end;
{!$IFDEF uMain_Net_DEBUG}
                    DEBUGMess(0, '[' + ProcName + ']: Sent to Client(' + IntToStr(_socket) + ').');
{!$ENDIF}
                    Inc(_count);
                  end; // if
                end;
                else // case
                end; // case
            end; // for
          end; // if
    end; // if Plain
  end; // if Length()
  Result := _count;
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Nti_Track
  Author:    n0mad
  Date:      22-окт-2002
  Arguments: ttRec: TTicketRec; ssT: TTicketControl
  Result:    Integer
-----------------------------------------------------------------------------}
function Nti_Track(ttRec: TTicketRec; ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Track';
begin
  Result := -1;
  if Assigned(ssT) then
  begin
    ssT.UsedByNet := ((ttRec.TC_State in [scFree]) and ttRec.tr_Selected) or (ttRec.TC_State in [scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq]);
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: ssT.UsedByNet = ' + FALSE_OR_TRUE[ssT.UsedByNet]);
{!$ENDIF}
    Result := 0;
  end;
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// new 02.11.2002
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Nti_Clear(ttRec: TTicketRec; ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Clear';
begin
  Result := -1;
  if Assigned(ssT) then
  begin
    if ssT.UsedByNet then
    begin
      ssT.UsedByNet := false;
      case ttRec.TC_State of
      scFree:
        if ttRec.tr_Selected then
          ttRec.tr_Selected := false;
      scReserved:
        ttRec.tr_Selected := false;
      scPrepared:
      begin
        ttRec.tr_Selected := false;
        ttRec.TC_State := scFree;
      end;
      scFixed, scFixedNoCash, scFixedCheq:
        ttRec.tr_Selected := false;
      else
      end; // case
    end;
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: ssT.UsedByNet = ' + FALSE_OR_TRUE[ssT.UsedByNet]);
{!$ENDIF}
    Result := 0;
  end;
end;

function Nti_Prepare(ttRec: TTicketRec; ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Prepare';
begin
  Result := -1;
  if Assigned(ssT) then
  begin
    if ssT.UsedByNet then
    begin
      ssT.Ticket_DateTime := Now;
      // ssT.UsedByNet := ((ttRec.TC_State in [scFree]) and ttRec.tr_Selected) or (ttRec.TC_State in [scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq]);
    end;
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: ssT.UsedByNet = ' + FALSE_OR_TRUE[ssT.UsedByNet]);
{!$ENDIF}
    Result := 0;
  end;
end;

function Nti_Restore(ttRec: TTicketRec; ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Restore';
begin
  Result := -1;
  if Assigned(ssT) then
  begin
    if ssT.UsedByNet then
    begin
      ssT.Ticket_DateTime := Now;
      // ssT.UsedByNet := ((ttRec.TC_State in [scFree]) and ttRec.tr_Selected) or (ttRec.TC_State in [scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq]);
    end;
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: ssT.UsedByNet = ' + FALSE_OR_TRUE[ssT.UsedByNet]);
{!$ENDIF}
    Result := 0;
  end;
end;

function Nti_Reserve(ttRec: TTicketRec; ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Reserve';
begin
  Result := -1;
  if Assigned(ssT) then
  begin
    if ssT.UsedByNet then
    begin
      ssT.Ticket_DateTime := Now;
      // ssT.UsedByNet := ((ttRec.TC_State in [scFree]) and ttRec.tr_Selected) or (ttRec.TC_State in [scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq]);
    end;
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: ssT.UsedByNet = ' + FALSE_OR_TRUE[ssT.UsedByNet]);
{!$ENDIF}
    Result := 0;
  end;
end;

function Nti_Save(ttRec: TTicketRec; ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Save';
begin
  Result := -1;
  if Assigned(ssT) then
  begin
    // ssT.UsedByNet := ((ttRec.TC_State in [scFree]) and ttRec.tr_Selected) or (ttRec.TC_State in [scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq]);
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: ssT.UsedByNet = ' + FALSE_OR_TRUE[ssT.UsedByNet]);
{!$ENDIF}
    Result := 0;
  end;
end;

{$IFDEF uNetCmd_DEBUG}
initialization
  DEBUGMess(0, 'uNetCmd.Init');
{$ENDIF}

{$IFDEF uNetCmd_DEBUG}
finalization
  DEBUGMess(0, 'uNetCmd.Final');
{$ENDIF}

end.
