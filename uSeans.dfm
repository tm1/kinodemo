object fmSeans: TfmSeans
  Left = 192
  Top = 107
  Width = 620
  Height = 400
  ActiveControl = dbgSeans
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Справочник сеансов'
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
  object dbgSeans: TDBGrid
    Left = 0
    Top = 105
    Width = 612
    Height = 227
    Align = alClient
    DataSource = dm.dSeans
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgSeansDblClick
    OnKeyDown = dbgSeansKeyDown
    OnKeyPress = dbgSeansKeyPress
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Seans_Kod'
        Title.Caption = 'Код'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Seans_HOUR'
        Title.Caption = 'Часы'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Seans_MINUTE'
        Title.Caption = 'Минуты'
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
      Width = 69
      Height = 13
      Caption = '&Код сеанса'
      FocusControl = edSeans_Kod
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 112
      Top = 16
      Width = 33
      Height = 13
      Caption = '&Часы'
      FocusControl = spSeans_Hour
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 192
      Top = 16
      Width = 46
      Height = 13
      Caption = '&Минуты'
      FocusControl = spSeans_Hour
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edSeans_Kod: TEdit
      Left = 8
      Top = 40
      Width = 73
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = edSeans_KodChange
      OnKeyDown = dbgSeansKeyDown
      OnKeyPress = spSeans_HourKeyPress
    end
    object btAddRec: TButton
      Left = 96
      Top = 72
      Width = 75
      Height = 25
      Caption = '&Добавить (+)'
      TabOrder = 4
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
      TabOrder = 3
      OnClick = btEditRecClick
    end
    object btDeleteRec: TButton
      Left = 184
      Top = 72
      Width = 75
      Height = 25
      Caption = '&Удалить (-)'
      TabOrder = 5
      OnClick = btDeleteRecClick
    end
    object spSeans_Hour: TSpinEdit
      Left = 96
      Top = 40
      Width = 73
      Height = 22
      MaxLength = 2
      MaxValue = 23
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = spSeansHMChange
      OnKeyPress = spSeans_HourKeyPress
    end
    object spSeans_Minute: TSpinEdit
      Left = 184
      Top = 40
      Width = 73
      Height = 22
      MaxLength = 2
      MaxValue = 59
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = spSeansHMChange
      OnKeyPress = spSeans_MinuteKeyPress
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
end
