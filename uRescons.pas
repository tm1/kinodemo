{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uRescons.pas
Version      : 15.10.2002 9:03:30
Description  : 
Creation     : 12.10.2002 9:03:30
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uRescons;

interface

uses
  Bugger,
  Classes,
  ShpCtrl;

type
  SetByte = set of Byte;
  TTicketAction = (taClear, taPrepare, taRestore, taReserve, taPrint, taPosTerminal, taPrintOneTicket, taFixCheq, taQueue);
  TNtiCmdType = (ntNothing, ntTrack, ntClear, ntClearAll, ntPrepare, ntRestore, ntReserve, ntSave, ntQueue);
  TNetCmd_Srv = (ncsUnknown, ncsNone, ncsQuit, ncsAuthLogin, ncsData, ncsOKAnswer, ncsERRAnswer, ncsHost);
  TNetCmd_Clt = (nccUnknown, nccNone, nccQuit, nccBroadcast, nccOKAnswer, nccERRAnswer, nccPing);
  TPrgRightsEnum = (rt_Can_Add1, rt_Can_Edit1, rt_Can_Del1, rt_Can_Add2, rt_Can_Edit2, rt_Can_Del2, rt_Can_Sell, rt_Can_Root);
  TPrgRightsSet = set of TPrgRightsEnum;

  TTicketRec = record
    tr_Row, tr_Column: Byte;
    tr_Selected, tr_Tracked: Boolean;
    TC_State: TTC_State;
    tr_Kod, tr_Tarifpl, tr_Repert, tr_Owner: Integer;
  end;

const
  About_Mess: string = 'Demo Kino';
  Srv_Mess: string = 'DemoX 1.0.4.x server';
  XR_Key: string = 'thE-mOthErfUckEr';
  Print_ModuleName: string = 'Print1c';
  Reg_BasePath: string = '\Software\Home(R)\KinoZal\1.0';
  Version_Block: string = '\\StringFileInfo\\041904E3';
  rgLeft: string = 'Left';
  rgTop: string = 'Top';
  rgWidth: string = 'Width';
  rgHeight: string = 'Height';
  rgMaximized: string = 'Maximized';
//  MinWidth: integer = 320;
//  MinHeight: integer = 200;
  clUserOrange: integer = $6AB5FF;
  PrgRights: TPrgRightsSet = [rt_Can_Sell];
  DataBase_Opened: byte = 0;
  s_Lock_FileName: string = 'lock.hdb';
  s_AppHandle: string = 'AppHandle';
  s_MainFmHandle: string = 'MainFmHandle';
  s_DateStamp: string ='DateStamp';
  s_TimeStamp: string = 'TimeStamp';
  s_StampFile_Delim: string = '=';
// -----------------------------------------------------------------------------
  // TNetCmd_Clt = (nccUnknown, nccNone, nccQuit, nccBroadcast, nccOKAnswer, nccERRAnswer, nccPing);
  NET_CMD_Clt_Array: array [TNetCmd_Clt] of string =
  (
  '',
  ' #;)',
  'EXIT',
  'BCST',
  '+OK^',
  '-ERR',
  'PING'
  );
  // TNetCmd_Srv = (ncsUnknown, ncsNone, ncsQuit, ncsAuthLogin, ncsData, ncsOKAnswer, ncsERRAnswer, ncsHost);
  NET_CMD_Srv_Array: array [TNetCmd_Srv] of string =
  (
  '',
  ' &;)',
  'QUIT',
  'AUTH',
  'DATA',
  '+ACK',
  '-RST',
  'HOST'
  );
// -----------------------------------------------------------------------------
  NTI_DLMT: Char = '.';
  NTI_CMD_Array: array [TNtiCmdType] of string =
  (
  '',
  'TRCK',
  'CLR1',
  'CLAL',
  'PREP',
  'RSTR',
  'RSRV',
  'SAVE',
  'QUED'
  );
// -----------------------------------------------------------------------------
  _tne: Boolean = False;
  _tnq: Boolean = True;
//  Server_Mode: Byte = 0;
//  ClientConnPresent: Boolean = False;
  Server_IP: string = '127.0.0.1';
// -----------------------------------------------------------------------------
  CellWidth: integer = 5;
  CellHeight: integer = 5;
  DeltaWidth: integer = 1;
  DeltaHeight: integer = 1;
  MarginWidth: integer = 5;
  MarginHeight: integer = 5;
  MultiplrMini: real = 2;
  MultiplrTopo: real = 5;
  MultiplrMain: real = 5.7;
// -----------------------------------------------------------------------------
  _Zal_Prefix: string = 'AL';
  _Serial: integer = 0;
  _Print_Serial: boolean = false;
  Show_All_Info: Boolean = False;
  MaxBase_Place_Type = $10000;
  Max1_Place_Type: integer = MaxBase_Place_Type + 1;
  Max2_Place_Type: integer = MaxBase_Place_Type + 2;
  Max3_Place_Type: integer = MaxBase_Place_Type + 3;
  Max4_Place_Type: integer = MaxBase_Place_Type + 4;
  Max5_Place_Type: integer = MaxBase_Place_Type + 5;
  Printed_Ticket_Count: integer = 0;
  LogSeparatorWidth: integer = 77;
  s_Valuta: string = 'тенге';
  Max_MenuText_Width: integer = 100;
// -----------------------------------------------------------------------------
// Global GFX
// -----------------------------------------------------------------------------
  Emblema_Loaded: integer = 0;
  gfx_Emblema: integer = 0;
  gfx_Address: integer = 0;
  gfx_Ryad: integer = 0;
  gfx_Mesto: integer = 0;
  gfx_Cena: integer = 0;
  gfx_Summa: integer = 0;
  gfx_Tenge: integer = 0;
  gfx_Halyava: integer = 0;
  gfx_Studpens: integer = 0;
  gfx_Detski: integer = 0;
  gfx_Priglas: integer = 0;
  gfx_Vip: integer = 0;
  gfx_Kolvomest: integer = 0;
// -----------------------------------------------------------------------------
// Local GFX
// -----------------------------------------------------------------------------
  gfx1_Filmname: integer = 0;
  gfx1_Datavremya: integer = 0;
{
  gfx_Emblema1: integer = 0;
  gfx_Emblema2: integer = 0;
  gfx_Emblema3: integer = 0;
  gfx_Emblema4: integer = 0;
  gfx_Emblema5: integer = 0;
  gfx_Emblema6: integer = 0;
  gfx_Emblema7: integer = 0;
  gfx_Emblema8: integer = 0;
  gfx_Emblema9: integer = 0;
  gfx_Emblema0: integer = 0;
}
// -----------------------------------------------------------------------------
  global_var_prefix: Char = #1;
  local_var_prefix: Char = #2;
// -----------------------------------------------------------------------------
  SBST_INVALID_SOCKET = Integer(NOT(0)); // Integer = 4 bytes
// -----------------------------------------------------------------------------
  Tab: Char = #9;
  Kav: Char = '''';
  Space: Char = ' ';
  Menu_In_Str: string = ' ::::: ';
  CarriageReturn: Char = #10;
  LineFeed: Char = #10;
  CRLF: string = #13#10;
// -----------------------------------------------------------------------------
{  CurZalList: TStrings = nil;}
  ZalList: TStrings = nil;
  TicketTypesList: TStrings = nil;
  TicketPriceList: TStrings = nil;
  TicketTypesSysSet: SetByte = [];
  TicketTypesReservedSet: SetByte = [];
  NetUserList: TStrings = nil;
  Cur_Owner: Integer = 0;
  Cur_Tarifet: Integer = 0;
// -----------------------------------------------------------------------------
  Boolean_Array: array [boolean] of string =
  (
  'Нет (No)',
  'Да (Yes)'
  );
// -----------------------------------------------------------------------------
  FALSE_OR_TRUE: array [boolean] of string =
  (
  'FALSE',
  'TRUE'
  );
  F_OR_T: array [boolean] of Char =
  (
  'F',
  'T'
  );
// -----------------------------------------------------------------------------
  EnumHS_Array: array [TEnumHS] of string =
  (
  'hsDisabled',
  'hsHybrid',
  'hsEnabled'
  );
// -----------------------------------------------------------------------------
{
  sys_SpShSt_Array: array [TTC_State] of string =
  (
  'scFree',
  'scBroken',
  'scReserved',
  'scPrepared',
  'scFixed',
  'scFixedNoCash',
  'scFixedCheq'
  );
}
// -----------------------------------------------------------------------------
// TTC_State = (scFree, scBroken, scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq);
  SpShSt_Array: array [TTC_State] of string =
  (
  'Свободно',
  'Сломано',
  'Зарезервировано',
  'Помечено для действия',
  'Продано',
  'Продано за б/н',
  'Продано`'
  );
  TC_Ch_Array: array [TTC_State] of Char =
  (
  'H',
  'B',
  'R',
  'A',
  'S',
  'T',
  'Q'
  );
// -----------------------------------------------------------------------------
// TTicketAction = (taClear, taPrepare, taRestore, taReserve, taPrint, taPosTerminal, taPrintOneTicket, taFixCheq);
  TicketAction_Array: array [TTicketAction] of string =
  (
  'Очистка',
  'Подготовка',
  'Возврат',
  'Резервирование',
  'Продажа',
  'Продажа за б/н',
  'Продажа одним билетом',
  'Продажа`',
  'Очередь'
  );
// -----------------------------------------------------------------------------
  errArray: array [-1..6] of string =
  (
  'Таблица базы не активна.',
  'Операция успешна.',
  'Неправильные значения полей записи или запрещено изменять запись.',
  'Запись с таким кодом не найдена в базе.',
  'Ошибка записи данных. Запись с таким кодом еще используется.',
  'Запись с таким кодом уже есть в базе.',
  'Неизвестная ошибка. Операция неуспешна.',
  'Недостаточно прав для выполнения операции.'
  );
// -----------------------------------------------------------------------------
  Warning_Caption: string = 'Предупреждение';
  Delete_Mess: string = 'Уверены, что хотите _УДАЛИТЬ_ запись ' + #10#13 + '(Kod = %u, Nam = "%s")?';
  Restore_Mess: string = 'Хотите вернуть билет ?' + #13#10 + '-------' + #13#10 + 'Ряд (%u) Место (%u)' + #13#10 + '-------' + #13#10 + '%s';
  Exit_Mess: string = 'Может не надо выходить ?' + #13#10 + 'Нажмите Enter(Yes), если хотите, и Escape(No), если нет.';
  Data_Sub_Dir: string = 'DATA';
  Data_DriverName: string = 'PARADOX';
// -----------------------------------------------------------------------------
  s_Total_Printed_Count: string = 'TotalPrintedCount';
  s_Print_Serial: string = 'Print_Serial';
  s_Serial_Num: string = 'SerialNum_';
// -----------------------------------------------------------------------------
  MaxTables = 13;
  TableNames_Array: array [1..MaxTables] of string =
  (
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
  );
// -----------------------------------------------------------------------------
  Kod_auto: string = 'auto';
  s_none: string = 'none';
// -----------------------------------------------------------------------------
  Film_Nam_auto: string = 'Новый фильм';                // #_1
// -----------------------------------------------------------------------------
  s_Film_Kod: string = 'FILM_KOD';                      // fld_1
  s_Film_Nam: string = 'FILM_NAM'; // 250               // fld_2
  s_Film_LEN: string = 'FILM_LEN';                      // fld_3
  s_Film_START: string = 'FILM_START';                  // fld_4
  s_Film_FINISH: string = 'FILM_FINISH';                // fld_5
  s_Film_Genre: string = 'FILM_GENRE';                  // fld_6
  s_Film_Rejiser: string = 'FILM_REJISER';              // fld_7
  s_Film_Producer: string = 'FILM_PRODUCER';            // fld_8
  s_Film_Proizv: string = 'FILM_PROIZV';                // fld_9
  s_Film_TAG: string = 'FILM_TAG';                      // fld_10
// -----------------------------------------------------------------------------
  Genre_Nam_auto: string = 'Новый жанр';                // #_2
// -----------------------------------------------------------------------------
  s_Genre_Kod: string = 'GENRE_KOD';                    // fld_1
  s_Genre_Nam: string = 'GENRE_NAM'; // 250             // fld_2
  s_Genre_TAG: string = 'GENRE_TAG';                    // fld_3
// -----------------------------------------------------------------------------
  Person_Nam_auto: string = 'Неизвестный(ая)';          // #_3
// -----------------------------------------------------------------------------
  s_Person_Kod: string = 'PERSON_KOD';                  // fld_1
  s_Person_Nam_SH: string = 'PERSON_NAM_SH'; // 40      // fld_2
  s_Person_Is_Rejiser: string = 'PERSON_IS_REJISER';    // fld_3
  s_Person_Is_Producer: string = 'PERSON_IS_PRODUCER';  // fld_4
  s_Person_Nam_FUL: string = 'PERSON_NAM_FUL'; // 250   // fld_5
  s_Person_TAG: string = 'PERSON_TAG';                  // fld_6
// -----------------------------------------------------------------------------
  Place_X_auto: string = '10';                          // #_4
  Place_Y_auto: string = '10';
// -----------------------------------------------------------------------------
  s_Place_Kod: string = 'PLACE_KOD';                    // fld_1
  s_Place_ROW: string = 'PLACE_ROW';                    // fld_2
  s_Place_COL: string = 'PLACE_COL';                    // fld_3
  s_Place_X: string = 'PLACE_X';                        // fld_4
  s_Place_Y: string = 'PLACE_Y';                        // fld_5
  s_Place_TYPE: string = 'PLACE_TYPE';                  // fld_6
  s_Place_Zal: string = 'PLACE_ZAL';                    // fld_7
  s_Place_TAG: string = 'PLACE_TAG';                    // fld_8
// -----------------------------------------------------------------------------
  Proizv_Nam_auto: string = 'Новый производитель';      // #_5
// -----------------------------------------------------------------------------
  s_Proizv_Kod: string = 'PROIZV_KOD';                  // fld_1
  s_Proizv_Nam: string = 'PROIZV_NAM'; // 250           // fld_2
  s_Proizv_TAG: string = 'PROIZV_TAG';                  // fld_3
// -----------------------------------------------------------------------------
//Repert_???_auto: string = 'Новый производитель';      // #_6
// -----------------------------------------------------------------------------
  s_Repert_Kod: string = 'REPERT_KOD';                  // fld_1
  s_Repert_DATE: string = 'REPERT_DATE';                // fld_2
  s_Repert_Seans: string = 'REPERT_SEANS';              // fld_3
  s_Repert_Film: string = 'REPERT_FILM';                // fld_4
  s_Repert_Tarifet: string = 'REPERT_TARIFET';          // fld_5
  s_Repert_Zal: string = 'REPERT_ZAL';                  // fld_6
  s_Repert_TAG: string = 'REPERT_TAG';                  // fld_7
// -----------------------------------------------------------------------------
  Seans_Hour_auto: string = '9';                        // #_7
  Seans_Minute_auto: string = '00';
// -----------------------------------------------------------------------------
  s_Seans_Kod: string = 'SEANS_KOD';                    // fld_1
  s_Seans_HOUR: string = 'SEANS_HOUR';                  // fld_2
  s_Seans_MINUTE: string = 'SEANS_MINUTE';              // fld_3
  s_Seans_TAG: string = 'SEANS_TAG';                    // fld_4
// -----------------------------------------------------------------------------
  Tarifet_Nam_auto: string = 'Базовый XXX';             // #_8
// -----------------------------------------------------------------------------
  s_Tarifet_Kod: string = 'TARIFET_KOD';                // fld_1
  s_Tarifet_Nam: string = 'TARIFET_NAM'; // 40          // fld_2
  s_Tarifet_TAG: string = 'TARIFET_TAG';                // fld_3
// -----------------------------------------------------------------------------
  Tarifpl_Nam_auto: string = 'Новый тип билета';        // #_9
// -----------------------------------------------------------------------------
  s_Tarifpl_Kod: string = 'TARIFPL_KOD';                // fld_1
  s_Tarifpl_Nam: string = 'TARIFPL_NAM'; // 40          // fld_2
  s_Tarifpl_PRINT: string = 'TARIFPL_PRINT';            // fld_3
  s_Tarifpl_REPORT: string = 'TARIFPL_REPORT';          // fld_4
  s_Tarifpl_FREE: string = 'TARIFPL_FREE';              // fld_5
  s_Tarifpl_SHOW: string = 'TARIFPL_SHOW';              // fld_6
  s_Tarifpl_SYS: string = 'TARIFPL_SYS';                // fld_7
  s_Tarifpl_TYPE: string = 'TARIFPL_TYPE';              // fld_8
  s_Tarifpl_BGCOLOR: string = 'TARIFPL_BGCOLOR';        // fld_9
  s_Tarifpl_FNTCOLOR: string = 'TARIFPL_FNTCOLOR';      // fld_10
  s_Tarifpl_TAG: string = 'TARIFPL_TAG';                // fld_11
// -----------------------------------------------------------------------------
  Tarifz_Cost_auto: integer = 100;                      // #_10
// -----------------------------------------------------------------------------
  s_Tarifz_Kod: string = 'TARIFZ_KOD';                  // fld_1
  s_Tarifz_ET: string = 'TARIFZ_ET';                    // fld_2
  s_Tarifz_PL: string = 'TARIFZ_PL';                    // fld_3
  s_Tarifz_COST: string = 'TARIFZ_COST';                // fld_4
  s_Tarifz_TAG: string = 'TARIFZ_TAG';                  // fld_5
// -----------------------------------------------------------------------------
//Ticket_???_auto: integer = 100;                       // #_11
// -----------------------------------------------------------------------------
  s_Ticket_Kod: string = 'TICKET_KOD';                  // fld_1
  s_Ticket_TARIFPL: string = 'TICKET_TARIFPL';          // fld_2
  s_Ticket_REPERT: string = 'TICKET_REPERT';            // fld_3
  s_Ticket_ROW: string = 'TICKET_ROW';                  // fld_4
  s_Ticket_COLUMN: string = 'TICKET_COLUMN';            // fld_5
  s_Ticket_DATE: string = 'TICKET_DATE';                // fld_6
  s_Ticket_TIME: string = 'TICKET_TIME';                // fld_7
  s_Ticket_STATE: string = 'TICKET_STATE';              // fld_8
  s_Ticket_OWNER: string = 'TICKET_OWNER';              // fld_9
  s_Ticket_RESTORED: string = 'TICKET_RESTORED';        // fld_10
  s_Ticket_TAG: string = 'TICKET_TAG';                  // fld_11
// -----------------------------------------------------------------------------
//Uzver_???_auto: integer = 100;                        // #_12
// -----------------------------------------------------------------------------
  s_Uzver_Kod: string = 'UZVER_KOD';                    // fld_1
  s_Uzver_Nam: string = 'UZVER_NAM'; // 40              // fld_2
  s_Uzver_HASH: string = 'UZVER_HASH'; // 192           // fld_3
  s_Uzver_RIGHTS: string = 'UZVER_RIGHTS';              // fld_4
  s_Uzver_TAG: string = 'UZVER_TAG';                    // fld_5
// -----------------------------------------------------------------------------
//Zal_???_auto: integer = 100;                          // #_13
// -----------------------------------------------------------------------------
  s_Zal_Kod: string = 'ZAL_KOD';                        // fld_1
  s_Zal_Nam: string = 'ZAL_NAM'; // 40                  // fld_2
  s_Zal_CINEMA: string = 'ZAL_CINEMA'; // 40            // fld_3
  s_Zal_EMBLEMA: string = 'ZAL_EMBLEMA';                // fld_4
  s_Zal_TAG: string = 'ZAL_TAG';                        // fld_5
// -----------------------------------------------------------------------------
//Option_???_auto: integer = 100;                       // #_14
// -----------------------------------------------------------------------------
  s_Option_Kod: string = 'OPTION_KOD';                        // fld_1
  s_Option_Nam: string = 'OPTION_NAM'; // 40                  // fld_2
  s_Option_VALUE: string = 'OPTION_VALUE'; // 250             // fld_3
  s_Option_TAG: string = 'OPTION_TAG';                        // fld_4
// -----------------------------------------------------------------------------

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uRescons_DEBUG}
{$ENDIF}

initialization
{$IFDEF uRescons_DEBUG}
  DEBUGMess(0, 'uRescons.Init');
{$ENDIF}
  try
    ZalList := TStringList.Create;
  except
    ZalList := nil;
  end;
  try
    TicketTypesList := TStringList.Create;
  except
    TicketTypesList := nil;
  end;
  try
    TicketPriceList := TStringList.Create;
  except
    TicketPriceList := nil;
  end;
  try
    NetUserList := TStringList.Create;
  except
    NetUserList := nil;
  end;

finalization
{$IFDEF uRescons_DEBUG}
  DEBUGMess(0, 'uRescons.Final');
{$ENDIF}
  if Assigned(ZalList) then
    ZalList.Free;
  if Assigned(TicketTypesList) then
    TicketTypesList.Free;
  if Assigned(TicketPriceList) then
    TicketPriceList.Free;
  if Assigned(NetUserList) then
    NetUserList.Free;

end.
