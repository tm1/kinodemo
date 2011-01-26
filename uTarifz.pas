{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uTarifz.pas
Version      : 15.10.2002 9:04:12
Description  : 
Creation     : 12.10.2002 9:04:12
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uTarifz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting, Buttons,
  Spin, ShpCtrl;
            
type
  TfmTarifz = class(TSLForm)
    dbgTarifz: TDBGrid;
    pnBottom: TPanel;
    btCancel: TButton;
    gbEdit: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edTarifz_Kod: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    cmTarifpl: TComboBox;
    btTarifpl: TWc_BitBtn;
    btTarifet: TWc_BitBtn;
    cmTarifet: TComboBox;
    seTarifz_Cost: TSpinEdit;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edTarifz_KodChange(Sender: TObject);
    procedure dbgTarifzDblClick(Sender: TObject);
    procedure dbgTarifzKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seTarifz_CostKeyPress(Sender: TObject; var Key: Char);
    procedure dbgTarifzKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure cmTarifetChange(Sender: TObject);
    procedure seTarifz_CostChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Tarifz_Track_Rec;
  end;

var
  fmTarifz: TfmTarifz;

implementation

uses
  uRescons,
  uDatamod,
  uMain;

{$R *.DFM}

procedure TfmTarifz.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmTarifz.Tarifz_Track_Rec;
var
  s1: string;
  i1, i2: integer;
begin
  dm.Tarifz_Track(s1, i1, i2);
  edTarifz_Kod.Text := s1;
  with cmTarifpl do
    ItemIndex := Items.IndexOfObject(TObject(i1));
  seTarifz_Cost.Value := i2;
end;

procedure TfmTarifz.dbgTarifzDblClick(Sender: TObject);
begin
  seTarifz_Cost.SetFocus;
end;

procedure TfmTarifz.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edTarifz_Kod.Text = Kod_auto then
  begin
    if dm.Tarifz_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Tarifz_Add(Kod,
          Integer(cmTarifpl.Items.Objects[cmTarifpl.ItemIndex]),
          Integer(cmTarifet.Items.Objects[cmTarifet.ItemIndex]),
          seTarifz_Cost.Value);
        case Res of
        0:
          begin
            dbgTarifz.SetFocus;
            Tarifz_Track_Rec;
            //seTarifz_Cost.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edTarifz_Kod.Text := Kod_auto;
    seTarifz_Cost.Value := Tarifz_Cost_auto;
    seTarifz_Cost.SetFocus;
  end;
end;

procedure TfmTarifz.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edTarifz_Kod.Text) > 0 then
    try
      Kod := StrToInt(edTarifz_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Tarifz_Edit(Kod,
          Integer(cmTarifpl.Items.Objects[cmTarifpl.ItemIndex]),
          Integer(cmTarifet.Items.Objects[cmTarifet.ItemIndex]),
          seTarifz_Cost.Value);
        case Res of
        0:
          begin
            dbgTarifz.SetFocus;
            Tarifz_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmTarifz.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Tarifz_Track_Rec;
  if length(edTarifz_Kod.Text) > 0 then
    try
      Kod := StrToInt(edTarifz_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, seTarifz_Cost.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Tarifz_Del(Kod, seTarifz_Cost.Value);
        case Res of
        0:
          begin
            dbgTarifz.SetFocus;
            Tarifz_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmTarifz.edTarifz_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edTarifz_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edTarifz_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
  cmTarifpl.Enabled := not btEditRec.Enabled;
end;

procedure TfmTarifz.dbgTarifzKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      seTarifz_Cost.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmTarifz.seTarifz_CostKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgTarifz.SetFocus;
    Tarifz_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edTarifz_Kod.Text = Kod_auto then
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

procedure TfmTarifz.dbgTarifzKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmTarifz.FormActivate(Sender: TObject);
begin
  //
  with dm do
  begin
    with cmTarifet do
    begin
      PrepareQuery_Tarifet_SQL(0, 0, Items);
      if Items.Count > 0 then
        ItemIndex := 0;
      cmTarifet.OnChange(nil);
    end;
    with cmTarifpl do
    begin
      PrepareQuery_Tarifpl_SQL(2, -1, false, Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
  end;
  Tarifz_Track_Rec;
end;

procedure TfmTarifz.cmTarifetChange(Sender: TObject);
var
  i: integer;
begin
  //
  with dm.tTarifz do
  begin
    // DisableControls;
    i := Integer(cmTarifet.Items.Objects[cmTarifet.ItemIndex]);
    Filtered := false;
    Filter := s_Tarifz_ET + ' = ' + IntToStr(i);
    Filtered := true;
    // EnableControls;
  end;
end;

procedure TfmTarifz.seTarifz_CostChange(Sender: TObject);
begin
  if seTarifz_Cost.Text = '' then
  begin
    seTarifz_Cost.Text := '0';
    seTarifz_Cost.SelectAll;
  end
  else
//    seTarifz_Cost.Text := IntToStr(seTarifz_Cost.Value);
end;

{$IFDEF uTarifz_DEBUG}
initialization
  DEBUGMess(0, 'uTarifz.Init');
{$ENDIF}

{$IFDEF uTarifz_DEBUG}
finalization
  DEBUGMess(0, 'uTarifz.Final');
{$ENDIF}

end.
