{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uDatamod.pas
Version      : 15.10.2002 9:01:40
Description  : 
Creation     : 12.10.2002 9:01:40
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uDatamod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, uRescons;

type
// -----------------------------------------------------------------------------
  TCombo_Load_HandleProc = function (DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  Tdm = class(TDatamodule)
// -----------------------------------------------------------------------------
    db: TDatabase;
// -----------------------------------------------------------------------------

    tFilm: TTable;
    tGenre: TTable;
    tPerson: TTable;
    tPlace: TTable;
    tProizv: TTable;
    tRepert: TTable;
    tSeans: TTable;
    tTarifet: TTable;
    tTarifpl: TTable;
    tTarifz: TTable;
    tTicket: TTable;
    tUzver: TTable;
    tZal: TTable;
// -----------------------------------------------------------------------------
    dFilm: TDataSource;
    dGenre: TDataSource;
    dPerson: TDataSource;
    dPlace: TDataSource;
    dProizv: TDataSource;
    dRepert: TDataSource;
    dSeans: TDataSource;
    dTarifet: TDataSource;
    dTarifpl: TDataSource;
    dTarifz: TDataSource;
    dTicket: TDataSource;
    dUzver: TDataSource;
    dZal: TDataSource;
// -----------------------------------------------------------------------------
    qFilm: TQuery;
    qGenre: TQuery;
    qPerson: TQuery;
    qPlace: TQuery;
    qProizv: TQuery;
    qRepert: TQuery;
    qSeans: TQuery;
    qTarifet: TQuery;
    qTarifpl: TQuery;
    qTarifz: TQuery;
    qTicket: TQuery;
    qUzver: TQuery;
    qZal: TQuery;
// -----------------------------------------------------------------------------
    tRepertRepert_Kod: TSmallintField;
// -----------------------------------------------------------------------------
    tRepert_Cinema: TStringField;
    tRepert_Film: TStringField;
    tRepert_Seans: TStringField;
    tRepert_Tarifet: TStringField;
    tRepert_Zal: TStringField;
    tRepertRepert_DATE: TDateField;
    tRepertRepert_Film: TSmallintField;
    tRepertRepert_Seans: TSmallintField;
    tRepertRepert_TAG: TSmallintField;
    tRepertRepert_Tarifet: TSmallintField;
    tRepertRepert_Zal: TSmallintField;
// -----------------------------------------------------------------------------
    tSeansSeans_Kod: TSmallintField;
// -----------------------------------------------------------------------------
    tSeans_Seans: TStringField;
    tSeansSeans_HOUR: TSmallintField;
    tSeansSeans_MINUTE: TSmallintField;
    tSeansSeans_TAG: TSmallintField;
// -----------------------------------------------------------------------------
    tTarifzTarifz_Kod: TSmallintField;
// -----------------------------------------------------------------------------
    tTarifz_Tarifpl_Color: TIntegerField;
    tTarifz_Tarifpl_Free: TBooleanField;
    tTarifz_Tarifpl_Nam: TStringField;
    tTarifz_Tarifpl_Print: TBooleanField;
    tTarifz_Tarifpl_Report: TBooleanField;
    tTarifz_Tarifpl_Show: TBooleanField;
    tTarifz_Tarifpl_Tag: TIntegerField;
    tTarifz_Tarifpl_Type: TIntegerField;
    tTarifzTarifz_COST: TCurrencyField;
    tTarifzTarifz_ET: TSmallintField;
    tTarifzTarifz_PL: TSmallintField;
    tTarifzTarifz_TAG: TSmallintField;
    tOption: TTable;
// -----------------------------------------------------------------------------
    procedure DatamoduleCreate(Sender: TObject); // 1.1) Создание алиаса базы
    procedure dbAfterConnect(Sender: TObject); // 1.2) Открытие таблиц базы
// -----------------------------------------------------------------------------
    procedure TableAfterScroll(DataSet: TDataSet);
    function Table_Add_GenKod(Table: TTable; FieldName: string; var Kod: integer): integer; // Генератор автоинкремента ключевого поля
    function Table_CheckCanDel(Table: TTable; Kod_FieldName, Tag_FieldName: string; Kod: integer): integer; // Проверка на удаляемость
// -----------------------------------------------------------------------------
    procedure tSeansCalcFields(DataSet: TDataSet);
    procedure TableAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
// -----------------------------------------------------------------------------
  public
    { Public declarations }
    function Film_Add(var Kod: integer; Nam :string; Film_Genre, Film_Rejiser, Film_Producer, Film_Proizv: integer): integer;
    function Film_Add_GenKod(var Kod: integer): integer;
    function Film_CheckCanDel(Kod: integer): integer;
    function Film_Del(Kod: integer; Nam :string): integer;
    function Film_Edit(Kod: integer; Nam :string; Film_Genre, Film_Rejiser, Film_Producer, Film_Proizv: integer): integer;
    function Film_Track(var Kod, Nam :string; var Film_Genre, Film_Rejiser, Film_Producer, Film_Proizv: integer): integer;
// -----------------------------------------------------------------------------
    function Genre_Add(var Kod: integer; Nam :string): integer;
    function Genre_Add_GenKod(var Kod: integer): integer;
    function Genre_CheckCanDel(Kod: integer): integer;
    function Genre_Del(Kod: integer; Nam :string): integer;
    function Genre_Edit(Kod: integer; Nam :string): integer;
    function Genre_Track(var Kod, Nam :string): integer;
// -----------------------------------------------------------------------------
    function Person_Add(var Kod: integer; Nam_Sh, Nam_Ful :string; IsReji, IsProd: boolean): integer;
    function Person_Add_GenKod(var Kod: integer): integer;
    function Person_CheckCanDel(Kod: integer): integer;
    function Person_Del(Kod: integer; Nam_Sh :string): integer;
    function Person_Edit(Kod: integer; Nam_Sh, Nam_Ful :string; IsReji, IsProd: boolean): integer;
    function Person_Track(var Kod, Nam_Sh, Nam_Ful :string; var IsReji, IsProd: boolean): integer;
// -----------------------------------------------------------------------------
    function Proizv_Add(var Kod: integer; Nam :string): integer;
    function Proizv_Add_GenKod(var Kod: integer): integer;
    function Proizv_CheckCanDel(Kod: integer): integer;
    function Proizv_Del(Kod: integer; Nam :string): integer;
    function Proizv_Edit(Kod: integer; Nam :string): integer;
    function Proizv_Track(var Kod, Nam :string): integer;
// -----------------------------------------------------------------------------
    function Repert_Add(var Kod: integer; _Date: TDateTime; _Seans, _Film, _Tarifet, _Zal: integer): integer;
    function Repert_Add_GenKod(var Kod: integer): integer;
    function Repert_CheckCanDel(Kod: integer): integer;
    function Repert_Del(Kod: integer; _Date: TDateTime; _Seans: integer): integer;
    function Repert_Edit(Kod: integer; _Date: TDateTime; _Seans, _Film, _Tarifet, _Zal: integer): integer;
    function Repert_Track(var Kod: string; var _Date: TDateTime; var _Seans, _Film, _Tarifet, _Zal: integer): integer;
// -----------------------------------------------------------------------------
    function Seans_Add(var Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
    function Seans_Add_GenKod(var Kod: integer): integer;
    function Seans_CheckCanDel(Kod: integer): integer;
    function Seans_Del(Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
    function Seans_Edit(Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
    function Seans_Track(var Kod, Seans_Hour, Seans_Minute: string): integer;
// -----------------------------------------------------------------------------
    function Tarifz_Add(var Kod: integer; _Pl, _Set, _Cost :integer): integer;
    function Tarifz_Add_GenKod(var Kod: integer): integer;
    function Tarifz_CheckCanDel(Kod: integer): integer;
    function Tarifz_CheckCanChange(Kod: integer): integer;
    function Tarifz_Del(Kod: integer; _Cost :integer): integer;
    function Tarifz_Edit(Kod: integer; _Pl, _Set, _Cost :integer): integer;
    function Tarifz_Track(var Kod: string; var _Tarifpl, _Cost: integer): Integer;
// -----------------------------------------------------------------------------
    function Tarifpl_Add(var Kod: integer; Nam :string; _Print, _Free, _Report, _Show, _Sys: boolean; _Type, _BgColor, _FntColor: integer): Integer;
    function Tarifpl_Add_GenKod(var Kod: integer): integer;
    function Tarifpl_CheckCanDel(Kod: integer): integer;
    function Tarifpl_Del(Kod: integer; Nam :string): integer;
    function Tarifpl_Edit(Kod: integer; Nam :string; _Print, _Free, _Report, _Show, _Sys: boolean; _Type, _BgColor, _FntColor: integer): Integer;
    function Tarifpl_Track(var Kod, Nam: string; var _Print, _Free, _Report, _Show, _Sys: boolean; var _Type, _BgColor, _FntColor: integer): integer;
// -----------------------------------------------------------------------------
    function Tarifet_Add(var Kod: integer; Nam :string): integer;
    function Tarifet_Add_GenKod(var Kod: integer): integer;
    function Tarifet_CheckCanDel(Kod: integer): integer;
    function Tarifet_Del(Kod: integer; Nam :string): integer;
    function Tarifet_Edit(Kod: integer; Nam :string): integer;
    function Tarifet_Track(var Kod, Nam :string): integer;
// -----------------------------------------------------------------------------
    function Ticket_Add(var Kod: integer; _Tarifpl, _Repert, _Row, _Column, _State, _Owner: Integer; _DateTime: TDateTime; _Restored: Boolean): integer;
//    function Ticket_Add_GenKod(var Kod: integer): integer;
    function Ticket_CheckCanDel(Kod: integer): integer;
    function Ticket_Del(Kod: integer; _Repert: integer): Integer;
    function Ticket_Edit(Kod: integer; _Tarifpl, _Repert, _Row, _Column, _State, _Owner: Integer; _DateTime: TDateTime; _Restored: Boolean): Integer;
    function Ticket_Restore(Kod: integer; _Repert: Integer; _Restored: Boolean): Integer;
// -----------------------------------------------------------------------------
    function Topogr_Add(var Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
    function Topogr_Add_GenKod(var Kod: integer): integer;
    function Topogr_CheckCanDel(Kod: integer): integer;
    function Topogr_Del(Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
    function Topogr_Edit(Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
    function Topogr_Track(var Kod, Seans_Hour, Seans_Minute: string): integer;
// -----------------------------------------------------------------------------
//  Фильтры
// -----------------------------------------------------------------------------
    procedure Table_Filter(Table: TTable; FilterString: string; _Controls_Disabled: boolean);
    procedure Table_UnFilter(Table: TTable; _Controls_Enabled: boolean);
    function _Table_Locate(Table: TTable; const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
    procedure _Table_UnLocate(Table: TTable);
// -----------------------------------------------------------------------------
//  Цикл загрузки записей из запроса
// -----------------------------------------------------------------------------
    function Combo_Load_DataSet(DataSet: TDataSet; Lines: TStrings; s_DataSet_Kod, s_DataSet_Nam: string; Combo_Load_HandleProc: TCombo_Load_HandleProc): integer;
// -----------------------------------------------------------------------------
    function Combo_Load_Film(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Genre(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Person(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Proizv(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Repert(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Seans(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Tarifet(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Tarifpl(DataSet: TDataSet; Lines: TStrings): integer;
    function Combo_Load_Zal(DataSet: TDataSet; Lines: TStrings): integer;
// -----------------------------------------------------------------------------
    function Combo_Load_Tarifz_Desc(DataSet: TDataSet; Lines: TStrings): integer; // Загрузка типов билетов из запроса
    function Combo_Load_Tarifpl_Desc(DataSet: TDataSet; Lines: TStrings): integer; // Загрузка типов билетов из запроса
    function Combo_Load_Zal_Map(DataSet: TDataSet; Lines: TStrings): integer; // Загрузка залов из запроса
// -----------------------------------------------------------------------------
    function PrepareQuery_Tarifet_SQL(FilterMode: byte; Filter_Tarifet_Kod: integer; Lines: TStrings): integer;
    function PrepareQuery_Tarifpl_SQL(FilterMode: byte; Filter_Tarifpl_Kod: integer; Filter_Tarifpl_Free: boolean; Lines: TStrings): integer;
    function PrepareQuery_Tarifz_SQL(FilterMode: byte; Filter_Tarifz_Kod, Filter_Tarifz_ET: integer; Lines: TStrings): integer;
    function PrepareQuery_Ticket_SQL(FilterMode: byte; Filter_Ticket_REPERT: Integer; Filter_Ticket_Tarifpl_Set: SetByte): Integer;
    function PrepareQuery_Zal(Lines: TStrings): integer;
// -----------------------------------------------------------------------------
    function PrepareQuery_Film(Lines: TStrings): integer;
    function PrepareQuery_Genre(Lines: TStrings): integer;
    function PrepareQuery_Person(Lines: TStrings; FilterMode: byte): integer;
    function PrepareQuery_Producer(Lines: TStrings): integer;
    function PrepareQuery_Proizv(Lines: TStrings): integer;
    function PrepareQuery_Rejiser(Lines: TStrings): integer;
    function PrepareQuery_Repert_SQL(FilterMode: byte; Filter_Date: TDateTime; Filter_Zal_Kod, Filter_Repert_Kod: integer): integer;
    function PrepareQuery_Seans(Lines: TStrings): integer;
  end;
// =============================================================================
  function fchp_DataSet(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  function fchp_Film(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  function fchp_Repert(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  function fchp_Seans(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  function fchp_Zal(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
// -----------------------------------------------------------------------------
  function fchp_Tarifz_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  function fchp_Tarifpl_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
  function fchp_Zal_Map(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
// =============================================================================

var
  dm: Tdm;

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uDatamod_DEBUG}
  {$UNDEF uDatamod_SQL_DEBUG}
{$ENDIF}

uses
  Bugger,
  BDE,
  uTools,
  uAddon,
  uFilm,
  uGenre,
  uPerson,
  uProizv,
  uRepert,
  uSeans,
  uTarifpl,
  uTarifz;

{$R *.DFM}

// -----------------------------------------------------------------------------
procedure Tdm.DatamoduleCreate(Sender: TObject);
const
  ProcName: string = 'Tdm.DatamoduleCreate';
var
  i: integer;
begin
  // --------------------------------------------------------------------------
  // 1.1) Создание алиаса базы
  // --------------------------------------------------------------------------
{!$IFDEF uDatamod_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TDBDataset) then
      with Components[i] as TDBDataset do
      begin
        Active := false;
        DatabaseName := db.DatabaseName;
      end;
  end;
{!$IFDEF uDatamod_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Tables is closed.');
{!$ENDIF}
  with Session do
  begin
    ConfigMode := cmSession;
    try
      try
        AddStandardAlias(db.AliasName, ExtractFilePath(ParamStr(0)) + Data_Sub_Dir, Data_DriverName);
{!$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Alias with Name "' + db.AliasName + '" is added.');
        DEBUGMess(0, '[' + ProcName + ']: Path is "' + ExtractFilePath(ParamStr(0)) + Data_Sub_Dir + '".');
{!$ENDIF}
      except
{!$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Error - Alias with Name "' + db.AliasName + '" is not added.');
{!$ENDIF}
      end;
    finally
      ConfigMode := cmAll;
    end;
  end;
{!$IFDEF uDatamod_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

// -----------------------------------------------------------------------------
procedure Tdm.dbAfterConnect(Sender: TObject);
const
  ProcName: string = 'Tdm.dbAfterConnect';
var
  i: integer;
begin
  // --------------------------------------------------------------------------
  // 1.2) Открытие таблиц базы
  // --------------------------------------------------------------------------
{!$IFDEF uDatamod_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TTable) then
      with Components[i] as TTable do
      try
        Active := true;
{$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Table with Name "' + TableName + '" is opened.');
{$ENDIF}
      except
{!$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Error - Table with Name "' + TableName + '" is not opened.');
{!$ENDIF}
      end;
  end;
{!$IFDEF uDatamod_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

// -----------------------------------------------------------------------------
procedure Tdm.TableAfterScroll(DataSet: TDataSet);
const
  ProcName: string = 'Tdm.TableAfterScroll';
var
  i, ti: integer;
begin
  // --------------------------------------------------------------------------
  // 
  // --------------------------------------------------------------------------
  if not DataSet.ControlsDisabled then
  begin
    ti := 0;
    for i := 1 to MaxTables do
      if TableNames_Array[i] = DataSet.Name then
        ti := i;
{
  'tFilm',     // #_1
  'tGenre',    // #_2
  'tPerson',   // #_3
  'tPlace',    // #_4
  'tProizv',   // #_5
  'tRepert',   // #_6
  'tSeans',    // #_7
  'tTarifet',  // #_8
  'tTarifpl',  // #_9
  'tTarifz',   // #_10
  'tTicket',   // #_11
  'tUzver',    // #_12
  'tZal'       // #_13 
}
    case ti of
    1: if Assigned(fmFilm) then
         fmFilm.Film_Track_Rec; // ok
    2: if Assigned(fmGenre) then
         fmGenre.Genre_Track_Rec; // ok
    3: if Assigned(fmPerson) and fmPerson.Visible then
         fmPerson.Person_Track_Rec; // ok
    4: {if Assigned(fmPlace) then
         fmPlace.Place_Track_Rec}; // ok
    5: if Assigned(fmProizv) then
         fmProizv.Proizv_Track_Rec; // ok
    6: if Assigned(fmRepert) then
         fmRepert.Repert_Track_Rec; // ok
    7: if Assigned(fmSeans) then
         fmSeans.Seans_Track_Rec; // ok
    8: {if Assigned(fmTarifet) then
         fmTarifet.Tarifet_Track_Rec}; // ok
    9: if Assigned(fmTarifpl) then
         fmTarifpl.Tarifpl_Track_Rec; // ok
    10: if Assigned(fmTarifz) then
         fmTarifz.Tarifz_Track_Rec; // ok
    11: {if Assigned(fmTicket) then
         fmTicket.Ticket_Track_Rec}; // ok
    12: {if Assigned(fmUzver) then
         fmUzver.Uzver_Track_Rec}; // ok
    13: {if Assigned(fmZal) then
         fmZal.Zal_Track_Rec}; // ok
    else
    end;
  end;
end;

// -----------------------------------------------------------------------------
function Tdm.Table_Add_GenKod(Table: TTable; FieldName: string; var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Table_Add_GenKod';
var
  MaxKod, tmp: integer;
  oldFiltered: boolean;
  oldFilter: string;
begin
  // --------------------------------------------------------------------------
  // Генератор автоинкремента ключевого поля
  // --------------------------------------------------------------------------
{$IFDEF uDatamod_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  Result := -1;
  if Assigned(Table) and (length(FieldName) > 0) then
  begin
{$IFDEF uDatamod_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Table.Name is "' + Table.Name + '"');
    DEBUGMess(0, '[' + ProcName + ']: FieldName is "' + FieldName + '"');
{$ENDIF}
    with Table do
    if Active then
      try
        DisableControls;
        oldFilter := Filter;
        oldFiltered := Filtered;
        Filtered := false;
        Filter := '';
        First;
        MaxKod := 0;
        while not Eof do
        begin
          try
            tmp := FieldByName(FieldName).AsInteger;
          except
            tmp := 0;
          end;
          if tmp > MaxKod then
            MaxKod := tmp;
          Next;
        end;
        Kod := MaxKod + 1;
        Filter := oldFilter;
        Filtered := oldFiltered;
        Result := 0; // all done
{$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: AutoInc value is (' + IntToStr(Kod) + ')');
{$ENDIF}
      finally
        EnableControls;
      end
    else
{$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Error - Table is NOT ACTIVE.');
{$ENDIF}
      ;
  end;
{$IFDEF uDatamod_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

// -----------------------------------------------------------------------------
function Tdm.Table_CheckCanDel(Table: TTable; Kod_FieldName, Tag_FieldName: string; Kod: integer): integer;
const
  ProcName: string = 'Tdm.Table_CheckCanDel';
begin
  // --------------------------------------------------------------------------
  // Проверка на удаляемость
  // --------------------------------------------------------------------------
{$IFDEF uDatamod_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  Result := -1;
  if Assigned(Table) and (length(Kod_FieldName) > 0) and (length(Tag_FieldName) > 0) then
  begin
{$IFDEF uDatamod_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Table.Name is "' + Table.Name + '"');
    DEBUGMess(0, '[' + ProcName + ']: Kod_FieldName is "' + Kod_FieldName + '"');
    DEBUGMess(0, '[' + ProcName + ']: Tag_FieldName is "' + Tag_FieldName + '"');
{$ENDIF}
    with Table do
    if Active then
    begin
      if (FieldByName(Kod_FieldName).AsString = IntToStr(Kod)) and
        (FieldByName(Tag_FieldName).AsInteger = 0) then
      begin
        Result := 0; // all done
      end
      else
        Result := 1; //wrong field values
{$IFDEF uDatamod_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Result = ' + IntToStr(Result));
{$ENDIF}
    end
    else
{$IFDEF uDatamod_DEBUG}
        DEBUGMess(0, '[' + ProcName + ']: Error - Table is NOT ACTIVE.');
{$ENDIF}
      ;
  end;
{$IFDEF uDatamod_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

// -----------------------------------------------------------------------------
function Tdm.Film_Add(var Kod: integer; Nam :string; Film_Genre, Film_Rejiser, Film_Producer, Film_Proizv: integer): integer;
const
  ProcName: string = 'Tdm.Film_Add';
begin
  // ready
  Result := -1;
  with tFilm do
    if Active then
    if (rt_Can_Add1 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Last;
        if not Locate(s_Film_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Film_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Film_Nam).AsString := Nam;
          FieldByName(s_Film_Genre).AsString := IntToStr(Film_Genre);
          FieldByName(s_Film_Rejiser).AsString := IntToStr(Film_Rejiser);
          FieldByName(s_Film_Producer).AsString := IntToStr(Film_Producer);
          FieldByName(s_Film_Proizv).AsString := IntToStr(Film_Proizv);
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Film_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Film_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tFilm, s_Film_Kod, Kod);
end;

function Tdm.Film_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Film_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tFilm, s_Film_Kod, s_Film_TAG, Kod);
end;

function Tdm.Film_Del(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Film_Del';
begin
  // ready
  Result := -1;
  with tFilm do
    if Active then
    if (rt_Can_Del1 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Film_Kod, Kod, []) then
        begin
          if FieldByName(s_Film_Nam).AsString = Nam then
            case Film_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Film_Edit(Kod: integer; Nam :string; Film_Genre, Film_Rejiser, Film_Producer, Film_Proizv: integer): integer;
const
  ProcName: string = 'Tdm.Film_Edit';
begin
  // ready
  Result := -1;
  with tFilm do
    if Active then
    if (rt_Can_Edit1 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        if Locate(s_Film_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Film_Nam).AsString := Nam;
          FieldByName(s_Film_Genre).AsString := IntToStr(Film_Genre);
          FieldByName(s_Film_Rejiser).AsString := IntToStr(Film_Rejiser);
          FieldByName(s_Film_Producer).AsString := IntToStr(Film_Producer);
          FieldByName(s_Film_Proizv).AsString := IntToStr(Film_Proizv);
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Film_Track(var Kod, Nam :string; var Film_Genre, Film_Rejiser, Film_Producer, Film_Proizv: integer): integer;
const
  ProcName: string = 'Tdm.Film_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Nam := '';
  Film_Genre := 0;
  Film_Rejiser := 0;
  Film_Producer := 0;
  Film_Proizv := 0;
  with tFilm do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Film_Kod).AsString;
        Nam := FieldByName(s_Film_Nam).AsString;
        Film_Genre := FieldByName(s_Film_Genre).AsInteger;
        Film_Rejiser := FieldByName(s_Film_Rejiser).AsInteger;
        Film_Producer := FieldByName(s_Film_Producer).AsInteger;
        Film_Proizv := FieldByName(s_Film_Proizv).AsInteger;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
function Tdm.Genre_Add(var Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Genre_Add';
begin
  // ready
  Result := -1;
  with tGenre do
    if Active then
    if (rt_Can_Add2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Last;
        if not Locate(s_Genre_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Genre_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Genre_Nam).AsString := Nam;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights 
end;

function Tdm.Genre_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Genre_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tGenre, s_Genre_Kod, Kod);
end;

function Tdm.Genre_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Genre_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tGenre, s_Genre_Kod, s_Genre_TAG, Kod);
end;

function Tdm.Genre_Del(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Genre_Del';
begin
  // ready
  Result := -1;
  with tGenre do
    if Active then
    if (rt_Can_Del2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;                                             
        Result := 2; // not found
        if Locate(s_Genre_Kod, Kod, []) then
        begin
          if FieldByName(s_Genre_Nam).AsString = Nam then
            case Genre_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Genre_Edit(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Genre_Edit';
begin
  // ready
  Result := -1;
  with tGenre do
    if Active then
    if (rt_Can_Edit2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        if Locate(s_Genre_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Genre_Nam).AsString := Nam;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Genre_Track(var Kod, Nam: string): integer;
const
  ProcName: string = 'Tdm.Genre_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Nam := '';
  with tGenre do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Genre_Kod).AsString;
        Nam := FieldByName(s_Genre_Nam).AsString;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
function Tdm.Person_Add(var Kod: integer; Nam_Sh, Nam_Ful :string; IsReji, IsProd: boolean): integer;
const
  ProcName: string = 'Tdm.Person_Add';
begin
  // ready
  Result := -1;
  with tPerson do
    if Active then
    if (rt_Can_Add2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam_Sh) <> 0) and (length(Nam_Ful) <> 0) and (IsReji or IsProd) then
      try
        DisableControls;
        Last;
        if not Locate(s_Person_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Person_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Person_Nam_SH).AsString := Nam_Sh;
          FieldByName(s_Person_Nam_FUL).AsString := Nam_Ful;
          FieldByName(s_Person_Is_Rejiser).AsBoolean := IsReji;
          FieldByName(s_Person_Is_Producer).AsBoolean := IsProd;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights 
end;

function Tdm.Person_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Person_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tPerson, s_Person_Kod, Kod);
end;

function Tdm.Person_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Person_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tPerson, s_Person_Kod, s_Person_TAG, Kod);
end;

function Tdm.Person_Del(Kod: integer; Nam_Sh: string): integer;
const
  ProcName: string = 'Tdm.Person_Del';
begin
  // ready
  Result := -1;
  with tPerson do
    if Active then
    if (rt_Can_Del2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam_Sh) <> 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Person_Kod, Kod, []) then
        begin
          if FieldByName(s_Person_Nam_SH).AsString = Nam_Sh then
            case Person_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Person_Edit(Kod: integer; Nam_Sh, Nam_Ful :string; IsReji, IsProd: boolean): integer;
const
  ProcName: string = 'Tdm.Person_Edit';
begin
  // ready
  Result := -1;
  with tPerson do
    if Active then
    if (rt_Can_Edit2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam_Sh) <> 0) then
      try
        DisableControls;
        if Locate(s_Person_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Person_Nam_SH).AsString := Nam_Sh;
          FieldByName(s_Person_Is_Rejiser).AsBoolean := IsReji;
          FieldByName(s_Person_Is_Producer).AsBoolean := IsProd;
          FieldByName(s_Person_Nam_FUL).AsString := Nam_Ful;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Person_Track(var Kod, Nam_Sh, Nam_Ful :string; var IsReji, IsProd: boolean): integer;
const
  ProcName: string = 'Tdm.Person_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Nam_Sh := '';
  Nam_Ful := '';
  IsReji := false;
  IsProd := false;
  with tPerson do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Person_Kod).AsString;
        Nam_Sh := FieldByName(s_Person_Nam_SH).AsString;
        Nam_Ful := FieldByName(s_Person_Nam_FUL).AsString;
        IsReji := FieldByName(s_Person_Is_Rejiser).AsBoolean;
        IsProd := FieldByName(s_Person_Is_Producer).AsBoolean;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
function Tdm.Proizv_Add(var Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Proizv_Add';
begin
  // ready
  Result := -1;
  with tProizv do
    if Active then
    if (rt_Can_Add2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Last;
        if not Locate(s_Proizv_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Proizv_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Proizv_Nam).AsString := Nam;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Proizv_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Proizv_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tProizv, s_Proizv_Kod, Kod);
end;

function Tdm.Proizv_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Proizv_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tProizv, s_Proizv_Kod, s_Repert_TAG, Kod);
end;

function Tdm.Proizv_Del(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Proizv_Del';
begin
  // ready
  Result := -1;
  with tProizv do
    if Active then
    if (rt_Can_Del2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Proizv_Kod, Kod, []) then
        begin
          if FieldByName(s_Proizv_Nam).AsString = Nam then
            case Proizv_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Proizv_Edit(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Proizv_Edit';
begin
  // ready
  Result := -1;
  with tProizv do
    if Active then
    if (rt_Can_Edit2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        if Locate(s_Proizv_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Proizv_Nam).AsString := Nam;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Proizv_Track(var Kod, Nam: string): integer;
const
  ProcName: string = 'Tdm.Proizv_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Nam := '';
  with tProizv do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Proizv_Kod).AsString;
        Nam := FieldByName(s_Proizv_Nam).AsString;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
function Tdm.Seans_Add(var Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
const
  ProcName: string = 'Tdm.Seans_Add';
begin
  // ready
  Result := -1;
  with tSeans do
    if Active then
    if (rt_Can_Add2 in PrgRights) then
    begin
      if (Kod > 0) and (Seans_Hour >= 0) and (Seans_Hour < 24) and (Seans_Minute >= 0) and (Seans_Minute < 60) then
      try
        DisableControls;
        Last;
        if not Locate(s_Seans_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Seans_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Seans_HOUR).AsString := IntToStr(Seans_Hour);
          FieldByName(s_Seans_MINUTE).AsString := IntToStr(Seans_Minute);
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Seans_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Seans_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tSeans, s_Seans_Kod, Kod);
end;

function Tdm.Seans_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Seans_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tSeans, s_Seans_Kod, s_Seans_TAG, Kod);
end;

function Tdm.Seans_Del(Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
const
  ProcName: string = 'Tdm.Seans_Del';
begin
  // ready
  Result := -1;
  with tSeans do
    if Active then
    if (rt_Can_Del2 in PrgRights) then
    begin
      if (Kod > 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Seans_Kod, Kod, []) then
        begin
          if (FieldByName(s_Seans_HOUR).AsString = IntToStr(Seans_Hour))
            and (FieldByName(s_Seans_MINUTE).AsString = IntToStr(Seans_Minute)) then
            case Seans_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Seans_Edit(Kod: integer; Seans_Hour, Seans_Minute: integer): integer;
const
  ProcName: string = 'Tdm.Seans_Edit';
begin
  // ready
  Result := -1;
  with tSeans do
    if Active then
    if (rt_Can_Edit2 in PrgRights) then
    begin
      if (Kod > 0) and (Seans_Hour >= 0) and (Seans_Hour < 24) and (Seans_Minute >= 0) and (Seans_Minute < 60) then
      try
        DisableControls;
        if Locate(s_Seans_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Seans_HOUR).AsString := IntToStr(Seans_Hour);
          FieldByName(s_Seans_MINUTE).AsString := IntToStr(Seans_Minute);
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Seans_Track(var Kod, Seans_Hour, Seans_Minute: string): integer;
const
  ProcName: string = 'Tdm.Seans_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Seans_Hour := '0';
  Seans_Minute := '0';
  with tSeans do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Seans_Kod).AsString;
        Seans_Hour := FieldByName(s_Seans_HOUR).AsString;
        Seans_Minute := FieldByName(s_Seans_MINUTE).AsString;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// =============================================================================
// -----------------------------------------------------------------------------
function fchp_DataSet(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_DataSet';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    _Nam := DataSet.FieldByName(s_DataSet_Nam).AsString;
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Tarifpl_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Tarifpl_Desc';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
  // --------------------------------------------------------------------------
  // Загрузка типа билета из запроса
  // --------------------------------------------------------------------------
    Load_Tarifpl_Desc(DataSet, _Kod);
  // --------------------------------------------------------------------------
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Tarifz_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Tarifet_Desc';
var
  _Tarifet, _Tarifpl, _Cost: Integer;
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    // _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    _Tarifet := DataSet.FieldByName(s_Tarifz_ET).AsInteger;
    _Tarifpl := DataSet.FieldByName(s_Tarifz_PL).AsInteger;
    _Cost := DataSet.FieldByName(s_Tarifz_COST).AsInteger;
  // --------------------------------------------------------------------------
  // Загрузка типа билета из запроса
  // --------------------------------------------------------------------------
    Load_Tarifet_Desc(DataSet, _Tarifet, _Tarifpl, _Cost);
  // --------------------------------------------------------------------------
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Seans(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Seans';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    _Nam := FixFmt(DataSet.FieldByName(s_Seans_HOUR).AsInteger, 2, '0') + ':' + FixFmt(DataSet.FieldByName(s_Seans_MINUTE).AsInteger, 2, '0');
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Film(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Film';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    _Nam := DataSet.FieldByName(s_DataSet_Nam).AsString + ' (' + DataSet.FieldByName(s_Film_LEN).AsString + ' min.)';
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Zal(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Zal';
var
  Recs: integer;
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    Recs := 0;
    with dm.tPlace do
      if Active then
        begin
          DisableControls;
          Filtered := false;
          Filter := '(' + s_Place_Zal + ' = ' + IntToStr(_Kod) + ')';
          Filtered := true;
          Recs := RecordCount;
          Filtered := false;
          Filter := '';
          First;
          EnableControls;
        end;
    _Nam := DataSet.FieldByName(s_DataSet_Nam).AsString + ' (' + IntToStr(Recs) + ' мест) - ' + DataSet.FieldByName(s_Zal_CINEMA).AsString;
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Zal_Map(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Zal_Map';
begin
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса (2) Текущая запись
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса
  // --------------------------------------------------------------------------
    Load_Zal_Map(_Kod);
  // --------------------------------------------------------------------------
    Result := true;
  except
  end;
end;
// -----------------------------------------------------------------------------

function fchp_Repert(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var _Kod: integer; var _Nam: string): boolean;
const
  ProcName: string = 'fchp_Repert';
var
  str_DATE, str_Seans, str_Film, str_Zal:string;
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and DataSet.Active then
  try
    _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    if (Dataset is TQuery) then
    begin
      DateSeparator := '.';
      str_DATE := DateToStr(Dataset.FieldByName(s_Repert_DATE).AsDateTime);
      str_Seans := FixFmt(Dataset.FieldByName(s_Seans_HOUR).AsInteger, 2, '0') + ':' + FixFmt(Dataset.FieldByName(s_Seans_MINUTE).AsInteger, 2, '0');
      str_Film := Dataset.FieldByName(s_Film_Nam).AsString + ' (' + Dataset.FieldByName(s_Film_LEN).AsString + ' мин.) - ' + IntToStr(_Kod);
      str_Zal := Dataset.FieldByName(s_Zal_Nam).AsString + '-' + Dataset.FieldByName(s_Zal_CINEMA).AsString;
      _Nam := '[' + str_Seans + '] - ' + str_Film;
    end
    else
      _Nam := 'unknown';
    Result := true;
  except
  end;
end;
// =============================================================================
// -----------------------------------------------------------------------------
function Tdm.Combo_Load_DataSet(DataSet: TDataSet; Lines: TStrings; s_DataSet_Kod, s_DataSet_Nam: string; Combo_Load_HandleProc: TCombo_Load_HandleProc): integer;
const
  ProcName: string = 'Tdm.Combo_Load_DataSet';
var
  Kod: integer;
  Nam: string;
begin
  // --------------------------------------------------------------------------
  // Цикл загрузки записей из запроса
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[Combo_Load_DataSet]: ->');
  Result := 0;
  if Assigned(DataSet) {and Assigned(Lines)} then
  with DataSet do
  begin
    if Assigned(Lines) then
      try
        Lines.Clear;
      except
        DEBUGMess(0, '[Combo_Load_DataSet]: Error - Lines is not null but cannot be cleared.');
      end;
    DEBUGMess(0, '[Combo_Load_DataSet]: DataSet.Name is (' + DataSet.Name + ').');
    if not Active then
    try
      DEBUGMess(0, '[Combo_Load_DataSet]: DataSet is not opened. Try to open.');
      Open;
    except
      DEBUGMess(0, '[Combo_Load_DataSet]: Error - Opening DataSet is failed.');
    end;
    if Active then
    try
      DisableControls;
      if (Dataset is TQuery) then
        if not (Dataset as TQuery).UniDirectional then
          First;
      DEBUGMess(0, '[Combo_Load_DataSet]: Start cycle...');
      while not Eof do
      begin
        Kod := -1;
        Nam := '<error>';
        if Assigned(Combo_Load_HandleProc) then
          if Combo_Load_HandleProc(DataSet, s_DataSet_Kod, s_DataSet_Nam, Kod, Nam) then
            if Assigned(Lines) then
              try
                Lines.AddObject(Nam, TObject(Kod));
              except
              end;
        Next;
      end;
      DEBUGMess(0, '[Combo_Load_DataSet]: Finish cycle...');
      if (Dataset is TQuery) then
        if not (Dataset as TQuery).UniDirectional then
          First;
      EnableControls;
    except
    end;
  end
  else
    DEBUGMess(0, '[Combo_Load_DataSet]: Error - DataSet is null.');
  DEBUGMess(-1, '[Combo_Load_DataSet]: <-');
end;
// =============================================================================
// -----------------------------------------------------------------------------
function Tdm.Combo_Load_Genre(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Genre';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Genre_Kod, s_Genre_Nam, fchp_DataSet);
end;

// -----------------------------------------------------------------------------
function Tdm.Combo_Load_Proizv(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Proizv';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Proizv_Kod, s_Proizv_Nam, fchp_DataSet);
end;

// -----------------------------------------------------------------------------
function Tdm.Combo_Load_Person(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Person';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Person_Kod, s_Person_Nam_SH, fchp_DataSet);
end;

function Tdm.Combo_Load_Tarifet(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Tarifet';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Tarifet_Kod, s_Tarifet_Nam, fchp_DataSet);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Tarifz_Desc(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Tarifet_Desc';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Tarifet_Kod, s_Tarifet_Nam, fchp_Tarifz_Desc);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Tarifpl(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Tarifpl';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
//  Result := Combo_Load_DataSet(DataSet, Lines, s_Tarifpl_Kod, s_Tarifpl_Nam, fchp_Tarifpl);
  Result := Combo_Load_DataSet(DataSet, Lines, s_Tarifpl_Kod, s_Tarifpl_Nam, fchp_DataSet);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Tarifpl_Desc(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Tarifpl_Desc';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Tarifpl_Kod, s_Tarifpl_Nam, fchp_Tarifpl_Desc);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Seans(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Seans';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Seans_Kod, 'foo', fchp_Seans);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Film(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Film';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Film_Kod, s_Film_Nam, fchp_Film);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Zal(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Zal';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Zal_Kod, s_Zal_Nam, fchp_Zal);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Zal_Map(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Zal_Map';
begin
  // --------------------------------------------------------------------------
  // Загрузка залов из запроса
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Zal_Kod, s_Zal_Nam, fchp_Zal_Map);
end;
// -----------------------------------------------------------------------------

function Tdm.Combo_Load_Repert(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.Combo_Load_Repert';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_Repert_Kod, 'foo', fchp_Repert);
end;
// -----------------------------------------------------------------------------

function Tdm.Topogr_Add(var Kod: integer; Seans_Hour,
  Seans_Minute: integer): integer;
const
  ProcName: string = 'Tdm.Topogr_Add';
begin
  Result := 1;
end;

function Tdm.Topogr_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Topogr_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tPlace, s_Place_Kod, Kod);
end;

function Tdm.Topogr_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Topogr_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tPlace, s_Place_Kod, s_Place_TAG, Kod);
end;

function Tdm.Topogr_Del(Kod, Seans_Hour,
  Seans_Minute: integer): integer;
const
  ProcName: string = 'Tdm.Topogr_Del';
begin
  Result := 1;
end;

function Tdm.Topogr_Edit(Kod, Seans_Hour,
  Seans_Minute: integer): integer;
const
  ProcName: string = 'Tdm.Topogr_Edit';
begin
  Result := 1;
end;

function Tdm.Topogr_Track(var Kod, Seans_Hour,
  Seans_Minute: string): integer;
const
  ProcName: string = 'Tdm.Topogr_Track';
begin
  Result := 1;
end;
// -----------------------------------------------------------------------------

function Tdm.Tarifz_Add(var Kod: integer; _Pl, _Set, _Cost :integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_Add';
begin
  Result := 1;
end;

function Tdm.Tarifz_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tTarifz, s_Tarifz_Kod, Kod);
end;

function Tdm.Tarifz_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tTarifz, s_Tarifz_Kod, s_Tarifz_TAG, Kod);
end;

function Tdm.Tarifz_CheckCanChange(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_CheckCanChange';
begin
  // Ready
  Result := 0;
end;

function Tdm.Tarifz_Del(Kod: integer; _Cost :integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_Del';
begin
  //
  Result := 1;
end;

function Tdm.Tarifz_Edit(Kod: integer; _Pl, _Set, _Cost :integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_Edit';
begin
  // ready
  Result := -1;
  with tTarifz do
    if Active then
    if (rt_Can_Edit1 in PrgRights) then
    begin
      if (Kod > 0) and (_Cost > 0) then
      begin
        case Tarifz_CheckCanChange(Kod) of
        0:
        try
          DisableControls;
          if Locate(s_Tarifz_Kod, Kod, []) then
            try
              Edit;
//              FieldByName(s_Tarifz_PL).AsInteger := _Pl;
//              FieldByName(s_Tarifz_ET).AsInteger := _Set;
              FieldByName(s_Tarifz_COST).AsInteger := _Cost;
              Post;
              Result := 0; // all done
            except
              Cancel;
              Result := 3; // write data error
            end // try
          else // if
            Result := 2; // not found
        finally
          EnableControls;
        end; // try
        1:;
        end; // case
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifz_Track(var Kod: string; var _Tarifpl, _Cost: integer): integer;
const
  ProcName: string = 'Tdm.Tarifz_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  _Cost := 0;
  with tTarifz do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Tarifz_Kod).AsString;
        _Tarifpl := FieldByName(s_Tarifz_PL).AsInteger;
        _Cost := FieldByName(s_Tarifz_COST).AsInteger;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
function Tdm.Tarifpl_Add(var Kod: integer; Nam :string; _Print, _Free, _Report, _Show, _Sys: boolean; _Type, _BgColor, _FntColor: integer): integer;
const
  ProcName: string = 'Tdm.Tarifpl_Add';
begin
  // ready
  Result := -1;
  with tTarifpl do
    if Active then
    if (rt_Can_Add2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) and (_Print or _Free or _Report or _Show) then
      try
        DisableControls;
        Last;
        if not Locate(s_Tarifpl_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Tarifpl_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Tarifpl_Nam).AsString := Nam;
          FieldByName(s_Tarifpl_PRINT).AsBoolean := _Print;
          FieldByName(s_Tarifpl_FREE).AsBoolean := _Free;
          FieldByName(s_Tarifpl_REPORT).AsBoolean := _Report;
          FieldByName(s_Tarifpl_SHOW).AsBoolean := _Show;
          FieldByName(s_Tarifpl_SYS).AsBoolean := _Sys;
          FieldByName(s_Tarifpl_TYPE).AsInteger := _Type;
          FieldByName(s_Tarifpl_BGCOLOR).AsInteger := _BgColor;
          FieldByName(s_Tarifpl_FNTCOLOR).AsInteger := _FntColor;
//          FieldByName(s_Tarifpl_TAG).AsInteger := _Tag;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifpl_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifpl_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tTarifpl, s_Tarifpl_Kod, Kod);
end;

function Tdm.Tarifpl_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifpl_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tTarifpl, s_Tarifpl_Kod, s_Tarifpl_TAG, Kod);
end;

function Tdm.Tarifpl_Del(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Tarifpl_Del';
begin
  // ready
  Result := -1;
  with tTarifpl do
    if Active then
    if (rt_Can_Del2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Tarifpl_Kod, Kod, []) then
        begin
          if FieldByName(s_Tarifpl_Nam).AsString = Nam then
            case Tarifpl_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifpl_Edit(Kod: integer; Nam :string; _Print, _Free, _Report, _Show, _Sys: boolean; _Type, _BgColor, _FntColor: integer): Integer;
const
  ProcName: string = 'Tdm.Tarifpl_Edit';
begin
  // ready
  Result := -1;
  with tTarifpl do
    if Active then
    if (rt_Can_Edit2 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        if Locate(s_Tarifpl_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Tarifpl_Nam).AsString := Nam;
          FieldByName(s_Tarifpl_PRINT).AsBoolean := _Print;
          FieldByName(s_Tarifpl_FREE).AsBoolean := _Free;
          FieldByName(s_Tarifpl_REPORT).AsBoolean := _Report;
          FieldByName(s_Tarifpl_SHOW).AsBoolean := _Show;
          FieldByName(s_Tarifpl_SYS).AsBoolean := _Sys;
          FieldByName(s_Tarifpl_TYPE).AsInteger := _Type;
          FieldByName(s_Tarifpl_BGCOLOR).AsInteger := _BgColor;
          FieldByName(s_Tarifpl_FNTCOLOR).AsInteger := _FntColor;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifpl_Track(var Kod, Nam: string; var _Print, _Free, _Report, _Show, _Sys: boolean; var _Type, _BgColor, _FntColor: integer): Integer;
const
  ProcName: string = 'Tdm.Tarifpl_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Nam := '';
  _Print := false;
  _Free := false;
  _Report := false;
  _Show := false;
  _Sys := false;
  _BgColor := clWhite;
  _FntColor := clBlack;
  with tTarifpl do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Tarifpl_Kod).AsString;
        Nam := FieldByName(s_Tarifpl_Nam).AsString;
        _Print := FieldByName(s_Tarifpl_PRINT).AsBoolean;
        _Free := FieldByName(s_Tarifpl_FREE).AsBoolean;
        _Report := FieldByName(s_Tarifpl_REPORT).AsBoolean;
        _Show := FieldByName(s_Tarifpl_SHOW).AsBoolean;
        _Sys := FieldByName(s_Tarifpl_SYS).AsBoolean;
        _Type := FieldByName(s_Tarifpl_TYPE).AsInteger;
        _BgColor := FieldByName(s_Tarifpl_BGCOLOR).AsInteger;
        _FntColor := FieldByName(s_Tarifpl_FNTCOLOR).AsInteger;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;
// -----------------------------------------------------------------------------
function Tdm.Tarifet_Add(var Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Tarifet_Add';
begin
  // ready
  Result := -1;
  with tTarifet do
    if Active then
    if (rt_Can_Add1 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Last;
        if not Locate(s_Tarifet_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Tarifet_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Tarifet_Nam).AsString := Nam;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifet_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifet_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tTarifet, s_Tarifet_Kod, Kod);
end;

function Tdm.Tarifet_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Tarifet_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tTarifet, s_Tarifet_Kod, s_Tarifet_TAG, Kod);
end;

function Tdm.Tarifet_Del(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Tarifet_Del';
begin
  // ready
  Result := -1;
  with tTarifet do
    if Active then
    if (rt_Can_Del1 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Tarifet_Kod, Kod, []) then
        begin
          if FieldByName(s_Tarifet_Nam).AsString = Nam then
            case Tarifet_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifet_Edit(Kod: integer; Nam: string): integer;
const
  ProcName: string = 'Tdm.Tarifet_Edit';
begin
  // ready
  Result := -1;
  with tTarifet do
    if Active then
    if (rt_Can_Edit1 in PrgRights) then
    begin
      if (Kod > 0) and (length(Nam) <> 0) then
      try
        DisableControls;
        if Locate(s_Tarifet_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Tarifet_Nam).AsString := Nam;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Tarifet_Track(var Kod, Nam: string): integer;
const
  ProcName: string = 'Tdm.Tarifet_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  Nam := '';
  with tTarifet do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Tarifet_Kod).AsString;
        Nam := FieldByName(s_Tarifet_Nam).AsString;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
function Tdm.Ticket_Add(var Kod: integer; _Tarifpl, _Repert, _Row, _Column, _State, _Owner: Integer; _DateTime: TDateTime; _Restored: Boolean): Integer;
const
  ProcName: string = 'Tdm.Ticket_Add';
begin
  // ready
  Result := -1;
  with tTicket do
    if Active then
    if (rt_Can_Sell in PrgRights) then
    begin
      if (_Tarifpl > 0) and (_Repert > 0) and (_Row > 0)
        and (_Column > 0) and (_State in [0, 1, 2, 3, 4])
        and (_Owner > 0) then
      try
        DisableControls;
        Last;
        if not Locate(s_Ticket_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Ticket_TARIFPL).AsInteger := _Tarifpl;
          FieldByName(s_Ticket_REPERT).AsInteger := _Repert;
          FieldByName(s_Ticket_ROW).AsInteger := _Row;
          FieldByName(s_Ticket_COLUMN).AsInteger := _Column;
          FieldByName(s_Ticket_DATE).AsDateTime := _DateTime;
          FieldByName(s_Ticket_TIME).AsDateTime := _DateTime;
          FieldByName(s_Ticket_STATE).AsInteger := _State;
          FieldByName(s_Ticket_OWNER).AsInteger := _Owner;
          FieldByName(s_Ticket_RESTORED).AsBoolean := _Restored;
          FieldByName(s_Ticket_TAG).AsInteger := 1;
          Post;
          Kod := FieldByName(s_Ticket_Kod).AsInteger;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

{
function Tdm.Ticket_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Ticket_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tTicket, s_Ticket_Kod, Kod);
end;
}

function Tdm.Ticket_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Ticket_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tTicket, s_Ticket_Kod, s_Ticket_TAG, Kod);
end;

function Tdm.Ticket_Del(Kod: integer; _Repert: integer): integer;
const
  ProcName: string = 'Tdm.Ticket_Del';
begin
  // ready
  Result := -1;
  with tTicket do
    if Active then
    if (rt_Can_Root in PrgRights) then
    begin
      if (Kod > 0) and (_Repert > 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Ticket_Kod, Kod, []) then
        begin
          if FieldByName(s_Ticket_REPERT).AsInteger = _Repert then
            case Ticket_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Ticket_Edit(Kod: integer; _Tarifpl, _Repert, _Row, _Column, _State, _Owner: Integer; _DateTime: TDateTime; _Restored: Boolean): Integer;
const
  ProcName: string = 'Tdm.Ticket_Edit';
begin
  // ready
  Result := -1;
  with tTicket do
    if Active then
    if (rt_Can_Sell in PrgRights) then
    begin
      if (Kod > 0) and (_Tarifpl > 0)
        and (_Repert > 0) and (_Row > 0)
        and (_Column > 0) and (_State in [0, 1, 2, 3, 4])
        and (_Owner > 0) then
      try
        DisableControls;
        if Locate(s_Ticket_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Ticket_TARIFPL).AsInteger := _Tarifpl;
          FieldByName(s_Ticket_REPERT).AsInteger := _Repert;
          FieldByName(s_Ticket_ROW).AsInteger := _Row;
          FieldByName(s_Ticket_COLUMN).AsInteger := _Column;
          FieldByName(s_Ticket_DATE).AsDateTime := _DateTime;
          FieldByName(s_Ticket_TIME).AsDateTime := _DateTime;
          FieldByName(s_Ticket_STATE).AsInteger := _State;
          FieldByName(s_Ticket_OWNER).AsInteger := _Owner;
          FieldByName(s_Ticket_RESTORED).AsBoolean := _Restored;
          FieldByName(s_Ticket_TAG).AsInteger := FieldByName(s_Ticket_TAG).AsInteger + 1;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Ticket_Restore(Kod: integer; _Repert: Integer; _Restored: Boolean): Integer;
const
  ProcName: string = 'Tdm.Ticket_Restore';
begin
  // ready
  Result := -1;
  with tTicket do
    if Active then
    if (rt_Can_Sell in PrgRights) then
    begin
      if (Kod > 0) and (_Repert > 0) then
      try
        DisableControls;
        if Locate(s_Ticket_Kod, Kod, []) then
        try
          Edit;
          if FieldByName(s_Ticket_STATE).AsInteger = 3 then
            FieldByName(s_Ticket_STATE).AsInteger := 1
          else
            FieldByName(s_Ticket_RESTORED).AsBoolean := _Restored;
          FieldByName(s_Ticket_TAG).AsInteger := FieldByName(s_Ticket_TAG).AsInteger + 1;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

// -----------------------------------------------------------------------------
function Tdm.Repert_Add(var Kod: integer; _Date: TDateTime; _Seans, _Film, _Tarifet, _Zal: integer): integer;
const
  ProcName: string = 'Tdm.Repert_Add';
begin
  // ready
  Result := -1;
  with tRepert do
    if Active then
    if (rt_Can_Add1 in PrgRights) then
    begin
      if (Kod > 0) and (_Date >= Date) then
      try
        DisableControls;
        Last;
        if not Locate(s_Repert_Kod, Kod, []) then
        try
          Append;
          FieldByName(s_Repert_Kod).AsString := IntToStr(Kod);
          FieldByName(s_Repert_DATE).AsDateTime := _Date;
          FieldByName(s_Repert_Seans).AsInteger := _Seans;
          FieldByName(s_Repert_Film).AsInteger := _Film;
          FieldByName(s_Repert_Tarifet).AsInteger := _Tarifet;
          FieldByName(s_Repert_Zal).AsInteger := _Zal;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 4; // already exist
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Repert_Add_GenKod(var Kod: integer): integer;
const
  ProcName: string = 'Tdm.Repert_Add_GenKod';
begin
  // Ready
  Result := Table_Add_GenKod(tRepert, s_Repert_Kod, Kod);
end;

function Tdm.Repert_CheckCanDel(Kod: integer): integer;
const
  ProcName: string = 'Tdm.Repert_CheckCanDel';
begin
  // Ready
  Result := Table_CheckCanDel(tRepert, s_Repert_Kod, s_Repert_TAG, Kod);
end;

function Tdm.Repert_Del(Kod: integer; _Date: TDateTime; _Seans: integer): integer;
const
  ProcName: string = 'Tdm.Repert_Del';
begin
  // ready
  Result := -1;
  with tRepert do
    if Active then
    if (rt_Can_Del1 in PrgRights) then
    begin
      if (Kod > 0) then
      try
        DisableControls;
        Result := 2; // not found
        if Locate(s_Repert_Kod, Kod, []) then
        begin
          if (FieldByName(s_Repert_DATE).AsDateTime = _Date)
            and (FieldByName(s_Repert_Seans).AsInteger = _Seans) then
            case Repert_CheckCanDel(Kod) of
            0:
              try
                Delete;
                Result := 0; // all done
              except
                Result := 3; // write data error
              end;
            1:;
            end;
        end;
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Repert_Edit(Kod: integer; _Date: TDateTime; _Seans, _Film, _Tarifet, _Zal: integer): integer;
const
  ProcName: string = 'Tdm.Repert_Edit';
begin
  // ready
  Result := -1;
  with tRepert do
    if Active then
    if (rt_Can_Edit1 in PrgRights) then
    begin
      if (Kod > 0) and (_Date >= Date) then
      try
        DisableControls;
        if Locate(s_Repert_Kod, Kod, []) then
        try
          Edit;
          FieldByName(s_Repert_DATE).AsDateTime := _Date;
          FieldByName(s_Repert_Seans).AsInteger := _Seans;
          FieldByName(s_Repert_Film).AsInteger := _Film;
          FieldByName(s_Repert_Tarifet).AsInteger := _Tarifet;
          FieldByName(s_Repert_Zal).AsInteger := _Zal;
          Post;
          Result := 0; // all done
        except
          Cancel;
          Result := 3; // write data error
        end
        else
          Result := 2; // not found
      finally
        EnableControls;
      end
      else
        Result := 1; //wrong field values
    end
    else
      Result := 6; // not enough rights
end;

function Tdm.Repert_Track(var Kod: string; var _Date: TDateTime; var _Seans, _Film, _Tarifet, _Zal: integer): integer;
const
  ProcName: string = 'Tdm.Repert_Track';
begin
  // ready
  Result := 0;
  Kod := Kod_auto;
  _Date := Date;
  _Seans := 0;
  _Film := 0;
  _Tarifet := 0;
  _Zal := 0;
  with tRepert do
    if Active then
    try
      if RecordCount > 0 then
      begin
        Kod := FieldByName(s_Repert_Kod).AsString;
        _Date := FieldByName(s_Repert_DATE).AsDateTime;
        _Seans := FieldByName(s_Repert_Seans).AsInteger;
        _Film := FieldByName(s_Repert_Film).AsInteger;
        _Tarifet := FieldByName(s_Repert_Tarifet).AsInteger;
        _Zal := FieldByName(s_Repert_Zal).AsInteger;
      end
      else
        Result := 1;
    except
      Result := 5;
    end
    else
      Result := -1;
end;

// -----------------------------------------------------------------------------
procedure Tdm.tSeansCalcFields(DataSet: TDataSet);
const
  ProcName: string = 'Tdm.tSeansCalcFields';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DataSet.FieldByName('_Seans').AsString := FixFmt(DataSet.FieldByName(s_Seans_HOUR).AsInteger, 2, '0') + ':' + FixFmt(DataSet.FieldByName(s_Seans_MINUTE).AsInteger, 2, '0');
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

procedure Tdm.Table_Filter(Table: TTable; FilterString: string; _Controls_Disabled: boolean);
const
  ProcName: string = 'Tdm.Table_Filter';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  with Table do
  begin
    if _Controls_Disabled then
      DisableControls
    else
      EnableControls;
    Filtered := false;
    Filter := FilterString;
    Filtered := true;
    First;
  end;
end;

procedure Tdm.Table_UnFilter(Table: TTable; _Controls_Enabled: boolean);
const
  ProcName: string = 'Tdm._Table_UnFilter';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  with Table do
  begin
    Filtered := false;
    Filter := '';
    First;
    if _Controls_Enabled then
      EnableControls
    else
      DisableControls;
  end;
end;

function Tdm._Table_Locate(Table: TTable; const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
const
  ProcName: string = 'Tdm._Table_Locate';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  with Table do
  begin
    DisableControls;
    First;
    if Locate(KeyFields, KeyValues, Options) then
      Result := true;
  end;
end;

procedure Tdm._Table_UnLocate(Table: TTable);
const
  ProcName: string = 'Tdm._Table_UnLocate';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  with Table do
  begin
    First;
    EnableControls;
  end;
end;

function Tdm.PrepareQuery_Tarifet_SQL(FilterMode: byte; Filter_Tarifet_Kod: integer; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Tarifet_SQL';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qTarifet do
  begin
    Close;
    SQL.Clear;
{
// fields count = 3
SELECT
 TARIFET_KOD,
 TARIFET_NAM,
 TARIFET_TAG
 FROM "TARIFET.DB" Tarifet
 WHERE TARIFET_KOD = '1'
}
    DEBUGMess(0, '[' + ProcName + ']: FilterMode is (' + IntToStr(FilterMode) + ')');
    case FilterMode of
    1:
      DEBUGMess(0, '[' + ProcName + ']: Filter_Tarifet_Kod is (' + IntToStr(Filter_Tarifet_Kod) + ')');
    else
    end;
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Tarifet_Kod + ',');
    SQL.Add(' ' + s_Tarifet_Nam + ',');
    SQL.Add(' ' + s_Tarifet_TAG + ' ');
    SQL.Add(format(' FROM "%s" Tarifet', [tTarifet.TableName]));
    case FilterMode of
    1:
      SQL.Add(format(' WHERE  ' + s_Tarifet_Kod + ' = ' + Kav + '%u' + Kav, [Filter_Tarifet_Kod]));
    else
    end;
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    case FilterMode of
    1, 2: Result := length(SQL.Text);
    else
      UniDirectional := true;
      Open;
{}
      Result := RecordCount;
      Combo_Load_Tarifet(qTarifet, Lines);
      DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
      Close;
      UniDirectional := false;
    end;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Tarifpl_SQL(FilterMode: byte; Filter_Tarifpl_Kod: integer; Filter_Tarifpl_Free: boolean; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Tarifpl_SQL';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qTarifpl do
  begin
    Close;
    SQL.Clear;
{
// fields count = 11
SELECT
 TARIFPL_KOD,
 TARIFPL_NAM,
 TARIFPL_PRINT,
 TARIFPL_REPORT,
 TARIFPL_FREE,
 TARIFPL_SHOW,
 TARIFPL_SYS,
 TARIFPL_TYPE,
 TARIFPL_BGCOLOR,
 TARIFPL_FNTCOLOR,
 TARIFPL_TAG
 FROM "TARIFPL.DB" Tarifpl
 ORDER BY TARIFPL_SYS, TARIFPL_FREE, TARIFPL_TYPE, TARIFPL_KOD
}
    DEBUGMess(0, '[' + ProcName + ']: FilterMode is (' + IntToStr(FilterMode) + ')');
    case FilterMode of
    2, 3:
      DEBUGMess(0, '[' + ProcName + ']: Filter_Tarifpl_Free is (' + FALSE_OR_TRUE[Filter_Tarifpl_Free] + ')');
    4:
      DEBUGMess(0, '[' + ProcName + ']: Filter_Tarifpl_Kod is (' + IntToStr(Filter_Tarifpl_Kod) + ')');
    else
    end;
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Tarifpl_Kod + ',');
    SQL.Add(' ' + s_Tarifpl_Nam + ',');
    SQL.Add(' ' + s_Tarifpl_PRINT + ',');
    SQL.Add(' ' + s_Tarifpl_REPORT + ',');
    SQL.Add(' ' + s_Tarifpl_FREE + ',');
    SQL.Add(' ' + s_Tarifpl_SHOW + ',');
    SQL.Add(' ' + s_Tarifpl_SYS + ',');
    SQL.Add(' ' + s_Tarifpl_TYPE + ',');
    SQL.Add(' ' + s_Tarifpl_BGCOLOR + ',');
    SQL.Add(' ' + s_Tarifpl_FNTCOLOR + ',');
    SQL.Add(' ' + s_Tarifpl_TAG + ' ');
    SQL.Add(format(' FROM "%s" Tarifpl', [tTarifpl.TableName]));
    case FilterMode of
    2, 3:
      SQL.Add(format(' WHERE (%s = %s)', [s_Tarifpl_FREE, FALSE_OR_TRUE[Filter_Tarifpl_Free]]));
    4:
      SQL.Add(format(' WHERE (%s = %u)', [s_Tarifpl_Kod, Filter_Tarifpl_Kod]));
    else
    end;
    SQL.Add(format(' ORDER BY %s, %s, %s, %s', [s_Tarifpl_SYS, s_Tarifpl_FREE, s_Tarifpl_TYPE, s_Tarifpl_KOD]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    case FilterMode of
    1, 3, 4:
    begin
      Result := length(SQL.Text);
    end;
    else
      UniDirectional := true;
      Open;
{}
      Result := RecordCount;
      Combo_Load_Tarifpl(qTarifpl, Lines);
      DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
      Close;
      UniDirectional := false;
    end;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Seans(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Seans';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qSeans do
  begin
    Close;
    SQL.Clear;
{
SELECT
 SEANS_KOD,
 SEANS_HOUR,
 SEANS_MINUTE,
 SEANS_TAG
 FROM "SEANS.DB" Seans
}
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Seans_Kod + ',');
    SQL.Add(' ' + s_Seans_HOUR + ',');
    SQL.Add(' ' + s_Seans_MINUTE + ',');
    SQL.Add(' ' + s_Seans_TAG + ' ');
    SQL.Add(format(' FROM "%s" Seans', [tSeans.TableName]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    UniDirectional := true;
    Open;
{}
    Result := RecordCount;
    Combo_Load_Seans(qSeans, Lines);
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Film(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Film';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qFilm do
  begin
    Close;
    SQL.Clear;
{
SELECT
 FILM_KOD,
 FILM_NAM,
 FILM_LEN,
 FILM_START,
 FILM_FINISH,
 FILM_GENRE,
 FILM_REJISER,
 FILM_PRODUCER,
 FILM_PROIZV,
 FILM_TAG
 FROM "FILM.DB" Film
 ORDER BY FILM_START, FILM_NAM
}
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Film_Kod + ',');
    SQL.Add(' ' + s_Film_Nam + ',');
    SQL.Add(' ' + s_Film_LEN + ',');
    SQL.Add(' ' + s_Film_START + ',');
    SQL.Add(' ' + s_Film_FINISH + ',');
    SQL.Add(' ' + s_Film_Genre + ',');
    SQL.Add(' ' + s_Film_Rejiser + ',');
    SQL.Add(' ' + s_Film_Producer + ',');
    SQL.Add(' ' + s_Film_Proizv + ',');
    SQL.Add(' ' + s_Film_TAG + ' ');
    SQL.Add(format(' FROM "%s" Film', [tFilm.TableName]));
    SQL.Add(format(' ORDER BY %s, %s', [s_Film_START, s_Film_Nam]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    UniDirectional := true;
    Open;
{}
    Result := RecordCount;
    Combo_Load_Film(qFilm, Lines);
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Zal(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Zal';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qZal do
  begin
    Close;
    SQL.Clear;
{
SELECT 
 ZAL_KOD,
 ZAL_NAM, 
 ZAL_CINEMA, 
 ZAL_EMBLEMA, 
 ZAL_TAG
 FROM "ZAL.DB" Zal
}
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Zal_Kod + ',');
    SQL.Add(' ' + s_Zal_Nam + ',');
    SQL.Add(' ' + s_Zal_CINEMA + ',');
    SQL.Add(' ' + s_Zal_EMBLEMA + ',');
    SQL.Add(' ' + s_Zal_TAG + ' ');
    SQL.Add(format(' FROM "%s" Zal', [tZal.TableName]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    UniDirectional := true;
    Open;
{}
    Result := RecordCount;
    Combo_Load_Zal(qZal, Lines);
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Genre(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Genre';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qGenre do
  begin
    Close;
    SQL.Clear;
{
SELECT
 GENRE_KOD,
 GENRE_NAM,
 GENRE_TAG
 FROM "GENRE.DB" Genre
}
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Genre_Kod + ',');
    SQL.Add(' ' + s_Genre_Nam + ',');
    SQL.Add(' ' + s_Genre_TAG + ' ');
    SQL.Add(format(' FROM "%s" Genre', [tGenre.TableName]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    UniDirectional := true;
    Open;
{}
    Result := RecordCount;
    Combo_Load_Genre(qGenre, Lines);
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Person(Lines: TStrings; FilterMode: byte): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Person';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qPerson do
  begin
    Close;
    SQL.Clear;
{
SELECT
 PERSON_KOD,
 PERSON_NAM_SH,
 PERSON_IS_REJISER,
 PERSON_IS_PRODUCER,
 PERSON_NAM_FUL,
 PERSON_TAG
 FROM "PERSON.DB" Person
 WHERE (PERSON_IS_REJISER = TRUE)
 ORDER BY PERSON_NAM_SH, PERSON_NAM_FUL, PERSON_IS_REJISER, PERSON_IS_PRODUCER
}
    DEBUGMess(0, '[' + ProcName + ']: FilterMode is (' + IntToStr(FilterMode) + ')');
    case FilterMode of
    1, 2:
      DEBUGMess(0, '[' + ProcName + ']: FilterByRejiser is (' + FALSE_OR_TRUE[FilterMode = 1] + ')');
    else
    end;
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Person_Kod + ',');
    SQL.Add(' ' + s_Person_Nam_SH + ',');
    SQL.Add(' ' + s_Person_Is_Rejiser + ',');
    SQL.Add(' ' + s_Person_Is_Producer + ',');
    SQL.Add(' ' + s_Person_Nam_FUL + ',');
    SQL.Add(' ' + s_Person_TAG + ' ');
    SQL.Add(format(' FROM "%s" Person', [tPerson.TableName]));
    case FilterMode of
    1: SQL.Add(format(' WHERE (%s = TRUE)', [s_Person_Is_Rejiser]));
    2: SQL.Add(format(' WHERE (%s = TRUE)', [s_Person_Is_Producer]));
    else
    end;
    SQL.Add(format(' ORDER BY %s, %s, %s', [s_Person_Nam_SH, s_Person_Nam_FUL, s_Person_Is_Rejiser, s_Person_Is_Producer]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    UniDirectional := true;
    Open;
{}
    Result := RecordCount;
    Combo_Load_Person(qPerson, Lines);
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Rejiser(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Rejiser';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := PrepareQuery_Person(Lines, 1);
end;

function Tdm.PrepareQuery_Producer(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Producer';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := PrepareQuery_Person(Lines, 2);
end;

function Tdm.PrepareQuery_Proizv(Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Proizv';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qProizv do
  begin
    Close;
    SQL.Clear;
{
SELECT
 PROIZV_KOD,
 PROIZV_NAM,
 PROIZV_TAG
 FROM "PROIZV.DB" Proizv
}
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Proizv_Kod + ',');
    SQL.Add(' ' + s_Proizv_Nam + ',');
    SQL.Add(' ' + s_Proizv_TAG + ' ');
    SQL.Add(format(' FROM "%s" Proizv', [tProizv.TableName]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    UniDirectional := true;
    Open;
{}
    Result := RecordCount;
    Combo_Load_Proizv(qProizv, Lines);
    DEBUGMess(0, '[' + ProcName + ']: RecordCount = ' + IntToStr(RecordCount));
{}
    Close;
    UniDirectional := false;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Repert_SQL(FilterMode: byte; Filter_Date: TDateTime; Filter_Zal_Kod, Filter_Repert_Kod: integer): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Repert_SQL';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qRepert do
  begin
    qRepert.Close;
    qRepert.SQL.Clear;
{
SELECT
 Repert.REPERT_KOD,
 Repert.REPERT_DATE,
 Repert.REPERT_SEANS,
 Repert.REPERT_FILM,
 Repert.REPERT_TARIFET,
 Repert.REPERT_ZAL,
 Repert.REPERT_TAG,
 Seans.SEANS_HOUR,
 Seans.SEANS_MINUTE,
 Film.FILM_NAM,
 Film.FILM_LEN,
 Zal.ZAL_NAM,
 Zal.ZAL_CINEMA
 FROM "REPERT.DB" Repert
   INNER JOIN "SEANS.DB" Seans
   ON  (Seans.SEANS_KOD = Repert.REPERT_SEANS)
   INNER JOIN "FILM.DB" Film
   ON  (Film.FILM_KOD = Repert.REPERT_FILM)
   INNER JOIN "ZAL.DB" Zal
   ON  (Zal.ZAL_KOD = Repert.REPERT_ZAL)
 WHERE  (Repert.REPERT_DATE = '09/23/2002')
   AND (Zal.ZAL_KOD = 1)
 ORDER BY Repert.REPERT_SEANS, Repert.REPERT_ZAL
}
    DEBUGMess(0, '[' + ProcName + ']: FilterMode is (' + IntToStr(FilterMode) + ')');
    case FilterMode of
    1:
    begin
      DateSeparator := '/';
      DEBUGMess(0, '[' + ProcName + ']: Filter_Date is (' + FormatDateTime('mm/dd/yyyy', Filter_Date) + ')');
      DEBUGMess(0, '[' + ProcName + ']: Filter_Zal_Kod is (' + IntToStr(Filter_Zal_Kod) + ')');
      DateSeparator := '/';
    end;
    2:
      DEBUGMess(0, '[' + ProcName + ']: Filter_Repert_Kod is (' + IntToStr(Filter_Repert_Kod) + ')');
    else
    end;
    SQL.Add('SELECT');
    SQL.Add(' Repert.' + s_Repert_Kod + ',');
    SQL.Add(' Repert.' + s_Repert_DATE + ',');
    SQL.Add(' Repert.' + s_Repert_Seans + ',');
    SQL.Add(' Repert.' + s_Repert_Film + ',');
    SQL.Add(' Repert.' + s_Repert_Tarifet + ',');
    SQL.Add(' Repert.' + s_Repert_Zal + ',');
    SQL.Add(' Repert.' + s_Repert_TAG + ',');
    SQL.Add(' Seans.' + s_Seans_HOUR + ',');
    SQL.Add(' Seans.' + s_Seans_MINUTE + ',');
    SQL.Add(' Film.' + s_Film_Nam + ',');
    SQL.Add(' Film.' + s_Film_LEN + ',');
    SQL.Add(' Zal.' + s_Zal_Nam + ',');
    SQL.Add(' Zal.' + s_Zal_CINEMA + ',');
    SQL.Add(' Tarifet.' + s_Tarifet_Nam + ' ');
    SQL.Add(format(' FROM "%s" Repert', [tRepert.TableName]));
    SQL.Add(format('   INNER JOIN "%s" Seans', [tSeans.TableName]));
    SQL.Add('   ON  (Seans.' + s_Seans_Kod + ' = Repert.' + s_Repert_Seans + ')');
    SQL.Add(format('   INNER JOIN "%s" Film', [tFilm.TableName]));
    SQL.Add('   ON  (Film.' + s_Film_Kod + ' = Repert.' + s_Repert_Film + ')');
    SQL.Add(format('   INNER JOIN "%s" Zal', [tZal.TableName]));
    SQL.Add('   ON  (Zal.' + s_Zal_Kod + ' = Repert.' + s_Repert_Zal + ')');
    SQL.Add(format('   INNER JOIN "%s" Tarifet', [tTarifet.TableName]));
    SQL.Add('   ON  (Tarifet.' + s_Tarifet_Kod + ' = Repert.' + s_Repert_Tarifet + ')');
    case FilterMode of
    1:
    begin
      DateSeparator := '/';
      SQL.Add(format(' WHERE  Repert.' + s_Repert_DATE + ' = ' + Kav + '%s' + Kav, [FormatDateTime('mm/dd/yyyy', Filter_Date)]));
      SQL.Add(format('   AND (Zal.' + s_Zal_Kod + ' = %u)', [Filter_Zal_Kod]));
    end;
    2:
    begin
      SQL.Add(format(' WHERE  Repert.' + s_Repert_Kod + ' = ' + Kav + '%u' + Kav, [Filter_Repert_Kod]));
    end;
    else
    end;
    SQL.Add(' ORDER BY Repert.' + s_Repert_Seans + ', Repert.' + s_Repert_Zal + '');
    SQL.Add('');
    Result := length(SQL.Text); 
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Tarifz_SQL(FilterMode: byte;
  Filter_Tarifz_Kod, Filter_Tarifz_ET: integer; Lines: TStrings): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Tarifz_SQL';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qTarifz do
  begin
    Close;
    SQL.Clear;
{
// fields count = 5
SELECT
 Tarifz.TARIFZ_KOD,
 Tarifz.TARIFZ_ET,
 Tarifz.TARIFZ_PL,
 Tarifz.TARIFZ_COST,
 Tarifz.TARIFZ_TAG, 
 Tarifet.TARIFET_NAM, 
 Tarifpl.TARIFPL_NAM,
 Tarifpl.TARIFPL_PRINT,
 Tarifpl.TARIFPL_REPORT,
 Tarifpl.TARIFPL_FREE,
 Tarifpl.TARIFPL_SHOW,
 Tarifpl.TARIFPL_BGCOLOR,
 Tarifpl.TARIFPL_FNTCOLOR,
 Tarifpl.TARIFPL_TYPE,
 Tarifpl.TARIFPL_TAG
 FROM "TARIFZ.DB" Tarifz
	INNER JOIN "TARIFET.DB" Tarifet
	ON  (Tarifet.TARIFET_KOD = Tarifz.TARIFZ_ET)
	INNER JOIN "TARIFPL.DB" Tarifpl
	ON  (Tarifpl.TARIFPL_KOD = Tarifz.TARIFZ_PL)
 WHERE  Tarifz.TARIFZ_ET = 1
 ORDER BY Tarifz.TARIFZ_ET, Tarifz.TARIFZ_PL, Tarifpl.TARIFPL_FREE, Tarifpl.TARIFPL_TYPE
}
{
// Filter_Mode = 4
SELECT
 Tarifz.TARIFZ_KOD,
 Tarifz.TARIFZ_ET,
 Tarifz.TARIFZ_PL,
 Tarifz.TARIFZ_COST,
 Tarifz.TARIFZ_TAG, 
 Tarifet.TARIFET_NAM, 
 Tarifpl.TARIFPL_NAM
 FROM "TARIFZ.DB" Tarifz
	INNER JOIN "TARIFET.DB" Tarifet
	ON  (Tarifet.TARIFET_KOD = Tarifz.TARIFZ_ET)
	INNER JOIN "TARIFPL.DB" Tarifpl
	ON  (Tarifpl.TARIFPL_KOD = Tarifz.TARIFZ_PL)
 ORDER BY Tarifz.TARIFZ_ET, Tarifz.TARIFZ_PL
}
    DEBUGMess(0, '[' + ProcName + ']: FilterMode is (' + IntToStr(FilterMode) + ')');
    case FilterMode of
    1:
      DEBUGMess(0, '[' + ProcName + ']: Filter_Tarifz_Kod is (' + IntToStr(Filter_Tarifz_Kod) + ')');
    2:
      DEBUGMess(0, '[' + ProcName + ']: Filter_Tarifz_ET is (' + IntToStr(Filter_Tarifz_ET) + ')');
    else
    end;
    SQL.Add('SELECT');
    SQL.Add(' Tarifz.' + s_Tarifz_Kod + ',');
    SQL.Add(' Tarifz.' + s_Tarifz_ET + ',');
    SQL.Add(' Tarifz.' + s_Tarifz_PL + ',');
    SQL.Add(' Tarifz.' + s_Tarifz_COST + ',');
    SQL.Add(' Tarifz.' + s_Tarifz_TAG + ',');
    //
    SQL.Add(' Tarifet.' + s_Tarifet_Nam + ',');
    //
    if FilterMode in [0, 1, 2, 3] then
    begin
      SQL.Add(' Tarifpl.' + s_Tarifpl_Nam + ',');
      //
      SQL.Add(' Tarifpl.' + s_Tarifpl_PRINT + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_REPORT + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_FREE + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_SHOW + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_SYS + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_TYPE + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_BGCOLOR + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_FNTCOLOR + ',');
      SQL.Add(' Tarifpl.' + s_Tarifpl_TAG + ' ');
    end
    else
      if FilterMode = 4 then
        SQL.Add(' Tarifpl.' + s_Tarifpl_Nam + ' ');
    SQL.Add(format(' FROM "%s" Tarifz', [tTarifz.TableName]));
    SQL.Add(format('   INNER JOIN "%s" Tarifet', [tTarifet.TableName]));
    SQL.Add('   ON  (Tarifet.' + s_Tarifet_Kod + ' = Tarifz.' + s_Tarifz_ET + ')');
    SQL.Add(format('   INNER JOIN "%s" Tarifpl', [tTarifpl.TableName]));
    SQL.Add('   ON  (Tarifpl.' + s_Tarifpl_Kod + ' = Tarifz.' + s_Tarifz_PL + ')');
    case FilterMode of
    1:
      SQL.Add(format(' WHERE  Tarifz.' + s_Tarifz_Kod + ' = ' + Kav + '%u' + Kav, [Filter_Tarifz_Kod]));
    2:
      SQL.Add(format(' WHERE  Tarifz.' + s_Tarifz_ET + ' = ' + Kav + '%u' + Kav, [Filter_Tarifz_ET]));
    else
    end;
    if FilterMode in [0, 1, 2, 3] then
      SQL.Add(format(' ORDER BY Tarifz.%s, Tarifz.%s, Tarifpl.%s, Tarifpl.%s', [s_Tarifz_ET, s_Tarifz_PL, s_Tarifpl_FREE, s_Tarifpl_TYPE]))
    else
      if FilterMode = 4 then
        SQL.Add(format(' ORDER BY Tarifz.%s, Tarifz.%s', [s_Tarifz_ET, s_Tarifz_PL]));
    SQL.Add('');
    {$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {$ENDIF}
    case FilterMode of
    1, 2, 3, 4:
      Result := length(SQL.Text);
    else
      UniDirectional := true;
      Open;
{}
      Result := RecordCount;
{      Combo_Load_Tarifet(qTarifz, Lines);}
      DEBUGMess(0, '[' + ProcName + ']: Lines.Count = ' + IntToStr(Lines.Count) + '; RecordCount = ' + IntToStr(RecordCount));
{}
      Close;
      UniDirectional := false;
    end;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

function Tdm.PrepareQuery_Ticket_SQL(FilterMode: byte;
  Filter_Ticket_REPERT: Integer; Filter_Ticket_Tarifpl_Set: SetByte): integer;
const
  ProcName: string = 'Tdm.PrepareQuery_Ticket_SQL';
var
  i: Byte;
  s: string;
begin
  // --------------------------------------------------------------------------
  // Билеты
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Result := -1;
  if db.Connected then
  with qTicket do
  begin
    Close;
    SQL.Clear;
{
// fields count = 11
SELECT
  TICKET_KOD,
  TICKET_TARIFPL,
  TICKET_REPERT,
  TICKET_ROW,
  TICKET_COLUMN,
  TICKET_DATE,
  TICKET_TIME,
  TICKET_STATE,
  TICKET_OWNER,
  TICKET_RESTORED,
  TICKET_TAG
 FROM "TICKET.DB" Ticket
 WHERE
  (TICKET_REPERT = 1)
  AND (TICKET_RESTORED = FALSE)
  AND TICKET_TARIFPL NOT IN (16, 17, 18, 19)

   INNER JOIN "TARIFET.DB" Tarifet
   ON  (Tarifet.TARIFET_KOD = Tarifz.TARIFZ_ET)
   INNER JOIN "TARIFPL.DB" Tarifpl
   ON  (Tarifpl.TARIFPL_KOD = Tarifz.TARIFZ_PL)
 WHERE  Tarifz.TARIFZ_ET = 1
 ORDER BY Tarifz.TARIFZ_ET, Tarifz.TARIFZ_PL, Tarifpl.TARIFPL_FREE, Tarifpl.TARIFPL_TYPE
}
    DEBUGMess(0, '[' + ProcName + ']: FilterMode is (' + IntToStr(FilterMode) + ')');
    case FilterMode of
    1:
      DEBUGMess(0, '[' + ProcName + ']: s_Ticket_REPERT is (' + IntToStr(Filter_Ticket_REPERT) + ')');
    else
    end;
    SQL.Add('SELECT');
    SQL.Add(' ' + s_Ticket_Kod + ',');
    SQL.Add(' ' + s_Ticket_TARIFPL + ',');
    SQL.Add(' ' + s_Ticket_REPERT + ',');
    SQL.Add(' ' + s_Ticket_ROW + ',');
    SQL.Add(' ' + s_Ticket_COLUMN + ',');
    SQL.Add(' ' + s_Ticket_DATE + ',');
    SQL.Add(' ' + s_Ticket_TIME + ',');
    SQL.Add(' ' + s_Ticket_STATE + ',');
    SQL.Add(' ' + s_Ticket_OWNER + ',');
    SQL.Add(' ' + s_Ticket_RESTORED + ',');
    SQL.Add(' ' + s_Ticket_TAG + ' ');
    SQL.Add(format(' FROM "%s" Ticket', [tTicket.TableName]));
//    SQL.Add(format('   INNER JOIN "%s" Tarifet', [tTarifet.TableName]));
//    SQL.Add('   ON  (Tarifet.' + s_Tarifet_Kod + ' = Ticket.' + s_Ticket_ET + ')');
//    SQL.Add(format('   INNER JOIN "%s" Tarifpl', [tTarifpl.TableName]));
//    SQL.Add('   ON  (Tarifpl.' + s_Tarifpl_Kod + ' = Ticket.' + s_Ticket_PL + ')');
    case FilterMode of
    1:
    begin
      SQL.Add(format(' WHERE (%s = %u)', [s_Ticket_REPERT, Filter_Ticket_REPERT]));
      SQL.Add(format('  AND (%s = FALSE)', [s_Ticket_RESTORED]));
      if Filter_Ticket_Tarifpl_Set <> [] then
      begin
        s := '';
        for i := 1 to 255 do
          if (i in Filter_Ticket_Tarifpl_Set) then
            s := s + IntToStr(i) + ',';
        SetLength(s, Length(s) - 1);
        DEBUGMess(0, '[' + ProcName + ']: SysTypes = (' + s + ')');
        SQL.Add(format('  AND %s NOT in (%s)', [s_Ticket_TARIFPL, s]));
      end;
    end;
    else
    end;
    SQL.Add(format(' ORDER BY %s, %s', [s_Ticket_ROW, s_Ticket_COLUMN]));
    SQL.Add('');
    {!$IFDEF uDatamod_SQL_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: SQL.Text(' + IntToStr(length(SQL.Text)) + ') is [' + CRLF + SQL.Text + ']');
    {!$ENDIF}
    case FilterMode of
    1:
      Result := length(SQL.Text);
    else
      UniDirectional := true;
      Open;
{}
      Result := RecordCount;
{}
      Close;
      UniDirectional := false;
    end;
  end
  else
    DEBUGMess(0, '[' + ProcName + ']: Error - Database not connected.');
  DEBUGMess(0, '[' + ProcName + ']: Result = (' + IntToStr(Result) + ')');  
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

procedure Tdm.TableAfterPost(DataSet: TDataSet);
begin
  if (DataSet is TTable) then
    DbiSaveChanges((DataSet as TTable).Handle);
end;

{$IFDEF uDatamod_DEBUG}
initialization
  DEBUGMess(0, 'uDatamod.Init');
{$ENDIF}

{$IFDEF uDatamod_DEBUG}
finalization
  DEBUGMess(0, 'uDatamod.Final');
{$ENDIF}

end.
