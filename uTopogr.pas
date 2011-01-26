{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uTopogr.pas
Version      : 15.10.2002 9:04:27
Description  : 
Creation     : 12.10.2002 9:04:27
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uTopogr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, ExtCtrls, Spin, uSetting,
  Gauges, ShpCtrl, ComCtrls, uDatamod;

type
  TfmTopogr = class(TSLForm)
    pnBottom: TPanel;
    btCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    gbSheme: TGroupBox;
    ggProgress: TGauge;
    sbxTopogr: TScrollBox;
    pnContainer: TPanel;
    dbgTopogr: TDBGrid;
    procedure btCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Created: Boolean;
  public
    { Public declarations }
  end;

var
  fmTopogr: TfmTopogr;

implementation

uses
  uRescons,
  uCells;

{$R *.DFM}

procedure TfmTopogr.btCancelClick(Sender: TObject);
begin
  // Close
  Close;
end;

procedure TfmTopogr.FormActivate(Sender: TObject);
begin
  //
  if not Created then
  begin
//    CreateZal(CurZalList, 1, ggProgress, pnContainer, 0, MultiplrTopo, true);
    pnContainer.Visible := true;
  end;
end;

procedure TfmTopogr.FormCreate(Sender: TObject);
begin
  Created := false;
end;

{$IFDEF uTopogr_DEBUG}
initialization
  DEBUGMess(0, 'uTopogr.Init');
{$ENDIF}

{$IFDEF uTopogr_DEBUG}
finalization
  DEBUGMess(0, 'uTopogr.Final');
{$ENDIF}

end.
