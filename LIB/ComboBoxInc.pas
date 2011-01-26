unit ComboBoxInc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
Dialogs,
  StdCtrls;

type
  TComboBoxInc = class(TComboBox)
private
    FTagString:AnsiString;
    FIncSearch:boolean;
    Findex:longint;
    Findex_prev:longint;
    FText_prev:string;
    FSelStart_prev:longint;
protected
    procedure KeyUp(var Key:word;  Shift:TShiftState);override;
    procedure KeyDown(var Key:word;  Shift:TShiftState);override;
public
    constructor Create (Owner:TComponent);override;
published
    property IncSearch:boolean read FIncSearch write FIncSearch default
true;
    property TagString:AnsiString read FTagString write FTagString;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TComboBoxInc]);
end;

procedure TComboBoxInc.KeyUp(var Key : word; Shift:TShiftState );
var
  start :integer;
//  s:string;

begin
if (Key = 13)
then begin
          start := 0;
          Findex_prev:=-1;
          Findex := SendMessage(Handle, CB_FINDSTRING, Findex-1, LongInt(PChar(Text)));
          FText_prev:='';
          if (Findex <> -1)
          then
              SendMessage(Handle, CB_SETCURSEL, Findex, 0);
          SelStart := start;
          SelLength := GetTextLen()-start;
          Findex:=-1;
          inherited;
end
else
begin
     if (FIncSearch)
     then begin
          if (key=8) then SelStart:=FSelStart_prev;
          start := SelStart;
          if (key <> 8) then Findex_prev:=Findex;
          Findex := SendMessage(Handle, CB_FINDSTRING, Findex-1,LongInt(PChar(Text)));
          FText_prev:=Text;
          if ((Findex <> -1)and not((Key = VK_DELETE)))
          then
              SendMessage(Handle, CB_SETCURSEL, Findex, 0);
          SelStart := start;
          SelLength := GetTextLen()-start;
     end;
end;
end;
procedure TComboBoxInc.KeyDown(var Key : word; Shift:TShiftState );
begin
 if (Key=8)
    then begin
         SetLength(FText_prev,length(FText_prev)-1);
         Findex:=Findex_prev;
         Text:=FText_prev;
    end
 else
    FSelStart_prev:=SelStart;
end;
constructor TComboBoxInc.Create (Owner:TComponent);
begin
    FIncSearch := true;
    FTagString := '';
    inherited;
end;
end.

