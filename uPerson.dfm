object fmPerson: TfmPerson
  Left = 192
  Top = 107
  Width = 620
  Height = 440
  ActiveControl = dbgPerson
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Справочник режиссеров'
  Color = clBtnFace
  Constraints.MinHeight = 400
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
  object dbgPerson: TDBGrid
    Left = 0
    Top = 169
    Width = 612
    Height = 203
    Align = alClient
    DataSource = dm.dPerson
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgPersonDblClick
    OnKeyDown = dbgPersonKeyDown
    OnKeyPress = dbgPersonKeyPress
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Person_Kod'
        Title.Caption = 'Код'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Person_Nam_SH'
        Title.Caption = 'Короткое имя'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Person_Is_Producer'
        Title.Caption = 'Продюссер'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Person_Is_Rejiser'
        Title.Caption = 'Режиссер'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Person_Nam_FUL'
        Title.Caption = 'Полное имя'
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
      Width = 23
      Height = 13
      Caption = '&Код'
      FocusControl = edPerson_Kod
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 96
      Top = 16
      Width = 84
      Height = 13
      Caption = '&Короткое имя'
      FocusControl = edPerson_Nam_Sh
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 72
      Height = 13
      Caption = 'Пол&ное имя'
      FocusControl = edPerson_Nam_Sh
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edPerson_Kod: TEdit
      Left = 8
      Top = 40
      Width = 73
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = edPerson_KodChange
      OnKeyDown = dbgPersonKeyDown
      OnKeyPress = edPerson_Nam_ShKeyPress
    end
    object btAddRec: TButton
      Left = 96
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Добавить (+)'
      TabOrder = 6
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
      TabOrder = 5
      OnClick = btEditRecClick
    end
    object btDeleteRec: TButton
      Left = 184
      Top = 128
      Width = 75
      Height = 25
      Caption = '&Удалить (-)'
      TabOrder = 7
      OnClick = btDeleteRecClick
    end
    object edPerson_Nam_Sh: TEdit
      Left = 96
      Top = 40
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnKeyPress = edPerson_Nam_ShKeyPress
    end
    object edPerson_Nam_Ful: TEdit
      Left = 8
      Top = 96
      Width = 585
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      OnKeyPress = edPerson_Nam_ShKeyPress
    end
    object chbPerson_IsReji: TCheckBox
      Left = 248
      Top = 72
      Width = 97
      Height = 17
      Caption = '&Режиссер'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object chbPerson_IsProd: TCheckBox
      Left = 384
      Top = 72
      Width = 97
      Height = 17
      Caption = '&Продюссер'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
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
