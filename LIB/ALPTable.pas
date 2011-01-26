unit ALPTable;
{-----------------------------------------------------------------------------
 Universal table component of access to databases without BDE
 Last modification : 23 May 2001
 (Please write this last modification date in your e-mails.)

 Version: 	1.17
 Author:	Momot Alexander (Deleon)
 Http:          http://www.dbwork.chat.ru
 E-Mail:	dbwork@chat.ru
 Status:	FreeWare
 Delphi:		32-bit versions
 Platform:	Windows 32-bit versions.

-----------------------------------------------------------------------------}
{$R *.DCR}
{$DEFINE REGISTERONPAGE}
interface

uses
  Windows,   Messages,   SysUtils,  Classes,
  Forms,     Db,        ALP,        DsgnIntf;

type
  PRecInfo = ^TRecInfo;
  TRecInfo = packed record
    RecordNumber: Longint;
    UpdateStatus: TUpdateStatus;
    BookmarkFlag: TBookmarkFlag;
  end;

  TALPTable = packed class(TDataSet)
  private
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //FDbHandle     : pEDIDB;
    FHandle       : ALP_HANDLE;
    FRecProps     : RecProps;
    FCurRec       : Integer;
    FExclusive    : boolean;
    FReadOnly     : boolean;

    FRecordSize   : Word;
    FBookmarkOfs  : Word;
    FRecInfoOfs   : Word;
    FBlobCacheOfs : Word;
    FRecBufSize   : Word;

    FFileName     : string;
    FDatabaseName : string;
    FTableName    : string;
    FLastBookmark : Integer;
    procedure InitBufferPointers(GetProps: Boolean);
    procedure SetExclusive(Value: boolean);
    procedure SetFileName(Value: string);
    function  GetActiveRecBuf(var RecBuf: PChar): Boolean;
    procedure SetTableName(const Value: string);
    procedure SetDatabaseName(const Value: string);
  protected
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    function  CreateHandle: ALP_HANDLE;
    procedure DestroyHandle;
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure CloseCursor; override;
    function  AllocRecordBuffer: PChar; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function  GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function  GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function  GetRecordSize: Word; override;
    procedure AddFieldDesc(pFld: pFLDDesc; FieldDefs: TFieldDefs);
    procedure InitRecord(Buffer: PChar); override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InitFieldDefs; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalInsert; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function  IsCursorOpen: Boolean; override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    function  GetRecordCount: Integer; override;
    function  GetRecNo: Integer; override;
    procedure SetRecNo(Value: Integer); override;
  public
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    function  GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    procedure CreateTable;
    property  Handle : ALP_HANDLE read FHandle;
  published
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    property Active;
    property AutoCalcFields;
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property Exclusive: boolean read FExclusive write SetExclusive;
    property Filter;
    property Filtered;
    property FilterOptions;
    property TableName: string read FTableName write SetTableName;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    property ObjectView default False;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
  end;

  TALPException = class(Exception);

procedure Check(Status: ALPResult);
procedure Register;

implementation

procedure Check(Status: ALPResult);
begin
 case( Status )of
 ERR_UNSUPPORTEDFILE  : raise TALPException.Create('Unsupported file format');
 ERR_CANNOTOPENFILE   : raise TALPException.Create('Cannot open file');
 ERR_CANNOTCLOSEFILE  : raise TALPException.Create('Cannot close file');
 ERR_INVALIDFILE      : raise TALPException.Create('Invalid file');
 ERR_INVALIDHANDLE    : raise TALPException.Create('Invalid handle');
 ERR_INVALIDFILENAME  : raise TALPException.Create('Invalid file name');
 ERR_FILENOTEXIST     : raise TALPException.Create('File not found');
 ERR_CANNOTSEEK       : raise TALPException.Create('Cannot seek');
 ERR_CANNOTREADFILE   : raise TALPException.Create('Cannot read file');
 ERR_CANNOTWRITEFILE  : raise TALPException.Create('Cannot write file');
 ERR_BOF              : raise TALPException.Create('At the begin of file');
 ERR_EOF              : raise TALPException.Create('At the end of file');
 ERR_BUFFERISEMPTY    : raise TALPException.Create('Buffer is empty');
 ERR_INVALIDFIELDDESC : raise TALPException.Create('Invalid field descriptor');
 ERR_INVALIDINDEXDESC : raise TALPException.Create('Invalid index descriptor');
 ERR_RECDELETED       : raise TALPException.Create('Record deleted');
 end;{ case }
end;

function _IsDirectory(const DatabaseName: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  if (DatabaseName = '') then Exit;
  I := 1;
  while I <= Length(DatabaseName) do
  begin
    if DatabaseName[I] in [':','\'] then Exit;
    if DatabaseName[I] in LeadBytes then Inc(I, 2)
    else Inc(I);
  end;
  Result := False;
end;

function _NormalDir(const DirName: string): string;
begin
  Result := DirName;
  if (Result <> '') and
    not (Result[Length(Result)] in [':', '\']) then
  begin
    if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
      Result := Result + ':\'
    else Result := Result + '\';
  end;
end;

procedure TALPTable.InternalOpen;
begin
 FRecordSize  := FHandle^.iDataSize;
 BookmarkSize := SizeOf(IBOOKMARK);
 FieldDefs.Updated := False;
 FieldDefs.Update;
 if DefaultFields then CreateFields;
 BindFields(True);
 InitBufferPointers(False);
 ALPSetToBegin(FHandle);
end;

procedure TALPTable.InternalClose;
begin
 BindFields(False);
 if DefaultFields then DestroyFields;
end;

function TALPTable.IsCursorOpen: Boolean;
begin
  Result := Assigned( FHandle );
end;

procedure TALPTable.InternalInitFieldDefs;
var
  I          : Integer;
  pFLD       : pFLDDesc;
begin
  FieldDefs.Clear;
  pFLD := FHandle^.pFIELDS;
  for I := 1 to FHandle^.iNumFlds do
  begin
   AddFieldDesc(pFLD, FieldDefs);
   inc(pFLD);
  end;{ while }
end;

{ Field Related }

procedure TALPTable.AddFieldDesc(pFld: pFLDDesc; FieldDefs: TFieldDefs);
var
  FType: TFieldType;
  FSize: Word;
  FRequired: Boolean;
  FPrecision, I: Integer;
  FName: string;
begin
  with( pFLD^ )do
  begin
    I := 0;
    FName := szName;
    while FieldDefs.IndexOf(FName) >= 0 do
    begin
      Inc(I);
      FName := Format('%s_%d', [szName, I]);
    end;
    //------------------------------
    FType     := TFieldType(iFldType);
    FRequired := False;
    //------------------------------
    case( ALP_FLDTYPE(iFldType) )of
    uftString, uftBytes, uftVarBytes,
    uftADT, uftArray, uftReference:
        begin
         FSize := iFldSize;
        end;
    uftBCD:
        begin
         FSize      := iFldSig;
         FPrecision := iFldDec;
        end;
    uftBLOB:
        begin
         FSize := iFldSize;
        end;
    else
     FSize      := 0;
     FPrecision := 0;
    end;{ case }
    //------------------------------
    with FieldDefs.AddFieldDef do
    begin
     FieldNo   := pFLD^.iFldNum + 1;
     Name      := FName;
     DataType  := FType;
     Size      := FSize;
     Precision := FPrecision;
     if( FRequired )then Attributes := [faRequired];
     if( DataType = ftAutoInc )then
      Attributes := Attributes + [faReadonly];
    end;{ with }
  end;{ with }
end;

procedure TALPTable.InternalHandleException;
begin
  Application.HandleException(Self);
end;

procedure TALPTable.InternalGotoBookmark(Bookmark: Pointer);
begin
  Check(ALPSetToBookmark(FHandle, Bookmark));
end;

procedure TALPTable.InternalSetToRecord(Buffer: PChar);
begin
  InternalGotoBookmark(Buffer + FBookmarkOfs);
end;

function TALPTable.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + FRecInfoOfs)^.BookmarkFlag;
end;

procedure TALPTable.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer + FRecInfoOfs)^.BookmarkFlag := Value;
end;

procedure TALPTable.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Move(Buffer[FBookmarkOfs], Data^, BookmarkSize);
end;

procedure TALPTable.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Move(Data^, Buffer[FBookmarkOfs], BookmarkSize);
end;

function TALPTable.GetRecordSize: Word;
begin
 Result := FHandle^.iDataSize;
end;

function TALPTable.AllocRecordBuffer: PChar;
begin
 Result := AllocMem(FRecBufSize);
end;

procedure TALPTable.FreeRecordBuffer(var Buffer: PChar);
begin
  FreeMem(Buffer, FRecBufSize);
end;

function TALPTable.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
var
  Status: ALPResult;
begin
  case( GetMode )of
    gmCurrent:
      Status := ALPGetRecord(FHandle, Buffer, @FrecProps);
    gmNext:
      Status := ALPGetNextRecord(FHandle, Buffer, @FrecProps);
    gmPrior:
      Status := ALPGetPriorRecord(FHandle, Buffer, @FrecProps);
  else
    Status := ERR_NONE;
  end;
  //------------
  case( Status )of
  ERR_NONE:
    begin
     with pRecInfo(Buffer + FRecInfoOfs)^ do
     begin
      UpdateStatus := usUnmodified;
      BookmarkFlag := bfCurrent;
      RecordNumber := FRecProps.iRecNum;
      Check(ALPGetBookmark(FHandle, Buffer + FBookmarkOfs));
      Result := grOK;
     end;{ with }
    end;
  ERR_BOF: Result := grBOF;
  ERR_EOF: Result := grEOF;
  else
  Result := grError;
  if DoCheck then Check(Status);
  end;{ case }
end;

procedure TALPTable.InternalInitRecord(Buffer: PChar);
begin
  ALPInitRecord(FHandle, Buffer);
end;

procedure TALPTable.SetFieldData(Field: TField; Buffer: Pointer);
var
  RecBuf: PChar;
begin
  with Field do
  begin
   GetActiveRecBuf(RecBuf);
   if( FieldNo > 0 )then
   begin
    Validate(Buffer);
    if FieldKind <> fkInternalCalc then
    begin
     Check(ALPPutField(FHandle, FieldNo, RecBuf, Buffer));
    end;
   end else {fkCalculated, fkLookup}
   begin
    Inc(RecBuf, FRecordSize + Offset);
    Boolean(RecBuf[0]) := LongBool(Buffer);
    if Boolean(RecBuf[0]) then Move(Buffer^, RecBuf[1], DataSize);
   end;
   if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
    DataEvent(deFieldChange, Longint(Field));
  end;
end;

procedure TALPTable.InternalFirst;
begin
 ALPSetToBegin(FHandle);
end;

procedure TALPTable.InternalLast;
begin
 ALPSetToEnd(FHandle);
end;

procedure TALPTable.InternalPost;
begin
  if State = dsEdit then
    Check(ALPModifyRecord(FHandle, ActiveBuffer, True)) else
    Check(ALPInsertRecord(FHandle, ActiveBuffer));
end;

procedure TALPTable.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  if Append then
    Check(ALPAppendRecord(FHandle, Buffer)) else
    Check(ALPInsertRecord(FHandle, Buffer));
end;

procedure TALPTable.InternalDelete;
begin
  Check( ALPDeleteRecord(FHandle, nil));
end;

function TALPTable.GetRecordCount: Longint;
begin
  CheckActive;
  if (ALPGetRecordCount(FHandle, Result) <> ERR_NONE) then
    Result := -1;
end;

function TALPTable.GetRecNo: Longint;
var
  BufPtr: PChar;
begin
  CheckActive;
  if State = dsCalcFields then
    BufPtr := CalcBuffer else
    BufPtr := ActiveBuffer;
  Result := PRecInfo(BufPtr + FRecInfoOfs).RecordNumber;
end;

procedure TALPTable.SetRecNo(Value: Integer);
begin
 {
  if (Value >= 0) and (Value < FData.Count) then
  begin
    FCurRec := Value - 1;
    Resync([]);
  end;
 }
end;

function TALPTable.CreateHandle: ALP_HANDLE;
begin
 FHandle := nil;
 if _IsDirectory( FDatabaseName )then
 FFileName  := _NormalDir( FDatabaseName ) + FTableName;

 Check(
 ALPOpenTable(
              FFileName,
              FReadOnly,
              FExclusive,
              FHandle
             )
       );
 Result := FHandle;
end;

procedure TALPTable.DestroyHandle;
begin
 ALPCloseTable(FHandle);
end;

procedure TALPTable.CloseCursor;
begin
  inherited CloseCursor;
  if FHandle <> nil then
  begin
   DestroyHandle;
   FHandle := nil;
  end;
end;

procedure TALPTable.InitFieldDefs;
var
  I        : Integer;
  pFld     : pFLDDESC;
  hHandle  : ALP_HANDLE;
  Result   : ALPRESULT;
  FldCount : Integer;
begin
  hHandle := nil;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if _IsDirectory( FDatabaseName )then
  FFileName  := _NormalDir( FDatabaseName ) + FTableName;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Result := ALPOpenTable(FFileName, True, False, hHandle);
  if( Result = ERR_NONE )then
  begin
   pFLD     := hHandle^.pFIELDS;
   FldCount := hHandle^.iNumFlds;

   FieldDefs.BeginUpdate;
   try
    FieldDefs.Clear;
    for I := 1 to FldCount do
    begin
     AddFieldDesc(pFLD, FieldDefs);
     inc(pFLD);
    end;{ for }
   finally
    FieldDefs.EndUpdate;
   end;{ fin }
   ALPCloseTable(hHandle);
  end;{ if }
end;

procedure TALPTable.OpenCursor(InfoQuery: Boolean);
begin
  if( FHandle = nil )then
    FHandle := CreateHandle;
  inherited OpenCursor(InfoQuery);
end;

procedure TALPTable.InitBufferPointers(GetProps: Boolean);
begin
  if GetProps then
  begin
   BookmarkSize := SizeOf(IBookmark);
   FRecordSize  := FHandle^.iDataSize;
  end;
  FBlobCacheOfs := FRecordSize + CalcFieldsSize;
  FRecInfoOfs   := FBlobCacheOfs + BlobFieldCount * SizeOf(Pointer);
  FBookmarkOfs  := FRecInfoOfs + SizeOf(TRecInfo);
  FRecBufSize   := FBookmarkOfs + BookmarkSize;
end;

procedure TALPTable.CreateTable;
var
 TblDesc: ICRTblDesc;
 Handle : ALP_HANDLE;

 procedure InitTableSettings;
 begin
  FillChar(TblDesc, SizeOf(TblDesc), 0);
  StrPCopy(TblDesc.szDbName, FDatabaseName);
  StrPCopy(TblDesc.szTblName, FTableName);
  TblDesc.iTblType := ttEJM;
 end;{ proc }

 procedure InitFieldDescriptors;
 var
  I    : Integer;
  pPos : pFLDDESC;
 begin
  InitFieldDefsFromFields;
  TblDesc.iFldCount := FieldDefs.Count;
  TblDesc.pFldDesc  := AllocMem(SizeOf(FldDesc) * TblDesc.iFldCount);
  pPos := TblDesc.pFldDesc;
  for I := 0 to FieldDefs.Count - 1 do
  with FieldDefs[I] do
  begin
   pPos^.iFldNum  := I;
   StrPCopy(pPos^.szName, Name);
   pPos^.iFldType := ALP_FLDTYPE(DataType);
   pPos^.iFldSize := Size;
   inc( pPos );
  end;{ with - for }
 end;{ proc }

begin
  CheckInactive;
  InitTableSettings;
  InitFieldDescriptors;
  //InitIndexDescriptors;
  ALPTableCreate(@TblDesc, False, Handle);
end;

procedure TALPTable.SetExclusive(Value: boolean);
begin
 CheckInactive;
 FExclusive := Value;
end;

procedure TALPTable.SetFileName(Value: string);
begin
 CheckInactive;
 FFileName := Value;
end;

function TALPTable.GetActiveRecBuf(var RecBuf: PChar): Boolean;
begin
  case State of
    //dsBlockRead: RecBuf := FBlockReadBuf + (FBlockBufOfs * FRecordSize);
    dsBrowse: if IsEmpty then RecBuf := nil else RecBuf := ActiveBuffer;
    dsEdit, dsInsert: RecBuf := ActiveBuffer;
    //dsSetKey: RecBuf := PChar(FKeyBuffer) + SizeOf(TKeyBuffer);
    dsCalcFields: RecBuf := CalcBuffer;
    //dsFilter: RecBuf := FFilterBuffer;
  else
    RecBuf := nil;
  end;
  Result := RecBuf <> nil;
end;

function TALPTable.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  IsBlank: Boolean;
  RecBuf : PChar;
begin
  Result := GetActiveRecBuf(RecBuf);
  if( Result )then
  begin
   Check(ALPGetField(FHandle, Field.FieldNo, RecBuf, Buffer, IsBlank));
   Result := not IsBlank;
  end;
end;

procedure TALPTable.InternalInsert;
begin
//  FHandle^.bCUR := True;
  CursorPosChanged;
end;

procedure TALPTable.InitRecord(Buffer: PChar);
begin
  inherited InitRecord(Buffer);
  with PRecInfo(Buffer + FRecInfoOfs)^ do
  begin
    UpdateStatus := TUpdateStatus(usInserted);
    BookMarkFlag := bfInserted;
    RecordNumber := -1;
  end;
end;

procedure TALPTable.SetTableName(const Value: string);
begin
 CheckInactive;
 FTableName := Value;
 DataEvent(dePropertyChange, 0);
end;

procedure TALPTable.SetDatabaseName(const Value: string);
begin
 CheckInactive;
 FDatabaseName := Value;
end;


{-----------------------------------------------------------------------}
{     Register Properties                                               }
{-----------------------------------------------------------------------}

{ TDatabaseNameProperty }

type
  TDatabaseNameProperty = class(TStringProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

procedure TDatabaseNameProperty.GetValues(Proc: TGetStrProc);
var
 I: Integer;
 _List: TStringList;
begin
 _List := TStringList.Create;
 try
 {
  SESSION.GetAliasNames(_List);
  for I := 0 to _List.Count - 1 do
  Proc(_List[I]);
  }
 finally
 _List.Free;
 end;
end;

function TDatabaseNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;


{ TTableNameProperty }

type
  TTableNameProperty = class(TStringProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

procedure TTableNameProperty.GetValues(Proc: TGetStrProc);
var
 I      : Integer;
 List   : TStringList;
 FlExt  : string;
 DbName : string;
 Found  : Integer;
 SRec   : TSearchRec;
begin
 List   := TStringList.Create;
 DbName := TALPTable(GetComponent(0)).FDatabaseName;
 if _IsDirectory( DbName )then
 DbName := _NormalDir( DbName );
 try
  Found := FindFirst(DbName + '*.*', faAnyFile, SRec);
  while( Found = 0 )do
  begin
   FlExt := UpperCase(ExtractFileExt(SRec.Name));
   if( SRec.Name <> '.' )and( SRec.Attr and faDirectory = 0 )then
   if( FlExt = '.DB' )or( FlExt = '.DBF' )or
     ( FlExt = '.DAT' )or( FlExt = '.EJM' )then
   List.Add(SRec.Name);
   Found := FindNext( SRec );
  end;{ while }
  FindClose( SRec );

  for I := 0 to List.Count - 1 do
  Proc(List[I]);
 finally
  List.Free;
 end;
end;

function TTableNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(string), TALPTable, 'DatabaseName', TDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TALPTable, 'TableName', TTableNameProperty);
{$IFDEF REGISTERONPAGE}
  RegisterComponents('Deleon', [TALPTable]);
{$ENDIF}
end;

end.
