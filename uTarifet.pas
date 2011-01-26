{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uTarifet.pas
Version      : 15.10.2002 9:03:59
Description  : 
Creation     : 12.10.2002 9:03:59
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uTarifet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting;

type
  TfmTarifet = class(TSLForm)
    dbgTarifet: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edTarifet_Kod: TEdit;
    edTarifet_Nam: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edTarifet_KodChange(Sender: TObject);
    procedure dbgTarifetDblClick(Sender: TObject);
    procedure dbgTarifetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edTarifet_NamKeyPress(Sender: TObject; var Key: Char);
    procedure dbgTarifetKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Tarifet_Track_Rec;
  end;

var
  fmTarifet: TfmTarifet;

implementation

uses 
  uRescons,
  uDatamod;

{$R *.DFM}

procedure TfmTarifet.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmTarifet.Tarifet_Track_Rec;
var
  s1, s2: string;
begin
  dm.Tarifet_Track(s1, s2);
  edTarifet_Kod.Text := s1;
  edTarifet_Nam.Text := s2;
end;

procedure TfmTarifet.dbgTarifetDblClick(Sender: TObject);
begin
  edTarifet_Nam.SetFocus;
end;

procedure TfmTarifet.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edTarifet_Kod.Text = Kod_auto then
  begin
    if dm.Tarifet_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Tarifet_Add(Kod, edTarifet_Nam.Text);
        case Res of
        0:
          begin
            dbgTarifet.SetFocus;
            Tarifet_Track_Rec;
            //edTarifet_Nam.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edTarifet_Kod.Text := Kod_auto;
    edTarifet_Nam.Text := Tarifet_Nam_auto;
    edTarifet_Nam.SetFocus;
  end;
end;

procedure TfmTarifet.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edTarifet_Kod.Text) > 0 then
    try
      Kod := StrToInt(edTarifet_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Tarifet_Edit(Kod, edTarifet_Nam.Text);
        case Res of
        0:
          begin
            dbgTarifet.SetFocus;
            Tarifet_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmTarifet.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Tarifet_Track_Rec;
  if length(edTarifet_Kod.Text) > 0 then
    try
      Kod := StrToInt(edTarifet_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, edTarifet_Nam.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Tarifet_Del(Kod, edTarifet_Nam.Text);
        case Res of
        0:
          begin
            dbgTarifet.SetFocus;
            Tarifet_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmTarifet.edTarifet_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edTarifet_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edTarifet_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmTarifet.dbgTarifetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      edTarifet_Nam.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmTarifet.edTarifet_NamKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgTarifet.SetFocus;
    Tarifet_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edTarifet_Kod.Text = Kod_auto then
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

procedure TfmTarifet.dbgTarifetKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmTarifet.FormActivate(Sender: TObject);
begin
  with dm do
    Table_UnFilter(tTarifet, true);
  Tarifet_Track_Rec;
end;

{$IFDEF uTarifet_DEBUG}
initialization
  DEBUGMess(0, 'uTarifet.Init');
{$ENDIF}

{$IFDEF uTarifet_DEBUG}
finalization
  DEBUGMess(0, 'uTarifet.Final');
{$ENDIF}

end.
