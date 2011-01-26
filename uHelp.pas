{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uHelp.pas
Version      : 15.10.2002
Description  : 
Creation     : 12.10.2002 9:02:25
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uHelp;

interface
uses
  Bugger,
  uRescons,
  uImports,
  uDatamod,
  Windows,
  SysUtils,
  Dbtables,
  Forms;

  function GetProgramInfo: string;

implementation

function GetProgramInfo: string;
const
  ProcName: string = 'GetProgramInfo';
procedure GetVersionString(var sBuffer: string; sVersionBuffer, sPath: string);
var
  lplpBuffer: Pointer;
  puLen: Cardinal;
begin
  sBuffer := '<Error>';
  if (length(sVersionBuffer) > 0) and (length(sPath) > 0) then
    if VerQueryValue(@sVersionBuffer[1], PChar(sPath), lplpBuffer, puLen) then
      if (lplpBuffer <> nil) and (puLen > 0) then
        begin
          SetLength(sBuffer, puLen);
          StrCopy(@sBuffer[1], lplpBuffer);
          SetLength(sBuffer, puLen - 1);
        end;
end;
var
  s, term, VersionInfo_Buf, ProductName_Buf, ProductVersion_Buf, LegalCopyright_Buf, FileDescription_Buf, CompanyName_Buf, FileVersion_Buf, main_program_info, print1c_info: string;
  i, dwHandle: Cardinal;
begin
  // About dialog
  DEBUGMess(1, '[' + ProcName + ']: ->');
  s := '';
  with dm do
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TTable) then
      with (Components[i] as TTable) do
      begin
        s := s + TableName + ' - ';
        if Active then
          s := s + 'Active'
        else
          s := 'Not Active';
        s := s + CRLF;
      end;
  end;
  ProductName_Buf := 'N/A';
  ProductVersion_Buf := 'N/A';
  LegalCopyright_Buf := 'N/A';
  FileDescription_Buf := 'N/A';
  CompanyName_Buf := 'N/A';
  FileVersion_Buf := 'N/A';
  i := GetFileVersionInfoSize(PChar(Application.ExeName), dwHandle);
  if i > 0 then
  begin
    SetLength(VersionInfo_Buf, i + 1);
    if GetFileVersionInfo(PChar(Application.ExeName), dwHandle, i, @VersionInfo_Buf[1]) then
    begin
      GetVersionString(ProductName_Buf, VersionInfo_Buf, Version_Block + '\\ProductName');
      GetVersionString(ProductVersion_Buf, VersionInfo_Buf, Version_Block + '\\ProductVersion');
      GetVersionString(LegalCopyright_Buf, VersionInfo_Buf, Version_Block + '\\LegalCopyright');
      GetVersionString(FileDescription_Buf, VersionInfo_Buf, Version_Block + '\\FileDescription');
      GetVersionString(CompanyName_Buf, VersionInfo_Buf, Version_Block + '\\CompanyName');
      GetVersionString(FileVersion_Buf, VersionInfo_Buf, Version_Block + '\\FileVersion');
    end;
  end;
  main_program_info :=
    'Product Name : "' + ProductName_Buf + '"'
    + CRLF
    + 'Product Version : [' + ProductVersion_Buf + ']'
    + CRLF
    + 'Legal Copyright : "' + LegalCopyright_Buf + '"'
    + CRLF
    + 'File Description : "' + FileDescription_Buf + '"'
    + CRLF
    + 'Company Name : "' + CompanyName_Buf + '"'
    + CRLF
    + 'File Version : [' + FileVersion_Buf + ']'
    + CRLF;
  ProductName_Buf := 'N/A';
  ProductVersion_Buf := 'N/A';
  LegalCopyright_Buf := 'N/A';
  FileDescription_Buf := 'N/A';
  CompanyName_Buf := 'N/A';
  FileVersion_Buf := 'N/A';
  i := GetFileVersionInfoSize(PChar(Print_ModuleFileName), dwHandle);
  if i > 0 then
  begin
    SetLength(VersionInfo_Buf, i + 1);
    if GetFileVersionInfo(PChar(Print_ModuleFileName), dwHandle, i, @VersionInfo_Buf[1]) then
    begin
      GetVersionString(ProductName_Buf, VersionInfo_Buf, Version_Block + '\\ProductName');
      GetVersionString(ProductVersion_Buf, VersionInfo_Buf, Version_Block + '\\ProductVersion');
      GetVersionString(LegalCopyright_Buf, VersionInfo_Buf, Version_Block + '\\LegalCopyright');
      GetVersionString(FileDescription_Buf, VersionInfo_Buf, Version_Block + '\\FileDescription');
      GetVersionString(CompanyName_Buf, VersionInfo_Buf, Version_Block + '\\CompanyName');
      GetVersionString(FileVersion_Buf, VersionInfo_Buf, Version_Block + '\\FileVersion');
    end;
  end;
  print1c_info :=
    'Product Name : "' + ProductName_Buf + '"'
    + CRLF
    + 'Product Version : [' + ProductVersion_Buf + ']'
    + CRLF
    + 'Legal Copyright : "' + LegalCopyright_Buf + '"'
    + CRLF
    + 'File Description : "' + FileDescription_Buf + '"'
    + CRLF
    + 'Company Name : "' + CompanyName_Buf + '"'
    + CRLF
    + 'File Version : [' + FileVersion_Buf + ']'
    + CRLF;
  term := '-=' + StringOfChar('-', 70) + '=-' + CRLF;
  Result :=
    term
    + About_Mess
    + CRLF
    + 'Путь к программе : "' + Application.ExeName + '"'
    + CRLF
    + 'Handle = ' + IntToHex(Application.Handle, 8)
    + CRLF
    + term
    + main_program_info
    + term
    + Print_ModuleName
    + CRLF
    + 'Путь к модулю : "' + Print_ModuleFileName + '"'
    + CRLF
    + 'GetVersion = "' + GetPrintModuleVersionString + '"'
    + CRLF
    + 'Handle = ' + IntToHex(Print_ModuleHandle, 8)
    + CRLF
    + term
    + print1c_info
    + term
    + 'Путь к базам : "' + dm.db.Directory + '"'
    + CRLF
    + term
    + s
    + term;
  DEBUGMess(0, '[' + ProcName + ']: Result = ' + Result);
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

{$IFDEF uHelp_DEBUG}
initialization
  DEBUGMess(0, 'uHelp.Init');
{$ENDIF}

{$IFDEF uHelp_DEBUG}
finalization
  DEBUGMess(0, 'uHelp.Final');
{$ENDIF}

end.
