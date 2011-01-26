object fmTarifz: TfmTarifz
  Left = 192
  Top = 107
  Width = 620
  Height = 440
  ActiveControl = dbgTarifz
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Справочник тарифов'
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
  object dbgTarifz: TDBGrid
    Left = 0
    Top = 169
    Width = 612
    Height = 203
    Align = alClient
    DataSource = dm.dTarifz
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgTarifzDblClick
    OnKeyDown = dbgTarifzKeyDown
    OnKeyPress = dbgTarifzKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'Tarifz_Kod'
        Title.Caption = 'Код тарифа'
        Visible = True
      end
      item
        Expanded = False
        FieldName = '_Tarifpl_Type'
        Title.Caption = 'Тип билета'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Tarifz_COST'
        Title.Caption = 'Цена билета'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Tarifz_ET'
        Title.Caption = 'Тариф. план'
        Visible = True
      end>
  end
  object pnBottom: TPanel
    Left = 0
    Top = 372
    Width = 612
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
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
  object gbEdit: TGroupBox
    Left = 0
    Top = 0
    Width = 612
    Height = 169
    Align = alTop
    Caption = 'Редактирование'
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 70
      Height = 13
      Caption = '&Код тарифа'
      FocusControl = edTarifz_Kod
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 216
      Top = 16
      Width = 195
      Height = 13
      Caption = '&Наименование тарифного плана'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 38
      Top = 72
      Width = 147
      Height = 13
      Caption = '&Типы билетов с оплатой'
      FocusControl = cmTarifpl
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 310
      Top = 72
      Width = 76
      Height = 13
      Caption = '&Цена билета'
      FocusControl = cmTarifpl
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edTarifz_Kod: TEdit
      Left = 8
      Top = 40
      Width = 73
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = edTarifz_KodChange
      OnKeyDown = dbgTarifzKeyDown
      OnKeyPress = seTarifz_CostKeyPress
    end
    object btAddRec: TButton
      Left = 96
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Добавить (+)'
      TabOrder = 7
      OnClick = btAddRecClick
    end
    object btEditRec: TButton
      Left = 8
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Изменить'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btEditRecClick
    end
    object btDeleteRec: TButton
      Left = 184
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Удалить (-)'
      TabOrder = 8
      OnClick = btDeleteRecClick
    end
    object cmTarifpl: TComboBox
      Left = 8
      Top = 96
      Width = 217
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
    end
    object btTarifpl: TWc_BitBtn
      Left = 232
      Top = 94
      Width = 25
      Height = 27
      Action = fmMain.acTarifpl
      TabOrder = 4
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
        FF0000000000FF00FF0000000000FF00FF0000000000FF00FF0000000000FF00
        FF0000000000FF00FF0000000000FF00FF0000000000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
        FF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000FF00FF0000000000FF00FF00FF00FF00FF00
        FF0000000000BDBEBD000000000000000000BDBEBD0000000000BDBEBD000000
        0000BDBEBD000000000000000000FF00FF00FF00FF00FF00FF0000000000FF00
        FF0000000000BDBEBD000000000000000000BDBEBD0000000000BDBEBD000000
        0000BDBEBD000000000000000000FF00FF0000000000FF00FF00FF00FF00FF00
        FF000000000000000000BDBEBD000000000000000000BDBEBD00000000000000
        000000000000BDBEBD0000000000FF00FF00FF00FF00FF00FF0000000000FF00
        FF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000FF00FF0000000000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
        FF0000000000FF00FF0000000000FF00FF0000000000FF00FF0000000000FF00
        FF0000000000FF00FF0000000000FF00FF0000000000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    end
    object btTarifet: TWc_BitBtn
      Left = 568
      Top = 38
      Width = 25
      Height = 25
      Action = fmMain.acTarifet
      Anchors = [akTop, akRight]
      TabOrder = 2
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDD007DD0000000D0000B0DD0CC0090D0E00B0DD0000000D0E00B77D0CC0090
        D0E077B0D0CC0090D0E0D0B0D0CC0090D0E0D0B770CC0090D0E0D77B00CC0090
        D0E0DD0B30CC0090D000DD0B30000090D0E0DD7000CC0090D000DDDDD0000090
        DDDDDDDDDDDDD000DDDDDDDDDDDDD090DDDDDDDDDDDDD000DDDD}
    end
    object cmTarifet: TComboBox
      Left = 96
      Top = 40
      Width = 465
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      OnChange = cmTarifetChange
    end
    object seTarifz_Cost: TSpinEdit
      Left = 296
      Top = 96
      Width = 121
      Height = 22
      Increment = 10
      MaxValue = 100000
      MinValue = 0
      TabOrder = 5
      Value = 10
      OnChange = seTarifz_CostChange
      OnKeyPress = seTarifz_CostKeyPress
    end
  end
end
