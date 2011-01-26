{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      :
Author       : n0mad
Module       : demo4.dpr
Version      : 
Description  : 
Creation     : 12.10.2002 9:00:39
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
program demo4;

{%File 'Defs.inc'}

uses
  Forms,
  bugger in 'bugger.pas',
  ShpCtrl in '..\LIB\ShpCtrl.pas',
  XPMenu in '..\LIB\XPMenu.pas',
  Udp in '..\LIB\Udp.pas',
  uAddon in 'uAddon.pas',
  uCells in 'uCells.pas',
  uHelp in 'uHelp.pas',
  uImports in 'uImports.pas',
  uRescons in 'uRescons.pas',
  uSetting in 'uSetting.pas',
  uThreads in 'uThreads.pas',
  uTools in 'uTools.pas',
  uPrint in 'uPrint.pas',
  uNetSrv in 'uNetSrv.pas',
  uNetClt in 'uNetClt.pas',
  uNetCmd in 'uNetCmd.pas',
  uDatamod in 'uDatamod.pas' {dm: TDatamodule},
  uMain in 'uMain.pas' {fmMain},
  uFilm in 'uFilm.pas' {fmFilm},
  uGenre in 'uGenre.pas' {fmGenre},
  uInfo in 'uInfo.pas' {fmInfo},
  uMinimap in 'uMinimap.pas' {fmMinimap},
  uOptions in 'uOptions.pas' {fmOptions},
  uPerson in 'uPerson.pas' {fmPerson},
  uProizv in 'uProizv.pas' {fmProizv},
  uRepert in 'uRepert.pas' {fmRepert},
  uSeans in 'uSeans.pas' {fmSeans},
  uTarifet in 'uTarifet.pas' {fmTarifet},
  uTarifpl in 'uTarifpl.pas' {fmTarifpl},
  uTarifz in 'uTarifz.pas' {fmTarifz},
  uTopogr in 'uTopogr.pas' {fmTopogr},
  uSplash in 'uSplash.pas' {fmSplash};

{$R *.RES}

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF DemoX_DEBUG}
{$ENDIF}

begin
  // --------------------------------------------------------------------------
{$IFDEF DemoX_DEBUG}
  DEBUGMess(0, CRLF + StringOfChar('_', LogSeparatorWidth)
    + CRLF + StringOfChar('$', LogSeparatorWidth));
  DEBUGMess(1, 'Application.Started');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Инициализация программы
  // --------------------------------------------------------------------------
  Application.Initialize;
  // --------------------------------------------------------------------------
  // 1.1) Создание алиаса базы
  // 1.2) Открытие таблиц базы
  // --------------------------------------------------------------------------
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
  // --------------------------------------------------------------------------
{$IFDEF DemoX_DEBUG}
  DEBUGMess(-1, 'Application.Finished');
  DEBUGMess(0, CRLF + StringOfChar('$', LogSeparatorWidth)
    + CRLF + StringOfChar('_', LogSeparatorWidth));
{$ENDIF}
end.
