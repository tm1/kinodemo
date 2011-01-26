object fmGenre: TfmGenre
  Left = 192
  Top = 107
  Width = 620
  Height = 400
  ActiveControl = dbgGenre
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Справочник жанров'
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
  object dbgGenre: TDBGrid
    Left = 0
    Top = 105
    Width = 612
    Height = 227
    Align = alClient
    DataSource = dm.dGenre
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgGenreDblClick
    OnKeyDown = dbgGenreKeyDown
    OnKeyPress = dbgGenreKeyPress
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'GENRE_KOD'
        Title.Caption = 'Код'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GENRE_NAM'
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
      Width = 64
      Height = 13
      Caption = '&Код жанра'
      FocusControl = edGenre_Kod
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
      Width = 130
      Height = 13
      Caption = '&Наименование жанра'
      FocusControl = edGenre_Nam
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edGenre_Kod: TEdit
      Left = 8
      Top = 40
      Width = 73
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = edGenre_KodChange
      OnKeyDown = dbgGenreKeyDown
      OnKeyPress = edGenre_NamKeyPress
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
    object edGenre_Nam: TEdit
      Left = 96
      Top = 40
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnKeyPress = edGenre_NamKeyPress
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
