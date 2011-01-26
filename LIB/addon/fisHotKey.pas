{------------------------------------------------------------------------------
  Unit     : fishotKey.pas
  Purpose  : System hot key handling
  Status   : Freeware
  Copyright: ©2000 First Internet Software House, http://www.fishouse.com
  contact  : support@fishouse.com
-------------------------------------------------------------------------------

  History:

  Date                By      Comments
  ----                ----    --------
  18 May 2000         ME      Created

}
unit fisHotKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, menus;

type
  TfisHotKey = class(TComponent)
  private
    FEnabled: Boolean;
    FRegistered: Boolean;
    prOldWndProc: TWndMethod;
    FHotkey: TSHortcut;
    FOnHotKeyPressed: TNotifyEvent;
    prWindow: TWinControl;
    procedure RegisterKey;
    procedure UnRegisterKey;
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetEnabled(const Value: Boolean);
    procedure SetHotKey(const Value: TShortcut);
    procedure NewWindowProc(var Message: TMessage);
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    property Registered: boolean read FRegistered;
  published
    { Published declarations }
    property Enabled: Boolean read FEnabled write SetEnabled default true;
    property Key: TShortcut read FHotkey write SetHotkey;
    property OnHotKey: TNotifyEvent read FOnHotKeyPressed write FOnHotKeyPressed;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('FISH', [TfisHotKey]);
end;

{ TfisHotKey }

constructor TfisHotKey.Create(aOwner: TComponent);
begin
  inherited;
  FEnabled := True;
  FHotKey := 0;
  FRegistered := false;
  if not (csDesigning in ComponentState) then
  begin
    prWindow := TWinControl.CreateParented(GetDesktopWindow);
    prOldWndProc := prWindow.WindowProc;
    prWindow.WindowProc := NewWindowProc;
  end;
end;

destructor TfisHotKey.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    UnRegisterKey;
    prWindow.WindowProc := prOldWndProc;
    prWindow.Free;
  end;
  inherited;
end;

procedure TfisHotKey.Loaded;
begin
  inherited;
  if (FEnabled) and (not (csDesigning in ComponentState)) then RegisterKey;
end;

procedure TfisHotKey.NewWindowProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_HOTKEY:
    begin
      if assigned(FOnHotkeyPressed) then FOnHotKeyPressed(self);
    end;
  end;
  prOldWndProc(Message);
end;

procedure TfisHotKey.RegisterKey;
var
  lVKey: word;
  lvShift: TShiftstate;
  lModifier: UINT;
begin
  if not FRegistered then
  begin
    lModifier := 0;
    ShortcutToKey(FHotkey, lvKey, lvShift);
    if ssShift in lvShift  then lModifier := lModifier or MOD_SHIFT;
    if ssAlt in lvShift then lModifier := lModifier or MOD_ALT;
    if ssCtrl in lvShift then lModifier := lModifier or MOD_CONTROL;
    FRegistered := RegisterHotKey(prWindow.Handle, 0,
                    lModifier, LOBYTE(lVKey));
  end;
end;

procedure TfisHotKey.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  if FEnabled then RegisterKey else UnregisterKey;
end;

procedure TfisHotKey.UnRegisterKey;
begin
  if FRegistered then
  begin
    UnregisterHotKey(prWindow.Handle, 0);
    FRegistered := False;
  end;
end;

procedure TfisHotKey.SetHotKey(const Value: TShortcut);
begin
  if Value <> FHotkey then
  begin
    FHotkey := Value;
    if not (csDesigning in ComponentState) then
    begin
        UnRegisterKey;
        if FEnabled then RegisterKey;
    end;
  end;
end;

end.
