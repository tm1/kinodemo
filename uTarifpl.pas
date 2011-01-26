{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uTarifpl.pas
Version      : 15.10.2002 9:04:03
Description  : 
Creation     : 12.10.2002 9:04:03
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uTarifpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting, ShpCtrl;

type
  TfmTarifpl = class(TSLForm)
    dbgTarifpl: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edTarifpl_Kod: TEdit;
    edTarifpl_Nam: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    chbTarifpl_Print: TCheckBox;
    chbTarifpl_Free: TCheckBox;
    chbTarifpl_Report: TCheckBox;
    chbTarifpl_Show: TCheckBox;
    ssTarifpl_Color: TTicketControl;
    ColorDialog1: TColorDialog;
    btTarifpl_BgColor: TButton;
    edTarifpl_Type: TEdit;
    btTarifpl_FntColor: TButton;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edTarifpl_KodChange(Sender: TObject);
    procedure dbgTarifplDblClick(Sender: TObject);
    procedure dbgTarifplKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edTarifpl_NamKeyPress(Sender: TObject; var Key: Char);
    procedure dbgTarifplKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure btTarifpl_BgColorClick(Sender: TObject);
    procedure ssTarifpl_ColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btTarifpl_FntColorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Tarifpl_Track_Rec;
  end;

var
  fmTarifpl: TfmTarifpl;

implementation

uses 
  uRescons,
  uDatamod;

{$R *.DFM}

procedure TfmTarifpl.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmTarifpl.Tarifpl_Track_Rec;
var
  s1, s2, s_i1: string;
  b1, b2, b3, b4, b5: boolean;
  i1, i2, i3: integer;
begin
  dm.Tarifpl_Track(s1, s2, b1, b2, b3, b4, b5, i1, i2, i3);
  edTarifpl_Kod.Text := s1;
  edTarifpl_Nam.Text := s2;
  chbTarifpl_Print.Checked := b1;
  chbTarifpl_Free.Checked := b2;
  chbTarifpl_Report.Checked := b3;
  chbTarifpl_Show.Checked := b4;
  if b5 then
  begin
    s_i1 := 'system';
    edTarifpl_Type.Tag := 1;
  end
  else
  begin
    if i1 in [0..4] then
      s_i1 := 'regular'
    else
      s_i1 := 'unknown';
    edTarifpl_Type.Tag := 0;
  end;
  edTarifpl_Type.Text := s_i1;
  with ssTarifpl_Color do
  begin
    FixedBrush.Color := TColor(i2);
    FixedFont.Color := TColor(i3);
    Hint := 'Background Color = ' + IntToStr(i2) + ' (' + IntToHex(i2, 8) + ')'
      + 'Font Color = ' + IntToStr(i3) + ' (' + IntToHex(i3, 8) + ')';
    ShowHint := true;
    TC_State := scFixed;
  end;
end;

procedure TfmTarifpl.dbgTarifplDblClick(Sender: TObject);
begin
  edTarifpl_Nam.SetFocus;
end;

procedure TfmTarifpl.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edTarifpl_Kod.Text = Kod_auto then
  begin
    if dm.Tarifpl_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Tarifpl_Add(Kod, edTarifpl_Nam.Text,
          chbTarifpl_Print.Checked, chbTarifpl_Free.Checked, chbTarifpl_Report.Checked, chbTarifpl_Show.Checked, False, 4, ssTarifpl_Color.FixedBrush.Color, ssTarifpl_Color.FixedFont.Color);
        case Res of
        0:
          begin
            dbgTarifpl.SetFocus;
            Tarifpl_Track_Rec;
            //edTarifpl_Nam.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edTarifpl_Kod.Text := Kod_auto;
    edTarifpl_Nam.Text := Tarifpl_Nam_auto;
    edTarifpl_Nam.SetFocus;
  end;
end;

procedure TfmTarifpl.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edTarifpl_Kod.Text) > 0 then
    try
      Kod := StrToInt(edTarifpl_Kod.Text);
      if (Kod > 0) and (edTarifpl_Type.Tag = 0) then
      begin
        Res := dm.Tarifpl_Edit(Kod, edTarifpl_Nam.Text,                                                                                                 
          chbTarifpl_Print.Checked, chbTarifpl_Free.Checked, chbTarifpl_Report.Checked, chbTarifpl_Show.Checked, edTarifpl_Type.Tag = 1, 4, ssTarifpl_Color.FixedBrush.Color, ssTarifpl_Color.FixedFont.Color);
        case Res of
        0:
          begin
            dbgTarifpl.SetFocus;
            Tarifpl_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmTarifpl.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Tarifpl_Track_Rec;
  if (length(edTarifpl_Kod.Text) > 0) and (edTarifpl_Type.Tag = 0) then
    try
      Kod := StrToInt(edTarifpl_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, edTarifpl_Nam.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Tarifpl_Del(Kod, edTarifpl_Nam.Text);
        case Res of
        0:
          begin
            dbgTarifpl.SetFocus;
            Tarifpl_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmTarifpl.edTarifpl_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edTarifpl_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edTarifpl_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmTarifpl.dbgTarifplKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      edTarifpl_Nam.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmTarifpl.edTarifpl_NamKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgTarifpl.SetFocus;
    Tarifpl_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edTarifpl_Kod.Text = Kod_auto then
      begin
        if btAddRec.Enabled then
          btAddRec.SetFocus;
      end
      else
      begin
        if btEditRec.Enabled then
          btEditRec.SetFocus;
      end;
end;

procedure TfmTarifpl.dbgTarifplKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmTarifpl.FormActivate(Sender: TObject);
begin
  with dm do
  begin
    Table_UnFilter(tTarifpl, true);
    tTarifpl.EnableControls;
  end;
  Tarifpl_Track_Rec;
end;

procedure TfmTarifpl.btTarifpl_BgColorClick(Sender: TObject);
begin
  ColorDialog1.Color := ssTarifpl_Color.FixedBrush.Color;
  ssTarifpl_Color.Selected := false;
  if ColorDialog1.Execute then
  begin
    ssTarifpl_Color.Hint := '_OLD_ Numerical Color = ' + IntToStr(ssTarifpl_Color.FixedBrush.Color) + ' (' + IntToHex(ssTarifpl_Color.FixedBrush.Color, 8) + ')'
     + CRLF + '_NEW_ Numerical Color = ' + IntToStr(ColorDialog1.Color) + ' (' + IntToHex(ColorDialog1.Color, 8) + ')';
    ssTarifpl_Color.FixedBrush.Color := ColorDialog1.Color;
  end;
end;

procedure TfmTarifpl.ssTarifpl_ColorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    if Sender is TTicketControl then
      if (Sender as TTicketControl).TC_State = scFree then
        (Sender as TTicketControl).TC_State := scFixed
      else
        (Sender as TTicketControl).TC_State := scFree;
end;

procedure TfmTarifpl.btTarifpl_FntColorClick(Sender: TObject);
begin
  ColorDialog1.Color := ssTarifpl_Color.FixedFont.Color;
  ssTarifpl_Color.Selected := false;
  if ColorDialog1.Execute then
  begin
    ssTarifpl_Color.Hint := '_OLD_ Numerical Color = ' + IntToStr(ssTarifpl_Color.FixedFont.Color) + ' (' + IntToHex(ssTarifpl_Color.FixedFont.Color, 8) + ')'
     + CRLF + '_NEW_ Numerical Color = ' + IntToStr(ColorDialog1.Color) + ' (' + IntToHex(ColorDialog1.Color, 8) + ')';
    ssTarifpl_Color.FixedFont.Color := ColorDialog1.Color;
  end;
end;

{$IFDEF uTarifpl_DEBUG}
initialization
  DEBUGMess(0, 'uTarifpl.Init');
{$ENDIF}

{$IFDEF uTarifpl_DEBUG}
finalization
  DEBUGMess(0, 'uTarifpl.Final');
{$ENDIF}

end.
