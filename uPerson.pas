{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uPerson.pas
Version      : 15.10.2002 9:03:03
Description  : 
Creation     : 12.10.2002 9:03:03
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uPerson;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting;

type
  TfmPerson = class(TSLForm)
    dbgPerson: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edPerson_Kod: TEdit;
    edPerson_Nam_Sh: TEdit;
    edPerson_Nam_Ful: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    chbPerson_IsReji: TCheckBox;
    chbPerson_IsProd: TCheckBox;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edPerson_KodChange(Sender: TObject);
    procedure dbgPersonDblClick(Sender: TObject);
    procedure dbgPersonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPerson_Nam_ShKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPersonKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Person_Track_Rec;
  end;

var
  fmPerson: TfmPerson;

implementation

uses 
  uRescons,
  uDatamod;

{$R *.DFM}

procedure TfmPerson.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmPerson.Person_Track_Rec;
var
  s1, s2, s3: string;
  b1, b2: boolean;
begin
  dm.Person_Track(s1, s2, s3, b1, b2);
  edPerson_Kod.Text := s1;
  edPerson_Nam_Sh.Text := s2;
  edPerson_Nam_Ful.Text := s3;
  chbPerson_IsReji.Checked := b1;
  chbPerson_IsProd.Checked := b2;
end;

procedure TfmPerson.dbgPersonDblClick(Sender: TObject);
begin
  edPerson_Nam_Sh.SetFocus;
end;

procedure TfmPerson.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edPerson_Kod.Text = Kod_auto then
  begin
    if dm.Person_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Person_Add(Kod, edPerson_Nam_Sh.Text,
          edPerson_Nam_Ful.Text, chbPerson_IsReji.Checked,
          chbPerson_IsProd.Checked);
        case Res of
        0:
          begin
            dbgPerson.SetFocus;
            Person_Track_Rec;
            //edPerson_Nam_Sh.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edPerson_Kod.Text := Kod_auto;
    edPerson_Nam_Sh.Text := Person_Nam_auto;
    edPerson_Nam_Sh.SetFocus;
  end;
end;

procedure TfmPerson.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edPerson_Kod.Text) > 0 then
    try
      Kod := StrToInt(edPerson_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Person_Edit(Kod, edPerson_Nam_Sh.Text,
          edPerson_Nam_Ful.Text, chbPerson_IsReji.Checked,
          chbPerson_IsProd.Checked);
        case Res of
        0:
          begin
            dbgPerson.SetFocus;
            Person_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmPerson.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Person_Track_Rec;
  if length(edPerson_Kod.Text) > 0 then
    try
      Kod := StrToInt(edPerson_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, edPerson_Nam_Sh.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Person_Del(Kod, edPerson_Nam_Sh.Text);
        case Res of
        0:
          begin
            dbgPerson.SetFocus;
            Person_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmPerson.edPerson_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edPerson_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edPerson_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmPerson.dbgPersonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      edPerson_Nam_Sh.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmPerson.edPerson_Nam_ShKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgPerson.SetFocus;
    Person_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edPerson_Kod.Text = Kod_auto then
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

procedure TfmPerson.dbgPersonKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmPerson.FormActivate(Sender: TObject);
begin
  with dm do
    Table_UnFilter(tPerson, true);
  Person_Track_Rec;
end;

{$IFDEF uPerson_DEBUG}
initialization
  DEBUGMess(0, 'uPerson.Init');
{$ENDIF}

{$IFDEF uPerson_DEBUG}
finalization
  DEBUGMess(0, 'uPerson.Final');
{$ENDIF}

end.
