object fmTarifpl: TfmTarifpl
  Left = 192
  Top = 107
  Width = 620
  Height = 400
  ActiveControl = dbgTarifpl
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Справочник типов билетов'
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
  object dbgTarifpl: TDBGrid
    Left = 0
    Top = 169
    Width = 612
    Height = 163
    Align = alClient
    DataSource = dm.dTarifpl
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgTarifplDblClick
    OnKeyDown = dbgTarifplKeyDown
    OnKeyPress = dbgTarifplKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'TARIFPL_KOD'
        Title.Caption = 'Код тарифа'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TARIFPL_NAM'
        Title.Caption = 'Наименование тарифа'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TARIFPL_PRINT'
        Title.Caption = 'Печать'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TARIFPL_REPORT'
        Title.Caption = 'Отчет'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TARIFPL_FREE'
        Title.Caption = 'Бесплатно'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TARIFPL_SHOW'
        Title.Caption = 'Показ'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Tarifpl_COLOR'
        Title.Caption = 'Цвет'
        Visible = True
      end>
  end
  object gbEdit: TGroupBox
    Left = 0
    Top = 0
    Width = 612
    Height = 169
    Align = alTop
    Caption = 'Редактирование'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 70
      Height = 13
      Caption = '&Код тарифа'
      FocusControl = edTarifpl_Kod
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
      Width = 136
      Height = 13
      Caption = '&Наименование тарифа'
      FocusControl = edTarifpl_Nam
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ssTarifpl_Color: TTicketControl
      Left = 216
      Top = 88
      Width = 30
      Height = 30
      Hint = 'Numerical Color = clWhite'
      OnMouseUp = ssTarifpl_ColorMouseUp
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      FixedBrush.Color = clGray
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clSilver
      FixedFont.Height = -11
      FixedFont.Name = 'MS Sans Serif'
      FixedFont.Style = []
      RegularFont.Charset = DEFAULT_CHARSET
      RegularFont.Color = clBlack
      RegularFont.Height = -11
      RegularFont.Name = 'MS Sans Serif'
      RegularFont.Style = []
      ReservedBrush.Color = 12582911
      SelectedBrush.Color = clRed
      SelectedFont.Charset = DEFAULT_CHARSET
      SelectedFont.Color = clWhite
      SelectedFont.Height = -11
      SelectedFont.Name = 'MS Sans Serif'
      SelectedFont.Style = [fsBold]
      SelectedPen.Width = 2
      TrackBrush.Color = clYellow
      TrackFont.Charset = DEFAULT_CHARSET
      TrackFont.Color = clWhite
      TrackFont.Height = -11
      TrackFont.Name = 'MS Sans Serif'
      TrackFont.Style = [fsBold]
      TrackPen.Color = clBlue
      TrackPen.Width = 2
      Ticket_DateTime = 37512.6335267477
    end
    object edTarifpl_Kod: TEdit
      Left = 8
      Top = 40
      Width = 73
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = edTarifpl_KodChange
      OnKeyDown = dbgTarifplKeyDown
      OnKeyPress = edTarifpl_NamKeyPress
    end
    object btAddRec: TButton
      Left = 96
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Добавить (+)'
      TabOrder = 9
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
      TabOrder = 8
      OnClick = btEditRecClick
    end
    object btDeleteRec: TButton
      Left = 184
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Удалить (-)'
      TabOrder = 10
      OnClick = btDeleteRecClick
    end
    object edTarifpl_Nam: TEdit
      Left = 96
      Top = 40
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnKeyPress = edTarifpl_NamKeyPress
    end
    object chbTarifpl_Print: TCheckBox
      Left = 8
      Top = 72
      Width = 97
      Height = 17
      Caption = '&Печать'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object chbTarifpl_Free: TCheckBox
      Left = 8
      Top = 96
      Width = 97
      Height = 17
      Caption = '&Бесплатно'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object chbTarifpl_Report: TCheckBox
      Left = 112
      Top = 72
      Width = 97
      Height = 17
      Caption = '&Отчет'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object chbTarifpl_Show: TCheckBox
      Left = 112
      Top = 96
      Width = 97
      Height = 17
      Caption = '&Показ'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object btTarifpl_BgColor: TButton
      Left = 288
      Top = 67
      Width = 100
      Height = 25
      Caption = '&Цвет'
      TabOrder = 6
      OnClick = btTarifpl_BgColorClick
    end
    object edTarifpl_Type: TEdit
      Left = 472
      Top = 72
      Width = 121
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 7
    end
    object btTarifpl_FntColor: TButton
      Left = 288
      Top = 99
      Width = 100
      Height = 25
      Caption = 'Цвет &шрифта'
      TabOrder = 11
      OnClick = btTarifpl_FntColorClick
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 332
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
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Color = clTeal
    Options = [cdFullOpen, cdAnyColor]
    Left = 184
    Top = 88
  end
end
