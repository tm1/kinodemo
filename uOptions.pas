{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uOptions.pas
Version      : 
Description  : 
Creation     : 12.10.2002 9:02:54
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uSetting;

type
  TfmOptions = class(TSLForm)
    GroupBox1: TGroupBox;
    btOK: TButton;
    btCancel: TButton;
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOptions: TfmOptions;

implementation

{$R *.DFM}

procedure TfmOptions.btOKClick(Sender: TObject);
begin
  // Apply Settings
  Close;
end;

procedure TfmOptions.btCancelClick(Sender: TObject);
begin
  // Just exit
  Close;
end;

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  SaveWindowState := false;
end;

{$IFDEF uOptions_DEBUG}
initialization
  DEBUGMess(0, 'uOptions.Init');
{$ENDIF}

{$IFDEF uOptions_DEBUG}
finalization
  DEBUGMess(0, 'uOptions.Final');
{$ENDIF}

end.
