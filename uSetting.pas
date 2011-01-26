{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      :
Author       : n0mad
Module       : uSetting.pas
Version      :
Description  :
Creation     : 12.10.2002 9:03:42
Installation :


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uSetting;

interface

uses
  bugger, uRescons, Windows, Controls, Forms, Registry, SysUtils;

type
  TSLForm = class(TForm)
  protected
    procedure DoCreate; override;
  public
    function CloseQuery: Boolean; override;
  public
    SaveWindowState: Boolean;
  end;

  TFSForm = class(TSLForm)
  private
    _WindowState: TWindowState;
    _PlaceAndDims: TRect;
    FFullScreen: Boolean;
    procedure SetFullScreen(const Value: Boolean);
  protected
    procedure DoCreate; override;
  public
    function CloseQuery: Boolean; override;
  published
    property FullScreen: Boolean read FFullScreen write SetFullScreen default false;
  end;

  procedure CorrectPlaceAndDims(Sender: TControl; Rect: TRect);
  procedure LoadPlaceAndDimsFromReg(Sender: TControl; Rect: TRect);
  procedure SavePlaceAndDimsToReg(Sender: TControl; Rect: TRect);
  procedure LoadStateFromReg(Sender: TForm);
  procedure SaveStateToReg(Sender: TForm);

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uSetting_DEBUG}
{$ENDIF}

// #############################################################################
procedure CorrectPlaceAndDims(Sender: TControl; Rect: TRect);
var
  RestoreMaxState: Boolean;
  OldWindowState: TWindowState;
begin
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '% Correct(Sender=' + Sender.Name + ') - started');
  DEBUGMess(0, '  > C   Left=' + IntToStr(Sender.Left) + '; Top=' + IntToStr(Sender.Top) + '; Width=' + IntToStr(Sender.Width) + '; Height=' + IntToStr(Sender.Height));
  if (Sender is TCustomForm) then
    DEBUGMess(0, '    > CF  WindowState=' + IntToStr(Integer((Sender as TCustomForm).WindowState)));
  DEBUGMess(0, '  > CR  Left=' + IntToStr(Rect.Left) + '; Top=' + IntToStr(Rect.Top) + '; Right=' + IntToStr(Rect.Right) + '; Bottom=' + IntToStr(Rect.Bottom));
{$ENDIF}
// -----------------------------------------------------------------------------
  if (Rect.Right - Rect.Left <= 0) or (Rect.Bottom - Rect.Top <= 0) then
{$IFDEF uSetting_DEBUG}
    DEBUGMess(0, '    > Wrong Rect')
{$ENDIF}
  else
  begin
    OldWindowState := wsNormal;
    if (Sender is TCustomForm) then
    begin
      RestoreMaxState := true;
      if (Sender is TSLForm) then
        RestoreMaxState := (Sender as TSLForm).SaveWindowState;
      if RestoreMaxState then
      begin
        OldWindowState := (Sender as TCustomForm).WindowState;
        (Sender as TCustomForm).WindowState := wsNormal;
      end;
    end
    else
      RestoreMaxState := false;
// -----------------------------------------------------------------------------
    if Sender.Left < 0 then
      Sender.Left := 0;
    if Sender.Top < 0 then
      Sender.Top := 0;
// -----------------------------------------------------------------------------
    if (Sender.Width > Rect.Right - Rect.Left + 1) then
      Sender.Width := Rect.Right - Rect.Left + 1;
    if (Sender.Height > Rect.Bottom - Rect.Top + 1) then
      Sender.Height := Rect.Bottom - Rect.Top + 1;
// -----------------------------------------------------------------------------
    if (Sender.Width + Sender.Left > Rect.Right - Rect.Left + 1) then
      Sender.Width := (Rect.Right - Rect.Left + 1) - Sender.Left;
    if (Sender.Height + Sender.Top > Rect.Bottom - Rect.Top + 1) then
      Sender.Height := (Rect.Bottom - Rect.Top + 1) - Sender.Top;
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
    DEBUGMess(0, '  > C1  Left=' + IntToStr(Sender.Left) + '; Top=' + IntToStr(Sender.Top) + '; Width=' + IntToStr(Sender.Width) + '; Height=' + IntToStr(Sender.Height));
    if (Sender is TCustomForm) then
      DEBUGMess(0, '    > CF  WindowState=' + IntToStr(Integer((Sender as TCustomForm).WindowState)));
{$ENDIF}
// -----------------------------------------------------------------------------
    if RestoreMaxState then
      (Sender as TCustomForm).WindowState := OldWindowState;
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
    DEBUGMess(0, '  > C2  Left=' + IntToStr(Sender.Left) + '; Top=' + IntToStr(Sender.Top) + '; Width=' + IntToStr(Sender.Width) + '; Height=' + IntToStr(Sender.Height));
    if (Sender is TCustomForm) then
      DEBUGMess(0, '    > CF  WindowState=' + IntToStr(Integer((Sender as TCustomForm).WindowState)));
{$ENDIF}
  end;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '% Correct(Sender=' + Sender.Name + ') - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
procedure LoadPlaceAndDimsFromReg(Sender: TControl; Rect: TRect);
var
  Reg: TRegistry;
  LoadMaxState: Boolean;
  OldWindowState: TWindowState;
begin
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '@ LoadPlaceAndDimsFromReg(Sender=' + Sender.Name + ') - started');
  DEBUGMess(0, '  > L   Left=' + IntToStr(Sender.Left) + '; Top=' + IntToStr(Sender.Top) + '; Width=' + IntToStr(Sender.Width) + '; Height=' + IntToStr(Sender.Height));
  if (Sender is TCustomForm) then
    DEBUGMess(0, '    > LF  WindowState=' + IntToStr(Integer((Sender as TCustomForm).WindowState)));
  DEBUGMess(0, '  > LR  Left=' + IntToStr(Rect.Left) + '; Top=' + IntToStr(Rect.Top) + '; Right=' + IntToStr(Rect.Right) + '; Bottom=' + IntToStr(Rect.Bottom));
{$ENDIF}
// -----------------------------------------------------------------------------
  if (Rect.Right - Rect.Left <= 0) or (Rect.Bottom - Rect.Top <= 0) then
{$IFDEF uSetting_DEBUG}
    DEBUGMess(0, '    > Wrong Rect')
{$ENDIF}
  else
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(Reg_BasePath + '\' + Sender.Name, True) then
        try
// -----------------------------------------------------------------------------
          OldWindowState := wsNormal;
          if (Sender is TCustomForm) then
          begin
            LoadMaxState := true;
            if (Sender is TSLForm) then
              LoadMaxState := (Sender as TSLForm).SaveWindowState;
            OldWindowState := (Sender as TCustomForm).WindowState;
            if LoadMaxState then
              (Sender as TCustomForm).WindowState := wsNormal;
          end
          else
            LoadMaxState := false;
// -----------------------------------------------------------------------------
          if Reg.ValueExists(rgLeft) then
            Sender.Left := Reg.ReadInteger(rgLeft);
          if Reg.ValueExists(rgTop) then
            Sender.Top := Reg.ReadInteger(rgTop);
          if Reg.ValueExists(rgWidth) then
            Sender.Width := Reg.ReadInteger(rgWidth);
          if Reg.ValueExists(rgHeight) then
            Sender.Height := Reg.ReadInteger(rgHeight);
// -----------------------------------------------------------------------------
          if LoadMaxState then
          begin
            if (Sender is TSLForm) then
              LoadMaxState := (Sender as TSLForm).SaveWindowState;
            if LoadMaxState then
            begin
              if Reg.ValueExists(rgMaximized) then
                if (Reg.ReadInteger(rgMaximized) = 1) then
                  (Sender as TCustomForm).WindowState := wsMaximized;
            end
            else
              (Sender as TCustomForm).WindowState := OldWindowState;
          end;
// -----------------------------------------------------------------------------
        except
        end;
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
  end;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '@ LoadPlaceAndDimsFromReg(Sender=' + Sender.Name + ') - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
procedure SavePlaceAndDimsToReg(Sender: TControl; Rect: TRect);
var
  Reg: TRegistry;
  SetMaxState: Boolean;
  OldWindowState: TWindowState;
begin
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '& SavePlaceAndDimsToReg(Sender=' + Sender.Name + ') - started');
  DEBUGMess(0, '  > S   Left=' + IntToStr(Sender.Left) + '; Top=' + IntToStr(Sender.Top) + '; Width=' + IntToStr(Sender.Width) + '; Height=' + IntToStr(Sender.Height));
  if (Sender is TCustomForm) then
    DEBUGMess(0, '    > SF  WindowState=' + IntToStr(Integer((Sender as TCustomForm).WindowState)));
  DEBUGMess(0, '  > SR  Left=' + IntToStr(Rect.Left) + '; Top=' + IntToStr(Rect.Top) + '; Right=' + IntToStr(Rect.Right) + '; Bottom=' + IntToStr(Rect.Bottom));
{$ENDIF}
// -----------------------------------------------------------------------------
  if (Rect.Right - Rect.Left <= 0) or (Rect.Bottom - Rect.Top <= 0) then
{$IFDEF uSetting_DEBUG}
    DEBUGMess(0, '    > Wrong Rect')
{$ENDIF}
  else
  begin
    Reg := TRegistry.Create;
    try
      CorrectPlaceAndDims(Sender, Rect);
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(Reg_BasePath + '\' + Sender.Name, True) then
        try
// -----------------------------------------------------------------------------
          OldWindowState := wsNormal;
          if (Sender is TCustomForm) then
          begin
            SetMaxState := true;
            if (Sender is TSLForm) then
              SetMaxState := (Sender as TSLForm).SaveWindowState;
            if SetMaxState then
            begin
              if (Sender as TCustomForm).WindowState = wsMaximized then
                Reg.WriteInteger(rgMaximized, 1)
              else
                Reg.WriteInteger(rgMaximized, 0);
            end
            else
              Reg.DeleteValue(rgMaximized);
          end
          else
            SetMaxState := false;
// -----------------------------------------------------------------------------
          if SetMaxState then
          begin
            OldWindowState := (Sender as TCustomForm).WindowState;
            (Sender as TCustomForm).WindowState := wsNormal;
          end;
// -----------------------------------------------------------------------------
          Reg.WriteInteger(rgLeft, Sender.Left);
          Reg.WriteInteger(rgTop, Sender.Top);
          Reg.WriteInteger(rgWidth, Sender.Width);
          Reg.WriteInteger(rgHeight, Sender.Height);
// -----------------------------------------------------------------------------
          if SetMaxState then
            (Sender as TCustomForm).WindowState := OldWindowState;
        except
        end;
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
  end;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '& SavePlaceAndDimsToReg(Sender=' + Sender.Name + ') - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
procedure LoadStateFromReg(Sender: TForm);
var
  Reg: TRegistry;
begin
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '! LoadStateFromReg(Sender=' + Sender.Name + ') - started');
{$ENDIF}
  if (Sender is TFSForm) then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(Reg_BasePath + '\' + Sender.Name, True) then
        try
// -----------------------------------------------------------------------------
          if Reg.ValueExists(rgMaximized) then
            (Sender as TFSForm).FullScreen := (Reg.ReadInteger(rgMaximized) = 2);
// -----------------------------------------------------------------------------
        except
        end;
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
  end;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '! LoadStateFromReg(Sender=' + Sender.Name + ') - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
procedure SaveStateToReg(Sender: TForm);
var
  Reg: TRegistry;
begin
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '! SaveStateToReg(Sender=' + Sender.Name + ') - started');
{$ENDIF}
  if (Sender is TFSForm) then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(Reg_BasePath + '\' + Sender.Name, True) then
        try
// -----------------------------------------------------------------------------
          if (Sender as TFSForm).FullScreen then
            Reg.WriteInteger(rgMaximized, 2);
// -----------------------------------------------------------------------------
        except
        end;
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
  end;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, '! SaveStateToReg(Sender=' + Sender.Name + ') - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
        { TTSLForm }
// #############################################################################
procedure TSLForm.DoCreate;
var
  Rect: TRect;
begin
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'TSLForm.DoCreate - started');
{$ENDIF}
  SaveWindowState := true;
  inherited DoCreate;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'TSLForm.Load...FromReg(Sender=' + Self.Name + ') - started');
{$ENDIF}
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := Screen.Width - 1;
  Rect.Bottom := Screen.Height - 1;
  LoadPlaceAndDimsFromReg(Self, Rect);
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'TSLForm.Load...FromReg(Sender=' + Self.Name + ') - done');
  DEBUGMess(0, 'TSLForm.DoCreate - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
function TSLForm.CloseQuery: Boolean;
var
  Rect: TRect;
begin
// -----------------------------------------------------------------------------
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'TSLForm.CloseQuery - started');
  DEBUGMess(0, 'TSLForm.Save...ToReg(Sender=' + Self.Name + ') - started');
{$ENDIF}
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := Screen.Width - 1;
  Rect.Bottom := Screen.Height - 1;
  SavePlaceAndDimsToReg(Self, Rect);
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'TSLForm.Save...ToReg(Sender=' + Self.Name + ') - done');
{$ENDIF}
  Result := inherited CloseQuery;
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'TSLForm.CloseQuery - done');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
        { TFSForm }
// #############################################################################
function TFSForm.CloseQuery: Boolean;
var
  OldFSState: boolean; 
begin
// -----------------------------------------------------------------------------
  OldFSState := FullScreen;
  FullScreen := false;
  Result := inherited CloseQuery;
  FullScreen := OldFSState;
  SaveStateToReg(Self);
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'SaveStateToReg(Sender=' + Self.Name + ') - passed');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

// #############################################################################
procedure TFSForm.DoCreate;
begin
// -----------------------------------------------------------------------------
  inherited DoCreate;
  LoadStateFromReg(Self);
{$IFDEF uSetting_DEBUG}
  DEBUGMess(0, 'LoadStateFromReg(Sender=' + Self.Name + ') - passed');
{$ENDIF}
// -----------------------------------------------------------------------------
end;

procedure TFSForm.SetFullScreen(const Value: Boolean);
var
  MousePoint: TPoint;
begin
// -----------------------------------------------------------------------------
  if FFullScreen <> Value then
  begin
    FFullScreen := Value;
    GetCursorPos(MousePoint);
    MousePoint := ScreenToClient(MousePoint);
    if FFullScreen then
    begin
// -----------------------------------------------------------------------------
      _WindowState := WindowState;
      if WindowState = wsMaximized then
        WindowState := wsNormal;
      if WindowState <> wsMaximized then
      begin
        _PlaceAndDims.Left := Left;
        _PlaceAndDims.Top := Top;
        _PlaceAndDims.Right := Width;
        _PlaceAndDims.Bottom := Height;
      end;
      WindowState := wsMaximized;
      BorderStyle := bsNone;
// -----------------------------------------------------------------------------
    end
    else
    begin
// -----------------------------------------------------------------------------
      BorderStyle := bsSizeable;
      WindowState := wsNormal;
      Left := _PlaceAndDims.Left;
      Top := _PlaceAndDims.Top;
      Width := _PlaceAndDims.Right;
      Height := _PlaceAndDims.Bottom;
      WindowState := _WindowState;
// -----------------------------------------------------------------------------
    end;
    MousePoint := ClientToScreen(MousePoint);
    SetCursorPos(MousePoint.X, MousePoint.Y);
  end;
// -----------------------------------------------------------------------------
end;

{$IFDEF uSetting_DEBUG}
initialization
  DEBUGMess(0, 'uSetting.Init');
{$ENDIF}

{$IFDEF uSetting_DEBUG}
finalization
  DEBUGMess(0, 'uSetting.Final');
{$ENDIF}

end.
