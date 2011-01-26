{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uInfo.pas
Version      : 15.10.2002 9:02:37
Description  : 
Creation     : 12.10.2002 9:02:37
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uSetting, uRescons, Gauges, ComCtrls, StdCtrls, Buttons,
  ShpCtrl;

type
  TfmInfo = class(TSLForm)
    pnInfo: TPanel;
    lvTarifz: TListView;
    GroupBox1: TGroupBox;
    bbnCmdPrint: TBitBtn;
    bbnCmdPosterminal: TBitBtn;
    bbnCmdOneTicket: TBitBtn;
    bbnCmdClear: TBitBtn;
    bbnCmdRestore: TBitBtn;
    sbarInfo: TStatusBar;
    bbnCmdReserve: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CycleMinMax(Sender: TObject);
  private
    { Private declarations }
    _Left, _Top: integer;
    OneTime: Boolean;
    MinSized: boolean;
  public
    { Public declarations }
  end;

var
  fmInfo: TfmInfo;

implementation

uses
  Bugger,
  uMain,
  uCells;

{$R *.DFM}

procedure TfmInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Action := caHide;
  if Assigned(fmMain) then
    fmMain.acMap.Checked := false;
end;

procedure TfmInfo.FormCreate(Sender: TObject);
begin
  WindowState := wsNormal;
//  SaveWindowState := false;
  OneTime := true;
  _Left := -1;
  _Top := -1;
  MinSized := false;
end;

procedure TfmInfo.FormActivate(Sender: TObject);
begin
  //
{  if OneTime then
  begin
    fmMain.Show;
    OneTime := false;
    CycleMinMax(nil);
  end;}
end;

procedure TfmInfo.CycleMinMax(Sender: TObject);
begin
  MinSized := not MinSized;
  if MinSized then
  begin
    Height := Constraints.MaxHeight;
    sbarInfo.Panels[0].Text := 'MAXI';
  end
  else
  begin
    Height := Constraints.MinHeight;
    sbarInfo.Panels[0].Text := 'MINI';
  end;
end;

{$IFDEF uInfo_DEBUG}
initialization
  DEBUGMess(0, 'uInfo.Init');
{$ENDIF}

{$IFDEF uInfo_DEBUG}
finalization
  DEBUGMess(0, 'uInfo.Final');
{$ENDIF}

end.
