unit TransparentWnd;

{+++++ Transparent Windows +++++++ V 2.0 ++++++++++++++++++++++++++++++++++++++

For learnig, testing and commercial use

?***********************************************?
? by Michael Glitzner (michael.glitzner@aon.at) ?
?***********************************************?

* ABOUT THIS COMPONENT *
This component should capsule the new Windows 2000 API calls for Alpha Blending
(transparency). I think you can use this component in nearly any Delphi
(tested in BD5) version with Win2000 or higher (e.g. Windows Whistler).
Install this component in Delphi 5 with |COMPONENT|INSTALL COMPONENT|. Then you
have to choose the "transparentWnd.pas" file. After this the component is
installed in |WIN32|.
Only drop the component on the Form and use the prefered method to set
transparency.

V1.4
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+) SetLayeredWindowAttributes dynamically loaded at runtime (otherwise an error
   has occured in win9x)
+) SetWindowLongA and GetWindowLongA declarations removed (already declared in
   windows.pas)
~~~~~~~~~~~~~~~~~~~~~" Thanks to Budi Sukmawan for these improvements "~~~~~~~~~
+) SetOpaque
+) SetOpaqueHWND

V2.0
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+) Changed Longint's into THandle
+) Added some safeguards on percentage value and to handles (check wnd/no wnd)
+) Test Owner to be a TWinControl Descendant instead of blindly casting it to
   TForm, this allows you to create the controls dynamically.
+) Added Constructor and Destructor.
+) Variable comments
~~~~~~~~~~~~~~~~~~~~~" Thanks to wvd_vegt@knoware.nl (13-dec-2000) "~~~~~~~~~~~~
+) Corrected bug in SetTransparentHWND(): 0% is now inverted (not 100% transparent)
+) Redesigned SetTransparentHWND(). Because now library is loaded in constructor
   I rewrote this method.
+) Property AutoOpaque: When AutoOpaque has the value "true" then the component
   automatically sets the window opaque when the transparency percentage is 0%.
+) NOW IT SHOULD BE REALLY FAST

Derived from:
TComponent

Properties:
Percent
= Percentage of transparency ( only in use with SetTransparent() )

AutoOpaque
= When AutoOpaque has the value "true" then the component automatically sets the
  window opaque when the transparency percentage is 0%.

Inherited properties:
Properties from TComponent

Methods:
Create(AOwner)
= The constructor. Normally when you drag the component at your form in design
  mode you don't need it. But you can also create a component at runtime by
  using this constructor. It is also required to specify the owner of the comp.

Destroy()
= The destructor. You have to call it to destroy the component at runtime.

SetTransparent()
= Set the transparency of the parent window to the property percent.

SetTransparent(percent)
= Set the transparency of the parent window to percent(variable).

SetTransparentHWND(hwnd, percent)
= Set the transparency of the window with the hwnd to percent(variable).

SetOpaque()
= Switch of window transparency and turn window opaque (!!! is not the same as
  window transparency 0% !!!)

SetOpaqueHWND()
=  Switch of window transparency and turn window with hwnd opaque

Events:
Events from TComponent
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

interface

uses
  Windows, Messages, Classes, Controls, Forms;

type

  _Percentage = 0..100;

  TW = class(TComponent)
  private
    { Private declarations }
  protected
    _percent : _Percentage;
    _auto : boolean;
    User32: HMODULE;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    //These work on a Handle
    //It doesn't change the Percent Property Value!
    procedure SetTransparentHWND(hwnd: THandle; percent : _Percentage);

    //These work on the Owner (a TWinControl decendant is the Minumum)
    //They don't change the Percent Property Value!
    procedure SetTransparent; overload;
    procedure SetTransparent(percent : _Percentage); overload;

    procedure SetOpaqueHWND(hwnd : THandle);
    procedure SetOpaque;
    { Public declarations }
  published

    //This works on the Owner (a TWinControl decendant is the Minumum)
    property Percent: _Percentage read _percent write _percent default 0;

    property AutoOpaque: boolean read _auto write _auto default false;
    { Published declarations }
  end;

  procedure Register;

implementation

const LWA_ALPHA = $2;
const GWL_EXSTYLE = (-20);
const WS_EX_LAYERED = $80000;
const WS_EX_TRANSPARENT = $20;

var SetLayeredWindowAttributes: function (hwnd: LongInt; crKey: byte; bAlpha: byte; dwFlags: LongInt): LongInt; stdcall;

constructor TW.Create(AOwner: TComponent);
begin
  inherited;

  User32 := LoadLibrary('USER32.DLL');
  if User32 <> 0 then
    @SetLayeredWindowAttributes := GetProcAddress(User32, 'SetLayeredWindowAttributes')
  else SetLayeredWindowAttributes:=nil;
end;

destructor TW.Destroy;
begin
  if User32 <> 0 then FreeLibrary(User32);

  inherited;
end;

procedure TW.SetOpaqueHWND(hwnd: THandle);
var
  old: THandle;
begin
  if IsWindow(hwnd) then
  begin
    old := GetWindowLongA(hwnd,GWL_EXSTYLE);
    SetWindowLongA(hwnd, GWL_EXSTYLE, old and ((not 0)-WS_EX_LAYERED) );
  end;
end;

procedure TW.SetOpaque;
begin
  Self.SetOpaqueHWND((Self.Owner as TWinControl).Handle);
end;

procedure TW.SetTransparent;
begin
  Self.SetTransparentHWND((Self.Owner as TWinControl).Handle,Self._percent);
end;

procedure TW.SetTransparentHWND(hwnd: THandle; percent : _Percentage);
var
  old: THandle;
begin
  if (User32 <> 0) AND (Assigned(SetLayeredWindowAttributes)) AND (IsWindow(hwnd)) then
    if (_auto=true) AND (percent=0) then SetOpaqueHWND(hwnd)
    else
      begin
        percent:=100-percent;
        old := GetWindowLongA(hwnd,GWL_EXSTYLE);
        SetWindowLongA(hwnd,GWL_EXSTYLE,old or WS_EX_LAYERED);
        SetLayeredWindowAttributes(hwnd, 0, (255 * percent) DIV 100, LWA_ALPHA);
      end;
end;

procedure TW.SetTransparent(percent: _Percentage);
begin
  Self.SetTransparentHWND((Self.Owner as TForm).Handle,percent);
end;

procedure Register;
begin
  RegisterComponents('Win32', [TW]);
end;

end.
