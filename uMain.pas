{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uMain.pas
Version      : 17.10.2002 7:07:07
Description  :
Creation     : 12.10.2002 8:58:11
Installation :


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ImgList, ActnList, uSetting, Menus, StdCtrls, ComCtrls, ToolWin,
  ShpCtrl, Gauges, XPMenu, UDP, Buttons;

type
  TNetState = (nsUnknown, nsServer, nsClient);
  
  TfmMain = class(TFSForm)
//  TfmMain = class(TSLForm)
    Secundomer: TTimer;
    imlFilm: TImageList;
    imlMain: TImageList;
    imlMainTicket: TImageList;
    imlSell: TImageList;
    aclMain: TActionList;
    acExit: TAction;
    acAbout: TAction;
    acOptions: TAction;
    acTickets: TAction;
    acGenre: TAction;
    acProducer: TAction;
    acSeans: TAction;
    acFilm: TAction;
    acRejiser: TAction;
    acSuppliers: TAction;
    acTopogr: TAction;
    acProizv: TAction;
    acFullScreen: TAction;
    acRepert: TAction;
    acReportSend: TAction;
    acTarifpl: TAction;
    acTarifz: TAction;
    acTarifet: TAction;
    acDailyReport: TAction;
    acMap: TAction;
    acInfo: TAction;
    acKKMOptions: TAction;
    aclMainTicket: TActionList;
    acPrint: TAction;
    acClear: TAction;
    acPosterminal: TAction;
    acMakeItSo: TAction;
    acRestore: TAction;
    acOneTicket: TAction;
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miReportSend: TMenuItem;
    miLine14: TMenuItem;
    miExit: TMenuItem;
    miSpravochniki: TMenuItem;
    miTopogr: TMenuItem;
    miLine10: TMenuItem;
    miGenre: TMenuItem;
    miRejiser: TMenuItem;
    miProducer: TMenuItem;
    miMakers: TMenuItem;
    miSuppliers: TMenuItem;
    miLine13: TMenuItem;
    miSeansTimes: TMenuItem;
    miFilm: TMenuItem;
    miLine16: TMenuItem;
    miTarifpl: TMenuItem;
    miDocuments: TMenuItem;
    miTarifz: TMenuItem;
    miTarifet: TMenuItem;
    miCurTarifz: TMenuItem;
    miLine18: TMenuItem;
    miRepert: TMenuItem;
    miTickets: TMenuItem;
    miReports: TMenuItem;
    miDailyReport: TMenuItem;
    miService: TMenuItem;
    miKKMOptions: TMenuItem;
    miOptions: TMenuItem;
    miLine15: TMenuItem;
    miMap: TMenuItem;
    miFullScreen: TMenuItem;
    miHelp: TMenuItem;
    miHelpIndex: TMenuItem;
    miAbout: TMenuItem;
    popMainTicket: TPopupMenu;
    miLine12: TMenuItem;
    miLine8: TMenuItem;
    miLine9: TMenuItem;
    miLine17: TMenuItem;
    miLine7: TMenuItem;
    miLine1: TMenuItem;
    miLine2: TMenuItem;
    miLine3: TMenuItem;
    miLine4: TMenuItem;
    miLine5: TMenuItem;
    miLine6: TMenuItem;
    popTicket: TPopupMenu;
    miTicketTypesInfo: TMenuItem;
    ppmLine1: TMenuItem;
    ppmMostUsed1: TMenuItem;
    ppmMostUsed2: TMenuItem;
    ppmMostUsed3: TMenuItem;
    ppmLine2: TMenuItem;
    ppmForMoney: TMenuItem;
    ppmLine3: TMenuItem;
    ppmForFree: TMenuItem;
    ppmLine4: TMenuItem;
    ppmLine5: TMenuItem;
    miLine11: TMenuItem;
    tbrMain: TToolBar;
    tbnTopogr: TToolButton;
    tbn1: TToolButton;
    tbnSeans: TToolButton;
    tbnFilm: TToolButton;
    ToolButton4: TToolButton;
    tbnTarifet: TToolButton;
    tbnTarifz: TToolButton;
    tbn3: TToolButton;
    tbnRepert: TToolButton;
    tbnTickets: TToolButton;
    tbn4: TToolButton;
    tbnDailyReport: TToolButton;
    tbn5: TToolButton;
    tbnOptions: TToolButton;
    tbn6: TToolButton;
    tbnMap: TToolButton;
    tbnFullScreen: TToolButton;
    tbn7: TToolButton;
    stTimer: TStaticText;
    ToolButton2: TToolButton;
    tbnExit: TToolButton;
    ToolButton1: TToolButton;
    tbHiddenSpace: TToolButton;
    sbMain: TStatusBar;
    pnMain: TPanel;
    lbNoRepert: TLabel;
    ggProgress: TGauge;
    pnInfo: TPanel;
    lbZal: TLabel;
    lbDate: TLabel;
    lbTarif: TLabel;
    ssSelect: TTicketControl;
    cmZal: TComboBox;
    dtpDate: TDateTimePicker;
    stTarifet: TSpeedShapeEx;
    tbcFilm: TTabControl;
    sbx_Cntr: TScrollBox;
    lbFilmInfo: TStaticText;
    XPMenu1: TXPMenu;
    pnZal_Container: TPanel;
    tbnTarifpl: TToolButton;
    ToolButton5: TToolButton;
    TCPClient1: TTCPClient;
    TCPServer1: TTCPServer;
    UDPClient1: TUDPClient;
    UDPServer1: TUDPServer;
    tbnBroadCast: TToolButton;
    tbnNul: TToolButton;
    acNetUp: TAction;
    acNetDown: TAction;
    miLine19: TMenuItem;
    U1: TMenuItem;
    D1: TMenuItem;
    acReserve: TAction;
    acHde: TAction;
    acToggleQm: TAction;
    ppmCancel: TMenuItem;
    ppmLine6: TMenuItem;
    tbnTicletOperate: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    miLine22: TMenuItem;
    miPrinterReload: TMenuItem;
    miLine20: TMenuItem;
    miActions: TMenuItem;
    miPrint: TMenuItem;
    miCancel: TMenuItem;
    miLine21: TMenuItem;
    miLine23: TMenuItem;
    miLine24: TMenuItem;
    miPosterminal: TMenuItem;
    miOneTicket: TMenuItem;
    miReserve: TMenuItem;
    miRestore: TMenuItem;
    miLine25: TMenuItem;
    miLine26: TMenuItem;
    pnCommand: TPanel;
    bbnCmdPrint: TBitBtn;
    bbnCmdPosterminal: TBitBtn;
    bbnCmdOneTicket: TBitBtn;
    bbnCmdRestore: TBitBtn;
    bbnCmdReserve: TBitBtn;
    bbnCmdCancel: TBitBtn;
    stInfo: TSpeedShapeEx;
    procedure SecundomerTimer(Sender: TObject);
    procedure acExitExecute(Sender: TObject); // Выход из программы
    procedure acAboutExecute(Sender: TObject); // О программе...
    procedure acOptionsExecute(Sender: TObject); // Изменение настроек программы
    procedure acTicketsExecute(Sender: TObject); // Журнал продажи билетов
    procedure acGenreExecute(Sender: TObject); // Справочник жанров
    procedure acProducerExecute(Sender: TObject); // Справочник продюссеров
    procedure acSeansExecute(Sender: TObject); // Справочник сеансов
    procedure acFilmExecute(Sender: TObject); // Справочник фильмов
    procedure acRejiserExecute(Sender: TObject); // Справочник режиссеров
    procedure acSuppliersExecute(Sender: TObject); // Справочник поставщиков
    procedure acTopogrExecute(Sender: TObject); // Топография зала
    procedure acProizvExecute(Sender: TObject); // Справочник производителей фильмов
    procedure acFullScreenExecute(Sender: TObject); // Полный экран
    procedure acRepertExecute(Sender: TObject); // Репертуар кинотеатра
    procedure acReportSendExecute(Sender: TObject); // Посылка отчета
    procedure acTarifplExecute(Sender: TObject); // Типы билетов
    procedure acTarifzExecute(Sender: TObject); // Справочник тарифов
    procedure acTarifetExecute(Sender: TObject); // Тарифные планы
    procedure acDailyReportExecute(Sender: TObject); // Ежедневный отчет
    procedure acMapExecute(Sender: TObject); // Миникарта зала
    procedure acInfoExecute(Sender: TObject); // Информационное окно
    procedure acKKMOptionsExecute(Sender: TObject); // Настройки ККМ
  // --------------------------------------------------------------------------
    procedure acPrintExecute(Sender: TObject); // Продажа подготовленных билетов за нал. и бесплатно
    procedure acPosterminalExecute(Sender: TObject); // Продажа подготовленных билетов по постерминалу
    procedure acClearExecute(Sender: TObject); // Сброс подготовленных билетов
    procedure acMakeItSoExecute(Sender: TObject); //
    procedure acReserveExecute(Sender: TObject); // Бронь подготовленных билетов
    procedure acRestoreExecute(Sender: TObject); // Возврат проданных билетов
    procedure acOneTicketExecute(Sender: TObject); // Продажа подготовленных билетов (печать одним билетом)
  // --------------------------------------------------------------------------
    procedure acNetUpExecute(Sender: TObject);
    procedure acNetDownExecute(Sender: TObject);
  // --------------------------------------------------------------------------
    procedure FormActivate(Sender: TObject); // Активизация главной формы
    procedure FormClose(Sender: TObject; var Action: TCloseAction); // Закрытие главной формы
    procedure FormCreate(Sender: TObject); // Создание главной формы
  // --------------------------------------------------------------------------
    procedure ssSelectClick(Sender: TObject); //
    procedure TicketLeftClick(Sender: TObject); // Нажатие левой
    procedure TicketRightClick(Sender: TObject); // Вызов из всплывающего меню
    procedure TicketChangeState(Sender: TObject); // Обновление состояния и статуса
    procedure TicketChangeTarifpl(Sender: TObject); // Обновление цветов фона и шрифта
    procedure TicketChangeUsedByNet(Sender: TObject); // Обновление сетевого режима
  // --------------------------------------------------------------------------
    procedure dtpDateChange(Sender: TObject); // Смена текущей даты
    procedure cmZalChange(Sender: TObject); // Смена текущего зала
    procedure tbcFilmChange(Sender: TObject); // Смена текущего сеанса
  // --------------------------------------------------------------------------
  // Net Components
  // --------------------------------------------------------------------------
    procedure TCPClient1Close(Sender: TObject; Socket: Integer);
    procedure TCPClient1Connect(Sender: TObject; Socket: Integer);
    procedure TCPClient1Data(Sender: TObject; Socket: Integer);
    procedure TCPClient1Error(Sender: TObject; Error: Integer;
      Msg: String);
  // --------------------------------------------------------------------------
    procedure TCPServer1Accept(Sender: TObject; Socket: Integer);
    procedure TCPServer1Close(Sender: TObject; Socket: Integer);
    procedure TCPServer1Data(Sender: TObject; Socket: Integer);
    procedure TCPServer1Error(Sender: TObject; Error: Integer;
      Msg: String);
  // --------------------------------------------------------------------------
    procedure UDPClient1Data(Sender: TObject; Socket: Integer);
    procedure UDPClient1Error(Sender: TObject; Error: Integer;
      Msg: String);
  // --------------------------------------------------------------------------
    procedure UDPServer1Data(Sender: TObject; Socket: Integer);
    procedure UDPServer1Error(Sender: TObject; Error: Integer;
      Msg: String);
    procedure tbnBroadCastClick(Sender: TObject);
    procedure acHdeExecute(Sender: TObject);
    procedure acToggleQmExecute(Sender: TObject);
    procedure SetDefOpt(Sender: TObject);
    procedure miPrinterReloadClick(Sender: TObject);
    procedure tbnNulClick(Sender: TObject);
    procedure stInfoClick(Sender: TObject);
  // --------------------------------------------------------------------------
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  // --------------------------------------------------------------------------
  private
    { Private declarations }
    FNet_Mode: TNetState;
    FClient_State: TSocketState;
    FServer_State: TSocketState;
    procedure UpdateNetMode;
    procedure UpdateNetState;
    procedure UpdateOptions;
    procedure SetNet_Mode(const Value: TNetState);
    procedure SetClient_State(const Value: TSocketState);
    procedure SetServer_State(const Value: TSocketState);
  // --------------------------------------------------------------------------
  public
    { Public declarations }
    property Net_Mode: TNetState read FNet_Mode write SetNet_Mode;
    property Client_State: TSocketState read FClient_State write SetClient_State;
    property Server_State: TSocketState read FServer_State write SetServer_State;
  // --------------------------------------------------------------------------
    procedure ScrollMove(px, py: byte);
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // 2.2) Загрузка всех типов билетов
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
    procedure Main_Activate_Proc;
  // --------------------------------------------------------------------------
    procedure ParseCommandLine;
    procedure NetSrv_Up;
    procedure NetSrv_Down;
  // --------------------------------------------------------------------------
    function SetStatus(panel_index: Integer; StatusText: string): Boolean;
  // --------------------------------------------------------------------------
  end;

var
  fmMain: TfmMain;

const
  ar_NetState: array [TNetState] of string =
  ('Unknown', 'SERVER', 'CLIENT');
  ar_SocketState: array [TSocketState] of string =
  ('NotStarted', 'Close', 'Connected', 'Listening', 'Open');

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uMain_DEBUG}
  {$UNDEF uMain_Net_DEBUG}
{$ENDIF}

uses
  Bugger,
  uTools,
  uAddon,
  uRescons,
  uHelp,
  uDatamod,
  uNetClt,
  uNetSrv,
  uNetCmd,
  uSplash,
  uGenre,
  uSeans,
  uFilm,
  uPerson,
  uProizv,
  uRepert,
  uTarifpl,
  uTarifz,
  uTarifet,
  uOptions,
  uTopogr,
  uMinimap,
  uInfo;

{$R *.DFM}

{-----------------------------------------------------------------------------
  Procedure: TfmMain.SecundomerTimer
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.SecundomerTimer(Sender: TObject);
const
  ProcName: string = 'TfmMain.SecundomerTimer';
begin
  try
    stTimer.Caption := TimeToStr(Time);
    // UpdateNetMode;
  except
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acExitExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acExitExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acExitExecute';
begin
  // --------------------------------------------------------------------------
  // Выход из программы
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: Close');
  Close;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acAboutExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acAboutExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acAboutExecute';
begin
  // --------------------------------------------------------------------------
  // О программе...
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: GetProgramInfo');
  ShowMessage(GetProgramInfo);
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acOptionsExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acOptionsExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acOptionsExecute';
begin
  // --------------------------------------------------------------------------
  // Изменение настроек программы
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmOptions, fmOptions);
    DEBUGMess(0, '[' + ProcName + ']: fmOptions.ShowModal');
    fmOptions.ShowModal;
  finally
    fmOptions.Free;
    fmOptions := nil;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acTicketsExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acTicketsExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acTicketsExecute';
begin
  // --------------------------------------------------------------------------
  // Журнал продажи билетов
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: ...not implemented...');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acGenreExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acGenreExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acGenreExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник жанров
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmGenre, fmGenre);
    DEBUGMess(0, '[' + ProcName + ']: fmGenre.ShowModal');
    fmGenre.ShowModal;
    if Assigned(fmFilm) then
      fmFilm.OnActivate(nil);
  finally
    fmGenre.Free;
    fmGenre := nil;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acProducerExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acProducerExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acProducerExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник продюссеров
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmPerson, fmPerson);
    DEBUGMess(0, '[' + ProcName + ']: fmProducer.ShowModal');
    fmPerson.ShowModal;
    if Assigned(fmFilm) then
      fmFilm.OnActivate(nil);
  finally
    fmPerson.Free;
    fmPerson := nil;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acSeansExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acSeansExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acSeansExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник сеансов
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmSeans, fmSeans);
    DEBUGMess(0, '[' + ProcName + ']: fmSeans.ShowModal');
    fmSeans.ShowModal;
  finally
    fmSeans.Free;
    fmSeans := nil;
  end;
  Refresh_Date(0);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acFilmExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acFilmExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acFilmExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник фильмов
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmFilm, fmFilm);
    DEBUGMess(0, '[' + ProcName + ']: fmFilm.ShowModal');
    fmFilm.ShowModal;
  finally
    fmFilm.Free;
    fmFilm := nil;
  end;
  Refresh_Date(0);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acRejiserExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acRejiserExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acRejiserExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник режиссеров
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmPerson, fmPerson);
    DEBUGMess(0, '[' + ProcName + ']: fmRejiser.ShowModal');
    fmPerson.ShowModal;
    if Assigned(fmFilm) then
      fmFilm.OnActivate(nil);
  finally
    fmPerson.Free;
    fmPerson := nil;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acSuppliersExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acSuppliersExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acSuppliersExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник поставщиков
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: ...not implemented...');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acTopogrExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acTopogrExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acTopogrExecute';
begin
  // --------------------------------------------------------------------------
  // Топография зала
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmTopogr, fmTopogr);
    DEBUGMess(0, '[' + ProcName + ']: fmTopogr.ShowModal');
    fmTopogr.ShowModal;
  finally
    fmTopogr.Free;
    fmTopogr := nil;
  end;
  Refresh_Date(0);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acProizvExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acProizvExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acProizvExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник производителей фильмов
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmProizv, fmProizv);
    DEBUGMess(0, '[' + ProcName + ']: fmProizv.ShowModal');
    fmProizv.ShowModal;
    if Assigned(fmFilm) then
      fmFilm.OnActivate(nil);
  finally
    fmProizv.Free;
    fmProizv := nil;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acFullScreenExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acFullScreenExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acFullScreenExecute';
begin
  // --------------------------------------------------------------------------
  // Полный экран
  // --------------------------------------------------------------------------
  FullScreen := not FullScreen;
  acFullScreen.Checked := FullScreen;
  DEBUGMess(0, '[' + ProcName + ']: fmMain.FullScreen = ' + Boolean_Array[FullScreen]);
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acRepertExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acRepertExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acRepertExecute';
begin
  // --------------------------------------------------------------------------
  // Репертуар кинотеатра
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmRepert, fmRepert);
    DEBUGMess(0, '[' + ProcName + ']: fmRepert.ShowModal');
    fmRepert.ShowModal;
  finally
    fmRepert.Free;
    fmRepert := nil;
  end;
  Refresh_Date(0);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acReportSendExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acReportSendExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acReportSendExecute';
begin
  // --------------------------------------------------------------------------
  // Посылка отчета
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: ...not implemented...');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acTarifplExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acTarifplExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acTarifplExecute';
begin
  // --------------------------------------------------------------------------
  // Типы билетов
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmTarifpl, fmTarifpl);
    DEBUGMess(0, '[' + ProcName + ']: fmTarifpl.ShowModal');
    fmTarifpl.ShowModal;
  finally
    fmTarifpl.Free;
    fmTarifpl := nil;
  end;
  // --------------------------------------------------------------------------
  // 2.2) Загрузка всех типов билетов
  // --------------------------------------------------------------------------
    Load_All_Ticket_Types; // tTarifpl
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
    Load_All_Tarifs; // tTarifz, tTarifet
  // --------------------------------------------------------------------------
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acTarifzExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acTarifzExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acTarifzExecute';
begin
  // --------------------------------------------------------------------------
  // Справочник тарифов
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmTarifz, fmTarifz);
    DEBUGMess(0, '[' + ProcName + ']: fmTarifz.ShowModal');
    fmTarifz.ShowModal;
  finally
    fmTarifz.Free;
    fmTarifz := nil;
  end;
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
    Load_All_Tarifs; // tTarifz, tTarifet
  // --------------------------------------------------------------------------
  Refresh_Date(0);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acTarifetExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acTarifetExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acTarifetExecute';
begin
  // --------------------------------------------------------------------------
  // Тарифные планы
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmTarifet, fmTarifet);
    DEBUGMess(0, '[' + ProcName + ']: fmTarifet.ShowModal');
    fmTarifet.ShowModal;
  finally
    fmTarifet.Free;
    fmTarifet := nil;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acDailyReportExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acDailyReportExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acDailyReportExecute';
begin
  // --------------------------------------------------------------------------
  // Ежедневный отчет
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: ...not implemented...');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acMapExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acMapExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acMapExecute';
begin
  // --------------------------------------------------------------------------
  // Миникарта зала
  // --------------------------------------------------------------------------
  exit;
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(fmMinimap) then
  begin
    if fmMinimap.Visible then
      try
        DEBUGMess(0, '[' + ProcName + ']: fmMinimap.Hide');
        fmMinimap.Hide;
      finally
        acMap.Checked := false;
      end
    else
    begin
      DEBUGMess(0, '[' + ProcName + ']: fmMinimap.Show');
      fmMinimap.Show;
      acMap.Checked := true;
    end;
  end
  else
    try
      Application.CreateForm(TfmMinimap, fmMinimap);
      DEBUGMess(0, '[' + ProcName + ']: fmMinimap.Show - after Create');
      fmMinimap.Show;
      acMap.Checked := true;
    except
      fmMinimap.Free;
      fmMinimap := nil;
      acMap.Checked := false;
    end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acInfoExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acInfoExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acInfoExecute';
begin
  // --------------------------------------------------------------------------
  // Информационное окно
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(fmInfo) then
  begin
    if fmInfo.Visible then
      try
        DEBUGMess(0, '[' + ProcName + ']: fmInfo.Hide');
        fmInfo.Hide;
      finally
        acMap.Checked := false;
      end
    else
    begin
      DEBUGMess(0, '[' + ProcName + ']: fmInfo.Show');
      fmInfo.Show;
      acMap.Checked := true;
    end;
  end
  else
    try
      Application.CreateForm(TfmInfo, fmInfo);
      DEBUGMess(0, '[' + ProcName + ']: fmInfo.Show - after Create');
      fmInfo.Show;
      acMap.Checked := true;
    except
      fmInfo.Free;
      fmInfo := nil;
      acMap.Checked := false;
    end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acKKMOptionsExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acKKMOptionsExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acKKMOptionsExecute';
begin
  // --------------------------------------------------------------------------
  // Настройки ККМ
  // --------------------------------------------------------------------------
  DEBUGMess(0, '[' + ProcName + ']: ...not implemented...');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acPrintExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acPrintExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acPrintExecute';
begin
  // --------------------------------------------------------------------------
  // Продажа подготовленных билетов за нал. и бесплатно
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TControl) then
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  if _tnq then
    Refresh_All_TC_Selected(taPrint, 0, Cur_Repert_Kod)
  else
    Refresh_All_TC_Selected(taFixCheq, 0, Cur_Repert_Kod);
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acClearExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acClearExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acClearExecute';
begin
  // --------------------------------------------------------------------------
  // Сброс подготовленных билетов
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TControl) then 
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  Refresh_All_TC_Selected(taClear, 0, 0)
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acPosterminalExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acPosterminalExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acPosterminalExecute';
begin
  // --------------------------------------------------------------------------
  // Продажа подготовленных билетов по постерминалу
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TControl) then 
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  Refresh_All_TC_Selected(taPosTerminal, 0, Cur_Repert_Kod)
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acMakeItSoExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acMakeItSoExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acMakeItSoExecute';
begin
  // --------------------------------------------------------------------------
  // 
  // --------------------------------------------------------------------------
  stTarifet.Selected := False;
  if Assigned(Sender) and (Sender is TControl) then 
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  Refresh_All_TC_Selected(taQueue, 0, Cur_Repert_Kod)
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acReserveExecute
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acReserveExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acReserveExecute';
begin
  // --------------------------------------------------------------------------
  // Бронь подготовленных билетов
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TControl) then 
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  Refresh_All_TC_Selected(taReserve, 0, Cur_Repert_Kod)
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acRestoreExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acRestoreExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acRestoreExecute';
begin
  // --------------------------------------------------------------------------
  // Возврат проданных билетов
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TControl) then 
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  Refresh_All_TC_Selected(taRestore, 0, Cur_Repert_Kod)
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acOneTicketExecute
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acOneTicketExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acOneTicketExecute';
begin
  // --------------------------------------------------------------------------
  // Продажа подготовленных билетов (печать одним билетом)
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TControl) then
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TControl).Name + ')');
  Refresh_All_TC_Selected(taPrintOneTicket, 0, Cur_Repert_Kod)
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acNetUpExecute
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acNetUpExecute(Sender: TObject);
begin
  if Net_Mode = nsUnknown then
    Net_Mode := nsClient; 
  NetSrv_Up;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.acNetDownExecute
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.acNetDownExecute(Sender: TObject);
begin
  NetSrv_Down;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.FormActivate
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.FormActivate(Sender: TObject);
const
  ProcName: string = 'TfmMain.FormActivate';
begin
  // --------------------------------------------------------------------------
  // Активизация главной формы
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  UpdateOptions;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.FormClose
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject; var Action: TCloseAction
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'TfmMain.FormClose';
begin
  // --------------------------------------------------------------------------
  // Закрытие главной формы
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  UpdateNetMode;
  DEBUGMess(0, '[' + ProcName + ']: MessageDlg(...mtConfirmation...)');
  // if MessageDlg(Exit_Mess, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  if 1=1 then
  begin
    DEBUGMess(0, '[' + ProcName + ']: Answer - Yes');
    if dm.db.Connected then
    begin
  // --------------------------------------------------------------------------
  // Остановка TCP(20021) и UDP(20021) серверов
  // --------------------------------------------------------------------------
      NetSrv_Down;
  // --------------------------------------------------------------------------
      dm.db.Connected := false;
      DEBUGMess(0, '[' + ProcName + ']: DataBase is disconnected.');
    end;
    Application.Terminate;
  end
  else
    Action := caNone;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.FormCreate
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.FormCreate(Sender: TObject);
const
  ProcName: string = 'TfmMain.FormCreate';
var
  str_Printed_Ticket_Count: string;
begin
  // --------------------------------------------------------------------------
  // Создание главной формы
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  try
    Application.CreateForm(TfmSplash, fmSplash);
    DEBUGMess(0, '[FormActivate]: Showing Splash form...');
    fmSplash.Show;
  except
    fmSplash := nil;
    DEBUGMess(0, '[FormActivate]: Error - Splash form creating...');
  end;
  DEBUGMess(0, '[' + ProcName + ']: Init variables & constants...');
  Cur_Panel_Cntr := nil;
  Cur_Date := 0;
  Cur_Repert_Kod := -1;
  Cur_Zal_Kod := -1;
  Cur_Film_Kod := -1;
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // 2.2) Загрузка всех типов билетов
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
  Main_Activate_Proc;
  // --------------------------------------------------------------------------
  if GetOption(s_Total_Printed_Count, str_Printed_Ticket_Count) > 0 then
  begin
    try
      Printed_Ticket_Count := StrToInt(str_Printed_Ticket_Count);
    except
      Printed_Ticket_Count := 0;
    end;
  end
  else
    Printed_Ticket_Count := 0;
  SaveOption(s_Total_Printed_Count, IntToStr(Printed_Ticket_Count), true);
  // --------------------------------------------------------------------------
  // Старт TCP(20021) и UDP(20021) серверов
  // --------------------------------------------------------------------------
  Server_IP := '127.0.0.1';
  Net_Mode := nsUnknown;
  Client_State := TCPClient1.SocketState;
  Server_State := TCPServer1.SocketState;
  _tne := False;
  ParseCommandLine;
  NetSrv_Up;
  Cur_Owner := 2;
  // --------------------------------------------------------------------------
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TicketLeftClick
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TicketLeftClick(Sender: TObject);
const
  ProcName: string = 'TfmMain.TicketLeftClick';
var
  ssTmp: TTicketControl;
  str_cmd: string;
begin
  // --------------------------------------------------------------------------
  // Нажатие левой
  // --------------------------------------------------------------------------
  DEBUGMess(0, CRLF + StringOfChar('^', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if (Sender is TTicketControl) then
  begin
    ssTmp := (Sender as TTicketControl);
    DEBUGMess(0, '[' + ProcName + ']: Row = ' + IntToStr(ssTmp.Row) + '; Column = ' + IntToStr(ssTmp.Column));
    DEBUGMess(0, '[' + ProcName + ']: Ticket_Kod = ' + IntToStr(ssTmp.Ticket_Kod)
      + '; Ticket_Tarifpl = ' + IntToStr(ssTmp.Ticket_Tarifpl)
      + '; Ticket_Repert = ' + IntToStr(ssTmp.Ticket_Repert)
      + '; Ticket_Type = ' + IntToStr(ssTmp.Ticket_Type));
{
    if ssTmp.TC_State in [scPrepared] then
      ssTmp.TC_State := scFree;
}
    if Create_Net_Commmand(str_cmd, ssTmp, ntTrack) > -1 then
    begin
      BroadcastSend(str_cmd, False, 0, 3);
    end;
    Refresh_TC_Hint(ssTmp);
  end;
  Refresh_TC_Count(nil);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('^', LogSeparatorWidth));
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TicketRightClick
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TicketRightClick(Sender: TObject);
const
  ProcName: string = 'TfmMain.TicketRightClick';
var
  tmpMenuItem: TMenuItem;
  tmpTC: TTicketControl;
  tmp_Repert_Kod, i_Tarifpl: integer;
  Dispatched: Boolean;
  str_cmd: string;
begin
  // --------------------------------------------------------------------------
  // Вызов из всплывающего меню
  // --------------------------------------------------------------------------
  DEBUGMess(0, CRLF + StringOfChar(',', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  Dispatched := False;
  if (Sender is TMenuItem) and (tbcFilm.Tabs.Count > 0) then
  begin
    tmpMenuItem := (Sender as TMenuItem);
    i_Tarifpl := tmpMenuItem.Tag;
    //tmp_Repert_Kod := integer(tbcFilm.Tabs.Objects[tbcFilm.TabIndex]);
    tmp_Repert_Kod := Cur_Repert_Kod;
    DEBUGMess(0, '[' + ProcName + ']: i_Tarifpl = (' + IntToStr(i_Tarifpl)
      + '); tmp_Repert_Kod = (' + IntToStr(tmp_Repert_Kod) + ').');
    with popTicket do
    if Assigned(PopupComponent) and (PopupComponent is TTicketControl) then
    begin
      tmpTC := (PopupComponent as TTicketControl);
      if tmpTC.Tracked then
      begin
        case tmpMenuItem.Tag of
        -1:
        begin
          case tmpTC.TC_State of
          scFree:
            if tmpTC.Selected then
              Refresh_All_TC_Selected(taClear, 1, 0);
          scPrepared:
            tmpTC.TC_State := scFree;
          scFixed, scFixedNoCash, scFixedCheq:
            tmpTC.Selected := False;
          else
          end;
          Dispatched := True;
        end
        else
          if (not tmpTC.Selected) and (tmpTC.TC_State in [scFree, scPrepared]) and (tmpTC.Ticket_Tarifpl <> i_Tarifpl) then
          begin
            tmpTC.TC_State := scFree;
            Refresh_TC_Selected(tmpTC, taPrepare, i_Tarifpl, tmp_Repert_Kod, Cur_Owner);
            Dispatched := True;
          end;
        end;
        if Create_Net_Commmand(str_cmd, tmpTC, ntTrack) > -1 then
        begin
          BroadcastSend(str_cmd, False, 0, 3);
        end;
      end;
    end;
    if (i_Tarifpl > -1) and not Dispatched then
    begin
      if Refresh_All_TC_Selected(taPrepare, i_Tarifpl, tmp_Repert_Kod) = 0 then
        // ShowMessage('Выделите места для действия')
      else
        // Dispatched := True
        ;
    end
    else
      Refresh_TC_Count(nil);
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar(',', LogSeparatorWidth));
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.ssSelectClick
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.ssSelectClick(Sender: TObject);
const
  ProcName: string = 'TfmMain.ssSelectClick';
var
  s: string;  
begin
//  acClear.Execute;
  DEBUGMess(1, '[' + ProcName + ']: ->');
  ssSelect.TC_State := scFree;
  Refresh_TC_Hint(ssSelect);
  acToggleQmExecute(Sender);
  if Create_Net_Commmand(s, ssSelect, ntTrack) > -1 then
  begin
    BroadcastSend(s, False, 0, 3);
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.dtpDateChange
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.dtpDateChange(Sender: TObject);
const
  ProcName: string = 'TfmMain.dtpDateChange';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  // --------------------------------------------------------------------------
  // Смена текущей даты
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('d', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  DateSeparator := '/';
  DEBUGMess(0, '[' + ProcName + ']: Date is (' + FormatDateTime('dd/mm/yyyy', dtpDate.Date) + ')');
  // --------------------------------------------------------------------------
  // Обновление состояния
  // --------------------------------------------------------------------------
  Refresh_Date(dtpDate.Date); // set Date from Control
  // --------------------------------------------------------------------------
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('d', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.cmZalChange
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.cmZalChange(Sender: TObject);
const
  ProcName: string = 'TfmMain.cmZalChange';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  tmpZal_Kod: integer;
begin
  // --------------------------------------------------------------------------
  // Смена текущего зала 
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('z', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  with cmZal do
  if ItemIndex = -1 then
    tmpZal_Kod := -1
  else
    tmpZal_Kod := Integer(Items.Objects[ItemIndex]);
  DEBUGMess(0, '[' + ProcName + ']: Zal_Kod = (' + IntToStr(tmpZal_Kod) + ')');
  if tbcFilm.TabIndex <> -1 then
    DEBUGMess(0, '[' + ProcName + ']: Description is (' + cmZal.Items[cmZal.ItemIndex] + ')');
  Refresh_Zal(tmpZal_Kod);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('z', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.tbcFilmChange
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.tbcFilmChange(Sender: TObject);
const
  ProcName: string = 'TfmMain.tbcFilmChange';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  tmpFilm_Kod: integer;
begin
  // --------------------------------------------------------------------------
  // Смена текущего сеанса 
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMess(0, CRLF + StringOfChar('f', LogSeparatorWidth));
  DEBUGMess(1, '[' + ProcName + ']: ->');
  with tbcFilm do
  if TabIndex = -1 then
    tmpFilm_Kod := -1
  else
    tmpFilm_Kod := Integer(Integer(Tabs.Objects[TabIndex]));
  DEBUGMess(0, '[' + ProcName + ']: Film_Kod = (' + IntToStr(tmpFilm_Kod) + ')');
  if tbcFilm.TabIndex <> -1 then
  begin
    DEBUGMess(0, '[' + ProcName + ']: Description is (' + tbcFilm.Tabs[tbcFilm.TabIndex] + ')');
    tbcFilm.Visible := true;
    lbFilmInfo.Caption := tbcFilm.Tabs[tbcFilm.TabIndex];
  end
  else
  begin
    tbcFilm.Visible := false;
    lbFilmInfo.Caption := 'Нет сеансов на эту дату.';
  end;
  Refresh_Film(tmpFilm_Kod);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('f', LogSeparatorWidth));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMess(0, '[' + ProcName + ']: '+ 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.ScrollMove
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: px, py: byte
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.ScrollMove(px, py: byte);
const
  ProcName: string = 'TfmMain.ScrollMove';
{var
  wx, wy: integer;
  wx1, wy1: integer;}
begin
  with sbx_Cntr do
  if ComponentCount > 0 then
  begin
    with HorzScrollBar do
    begin
{      wx := round(sqr(ClientWidth) / Range);}
      Position := Round((Range - ClientWidth) * px / 100 + (sqr(ClientWidth) / Range) * (px - 50) / 50);
{      wx1 := round(Position * 100 / (Range - ClientWidth));}
    end;
    with VertScrollBar do
    begin
{      wy := round(sqr(ClientHeight) / Range);}
      Position := Round((Range - ClientHeight) * py / 100 + (sqr(ClientHeight) / Range) * (py - 50) / 50);
{      wy1 := round(Position * 100 / (Range - ClientHeight));}
    end;
{    Caption := format(
      'fmMain - wx=%u, wy=%u, ClX=%u, ClY=%u, RngX=%u, RngY=%u, psX=%u=%u%%, ScX=%u, psY=%u=%u%%, ScY=%u',
      [
      wx, wy,
      ClientWidth, ClientHeight,
      HorzScrollBar.Range, VertScrollBar.Range,
      HorzScrollBar.Position, wx1, HorzScrollBar.ScrollPos,
      VertScrollBar.Position, wy1, VertScrollBar.ScrollPos
      ]);}
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.Main_Activate_Proc
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.Main_Activate_Proc;
const
  ProcName: string = 'TfmMain.Main_Activate_Proc';
var
  tmp_Action: TCloseAction;
begin
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // 2.2) Загрузка всех типов билетов
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if not dm.db.Connected then
  begin
    DEBUGMess(0, '[' + ProcName + ']: Connecting DataBase...');
    dm.db.Connected := true;
  end;
  if dm.db.Connected then
  begin
    DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
    DEBUGMess(0, '[' + ProcName + ']: Init procs...');
    acInfo.Execute;
    fmInfo.Visible := false;
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // --------------------------------------------------------------------------
    Load_All_Zals; // tPlace, tZal
  // --------------------------------------------------------------------------
  // 2.2) Загрузка всех типов билетов
  // --------------------------------------------------------------------------
    Load_All_Ticket_Types; // tTarifpl
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
    Load_All_Tarifs; // tTarifz, tTarifet
  // --------------------------------------------------------------------------
  // Загрузка текущего зала
  // --------------------------------------------------------------------------
    Cur_Zal_Kod := -1;
    Refresh_Zal(-2); // force changes in combobox
  // --------------------------------------------------------------------------
  // Установка даты
  // --------------------------------------------------------------------------
    Init_Cur_Date;
    dtpDate.OnChange(nil);
  // --------------------------------------------------------------------------
    DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
    if Assigned(fmSplash) then
    begin
      DEBUGMess(0, '[' + ProcName + ']: Closing Splash form...');
      fmSplash.OnClose(fmMain, tmp_Action);
      try
        fmSplash.Free;
        DEBUGMess(0, '[' + ProcName + ']: Splash form is freed...');
      except
        fmSplash := nil;
        DEBUGMess(0, '[' + ProcName + ']: Error - Splash form freeing...');
      end;
    end;
    fmInfo.Visible := true;
    acFullScreen.Checked := FullScreen;
    DEBUGMess(0, '[' + ProcName + ']: Done activating.');
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
  DEBUGMess(0, CRLF + StringOfChar('-', LogSeparatorWidth));
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TicketChangeState
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TicketChangeState(Sender: TObject);
const
  ProcName: string = 'TfmMain.TicketChangeState';
begin
  // --------------------------------------------------------------------------
  // Обновление состояния и статуса
  // --------------------------------------------------------------------------
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(Sender) and (Sender is TTicketControl) then
  with (Sender as TTicketControl) do
  begin
    DEBUGMess(0, '[' + ProcName + ']: Name = ' + Name);
    DEBUGMess(0, '[' + ProcName + ']: TC_State = ' + SpShSt_Array[TC_State]);
    DEBUGMess(0, '[' + ProcName + ']: Before. Repert = ' + IntToStr(Ticket_Repert));
    Ticket_Repert := Cur_Repert_Kod;
    DEBUGMess(0, '[' + ProcName + ']: After. Repert = ' + IntToStr(Ticket_Repert));
    Refresh_TC_Hint(Sender as TTicketControl);
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TicketChangeTarifpl
  Author:    n0mad
  Date:      12-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TicketChangeTarifpl(Sender: TObject);
const
  ProcName: string = 'TfmMain.TicketChangeTarifpl';
var
  FixedBrush_Color, FixedFont_Color: TColor;  
begin
  // --------------------------------------------------------------------------
  // Обновление цветов фона и шрифта
  // --------------------------------------------------------------------------
{$IFDEF uMain_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  if Assigned(Sender) and (Sender is TTicketControl) then
  with (Sender as TTicketControl) do
  begin
{$IFDEF uMain_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Name = ' + Name);
    DEBUGMess(0, '[' + ProcName + ']: '
      + Format('Kod = (%u); Tarifpl = (%u); SpShSt = (%s)',
      [Ticket_Kod, Ticket_Tarifpl, SpShSt_Array[TC_State]]));
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка цветов фона и шрифта
  // --------------------------------------------------------------------------
    Change_Tarifpl_Desc(Ticket_Tarifpl, FixedBrush_Color, FixedFont_Color);
  // --------------------------------------------------------------------------
    FixedBrush.Color := FixedBrush_Color;
    FixedFont.Color := FixedFont_Color;
    Refresh_TC_Hint(Sender as TTicketControl);
  end;
{$IFDEF uMain_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TicketChangeUsedByNet
  Author:    n0mad
  Date:      21-окт-2002
  Arguments: Sender: TObject
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TicketChangeUsedByNet(Sender: TObject);
const
  ProcName: string = 'TfmMain.TicketChangeUsedByNet';
begin
  // --------------------------------------------------------------------------
  // Обновление цветов фона и шрифта
  // --------------------------------------------------------------------------
{$IFDEF uMain_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  if Assigned(Sender) and (Sender is TTicketControl) then
  with (Sender as TTicketControl) do
  begin
{!$IFDEF uMain_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Name = ' + Name);
    DEBUGMess(0, '[' + ProcName + ']: UsedByNet = ' + FALSE_OR_TRUE[UsedByNet]);
    DEBUGMess(0, '[' + ProcName + ']: '
      + Format('Kod = (%u); Tarifpl = (%u); SpShSt = (%s)',
      [Ticket_Kod, Ticket_Tarifpl, SpShSt_Array[TC_State]]));
{!$ENDIF}
  // --------------------------------------------------------------------------
  // Смена формы
  // --------------------------------------------------------------------------
    if UsedByNet then
      Shape := stEllipse
    else
      Shape := stRoundRect;
  // --------------------------------------------------------------------------
    Refresh_TC_Count(nil);
  end;
{$IFDEF uMain_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPClient1Close
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPClient1Close(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.TCPClient1Close';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_TCP_Logging_Clt(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    Process_TCP_Farewell_Clt(Sender, Socket);
  end;
  Client_State := TCPClient1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPClient1Connect
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPClient1Connect(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.TCPClient1Connect';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_TCP_Logging_Clt(Sender, Socket, 1);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    Process_TCP_HandShake_Clt(Sender, Socket);
  end;
  Client_State := TCPClient1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPClient1Data
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPClient1Data(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.TCPClient1Data';
var
  p1, len: Integer;
  NetData, Part: string;  
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_TCP_Logging_Clt(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    NetData := TCPClient1.Read;
    len := Length(NetData);
    while len > 0 do
    begin
      p1 := Pos(LineFeed, NetData);
      if p1 > 0 then
      begin
        Part := Copy(NetData, 1, p1);
        Delete(NetData, 1, p1); 
        len := Length(NetData);
      end
      else
      begin
        Part := NetData;
        len := 0;
      end;
      Process_TCP_NetData_Clt(Sender, Socket, Part);
    end;
  end;
  Client_State := TCPClient1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPClient1Error
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: String
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPClient1Error(Sender: TObject; Error: Integer;
  Msg: String);
const
  ProcName: string = 'TfmMain.TCPClient1Error';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Error = (' + IntToStr(Error) + '); Msg = (' + Msg + ')');
{!$ENDIF}
  Process_TCP_Error_Clt(Sender, Error, Msg);
  Client_State := TCPClient1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPServer1Accept
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPServer1Accept(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.TCPServer1Accept';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_TCP_Logging_Srv(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    Process_TCP_HandShake_Srv(Sender, Socket);
  end;
  Server_State := TCPServer1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPServer1Close
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPServer1Close(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.TCPServer1Close';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_TCP_Logging_Srv(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    Process_TCP_Farewell_Srv(Sender, Socket);
  end;
  Server_State := TCPServer1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPServer1Data
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPServer1Data(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.TCPServer1Data';
var
  p1, len: Integer;
  NetData, Part: string;  
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_TCP_Logging_Srv(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    NetData := TCPServer1.Read(Socket);
    len := Length(NetData);
    while len > 0 do
    begin
      p1 := Pos(LineFeed, NetData);
      if p1 > 0 then
      begin
        Part := Copy(NetData, 1, p1);
        Delete(NetData, 1, p1); 
        len := Length(NetData);
      end
      else
      begin
        Part := NetData;
        len := 0;
      end;
      Process_TCP_NetData_Srv(Sender, Socket, Part);
    end;
  end;
  Server_State := TCPServer1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.TCPServer1Error
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: String
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.TCPServer1Error(Sender: TObject; Error: Integer;
  Msg: String);
const
  ProcName: string = 'TfmMain.TCPServer1Error';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Error = (' + IntToStr(Error) + '); Msg = (' + Msg + ')');
{$ENDIF}
  Process_TCP_Error_Srv(Sender, Error, Msg);
  Server_State := TCPServer1.SocketState; 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.UDPClient1Data
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.UDPClient1Data(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.UDPClient1Data';
var
  NetData: string;  
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_UDP_Logging_Clt(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    NetData := UDPClient1.Read;
    Process_UDP_NetData_Clt(Sender, Socket, NetData);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.UDPClient1Error
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: String
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.UDPClient1Error(Sender: TObject; Error: Integer;
  Msg: String);
const
  ProcName: string = 'TfmMain.UDPClient1Error';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Error = (' + IntToStr(Error) + '); Msg = (' + Msg + ')');
{$ENDIF}
  Process_UDP_Error_Clt(Sender, Error, Msg);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.UDPServer1Data
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Socket: Integer
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.UDPServer1Data(Sender: TObject; Socket: Integer);
const
  ProcName: string = 'TfmMain.UDPServer1Data';
var
  NetData: string;
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Process_UDP_Logging_Srv(Sender, Socket, 0);
  if Socket <> SBST_INVALID_SOCKET then
  begin
    NetData := 'N/A';
    // NetData := UDPServer1.Read(Socket);
    Process_UDP_NetData_Srv(Sender, Socket, NetData);
  end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.UDPServer1Error
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: Sender: TObject; Error: Integer; Msg: String
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.UDPServer1Error(Sender: TObject; Error: Integer;
  Msg: String);
const
  ProcName: string = 'TfmMain.UDPServer1Error';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Error = (' + IntToStr(Error) + '); Msg = (' + Msg + ')');
{$ENDIF}
  Process_UDP_Error_Srv(Sender, Error, Msg);
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.NetSrv_Up
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.NetSrv_Up;
const
  ProcName: string = 'TfmMain.NetSrv_Up';
begin
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Client_State := TCPClient1.SocketState;
  Server_State := TCPServer1.SocketState;
  case Net_Mode of
  nsServer:
  begin
    with TCPServer1 do
    begin
      Close;
      NetUserList.Clear;
      Open;
{$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Version is (' + Version + ')');
      DEBUGMess(0, '[' + ProcName + ']: Description is (' + Description + ')');
      DEBUGMess(0, '[' + ProcName + ']: SystemStatus is (' + SystemStatus + ')');
      DEBUGMess(0, '[' + ProcName + ']: LocalHostName = ' + LocalHostName + ' [' + LocalHostAddress + ']');
      DEBUGMess(0, '[' + ProcName + ']: LocalPort = (' + Port + ')');
{$ENDIF}
{!$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Server mode');
{!$ENDIF}
    end;
    UDPServer1.Open;
  end;
  nsClient:
  begin
    with TCPClient1 do
    begin
      Close;
      Host := Server_IP;
      Open;
{$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Version is (' + Version + ')');
      DEBUGMess(0, '[' + ProcName + ']: Description is (' + Description + ')');
      DEBUGMess(0, '[' + ProcName + ']: SystemStatus is (' + SystemStatus + ')');
      DEBUGMess(0, '[' + ProcName + ']: LocalHostName = ' + LocalHostName + ' [' + LocalHostAddress + ']');
      DEBUGMess(0, '[' + ProcName + ']: LocalPort = (' + Port + ')');
{$ENDIF}
{!$IFDEF uMain_Net_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Client mode - Host = [' + Host + ']');
{!$ENDIF}
    end;
  end;
  else
    {ignore}
  end;
  //
{!$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.NetSrv_Down
  Author:    n0mad
  Date:      14-окт-2002
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure TfmMain.NetSrv_Down;
const
  ProcName: string = 'TfmMain.NetSrv_Down';
begin
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  //
  TCPClient1.Close;
  UDPServer1.Close;
  TCPServer1.Close;
  NetUserList.Clear;
  Client_State := TCPClient1.SocketState;
  Server_State := TCPServer1.SocketState;
  //
{$IFDEF uMain_Net_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
end;

procedure TfmMain.tbnBroadCastClick(Sender: TObject);
var
  tmb: Byte; 
begin
  case Net_Mode of
  nsClient:
    tmb := 1;
  nsServer:
    tmb := 2;
  else
    tmb := 0;
  end;
  if tmb > 0 then
  begin
    BroadcastSend(NET_CMD_Clt_Array[nccPing], True, 0, tmb);
    BroadcastSend(NET_CMD_Clt_Array[nccPing], False, 0, tmb);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmMain.SetStatus
  Author:    n0mad
  Date:      17-окт-2002
  Arguments: panel_index: Integer; StatusText: string
  Result:    Boolean
-----------------------------------------------------------------------------}
function TfmMain.SetStatus(panel_index: Integer; StatusText: string): Boolean;
begin
  Result := False;
  if (panel_index > -1) and (sbMain.Panels.Count > panel_index) then
  begin
    if Length(StatusText) > 0 then
      sbMain.Panels[panel_index].Text := StatusText
    else
      sbMain.Panels[panel_index].Text := '---';
    Result := True;
  end;
end;

procedure TfmMain.UpdateNetMode;
begin
  SetStatus(0, ar_NetState[Net_Mode]);
  UpdateNetState;
end;

procedure TfmMain.UpdateNetState;
var
  curi: string;
begin
  case Net_Mode of
  nsServer:
    with TCPServer1 do
    begin
      SetStatus(1, SocketToName(LocalSocket));
      SetStatus(2, SocketToAddress(LocalSocket));
      SetStatus(3, SocketToPort(LocalSocket));
      SetStatus(4, ar_SocketState[FServer_State]);
      if Assigned(NetUserList) then
        SetStatus(5, 'Clients: ' + IntToStr(NetUserList.Count))
      else
        SetStatus(5, '');
      PrgRights := PrgRights + [rt_Can_Add1, rt_Can_Edit1, rt_Can_Del1, rt_Can_Sell];
    end;
  nsClient:
    with TCPClient1 do
    begin
      SetStatus(1, SocketToName(LocalSocket));
      SetStatus(2, SocketToAddress(LocalSocket));
      SetStatus(3, SocketToPort(LocalSocket));
      SetStatus(4, ar_SocketState[FClient_State]);
      if (Length(PeerAddress) > 0) and (Length(PeerPort) > 0) then
        SetStatus(5, 'Up ' + PeerAddress + ':' + PeerPort)
      else
        if Client_State in [ssOpen] then
          SetStatus(5, 'Down ' + Host + ':' + Port)
        else
          SetStatus(5, 'Not found ' + Host + ':' + Port);
      PrgRights := PrgRights - [rt_Can_Add1, rt_Can_Edit1, rt_Can_Del1] + [rt_Can_Sell];
    end;
  else
    SetStatus(1, '');
    SetStatus(2, '');
    SetStatus(3, '');
    SetStatus(4, 'Undefined');
    with TCPClient1 do
      SetStatus(5, 'Host ' + Host + ':' + Port);
    PrgRights := [];
  end;
  curi := '';
  curi := curi + F_OR_T[rt_Can_Add1 in PrgRights];
  curi := curi + F_OR_T[rt_Can_Edit1 in PrgRights];
  curi := curi + F_OR_T[rt_Can_Del1 in PrgRights];
  curi := curi + '-';
  curi := curi + F_OR_T[rt_Can_Add2 in PrgRights];
  curi := curi + F_OR_T[rt_Can_Edit2 in PrgRights];
  curi := curi + F_OR_T[rt_Can_Del2 in PrgRights];
  curi := curi + '-';
  curi := curi + F_OR_T[rt_Can_Sell in PrgRights];
  curi := curi + F_OR_T[rt_Can_Root in PrgRights];
  SetStatus(7, curi);
end;

procedure TfmMain.SetNet_Mode(const Value: TNetState);
begin
  if Value <> FNet_Mode then
  begin
    FNet_Mode := Value;
    UpdateNetMode;
  end;
end;

procedure TfmMain.SetClient_State(const Value: TSocketState);
begin
  if Value <> FClient_State then
  begin
    FClient_State := Value;
  end;
  UpdateNetState;
end;

procedure TfmMain.SetServer_State(const Value: TSocketState);
begin
  if Value <> FServer_State then
  begin
    FServer_State := Value;
  end;
  UpdateNetState;
end;

procedure TfmMain.acHdeExecute(Sender: TObject);
const
  ProcName: string = 'TfmMain.acHdeExecute';
begin
  //
  if _tne then
    inc(HSettting);
  if HSettting > hsEnabled then
    HSettting := hsDisabled;
  if Check_Cntr then
  begin
    Cur_Panel_Cntr.Invalidate;
    Refresh_TC_Count(nil);
  end;
  UpdateOptions;
end;

procedure TfmMain.acToggleQmExecute(Sender: TObject);
begin
  //
  if _tne then
    _tnq := not _tnq;
  UpdateOptions;
  Refresh_TC_Count(nil);
end;

procedure TfmMain.UpdateOptions;
var
  ch1, ch2, ch3, ch4: Char;
begin
  ssSelect.Selected := not _tnq;    
  if _tnq then
    ch1 := '4'
  else
    ch1 := '0';
  if _tne then
    case HSettting of
    hsDisabled:
      ch2 := 'D';
    hsHybrid:
      ch2 := 'H';
    hsEnabled:
      ch2 := 'E';
    else // case
      ch2 := '+';
    end // case
  else // if _tne then
    ch2 := '-';
  if _Print_Serial then
    ch3 := 'S'
  else
    ch3 := 'N';
  if Show_All_Info then
    ch4 := '0'
  else
    ch4 := '1';
  SetStatus(6, ch1 + ch2 + '% '+ ch3 + ch4);
end;

procedure TfmMain.SetDefOpt(Sender: TObject);
begin
  _tnq := True;
  HSettting := hsEnabled;
  if Check_Cntr then
    Cur_Panel_Cntr.Invalidate;
  UpdateOptions;
end;

procedure TfmMain.ParseCommandLine;
var
  _option1, _option2: string;  
begin
  //
  if ParamCount > 0 then
  begin
    _option1 := ParamStr(1);
    if Length(_option1) > 0 then
      if _option1[1] = '-' then
        _tne := True;
    Delete(_option1, 1, 1);
    _option1 := LowerCase(_option1);
    if (_option1 = 'server') or (_option1 = 's') then
      Net_Mode := nsServer
    else
    begin
      if (_option1 = 'connect') or (_option1 = 'client') or (_option1 = 'c') then
        Net_Mode := nsClient;
      if ParamCount > 1 then
      begin
        _option2 := ParamStr(2);
          if CheckIP(_option2) then
            Server_IP := _option2;
      end;
    end;
  end;
end;

procedure TfmMain.miPrinterReloadClick(Sender: TObject);
begin
 //
 Emblema_Loaded := 0;
 ShowMessage('Принтер инициализирован.');
end;

procedure TfmMain.tbnNulClick(Sender: TObject);
begin
  Show_All_Info := not Show_All_Info;
  UpdateOptions;
  Refresh_TC_Count(nil); 
end;

procedure TfmMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  LocalPos: TPoint;
  HotControl: TControl;
begin
  LocalPos := Self.ScreenToClient(MousePos);
  HotControl := Self.ControlAtPos(LocalPos, False, True);
  if ((HotControl is TPanel) and (HotControl = pnMain)) then
    with sbx_Cntr do
    begin
      VertScrollBar.Position := VertScrollBar.Position -
        Sign(WheelDelta) * 20;
    end;
end;

{!$IFDEF uMain_DEBUG}
procedure TfmMain.stInfoClick(Sender: TObject);
begin
  stInfo.Selected := False;
end;

initialization
  DEBUGMess(0, 'uMain.Init');
  DateSeparator := '-';
  TimeSeparator := ':';
  DEBUGMess(0, DateToStr(Now) + '_' + TimeToStr(Time));
{!$ENDIF}

{!$IFDEF uMain_DEBUG}
finalization
  DEBUGMess(0, 'uMain.Final');
{!$ENDIF}

end.
