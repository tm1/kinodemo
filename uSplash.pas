{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uSplash.pas
Version      : 15.10.2002 9:03:54
Description  : 
Creation     : 12.10.2002 9:03:54
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, ExtCtrls, jpeg, StdCtrls;

type
  TfmSplash = class(TForm)
    pnSplash: TPanel;
    imSplash: TImage;
    ggSplash: TGauge;
    lbLoadTitle: TLabel;
    lbProgramTitle: TLabel;
    lbProgramTitleShadow: TLabel;
    bvLoadTitle: TBevel;
    bvProgramTitle: TBevel;
    btClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSplash: TfmSplash;

implementation

uses
  Bugger,
  uMain;

{$R *.DFM}

procedure TfmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'TfmSplash.FormClose';
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMess(0, '[' + ProcName + ']: Sender.Name = (' + (Sender as TComponent).Name + ')')
  else
    DEBUGMess(0, '[' + ProcName + ']: Sender is null.');
  if (Sender = btClose) then
  begin
    DEBUGMess(0, '[' + ProcName + ']: Application.Terminate called.');
    Application.Terminate;
  end
  else
    if not (Sender = fmMain) then
      Action := caNone;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

procedure TfmSplash.btCloseClick(Sender: TObject);
var
 tmp_Action: TCloseAction;
begin
  FormClose(btClose, tmp_Action); 
end;

{$IFDEF uSplash_DEBUG}
initialization
  DEBUGMess(0, 'uSplash.Init');
{$ENDIF}

{$IFDEF uSplash_DEBUG}
finalization
  DEBUGMess(0, 'uSplash.Final');
{$ENDIF}

end.
