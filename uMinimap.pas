{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uMinimap.pas
Version      : 15.10.2002 9:02:48
Description  : 
Creation     : 12.10.2002 9:02:48
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uMinimap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uSetting, uRescons, Gauges;

type
  TfmMinimap = class(TSLForm)
    pnMinimap: TPanel;
    ggProgress: TGauge;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pnMinimapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnMinimapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnMinimapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    CurMinimap: integer;
    procedure ConvertCoord(Control: TControl; X1, Y1: Integer; var X2, Y2: Integer);
    procedure DestroyCurMinimap;
  public
    { Public declarations }
  end;

var
  fmMinimap: TfmMinimap;

implementation

uses
  uMain,
  uAddon,
  uCells;

{$R *.DFM}

procedure TfmMinimap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Action := caHide;
  if Assigned(fmMain) then
    fmMain.acMap.Checked := false;
end;

procedure TfmMinimap.FormCreate(Sender: TObject);
begin
  WindowState := wsNormal;
  SaveWindowState := false;
  CurMinimap := -1;
end;

procedure TfmMinimap.FormActivate(Sender: TObject);
var
  i: integer;
  t: TComponent;
  tmp_Zal_Minimap: TStrings;
begin
  if CurMinimap <> Cur_Zal_Kod then
  begin
    i := ZalList.IndexOf(IntToStr(Cur_Zal_Kod));
    if i > -1 then
    begin
      tmp_Zal_Minimap := TStrings(ZalList.Objects[i]);
      DestroyCurMinimap;
      CreateZal_ThreadExecuted := true;
      CreateZal(tmp_Zal_Minimap, Cur_Zal_Kod, ggProgress, pnMinimap, 1, MultiplrMini, true);
      while CreateZal_ThreadExecuted do
        Application.ProcessMessages;
      CurMinimap := Cur_Zal_Kod;
    end;
    for i := 0 to pnMinimap.ComponentCount - 1 do
    begin
      t := pnMinimap.Components[i];
      if (t is TShape) then
      begin
        (t as TShape).OnMouseDown := ShapeMouseDown;
        (t as TShape).OnMouseMove := ShapeMouseMove;
        (t as TShape).OnMouseUp := ShapeMouseUp;
      end;
    end;
  end;
end;

procedure TfmMinimap.pnMinimapMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  px, py: byte;
begin
  if (X >= 0) and (X <= pnMinimap.ClientWidth) and (Y >= 0) and (Y <= pnMinimap.ClientHeight) then
  begin
    px := round(X * 100 / pnMinimap.ClientWidth);
    py := round(Y * 100 / pnMinimap.ClientHeight);
    fmMinimap.Caption := format('MouseDown @ px=%d%% py=%d%%  x=%d y=%d', [px,py,x,y]);
  end;
end;

procedure TfmMinimap.pnMinimapMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  px, py: byte;
begin
  if ssLeft in Shift then
  if (X >= 0) and (X <= pnMinimap.ClientWidth) and (Y >= 0) and (Y <= pnMinimap.ClientHeight) then
  begin
    px := round(X * 100 / pnMinimap.ClientWidth);
    py := round(Y * 100 / pnMinimap.ClientHeight);
    fmMinimap.Caption := format('MouseMove @ px=%d%% py=%d%%  x=%d y=%d', [px,py,x,y]);
    fmMain.ScrollMove(px, py);
  end;
end;

procedure TfmMinimap.pnMinimapMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  px, py: byte;
begin
  if (X >= 0) and (X <= pnMinimap.ClientWidth) and (Y >= 0) and (Y <= pnMinimap.ClientHeight) then
  begin
    px := round(X * 100 / pnMinimap.ClientWidth);
    py := round(Y * 100 / pnMinimap.ClientHeight);
    fmMinimap.Caption := format('MouseUp @ px=%d%% py=%d%%  x=%d y=%d', [px,py,x,y]);
    fmMain.ScrollMove(px, py);
  end;
end;

procedure TfmMinimap.ShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  px, py: integer;
begin
  if (Sender is TShape) then
  begin
    ConvertCoord((Sender as TControl), X, Y, px, py);
    pnMinimap.OnMouseDown(Sender, Button, Shift, px, py);
  end;
end;

procedure TfmMinimap.ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  px, py: integer;
begin
  if (Sender is TShape) then
  begin
    ConvertCoord((Sender as TControl), X, Y, px, py);
    pnMinimap.OnMouseMove(Sender, Shift, px, py);
  end;
end;

procedure TfmMinimap.ShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  px, py: integer;
begin
  if (Sender is TShape) then
  begin
    ConvertCoord((Sender as TControl), X, Y, px, py);
    pnMinimap.OnMouseUp(Sender, Button, Shift, px, py);
  end;
end;

procedure TfmMinimap.ConvertCoord(Control: TControl; X1, Y1: Integer; var X2, Y2: Integer);
var
  p1, p2: TPoint;
begin
  if (Control is TControl) then
  begin
    p1.x := X1;
    p1.y := Y1;
    p2 := (Control as TControl).ClientToScreen(p1);
    p1 := pnMinimap.ScreenToClient(p2);
    X2 := p1.x;
    Y2 := p1.y;
  end
  else
  begin
    X2 := X1;
    Y2 := Y1;
  end;
end;

procedure TfmMinimap.DestroyCurMinimap;
var
  i: integer;
  tmpComponent: TComponent;
begin
  for i := pnMinimap.ComponentCount - 1 downto 0 do
  begin
    tmpComponent := pnMinimap.Components[i];
    if (tmpComponent is TShape) then
      (tmpComponent as TShape).Free;
  end;
//  Cur_Zal_KodList.Clear;
end;

{$IFDEF uMinimap_DEBUG}
initialization
  DEBUGMess(0, 'uMinimap.Init');
{$ENDIF}

{$IFDEF uMinimap_DEBUG}
finalization
  DEBUGMess(0, 'uMinimap.Final');
{$ENDIF}

end.
