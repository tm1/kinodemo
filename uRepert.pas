{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uRepert.pas
Version      : 15.10.2002 9:03:25
Description  :
Creation     : 12.10.2002 9:03:25
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uRepert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, uSetting, ComCtrls,
  Buttons, ShpCtrl;

type
  TfmRepert = class(TSLForm)
    btCancel: TButton;
    dbgRepert: TDBGrid;
    pnBottom: TPanel;
    gbEdit: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edRepert_Kod: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    dtpDate_Filt: TDateTimePicker;
    cmSeans: TComboBox;
    cmZal_Filt: TComboBox;
    btSeans: TWc_BitBtn;
    btFilm: TWc_BitBtn;
    btTarifz: TWc_BitBtn;
    cmFilm: TComboBox;
    cmTarifet: TComboBox;
    Label6: TLabel;
    chFiltrate: TCheckBox;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edRepert_KodChange(Sender: TObject);
    procedure dbgRepertDblClick(Sender: TObject);
    procedure dbgRepertKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmRepert_FilmKeyPress(Sender: TObject; var Key: Char);
    procedure dbgRepertKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure chFiltrateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Repert_Track_Rec;
  end;

var
  fmRepert: TfmRepert;

implementation

uses
  uRescons,
  uDatamod,
  uMain;

{$R *.DFM}

procedure TfmRepert.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmRepert.Repert_Track_Rec;
var
  Res: integer;
  s1: string;
  d1: TDateTime;
  i1, i2, i3, i4: integer;
begin
  Res := dm.Repert_Track(s1, d1, i1, i2, i3, i4);
  edRepert_Kod.Text := s1;
//  dtpDate.DateTime := d1;
  if Res = 0 then
  begin
    with cmSeans do
      ItemIndex := Items.IndexOfObject(TObject(i1));
    with cmFilm do
      ItemIndex := Items.IndexOfObject(TObject(i2));
    with cmTarifet do
      ItemIndex := Items.IndexOfObject(TObject(i3));
//    with cmZal do
//      ItemIndex := Items.IndexOfObject(TObject(i4));
  end
  else
  begin
    with cmSeans do
      if cmSeans.Items.Count > 0 then
        ItemIndex := 0
      else
        ItemIndex := -1;
    with cmFilm do
      if cmSeans.Items.Count > 0 then
        ItemIndex := 0
      else
        ItemIndex := -1;
    with cmTarifet do
      if cmSeans.Items.Count > 0 then
        ItemIndex := 0
      else
        ItemIndex := -1;
//    with cmZal do
//      if cmSeans.Items.Count > 0 then
//        ItemIndex := 0
//      else
//        ItemIndex := -1;
  end;
end;

procedure TfmRepert.dbgRepertDblClick(Sender: TObject);
begin
  cmFilm.SetFocus;
end;

procedure TfmRepert.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edRepert_Kod.Text = Kod_auto then
  begin
    if dm.Repert_Add_GenKod(Kod) = 0 then
      if (Kod > 0) and (cmSeans.ItemIndex <> -1)
        and (cmFilm.ItemIndex <> -1)
        and (cmTarifet.ItemIndex <> -1)
        and (cmZal_Filt.ItemIndex <> -1) then
      begin
        Res := dm.Repert_Add(Kod, dtpDate_Filt.DateTime,
          Integer(cmSeans.Items.Objects[cmSeans.ItemIndex]),
          Integer(cmFilm.Items.Objects[cmFilm.ItemIndex]),
          Integer(cmTarifet.Items.Objects[cmTarifet.ItemIndex]),
          Integer(cmZal_Filt.Items.Objects[cmZal_Filt.ItemIndex]));
        case Res of
        0:
          begin
            dbgRepert.SetFocus;
            Repert_Track_Rec;
            //edRepert_Nam.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edRepert_Kod.Text := Kod_auto;
//    edRepert_Nam.Text := Repert_Nam_auto;
    cmFilm.SetFocus;
  end;
end;

procedure TfmRepert.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edRepert_Kod.Text) > 0 then
    try
      Kod := StrToInt(edRepert_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Repert_Edit(Kod, dtpDate_Filt.DateTime,
          Integer(cmSeans.Items.Objects[cmSeans.ItemIndex]),
          Integer(cmFilm.Items.Objects[cmFilm.ItemIndex]),
          Integer(cmTarifet.Items.Objects[cmTarifet.ItemIndex]),
          Integer(cmZal_Filt.Items.Objects[cmZal_Filt.ItemIndex]));
        case Res of
        0:
          begin
            dbgRepert.SetFocus;
            Repert_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmRepert.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Repert_Track_Rec;
  if length(edRepert_Kod.Text) > 0 then
    try
      Kod := StrToInt(edRepert_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, cmFilm.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Repert_Del(Kod, dtpDate_Filt.DateTime,
          Integer(cmSeans.Items.Objects[cmSeans.ItemIndex]));
        case Res of
        0:
          begin
            dbgRepert.SetFocus;
            Repert_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmRepert.edRepert_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edRepert_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edRepert_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmRepert.dbgRepertKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      cmFilm.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmRepert.cmRepert_FilmKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgRepert.SetFocus;
    Repert_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edRepert_Kod.Text = Kod_auto then
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

procedure TfmRepert.dbgRepertKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmRepert.FormActivate(Sender: TObject);
begin
  //
  with dm do
  begin
    Table_UnFilter(tSeans, true);
    Table_UnFilter(tFilm, true);
    Table_UnFilter(tTarifet, true);
    Table_UnFilter(tZal, true);
    with cmSeans do
    begin
      PrepareQuery_Seans(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
    with cmFilm do
    begin
      PrepareQuery_Film(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
    with cmTarifet do
    begin
      PrepareQuery_Tarifet_SQL(0, 0, Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
    with cmZal_Filt do
    begin
      PrepareQuery_Zal(Items);
      if Items.Count > 0 then
        ItemIndex := 0;
    end;
  end;
  dtpDate_Filt.DateTime := Date;
  chFiltrate.Checked := true;
  chFiltrate.OnClick(nil);
  Repert_Track_Rec;
end;

procedure TfmRepert.chFiltrateClick(Sender: TObject);
begin
  //
  if chFiltrate.Checked then
  begin
    DateSeparator := '.';
//    if not dm.tRepert.Filtered then
      dm.Table_Filter(dm.tRepert, '(' + s_Repert_DATE + ' = ' + Kav + DateToStr(dtpDate_Filt.Date) + Kav + ') AND (' +
        s_Repert_Zal + ' = ' + IntToStr(Integer(cmZal_Filt.Items.Objects[cmZal_Filt.ItemIndex])) + ')', false);
  end
  else
  begin
//    if dm.tRepert.Filtered then
      dm.Table_UnFilter(dm.tRepert, true);
  end;
end;

procedure TfmRepert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  chFiltrate.Checked := false;
  chFiltrate.OnClick(nil);
end;

{$IFDEF uRepert_DEBUG}
initialization
  DEBUGMess(0, 'uRepert.Init');
{$ENDIF}

{$IFDEF uRepert_DEBUG}
finalization
  DEBUGMess(0, 'uRepert.Final');
{$ENDIF}

end.
