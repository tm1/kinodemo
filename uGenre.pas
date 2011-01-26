{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uGenre.pas
Version      : 15.10.2002 9:02:15
Description  : 
Creation     : 12.10.2002 9:02:15
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uGenre;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting;

type
  TfmGenre = class(TSLForm)
    dbgGenre: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edGenre_Kod: TEdit;
    edGenre_Nam: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edGenre_KodChange(Sender: TObject);
    procedure dbgGenreDblClick(Sender: TObject);
    procedure dbgGenreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edGenre_NamKeyPress(Sender: TObject; var Key: Char);
    procedure dbgGenreKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Genre_Track_Rec;
  end;

var
  fmGenre: TfmGenre;

implementation

uses
  uRescons,
  uDatamod;

{$R *.DFM}

procedure TfmGenre.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmGenre.Genre_Track_Rec;
var
  s1, s2: string;
begin
  dm.Genre_Track(s1, s2);
  edGenre_Kod.Text := s1;
  edGenre_Nam.Text := s2;
end;

procedure TfmGenre.dbgGenreDblClick(Sender: TObject);
begin
  edGenre_Nam.SetFocus;
end;

procedure TfmGenre.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edGenre_Kod.Text = Kod_auto then
  begin
    if dm.Genre_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Genre_Add(Kod, edGenre_Nam.Text);
        case Res of
        0:
          begin
            dbgGenre.SetFocus;
            Genre_Track_Rec;
            //edGenre_Nam.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edGenre_Kod.Text := Kod_auto;
    edGenre_Nam.Text := Genre_Nam_auto;
    edGenre_Nam.SetFocus;
  end;
end;

procedure TfmGenre.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edGenre_Kod.Text) > 0 then
    try
      Kod := StrToInt(edGenre_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Genre_Edit(Kod, edGenre_Nam.Text);
        case Res of
        0:
          begin
            dbgGenre.SetFocus;
            Genre_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmGenre.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Genre_Track_Rec;
  if length(edGenre_Kod.Text) > 0 then
    try
      Kod := StrToInt(edGenre_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, edGenre_Nam.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Genre_Del(Kod, edGenre_Nam.Text);
        case Res of
        0:
          begin
            dbgGenre.SetFocus;
            Genre_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmGenre.edGenre_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edGenre_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edGenre_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmGenre.dbgGenreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      edGenre_Nam.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmGenre.edGenre_NamKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgGenre.SetFocus;
    Genre_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edGenre_Kod.Text = Kod_auto then
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

procedure TfmGenre.dbgGenreKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmGenre.FormActivate(Sender: TObject);
begin
  with dm do
    Table_UnFilter(tGenre, true);
  Genre_Track_Rec;
end;

{$IFDEF uGenre_DEBUG}
initialization
  DEBUGMess(0, 'uGenre.Init');
{$ENDIF}

{$IFDEF uGenre_DEBUG}
finalization
  DEBUGMess(0, 'uGenre.Final');
{$ENDIF}

end.
