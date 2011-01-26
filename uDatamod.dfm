object dm: Tdm
  OldCreateOrder = False
  OnCreate = DatamoduleCreate
  Left = 65532
  Top = 83
  Height = 636
  Width = 1032
  object db: TDatabase
    AliasName = 'KINO_DAT'
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    AfterConnect = dbAfterConnect
    Left = 304
    Top = 16
  end
  object tGenre: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Genre.db'
    Left = 72
    Top = 16
  end
  object tTarifz: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Tarifz.DB'
    Left = 224
    Top = 72
    object tTarifzTarifz_Kod: TSmallintField
      FieldName = 'Tarifz_Kod'
      Required = True
    end
    object tTarifzTarifz_ET: TSmallintField
      FieldName = 'Tarifz_ET'
      Required = True
    end
    object tTarifzTarifz_PL: TSmallintField
      FieldName = 'Tarifz_PL'
      Required = True
    end
    object tTarifzTarifz_COST: TCurrencyField
      FieldName = 'Tarifz_COST'
    end
    object tTarifzTarifz_TAG: TSmallintField
      FieldName = 'Tarifz_TAG'
    end
    object tTarifz_Tarifpl_Nam: TStringField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Nam'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_NAM'
      KeyFields = 'Tarifz_PL'
      Size = 40
      Lookup = True
    end
    object tTarifz_Tarifpl_Color: TIntegerField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Color'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_BGCOLOR'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
    object tTarifz_Tarifpl_Tag: TIntegerField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Tag'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_TAG'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
    object tTarifz_Tarifpl_Print: TBooleanField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Print'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_PRINT'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
    object tTarifz_Tarifpl_Report: TBooleanField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Report'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_REPORT'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
    object tTarifz_Tarifpl_Free: TBooleanField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Free'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_FREE'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
    object tTarifz_Tarifpl_Show: TBooleanField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Show'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_SHOW'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
    object tTarifz_Tarifpl_Type: TIntegerField
      FieldKind = fkLookup
      FieldName = '_Tarifpl_Type'
      LookupDataSet = tTarifpl
      LookupKeyFields = 'TARIFPL_KOD'
      LookupResultField = 'TARIFPL_TYPE'
      KeyFields = 'Tarifz_PL'
      Lookup = True
    end
  end
  object tFilm: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Film.db'
    Left = 144
    Top = 16
  end
  object tPerson: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Person.db'
    Left = 8
    Top = 16
  end
  object tProizv: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Proizv.db'
    Left = 8
    Top = 72
  end
  object tSeans: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    OnCalcFields = tSeansCalcFields
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Seans.db'
    Left = 144
    Top = 72
    object tSeansSeans_Kod: TSmallintField
      FieldName = 'Seans_Kod'
      Required = True
    end
    object tSeansSeans_HOUR: TSmallintField
      FieldName = 'Seans_HOUR'
      Required = True
    end
    object tSeansSeans_MINUTE: TSmallintField
      FieldName = 'Seans_MINUTE'
      Required = True
    end
    object tSeansSeans_TAG: TSmallintField
      FieldName = 'Seans_TAG'
    end
    object tSeans_Seans: TStringField
      FieldKind = fkCalculated
      FieldName = '_Seans'
      Size = 5
      Calculated = True
    end
  end
  object tPlace: TTable
    AfterPost = TableAfterPost
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Place.db'
    Left = 72
    Top = 72
  end
  object tTarifpl: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Tarifpl.DB'
    Left = 224
    Top = 128
  end
  object tTarifet: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Tarifet.DB'
    Left = 224
    Top = 16
  end
  object dPerson: TDataSource
    DataSet = tPerson
    Left = 8
    Top = 384
  end
  object dGenre: TDataSource
    DataSet = tGenre
    Left = 72
    Top = 384
  end
  object dFilm: TDataSource
    DataSet = tFilm
    Left = 144
    Top = 384
  end
  object dTarifz: TDataSource
    DataSet = tTarifz
    Left = 224
    Top = 440
  end
  object dProizv: TDataSource
    DataSet = tProizv
    Left = 8
    Top = 440
  end
  object dSeans: TDataSource
    DataSet = tSeans
    Left = 144
    Top = 440
  end
  object dPlace: TDataSource
    DataSet = tPlace
    Left = 72
    Top = 440
  end
  object dTarifpl: TDataSource
    DataSet = tTarifpl
    Left = 224
    Top = 496
  end
  object dTarifet: TDataSource
    DataSet = tTarifet
    Left = 224
    Top = 384
  end
  object tZal: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Zal.DB'
    Left = 72
    Top = 128
  end
  object tRepert: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Repert.DB'
    Left = 8
    Top = 128
    object tRepertRepert_Kod: TSmallintField
      FieldName = 'Repert_Kod'
      Required = True
    end
    object tRepertRepert_DATE: TDateField
      FieldName = 'Repert_DATE'
      Required = True
    end
    object tRepertRepert_Seans: TSmallintField
      FieldName = 'Repert_Seans'
      Required = True
    end
    object tRepertRepert_Film: TSmallintField
      FieldName = 'Repert_Film'
      Required = True
    end
    object tRepertRepert_Tarifet: TSmallintField
      FieldName = 'Repert_Tarifet'
      Required = True
    end
    object tRepertRepert_Zal: TSmallintField
      FieldName = 'Repert_Zal'
      Required = True
    end
    object tRepertRepert_TAG: TSmallintField
      FieldName = 'Repert_TAG'
    end
    object tRepert_Seans: TStringField
      FieldKind = fkLookup
      FieldName = '_Seans'
      LookupDataSet = tSeans
      LookupKeyFields = 'Seans_Kod'
      LookupResultField = '_Seans'
      KeyFields = 'Repert_Seans'
      Size = 5
      Lookup = True
    end
    object tRepert_Film: TStringField
      FieldKind = fkLookup
      FieldName = '_Film'
      LookupDataSet = tFilm
      LookupKeyFields = 'Film_Kod'
      LookupResultField = 'Film_Nam'
      KeyFields = 'Repert_Film'
      Size = 40
      Lookup = True
    end
    object tRepert_Tarifet: TStringField
      FieldKind = fkLookup
      FieldName = '_Tarifet'
      LookupDataSet = tTarifet
      LookupKeyFields = 'Tarifet_Kod'
      LookupResultField = 'Tarifet_Nam'
      KeyFields = 'Repert_Tarifet'
      Size = 40
      Lookup = True
    end
    object tRepert_Zal: TStringField
      FieldKind = fkLookup
      FieldName = '_Zal'
      LookupDataSet = tZal
      LookupKeyFields = 'Zal_Kod'
      LookupResultField = 'Zal_Nam'
      KeyFields = 'Repert_Zal'
      Size = 40
      Lookup = True
    end
    object tRepert_Cinema: TStringField
      FieldKind = fkLookup
      FieldName = '_Cinema'
      LookupDataSet = tZal
      LookupKeyFields = 'ZAL_KOD'
      LookupResultField = 'ZAL_CINEMA'
      KeyFields = 'Repert_Zal'
      Size = 40
      Lookup = True
    end
  end
  object dZal: TDataSource
    DataSet = tZal
    Left = 72
    Top = 496
  end
  object dRepert: TDataSource
    DataSet = tRepert
    Left = 8
    Top = 496
  end
  object tTicket: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'TICKET.DB'
    Left = 144
    Top = 128
  end
  object dTicket: TDataSource
    DataSet = tTicket
    Left = 144
    Top = 496
  end
  object qRepert: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 8
    Top = 320
  end
  object qZal: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 72
    Top = 320
  end
  object qPlace: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 72
    Top = 248
  end
  object qTicket: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 144
    Top = 320
  end
  object qProizv: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 8
    Top = 248
  end
  object qTarifpl: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 224
    Top = 320
  end
  object qTarifet: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 224
    Top = 192
  end
  object qTarifz: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 224
    Top = 248
  end
  object qGenre: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 72
    Top = 192
  end
  object qPerson: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 8
    Top = 192
  end
  object qFilm: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 144
    Top = 192
  end
  object qSeans: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 144
    Top = 248
  end
  object tUzver: TTable
    AfterPost = TableAfterPost
    AfterScroll = TableAfterScroll
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'UZVER.DB'
    Left = 304
    Top = 72
  end
  object qUzver: TQuery
    DatabaseName = 'db_main_temp'
    SessionName = 'Default'
    Left = 312
    Top = 192
  end
  object dUzver: TDataSource
    DataSet = tUzver
    Left = 320
    Top = 384
  end
  object tOption: TTable
    AfterPost = TableAfterPost
    DatabaseName = 'db_Main_data'
    SessionName = 'Default'
    TableName = 'Option.DB'
    Left = 376
    Top = 264
  end
end
