object fmOptions: TfmOptions
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Настройки'
  ClientHeight = 153
  ClientWidth = 292
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 105
    Caption = 'GroupBox1'
    TabOrder = 0
  end
  object btOK: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btOKClick
  end
  object btCancel: TButton
    Left = 88
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btCancelClick
  end
end
