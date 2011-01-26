object fmProizv: TfmProizv
  Left = 192
  Top = 107
  Width = 620
  Height = 440
  ActiveControl = dbgProizv
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Справочник производителей'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object dbgProizv: TDBGrid
    Left = 0
    Top = 105
    Width = 612
    Height = 267
    Align = alClient
    DataSource = dm.dProizv
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgProizvDblClick
    OnKeyDown = dbgProizvKeyDown
    OnKeyPress = dbgProizvKeyPress
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Proizv_Kod'
        Title.Caption = 'Код'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Proizv_Nam'
        Title.Caption = 'Наименование'
        Visible = True
      end>
  end
  object gbEdit: TGroupBox
    Left = 0
    Top = 0
    Width = 612
    Height = 105
    Align = alTop
    Caption = 'Редактирование'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 117
      Height = 13
      Caption = '&Код производителя'
      FocusControl = edProizv_Kod
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 184
      Top = 16
      Width = 183
      Height = 13
      Caption = '&Наименование производителя'
      FocusControl = edProizv_Nam
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edProizv_Kod: TEdit
      Left = 8
      Top = 40
      Width = 73
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = edProizv_KodChange
      OnKeyDown = dbgProizvKeyDown
      OnKeyPress = edProizv_NamKeyPress
    end
    object btAddRec: TButton
      Left = 96
      Top = 72
      Width = 75
      Height = 25
      Caption = '&Добавить (+)'
      TabOrder = 3
      OnClick = btAddRecClick
    end
    object btEditRec: TButton
      Left = 8
      Top = 72
      Width = 75
      Height = 25
      Caption = '&Изменить'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btEditRecClick
    end
    object btDeleteRec: TButton
      Left = 184
      Top = 72
      Width = 75
      Height = 25
      Caption = '&Удалить (-)'
      TabOrder = 4
      OnClick = btDeleteRecClick
    end
    object edProizv_Nam: TEdit
      Left = 96
      Top = 40
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnKeyPress = edProizv_NamKeyPress
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 372
    Width = 612
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btCancel: TButton
      Left = 508
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть (&X)'
      TabOrder = 0
      OnClick = btCancelClick
    end
  end
end
