{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uProizv.pas
Version      : 15.10.2002 9:03:19
Description  : 
Creation     : 12.10.2002 9:03:19
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uProizv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting;

type
  TfmProizv = class(TSLForm)
    dbgProizv: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edProizv_Kod: TEdit;
    edProizv_Nam: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edProizv_KodChange(Sender: TObject);
    procedure dbgProizvDblClick(Sender: TObject);
    procedure dbgProizvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edProizv_NamKeyPress(Sender: TObject; var Key: Char);
    procedure dbgProizvKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Proizv_Track_Rec;
  end;

var
  fmProizv: TfmProizv;

implementation

uses 
  uRescons,
  uDatamod;

{$R *.DFM}

procedure TfmProizv.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmProizv.Proizv_Track_Rec;
var
  s1, s2: string;
begin
  dm.Proizv_Track(s1, s2);
  edProizv_Kod.Text := s1;
  edProizv_Nam.Text := s2;
end;

procedure TfmProizv.dbgProizvDblClick(Sender: TObject);
begin
  edProizv_Nam.SetFocus;
end;

procedure TfmProizv.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edProizv_Kod.Text = Kod_auto then
  begin
    if dm.Proizv_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Proizv_Add(Kod, edProizv_Nam.Text);
        case Res of
        0:
          begin
            dbgProizv.SetFocus;
            Proizv_Track_Rec;
            //edProizv_Nam.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edProizv_Kod.Text := Kod_auto;
    edProizv_Nam.Text := Proizv_Nam_auto;
    edProizv_Nam.SetFocus;
  end;
end;

procedure TfmProizv.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edProizv_Kod.Text) > 0 then
    try
      Kod := StrToInt(edProizv_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Proizv_Edit(Kod, edProizv_Nam.Text);
        case Res of
        0:
          begin
            dbgProizv.SetFocus;
            Proizv_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmProizv.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Proizv_Track_Rec;
  if length(edProizv_Kod.Text) > 0 then
    try
      Kod := StrToInt(edProizv_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, edProizv_Nam.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Proizv_Del(Kod, edProizv_Nam.Text);
        case Res of
        0:
          begin
            dbgProizv.SetFocus;
            Proizv_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmProizv.edProizv_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edProizv_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edProizv_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmProizv.dbgProizvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      edProizv_Nam.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmProizv.edProizv_NamKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgProizv.SetFocus;
    Proizv_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edProizv_Kod.Text = Kod_auto then
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

procedure TfmProizv.dbgProizvKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmProizv.FormActivate(Sender: TObject);
begin
  with dm do
    Table_UnFilter(tProizv, true);
  Proizv_Track_Rec;
end;

{$IFDEF uProizv_DEBUG}
initialization
  DEBUGMess(0, 'uProizv.Init');
{$ENDIF}

{$IFDEF uProizv_DEBUG}
finalization
  DEBUGMess(0, 'uProizv.Final');
{$ENDIF}

end.
