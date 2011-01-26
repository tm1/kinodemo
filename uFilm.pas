{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uFilm.pas
Version      : 15.10.2002 9:02:04
Description  : 
Creation     : 12.10.2002 9:02:04
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uFilm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, Buttons, uSetting,
  ShpCtrl;

type
  TfmFilm = class(TSLForm)
    dbgFilm: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edFilm_Kod: TEdit;
    edFilm_Nam: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cmGenre: TComboBox;
    cmRejiser: TComboBox;
    cmProducer: TComboBox;
    cmProizv: TComboBox;
    btGenre: TWc_BitBtn;
    btRejiser: TWc_BitBtn;
    btProducer: TWc_BitBtn;
    btProizv: TWc_BitBtn;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edFilm_KodChange(Sender: TObject);
    procedure dbgFilmDblClick(Sender: TObject);
    procedure dbgFilmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFilm_NamKeyPress(Sender: TObject; var Key: Char);
    procedure dbgFilmKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure cmGenreKeyPress(Sender: TObject; var Key: Char);
    procedure cmRejiserKeyPress(Sender: TObject; var Key: Char);
    procedure cmProducerKeyPress(Sender: TObject; var Key: Char);
    procedure cmProizvKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Film_Track_Rec;
  end;

var
  fmFilm: TfmFilm;

implementation

uses
  uRescons,
  uDatamod,
  uMain;

{$R *.DFM}

procedure TfmFilm.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmFilm.Film_Track_Rec;
var
  s1, s2: string;
  i1, i2, i3, i4: integer;
begin
  dm.Film_Track(s1, s2, i1, i2, i3, i4);
  edFilm_Kod.Text := s1;
  edFilm_Nam.Text := s2;
  with cmGenre do
    ItemIndex := Items.IndexOfObject(TObject(i1));
  with cmRejiser do
    ItemIndex := Items.IndexOfObject(TObject(i2));
  with cmProducer do
    ItemIndex := Items.IndexOfObject(TObject(i3));
  with cmProizv do
    ItemIndex := Items.IndexOfObject(TObject(i4));
end;

procedure TfmFilm.dbgFilmDblClick(Sender: TObject);
begin
  edFilm_Nam.SetFocus;
end;

procedure TfmFilm.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edFilm_Kod.Text = Kod_auto then
  begin
    if dm.Film_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Film_Add(Kod, edFilm_Nam.Text,
          Integer(cmGenre.Items.Objects[cmGenre.ItemIndex]),
          Integer(cmRejiser.Items.Objects[cmRejiser.ItemIndex]),
          Integer(cmProducer.Items.Objects[cmProducer.ItemIndex]),
          Integer(cmProizv.Items.Objects[cmProizv.ItemIndex]));
        case Res of
        0:
          begin
            dbgFilm.SetFocus;
            Film_Track_Rec;
            //edFilm_Nam.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edFilm_Kod.Text := Kod_auto;
    edFilm_Nam.Text := Film_Nam_auto;
    edFilm_Nam.SetFocus;
  end;
end;

procedure TfmFilm.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edFilm_Kod.Text) > 0 then
    try
      Kod := StrToInt(edFilm_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Film_Edit(Kod, edFilm_Nam.Text,
          Integer(cmGenre.Items.Objects[cmGenre.ItemIndex]),
          Integer(cmRejiser.Items.Objects[cmRejiser.ItemIndex]),
          Integer(cmProducer.Items.Objects[cmProducer.ItemIndex]),
          Integer(cmProizv.Items.Objects[cmProizv.ItemIndex]));
        case Res of
        0:
          begin
            dbgFilm.SetFocus;
            Film_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmFilm.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Film_Track_Rec;
  if length(edFilm_Kod.Text) > 0 then
    try
      Kod := StrToInt(edFilm_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, edFilm_Nam.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Film_Del(Kod, edFilm_Nam.Text);
        case Res of
        0:
          begin
            dbgFilm.SetFocus;
            Film_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmFilm.edFilm_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edFilm_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edFilm_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmFilm.dbgFilmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      edFilm_Nam.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmFilm.edFilm_NamKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgFilm.SetFocus;
    Film_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      cmGenre.SetFocus;
{      if edFilm_Kod.Text = Kod_auto then
      begin
        if btAddRec.Enabled then
          btAddRec.SetFocus;
      end
      else
      begin
        if btEditRec.Enabled then
          btEditRec.SetFocus;
      end;}
end;

procedure TfmFilm.dbgFilmKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmFilm.FormActivate(Sender: TObject);
begin
  //
  with dm do
  begin
    Table_UnFilter(tGenre, true);
    Table_UnFilter(tPerson, true);
    Table_UnFilter(tProizv, true);
    Table_UnFilter(tProizv, true);
    Table_UnFilter(tFilm, true);
    with cmGenre do
    begin
      PrepareQuery_Genre(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
    with cmRejiser do
    begin
      PrepareQuery_Rejiser(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
    with cmProducer do
    begin
      PrepareQuery_Producer(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
    with cmProizv do
    begin
      PrepareQuery_Proizv(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
  end;
  Film_Track_Rec;
end;

procedure TfmFilm.cmGenreKeyPress(Sender: TObject; var Key: Char);
begin
  //
  if Key = #27 then
  begin
    Key := #0;
    dbgFilm.SetFocus;
    Film_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      cmRejiser.SetFocus;
end;

procedure TfmFilm.cmRejiserKeyPress(Sender: TObject; var Key: Char);
begin
  //
  if Key = #27 then
  begin
    Key := #0;
    dbgFilm.SetFocus;
    Film_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      cmProducer.SetFocus;
end;

procedure TfmFilm.cmProducerKeyPress(Sender: TObject; var Key: Char);
begin
  //
  if Key = #27 then
  begin
    Key := #0;
    dbgFilm.SetFocus;
    Film_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      cmProizv.SetFocus;
end;

procedure TfmFilm.cmProizvKeyPress(Sender: TObject; var Key: Char);
begin
  //
  if Key = #27 then
  begin
    Key := #0;
    dbgFilm.SetFocus;
    Film_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edFilm_Kod.Text = Kod_auto then
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

{$IFDEF uFilm_DEBUG}
initialization
  DEBUGMess(0, 'uFilm.Init');
{$ENDIF}

{$IFDEF uFilm_DEBUG}
finalization
  DEBUGMess(0, 'uFilm.Final');
{$ENDIF}

end.
