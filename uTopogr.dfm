object fmTopogr: TfmTopogr
  Left = 192
  Top = 107
  Width = 620
  Height = 400
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Карта мест в зале'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 332
    Width = 612
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 612
    Height = 332
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object gbSheme: TGroupBox
        Left = 0
        Top = 0
        Width = 604
        Height = 304
        Align = alClient
        Caption = 'Редактирование схемы зала'
        TabOrder = 0
        object ggProgress: TGauge
          Left = 2
          Top = 15
          Width = 600
          Height = 18
          Align = alTop
          ForeColor = clNavy
          Progress = 30
          Visible = False
        end
        object sbxTopogr: TScrollBox
          Left = 2
          Top = 33
          Width = 600
          Height = 269
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 0
          object pnContainer: TPanel
            Left = 0
            Top = 0
            Width = 1280
            Height = 1024
            BevelInner = bvRaised
            BevelOuter = bvLowered
            Caption = 'pnContainer'
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object dbgTopogr: TDBGrid
        Left = 0
        Top = 0
        Width = 584
        Height = 304
        Align = alClient
        DataSource = dm.dPlace
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'PLACE_KOD'
            Title.Caption = 'Код'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLACE_ROW'
            Title.Caption = 'Ряд'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLACE_COL'
            Title.Caption = 'Место'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLACE_X'
            Title.Caption = 'X'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLACE_Y'
            Title.Caption = 'Y'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Place_STATE'
            Title.Caption = 'Тип'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLACE_ZAL'
            Title.Caption = 'Зал'
            Visible = True
          end>
      end
    end
  end
end
