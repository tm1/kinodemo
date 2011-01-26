{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uAddon.pas
Version      : 18.10.2002 7:07:07
Description  : 
Creation     : 12.10.2002 9:01:20
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uAddon;

interface
uses
  Bugger,
  uRescons,
  uTools,
  ShpCtrl,
  uCells,
  uMain,
  uDatamod,
  uPrint,
  uSplash,
  uInfo,
  uNetCmd,
  Graphics,
  Extctrls,
  Classes,
  SysUtils,
  Forms,
  Gauges,
  Controls,
  Comctrls,
  Menus,
  Math,
  Db;

type
  // scFree, scBroken, scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq
  TTicketSummary = record
    Place_Kod_Pl: integer;
    Place_Is_Free: boolean;
    Place_Cost: integer;
    Place_Type: integer;
    // ------
    Place_Reserved: integer;
    Place_Prepared: integer;
    Place_Prepared_Sum: integer;
    Place_Fixed: integer;
    Place_Fixed_Sum: integer;
    Place_FixedNoCash: integer;
    Place_FixedNoCash_Sum: integer;
    Place_FixedCheq: integer;
    Place_FixedCheq_Sum: integer;
    // ------
    Place_Tag: integer;
  end;

  TTicketType = record
    tt_Tarifpl_Kod: integer;
    tt_Tarifpl_Nam: string[40];
    tt_Tarifpl_PRINT: boolean;
    tt_Tarifpl_REPORT: boolean;
    tt_Tarifpl_FREE: boolean;
    tt_Tarifpl_SHOW: boolean;
    tt_Tarifpl_SYS: boolean;
    tt_Tarifpl_TYPE: integer;
    tt_Tarifpl_BGCOLOR: TColor;
    tt_Tarifpl_FNTCOLOR: TColor;
    tt_Tarifpl_TAG: integer;
  end;

{  TTicketPrice = record
    tt_Tarifpl_Kod: integer;
//    tt_Tarifpl_Nam: integer;
    tt_Tarifpl_PRINT: boolean;
    tt_Tarifpl_REPORT: boolean;
    tt_Tarifpl_FREE: boolean;
    tt_Tarifpl_SHOW: boolean;
    tt_Tarifpl_SYS: boolean;
    tt_Tarifpl_TYPE: integer;
    tt_Tarifpl_BGCOLOR: TColor;
    tt_Tarifpl_FNTCOLOR: TColor;
    tt_Tarifpl_TAG: integer;
  end;}

  // TTC_State = (scFree, scBroken, scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq);
  // TTicketAction = (taClear, taPrepare, taRestore, taReserve, taPrint, taPosTerminal, taPrintOneTicket, taFixCheq);

const
  Cur_Date: TDateTime = 0;
  Cur_Repert_Kod: integer = -1;
  Cur_Zal_Kod: integer = -1;
  Cur_Film_Kod: integer = -1;
  Cur_Panel_Cntr: TPanel = nil;
  _Count_To_Print: integer = 0;

  // --------------------------------------------------------------------------
  procedure Init_Cur_Date;
  function Init_Cur_Repert: integer;
//  function Init_Cur_Film: integer;
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса
  // --------------------------------------------------------------------------
  procedure Load_Zal_Map(Zal_Num: integer);
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // --------------------------------------------------------------------------
  function Load_All_Zals: integer;
  // --------------------------------------------------------------------------
  // Загрузка цветов фона и шрифта
  // --------------------------------------------------------------------------
  procedure Change_Tarifpl_Desc(i_Tarifpl_Kod: integer;
    var c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor);
  // --------------------------------------------------------------------------
  function Get_Tarifpl(i_Tarifpl_Kod: integer;
    var b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: boolean;
    var i_Tarifpl_TYPE: Integer; var c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor;
    var i_Tarifpl_TAG: integer): integer; // ready
  // --------------------------------------------------------------------------
  // Добавление типа билета в интерфейс
  // --------------------------------------------------------------------------
  procedure Add_Tarifpl_Desc(i_Tarifpl_Kod: integer; str_Tarifpl_Nam: string;
    b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: Boolean;
    i_Tarifpl_TYPE: Integer; c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor; i_Tarifpl_TAG: Integer);
  // --------------------------------------------------------------------------
  // Загрузка типа билета из запроса
  // --------------------------------------------------------------------------
  procedure Load_Tarifpl_Desc(DataSet: TDataSet; Tarifpl_Kod: integer);
  // --------------------------------------------------------------------------
  // Очистка интерфейса (меню и списка картинок)
  // --------------------------------------------------------------------------
  procedure Clear_User_Interface;
  procedure Load_User_Interface_Info;
  // --------------------------------------------------------------------------
  // 2.2) Загрузка всех типов билетов
  // --------------------------------------------------------------------------
  function Load_All_Ticket_Types: Integer;
  // --------------------------------------------------------------------------
  // Загрузка тарифа из запроса
  // --------------------------------------------------------------------------
  function Get_Tarifet_Desc(i_Tarifet, i_Tarifpl: Integer; var i_Cost: Integer): Integer;
  // --------------------------------------------------------------------------
  // Загрузка тарифа из запроса
  // --------------------------------------------------------------------------
  procedure Load_Tarifet_Desc(DataSet: TDataSet; Tarifet_Kod, Tarifpl_Kod, i_Cost: integer);
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
  function Load_All_Tarifs: integer;
  // --------------------------------------------------------------------------
  // Обновление подсказки
  // --------------------------------------------------------------------------
  procedure Refresh_TC_Hint(ssT :TTicketControl); // ready partially
  // --------------------------------------------------------------------------
  // Загрузка билета из запроса и обновление состояния
  // --------------------------------------------------------------------------
  procedure Refresh_TC_Count(ssT :TTicketControl);
  procedure Refresh_TC_State(ssT :TTicketControl; _Kod, _TARIFPL, _REPERT: Integer;
    _DATETIME: TDateTime; _STATE, _OWNER: Integer; _RESTORED: Boolean; _TAG: Integer);
  // --------------------------------------------------------------------------
  // Загрузка всех билетов
  // --------------------------------------------------------------------------
  procedure Load_All_TC(Repert_Film: integer);
  // --------------------------------------------------------------------------
  // Обработка выделенного билета
  // --------------------------------------------------------------------------
  function Refresh_TC_Selected(ssT: TTicketControl; ActionToDo: TTicketAction; i_Tarifpl, i_Repert_Kod, i_Owner: integer): Integer;
  // --------------------------------------------------------------------------
  // Обработка выделенных билетов
  // --------------------------------------------------------------------------
  function Refresh_All_TC_Selected(ActionToDo: TTicketAction; i_Tarifpl, i_Repert_Kod: integer): Integer;
  // --------------------------------------------------------------------------
  procedure Refresh_Date(NewDate: TDateTime); // Смена даты
  procedure Refresh_Zal(NewZal: integer); // Смена зала
  procedure Refresh_Film(NewFilm: integer); // Смена сеанса
  // --------------------------------------------------------------------------
  function Check_Cntr: boolean; // ready
  procedure Modify_Tarifpl_Desc(_Tarifet: integer); // ready partially
  procedure Load_Tarifet(i_Repert_Kod: integer);
  // --------------------------------------------------------------------------
  // Сохранение в базе отправленного на печать билета
  // --------------------------------------------------------------------------
  function Save2DB(ssT: TTicketControl; Restore: Boolean): Integer; // ready partially
  // --------------------------------------------------------------------------
  function Get_Repert_Film_Desc(_Repert_Kod: Integer; var d_Film_Date: TDateTime;
    var str_Zal_Nam, str_Film_Name, str_Seans_Desk: string): Integer; // ready
  function Get_Repert_Desc(_Repert_Kod: Integer;
    var Repert_DATE: TDateTime; var Repert_Seans, Repert_Film, Repert_Tarifet,
    Repert_Zal, Repert_TAG: Integer): Integer; // ready
  // --------------------------------------------------------------------------
  function Exist_Zal_Desc(Zal_Kod: Byte): Boolean;
  // --------------------------------------------------------------------------
  function Get_Caption_Length(_Text: string; _Font: TFont): Integer;
  function Get_Caption_Addon(_Text: string; MaxW: Integer; _Font: TFont): Integer;
  // --------------------------------------------------------------------------
  function Nti_Parse(ttRec: TTicketRec; var ssT: TTicketControl): Integer;
  function GetOption(OptionName: string; var OptionValue: string): Integer;
  function SaveOption(OptionName, OptionValue: string; _Create: boolean): Integer;

implementation

uses
  Dialogs;

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uAddon_DEBUG}
{$ENDIF}

{-----------------------------------------------------------------------------
  Procedure: Init_Cur_Date
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure Init_Cur_Date;
const
  ProcName: string = 'Init_Cur_Date';
begin
  Cur_Date := 0;
  fmMain.dtpDate.Date := Date;
end;

{-----------------------------------------------------------------------------
  Procedure: Init_Cur_Repert
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    integer
-----------------------------------------------------------------------------}
function Init_Cur_Repert: integer;
const
  ProcName: string = 'Init_Cur_Repert';
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Cur_Repert_Kod := -1;
  Cur_Film_Kod := -1;
  Result := -1;
  with dm, dm.qRepert do
  if PrepareQuery_Repert_SQL(1, Cur_Date, Cur_Zal_Kod, 0) > 0 then
  begin
    UniDirectional := true;
    Open;
{}    
    Result := RecordCount;
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
    if Result > 0 then
    begin
      Cur_Repert_Kod := FieldByName(s_Repert_Kod).AsInteger;
      Cur_Film_Kod := FieldByName(s_Repert_Film).AsInteger;
      DEBUGMess(0, '[' + ProcName + ']: Cur_Repert_Kod = ' + IntToStr(Cur_Repert_Kod));
    end;
{}
    with fmMain.tbcFilm do
    begin
      Combo_Load_Repert(qRepert, Tabs);
      DEBUGMess(0, '[' + ProcName + ']: Tabs.Count = ' + IntToStr(Tabs.Count));
      if Tabs.Count > 0 then
      begin
        TabIndex := Tabs.IndexOfObject(TObject(Cur_Repert_Kod));
        DEBUGMess(0, '[' + ProcName + ']: TabIndex = ' + IntToStr(TabIndex));
        if TabIndex = -1 then
        begin
          TabIndex := 0;
          Cur_Repert_Kod := Integer(Tabs.Objects[0]);
          DEBUGMess(0, '[' + ProcName + ']: Cur_Repert_Kod = ' + IntToStr(Cur_Repert_Kod));
        end;
      end;
    end;
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_Zal_Map
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: Zal_Num: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Load_Zal_Map(Zal_Num: integer);
const
  ProcName: string = 'Load_Zal_Map';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i: integer;
  tmp_Zal_Plan: TStrings;
  Gauge: TGauge;
  NewPanel: TPanel;
begin
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(1, '[' + ProcName + ']: ->');
  i := fmMain.cmZal.Items.IndexOfObject(TObject(Zal_Num));
  if (i <> -1) then
  begin
    Cur_Zal_Kod := Zal_Num;
    with fmMain do
    begin
      cmZal.Enabled := false;
      DEBUGMess(0, '[' + ProcName + ']: cmZal.Enabled = false');
      Gauge := ggProgress;
      if Assigned(fmSplash) then
        try
          fmSplash.Show;
          Gauge := fmSplash.ggSplash;
        except
          Gauge := ggProgress;
        end;
      i := ZalList.IndexOf(IntToStr(Cur_Zal_Kod));
      if i = -1 then
      begin
        tmp_Zal_Plan := nil;
        try
          tmp_Zal_Plan := TStringList.Create;
          ImportZal_ThreadExecuted := true;
          DEBUGMess(0, '[' + ProcName + ']: ImportZal(' + FixFmt(Cur_Zal_Kod, 3, '0') + ') - Begin');
          ImportZal(tmp_Zal_Plan, Cur_Zal_Kod, Gauge);
          DEBUGMess(0, '[' + ProcName + ']: ImportZal(' + FixFmt(Cur_Zal_Kod, 3, '0') + ') - End');
          while ImportZal_ThreadExecuted do
            Application.ProcessMessages;
          ZalList.AddObject(IntToStr(Cur_Zal_Kod), tmp_Zal_Plan);
        except
          tmp_Zal_Plan.Free;
        end;
      end;
      i := ZalList.IndexOf(IntToStr(Cur_Zal_Kod));
      if i > -1 then
      begin
        tmp_Zal_Plan := TStrings(ZalList.Objects[i]);
        try
          NewPanel := TPanel.Create(fmMain.pnZal_Container);
          NewPanel.Name := 'pnZal_' + IntToStr(Cur_Zal_Kod);
          NewPanel.Parent := fmMain.pnZal_Container;
          NewPanel.Caption := '-=(' + IntToStr(Cur_Zal_Kod) + ')=-';
          NewPanel.Visible := false;
          NewPanel.Left := 0;
          NewPanel.Top := 0;
          NewPanel.Width := 1;
          NewPanel.Height := 1;
          NewPanel.BevelInner := bvRaised;
          NewPanel.BevelOuter := bvLowered;
          NewPanel.Hint := NewPanel.Name;
          NewPanel.ShowHint := true;
          NewPanel.Tag := Cur_Zal_Kod;
          CreateZal_ThreadExecuted := true;
          DEBUGMess(0, '[' + ProcName + ']: CreateZal(' + FixFmt(Cur_Zal_Kod, 3, '0') + ') - Begin');
          CreateZal(tmp_Zal_Plan, Cur_Zal_Kod, Gauge, NewPanel, 0, MultiplrMain, true);
          DEBUGMess(0, '[' + ProcName + ']: CreateZal(' + FixFmt(Cur_Zal_Kod, 3, '0') + ') - End');
          NewPanel.Visible := false;
        except
          DEBUGMess(0, '[' + ProcName + ']: Error - Creating Zal(' + FixFmt(Cur_Zal_Kod, 3, '0') + ')');
        end;
        while CreateZal_ThreadExecuted do
          Application.ProcessMessages;
      end;
{      if Assigned(fmMinimap) then
        fmMinimap.OnActivate(nil);}
      cmZal.Enabled := true;
      DEBUGMess(0, '[' + ProcName + ']: cmZal.Enabled = true');
    end;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_All_Zals
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    integer
-----------------------------------------------------------------------------}
function Load_All_Zals: integer;
const
  ProcName: string = 'Load_All_Zals';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('*', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  Cur_Zal_Kod := -1;
  with dm, dm.qZal, fmMain.cmZal do
  if db.Connected then
  begin
    Result := PrepareQuery_Zal(Items);
    DEBUGMess(0, '[' + ProcName + ']: Items.Count = (' + IntToStr(Items.Count) + ')');
    DEBUGMess(0, '[' + ProcName + ']: ItemIndex = (' + IntToStr(ItemIndex) + ')');
    if (Items.Count > 0) then
    begin
      if (ItemIndex = -1) then
        ItemIndex := 0;
//      Cur_Zal_Kod := integer(Items.Objects[ItemIndex])
    end;
    DEBUGMess(0, '[' + ProcName + ']: Cur_Zal_Kod = ' + IntToStr(Cur_Zal_Kod));
{}
    Close;
    UniDirectional := true;
    Open;
{}
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
    Combo_Load_Zal_Map(qZal, nil);  // Загрузка залов из запроса
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('*', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: Change_Tarifpl_Desc
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: i_Tarifpl_Kod: integer; var c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor
  Result:    None
-----------------------------------------------------------------------------}
procedure Change_Tarifpl_Desc(i_Tarifpl_Kod: integer;
  var c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor);
const
  ProcName: string = 'Change_Tarifpl_Desc';
var
  i: integer;
  s: string;
  p_TicketType: ^TTicketType;
begin
  // --------------------------------------------------------------------------
  // Загрузка цветов фона и шрифта
  // --------------------------------------------------------------------------
{$IFDEF uAddon_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  if Assigned(fmMain) then
  begin
    c_Tarifpl_BGCOLOR := fmMain.ssSelect.FixedBrush.Color;
    c_Tarifpl_FNTCOLOR := fmMain.ssSelect.FixedFont.Color;
    // DEBUGMess(0, '[' + ProcName + ']: fmMain is assigned.');
  end
  else
  begin
    c_Tarifpl_BGCOLOR := clDkGray;
    c_Tarifpl_FNTCOLOR := clLtGray;
    DEBUGMess(0, '[' + ProcName + ']: fmMain is not assigned.');
  end;
  if Assigned(TicketTypesList) then
  begin
    if TicketTypesList.Count > 0 then
    begin
      i := TicketTypesList.IndexOfName(IntToStr(i_Tarifpl_Kod));
      if i > -1 then
      begin
        s := TicketTypesList.Values[IntToStr(i_Tarifpl_Kod)];
        if length(s) > SizeOf(TTicketType) then
        begin
          p_TicketType := @s[1];
          if p_TicketType.tt_Tarifpl_SHOW then
          begin
            c_Tarifpl_BGCOLOR := p_TicketType.tt_Tarifpl_BGCOLOR;
            c_Tarifpl_FNTCOLOR := p_TicketType.tt_Tarifpl_FNTCOLOR;
          end
          else
            DEBUGMess(0, '[' + ProcName + ']: tt_Tarifpl_SHOW = false.');
        end
        else
          DEBUGMess(0, '[' + ProcName + ']: Error - length(s) = (' + IntToStr(length(s)) + ') > SizeOf(TTicketType) = (' + IntToStr(SizeOf(TTicketType)) + ').');
      end
      else
        DEBUGMess(0, '[' + ProcName + ']: Error - not found Kod = (' + IntToStr(i_Tarifpl_Kod) + ').');
    end
    else
      DEBUGMess(0, '[' + ProcName + ']: TicketTypesList is empty.');
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: TicketTypesList is not assigned.');
{$IFDEF uAddon_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Add_Tarifpl_Desc
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: i_Tarifpl_Kod: integer; str_Tarifpl_Nam: string; b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: Boolean; i_Tarifpl_TYPE: Integer; c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor; i_Tarifpl_TAG: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Add_Tarifpl_Desc(i_Tarifpl_Kod: integer; str_Tarifpl_Nam: string;
  b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: Boolean;
  i_Tarifpl_TYPE: Integer; c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor; i_Tarifpl_TAG: Integer);
const
  ProcName: string = 'Add_Tarifpl_Desc';
var
  tmp, fav: TMenuItem;
  bm: TBitmap;
  index: integer;
  tnt: TListItem;

//  str_Tarf,
  s: string;
  p: ^TTicketType;
begin
  // --------------------------------------------------------------------------
  // Добавление типа билета в интерфейс
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  DEBUGMess(0, '[' + ProcName + ']: Tarifpl_Kod = (' + IntToStr(i_Tarifpl_Kod) + ')');
  with fmMain do
  try
  // --------------------------------------------------------------------------
  // Заполнение списка всех типов билетов
  // --------------------------------------------------------------------------
    if Assigned(TicketTypesList) then
    try
      SetLength(s, SizeOf(TTicketType));
      p := @s[1];
      if Assigned(p) then
      begin
        p.tt_Tarifpl_Kod := i_Tarifpl_Kod;
        if Length(str_Tarifpl_Nam) <= 40 then
          p.tt_Tarifpl_Nam := str_Tarifpl_Nam
        else
          p.tt_Tarifpl_Nam := Copy(str_Tarifpl_Nam, 1, 40);
        p.tt_Tarifpl_PRINT := b_Tarifpl_PRINT;
        p.tt_Tarifpl_REPORT := b_Tarifpl_REPORT;
        p.tt_Tarifpl_FREE := b_Tarifpl_FREE;
        p.tt_Tarifpl_SHOW := b_Tarifpl_SHOW;
        p.tt_Tarifpl_SYS := b_Tarifpl_SYS;
        p.tt_Tarifpl_TYPE := i_Tarifpl_TYPE;
        p.tt_Tarifpl_BGCOLOR := TColor(c_Tarifpl_BGCOLOR);
        p.tt_Tarifpl_FNTCOLOR := TColor(c_Tarifpl_FNTCOLOR);
        p.tt_Tarifpl_TAG := i_Tarifpl_TAG;
        TicketTypesList.Add(IntToStr(i_Tarifpl_Kod) + '=' + s + ';' + str_Tarifpl_Nam);
      end;
    except
      DEBUGMess(0, '[' + ProcName + ']: Error - Adding item to TicketTypesList.');
    end;
  // --------------------------------------------------------------------------
    if b_Tarifpl_SYS then
    begin
      TicketTypesSysSet := TicketTypesSysSet + [Byte(i_Tarifpl_Kod)];
      if (i_Tarifpl_TYPE = 2) and (Byte(i_Tarifpl_Kod) = i_Tarifpl_Kod) then
        TicketTypesReservedSet := TicketTypesReservedSet + [Byte(i_Tarifpl_Kod)];
    end;
  // --------------------------------------------------------------------------
  // Отсев непригодных типов
  // --------------------------------------------------------------------------
    if (i_Tarifpl_TYPE in [0..4]) and (i_Tarifpl_TAG in [0..3]) then
    begin
  // --------------------------------------------------------------------------
  // Создание картинки
  // --------------------------------------------------------------------------
      bm := TBitmap.Create;
      with bm do
      try
        Width := imlSell.Width;
        Height := imlSell.Height;
        Canvas.Pen.Style := psSolid;
        Transparent := True;
        TransparentMode := tmFixed;
        TransparentColor := clBtnFace;
        Canvas.Brush.Color := TransparentColor;
        Canvas.Pen.Color := TransparentColor;
        Canvas.Rectangle(0, 0, Width, Height);
        Canvas.Pen.Color := clBlack;
        Canvas.Brush.Color := TColor(c_Tarifpl_BGColor);
        Canvas.Rectangle(0, 2, Width, Height - 2);
        Canvas.Pen.Color := TColor(c_Tarifpl_FNTCOLOR);
        Canvas.Brush.Style := bsClear;
        // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
        //Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
        Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2, Width - 2, Height - 4);
        index := imlSell.Add(bm, nil);
      finally
      end;
      if b_Tarifpl_SHOW then
      begin
  // --------------------------------------------------------------------------
  // Создание меню
  // --------------------------------------------------------------------------
        tmp := nil;
        // str_Tarf := FormatTextToMax(str_Tarifpl_Nam, 40, Space, True);
        case i_Tarifpl_TAG of
        0, 1:
          if b_Tarifpl_Free then
          begin
            tmp := TMenuItem.Create(ppmForFree); // submenu for free types
            tmp.Caption := FixFmt(i_Tarifpl_Kod, 2, ' ') + ' - "' + str_Tarifpl_Nam + '"';
          end
          else
          begin
            tmp := TMenuItem.Create(ppmForMoney); // submenu for other types
//            tmp.Caption := FixFmt(i_Tarifpl_Kod, 2, ' ') + ' - "' + str_Tarf + '"';
            tmp.Caption := FixFmt(i_Tarifpl_Kod, 2, ' ') + ' - "' + str_Tarifpl_Nam + '"';
            tmp.Caption := tmp.Caption + Menu_In_Str;
            // tmp.Caption := tmp.Caption + ' = ' + IntToStr(i_Tarifz_Cost) + ' тенге';
          end;
        2:
        begin
          tmp := TMenuItem.Create(popTicket); // upper level
          tmp.Caption := FixFmt(i_Tarifpl_Kod, 2, ' ') + ' - "' + str_Tarifpl_Nam + '"';
        end;
        else
        end;
        if Assigned(tmp) then
          Max_MenuText_Width := Max(Max_MenuText_Width, Get_Caption_Length(tmp.Caption, XPMenu1.Font));
  // --------------------------------------------------------------------------
  // Первые три типа попадают в верхний уровень
  // --------------------------------------------------------------------------
        fav := nil;
        if Assigned(tmp) and (i_Tarifpl_TAG in [0..2]) then
        begin
          tmp.ImageIndex := index;
          tmp.Tag := i_Tarifpl_Kod;
          tmp.GroupIndex := i_Tarifpl_Type;
          tmp.OnClick := TicketRightClick;
          case i_Tarifpl_Kod of
            1: fav := ppmMostUsed1;
            2: fav := ppmMostUsed2;
            3: fav := ppmMostUsed3;
          else
            fav := nil;
          end;
        end;
        if Assigned(fav) then
        begin
          fav.Caption := tmp.Caption;
          fav.ImageIndex := tmp.ImageIndex;
          fav.Tag := tmp.Tag;
          fav.OnClick := tmp.OnClick;
        end
        else
          case i_Tarifpl_TAG of
          0, 1:
            if b_Tarifpl_Free then
              ppmForFree.Add(tmp)
            else
              ppmForMoney.Add(tmp);
          2:
            popTicket.Items.Insert(popTicket.Items.IndexOf(ppmLine5), tmp)
          else
          end;
  // --------------------------------------------------------------------------
  // Полный список в главном меню
  // --------------------------------------------------------------------------
        fav := TMenuItem.Create(miCurTarifz);
        fav.Caption := tmp.Caption;
        fav.ImageIndex := tmp.ImageIndex;
        fav.Tag := tmp.Tag;
        fav.OnClick := tmp.OnClick;
        miCurTarifz.Add(fav);
        DEBUGMess(0, '[' + ProcName + ']: str_Tarifpl_Nam = (' + str_Tarifpl_Nam + ')');
      end; // if b_Tarifpl_SHOW then
  // --------------------------------------------------------------------------
  //  Заполнение строк информационного списка
  // --------------------------------------------------------------------------
      if Assigned(fmInfo) then
      with fmInfo do
      begin
        try
          DEBUGMess(0, '[' + ProcName + ']: Add to fmInfo.lvTarifz.Items');
          tnt := lvTarifz.Items.Add;
          tnt.Caption := str_Tarifpl_Nam;
          tnt.Data := Pointer(i_Tarifpl_Kod);
          tnt.ImageIndex := index;
          case i_Tarifpl_TAG of
          0, 1:
          begin
            if b_Tarifpl_Free then
            begin
              // tnt.SubItems.Add('Без оплаты')
              tnt.SubItems.Add('---');
              tnt.SubItems.Add('');
              tnt.SubItems.Add('---');
            end
            else
            begin
              tnt.SubItems.Add('0');
              tnt.SubItems.Add('');
              tnt.SubItems.Add('');
            end;
            if b_Tarifpl_Print then
              tnt.SubItems.Add('')
            else
              tnt.SubItems.Add('Нет');
            end;
          else
            tnt.SubItems.Add('---');
            tnt.SubItems.Add('');
            tnt.SubItems.Add('---');
            tnt.SubItems.Add('---');
          end;
        except
        end;
      end;
  // --------------------------------------------------------------------------
    end; // if (i_Tarifpl_TYPE in [0..4]) and (i_Tarifpl_TAG in [0..3]) then
  // --------------------------------------------------------------------------
  except
  end; // try
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_Tarifpl_Desc
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: DataSet: TDataSet; Tarifpl_Kod: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Load_Tarifpl_Desc(DataSet: TDataSet; Tarifpl_Kod: integer);
const
  ProcName: string = 'Load_Tarifpl_Desc';
begin
  // --------------------------------------------------------------------------
  // Загрузка типа билета из запроса
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(Dataset) and Dataset.Active then
  begin
    with Dataset do
    if FieldByName(s_Tarifpl_Kod).AsInteger = Tarifpl_Kod then
    begin
      Add_Tarifpl_Desc(FieldByName(s_Tarifpl_Kod).AsInteger, FieldByName(s_Tarifpl_Nam).AsString,
        FieldByName(s_Tarifpl_PRINT).AsBoolean, FieldByName(s_Tarifpl_REPORT).AsBoolean,
        FieldByName(s_Tarifpl_FREE).AsBoolean, FieldByName(s_Tarifpl_SHOW).AsBoolean,
        FieldByName(s_Tarifpl_SYS).AsBoolean, FieldByName(s_Tarifpl_TYPE).AsInteger,  
        FieldByName(s_Tarifpl_BGCOLOR).AsInteger, FieldByName(s_Tarifpl_FNTCOLOR).AsInteger,
        FieldByName(s_Tarifpl_TAG).AsInteger);
    end
    else
      DEBUGMess(0, '[' + ProcName + ']: Dataset is not positioned.');
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Dataset is null or not opened.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Clear_User_Interface
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure Clear_User_Interface;
const
  ProcName: string = 'Clear_User_Interface';
var
  i, i_stop: integer;
begin
  // --------------------------------------------------------------------------
  // Очистка интерфейса (меню и списка картинок)
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  with fmMain do
  begin
    imlSell.Clear;
    ppmForFree.Clear;
    ppmForMoney.Clear;
    miCurTarifz.Clear;
    with popTicket do
    begin
      i := Items.IndexOf(ppmLine4);
      i_stop := Items.IndexOf(ppmLine5);
      while (i <> i_stop) and (i < Items.Count) do
      begin
        if Items[i].Tag > 0 then
        begin
          DEBUGMess(0, '[' + ProcName + ']: Deleted menuitem - (' + Items[i].Caption + ')');
          Items.Delete(i);
        end
        else
          inc(i);
      end;
    end;
    ppmMostUsed1.Caption := '-';
    ppmMostUsed2.Caption := '-';
    ppmMostUsed3.Caption := '-';
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_User_Interface_Info
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure Load_User_Interface_Info;
const
  ProcName: string = 'Load_User_Interface_Info';
var
  index: integer;
  bm: TBitmap;
  tnt: TListItem;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  with dm, fmMain do
  begin
    bm := TBitmap.Create;
    with bm do
    try
      Width := imlSell.Width;
      Height := imlSell.Height;
      Canvas.Pen.Style := psSolid;
      Transparent := True;
      TransparentMode := tmFixed;
      TransparentColor := clBtnFace;
      Canvas.Brush.Color := TransparentColor;
      Canvas.Pen.Color := TransparentColor;
      Canvas.Rectangle(0, 0, Width, Height);
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := ssSelect.SelectedBrush.Color;
      Canvas.Rectangle(0, 2, Width, Height - 2);
      Canvas.Pen.Color := ssSelect.SelectedFont.Color;
      Canvas.Brush.Style := bsClear;
      // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
      //Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
      Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2, Width - 2, Height - 4);
      index := imlSell.Add(bm, nil);
    finally
    end;
    if Assigned(fmInfo) then
      with fmInfo do
      begin
        Caption := 'Инфо';
        lvTarifz.Items.Clear;
        try
          tnt := lvTarifz.Items.Add;
          tnt.Caption := 'Итого на продажу';
          tnt.Data := Pointer(Max1_Place_Type);
          tnt.ImageIndex := -1;
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('')
        except
        end;
        try
          tnt := lvTarifz.Items.Add;
          tnt.Caption := 'Помеченные места';
          tnt.Data := Pointer(Max2_Place_Type);
          tnt.ImageIndex := index;
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('')
        except
        end;
        try
          tnt := lvTarifz.Items.Add;
          tnt.Caption := StringOfChar('-', 40);
          tnt.Data := Pointer(Max3_Place_Type);
          tnt.ImageIndex := -1;
          tnt.SubItems.Add('---');
          tnt.SubItems.Add('---');
          tnt.SubItems.Add('---');
          tnt.SubItems.Add('---');
        except
        end;
      end;
    end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_All_Ticket_Types
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    integer
-----------------------------------------------------------------------------}
function Load_All_Ticket_Types: integer;
const
  ProcName: string = 'Load_All_Ticket_Types';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  tnt: TListItem;
begin
  // --------------------------------------------------------------------------
  // 2.2) Загрузка всех типов билетов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('*', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  with dm, dm.qTarifpl do
  if db.Connected then
  begin
    Clear_User_Interface;
    Load_User_Interface_Info;
    Max_MenuText_Width := -1;
    if not Assigned(TicketTypesList) then
      try
        TicketTypesList := TStringList.Create;
      except
        TicketTypesList := nil;
      end;
    if Assigned(TicketTypesList) then
      TicketTypesList.Clear
    else
      DEBUGMess(0, '[' + ProcName + ']: Error - TicketTypesList is null');
    TicketTypesSysSet := [];
    TicketTypesReservedSet := [];
    Result := PrepareQuery_Tarifpl_SQL(1, 0, false, nil);
{}
    Close;
    UniDirectional := true;
    Open;
{}
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
    Combo_Load_Tarifpl_Desc(qTarifpl, nil);
{}
    Close;
    UniDirectional := false;
    if Assigned(fmInfo) then
      with fmInfo do
      begin
        try
          tnt := lvTarifz.Items.Add;
          tnt.Caption := StringOfChar('-', 40);
          tnt.Data := Pointer(Max3_Place_Type);
          tnt.ImageIndex := -1;
          tnt.SubItems.Add('---');
          tnt.SubItems.Add('---');
          tnt.SubItems.Add('---');
          tnt.SubItems.Add('---');
        except
        end;
        try
          tnt := lvTarifz.Items.Add;
          tnt.Caption := 'Итого по постерминалу';
          tnt.Data := Pointer(Max4_Place_Type);
          tnt.ImageIndex := -1;
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('')
        except
        end;
        try
          tnt := lvTarifz.Items.Add;
          tnt.Caption := 'Итого по всем';
          tnt.Data := Pointer(Max5_Place_Type);
          tnt.ImageIndex := -1;
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('');
          tnt.SubItems.Add('')
        except
        end;
      end;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('*', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: Get_Tarifet_Desc
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: i_Tarifet, i_Tarifpl: Integer; var i_Cost: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Get_Tarifet_Desc(i_Tarifet, i_Tarifpl: Integer; var i_Cost: Integer): Integer;
const
  ProcName: string = 'Get_Tarifet_Desc';
var
  s: string;
  Index: Integer;
begin
  // --------------------------------------------------------------------------
  // Загрузка тарифа из запроса
  // --------------------------------------------------------------------------
{$IFDEF _t_uAddon_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  Result := -1;
  if Assigned(TicketPriceList) then
  begin
    Result := 0;
    if TicketPriceList.Count > 0 then
    begin
      Result := 1;
      s := '_' + IntToStr(i_Tarifet) + '_' + IntToStr(i_Tarifpl);
      Index := TicketPriceList.IndexOfName(s);
      i_Cost := 0;
      if Index > -1 then
        try
          i_Cost := StrToInt(TicketPriceList.Values[s]);
          Result := 2;
{$IFDEF _t_uAddon_DEBUG}
          DEBUGMess(0, '[' + ProcName + ']: i_Cost = (' + TicketPriceList.Values[s] + ')');
{$ENDIF}
        except
          i_Cost := 0;
        end
      else
{$IFDEF _t_uAddon_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Cost for s = (' + s + ') not found.');
{$ENDIF}
        {};
    end;
  end;
{$IFDEF _t_uAddon_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Load_Tarifet_Desc
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: DataSet: TDataSet; Tarifet_Kod, Tarifpl_Kod, i_Cost: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Load_Tarifet_Desc(DataSet: TDataSet; Tarifet_Kod, Tarifpl_Kod, i_Cost: integer);
const
  ProcName: string = 'Load_Tarifet_Desc';
var
  s: string;
begin
  // --------------------------------------------------------------------------
  // Загрузка тарифа из запроса
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  // DEBUGMess(0, '[' + ProcName + ']: Create_Tarif(' + FixFmt(Tarifet_Kod, 3, '0') + ') - Begin');
  if Assigned(TicketPriceList) then
  try
    s := '_' + IntToStr(Tarifet_Kod) + '_' + IntToStr(Tarifpl_Kod) + '=' + IntToStr(i_Cost);
    TicketPriceList.Add(s);
    DEBUGMess(0, '[' + ProcName + ']: Add("' + s + '")');
  except
    DEBUGMess(0, '[' + ProcName + ']: Error - Adding item to TicketPriceList.');
  end;
  // DEBUGMess(0, '[' + ProcName + ']: Create_Tarif(' + FixFmt(Tarifet_Kod, 3, '0') + ') - End');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_All_Tarifs
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    integer
-----------------------------------------------------------------------------}
function Load_All_Tarifs: integer;
const
  ProcName: string = 'Load_All_Tarifs';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('*', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  with dm, dm.qTarifz do
  if db.Connected then
  begin
    if not Assigned(TicketPriceList) then
      try
        TicketPriceList := TStringList.Create;
      except
        TicketPriceList := nil;
      end;
    if Assigned(TicketPriceList) then
      TicketPriceList.Clear
    else
      DEBUGMess(0, '[' + ProcName + ']: Error - TicketPriceList is null');
    Result := PrepareQuery_Tarifz_SQL(4, 0, 0, nil);
{}
    Close;
    UniDirectional := true;
    Open;
{}
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
    Combo_Load_Tarifz_Desc(qTarifz, nil);
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('*', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{
function Init_Cur_Film: integer;
const
  ProcName: string = 'Init_Cur_Film';
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := 1;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;
}

{-----------------------------------------------------------------------------
  Procedure: Refresh_Date
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: NewDate: TDateTime
  Result:    None
-----------------------------------------------------------------------------}
procedure Refresh_Date(NewDate: TDateTime);
const
  ProcName: string = 'Refresh_Date';
begin
  // --------------------------------------------------------------------------
  // Смена даты
  // --------------------------------------------------------------------------
  // Integer(cmZal.Items.Objects[cmZal.ItemIndex])
  DEBUGMess(0, CRLF + StringOfChar('~', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if (Cur_Date <> NewDate) or (NewDate = 0) then
  begin
    if NewDate <> 0 then
      Cur_Date := NewDate;
    if Init_Cur_Repert > 0 then;
    begin
//      fmMain.cmZal.OnChange(nil);
      fmMain.tbcFilm.OnChange(nil);
    end;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('~', LogSeparatorWidth));
  // --------------------------------------------------------------------------
end;

{-----------------------------------------------------------------------------
  Procedure: Refresh_Zal
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: NewZal: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Refresh_Zal(NewZal: integer);
const
  ProcName: string = 'Refresh_Zal';
var
  i, tmp_Zal_Kod: integer;
{  tmp_Zal_Plan: TStrings;}
{  Gauge: TGauge;}
  str_Panel_Name1{, str_Panel_Name2}: string;
  tmp_Zal_Panel1{, tmp_Zal_Panel2}: TPanel;
  Source: TComponent;
  str_Print_Serial: string;
  str_Serial: string;
begin
  // --------------------------------------------------------------------------
  // Смена зала
  // --------------------------------------------------------------------------
  DEBUGMess(0, CRLF + StringOfChar('~', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  with fmMain.cmZal do
  begin
    if (NewZal = -2) and (ItemIndex > -1) then
    begin
      tmp_Zal_Kod := integer(Items.Objects[ItemIndex]);
    end
    else
    begin
      tmp_Zal_Kod := NewZal;
    end;
    if tmp_Zal_Kod > -1 then
      i := Items.IndexOfObject(TObject(tmp_Zal_Kod))
    else
      i := -1;
  end;
  if (Cur_Zal_Kod <> tmp_Zal_Kod) and (i > -1) then
  begin
    with fmMain do
    begin
      cmZal.Enabled := false;
      DEBUGMess(0, '[' + ProcName + ']: cmZal.Enabled = false');
{      Gauge := ggProgress;
      if Assigned(fmSplash) then
        try
          if fmSplash.Visible then
            Gauge := fmSplash.ggSplash;
        except
        end;}
      i := ZalList.IndexOf(IntToStr(tmp_Zal_Kod));
      if i = -1 then
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса
  // --------------------------------------------------------------------------
        Load_Zal_Map(tmp_Zal_Kod);
  // --------------------------------------------------------------------------
      Emblema_Loaded := 0;
      i := ZalList.IndexOf(IntToStr(tmp_Zal_Kod));
      if i > -1 then
      begin
        str_Panel_Name1 := 'pnZal_' + IntToStr(tmp_Zal_Kod);
        Source := pnZal_Container.FindComponent(str_Panel_Name1);
        if (Source is TPanel) then
          tmp_Zal_Panel1 := (Source as TPanel)
        else
          tmp_Zal_Panel1 := nil;
        if (not Assigned(tmp_Zal_Panel1)) or (tmp_Zal_Panel1.Tag <> tmp_Zal_Kod) then
        begin
          DEBUGMess(0, '[' + ProcName + ']: Error - "' + str_Panel_Name1 + '" not found or invalid.');
        end
        else
        begin
          if Check_Cntr then
          begin
            DEBUGMess(0, '[' + ProcName + ']: Cur_Panel_Cntr is "' + Cur_Panel_Cntr.Name + '".');
            DEBUGMess(0, '[' + ProcName + ']: Before - Cur_Panel_Cntr.Owner is "' + Cur_Panel_Cntr.Owner.Name + '".');
            DEBUGMess(0, '[' + ProcName + ']: Before - Cur_Panel_Cntr.Parent is "' + Cur_Panel_Cntr.Parent.Name + '".');
            Cur_Panel_Cntr.Owner.RemoveComponent(Cur_Panel_Cntr);
            pnZal_Container.InsertComponent(Cur_Panel_Cntr);
            Cur_Panel_Cntr.Parent := pnZal_Container;
            DEBUGMess(0, '[' + ProcName + ']: After - Cur_Panel_Cntr.Owner is "' + Cur_Panel_Cntr.Owner.Name + '".');
            DEBUGMess(0, '[' + ProcName + ']: After - Cur_Panel_Cntr.Parent is "' + Cur_Panel_Cntr.Parent.Name + '".');
         end;
          Cur_Panel_Cntr := tmp_Zal_Panel1;
          DEBUGMess(0, '[' + ProcName + ']: Cur_Panel_Cntr is "' + Cur_Panel_Cntr.Name + '".');
          DEBUGMess(0, '[' + ProcName + ']: Before - Cur_Panel_Cntr.Owner is "' + Cur_Panel_Cntr.Owner.Name + '".');
          DEBUGMess(0, '[' + ProcName + ']: Before - Cur_Panel_Cntr.Parent is "' + Cur_Panel_Cntr.Parent.Name + '".');
          Cur_Panel_Cntr.Owner.RemoveComponent(Cur_Panel_Cntr);
          sbMain.InsertComponent(Cur_Panel_Cntr);
          Cur_Panel_Cntr.Parent := sbx_Cntr;
          DEBUGMess(0, '[' + ProcName + ']: After - Cur_Panel_Cntr.Owner is "' + Cur_Panel_Cntr.Owner.Name + '".');
          DEBUGMess(0, '[' + ProcName + ']: After - Cur_Panel_Cntr.Parent is "' + Cur_Panel_Cntr.Parent.Name + '".');
        end;
      end;
      Cur_Zal_Kod := tmp_Zal_Kod;
  // --------------------------------------------------------------------------
      _Print_Serial := false;
      str_Print_Serial := 'FaLSe';
      str_Serial := 'unknown';
      _Serial := 99000;
      if GetOption(s_Print_Serial + IntToStr(Cur_Zal_Kod), str_Print_Serial) > 0 then
      begin
        str_Print_Serial := LowerCase(str_Print_Serial);
        if (str_Print_Serial = 'yes') or (str_Print_Serial = 'true') then
        begin
          _Print_Serial := true;
          _Serial := 0;
          if GetOption(s_Serial_Num + IntToStr(Cur_Zal_Kod), str_Serial) > 0 then
          begin
            try
              _Serial := StrToInt(str_Serial);
            except
              _Print_Serial := false;
              _Serial := 98000;
            end;
          end
          else
            _Serial := 0;
        end;
      end;
      SaveOption(s_Print_Serial + IntToStr(Cur_Zal_Kod), FALSE_OR_TRUE[_Print_Serial], true);
      DEBUGMess(0, '[' + ProcName + ']: str_Print_Serial = ' + str_Print_Serial);
      DEBUGMess(0, '[' + ProcName + ']: _Print_Serial = ' + FALSE_OR_TRUE[_Print_Serial]);
      DEBUGMess(0, '[' + ProcName + ']: str_Serial = ' + str_Serial);
      DEBUGMess(0, '[' + ProcName + ']: _Serial = ' + IntToStr(_Serial));
  // --------------------------------------------------------------------------
      ScrollMove(50, 50);
      if Init_Cur_Repert > 0 then;
      begin
        fmMain.tbcFilm.OnChange(nil);
      end;
{      if Assigned(fmMinimap) then
        fmMinimap.OnActivate(nil);}
      cmZal.Enabled := true;
      DEBUGMess(0, '[' + ProcName + ']: -> cmZal.Enabled = true');
    end;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('~', LogSeparatorWidth));
  // --------------------------------------------------------------------------
end;

{-----------------------------------------------------------------------------
  Procedure: Refresh_Film
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: NewFilm: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Refresh_Film(NewFilm: integer);
const
  ProcName: string = 'Refresh_Film';
begin
  // --------------------------------------------------------------------------
  // Смена зала
  // --------------------------------------------------------------------------
  DEBUGMess(0, CRLF + StringOfChar('~', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Cur_Repert_Kod := NewFilm;
  Load_Tarifet(NewFilm);
  Load_All_TC(NewFilm);
  Refresh_TC_Count(nil);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('~', LogSeparatorWidth));
  // --------------------------------------------------------------------------
end;

{-----------------------------------------------------------------------------
  Procedure: Check_Cntr
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    boolean
-----------------------------------------------------------------------------}
function Check_Cntr: boolean; // ready
begin
  Result := false;
  if Assigned(Cur_Panel_Cntr) then
    if length(Cur_Panel_Cntr.Name) > 6 then
      if copy(Cur_Panel_Cntr.Name, 1, 6) = 'pnZal_' then
        Result := true;
end;

{-----------------------------------------------------------------------------
  Procedure: Modify_Tarifpl_Desc
  Author:    n0mad
  Date:      23-окт-2002
  Arguments: _Tarifet: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Modify_Tarifpl_Desc(_Tarifet: integer); // ready partially
const
  ProcName: string = 'Modify_Tarifpl_Desc';
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure Modify_Menu(i_Taripl: Integer; var Caption: string);
var
  i1, p1, i_Cost: Integer;
  s1, s2: string;
begin
  p1 := Pos(Menu_In_Str, Caption);
  if (i_Taripl > 0) and (p1 > 0) then
  begin
    s2 := '';
    if (Get_Tarifet_Desc(_Tarifet, i_Taripl, i_Cost) > 0) then
      if (i_Cost > 0) then
        s2 := Format('%8u', [i_Cost]) + Space + s_Valuta
      else
        s2 := '0';
    s1 := Copy(Caption, 1, p1 + Length(Menu_In_Str) - 1);
    i1 := -1;
    if (Max_MenuText_Width > 0) and Assigned(fmMain) then
      i1 := Get_Caption_Addon(s1, Max_MenuText_Width, fmMain.XPMenu1.Font);
    if i1 < 0 then
      i1 := 2; 
    Caption := s1 + StringOfChar(Space, i1 + 1) + s2;
    DEBUGMess(0, '[' + ProcName + ']: Cap[' + IntToStr(i_Taripl) + '] = ' + Caption + '.');
  end; // if
end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var
  i : Integer;
  s: string;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if Assigned(fmMain) then
    with fmMain do
    begin
      with popTicket do
       for i := 0 to Items.Count - 1 do
       begin
         s := Items[i].Caption;
         Modify_Menu(Items[i].Tag, s);
         Items[i].Caption := s;
       end;
      with ppmForMoney do
       for i := 0 to Count - 1 do
       begin
         s := Items[i].Caption;
         Modify_Menu(Items[i].Tag, s);
         Items[i].Caption := s;
       end;
      with miCurTarifz do
       for i := 0 to Count - 1 do
       begin
         s := Items[i].Caption;
         Modify_Menu(Items[i].Tag, s);
         Items[i].Caption := s;
       end;
    end; // with
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Load_Tarifet
  Author:    n0mad
  Date:      23-окт-2002
  Arguments: i_Repert_Kod: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Load_Tarifet(i_Repert_Kod: integer);
const
  ProcName: string = 'Load_Tarifet';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i_Tarifet: Integer;
begin
  Time_Start := Now;
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if Assigned(fmMain) then
  with dm, dm.qRepert do
  begin
    i_Tarifet := -1;
    if PrepareQuery_Repert_SQL(2, 0, 0, i_Repert_Kod) > 0 then
    begin
      UniDirectional := true;
      Open;
//
      DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
      with fmMain.stTarifet do
      if RecordCount > 0 then
      begin
        DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
        i_Tarifet := FieldByName(s_Repert_Tarifet).AsInteger;
        Caption := ' ' + FieldByName(s_Tarifet_Nam).AsString + ' ';
      end
      else
      begin
        Caption := StringOfChar(' ', 40);
      end;
{
        // ----------------
        // old variant
        // ----------------
        with fmMain.stTarifet, qTarifet do
        if PrepareQuery_Tarifet_SQL(1, i_Tarifet, nil) > 0 then
        begin
          UniDirectional := true;
          Open;
//
          DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
          if RecordCount > 0 then
            Caption := ' ' + FieldByName(s_Tarifet_Nam).AsString + ' '
          else
            Caption := StringOfChar(' ', 40);
//
          Close;
          UniDirectional := false;
        end;
        //
        if PrepareQuery_Tarifz_SQL(2, 0, i_Tarifet, nil) > 0 then
        // WHERE  Tarifz.TARIFZ_ET = 1
        begin
          qTarifz.UniDirectional := true;
          qTarifz.Open;
//
          DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
          while not qTarifz.Eof do
          begin
            with qTarifz do
              Modify_Tarifpl_Desc(FieldByName(s_Tarifz_PL).AsInteger, FieldByName(s_Tarifz_COST).AsInteger);
            qTarifz.Next;
          end;
//
          qTarifz.Close;
          qTarifz.UniDirectional := false;
        end;
        //
        if PrepareQuery_Tarifpl_SQL(3, -1, true, nil) > 0 then
        // All records
        try
          qTarifpl.UniDirectional := true;
          qTarifpl.Open;
          //
          DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
          while not qTarifpl.Eof do
          begin
            with qTarifpl do
              Modify_Tarifpl_Desc(FieldByName(s_Tarifpl_Kod).AsInteger, 0);
            qTarifpl.Next;
          end;
          //
        finally
          qTarifpl.Close;
          qTarifpl.UniDirectional := false;
        end;
}
//
      Close;
      UniDirectional := false;
      if i_Tarifet > -1 then
      begin
        // ----------------
        // new variant
        // ----------------
        Modify_Tarifpl_Desc(i_Tarifet);
      end;
    end
    else
      DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
    Cur_Tarifet := i_Tarifet;
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: Refresh_TC_Hint
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: ssT :TTicketControl
  Result:    None
-----------------------------------------------------------------------------}
procedure Refresh_TC_Hint(ssT :TTicketControl); // ready partially
const
  ProcName: string = 'Refresh_TC_Hint';
begin
  // --------------------------------------------------------------------------
  // Обновление подсказки 
  // --------------------------------------------------------------------------
//  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(ssT) then
    with ssT do
    begin
//      Get_Re
      Hint :=
{$IFDEF t_uAddon_DEBUG}
        'Left = ' + IntToStr(Left) + CRLF +
        'Top = ' + IntToStr(Top) + CRLF +
        CRLF +
{$ENDIF}
        'Выделено = ' + Boolean_Array[Selected] + CRLF +
        'Состояние = ' + SpShSt_Array[TC_State] + CRLF +
        CRLF +
        'Код = ' + IntToStr(Ticket_Kod) + CRLF +
        'РядМесто = ' + IntToStr(Row) + ',' + IntToStr(Column) + CRLF +
        'Тип билета = ' + IntToStr(Ticket_Tarifpl) + CRLF +
        'Фильм = ' + IntToStr(Ticket_Repert) + ' - ' + fmMain.lbFilmInfo.Caption + CRLF +
        'Время = ' + DateTimeToStr(Ticket_DateTime) + CRLF +
        CRLF +
        'Тип сл.= ' + IntToStr(Ticket_Type) + CRLF;
    end;
//  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

procedure Refresh_TC_Count(ssT :TTicketControl);
const
  ProcName: string = 'Refresh_TC_Count';
var
  i, k: Integer;
  Count_All, Count_Sel, Count_Net_All, Count_Net_Sel, Count_Free, Count_Broken,
    Total_SumF, Total_SumP, Total_SumQ: Integer;
  ssTmp: TTicketControl;
  arItem: TTicketSummary;
  arCount: array of TTicketSummary;
  s: string;
  p_TicketType: ^TTicketType;
  Calced: Boolean;
  i_lvTarifz, i_Kod_Pl: integer;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Calced := False;
//  if Assigned(fmMain) and Assigned(TicketTypesList) and fmMain.tbcFilm.Visible and Check_Cntr then
  Count_All := 0;
  Count_Sel := 0;
  Count_Net_All := 0;
  Count_Net_Sel := 0;
  Count_Free := 0;
  Count_Broken := 0;
  Total_SumF := 0;
  Total_SumP := 0;
  Total_SumQ := 0;
  if Assigned(fmMain) and Assigned(TicketTypesList) then
  begin
    SetLength(arCount, TicketTypesList.Count + 2);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    with arItem do
    begin
      Place_Kod_Pl := Max1_Place_Type;
      Place_Is_Free := False;
      Place_Cost := 0;
      Place_Type := 1;
      Place_Reserved := 0;
      Place_Prepared := 0;
      Place_Fixed := 0;
      Place_FixedNoCash := 0;
      Place_FixedCheq := 0;
      Place_Tag := 0;
      Place_Prepared_Sum := 0;
      Place_Fixed_Sum := 0;
      Place_FixedNoCash := 0;
      Place_FixedCheq_Sum := 0;
    end; // with
    arCount[0] := arItem;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    with arItem do
    begin
      Place_Kod_Pl := Max2_Place_Type;
      Place_Is_Free := False;
      Place_Cost := 0;
      Place_Type := 2;
      Place_Reserved := 0;
      Place_Prepared := 0;
      Place_Fixed := 0;
      Place_FixedNoCash := 0;
      Place_FixedCheq := 0;
      Place_Tag := 0;
      Place_Prepared_Sum := 0;
      Place_Fixed_Sum := 0;
      Place_FixedNoCash := 0;
      Place_FixedCheq_Sum := 0;
    end; // with
    arCount[1] := arItem;
    Calced := True;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if TicketTypesList.Count > 0 then
    begin
      for i := 0 to TicketTypesList.Count - 1 do
      begin
        // _index := TicketTypesList.IndexOfName(IntToStr(i_Tarifpl_Kod));
        s := TicketTypesList.Names[i];
        s := TicketTypesList.Values[s];
        if length(s) > SizeOf(TTicketType) then
        begin
          p_TicketType := @s[1];
          with arItem do
          begin
            Place_Kod_Pl := p_TicketType.tt_Tarifpl_Kod;
            Place_Is_Free := p_TicketType.tt_Tarifpl_FREE;
            if Place_Is_Free then
              Place_Cost := 0
            else
            begin
              if Get_Tarifet_Desc(Cur_Tarifet, p_TicketType.tt_Tarifpl_Kod, Place_Cost) < 1 then
                Place_Cost := 0;
            end;
            if (Place_Cost < 0) then
              Place_Cost := 0;
            Place_Type := p_TicketType.tt_Tarifpl_TYPE;
            Place_Reserved := 0;
            Place_Prepared := 0;
            Place_Fixed := 0;
            Place_FixedNoCash := 0;
            Place_FixedCheq := 0;
            Place_Tag := 0;
            Place_Prepared_Sum := 0;
            Place_Fixed_Sum := 0;
            Place_FixedNoCash := 0;
            Place_FixedCheq_Sum := 0;
          end; // with
          arCount[i + 1] := arItem;
        end // if
        else
          DEBUGMess(0, '[' + ProcName + ']: Error - length(s) = (' + IntToStr(length(s)) + ') > SizeOf(TTicketType) = (' + IntToStr(SizeOf(TTicketType)) + ').');
      end; // for i := 1 to TicketTypesList.Count do
    end; // if TicketTypesList.Count > 0 then 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if Check_Cntr and fmMain.tbcFilm.Visible then
    for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
    begin
      if (Cur_Panel_Cntr.Components[i] is TTicketControl) then
      begin
        ssTmp := (Cur_Panel_Cntr.Components[i] as TTicketControl);
        inc(Count_All);
        if (ssTmp.TC_State = scBroken) then
          inc(Count_Broken);
        if ssTmp.UsedByNet then
        begin
          inc(Count_Net_All);
          if ssTmp.Selected then
            inc(Count_Net_Sel);
        end // if
        else
        begin
          if ssTmp.Selected then
            inc(Count_Sel)
          else
            if (ssTmp.TC_State = scFree) then
              inc(Count_Free);
        end; // else end
        for k := Low(arCount) to High(arCount) do
        begin
          if ssTmp.Ticket_Tarifpl = arCount[k].Place_Kod_Pl then
          begin
            case ssTmp.TC_State of
            // scFree: ;
            // scBroken: ;
            scReserved:
            begin
              inc(arCount[k].Place_Reserved);
            end;
            scPrepared:
            begin
              inc(arCount[k].Place_Prepared);
              arCount[k].Place_Prepared_Sum := arCount[k].Place_Prepared_Sum + arCount[k].Place_Cost;
            end;
            scFixed:
            begin
              inc(arCount[k].Place_Fixed);
              arCount[k].Place_Fixed_Sum := arCount[k].Place_Fixed_Sum + arCount[k].Place_Cost;
              Total_SumF := Total_SumF + arCount[k].Place_Cost;
            end;
            scFixedNoCash:
            begin
              inc(arCount[k].Place_FixedNoCash);
              arCount[k].Place_FixedNoCash_Sum := arCount[k].Place_FixedNoCash_Sum + arCount[k].Place_Cost;
              Total_SumP := Total_SumP + arCount[k].Place_Cost;
            end;
            scFixedCheq:
            begin
              inc(arCount[k].Place_FixedCheq);
              arCount[k].Place_FixedCheq_Sum := arCount[k].Place_FixedCheq_Sum + arCount[k].Place_Cost;
              Total_SumQ := Total_SumQ + arCount[k].Place_Cost;
            end;
            else
            end;
          end; // if
        end; // for k := Low(arCount) to High(arCount) do
      end; // if
    end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
    for k := Low(arCount) to High(arCount) do
    begin
      if (arCount[k].Place_Kod_Pl <> Max1_Place_Type) and (arCount[k].Place_Kod_Pl > 0) then
      begin
        Inc(arCount[0].Place_Reserved, arCount[k].Place_Reserved);
        Inc(arCount[0].Place_Prepared, arCount[k].Place_Prepared);
        Inc(arCount[0].Place_Fixed, arCount[k].Place_Fixed);
        Inc(arCount[0].Place_FixedNoCash, arCount[k].Place_FixedNoCash);
        Inc(arCount[0].Place_FixedCheq, arCount[k].Place_FixedCheq);
        Inc(arCount[0].Place_Prepared_Sum, arCount[k].Place_Prepared_Sum);
        Inc(arCount[0].Place_Fixed_Sum, arCount[k].Place_Fixed_Sum);
        Inc(arCount[0].Place_FixedNoCash_Sum, arCount[k].Place_FixedNoCash_Sum);
        Inc(arCount[0].Place_FixedCheq_Sum, arCount[k].Place_FixedCheq_Sum);
      end; // if
    end; // for k := Low(arCount) to High(arCount) do
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  s := Format('Помеч. %u, своб. [%u] из %u. Сеть: %u из %u. Сломано = %u.', [Count_Sel, Count_Free, Count_All, Count_Net_Sel, Count_Net_All, Count_Broken]); 
  DEBUGMess(0, '[' + ProcName + ']: Length(' + IntToStr(length(s)) + ') = "' + s + '"');
  if Assigned(fmInfo) and Calced then
  begin
    fmMain.stInfo.Caption := Format('Помеч. %u из %u своб. На продажу %u билета(ов), %u тенге.', [Count_Sel, Count_Free, arCount[0].Place_Prepared, arCount[0].Place_Prepared_Sum]);
    fmInfo.Caption := Format('Помеч. %u из %u своб. Сеть: %u из %u.', [Count_Sel, Count_Free, Count_Net_Sel, Count_Net_All]);
    fmInfo.Hint := fmInfo.Caption;
    with fmInfo do 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for i := 0 to lvTarifz.Items.Count - 1 do
    begin
      i_lvTarifz := Integer(lvTarifz.Items[i].Data);
      for k := Low(arCount) to High(arCount) do
      begin
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        i_Kod_Pl := arCount[k].Place_Kod_Pl;
        if (i_lvTarifz = i_Kod_Pl) 
          or (i_lvTarifz = Max1_Place_Type) 
          or (i_lvTarifz = Max2_Place_Type) 
          or (i_lvTarifz = Max4_Place_Type) 
          or (i_lvTarifz = Max5_Place_Type) then
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          if lvTarifz.Items[i].SubItems.Count > 2 then
          begin
            if (i_lvTarifz = Max1_Place_Type) then
            begin
              // Итого на продажу
              lvTarifz.Items[i].SubItems[0] := '';
              lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[0].Place_Prepared);
              lvTarifz.Items[i].SubItems[2] := IntToStr(arCount[0].Place_Prepared_Sum);
            end
            else if (i_lvTarifz = Max2_Place_Type) then
            begin
              // Помеченные места
              lvTarifz.Items[i].SubItems[0] := '';
              lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[1].Place_Prepared);
              lvTarifz.Items[i].SubItems[2] := '-';
            end
            else if (i_lvTarifz = Max4_Place_Type) then
            begin
              // Итого по постерминалу
              lvTarifz.Items[i].SubItems[0] := '';
              lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[0].Place_FixedNoCash);
              lvTarifz.Items[i].SubItems[2] := IntToStr(Total_SumP);
            end
            else if (i_lvTarifz = Max5_Place_Type) then
            begin
              // Итого по всем
              lvTarifz.Items[i].SubItems[0] := '';
              lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[0].Place_Fixed);
              lvTarifz.Items[i].SubItems[2] := IntToStr(Total_SumF);
            end
            else
            begin
              // regular
              if (arCount[k].Place_Prepared > 0) or (arCount[k].Place_Fixed > 0) then
              begin
              // if arCount[k].Place_Cost > 0 then
                // lvTarifz.Items[i].SubItems[0] := IntToStr(arCount[k].Place_Cost);
                  if Show_All_Info then
                  begin
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[k].Place_Fixed);
                    // lvTarifz.Items[i].SubItems[2] := IntToStr(arCount[k].Place_Fixed_Sum);
                  end
                  else
                  begin
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[k].Place_Prepared);
                    // lvTarifz.Items[i].SubItems[2] := IntToStr(arCount[k].Place_Prepared_Sum);
                  end;
              end
              else
                if arCount[k].Place_Is_Free then
                  lvTarifz.Items[i].SubItems[0] := '---'
                else
                  lvTarifz.Items[i].SubItems[0] := IntToStr(arCount[k].Place_Cost);
                  // lvTarifz.Items[i].SubItems[0] := '0';
              if arCount[k].Place_Is_Free then
              begin
                // Бесплатный
                if (arCount[k].Place_Prepared > 0) or (arCount[k].Place_Fixed > 0) then
                begin
                  if Show_All_Info then
                  begin
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[k].Place_Fixed);
                  end
                  else
                  begin
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[k].Place_Prepared);
                  end;
                end // Бесплатный
                else // if (arCount[k].Place_Prepared > 0) or (arCount[k].Place_Fixed > 0) then
                begin
                  // Системный
                  case arCount[k].Place_Kod_Pl of
                  16:
                    lvTarifz.Items[i].SubItems[1] := IntToStr(Count_Free);
                  17:
                    lvTarifz.Items[i].SubItems[1] := IntToStr(Count_Broken);
                  18:
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[0].Place_Reserved);
                  19:
                  begin
                    lvTarifz.Items[i].SubItems[1] := '---';
                    lvTarifz.Items[i].SubItems[2] := '---';
                    lvTarifz.Items[i].SubItems[3] := '---';
                    case HSettting of
                    hsDisabled:
                    begin
                    end;
                    hsHybrid:
                      if _tne and (not _tnq) then
                      begin                        
                        sbarInfo.Panels[1].Text := IntToStr(arCount[0].Place_FixedCheq) + '%';
                        sbarInfo.Panels[2].Text := IntToStr(Total_SumQ) + ' lines';
                      end
                      else
                      begin                        
                        sbarInfo.Panels[1].Text := IntToStr(Random(Count_Free + arCount[0].Place_FixedCheq)) + '%';
                        sbarInfo.Panels[2].Text := IntToStr(Random(Count_Free + Total_SumQ)) + ' lines';
                      end;
                    else // case
                    end; // case
                  end;
                  else // case
                    lvTarifz.Items[i].SubItems[1] := '';
                  end; // case
                end; // if (arCount[k].Place_Prepared > 0) or (arCount[k].Place_Fixed > 0) then
              end // Системный
              else
              begin
                // Платный
                lvTarifz.Items[i].SubItems[0] := IntToStr(arCount[k].Place_Cost);
                if (arCount[k].Place_Prepared > 0) or (arCount[k].Place_Fixed > 0) then
                begin
                  if Show_All_Info then
                  begin
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[k].Place_Fixed);
                    lvTarifz.Items[i].SubItems[2] := IntToStr(arCount[k].Place_Fixed_Sum);
                  end
                  else
                  begin
                    lvTarifz.Items[i].SubItems[1] := IntToStr(arCount[k].Place_Prepared);
                    lvTarifz.Items[i].SubItems[2] := IntToStr(arCount[k].Place_Prepared_Sum);
                  end;
                end
                else
                begin
                  lvTarifz.Items[i].SubItems[1] := '';
                  lvTarifz.Items[i].SubItems[2] := '';
                end;
              end;
            end; // Платный
          end; // if lvTarifz.Items[i].SubItems.Count > 2 then
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      end; // for k := Low(arCount) to High(arCount) do
    end;
  end; // for i := 0 to Items.Count - 1 do
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Refresh_TC_State
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: ssT :TTicketControl; _Kod, _TARIFPL, _REPERT: Integer; _DATETIME: TDateTime; _STATE, _OWNER: Integer; _RESTORED: Boolean; _TAG: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Refresh_TC_State(ssT :TTicketControl; _Kod, _TARIFPL, _REPERT: Integer;
  _DATETIME: TDateTime; _STATE, _OWNER: Integer; _RESTORED: Boolean; _TAG: Integer);
const
  ProcName: string = 'Refresh_TC_State';
{
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
}
begin
  // --------------------------------------------------------------------------
  // Загрузка билета из запроса и обновление состояния
  // --------------------------------------------------------------------------
  {
  Time_Start := Now;
  }
{$IFDEF uAddon_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  with ssT do
  if Assigned(ssT) and (_Kod >= -2) then
  begin
    Ticket_Repert := _REPERT;
    Ticket_Type := _STATE;
    Ticket_Owner := _OWNER;
    case _Kod of
    -2:
    begin
      DEBUGMess(0, '[' + ProcName + ']: This place is broken.');
  // --------------------------------------------------------------------------
  // refreshing state
  // --------------------------------------------------------------------------
      TC_State := scBroken;
      //
      Ticket_Kod := _Kod;
  // --------------------------------------------------------------------------
  // refreshing colors
  // --------------------------------------------------------------------------
      // Ticket_Tarifpl := _TARIFPL;
  // --------------------------------------------------------------------------
      // Ticket_Repert := _REPERT;
      Ticket_DateTime := _DATETIME;
      // Ticket_Type := _STATE;
      // Ticket_Owner := _OWNER;
    end;
    -1:
    begin
      DEBUGMess(0, '[' + ProcName + ']: This place is prepared.');
  // --------------------------------------------------------------------------
  // refreshing state
  // --------------------------------------------------------------------------
      TC_State := scPrepared;
      //
      // Ticket_Kod := _Kod;
  // --------------------------------------------------------------------------
  // refreshing colors
  // --------------------------------------------------------------------------
      Ticket_Tarifpl := _TARIFPL;
  // --------------------------------------------------------------------------
      // Ticket_Repert := _REPERT;
      Ticket_DateTime := _DATETIME;
      // Ticket_Type := _STATE;
      // Ticket_Owner := _OWNER;
    end;
    0:
    begin
      // DEBUGMess(0, '[' + ProcName + ']: This place is free.');
  // --------------------------------------------------------------------------
  // refreshing state
  // --------------------------------------------------------------------------
      TC_State := scFree;
      //
      // Ticket_Kod := _Kod;
  // --------------------------------------------------------------------------
  // refreshing colors
  // --------------------------------------------------------------------------
      // Ticket_Tarifpl := _TARIFPL;
  // --------------------------------------------------------------------------
      // Ticket_Repert := _REPERT;
      Ticket_DateTime := _DATETIME;
      // Ticket_Type := _STATE;
      // Ticket_Owner := _OWNER;
    end;
    else
  // --------------------------------------------------------------------------
  // refreshing state
  // --------------------------------------------------------------------------
      case _STATE of
      0:
        TC_State := scReserved;
      1:
        TC_State := scFixed;
      2:
        TC_State := scFixedNoCash;
      3:
        TC_State := scFixedCheq;
      else
        TC_State := scFixed;
        DEBUGMess(0, '[' + ProcName + ']: Error - Ticket_Type = (' + IntToStr(Ticket_Type) + ')');
      end;
      //
      Ticket_Kod := _Kod;
  // --------------------------------------------------------------------------
  // refreshing colors
  // --------------------------------------------------------------------------
      Ticket_Tarifpl := _TARIFPL;
  // --------------------------------------------------------------------------
      Ticket_Repert := _REPERT;
      Ticket_DateTime := _DATETIME;
      Ticket_Type := _STATE;
      Ticket_Owner := _OWNER;
    end;
  // --------------------------------------------------------------------------
{$IFDEF uAddon_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SpShSt = (' + SpShSt_Array[TC_State] + ')');
{$ENDIF}
  end;
{$IFDEF uAddon_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  {
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
  }
end;

{-----------------------------------------------------------------------------
  Procedure: Load_All_TC
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: Repert_Film: integer
  Result:    None
-----------------------------------------------------------------------------}
procedure Load_All_TC(Repert_Film: integer);
const
  ProcName: string = 'Load_All_TC';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i: integer;
  _Row, _Column: Integer;
  tmpComponent: TComponent;
  ssTmp: TTicketControl;
//  vArray: Variant;
begin
  // --------------------------------------------------------------------------
  // Загрузка всех билетов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  with dm, dm.qTicket do
  if fmMain.tbcFilm.Visible and Check_Cntr then
    if PrepareQuery_Ticket_SQL(1, Repert_Film, TicketTypesSysSet) > 0 then
    begin
      DEBUGMess(0, '[' + ProcName + ']: qTicket.Open');
      UniDirectional := true;
      Open;
{}
      DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
      // new variant
      for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
      begin
        tmpComponent := Cur_Panel_Cntr.Components[i];
        if (tmpComponent is TTicketControl) then
        begin
          ssTmp := (tmpComponent as TTicketControl);
          ssTmp.Selected := False;
          ssTmp.Tag := -1;
        end;
      end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
      while not Eof do
      begin
        _Row := FieldByName(s_Ticket_ROW).AsInteger;
        _Column := FieldByName(s_Ticket_COLUMN).AsInteger;
        // s := '_R' + IntToStr(_Row) + '_C' + IntToStr(_Column);
        for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
        begin
          tmpComponent := Cur_Panel_Cntr.Components[i];
          if (tmpComponent is TTicketControl) then
          begin
            ssTmp := (tmpComponent as TTicketControl);
            if (ssTmp.Row = _Row) and (ssTmp.Column = _Column) then
            begin
              Refresh_TC_State(
                ssTmp,
                FieldByName(s_Ticket_Kod).AsInteger,
                FieldByName(s_Ticket_TARIFPL).AsInteger,
                FieldByName(s_Ticket_REPERT).AsInteger,
                FieldByName(s_Ticket_DATE).AsDateTime + FieldByName(s_Ticket_TIME).AsDateTime,
                FieldByName(s_Ticket_STATE).AsInteger,
                FieldByName(s_Ticket_OWNER).AsInteger,
                FieldByName(s_Ticket_RESTORED).AsBoolean,
                FieldByName(s_Ticket_TAG).AsInteger
                );
              ssTmp.Tag := 0;
            end; // if (ssTmp.Row = _Row) and (ssTmp.Column = _Column) then
          end; // if (tmpComponent is TTicketControl) then
        end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
        Next;
      end; // while not Eof do
      for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
      begin
        tmpComponent := Cur_Panel_Cntr.Components[i];
        if (tmpComponent is TTicketControl) then
        begin
          ssTmp := (tmpComponent as TTicketControl);
          if (ssTmp.Tag = -1) then
          begin
            Refresh_TC_State(
              ssTmp,
              0,                // Kod
              0,                // Tarif_Pl
              Repert_Film,      // Repert
              Now,              // Date&Time
              0,                // State
              0,                // Owner
              false,            // Restored
              0                 // Tag
              );
            ssTmp.Tag := 0;
            Refresh_TC_Hint(ssTmp);
          end; // if
        end; // if
      end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
{
      // old variant
      for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
      begin
        tmpComponent := Cur_Panel_Cntr.Components[i];
        if (tmpComponent is TTicketControl) then
        begin
          ssTmp := (tmpComponent as TTicketControl);
          ssTmp.Selected := false;
          //
          vArray := VarArrayCreate([0, 1], varInteger);
          vArray[0] := ssTmp.Row;
          vArray[1] := ssTmp.Column;
          First;
          if Locate(s_Ticket_ROW + ';' + s_Ticket_COLUMN, vArray, []) then
          begin
            Refresh_TC_State(
              ssTmp,
              FieldByName(s_Ticket_Kod).AsInteger,
              FieldByName(s_Ticket_TARIFPL).AsInteger,
              FieldByName(s_Ticket_REPERT).AsInteger,
              FieldByName(s_Ticket_DATE).AsDateTime + FieldByName(s_Ticket_TIME).AsDateTime,
              FieldByName(s_Ticket_STATE).AsInteger,
              FieldByName(s_Ticket_OWNER).AsInteger,
              FieldByName(s_Ticket_RESTORED).AsBoolean,
              FieldByName(s_Ticket_TAG).AsInteger
              );
          end
          else
            Refresh_TC_State(
              ssTmp,
              0,                // Kod
              0,                // Tarif_Pl
              Repert_Film,      // Repert
              Now,              // Date&Time
              0,                // State
              0,                // Owner
              false,            // Restored
              0                 // Tag
              );
        end;
      end; // for
}      
{}
      Close;
      UniDirectional := false;
      DEBUGMess(0, '[' + ProcName + ']: qTicket.Close');
    end; // if
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: Refresh_TC_Selected
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: ssT: TTicketControl; ActionToDo: TTicketAction; i_Tarifpl, i_Repert_Kod, i_Owner: integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Refresh_TC_Selected(ssT: TTicketControl; ActionToDo: TTicketAction; i_Tarifpl, i_Repert_Kod, i_Owner: integer): Integer;
const
  ProcName: string = 'Refresh_TC_Selected';
var
  str_cmd: string;  
  _checkpoint: boolean;
begin
  // --------------------------------------------------------------------------
  // Обработка выделенного билета
  // --------------------------------------------------------------------------
  DEBUGMess(0, CRLF + StringOfChar('.', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if Assigned(ssT) then
  begin
    Result := 0;
    {
    if Create_Net_Commmand(str_cmd, ssT, ntTrack) > -1 then
    begin
      BroadcastSend(str_cmd, False, 0, 3);
    end;
    }
    // taClear, taPrepare, taRestore, taReserve, taPrint, taPosTerminal, taPrintOneTicket, taFixCheq
    case ActionToDo of
  // --------------------------------------------------------------------------
  // Очистка всех выделенных мест
  // --------------------------------------------------------------------------
    taClear:
    begin
      ssT.Selected := False;
      case ssT.TC_State of
      scPrepared:
      begin
        ssT.TC_State := scFree;
      end;
      end;
      Result := 1;
      // --------------------------start----------------------------------------
      if Create_Net_Commmand(str_cmd, ssT, ntClear) > -1 then
      begin
        BroadcastSend(str_cmd, False, 0, 3);
      end;
      // --------------------------finish---------------------------------------
    end;
  // --------------------------------------------------------------------------
  // Подготовка для печати
  // --------------------------------------------------------------------------
    taPrepare:
    begin
      case ssT.TC_State of
      scFree:
      begin
        ssT.Ticket_Kod := -1;
        ssT.Ticket_Tarifpl := i_Tarifpl;
        // ssT.Ticket_Repert := i_Repert_Kod;
        ssT.Ticket_DateTime := Now;
        ssT.Ticket_Owner := i_Owner;
        ssT.TC_State := scPrepared;
        Result := 1;
      end;
      scBroken:
        {ignore};
      scReserved:
        {ignore};
      scPrepared:
        {ignore};
      scFixed, scFixedNoCash, scFixedCheq:
        Result := 2;
      else
      end;
      // --------------------------start----------------------------------------
      if Create_Net_Commmand(str_cmd, ssT, ntPrepare) > -1 then
      begin
        BroadcastSend(str_cmd, False, 0, 3);
      end;
      // --------------------------finish---------------------------------------
    end;
  // --------------------------------------------------------------------------
  // Возврат проданных билетов
  // --------------------------------------------------------------------------
    taRestore:
    begin
      case ssT.TC_State of
      scFree:
        {ignore};
      scBroken:
        {ignore};
      scReserved:
      begin
  // --------------------------------------------------------------------------
  // Сохранение в базе
  // --------------------------------------------------------------------------
        Save2DB(ssT, true);
  // --------------------------------------------------------------------------
        ssT.TC_State := scFree;
        Result := 1;
      end;
      scPrepared:
        {ignore};
      scFixed, scFixedNoCash, scFixedCheq:
      begin
  // --------------------------------------------------------------------------
  // Сохранение в базе
  // --------------------------------------------------------------------------
        Save2DB(ssT, true);
  // --------------------------------------------------------------------------
        ssT.TC_State := scFree;
        Result := 1;
      end;
      else
      end;
      // --------------------------start----------------------------------------
      if Create_Net_Commmand(str_cmd, ssT, ntRestore) > -1 then
      begin
        BroadcastSend(str_cmd, False, 0, 3);
      end;
      // --------------------------finish---------------------------------------
    end;
  // --------------------------------------------------------------------------
  // Резервирование (бронь) билетов
  // --------------------------------------------------------------------------
    taReserve:
    begin
      case ssT.TC_State of
      scFree:
        {ignore};
      scBroken:
        Result := 2;
      scReserved:
        Result := 2;
      scPrepared:
      begin
        if ssT.Ticket_Kod = -1 then
        begin
          ssT.Ticket_DateTime := Now;
          ssT.Ticket_Owner := i_Owner;
          ssT.TC_State := scReserved;
  // --------------------------------------------------------------------------
  // Сохранение в базе
  // --------------------------------------------------------------------------
          Save2DB(ssT, false);
  // --------------------------------------------------------------------------
          Result := 1;
        end;
      end;
      scFixed, scFixedNoCash, scFixedCheq:
        Result := 2;
      else
      end;
      // --------------------------start----------------------------------------
      if Create_Net_Commmand(str_cmd, ssT, ntReserve) > -1 then
      begin
        BroadcastSend(str_cmd, False, 0, 3);
      end;
      // --------------------------finish---------------------------------------
    end;
  // --------------------------------------------------------------------------
  // Печать подготовленных билетов (Все)
  // --------------------------------------------------------------------------
    taPrint, taPosTerminal, taFixCheq:
    begin
      case ssT.TC_State of
      scFree:
        {ignore};
      scBroken:
        {ignore};
      scReserved:
        {ignore};
      scPrepared:
      begin
      // --------------------------start----------------------------------------
        if Create_Net_Commmand(str_cmd, ssT, ntTrack) > -1 then
        begin
          BroadcastSend(str_cmd, False, 0, 3);
        end;
      // --------------------------finish---------------------------------------
        if ssT.Ticket_Kod = -1 then
        begin
          ssT.Ticket_DateTime := Now;
          ssT.Ticket_Owner := i_Owner;
          case ActionToDo of
          taPrint:
            ssT.TC_State := scFixed;
          taPosTerminal:
            ssT.TC_State := scFixedNoCash;
          taFixCheq:
            ssT.TC_State := scFixedCheq;
          else
          end;
  // --------------------------------------------------------------------------
  // Сохранение в базе
  // --------------------------------------------------------------------------
          Save2DB(ssT, false);
  // --------------------------------------------------------------------------
          if not ssT.UsedByNet then
          begin
            _checkpoint := not ((ssT.Ticket_Tarifpl in [10, 11, 12, 13, 14, 15]));
            if _Print_Serial and _checkpoint then
            begin
              Inc(_Serial);
              SaveOption(s_Serial_Num + IntToStr(Cur_Zal_Kod), IntToStr(_Serial), true);
              DEBUGMess(0, '[' + ProcName + ']: Serial' + IntToStr(Cur_Zal_Kod) + ' = (' + _Zal_Prefix + FixFmt(_Serial, 5, '0') + ')');
            end;
            if Add_TC_Print(0,
              ssT.Ticket_Kod,
              ssT.Ticket_Tarifpl,
              ssT.Ticket_Repert,
              ssT.Row,
              ssT.Column,
              ssT.Ticket_Owner,
              0, '',
              _Print_Serial and _checkpoint) = 1 then
              Inc(_Count_To_Print);
          end;
          Result := 1;
        end;
      end;
      scFixed, scFixedNoCash, scFixedCheq:
      begin
        Result := 2;
      end;
      else
      end;
    end;
  // --------------------------------------------------------------------------
  // Печать подготовленных билетов на ОДИН бланк
  // --------------------------------------------------------------------------
    taPrintOneTicket:
    begin
      case ssT.TC_State of
      scFree:
        {ignore};
      scBroken:
        {ignore};
      scReserved:
        {ignore};
      scPrepared:
      begin
        {ignore};
      end;
      scFixed, scFixedNoCash, scFixedCheq:
        Result := 2;
      else
      end;
    end;
    taQueue:
    begin
      case ssT.TC_State of
      scFixedCheq:
        if (ssT.Ticket_Kod > 0) then
        begin
          ssT.TC_State := scFixed;
  // --------------------------------------------------------------------------
  // Сохранение в базе
  // --------------------------------------------------------------------------
          Save2DB(ssT, false);
  // --------------------------------------------------------------------------
          Result := 2;
        end;
      else
      end; // case
      // --------------------------start----------------------------------------
      if Create_Net_Commmand(str_cmd, ssT, ntQueue) > -1 then
      begin
        BroadcastSend(str_cmd, False, 0, 3);
      end;
      // --------------------------finish---------------------------------------
    end;
    else // case ActionToDo of
    end; // case ActionToDo of
    if Result <> 0 then
      ssT.Selected := False;
    if Result = 2 then
      Result := 0;
    Refresh_TC_Hint(ssT);
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('.', LogSeparatorWidth));
end;

{-----------------------------------------------------------------------------
  Procedure: Refresh_All_TC_Selected
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: ActionToDo: TTicketAction; i_Tarifpl, i_Repert_Kod: integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Refresh_All_TC_Selected(ActionToDo: TTicketAction; i_Tarifpl, i_Repert_Kod: integer): Integer;
const
  ProcName: string = 'Refresh_All_TC_Selected';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i: Integer;
  tmpComponent: TComponent;
  ssTmp: TTicketControl;
  Fit: Boolean;
  s: string;
  b_NoToAll: Boolean;
begin
  // --------------------------------------------------------------------------
  // Обработка выделенных билетов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
  _Count_To_Print := 0;
  DEBUGMess(1, '[' + ProcName + ']: ->');
  //
  if fmMain.tbcFilm.Visible and Check_Cntr then
  begin
    PrintJobFirst := True;
    b_NoToAll := False;
    DEBUGMess(0, '[' + ProcName + ']: Operation = (' + TicketAction_Array[ActionToDo] + ')');
    for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
    begin
      tmpComponent := Cur_Panel_Cntr.Components[i];
      if (tmpComponent is TTicketControl) then
      begin
        ssTmp := (tmpComponent as TTicketControl);
        case ActionToDo of
        taClear:
          Fit := ssTmp.Selected or ((ssTmp.TC_State = scPrepared) and (i_Tarifpl = 0));
        taPrepare:
          Fit := ssTmp.Selected and (ssTmp.TC_State in [scFree, scBroken, scReserved]);
        taRestore:
        begin
          Fit := False;
          if ssTmp.Selected then
          case ssTmp.TC_State of
          scReserved:
            Fit := True;
          scFixed, scFixedNoCash, scFixedCheq:
          begin
            if b_NoToAll then
              ssTmp.Selected := False
            else
            begin
              s := ssTmp.Hint;
              s := Format(Restore_Mess, [ssTmp.Row, ssTmp.Column, s]);
              case MessageDlg(s, mtWarning, [mbYes, mbNo, mbNoToAll], 0) of
              mrYes:
                Fit := True;
              mrNo:
                ssTmp.Selected := False;
              mrNoToAll:
              begin
                ssTmp.Selected := False;
                b_NoToAll := True;
              end;
              end;
            end;
          end;
          else
          end;
        end;
        taReserve:
        begin
          Fit := (ssTmp.Selected and (ssTmp.TC_State = scFree)) or  (ssTmp.TC_State = scPrepared);
          if Fit then
            Refresh_TC_Selected(ssTmp, taPrepare, 1, i_Repert_Kod, Cur_Owner);
        end;
        taPrint:
          Fit := (ssTmp.TC_State in [scPrepared]);
        taPosTerminal:
          Fit := (ssTmp.TC_State in [scPrepared]);
        taPrintOneTicket:
          Fit := (ssTmp.TC_State in [scPrepared]);
        taFixCheq:
          Fit := (ssTmp.TC_State in [scPrepared]);
        taQueue:
          Fit := ssTmp.Selected and (ssTmp.TC_State in [scFixedCheq]);
        else
          Fit := False;
        end;
        if Fit then
        begin
          Refresh_TC_Selected(ssTmp, ActionToDo, i_Tarifpl, i_Repert_Kod, Cur_Owner);
        end;
      end;
    end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
    if not PrintJobFirst then
    begin
      Final_TC_Print(_Count_To_Print);
      SaveOption(s_Total_Printed_Count, IntToStr(Printed_Ticket_Count), true);
    end;
  end; // if
  Refresh_TC_Count(nil);
  Result := _Count_To_Print;
  _Count_To_Print := 0;
  DEBUGMess(0, '[' + ProcName + ']: Result = (' + IntToStr(Result) + ')');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: Get_Tarifpl
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: i_Tarifpl_Kod: integer; var b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: boolean; var i_Tarifpl_TYPE: Integer; var c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor; var i_Tarifpl_TAG: integer
  Result:    integer
-----------------------------------------------------------------------------}
function Get_Tarifpl(i_Tarifpl_Kod: integer;
  var b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: boolean;
  var i_Tarifpl_TYPE: Integer; var c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor;
  var i_Tarifpl_TAG: integer): integer; // ready
const
  ProcName: string = 'Get_Tarifpl';
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  b_Tarifpl_PRINT := true;
  b_Tarifpl_REPORT := true;
  b_Tarifpl_FREE := true;
  b_Tarifpl_SHOW := true;
  b_Tarifpl_SYS := true;
  i_Tarifpl_TYPE := 0;
  c_Tarifpl_BGCOLOR := clLime;
  c_Tarifpl_FNTCOLOR := clBlack;
  i_Tarifpl_TAG := 0;
  Result := 0;
  with dm, dm.qTarifpl do
  if PrepareQuery_Tarifpl_SQL(4, i_Tarifpl_Kod, false, nil) > 0 then
  begin
    UniDirectional := true;
    Open;
{}
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
    if RecordCount > 0 then
    begin
      b_Tarifpl_PRINT := FieldByName(s_Tarifpl_PRINT).AsBoolean;
      b_Tarifpl_REPORT := FieldByName(s_Tarifpl_REPORT).AsBoolean;
      b_Tarifpl_FREE := FieldByName(s_Tarifpl_FREE).AsBoolean;
      b_Tarifpl_SHOW := FieldByName(s_Tarifpl_SHOW).AsBoolean;
      b_Tarifpl_SYS := FieldByName(s_Tarifpl_SYS).AsBoolean;
      i_Tarifpl_TYPE := FieldByName(s_Tarifpl_TYPE).AsInteger;
      c_Tarifpl_BGCOLOR := TColor(FieldByName(s_Tarifpl_BGCOLOR).AsInteger);
      c_Tarifpl_FNTCOLOR := TColor(FieldByName(s_Tarifpl_FNTCOLOR).AsInteger);
      i_Tarifpl_TAG := FieldByName(s_Tarifpl_TAG).AsInteger;
      Result := 1;
    end;
{}
    Close;
    UniDirectional := false;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Save2DB
  Author:    n0mad
  Date:      21-окт-2002
  Arguments: ssT: TTicketControl; Restore: Boolean
  Result:    Integer
-----------------------------------------------------------------------------}
function Save2DB(ssT: TTicketControl; Restore: Boolean): Integer; // ready partially
const
  ProcName: string = 'Save2DB';
var
  _Kod, _Type: Integer;
  s: string;
  _Saved: TNtiCmdType;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  _Kod := 0;
  if Assigned(ssT) then
  with ssT, dm do
  begin
    DEBUGMess(0, '[' + ProcName + ']: ssT.TC_State = "' + SpShSt_Array[ssT.TC_State] + '"');
    case TC_State of
    scFree:
      {ignore};
    scBroken:
      {ignore};
    scPrepared:
      {ignore};
    scReserved, scFixed, scFixedNoCash, scFixedCheq:
    begin
      case TC_State of
      scReserved:
        _Type := 0;
      scFixed:
        _Type := 1;
      scFixedNoCash:
        _Type := 2;
      scFixedCheq:
        _Type := 3;
      else
        _Type := 4;
      end;
      _Saved := ntNothing;
      if Ticket_Kod = -1 then
      begin
        if Ticket_Owner = 0 then
          Ticket_Owner := Cur_Owner;
        if Ticket_Add(_Kod, Ticket_Tarifpl, Ticket_Repert, Row, Column, _Type, Ticket_Owner, Ticket_DateTime, False) = 0 then
        begin
          Ticket_Kod := _Kod;
          Ticket_Type := _Type;
          _Saved := ntSave;
          Result := 0;
          DEBUGMess(0, '[' + ProcName + ']: {SAVED}');
        end
        else
          DEBUGMess(0, '[' + ProcName + ']: {NOT_SAVED}');
      end
      else // <> -1
      begin
        if Restore then
        begin
          if Ticket_Restore(Ticket_Kod, Ticket_Repert, True) = 0 then
          begin
            _Saved := ntRestore;
            Result := 0;
            DEBUGMess(0, '[' + ProcName + ']: {RESTORED}');
          end
          else
            DEBUGMess(0, '[' + ProcName + ']: {NOT_RESTORED}')
        end
        else
        begin
          if Ticket_Restore(Ticket_Kod, Ticket_Repert, False) = 0 then
          begin
            _Saved := ntQueue;
            Result := 0;
            DEBUGMess(0, '[' + ProcName + ']: {QUEUED}');
          end
          else
            DEBUGMess(0, '[' + ProcName + ']: {NOT_QUEUED}')
        end;
      end; // if
      if Create_Net_Commmand(s, ssT, _Saved) > -1 then
      begin
        BroadcastSend(s, False, 0, 3);
      end;
      DEBUGMess(0, '[' + ProcName + ']: Ticket_Hint = (' + Hint + ')');
    end;
    else // case
    end;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Get_Repert_Film_Desc
  Author:    n0mad
  Date:      23-окт-2002
  Arguments: _Repert_Kod: Integer; var d_Film_Date: TDateTime; var str_Zal_Nam, str_Film_Name, str_Seans_Desk: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Get_Repert_Film_Desc(_Repert_Kod: Integer; var d_Film_Date: TDateTime;
  var str_Zal_Nam, str_Film_Name, str_Seans_Desk: string): Integer; // ready
const
  ProcName: string = 'Get_Repert_Film_Desc';
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  with dm, dm.qRepert do
  begin
    if PrepareQuery_Repert_SQL(2, 0, 0, _Repert_Kod) > 0 then
    begin
      Result := 0;
      UniDirectional := true;
      Open;
//
      DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
      if RecordCount > 0 then
      begin
        DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
        d_Film_Date := FieldByName(s_Repert_DATE).AsDateTime;
        str_Zal_Nam := FieldByName(s_Zal_Nam).AsString;
        if Pos('Основной', str_Zal_Nam) = 1 then
          str_Zal_Nam := '';
        str_Film_Name := FieldByName(s_Film_Nam).AsString;
        str_Seans_Desk := FixFmt(FieldByName(s_Seans_HOUR).AsInteger, 2, '0')
           + ':' + FixFmt(FieldByName(s_Seans_MINUTE).AsInteger, 2, '0');
        Result := 1;
      end;
//
      Close;
      UniDirectional := false;
    end
    else
      DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  {
  Result := 1;
  d_Film_Date := Now;
  s_Film_Name := 'Тестовый просмотр';
  s_Seans_Desk := '13:20';
  }
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Get_Repert_Desc
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: _Repert_Kod: Integer; var Repert_DATE: TDateTime; var Repert_Seans, Repert_Film, Repert_Tarifet, Repert_Zal, Repert_TAG: Integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Get_Repert_Desc(_Repert_Kod: Integer;
  var Repert_DATE: TDateTime; var Repert_Seans, Repert_Film, Repert_Tarifet,
  Repert_Zal, Repert_TAG: Integer): Integer; // ready
const
  ProcName: string = 'Get_Repert_Desc';
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  with dm, dm.qRepert do
  begin
    if PrepareQuery_Repert_SQL(2, 0, 0, _Repert_Kod) > 0 then
    begin
      Result := 0;
      UniDirectional := true;
      Open;
//
      DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
      if RecordCount > 0 then
      begin
        DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
        Repert_DATE := FieldByName(s_Repert_DATE).AsDateTime;
        Repert_Seans := FieldByName(s_Repert_Seans).AsInteger;
        Repert_Film := FieldByName(s_Repert_Film).AsInteger;
        Repert_Tarifet := FieldByName(s_Repert_Tarifet).AsInteger;
        Repert_Zal := FieldByName(s_Repert_Zal).AsInteger;
        Repert_TAG := FieldByName(s_Repert_TAG).AsInteger;
        Result := 1;
      end;
//
      Close;
      UniDirectional := false;
    end
    else
      DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  {
  Result := 1;
  Repert_DATE := Now;
  Repert_Seans := 1;
  Repert_Film := 1;
  Repert_Tarifet := 1;
  Repert_Zal := 1;
  Repert_TAG := 1;
  }
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: Exist_Zal_Desc
  Author:    n0mad
  Date:      23-окт-2002
  Arguments: Zal_Kod: Byte
  Result:    Boolean
-----------------------------------------------------------------------------}
function Exist_Zal_Desc(Zal_Kod: Byte): Boolean;
begin
  Result := False;
  if Assigned(ZalList) then
    if ZalList.IndexOf(IntToStr(Zal_Kod)) > -1 then
      Result := True;
end;

function Get_Caption_Length(_Text: string; _Font: TFont): Integer;
begin
  Result := -1;
  if Assigned(fmMain) and Assigned(_Font) then
    with fmMain.lbNoRepert do
    begin
      Canvas.Font.Assign(_Font);
      Result := Canvas.TextWidth(_Text);
    end;
end;

function Get_Caption_Addon(_Text: string; MaxW: Integer; _Font: TFont): Integer;
var
  len: Integer;
begin
  Result := -1;
  if (MaxW > 0) and Assigned(_Font) then
  begin
    len := 0;
    while Get_Caption_Length(_Text + StringOfChar(Space, len), _Font) < MaxW do
      Inc(len);
    Result := len;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: Nti_Parse
  Author:    n0mad
  Date:      31-окт-2002
  Arguments: ttRec: TTicketRec; var ssT: TTicketControl
  Result:    Integer
-----------------------------------------------------------------------------}
function Nti_Parse(ttRec: TTicketRec; var ssT: TTicketControl): Integer;
const
  ProcName: string = 'Nti_Parse';
var
  i: Integer;
  tmpComponent: TComponent;
  ssTmp: TTicketControl;
begin
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Result := -1;
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Repert = (' + IntToStr(ttRec.tr_Repert) + '=' + IntToStr(Cur_Repert_Kod) + ')');
{!$ENDIF}
  if Assigned(fmMain)
    and fmMain.tbcFilm.Visible
    and Check_Cntr
    and (ttRec.tr_Repert = Cur_Repert_Kod) then
  begin
    Result := 0;
{!$IFDEF uMain_Net_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Searching RowCol = (' + IntToStr(ttRec.tr_Row) + ', ' + IntToStr(ttRec.tr_Row) + ')');
{!$ENDIF}
    for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
    begin
      tmpComponent := Cur_Panel_Cntr.Components[i];
      if (tmpComponent is TTicketControl) then
      begin
        ssTmp := (tmpComponent as TTicketControl);
        if (ssTmp.Row = ttRec.tr_Row)
          and (ssTmp.Column = ttRec.tr_Column)
          // and (ssTmp.Ticket_Owner = ttRec.tr_Owner)
          then
        begin
          ssT := ssTmp;
{!$IFDEF uMain_Net_DEBUG}
          DEBUGMess(0, '[' + ProcName + ']: Found ssTmp.Name = (' + ssTmp.Name + ')');
          DEBUGMess(0, '[' + ProcName + ']: ssTmp.TC_Owner = (' + IntToStr(ssTmp.Ticket_Owner) + ')');
{!$ENDIF}
          Result := 1;
          Break;
        end;
      end;
    end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
  end;
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

function GetOption(OptionName: string; var OptionValue: string): Integer;
const
  ProcName: string = 'GetOption';
var
  str_OptionName, str_OptionValue: string;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  DEBUGMess(0, '[' + ProcName + ']: OptionName = (' + OptionName + ')');
  DEBUGMess(0, '[' + ProcName + ']: OptionValue = (' + OptionValue + ')');
  with dm.tOption do
  // Read
  if Active then
  begin
    Result := 0;
    str_OptionName := '';
    str_OptionValue := '';
    First;
    while not Eof do
    begin
      str_OptionName := FieldByName(s_Option_Nam).AsString;
      str_OptionValue := FieldByName(s_Option_Value).AsString;
      if LowerCase(str_OptionName) = LowerCase(OptionName) then
      begin      
        OptionValue := str_OptionValue;
	DEBUGMess(0, '[' + ProcName + ']: str_OptionName = (' + str_OptionName + ')');
  	DEBUGMess(0, '[' + ProcName + ']: str_OptionValue = (' + str_OptionValue + ')');
        Result := 1;
        Break;
      end;
      Next;
    end;
    First;
  end;
  DEBUGMess(0, '[' + ProcName + ']: Result = ' + IntToStr(Result));
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function SaveOption(OptionName, OptionValue: string; _Create: boolean): Integer;
const
  ProcName: string = 'SaveOption';
var
  i_Kod: integer;
  str_OptionName, str_OptionValue: string;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := -1;
  DEBUGMess(0, '[' + ProcName + ']: OptionName = (' + OptionName + ')');
  DEBUGMess(0, '[' + ProcName + ']: OptionValue = (' + OptionValue + ')');
  with dm.tOption do
  // Read
  if Active then
  begin
    Result := 0;
    str_OptionName := '';
    str_OptionValue := '';
    First;
    while not Eof do
    begin
      str_OptionName := FieldByName(s_Option_Nam).AsString;
      str_OptionValue := FieldByName(s_Option_Value).AsString;
      if LowerCase(str_OptionName) = LowerCase(OptionName) then
      begin      
        if OptionValue <> str_OptionValue then
        begin
  	  DEBUGMess(0, '[' + ProcName + ']: str_OptionName = (' + str_OptionName + ')');
  	  DEBUGMess(0, '[' + ProcName + ']: old_OptionValue = (' + str_OptionValue + ')');
          try
            Edit;
            FieldByName(s_Option_Value).AsString := OptionValue;
	    DEBUGMess(0, '[' + ProcName + ']: new_OptionValue = (' + OptionValue + ')');
            Post;
            Active := false;
            Active := true;
          except
            Cancel;
          end;
        end;
        Result := 1;
        Break;
      end;
      Next;
    end;
    if (Result = 0) and _Create then
    begin
      // Table_Add_GenKod(tFilm, s_Film_Kod, Kod);
      if dm.Table_Add_GenKod(dm.tOption, s_Option_Kod, i_Kod) = 0 then
      try
        Append;
        FieldByName(s_Option_Kod).AsInteger := i_Kod;
        FieldByName(s_Option_Nam).AsString := OptionName;
        FieldByName(s_Option_Value).AsString := OptionValue;
        Post;
        DEBUGMess(0, '[' + ProcName + ']: app_OptionValue = (' + OptionValue + ')');
      except
        Cancel;
      end;
    end;
    First;
  end;
  DEBUGMess(0, '[' + ProcName + ']: Result = ' + IntToStr(Result));
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// init module
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{!$IFDEF uAddon_DEBUG}
initialization
  DEBUGMess(0, 'uAddon.Init');
{!$ENDIF}

{!$IFDEF uAddon_DEBUG}
finalization
  DEBUGMess(0, 'uAddon.Final');
{!$ENDIF}

end.


