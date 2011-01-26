{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uImports.pas
Version      : 15.10.2002 9:02:32
Description  : 
Creation     : 12.10.2002 9:02:32
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uImports;

interface
uses
  Bugger,
  uRescons,
  Windows,
  Sysutils;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
type
  THandle = Integer;
  TGetVersion = procedure (var MajorVersion, MinorVersion, Release,
    Build, Flags: Word); stdcall;
  TInitializePrinterJob = function : Integer; stdcall;
  TFinalizePrinterJob = function : Integer; stdcall;
  TPrepareBitmapFromText = function (const lpFmtTextLine: PChar; GfxId,
    Permanent: Integer): Integer; stdcall; 
  TLoadBitmapFromFile = function (const lpFmtFilename: PChar; GfxId,
    Permanent: Integer): Integer; stdcall; 
  TPlaceBitmap = function (HeightMplr, WidthMplr, Row, Column,
    GfxId: Integer): Integer; stdcall;
  TBeginLabelCmd = function : Integer; stdcall;
  TEndLabelCmd = function : Integer; stdcall;
  TPrintBuffer = function (const lpPrinterName, lpJobTitle: PChar): Integer;
    stdcall; 
  TFlushGfxCache = function : Integer; stdcall;
  TMeasurementSystem = function (Mode: Integer): Integer; stdcall;
  TClearPrinterBuffer = function : Integer; stdcall; 

{
  std_GetVersion index 1001 name 'dpl_GetVersion',
  std_InitializePrinterJob index 1002 name 'dpl_InitializePrinterJob',
  std_FinalizePrinterJob index 1003 name 'dpl_FinalizePrinterJob',
  std_PrepareBitmapFromText index 1004 name 'dpl_PrepareBitmapFromText',
  std_LoadBitmapFromFile index 1005 name 'dpl_LoadBitmapFromFile',
  std_PlaceBitmap index 1006 name 'dpl_PlaceBitmap',
  std_BeginLabelCmd index 1007 name 'dpl_BeginLabelCmd',
  std_EndLabelCmd index 1008 name 'dpl_EndLabelCmd',
  std_PrintBuffer index 1009 name 'dpl_PrintBuffer',
  std_FlushGfxCache index 1010 name 'dpl_FlushGfxCache',
  std_MeasurementSystem index 1011 name 'dpl_MeasurementSystem',
  std_ClearPrinterBuffer index 1012 name 'dpl_ClearPrinterBuffer';


  procedure std_GetVersion(var MajorVersion, MinorVersion, Release,
    Build: Word); stdcall; external 'Print1c.dll';
  function std_InitializePrinterJob: Integer; stdcall; external 'Print1c.dll';
  function std_FinalizePrinterJob: Integer; stdcall; external 'Print1c.dll';
  function std_PrepareBitmapFromText(const lpFmtTextLine: PChar; GfxId,
    Permanent: Integer): Integer; stdcall; external 'Print1c.dll';
  function std_LoadBitmapFromFile(const lpFmtFilename: PChar; GfxId,
    Permanent: Integer): Integer; stdcall; external 'Print1c.dll';
  function std_PlaceBitmap(HeightMplr, WidthMplr, Row, Column,
    GfxId: Integer): Integer; stdcall; external 'Print1c.dll';
  function std_BeginLabelCmd: Integer; stdcall; external 'Print1c.dll';
  function std_EndLabelCmd: Integer; stdcall; external 'Print1c.dll';
  function std_PrintBuffer(const lpPrinterName, lpJobTitle: PChar): Integer;
    stdcall; external 'Print1c.dll';
  function std_FlushGfxCache: Integer; stdcall; external 'Print1c.dll';
  function std_MeasurementSystem(Mode: Integer): Integer; stdcall; external 'Print1c.dll';
  function std_ClearPrinterBuffer: Integer; stdcall; external 'Print1c.dll';
}
  function GetPrintModuleVersionString: WideString;
  function InitializePrinterJob: Integer;
  function FinalizePrinterJob: Integer;
  function PrepareBitmapFromText(const lpFmtTextLine: PChar; GfxId,
    Permanent: Integer): Integer;
  function LoadBitmapFromFile(const lpFmtFilename: PChar; GfxId,
    Permanent: Integer): Integer;
  function PlaceBitmap(HeightMplr, WidthMplr, Row, Column,
    GfxId: Integer): Integer;
  function BeginLabelCmd: Integer;
  function EndLabelCmd: Integer;
  function PrintBuffer(const lpPrinterName, lpJobTitle: PChar): Integer;
  function FlushGfxCache: Integer;
  function MeasurementSystem(Mode: Integer): Integer;
  function ClearPrinterBuffer: Integer; 
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
const
  Print_ModuleHandle: THandle = 0;
  Print_ModuleFileName: string = 'not found';
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uImports_DEBUG}
{$ENDIF}

const
  ext_GetVersion: TGetVersion = nil;
  s_GetVersion: string = 'dpl_GetVersion';
  ext_InitializePrinterJob: TInitializePrinterJob = nil;
  s_InitializePrinterJob: string = 'dpl_InitializePrinterJob';
  ext_FinalizePrinterJob: TFinalizePrinterJob = nil;
  s_FinalizePrinterJob: string = 'dpl_FinalizePrinterJob';
  ext_PrepareBitmapFromText: TPrepareBitmapFromText = nil;
  s_PrepareBitmapFromText: string = 'dpl_PrepareBitmapFromText';
  ext_LoadBitmapFromFile: TLoadBitmapFromFile = nil;
  s_LoadBitmapFromFile: string = 'dpl_LoadBitmapFromFile';
  ext_PlaceBitmap: TPlaceBitmap = nil;
  s_PlaceBitmap: string = 'dpl_PlaceBitmap';
  ext_BeginLabelCmd: TBeginLabelCmd = nil;
  s_BeginLabelCmd: string = 'dpl_BeginLabelCmd';
  ext_EndLabelCmd: TEndLabelCmd = nil;
  s_EndLabelCmd: string = 'dpl_EndLabelCmd';
  ext_PrintBuffer: TPrintBuffer = nil;
  s_PrintBuffer: string = 'dpl_PrintBuffer';
  ext_FlushGfxCache: TFlushGfxCache = nil;
  s_FlushGfxCache: string = 'dpl_FlushGfxCache';
  ext_MeasurementSystem: TMeasurementSystem = nil;
  s_MeasurementSystem: string = 'dpl_MeasurementSystem';
  ext_ClearPrinterBuffer: TClearPrinterBuffer = nil;
  s_ClearPrinterBuffer: string = 'dpl_ClearPrinterBuffer';
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function GetPrintModuleVersionString: WideString;
var
  _MajorVersion, _MinorVersion, _Release, _Build, _Flags: Word;
  _VersionString: string;
begin
  if Assigned(ext_GetVersion) then
  begin
    ext_GetVersion(_MajorVersion, _MinorVersion, _Release, _Build, _Flags);
    _VersionString := IntToStr(_MajorVersion) + '.' + IntToStr(_MinorVersion)
        + '.' + IntToStr(_Release) + '.' + IntToStr(_Build);
    if _Flags > 0 then
    begin
      _VersionString := _VersionString + ' Debug (';
      if (_Flags and 1) > 0 then
        _VersionString := _VersionString + 'F';
      if (_Flags and 2) > 0 then
        _VersionString := _VersionString + 'B';
      if (_Flags and 4) > 0 then
        _VersionString := _VersionString + 'S';
      if (_Flags and 8) > 0 then
        _VersionString := _VersionString + 'P';
      _VersionString := _VersionString + ') ';
    end
    else
      _VersionString := _VersionString + ' Ready ';
    Result := _VersionString + ' release';
  end
  else
    Result := '<wrong version>';
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function InitializePrinterJob: Integer;
begin
  if Assigned(ext_InitializePrinterJob) then
    Result := ext_InitializePrinterJob
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function FinalizePrinterJob: Integer;
begin
  if Assigned(ext_FinalizePrinterJob) then
    Result := ext_FinalizePrinterJob
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function PrepareBitmapFromText(const lpFmtTextLine: PChar; GfxId,
    Permanent: Integer): Integer;
begin
  if Assigned(ext_PrepareBitmapFromText) then
    Result := ext_PrepareBitmapFromText(lpFmtTextLine, GfxId, Permanent)
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function LoadBitmapFromFile(const lpFmtFilename: PChar; GfxId,
    Permanent: Integer): Integer;
begin
  if Assigned(ext_LoadBitmapFromFile) then
    Result := ext_LoadBitmapFromFile(lpFmtFilename, GfxId, Permanent)
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function PlaceBitmap(HeightMplr, WidthMplr, Row, Column,
  GfxId: Integer): Integer;
begin
  if Assigned(ext_PlaceBitmap) then
    Result := ext_PlaceBitmap(HeightMplr, WidthMplr, Row, Column, GfxId)
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function BeginLabelCmd: Integer;
begin
  if Assigned(ext_BeginLabelCmd) then
    Result := ext_BeginLabelCmd
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function EndLabelCmd: Integer;
begin
  if Assigned(ext_EndLabelCmd) then
    Result := ext_EndLabelCmd
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function PrintBuffer(const lpPrinterName, lpJobTitle: PChar): Integer;
begin
  if Assigned(ext_PrintBuffer) then
    Result := ext_PrintBuffer(lpPrinterName, lpJobTitle)
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function FlushGfxCache: Integer;
begin
  if Assigned(ext_FlushGfxCache) then
    Result := ext_FlushGfxCache
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function MeasurementSystem(Mode: Integer): Integer;
begin
  if Assigned(ext_MeasurementSystem) then
    Result := ext_MeasurementSystem(Mode)
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function ClearPrinterBuffer: Integer;
begin
  if Assigned(ext_ClearPrinterBuffer) then
    Result := ext_ClearPrinterBuffer
  else
    Result := -1;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
initialization
{$IFDEF uImports_DEBUG}
  DEBUGMess(0, 'uImports.Init');
{$ENDIF}
  Print_ModuleHandle := LoadLibrary(PChar(Print_ModuleName));
  if Print_ModuleHandle <> 0 then
  begin
    SetLength(Print_ModuleFileName, 2048);
    SetLength(Print_ModuleFileName, GetModuleFileName(Print_ModuleHandle, @Print_ModuleFileName[1], 2048));
{$IFDEF uImports_DEBUG}
    DEBUGMess(0, Print_ModuleName + ' module is opened, path - "' + Print_ModuleFileName + '".');
{$ENDIF}
    // 1001
    @ext_GetVersion := GetProcAddress(Print_ModuleHandle, PChar(s_GetVersion));
    if @ext_GetVersion <> nil then
{$IFDEF uImports_DEBUG}
      DEBUGMess(0, 'Module version is [' + GetPrintModuleVersionString + '].')
{$ENDIF}
    else
      DEBUGMess(0, 'Failed to import function "' + s_GetVersion + '" from ' + Print_ModuleName + '.');
    // 1002
    @ext_InitializePrinterJob := GetProcAddress(Print_ModuleHandle, PChar(s_InitializePrinterJob));
    if @ext_InitializePrinterJob = nil then
      DEBUGMess(0, 'Failed to import function "' + s_InitializePrinterJob + '" from ' + Print_ModuleName + '.');
    // 1003
    @ext_FinalizePrinterJob := GetProcAddress(Print_ModuleHandle, PChar(s_FinalizePrinterJob));
    if @ext_FinalizePrinterJob = nil then
      DEBUGMess(0, 'Failed to import function "' + s_FinalizePrinterJob + '" from ' + Print_ModuleName + '.');
    // 1004
    @ext_PrepareBitmapFromText := GetProcAddress(Print_ModuleHandle, PChar(s_PrepareBitmapFromText));
    if @ext_PrepareBitmapFromText = nil then
      DEBUGMess(0, 'Failed to import function "' + s_PrepareBitmapFromText + '" from ' + Print_ModuleName + '.');
    // 1005
    @ext_LoadBitmapFromFile := GetProcAddress(Print_ModuleHandle, PChar(s_LoadBitmapFromFile));
    if @ext_LoadBitmapFromFile = nil then
      DEBUGMess(0, 'Failed to import function "' + s_LoadBitmapFromFile + '" from ' + Print_ModuleName + '.');
    // 1006
    @ext_PlaceBitmap := GetProcAddress(Print_ModuleHandle, PChar(s_PlaceBitmap));
    if @ext_PlaceBitmap = nil then
      DEBUGMess(0, 'Failed to import function "' + s_PlaceBitmap + '" from ' + Print_ModuleName + '.');
    // 1007
    @ext_BeginLabelCmd := GetProcAddress(Print_ModuleHandle, PChar(s_BeginLabelCmd));
    if @ext_BeginLabelCmd = nil then
      DEBUGMess(0, 'Failed to import function "' + s_BeginLabelCmd + '" from ' + Print_ModuleName + '.');
    // 1008
    @ext_EndLabelCmd := GetProcAddress(Print_ModuleHandle, PChar(s_EndLabelCmd));
    if @ext_EndLabelCmd = nil then
      DEBUGMess(0, 'Failed to import function "' + s_EndLabelCmd + '" from ' + Print_ModuleName + '.');
    // 1009
    @ext_PrintBuffer := GetProcAddress(Print_ModuleHandle, PChar(s_PrintBuffer));
    if @ext_PrintBuffer = nil then
      DEBUGMess(0, 'Failed to import function "' + s_PrintBuffer + '" from ' + Print_ModuleName + '.');
    // 1010
    @ext_FlushGfxCache := GetProcAddress(Print_ModuleHandle, PChar(s_FlushGfxCache));
    if @ext_FlushGfxCache = nil then
      DEBUGMess(0, 'Failed to import function "' + s_FlushGfxCache + '" from ' + Print_ModuleName + '.');
    // 1011
    @ext_MeasurementSystem := GetProcAddress(Print_ModuleHandle, PChar(s_MeasurementSystem));
    if @ext_MeasurementSystem = nil then
      DEBUGMess(0, 'Failed to import function "' + s_MeasurementSystem + '" from ' + Print_ModuleName + '.');
    // 1012
    @ext_ClearPrinterBuffer := GetProcAddress(Print_ModuleHandle, PChar(s_ClearPrinterBuffer));
    if @ext_ClearPrinterBuffer = nil then
      DEBUGMess(0, 'Failed to import function "' + s_ClearPrinterBuffer + '" from ' + Print_ModuleName + '.');
  end
  else
  begin
    @ext_GetVersion := nil;             // 1001
    @ext_InitializePrinterJob := nil;   // 1002
    @ext_FinalizePrinterJob := nil;     // 1003
    @ext_PrepareBitmapFromText := nil;  // 1004
    @ext_LoadBitmapFromFile := nil;     // 1005
    @ext_PlaceBitmap := nil;            // 1006
    @ext_BeginLabelCmd := nil;          // 1007
    @ext_EndLabelCmd := nil;            // 1008
    @ext_PrintBuffer := nil;            // 1009
    @ext_FlushGfxCache := nil;          // 1010
    @ext_MeasurementSystem := nil;      // 1011
    @ext_ClearPrinterBuffer := nil;     // 1012
{$IFDEF uImports_DEBUG}
    DEBUGMess(0, 'Failed to open module ' + Print_ModuleName + '.')
{$ENDIF}
  end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
finalization
{$IFDEF uImports_DEBUG}
  DEBUGMess(0, 'uImports.Final');
{$ENDIF}
  if Print_ModuleHandle <> 0 then
    try
//      @ext_GetVersion := nil;             // 1001
//      @ext_InitializePrinterJob := nil;   // 1002
//      @ext_FinalizePrinterJob := nil;     // 1003
//      @ext_PrepareBitmapFromText := nil;  // 1004
//      @ext_LoadBitmapFromFile := nil;     // 1005
//      @ext_PlaceBitmap := nil;            // 1006
//      @ext_BeginLabelCmd := nil;          // 1007
//      @ext_EndLabelCmd := nil;            // 1008
//      @ext_PrintBuffer := nil;            // 1009
//      @ext_FlushGfxCache := nil;          // 1010
//      @ext_MeasurementSystem := nil;      // 1011
//      @ext_ClearPrinterBuffer := nil;     // 1012
      FreeLibrary(Print_ModuleHandle);
{$IFDEF uImports_DEBUG}
      DEBUGMess(0, Print_ModuleName + ' module is closed.');
{$ENDIF}
    except
{$IFDEF uImports_DEBUG}
      DEBUGMess(0, 'Failed to close module ' + Print_ModuleName + '.');
{$ENDIF}
    end;

end.
