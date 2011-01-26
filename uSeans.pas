{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uSeans.pas
Version      : 15.10.2002 9:03:36
Description  : 
Creation     : 12.10.2002 9:03:36
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uSeans;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, Spin, uSetting;

type
  TfmSeans = class(TSLForm)
    dbgSeans: TDBGrid;
    gbEdit: TGroupBox;
    pnBottom: TPanel;
    btCancel: TButton;
    edSeans_Kod: TEdit;
    btAddRec: TButton;
    btEditRec: TButton;
    btDeleteRec: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    spSeans_Hour: TSpinEdit;
    spSeans_Minute: TSpinEdit;
    procedure btCancelClick(Sender: TObject);
    procedure btAddRecClick(Sender: TObject);
    procedure btEditRecClick(Sender: TObject);
    procedure btDeleteRecClick(Sender: TObject);
    procedure edSeans_KodChange(Sender: TObject);
    procedure dbgSeansDblClick(Sender: TObject);
    procedure dbgSeansKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure spSeans_HourKeyPress(Sender: TObject; var Key: Char);
    procedure spSeans_MinuteKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSeansKeyPress(Sender: TObject; var Key: Char);
    procedure spSeansHMChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Seans_Track_Rec;
  end;

var
  fmSeans: TfmSeans;

implementation

uses 
  uRescons,
  uDatamod;

{$R *.DFM}

procedure TfmSeans.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmSeans.Seans_Track_Rec;
var
  s1, s2, s3: string;
begin
  dm.Seans_Track(s1, s2, s3);
  edSeans_Kod.Text := s1;
  spSeans_Hour.Text := s2;
  spSeans_Minute.Text := s3;
end;

procedure TfmSeans.dbgSeansDblClick(Sender: TObject);
begin
  spSeans_Hour.SetFocus;
end;

procedure TfmSeans.btAddRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  // ready
  if edSeans_Kod.Text = Kod_auto then
  begin
    if dm.Seans_Add_GenKod(Kod) = 0 then
      if Kod > 0 then
      begin
        Res := dm.Seans_Add(Kod, spSeans_Hour.Value, spSeans_Minute.Value);
        case Res of
        0:
          begin
            dbgSeans.SetFocus;
            Seans_Track_Rec;
            //spSeans_Hour.SetFocus;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
  end
  else
  begin
    edSeans_Kod.Text := Kod_auto;
    spSeans_Hour.Text := Seans_Hour_auto;
    spSeans_Minute.Text := Seans_Minute_auto;
    spSeans_Hour.SetFocus;
  end;
end;

procedure TfmSeans.btEditRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  if length(edSeans_Kod.Text) > 0 then
    try
      Kod := StrToInt(edSeans_Kod.Text);
      if Kod > 0 then
      begin
        Res := dm.Seans_Edit(Kod, spSeans_Hour.Value, spSeans_Minute.Value);
        case Res of
        0:
          begin
            dbgSeans.SetFocus;
            Seans_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmSeans.btDeleteRecClick(Sender: TObject);
var
  Kod, Res: integer;
begin
  //
  Seans_Track_Rec;
  if length(edSeans_Kod.Text) > 0 then
    try
      Kod := StrToInt(edSeans_Kod.Text);
      if (Kod > 0) and (Application.MessageBox(
        PChar(format(Delete_Mess, [Kod, spSeans_Hour.Text + ':' + spSeans_Minute.Text])),
        PChar(Warning_Caption),
        MB_YESNO + MB_DEFBUTTON1) = IDYES) then
      begin
        Res := dm.Seans_Del(Kod, spSeans_Hour.Value, spSeans_Minute.Value);
        case Res of
        0:
          begin
            dbgSeans.SetFocus;
            Seans_Track_Rec;
          end;
        1,2,3,4,6: ShowMessage(errArray[Res]);
        else
          ShowMessage(errArray[5]);
        end;
      end;
    except
    end;
end;

procedure TfmSeans.edSeans_KodChange(Sender: TObject);
var
  tmp: integer;
begin
  //
  try
    if edSeans_Kod.Text = Kod_auto then
      tmp := -1
    else
      tmp := StrToInt(edSeans_Kod.Text);
  except
    tmp := 0;
  end;
  btEditRec.Enabled := (tmp > 0);
  btDeleteRec.Enabled := btEditRec.Enabled;
end;

procedure TfmSeans.dbgSeansKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  case Key of
  VK_INSERT:
    btAddRecClick(nil);
  VK_RETURN:
    begin
      Key := 0;
      spSeans_Hour.SetFocus;
    end;
  VK_DELETE:
    btDeleteRecClick(nil);
  else
  end;
end;

procedure TfmSeans.spSeans_HourKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgSeans.SetFocus;
    Seans_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      spSeans_Minute.SetFocus;
end;

procedure TfmSeans.spSeans_MinuteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    dbgSeans.SetFocus;
    Seans_Track_Rec;
  end
  else
    if Key = CarriageReturn then
      if edSeans_Kod.Text = Kod_auto then
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

procedure TfmSeans.dbgSeansKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    btCancel.SetFocus;
  end;
end;

procedure TfmSeans.spSeansHMChange(Sender: TObject);
begin
  if (Sender is TSpinEdit) then
    if (Sender as TSpinEdit).Text = '' then
      (Sender as TSpinEdit).Value := 0;
end;

procedure TfmSeans.FormActivate(Sender: TObject);
begin
  with dm do
    Table_UnFilter(tSeans, true);
  Seans_Track_Rec;
end;

{$IFDEF uSeans_DEBUG}
initialization
  DEBUGMess(0, 'uSeans.Init');
{$ENDIF}

{$IFDEF uSeans_DEBUG}
finalization
  DEBUGMess(0, 'uSeans.Final');
{$ENDIF}

end.
