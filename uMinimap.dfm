object fmMinimap: TfmMinimap
  Left = 600
  Top = 420
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Миникарта'
  ClientHeight = 173
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ggProgress: TGauge
    Left = 0
    Top = 0
    Width = 312
    Height = 18
    Align = alTop
    ForeColor = clNavy
    Progress = 30
  end
  object pnMinimap: TPanel
    Left = 0
    Top = 0
    Width = 312
    Height = 173
    BevelOuter = bvLowered
    Caption = 'pnMinimap'
    TabOrder = 0
    OnMouseDown = pnMinimapMouseDown
    OnMouseMove = pnMinimapMouseMove
    OnMouseUp = pnMinimapMouseUp
  end
end
