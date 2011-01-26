unit ALP;
{-----------------------------------------------------------------------------
 Universal unit of access to databases without BDE
 Last modification : 23 May 2001
 (Please write this last modification date in your e-mails.)

 Version: 	1.17
 Author:	Momot Alexander (Deleon)
 Http:          http://www.dbwork.chat.ru
 E-Mail:	dbwork@chat.ru
 Status:	FreeWare
 Delphi:		32-bit versions
 Platform:	Windows 32-bit versions.

~ History ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* 27 Feb 2001
  - Adding a new error codes.
  - Correct ALPDeleteRecord function.
  - Correct ALPGetRecord function.

-----------------------------------------------------------------------------}

interface

uses
  Windows, SysUtils, Alp32;

type
  Char3      = array[0..02] of Char;
  Char12     = array[0..11] of Char;
  Char16     = array[0..15] of Char;
  Char24     = array[0..23] of Char;
  Char32     = array[0..31] of Char;
  Char36     = array[0..35] of Char;
  Char48     = array[0..47] of Char;
  Char64     = array[0..63] of Char;
  Char256    = array[0..255]of Char;
  TByteSet   = set of Byte;
  TByteIdent = record
                iOffs: Word;
                iVals: TByteSet;
               end;
  TTblIdent  = packed record
                iName : string[16];
                iDesc : string[24];
                iCount: 0..6;
                iIdent: array[0..6]of TByteIdent;
               end;{ rec }


{----------------------------------------------------------------------------}
{ SUPPORTED TABLE TYPES                                                      }
{----------------------------------------------------------------------------}

  ALP_TBLTYPE  = (
                   ttUNKNOWN,  { Unknown table type      }
                   ttDBASE3,   { FoxBase+/dBase III Plus }
                   ttDBASE4,   { dBase IV                }
                   ttDBASE5,   { dBase V for WIN         }
                   ttDBASE7,   { dBase VII for WIN       }
                   ttFOXPRO1,  { FoxPRO                  }
                   ttFOXPRO2,  { FoxPRO                  }
                   ttFOXPRO3,  { FoxPRO                  }
                   ttFOXPRO4,  { FoxPRO                  }
                   ttPARADOX3, { Paradox 3.5             }
                   ttPARADOX4, { Paradox 4               }
                   ttPARADOX5, { Paradox 5 for WIN       }
                   ttPARADOX7, { Paradox 7 for WIN       }
                   ttCLARION1, { Clarion 1               }
                   ttCLARION2, { Clarion 2               }
                   ttEXCEL,    { Excel                   }
                   ttEJM       { EJM                     }
                  );

  ALP_TYPESET = set of ALP_TBLTYPE;


{============================================================================}
{                   Bookmark Properties                                      }
{============================================================================}
  pBookmark = ^IBookmark;       { Bookmark properties }
  IBookmark  = Integer;

{============================================================================}
{                   Record Properties                                        }
{============================================================================}

type
  RECStatus = (rsUnmodified, rsModified, rsInserted, rsDeleted);

  pRECProps = ^RECProps;
  RECProps = packed record              { Record properties }
    iRecNum         : Longint;          { When Seq# supported only }
    iRecStatus      : RECStatus;        { Delayed Updates Record Status }
    bDeleteFlag     : Boolean;          { When soft delete supported only }
  end;


const
{----------------------------------------------------------------------------}
{ ALP CONSTANTS                                                             }
{----------------------------------------------------------------------------}

{ TABLE IDENTS }
  TBLIDENT : array[ALP_TBLTYPE]of TTblIdent =
             (
              (iName: 'UNKNOWN';  iDesc: 'UNKNOWN';  iCount: 0; iIdent: ((iOffs: 00;iVals: [00]),             (iOffs: 00;iVals: [00]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'dBASE3';   iDesc: 'UNKNOWN';  iCount: 6; iIdent: ((iOffs: 00;iVals: [$03,$83]),        (iOffs: 14;iVals: [00,01]),       (iOffs: 15;iVals: [00,01]), (iOffs: 12;iVals: [00]), (iOffs: 13;iVals: [00]), (iOffs: 28;iVals: [00,01]), (iOffs: 00;iVals: [00]))),
              (iName: 'dBASE4';   iDesc: 'UNKNOWN';  iCount: 6; iIdent: ((iOffs: 00;iVals: [$04,$8B,$8E,$7B]),(iOffs: 14;iVals: [00,01]),       (iOffs: 15;iVals: [00,01]), (iOffs: 12;iVals: [00]), (iOffs: 13;iVals: [00]), (iOffs: 28;iVals: [00,01]), (iOffs: 00;iVals: [00]))),
              (iName: 'dBASE5';   iDesc: 'UNKNOWN';  iCount: 6; iIdent: ((iOffs: 00;iVals: [$05]),            (iOffs: 14;iVals: [00,01]),       (iOffs: 15;iVals: [00,01]), (iOffs: 12;iVals: [00]), (iOffs: 13;iVals: [00]), (iOffs: 28;iVals: [00,01]), (iOffs: 00;iVals: [00]))),
              (iName: 'dBASE7';   iDesc: 'UNKNOWN';  iCount: 6; iIdent: ((iOffs: 00;iVals: [$9B]),            (iOffs: 14;iVals: [00,01]),       (iOffs: 15;iVals: [00,01]), (iOffs: 12;iVals: [00]), (iOffs: 13;iVals: [00]), (iOffs: 28;iVals: [00,01]), (iOffs: 00;iVals: [00]))),
              (iName: 'FOXPRO1';  iDesc: 'UNKNOWN';  iCount: 0; iIdent: ((iOffs: 00;iVals: [$00]),            (iOffs: 00;iVals: [00]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'FOXPRO2';  iDesc: 'UNKNOWN';  iCount: 0; iIdent: ((iOffs: 00;iVals: [$00]),            (iOffs: 00;iVals: [00]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'FOXPRO3';  iDesc: 'UNKNOWN';  iCount: 0; iIdent: ((iOffs: 00;iVals: [$00]),            (iOffs: 00;iVals: [00]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'FOXPRO4';  iDesc: 'UNKNOWN';  iCount: 0; iIdent: ((iOffs: 00;iVals: [$00]),            (iOffs: 00;iVals: [00]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'PARADOX3'; iDesc: 'UNKNOWN';  iCount: 3; iIdent: ((iOffs: 04;iVals: [00,02]),          (iOffs: 05;iVals: [01,02,03,04]), (iOffs: 57;iVals: [04]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'PARADOX4'; iDesc: 'UNKNOWN';  iCount: 3; iIdent: ((iOffs: 04;iVals: [00,02]),          (iOffs: 05;iVals: [01,02,03,04]), (iOffs: 57;iVals: [09]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'PARADOX5'; iDesc: 'UNKNOWN';  iCount: 3; iIdent: ((iOffs: 04;iVals: [00,02]),          (iOffs: 05;iVals: [01,02,03,04]), (iOffs: 57;iVals: [11]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'PARADOX7'; iDesc: 'UNKNOWN';  iCount: 3; iIdent: ((iOffs: 04;iVals: [00,02]),          (iOffs: 05;iVals: [01,02,03,04]), (iOffs: 57;iVals: [12]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'CLARION1'; iDesc: 'CLARION1'; iCount: 0; iIdent: ((iOffs: 00;iVals: [67]),             (iOffs: 01;iVals: [51]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'CLARION2'; iDesc: 'CLARION2'; iCount: 2; iIdent: ((iOffs: 00;iVals: [67]),             (iOffs: 01;iVals: [51]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'EXCEL';    iDesc: 'EXCEL';    iCount: 0; iIdent: ((iOffs: 00;iVals: [67]),             (iOffs: 01;iVals: [51]),          (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00]))),
              (iName: 'EJM';      iDesc: 'EJM';      iCount: 4; iIdent: ((iOffs: 00;iVals: [09]),             (iOffs: 01;iVals: [04]),          (iOffs: 02;iVals: [74]),    (iOffs: 03;iVals: [19]), (iOffs: 00;iVals: [00]), (iOffs: 00;iVals: [00]),    (iOffs: 00;iVals: [00])))
             );

  ALP_CLARIONTYPES : ALP_TYPESET =  [ttCLARION1..ttCLARION2];
  ALP_DBASETYPES   : ALP_TYPESET =  [ttDBASE3..ttDBASE7, ttFOXPRO1..ttFOXPRO4];
  ALP_PDXTYPES     : ALP_TYPESET =  [ttPARADOX3..ttPARADOX7];

{ ERRORS }
  ERR_NONE                   = 0;
  ERR_UNSUPPORTEDFILE        = 1;
  ERR_CANNOTOPENFILE         = 2;
  ERR_CANNOTCLOSEFILE        = 3;
  ERR_INVALIDFILE            = 4;
  ERR_INVALIDHANDLE          = 5;
  ERR_INVALIDFILENAME        = 6;
  ERR_FILENOTEXIST           = 7;
  ERR_CANNOTSEEK             = 8;
  ERR_CANNOTREADFILE         = 9;
  ERR_CANNOTWRITEFILE        = 10;
  ERR_BOF                    = 11;
  ERR_EOF                    = 12;
  ERR_BUFFERISEMPTY          = 13;
  ERR_INVALIDFIELDDESC       = 14;
  ERR_INVALIDINDEXDESC       = 15;
  ERR_RECDELETED             = 16;
  ERR_INVALIDCRDESC          = 17;

{ PARAMETERS }
  PRM_NUMRECS                = 11;
  PRM_NUMDELS                = 12;
  PRM_NUMFLDS                = 13;
  PRM_RECSIZE                = 14;
  PRM_BLOCKFIRST             = 15;
  PRM_BLOCKLAST              = 16;
  PRM_BLOCKFREE              = 17;
  PRM_BLOCKUSED              = 18;
  PRM_BLOCKTOTAL             = 19;

{ MAX }
  MAX_FILENAMELEN            = 255;
  MAX_HEADERBUFSIZE          = 1024 * 2;
  MAX_BUFFERSIZE             = 1024 * 32;   { Read buffer size }

{ SEEK }
  SEEK_FROMBEGIN             = 0;           { Seek from begin of file }
  SEEK_FROMCURRENT           = 1;           { Seek from current position }
  SEEK_FROMEND               = 2;           { Seek from end of file }

{ SEEK OF FILE }
  SEEK_PDXVERSION            = 57;

{ SET BUFFER RESULTS }
  BUFFER_NORMAL              = 0;
  BUFFER_EMPTY               = 1;
  BUFFER_END                 = 2;

{ VERSION }
  VERSION_DBASE3             = $03;
  VERSION_DBASE4             = $04;
  VERSION_DBASE5             = $05;
  VERSION_DBASE7             = $8B;

  VERSION_PDX3               = 04;
  VERSION_PDX4               = 09;
  VERSION_PDX5               = 11;
  VERSION_PDX7               = 12;

type
{----------------------------------------------------------------------------}
{ ARRAYS                                                                     }
{----------------------------------------------------------------------------}

  ALP_FILENAME     = packed array [0..MAX_FILENAMELEN] of Char; { holds a DOS path }


{============================================================================}
{                    Field map                                               }
{============================================================================}

  ALP_FLDTYPE =   (uftUnknown,    uftString,      uftSmallint,  uftInteger,
              {4}  uftWord,       uftBoolean,     uftFloat,     uftCurrency,
              {8}  uftBCD,        uftDate,        uftTime,      uftDateTime,
              {12} uftBytes,      uftVarBytes,    uftAutoInc,   uftBlob,
              {16} uftMemo,       uftGraphic,     uftFmtMemo,   uftParadoxOle,
              {20} uftDBaseOle,   uftTypedBinary, uftCursor,    uftFixedChar,
              {24} uftWideString, uftLargeint,    uftADT,       uftArray,
              {28} uftReference,  uftDataSet,     uftOraBlob,   uftOraClob,
              {32} uftVariant,    uftInterface,   uftIDispatch, uftGuid);

  ALP_SUBTYPE = (sftUNKNOWN, sftBYTE, sftBCD);



const
  ALP_FLDSIZES: packed array[ALP_FLDTYPE] of Byte =
    (0 {ftUnknown},    0 {ftString},      2 {ftSmallint}, 4  {ftInteger},    2 {ftWord},
     0 {ftBoolean},    8 {ftFloat},       8 {ftCurrency}, 0  {ftBCD},        4 {ftDate},
     4 {ftTime},       8 {ftDateTime},    0 {ftBytes},    0  {ftVarBytes},   4 {ftAutoInc},
     10{ftBlob},       10{ftMemo},        10{ftGraphic},  10 {ftFmtMemo},    0 {ftParadoxOle},
     10{ftDBaseOle},   10{ftTypedBinary}, 10{ftCursor},   0  { ftFixedChar },
     0 {ftWideString}, 0 {ftLargeInt} ,   0 {ftADT},      0  {ftArray},      0 {ftReference},
     0 {ftDataSet},    10{ftOraBlob},     10{ftOraClob},  0  {ftVariant},    10{ftInterface},
     0 {ftIDispatch},  0 {ftGuid});

  ALP_SIZEFLDS = [uftString, uftBytes, uftVarBytes, uftADT, uftArray, uftReference];

{----------------------------------------------------------------------------}
{ SUPPORTED TABLE HEADERS                                                    }
{----------------------------------------------------------------------------}


{============================================================================}
{                    dBASE descriptors                                       }
{============================================================================}

  FLD_DB_STRING  = 67;
  FLD_DB_DATE    = 68;
  FLD_DB_NUMBER  = 70;
  FLD_DB_BOOLEAN = 76;
  FLD_DB_MEMO    = 77;
  FLD_DB_FLOAT   = 78;

type
  HDR_DBASE = packed record
  {000} Version     : Byte;    { dBase version                   }
  {001} Year        : Byte;    { Year of last update             }
  {002} Month       : Byte;    { Month of last update            }
  {003} Day         : Byte;    { Day of last update              }
  {004} NumRecs     : Integer; { Number of records in the file   }
  {008} HdrLen      : Word;    { Length of the header            }
  {010} RecLen      : Word;    { Length of individual records    }
  {012} Nets        : Word;    { not used                        }
  {014} Transaction : Byte;    { begin-end transaction (0,1)     }
  {015} Encrypted   : Byte;    { Coded fields (0,1)              }
  {016} NetWork     : array [0..11]of Byte;
  {028} MdxFile     : Byte;    { Exist .mdx file indicator (0,1) }
  {029} LangDrv     : Byte;    { language driver /fox/           }
  {030} Labeled     : Word;
  end;{ rec }

  { 001 - code page 437  }
  { 002 - code page 850  }
  { 100 - code page 852  }
  { 102 - code page 865  }
  { 101 - code page 866  }
  { 104 - code page 895  }
  { 200 - code page 1250 }
  { 201 - code page 1251 }
  { 003 - code page 1252 }

  HDR_DBASEADD = record
    Dummy   : array[32..67] of byte;
  end;{ rec }

  pFLDHDR_DBASE = ^FLDHDR_DBASE;
  FLDHDR_DBASE = packed record
    Hdr  : Byte;                 { record header type and status }
  end;

  pFLD_DBASE3 = ^FLD_DBASE3;
  FLD_DBASE3 = packed record
  {000} FldName  : array[0..10]of Char;
  {011} FldType  : Byte;
  {012} Rsrv1    : array[0..3]of Byte;
  {016} FldSize  : Byte;
  {017} FldDec   : Byte;
  {018} Rsrv2    : array[0..13]of Byte;
  end;{ rec }

  pFLD_DBASE5 = ^FLD_DBASE5;
  FLD_DBASE5 = packed record
  {000} FldName  : array[0..10]of Char;
  {011} Rsrv1    : array[0..20]of Byte;
  {032} FldType  : Byte;
  {033} FldSize  : Byte;
  {034} FldDec   : Byte;
  {035} Rsrv2    : array[0..12]of Byte;
  end;{ rec }

  pDATE_DBASE = ^DATE_DBASE;
  DATE_DBASE = packed record
  {000} Year     : array[0..3]of Char;
  {004} Month    : array[0..1]of Char;
  {006} Day      : array[0..1]of Char;
  end;

const
  DELFLAG_DBASE       = Ord('*');
  EMPCHAR_DBASE       = Ord(' ');
  OFFS_DBASE_NUMRECS  = 4;

{============================================================================}
{                    CLARION descriptors                                     }
{============================================================================}
const
  SIGN_LOCKED     =   1;         { bit 0 - file is locked          }
  SIGN_OWNED      =   2;         { bit 1 - file is owned           }
  SIGN_ENCRYPTED  =   4;         { bit 2 - records are encrypted   }
  SIGN_MEMO       =   8;         { bit 3 - memo file exists        }
  SIGN_COMPRESSED =  16;         { bit 4 - file is compressed      }
  SIGN_RECLAIM    =  32;         { bit 5 - reclaim deleted records }
  SIGN_READONLY   =  64;         { bit 6 - file is read only       }
  SIGN_CREATED    =  128;        { bit 7 - file may be created     }

  DELFLAG_CLARION =    16;
  EMPCHAR_CLARION =     0;
  DELTA_DAYS      = 36161;       { for fast DATE conversion }

  FLD_CL_LONG     = 1;
  FLD_CL_REAL     = 2;
  FLD_CL_STRING   = 3;
  FLD_CL_PICTURE  = 4;
  FLD_CL_BYTE     = 5;
  FLD_CL_SHORT    = 6;
  FLD_CL_GROUP    = 7;
  FLD_CL_DECIMAL  = 8;

type
  HDR_CLARION = packed record
  {000} FileSIG  : Word;             { file signature            }
  {002} SFAtr    : Word;             { file attribute and status }
  {004} NumKeys  : Byte;             { number of keys in file      }
  {005} NumRecs  : Integer;          { number of records in file   }
  {009} NumDels  : Integer;          { number of deleted records   }
  {013} NumFlds  : Word;             { number of fields            }
  {015} NumPics  : Word;             { number of pictures          }
  {017} NumArrs  : Word;             { number of array descriptors }
  {019} RecLen   : Word;             { record length (including record header) }
  {021} Offset   : Integer;          { start of data area          }
  {025} LogEOF   : Integer;          { logical end of file         }
  {029} LogBOF   : Integer;          { logical beginning of file   }
  {033} FreeRec  : Integer;          { first usable deleted record }
  {037} RecName  : Char12;           { record name without prefix }
  {049} MemName  : Char12;           { memo name without prefix   }
  {061} FilPrefx : Char3;            { file name prefix           }
  {064} RecPrefx : Char3;            { record name prefix         }
  {067} MemoLen  : Word;             { size of memo         }
  {069} MemoWid  : Word;             { column width of memo }
  {071} LockCont : Integer;          { Lock Count }
  {075} ChgTime  : Integer;          { time of last change }
  {079} ChgDate  : Integer;          { date of last change }
  {083} CheckSum : Word;             { checksum for encrypt }
  end; { rec }

  pFLDHDR_CLARION = ^FLDHDR_CLARION;
  FLDHDR_CLARION = packed record
    Hdr  : Byte;                 { record header type and status }
    Ptr  : Integer;              { pointer for next deleted record or memo if active }
  end;

  pFLD_CLARION = ^FLD_CLARION;
  FLD_CLARION  = packed record
    FldType : Byte;              { type of field }
    FldName : Char16;            { name of field }
    FOffset : Word;              { offset into record }
    Length  : Word;              { length of field    }
    DecSig  : Byte;              { significance for decimals }
    DecDec  : Byte;              { number of decimal places  }
    ArrNum  : Word;              { array number   }
    PicNum  : Word;              { picture number }
  end;

  pKEY_CLARION = ^KEY_CLARION;
  KEY_CLARION = packed record
    NumComps : Byte;             { number of components for key }
    KeyNams  : Char16;           { name of this key    }
    CompType : Byte;             { type of composite   }
    CompLen  : Byte;             { length of composite }
  end;

  pKEYITEM_CLARION = ^KEYITEM_CLARION;
  KEYITEM_CLARION = packed record
    FldType : Byte;              { type of field }
    FldNum  : Word;              { field number  }
    ElmOff  : Word;              { record offset of this element }
    ElmLen  : Byte;              { length of element }
  end;

  pPICT_CLARION = ^PICT_CLARION;
  PICT_CLARION = packed record
    PicLen : Word;
    PicStr : Char256;
  end;

  pARR_CLARION = ^ARR_CLARION;
  ARR_CLARION = packed record
    NumDim : Word;               { dims for current field         }
    TotDim : Word;               { total number of dims for field }
    ElmSiz : Word;               { total size of current field    }
  end;

  pARRITEM_CLARION = ^ARRITEM_CLARION;
  ARRITEM_CLARION = packed record
    MaxDim : Word;               { number of dims for array part }
    LenDim : Word;               { length of field }
  end;


{============================================================================}
{                    PARADOX descriptors                                       }
{============================================================================}

const
  FLD_PD_ALPHA          = 1;
  FLD_PD_DATE           = 2;
  FLD_PD_INT16          = 3;
  FLD_PD_INT32          = 4;
  FLD_PD_MONEY          = 5;
  FLD_PD_NUMBER         = 6;
  FLD_PD_LOGICAL        = 9;
  FLD_PD_MEMO           = 12;
  FLD_PD_BINARY         = 13;
  FLD_PD_FMEMO          = 14;
  FLD_PD_OLE            = 15;
  FLD_PD_GRAPHIC        = 16;
  FLD_PD_TIME           = 20;
  FLD_PD_TIMESTAMP      = 21;
  FLD_PD_AUTOINC        = 22;
  FLD_PD_BCD            = 23;
  FLD_PD_BYTES          = 24;

  OFFS_FIRSTRECPDX    = 06;

type
  HDR_PARADOX = packed record
  {000} RecLen     : Word;        { record length (including record header) }
  {002} HdrLen     : Word;        { header length               }
  {004} Keyed      : Byte;        { flag keyed table or not     }
  {005} BlockSize  : Byte;        { data block size code in kb  }
  {006} NumRecs    : Longint;     { number of records in file   }
  {010} NumBlUsed  : Word;        { number of blocks in use     }
  {012} NumBlTotal : Word;        { number of blocks total      }
  {014} BlFirst    : Word;        { First data block (always 1) }
  {016} BlLast     : Word;        { Last data block             }
  {018} Rsrv1      : array[0..14]of Byte;
  {033} NumFlds    : Byte;        { number of fields            }
  {034} Rsrv2      : Byte;
  {035} NumKeyFlds : Word;        { number of keyed fields      }
  {037} Rsrv3      : array[0..19]of Byte;
  {057} Version    : Byte;        { version of file             }
  {058} Rsrv4      : array[0..14]of Byte;
  {073} AutoInc    : Integer;     { autoincrement value         }
  {077} BlFrstFree : Word;        { first free block            }
  {079} Rsrv5      : array[0..40]of Byte;
  {120} OffsFlds   : Word;        { start of field description array }
  end;

  pFLD_PARADOX = ^FLD_PARADOX;
  FLD_PARADOX = packed record
  {000} FldType   : Byte;
  {001} FldSize   : Byte;
  end;{ rec }

  pBLOCK_HDR = ^BLOCK_HDR;
  BLOCK_HDR = packed record
  {000} NumNext   : Word;         { Next block number (Zero if last block)      }
  {002} NumPrev   : Word;         { Previous block number (Zero if first block) }
  {004} OffsLast  : SmallInt;     { Offset of last record in block              }
  end;{ rec }

{============================================================================}
{                    EJM descriptors                                         }
{============================================================================}

const
  EJM_TBLIDENT = 323617801;

type
  HDR_EJM = packed record
  {000} Ident      : Longint;     { table identificator         }
  {004} Version    : Byte;        { table version               }
  {005} HdrLen     : Word;        { header length               }
  {007} Keyed      : Byte;        { flag keyed table or not     }
  {008} BlockSize  : Byte;        { data block size code in kb  }
  {009} RecLen     : Longint;     { data record size            }
  {013} NumFlds    : Word;        { number of fields            }
  {015} NumRecs    : Longint;     { number of records           }
  {019} NumDels    : Longint;     { number of deleted records   }
  {023} NumKeyFlds : Word;        { number of keyed fields      }
  {025} AutoInc    : Longint;     { autoincrement value         }
  {029} Encrypted  : Byte;        { encripted value             }
  {030} LangDrv    : array[0..15]of Byte;
  {046} Password   : array[0..15]of Byte;
  {062} Rsrv1      : array[0..15]of Byte;
  {078} Rsrv2      : array[0..6] of Byte;
  end;

  pFLD_EJM = ^FLD_EJM;
  FLD_EJM = packed record
  {000} FldType   : Byte;
  {001} FldSize   : Byte;
  {002} FldDec    : Byte;
  end;{ rec }

  IFLD_EJM_STATE = (esNORMAL, esDELETED);

type
  ALPRESULT = Word;

{============================================================================}
{                    Record descriptor                                       }
{============================================================================}


{============================================================================}
{                    Field descriptor                                        }
{============================================================================}

  pFLDDESC = ^FLDDESC;
  FLDDESC = packed record
   iFldNum         : Word;             { Field number (1..n) }
   szName          : Char36;           { Field name }
   iFldType        : ALP_FLDTYPE;     { Field type }
   iSubType        : ALP_SUBTYPE;     { Sub field type }
   iFldSize        : Word;             { Number of Chars, digits etc }
   iFldSig         : Byte;             { significance for decimals }
   iFldDec         : Byte;             { number of decimal places  }
   iOffset         : Word;             { Offset in the record (computed) }
   iPhysLen        : Word;             { Length in bytes (computed) }
   iDataLen        : Word;             { Data length in bytes }
   iUnUsed         : array [0..1] of Word;
  end;

  pFldArray = ^IFldArray;
  IFldArray = array[0..0]of FLDDESC;

{============================================================================}
{                    Index descriptor                                        }
{============================================================================}

  pIdxDesc = ^IdxDesc;
  IdxDesc = packed record
   iIdxNum         : Word;             { Index number (1..n) }
   szName          : Char36;           { Index name }
   iUnUsed         : array [0..1] of Word;
  end;

  pIdxArray = ^IIdxArray;
  IIdxArray = array[0..0]of IdxDesc;

{============================================================================}
{                    Handle descriptor                                       }
{============================================================================}
  IBuffer      = class;

  ALP_HANDLE   = ^_HANDLE;
  _HANDLE  = packed record
   iHandle       : Integer;            { Handle of data file                }
   iTblType      : ALP_TBLTYPE;        { Type of file (dBase, Clarion etc.) }
   iTblDesc      : Char16;             { File descriptor                    }
   iVersion      : Word;               { File version                       }
   iFileName     : ALP_FILENAME;       { File name                          }
   iHdrSize      : Integer;            { Size of header                     }
   iHdrReadBytes : Integer;            { Count of read bytes in buffer      }
   iFilePos      : Integer;            { Cursor position in file            }
   iRecId        : Integer;            { Record index                       }
   iRecPos       : Integer;            { Record position in file            }
   iOffsData     : Integer;            { Offset begin of data               }
   iOffsNames    : Integer;            { Offset begin of field names        }
   iAutoInc      : Integer;            { AutoInc value                      }
   iNumRecs      : Integer;            { Number of records                  }
   iNumDels      : Integer;            { Number of deleted records          }
   iNumFlds      : Word;               { Number of physical fields          }
   iNumIdxs      : Word;               { Number of indexes                  }
   iNumPict      : Word;               { Number of pictures                 }
   iNumArrs      : Word;               { Number of arrays                   }
   iNumBlobs     : Byte;               { Number of blobs                    }
   iRecSize      : Word;               { Physical record size               }
   iMarkSize     : Word;               { Bookmark size                      }
   iDataSize     : Word;               { Data rec size without hdr          }
   iFldHdrSize   : Byte;               { Size of record header              }
   //~~~~~~~~~~~~~
   iBlockPos     : Integer;            { Size of block                      }
   iBlockFirst   : Integer;            { Number of first block              }
   iBlockLast    : Integer;            { Number of last block               }
   iBlockUsed    : Integer;            { Count of used blocks               }
   iBlockTotal   : Integer;            { Total count of blocks              }
   iBlockCurr    : Integer;            { Size of block                      }
   iBlockNext    : Integer;            { Size of block                      }
   iBlockPred    : Integer;            { Size of block                      }
   iBlockSize    : Integer;            { Size of block                      }
   //~~~~~~~~~~~~~
   iBufSize      : Integer;            { Size of buffer                     }
   iReadBytes    : Integer;            { Count bytes in buffer              }
   iCurrRec      : Integer;            { Current record in buffer           }
   iMaxPos       : Integer;            { Max pos record to read             }
   iFooterLen    : Word;               { Size of footer                     }
   mBlocksInBuf  : Integer;            { Max count blocks in buffer         }
   mRecsInBuf    : Integer;            { Max count records in buffer        }
   mRecsInBlock  : Integer;            { Max count records in block         }
   pFIELDS       : pFLDDESC;           { Pointer to fields descriptor       }
   BUFFER        : IBuffer;            { Pointer to buffer                  }
   pHEADER       : pBYTE;              { Pointer to header descriptor       }
  end;


{============================================================================}
{                   Buffer class                                             }
{============================================================================}
  pRecDesc = ^IRecDesc;
  IRecDesc = packed record
    Ident     : Integer;
    Pos       : Integer;
  end;{ rec }

  IBuffer  = class
  private
    pHandle     : ALP_HANDLE;
    //~~~~~~~~~~~~~~
    pMainBuf    : Pointer;
    pIntBuf     : Pointer;
    pCursor     : Pointer;
    //~~~~~~~~~~~~~~
    BufferPos   : Integer;
    BufferSize  : Integer;
    RecordId    : Integer;
    RecordOffs  : Integer;
    RecordSize  : Integer;
    ReadRecs    : Integer;
    Capacity    : Integer;
    function    GetRecPos: Integer;
    function    IsBOF   : Boolean;
    function    IsEOF   : Boolean;
    function    IsEMPTY : Boolean;
  public
    constructor Create(Owner: ALP_HANDLE);
    destructor  Destroy; override;
    procedure   Clear;
    procedure   Delete;
    function    Next  : Boolean;
    function    Prior : Boolean;
    function    First : Boolean;
    function    Last  : Boolean;
    function    Locate(RecPos: Integer): Boolean;
    function    SetToRec(RecId: Integer): Boolean;
    property    BOF   : Boolean read IsBOF;
    property    EOF   : Boolean read IsEOF;
    property    RecPos: Integer read GetRecPos;
  end;


{============================================================================}
{                      Create/Restructure descriptor                         }
{============================================================================}

type
  pCROpType = ^ICROpType;
  ICROpType = (                         { Create/Restruct Operation type }
    crNOOP,
    crADD,                              { Add a new element. }
    crCOPY,                             { Copy an existing element. }
    crMODIFY,                           { Modify an element. }
    crDROP,                             { Removes an element. }
    crREDO,                             { Reconstruct an element. }
    crTABLE,                            { Not used }
    crGROUP,                            { Not used }
    crFAMILY,                           { Not used }
    crDONE,                             { Used internally }
    crDROPADD                           { Used internally }
  );

  pCRTblDesc = ^ICRTblDesc;
  ICRTblDesc = packed record            { Create/Restruct Table descr }
    szDbName        : Char256;          { DatabaseName           }
    szTblName       : Char36;           { TableName incl. optional path & ext }
    iTblType        : ALP_TBLTYPE;      { Driver type (optional) }
    szUserName      : Char36;           { User name (if applicable) }
    szPassword      : Char24;           { Password (optional) }
    bProtected      : Boolean;          { Master password supplied in szPassword }
    bPack           : Boolean;          { Pack table (restructure only) }
    iFldCount       : Word;             { Number of field defs supplied }
    pFldOp          : pCROpType;        { Array of field ops }
    pFldDesc        : pFLDDesc;         { Array of field descriptors }
    iIdxCount       : Word;             { Number of index defs supplied }
    pIdxOp          : pCROpType;        { Array of index ops }
    pIdxDesc        : PIdxDesc;         { Array of index descriptors }
    (*
    iSecRecCount    : Word;             { Number of security defs supplied }
    pecrSecOp       : pCROpType;        { Array of security ops }
    psecDesc        : pSECDesc;         { Array of security descriptors }
    iValChkCount    : Word;             { Number of val checks }
    pecrValChkOp    : pCROpType;        { Array of val check ops }
    pvchkDesc       : pVCHKDesc;        { Array of val check descs }
    iRintCount      : Word;             { Number of ref int specs }
    pecrRintOp      : pCROpType;        { Array of ref int ops }
    printDesc       : pRINTDesc;        { Array of ref int specs }
    iOptParams      : Word;             { Number of optional parameters }
    pfldOptParams   : pFLDDesc;         { Array of field descriptors }
    pOptData        : Pointer;          { Optional parameters }
    *)
  end;

{===========================================================================}
{ ALP FUNCTIONS                                                             }
{===========================================================================}
{                      Table Open, Properties & Structure                   }
{===========================================================================}

function ALPOpenTable (                { Open a table }
      FileName      : string;          { Table name or file name }
      bReadOnly     : boolean;         { Read or RW }
      bExclusive    : boolean;         { Excl or Share }
var   Handle        : ALP_HANDLE       { Returns Cursor handle }
   ): ALPResult;

function ALPCloseTable (               { Closes cursor }
      Handle        : ALP_HANDLE       { Pntr to Cursor handle }
   ): ALPResult;

function ALPTableCreate (              { Create a table        }
      pTblDesc      : pCRTblDesc;      { Table descriptor      }
      bOpen         : boolean;         { Open after create     }
var   Handle        : ALP_HANDLE       { Returns Cursor handle }
   ): ALPResult;

function ALPGetFieldDescs (            { Get field descriptions }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pFldDesc      : pFLDDesc         { Array of field descriptors }
   ): ALPResult;

{=============================================================================}
{                              Cursor Maintenance                             }
{=============================================================================}


function ALPSetToBegin (               { Reset cursor to beginning }
      Handle        : ALP_HANDLE       { Cursor handle }
   ): ALPResult;

function ALPSetToEnd (                 { Reset cursor to ending }
      Handle        : ALP_HANDLE       { Cursor handle }
   ): ALPResult;

function ALPGetBookMark (              { Get a book-mark }
      Handle        : ALP_HANDLE;      { Cursor }
      pBkMark       : Pointer          { Pointer to Book-Mark }
   ): ALPResult;

function ALPSetToBookMark (            { Position to a Book-Mark }
      Handle        : ALP_HANDLE;      { Cursor }
      pBkMark       : Pointer          { Pointer to Book-Mark }
   ): ALPResult;


{============================================================================}
{                      Data Access: Logical Record Level                     }
{============================================================================}

function ALPGetNextRecord (            { Find/Get the next record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer;         { Record buffer(client) }
      pRecProps     : pRECProps        { Optional record properties }
   ): ALPResult;

function ALPGetPriorRecord (           { Find/Get the prior record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer;         { Record buffer(client) }
      pRecProps     : pRECProps        { Optional record properties }
   ): ALPResult;

function ALPGetRecord (                { Gets the current record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer;         { Record buffer(client) }
      pRecProps     : pRECProps        { Optional record properties }
   ): ALPResult;

function ALPInitRecord (               { Initialize record area }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer          { Record buffer }
   ): ALPResult;

function ALPInsertRecord (             { Inserts a new record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer          { New Record (client) }
   ): ALPResult;

function ALPModifyRecord (             { Updates the current record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuf       : Pointer;         { Modified record }
      bFreeLock     : Boolean          { Free record lock }
   ): ALPResult;

function ALPDeleteRecord (             { Deletes the current record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuf       : Pointer          { Copy of deleted record }
   ): ALPResult;

function ALPReadBlock (                { Read a block of records }
      Handle        : ALP_HANDLE;      { Cursor handle }
var   iRecords      : Longint;         { Number of records to read }
      pBuf          : Pointer          { Buffer }
   ): ALPResult;

function ALPWriteBlock (               { Write a block of records }
      Handle        : ALP_HANDLE;      { Cursor handle }
var   iRecords      : Longint;         { Number of records to write/written }
      pBuf          : Pointer          { Buffer }
   ): ALPResult;

function ALPAppendRecord (             { Inserts a new record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer          { New Record (client) }
   ): ALPResult;

function ALPGetRecordCount (           { Get the current number of records }
      Handle        : ALP_HANDLE;      { Cursor handle }
var   iRecCount     : Longint          { Number of records }
   ): ALPResult;

{============================================================================}
{                            Field Level Access                              }
{============================================================================}

function ALPGetField (                 { Get Field value }
      Handle        : ALP_HANDLE;      { Cursor }
      iField        : Word;            { Field # (1..n) }
      pRecBuff      : Pointer;         { Record buffer }
      pDest         : Pointer;         { Destination field buffer }
var   bBlank        : Boolean          { Returned : is field blank }
   ): ALPResult;

function ALPPutField (                 { Put a value in the record buffer }
      Handle        : ALP_HANDLE;      { Cursor }
      iField        : Word;            { Field # (1..n) }
      pRecBuff      : Pointer;         { Record buffer }
      pSrc          : Pointer          { Source field buffer }
   ): ALPResult;


{============================================================================}
{                            Formatting data                                 }
{============================================================================}

function ALPDataToIDE (                { Get a formatted value }
      Handle        : ALP_HANDLE;      { Cursor }
      pFld          : pFldDesc;        { Field pointer }
      pBuff         : Pointer          { Value buffer }
   ): ALPResult;

function ALPIDEToData (                { Set a formatted value }
      Handle        : ALP_HANDLE;      { Cursor }
      pFld          : pFldDesc;        { Field pointer }
      pBuff         : Pointer          { Value buffer }
   ): ALPResult;



implementation



{============================================================================}
{                            Utilites                                        }
{============================================================================}

procedure _CalcHandleProps (           { Set handle properties           }
      Handle        : ALP_HANDLE       { Cursor                          }
   );
var
 BlockCount  : Integer;
begin
 if( Handle^.iTblType in [ttPARADOX3..ttPARADOX7])then
 begin
  Handle^.mBlocksInBuf := ( Handle^.iBufSize div Handle^.iBlockSize );
  Handle^.mRecsInBlock := ( Handle^.iBlockSize - SizeOf(BLOCK_HDR))div Handle^.iRecSize;
  BlockCount  := ( Handle^.iBufSize div Handle^.iBlockSize );
  Handle^.mRecsInBuf   := ( BlockCount * Handle^.mRecsInBlock );
 end{ if }else
 begin
  Handle^.mBlocksInBuf := 1;
  Handle^.mRecsInBlock := ( Handle^.iBlockSize div Handle^.iRecSize );
  Handle^.mRecsInBuf   := Handle^.mRecsInBlock;
  BlockCount := ( Handle^.iNumRecs div Handle^.mRecsInBlock );
  if( Handle^.iNumRecs > BlockCount * Handle^.mRecsInBlock )then
  inc( BlockCount );
  Handle^.iBlockTotal  := BlockCount;
  Handle^.iBlockFirst  := 1;
  Handle^.iBlockLast   := BlockCount;
  Handle^.iBlockUsed   := BlockCount;
  Handle^.iBlockUsed   := BlockCount;
 end;{ else }
end;{ proc }

procedure _SetFldDataLen (                 { Get a field data length         }
      pFld          : pFldDesc             { Pointer to field structure      }
   );
begin
 pFld^.iDataLen := ALP_FLDSIZES[pFld^.iFldType];
 if( pFld^.iDataLen = 0 )then
 pFld^.iDataLen := pFld^.iPhysLen;
 if( pFld^.iFldType = uftSmallInt )and
   ( pFld^.iSubType = sftByte )then
 begin
  pFld^.iPhysLen := 1;
  pFld^.iDataLen := 2;
 end;
end;{ proc }

procedure _WriteParam (                  { Write param to header }
      Handle        : ALP_HANDLE;        { Cursor }
      Param         : Word               { Param ident }
   );
var
 PrmSize: Integer;
 PrmOffs: Integer;
 PrmBuf : Pointer;
begin
 PrmOffs := -1;
 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 if( Handle^.iTblType in ALP_PDXTYPES )then
 begin
  case( Param )of
  PRM_NUMRECS: begin
    PrmSize := SizeOf(Integer);
    GetMem(PrmBuf, PrmSize);
    Integer(PrmBuf^) := Handle^.iNumRecs;
    PrmOffs := 6;
   end;{ NumRecs }
  PRM_NUMFLDS: begin
    PrmSize := SizeOf(Byte);
    GetMem(PrmBuf, PrmSize);
    Byte(PrmBuf^) := Handle^.iNumFlds;
    PrmOffs := 33;
   end;{ NumRecs }
  PRM_RECSIZE: begin
    PrmSize := SizeOf(Word);
    GetMem(PrmBuf, PrmSize);
    Word(PrmBuf^) := Handle^.iRecSize;
    PrmOffs := 0;
   end;{ NumRecs }
  end;{ case }
 end else
 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 if( Handle^.iTblType in ALP_CLARIONTYPES )then
 begin
  case( Param )of
  PRM_NUMRECS: begin
    PrmSize := SizeOf(Integer);
    GetMem(PrmBuf, PrmSize);
    Integer(PrmBuf^) := Handle^.iNumRecs;
    PrmOffs := 5;
   end;{ NumRecs }
  PRM_NUMDELS: begin
    PrmSize := SizeOf(Integer);
    GetMem(PrmBuf, PrmSize);
    Integer(PrmBuf^) := Handle^.iNumDels;
    PrmOffs := 9;
   end;{ NumRecs }
  PRM_NUMFLDS: begin
    PrmSize := SizeOf(Word);
    GetMem(PrmBuf, PrmSize);
    Word(PrmBuf^) := Handle^.iNumFlds;
    PrmOffs := 13;
   end;{ NumRecs }
  PRM_RECSIZE: begin
    PrmSize := SizeOf(Word);
    GetMem(PrmBuf, PrmSize);
    Word(PrmBuf^) := Handle^.iRecSize;
    PrmOffs := 19;
   end;{ NumRecs }
  end;{ case }
 end else
 if( Handle^.iTblType in ALP_DBASETYPES )then
 begin
  case( Param )of
  PRM_NUMRECS: begin
    PrmSize := SizeOf(Integer);
    GetMem(PrmBuf, PrmSize);
    Integer(PrmBuf^) := Handle^.iNumRecs;
    PrmOffs := 2;
   end;{ NumRecs }
  PRM_RECSIZE: begin
    PrmSize := SizeOf(Word);
    GetMem(PrmBuf, PrmSize);
    Word(PrmBuf^) := Handle^.iRecSize;
    PrmOffs := 8;
   end;{ NumRecs }
  end;{ case }
 end;
 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 if( PrmOffs > -1 )then
 begin
  try
   FileSeek(Handle^.iHandle, PrmOffs, SEEK_FROMBEGIN);
   FileWrite(Handle^.iHandle, PrmBuf^, PrmSize);
  finally
   FreeMem(PrmBuf, PrmSize);
  end;{ fin }
 end;{ if }
end;

procedure _SetRecId (                    { Set current record }
      Handle        : ALP_HANDLE         { Cursor }
   );
var
 TotalRecs   : Integer;
 RecsInBlock : Integer;
 BlockOffs   : Integer;
 BlockCount  : Integer;
begin
 if( Handle^.iTblType in [ttPARADOX3..ttPARADOX7])then
 begin
  RecsInBlock := ((Handle^.iBlockSize - SizeOf(BLOCK_HDR))div Handle^.iRecSize );
  BlockCount  := ((Handle^.iRecPos - Handle^.iOffsData )div Handle^.iBlockSize );
  TotalRecs   := ( RecsInBlock * BlockCount );
  BlockOffs   := ( Handle^.iOffsData + ( Handle^.iBlockSize * BlockCount ));
  Handle^.iRecId := ((Handle^.iRecPos - BlockOffs - SizeOf(BLOCK_HDR))div Handle^.iRecSize + TotalRecs + 1 );
 end{ if }else
 begin
  Handle^.iRecId := ( Handle^.iRecPos - Handle^.iOffsData )div Handle^.iRecSize + 1;
 end;{ else }
end;{ proc }

function _GetFieldType (                  { Get a field type }
      Handle        : ALP_HANDLE;         { Handle of Table  }
      FldType       : Byte;               { Original field type }
      FldSize       : Word;               { Original field size }
      FldDec        : Byte                { Original field dec }
   ): ALP_FLDTYPE;
begin
  case( Handle^.iTBLTYPE )of
  //~~ dbase types ~~~~~~~~~~~~~~~~~~~~~
  ttDBASE3..ttDBASE7,
  ttFOXPRO1..ttFOXPRO4:
    case( FldType )of
    FLD_DB_STRING  : Result := uftString;
    FLD_DB_DATE    : Result := uftDate;
    FLD_DB_BOOLEAN : Result := uftBoolean;
    FLD_DB_MEMO    : Result := uftMemo;
    FLD_DB_NUMBER, FLD_DB_FLOAT:
     case( FldSize )of
     06: if( FldDec = 0 )then
         Result := uftSmallint else
         Result := uftFloat;
     11: if( FldDec = 0 )then
         Result := uftInteger else
         Result := uftFloat;
     else
      Result := uftFloat;
     end;{ case }
    end;{ case }
  //~~ clarion types ~~~~~~~~~~~~~~~~~~~~~
  ttCLARION1..ttCLARION2:
    case( FldType )of
    FLD_CL_LONG     : Result := uftInteger;
    FLD_CL_REAL     : Result := uftFloat;
    FLD_CL_STRING   : Result := uftString;
    FLD_CL_PICTURE  : Result := uftGraphic;
    FLD_CL_BYTE     : Result := uftSmallint;
    FLD_CL_SHORT    : Result := uftSmallInt;
    FLD_CL_GROUP    : Result := uftArray;
    FLD_CL_DECIMAL  : Result := uftFloat;
    end;{ case }
  //~~ paradox types ~~~~~~~~~~~~~~~~~~~~~
  ttPARADOX3..ttPARADOX7:
    case( FldType )of
    FLD_PD_ALPHA    : Result := uftString;
    FLD_PD_DATE     : Result := uftDate;
    FLD_PD_INT16    : Result := uftSmallint;
    FLD_PD_INT32    : Result := uftInteger;
    FLD_PD_MONEY    : Result := uftCurrency;
    FLD_PD_NUMBER   : Result := uftFloat;
    FLD_PD_LOGICAL  : Result := uftBoolean;
    FLD_PD_MEMO     : Result := uftMemo;
    FLD_PD_BINARY   : Result := uftBlob;
    FLD_PD_FMEMO    : Result := uftFmtMemo;
    FLD_PD_OLE      : Result := uftParadoxOle;
    FLD_PD_GRAPHIC  : Result := uftGraphic;
    FLD_PD_TIME     : Result := uftTime;
    FLD_PD_TIMESTAMP: Result := uftDateTime;
    FLD_PD_AUTOINC  : Result := uftAutoInc;
    FLD_PD_BCD      : Result := uftBCD;
    FLD_PD_BYTES    : Result := uftBytes;
    end;{ case }
  end;{ case }
end;

function _IsBOF (                        { Get begin flag }
      Handle        : ALP_HANDLE         { Handle of Table  }
   ): Boolean;
begin
 Result := ( Handle^.iRecId < 1 );
end;{ func }

function _IsEOF (                        { Get end flag }
      Handle        : ALP_HANDLE         { Handle of Table  }
   ): Boolean;
begin
  Result := ( Handle^.iRecId > Handle^.iNumRecs );
end;{ func }

function _IsBlank (                      { Analize field value }
      Handle        : ALP_HANDLE;        { Cursor }
      pFld          : pFldDesc;          { Field pointer }
      pBuff         : Pointer            { Value buffer }
   ): Boolean;
var
 I       : Integer;
 pPos    : pByte;
 EmpChar : Byte;
begin
 case( Handle^.iTblType )of
 ttDBASE3..ttDBASE7,
 ttFOXPRO1..ttFOXPRO4:
  EmpChar := EMPCHAR_DBASE;
 ttCLARION1..ttCLARION2,
 ttPARADOX3..ttPARADOX7:
  EmpChar := EMPCHAR_CLARION;
 end;{ case }

 pPos   := pBuff;
 Result := True;
 for I := 1 to pFld^.iPhysLen do
 begin
  if( pPos^ <> EmpChar )then
  begin
   Result := False;
   Break;
  end;{ if }
  inc(pPos);
 end;{ for }
end;{ func }


procedure _SetBuffer (                  { Set buffer }
      Handle        : ALP_HANDLE        { Cursor }
   );
var
 I           : Integer;
 pPos1       : pBYTE;
 pPos2       : pBYTE;
 pBlHdr      : pBLOCK_HDR;
 RecsInBlock : Integer;
begin
 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 pPos1  := Handle^.BUFFER.pIntBuf;
 pPos2  := Handle^.BUFFER.pMainBuf;
 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Handle^.BUFFER.BufferPos := Handle^.iBlockPos;
 Handle^.iBlockCurr := (Handle^.iBlockPos - Handle^.iOffsData )div Handle^.iBlockSize + 1;
 Handle^.BUFFER.ReadRecs  := 0;
 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 if( Handle^.iTblType in ALP_PDXTYPES )then
 begin
  pBlHdr := Handle^.BUFFER.pINTBUF;
  inc(pPos1, SizeOf(BLOCK_HDR));
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.iBlockNext := pBlHdr^.NumNext;
  Handle^.iBlockPred := pBlHdr^.NumPrev;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if( pBlHdr^.OffsLast < 0 )then
  RecsInBlock := 0 else
  RecsInBlock := (( pBlHdr^.OffsLast + Handle^.iRecSize) div Handle^.iRecSize );
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  _Move(pPos1, pPos2, RecsInBlock * Handle^.iRecSize);
  inc( Handle^.BUFFER.ReadRecs, RecsInBlock );
 end else
 begin
  Handle^.iBlockNext := Handle^.iBlockCurr + 1;
  Handle^.iBlockPred := Handle^.iBlockCurr - 1;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  RecsInBlock := Handle^.iReadBytes div Handle^.iRecSize;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  _Move(pPos1, pPos2, RecsInBlock * Handle^.iRecSize);
  inc( Handle^.BUFFER.ReadRecs, RecsInBlock );
 end;{ else }
 Handle^.BUFFER.First;
end;{ func }

function _GetBlockPos (                  { Get block position       }
      Handle        : ALP_HANDLE;        { Handle of Table          }
      BlockId       : Integer            { Block number             }
   ): Integer;
begin
 if( Handle^.iTblType in ALP_PDXTYPES)then
 begin
  Result := Handle^.iOffsData + (BlockId - 1) * Handle^.iBlockSize;
 end{ if }else
 begin
  Result := Handle^.iOffsData + (BlockId - 1) * Handle^.iBlockSize;
 end;{ else }
end;{ func }

function _ReadBlockHdr (                 { Write block hdr          }
      Handle        : ALP_HANDLE;        { Cursor                   }
      BlockId       : Integer;           { Block ident              }
      pBlHdr        : pBLOCK_HDR         { Header descriptor        }
   ): ALPRESULT;
var
 E     : Integer;
 BlPos : Integer;
begin
 if( BlockId >= 1 )and( BlockId <= Handle^.iBlockLast )then
 begin
  BlPos := _GetBlockPos( Handle, BlockId );
  E := FileSeek(Handle^.iHandle, BlPos, SEEK_FROMBEGIN);
  if( E = -1 )then Result := ERR_CANNOTSEEK else
  begin
   E := FileRead(Handle^.iHandle, pBlHdr^, SizeOf(BLOCK_HDR));
   if( E = -1 )then Result := ERR_CANNOTREADFILE else
   Result := ERR_NONE;
  end;{ if }
 end;{ if }
end;

function _WriteBlockHdr (                { Write block hdr          }
      Handle        : ALP_HANDLE;        { Cursor                   }
      BlockId       : Integer;           { Block ident              }
      pBlHdr        : pBLOCK_HDR         { Header descriptor        }
   ): ALPRESULT;
var
 E     : Integer;
 BlPos : Integer;
begin
 if( BlockId >= 1 )and( BlockId <= Handle^.iBlockLast )then
 begin
  BlPos := _GetBlockPos( Handle, BlockId );
  E := FileSeek(Handle^.iHandle, BlPos, SEEK_FROMBEGIN);
  if( E = -1 )then Result := ERR_CANNOTSEEK else
  begin
   E := FileWrite(Handle^.iHandle, pBlHdr^, SizeOf(BLOCK_HDR));
   if( E = -1 )then Result := ERR_CANNOTWRITEFILE else
   Result := ERR_NONE;
  end;{ if }
 end;{ if }
end;


{===========================================================================}
{ BUFFER FUNCTIONS & PROCEDURES                                             }
{===========================================================================}

{ IBuffer }

constructor IBuffer.Create(Owner: ALP_HANDLE);
begin
 BufferSize  := Owner^.iBufSize;
 RecordId    := 1;
 RecordSize  := Owner^.iRecSize;
 ReadRecs    := 0;
 Capacity    := BufferSize div RecordSize;
 if( Owner^.iTblType in ALP_PDXTYPES )then
 RecordOffs  := SizeOf(BLOCK_HDR)else
 RecordOffs  := 0;
 //~~~~~~~~~~~~~~~~~~~~~~
 pMainBuf    := AllocMem(BufferSize);
 pIntBuf     := AllocMem(BufferSize);
 pCursor     := pMainBuf;
 //~~~~~~~~~~~~~~~~~~~~~~
 pHandle     := Owner;
end;

destructor IBuffer.Destroy;
begin
 FreeMem(pMainBuf, BufferSize);
 FreeMem(pIntBuf, BufferSize);
end;

function IBuffer.First: Boolean;
begin
 RecordId := 1;
 pCursor  := pMainBuf;
 Result   := True;
end;

function IBuffer.Last: Boolean;
begin
 RecordId := ReadRecs;
 Longint(pCursor) := Longint(pMainBuf) + (ReadRecs - 1)* RecordSize;
 Result   := True;
end;

function IBuffer.IsBOF: Boolean;
begin
 Result := ( RecordId <= 1 )or( ReadRecs = 0 );
end;

function IBuffer.IsEOF: Boolean;
begin
 Result := ( RecordId >= ReadRecs )or( ReadRecs = 0 );
end;

function IBuffer.Next: Boolean;
begin
 Result := not( IsEOF );
 if( Result )then
 begin
  inc( RecordId );
  Longint(pCursor) := Longint(pMainBuf) + (RecordId - 1)* RecordSize;
 end;{ if }
end;

function IBuffer.Prior: Boolean;
begin
 Result := not( IsBOF );
 if( Result )then
 begin
  dec( RecordId );
  Longint(pCursor) := Longint(pMainBuf) + (RecordId - 1)* RecordSize;
 end;{ if }
end;

procedure IBuffer.Clear;
begin
 RecordId := 0;
 ReadRecs := 0;
end;

procedure IBuffer.Delete;
var
 pPos1 : pBYTE;
 pPos2 : pBYTE;
 pBlock: pBLOCK_HDR;
begin
 if( ReadRecs > 0 )then
 begin
  pPos1 := pCursor;
  if( pHandle^.iTblType in ALP_PDXTYPES )then
  begin
   pBlock := pIntBuf;
   if( RecordId < ReadRecs )then
   begin
    { move main buffer }
    pPos2 := pCursor;
    inc(pPos2, pHandle^.iRecSize);
    _Move(pPos2, pPos1, (ReadRecs - RecordId)* pHandle^.iRecSize);
    { move internal buffer }
    pPos1  := pIntBuf;
    inc(pPos1, SizeOf(BLOCK_HDR)+ (RecordId - 1)*pHandle^.iRecSize);
    pPos2 := pPos1;
    inc(pPos2, pHandle^.iRecSize);
    _Move(pPos2, pPos1, (ReadRecs - RecordId)* pHandle^.iRecSize);
   end{ if }else
   RecordId := ReadRecs - 1;
   { calc block hdr }
   dec(pBlock^.OffsLast, pHandle^.iRecSize);
   dec(ReadRecs);
  end{ if }else
  begin
   if( pHandle^.iTblType in ALP_CLARIONTYPES )then
   pPos1^ := DELFLAG_CLARION else
   if( pHandle^.iTblType in ALP_DBASETYPES )then
   pPos1^ := DELFLAG_DBASE;
  end;
 end;{ if }
end;

function IBuffer.SetToRec(RecId: Integer): Boolean;
begin
 Result := ( RecId >= 1 )and( RecId <= ReadRecs );
 if( Result )then
 begin
  RecordId := RecId;
  Longint(pCursor) := Longint(pMainBuf) + (RecordId - 1)* RecordSize;
 end;{ if }
end;

function IBuffer.Locate(RecPos: Integer): Boolean;
begin
 if( PHandle^.iTblType in ALP_PDXTYPES )then
  Result := ( RecPos >= BufferPos + SizeOf(BLOCK_HDR))and
            ( RecPos <= BufferPos + SizeOf(BLOCK_HDR) + (ReadRecs - 1)* PHandle^.iRecSize )
 else
  Result := ( RecPos >= BufferPos )and( RecPos <= BufferPos + (ReadRecs - 1)* PHandle^.iRecSize );

 if( Result )then
 begin
  RecordId := (RecPos - BufferPos - RecordOffs)div RecordSize + 1;
  Longint(pCursor) := Longint(pMainBuf) + (RecordId - 1)* RecordSize;
 end;{ if }
end;

function IBuffer.GetRecPos: Integer;
begin
 Result := BufferPos + RecordOffs + (RecordId - 1) * RecordSize;
end;

function IBuffer.IsEMPTY: Boolean;
begin
 Result := ReadRecs = 0;
end;







{===========================================================================}
{                      Table Open, Properties & Structure                   }
{===========================================================================}

function ALPOpenTable (                { Open a table }
      FileName      : string;           { Table name or file name }
      bReadOnly     : boolean;          { Read or RW }
      bExclusive    : boolean;          { Excl or Share }
var   Handle        : ALP_HANDLE       { Returns Cursor handle }
   ): ALPResult;
const
 //(('FF','FT'),('TF','TT'));
 OpenArray: array[boolean, boolean]of Integer =
            ((fmOpenReadWrite or fmShareDenyNone,
              fmOpenReadWrite or fmShareExclusive),
             (fmOpenRead or fmShareDenyNone,
              fmOpenRead or fmShareExclusive));
label
 LB_UNSUPPORT;
var
 I, E, F   : Integer;
 X         : ALP_TBLTYPE;
 Found     : Boolean;
 OpenMode  : Integer;
 { DBASE }
 H_DBASE   : HDR_DBASE;
 pFDB3     : pFLD_DBASE3;
 pFDB5     : pFLD_DBASE5;
 { CLARION }
 H_CLR     : HDR_CLARION;
 pFCLR     : pFLD_CLARION;
 pKCLR     : pKEY_CLARION;
 pKICLR    : pKEYITEM_CLARION;
 pPCLR     : pPICT_CLARION;
 pACLR     : pARR_CLARION;
 pAICLR    : pARRITEM_CLARION;
 { PARADOX }
 H_PDX     : HDR_PARADOX;
 pFPDX     : pFLD_PARADOX;
 { EJM }
 H_EJM     : HDR_EJM;
 pFEJM     : pFLD_EJM;

 FldOffs   : Word;

 pFLD      : pFLDDesc;
 pPOS      : pBYTE;
 pSTEP     : pBYTE;
begin
 Result := ERR_NONE;
 if( Handle <> nil )then  { Check valid handle }
 Result := ERR_INVALIDHANDLE else
 begin
  OpenMode := OpenArray[bReadOnly, bExclusive];
  { Open file }
  E := FileOpen(FileName, OpenMode);
  if( E = -1 )then Result := ERR_CANNOTOPENFILE else
  begin
   Handle := AllocMem(SizeOf(_HANDLE));
   Handle^.iHANDLE := E;
   { Set to begin of file }
   E := FileSeek(Handle^.iHANDLE, 0, SEEK_FROMBEGIN);
   if( E = -1 )then
   begin
    Result := ERR_CANNOTSEEK;
    FileClose(Handle^.iHANDLE);
    FreeMem(Handle, SizeOf(_HANDLE));
    Handle := nil;
   end else begin
    { Get mem for header }
    Handle^.pHEADER   := AllocMem(MAX_HEADERBUFSIZE);
    Handle^.iMarkSize := SizeOf(IBookMark);
    Handle^.iFilePos  := E;
    E := FileRead(Handle^.iHANDLE, Handle^.pHEADER^, MAX_HEADERBUFSIZE);
    if( E = -1 )then
    begin
     Result := ERR_CANNOTREADFILE;
     FileClose(Handle^.iHANDLE);
     FreeMem(Handle^.pHEADER, MAX_HEADERBUFSIZE);
     FreeMem(Handle, SizeOf(_HANDLE));
     Handle := nil;
    end else begin
     inc(Handle^.iFilePos, E);
     Handle^.iHdrReadBytes := E;
     { GETTING FILE FORMAT }
     pPOS := Handle^.pHEADER;
     for X := Low(ALP_TBLTYPE)to High(ALP_TBLTYPE)do
     begin
      Found := False;
      for F := 0 to TBLIDENT[X].iCount - 1 do
      begin
       pPOS := Handle^.pHEADER;
       inc(pPOS, TBLIDENT[X].iIdent[F].iOffs);
       Found := (pPOS^ in TBLIDENT[X].iIdent[F].iVals);
       if( not Found )then Break;
      end;{ for }
      if( Found )then
      begin
       Handle^.iTBLTYPE := X;
       StrPCopy(Handle^.iTBLDESC, TBLIDENT[X].iName);
       Break;
      end;{ if }
     end;{ for }

     { UNKNOWN FILE FORMAT }
     if( Handle^.iTBLTYPE = ttUNKNOWN )then
     begin
      Result := ERR_UNSUPPORTEDFILE;
      FileClose(Handle^.iHANDLE);
      FreeMem(Handle^.pHEADER, MAX_HEADERBUFSIZE);
      FreeMem(Handle, SizeOf(_HANDLE));
      Handle := nil;
     end else
     begin
      { LOAD DESCRIPTORS }
      case( Handle^.iTBLTYPE )of


      ttDBASE3..ttDBASE7:
       begin
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        _Move(Handle^.pHEADER, @H_DBASE, SizeOf(HDR_DBASE));
        Handle^.iHdrSize    := H_DBASE.HdrLen;
        Handle^.iRecSize    := H_DBASE.recLen;
        Handle^.iDataSize   := H_DBASE.recLen - SizeOf(FLDHDR_DBASE);
        Handle^.iFldHdrSize := SizeOf(FLDHDR_DBASE);
        Handle^.iNumRecs    := H_DBASE.numRecs;
        Handle^.iOffsData   := H_DBASE.HdrLen;
        Handle^.iBufSize    := ( MAX_BUFFERSIZE div Handle^.iRecSize ) * Handle^.iRecSize;
        Handle^.iBlockSize  := Handle^.iBufSize;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        pPOS := Handle^.pHEADER;
        inc(pPOS, SizeOf(HDR_DBASE));
        case( Handle^.iTBLTYPE )of
        ttDBASE3..ttDBASE4:
         begin
          pFDB3 := pFLD_DBASE3(pPOS);
         end;{ ttDBASE3 }
        ttDBASE5..ttDBASE7:
         begin
          inc(pPOS, SizeOf(HDR_DBASEADD));
          pFDB5 := pFLD_DBASE5(pPOS);
         end;{ ttDBASE4 }
        end;{ case }
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        E := 0;
        while( Char(pPOS^)<> #$0D )do
        begin
         inc(Handle^.iNumFlds);
         ReallocMem(Handle^.pFIELDS, SizeOf(FLDDesc) * Handle^.iNumFlds);
         pFLD := Handle^.pFIELDS;
         inc(pFLD, Handle^.iNumFlds - 1);
         { read field properties }
         pFLD^.iFldNum := Handle^.iNumFlds;
         case( Handle^.iTBLTYPE )of
         ttDBASE3..ttDBASE4:
           begin
            StrPCopy(pFLD^.szName, pFDB3^.FldName);
            pFLD^.iFldType := _GetFieldType(Handle, pFDB3^.FldType, pFDB3^.FldSize, pFDB3^.FldDec);
            pFLD^.iFldSize := pFDB3^.FldSize;
            pFLD^.iFldDec  := pFDB3^.FldDec;
            pFLD^.iPhysLen := pFDB3^.FldSize;
            pFLD^.iOffset  := E;
            _SetFldDataLen( pFLD );
            inc(E, pFLD^.iPhysLen);
            { update pos }
            inc(pFDB3);
            pPOS := pBYTE(pFDB3);
           end;{ ttDBASE3 }
         ttDBASE5..ttDBASE7:
           begin
            StrPCopy(pFLD^.szName, pFDB5^.FldName);
            pFLD^.iFldType := _GetFieldType(Handle, pFDB5^.FldType, pFDB3^.FldSize, pFDB3^.FldDec);
            pFLD^.iFldSize := pFDB5^.FldSize;
            pFLD^.iFldDec  := pFDB5^.FldDec;
            pFLD^.iPhysLen := pFDB5^.FldSize;
            pFLD^.iOffset  := E;
            _SetFldDataLen( pFLD );
            inc(E, pFLD^.iPhysLen);
            { update pos }
            inc(pFDB5);
            pPOS := pBYTE(pFDB5);
           end;{ ttDBASE4 }
         end;{ case }
        end;{ while }
       end;{ ttDBASE3..ttDBASE7 }


      ttCLARION1..ttCLARION2:
       begin
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        _Move(Handle^.pHEADER, @H_CLR, SizeOf(HDR_CLARION));
        Handle^.iNumFlds    := H_CLR.NumFlds;
        Handle^.iRecSize    := H_CLR.RecLen;
        Handle^.iFldHdrSize := SizeOf(FLDHDR_CLARION);
        Handle^.iDataSize   := H_CLR.RecLen - SizeOf(FLDHDR_CLARION);
        Handle^.iNumRecs    := H_CLR.NumRecs;
        Handle^.iNumDels    := H_CLR.NumDels;
        Handle^.iBufSize    := ( MAX_BUFFERSIZE div Handle^.iRecSize ) * Handle^.iRecSize;
        Handle^.iBlockSize  := Handle^.iBufSize;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        pPOS := Handle^.pHEADER;
        inc(pPOS, SizeOf(HDR_CLARION));
        Handle^.pFIELDS := AllocMem(SizeOf(FLDDesc) * Handle^.iNumFlds);
        pFLD  := Handle^.pFIELDS;
        E     := Length(H_CLR.FilPrefx) + 2;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        { Read fields }
        for I := 1 to H_CLR.NumFlds do
        begin
         pFCLR := pFLD_CLARION(pPOS);
         pFLD^.iFldNum  := I;
         StrPCopy(pFLD^.szName, Trim(Copy(pFCLR^.FldName, E, Length(pFCLR^.FldName) - E)));
         pFLD^.iFldType := _GetFieldType(Handle, pFCLR^.FldType, pFCLR^.DecSig, pFCLR^.DecDec);
         pFLD^.iFldSize := pFCLR^.Length;
         pFLD^.iFldSig  := pFCLR^.DecSig;
         pFLD^.iFldDec  := pFCLR^.DecDec;
         pFLD^.iPhysLen := pFCLR^.Length;
         pFLD^.iOffset  := pFCLR^.FOffset;
         if( pFld^.iFldType = uftInteger )and
           ( Pos('DATE', UpperCase(pFld^.szName)) > 0 )then
         pFld^.iFldType := uftDate;
         { set subtype }
         if( pFCLR^.FldType = FLD_CL_DECIMAL )then
         pFLD^.iSubType := sftBCD else
         if( pFCLR^.FldType = FLD_CL_BYTE )then
         pFLD^.iSubType := sftBYTE;
         _SetFldDataLen( pFLD );
         inc(pPOS, SizeOf(FLD_CLARION));
         inc(pFLD);
        end;{ for }
        //------------------
        { Read keys }
        for I := 1 to H_CLR.NumKeys do
        begin
         pKCLR := pKEY_CLARION(pPOS);
         for F := 1 to pKCLR^.NumComps do
         begin
          inc(pPOS, SizeOf(KEYITEM_CLARION));
         end;{ for }
         inc(pPOS, SizeOf(KEY_CLARION));
        end;{ for }
        //------------------
        { Read pictures }
        for I := 1 to H_CLR.NumPics do
        begin
         pPCLR := pPICT_CLARION(pPOS);
         inc(pPOS, SizeOf(PICT_CLARION));
        end;{ for }
        //------------------
        { Read arrays }
        for I := 1 to H_CLR.NumArrs do
        begin
         pACLR := pARR_CLARION(pPOS);
         for F := 1 to pACLR^.TotDim do
         begin
          inc(pPOS, SizeOf(ARRITEM_CLARION))
         end;{ for }
         inc(pPOS, SizeOf(ARR_CLARION));
        end;{ for }
        Handle^.iOffsData := Longint(pPOS) - Longint(Handle^.pHEADER);
       end;{ ttCLARION1..ttCLARION2 }


      ttPARADOX3..ttPARADOX7:
       begin
        _Move(Handle^.pHEADER, @H_PDX, SizeOf(HDR_PARADOX));
        Handle^.iHdrSize    := H_PDX.HdrLen;
        Handle^.iNumFlds    := H_PDX.NumFlds;
        Handle^.iRecSize    := H_PDX.RecLen;
        Handle^.iFldHdrSize := 0;
        Handle^.iDataSize   := H_PDX.RecLen;
        Handle^.iNumRecs    := H_PDX.NumRecs;
        Handle^.iNumDels    := 0;
        Handle^.iAutoInc    := H_PDX.AutoInc;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Handle^.iBlockFirst := H_PDX.BlFirst;
        Handle^.iBlockLast  := H_PDX.BlLast;
        Handle^.iBlockUsed  := H_PDX.NumBlUsed;
        Handle^.iBlockTotal := H_PDX.NumBlTotal;
        Handle^.iBlockSize  := H_PDX.BlockSize * 1024;
        Handle^.iBufSize    := Handle^.iBlockSize;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Handle^.iOffsData   := H_PDX.HdrLen;
        { Calc field descs offset }
        case( Handle^.iTblType )of
        ttPARADOX3:
          begin
           Handle^.iOffsNames := 177 + ((Handle^.iNumFlds - 1) * 6);
           FldOffs := 88;
          end;
        ttPARADOX4..ttPARADOX5:
          begin
           Handle^.iOffsNames := 209 + ((Handle^.iNumFlds - 1) * 6);
           FldOffs := 120;
          end;
        ttPARADOX7:
          begin
           Handle^.iOffsNames := 391 + ((Handle^.iNumFlds - 1) * 6);
           FldOffs := 120;
          end;
        end;{ case }

        Handle^.pFIELDS := AllocMem(SizeOf(FLDDesc) * Handle^.iNumFlds);
        pFLD  := Handle^.pFIELDS;
        pPos  := Handle^.pHEADER;
        inc(pPos, FldOffs);
        pFPDX := pFLD_PARADOX(pPos);
        pPos  := Handle^.pHEADER;
        inc(pPos,  Handle^.iOffsNames);
        E := 0;
        { Read fields }
        for I := 1 to H_PDX.NumFlds do
        begin
         pFLD^.iFldNum := I;
         StrCopy(pFLD^.szName, PChar(pPos));
         pFLD^.iFldType := _GetFieldType(Handle, pFPDX^.FldType, pFPDX^.FldSize, 0);
         pFLD^.iFldSize := pFPDX^.FldSize;
         pFLD^.iPhysLen := pFPDX^.FldSize;
         pFLD^.iDataLen := pFPDX^.FldSize;
         pFLD^.iOffset  := E;
         inc(pPos, StrLen(pFLD^.szName) + 1);
         inc(E, pFLD^.iDataLen);
         inc(pFPDX);
         inc(pFLD);
        end;{ for }
       end;{ Paradox }


      ttEJM:
       begin
        _Move(Handle^.pHEADER, @H_EJM, SizeOf(HDR_EJM));
        Handle^.iHdrSize    := H_EJM.HdrLen;
        Handle^.iNumFlds    := H_EJM.NumFlds;
        Handle^.iRecSize    := H_EJM.RecLen;
        Handle^.iFldHdrSize := SizeOf(IFLD_EJM_STATE);
        Handle^.iDataSize   := H_EJM.RecLen - Handle^.iFldHdrSize;
        Handle^.iNumRecs    := H_EJM.NumRecs;
        Handle^.iNumDels    := H_EJM.NumDels;
        Handle^.iAutoInc    := H_EJM.AutoInc;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Handle^.iBufSize    := ( MAX_BUFFERSIZE div Handle^.iRecSize ) * Handle^.iRecSize;
        Handle^.iBlockSize  := Handle^.iBufSize;
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Handle^.iOffsNames  := SizeOf(H_EJM) + (Handle^.iNumFlds * SizeOf(FLD_EJM));
        Handle^.iOffsData   := H_EJM.HdrLen;
        FldOffs := SizeOf(H_EJM);

        Handle^.pFIELDS := AllocMem(SizeOf(FLDDesc) * Handle^.iNumFlds);
        pFLD  := Handle^.pFIELDS;
        pPos  := Handle^.pHEADER;
        inc(pPos, FldOffs);
        pFEJM := pFLD_EJM(pPos);
        pPos  := Handle^.pHEADER;
        inc(pPos,  Handle^.iOffsNames);
        E := 0;
        { Read fields }
        for I := 1 to H_EJM.NumFlds do
        begin
         pFLD^.iFldNum := I;
         StrCopy(pFLD^.szName, PChar(pPos));
         pFLD^.iFldType := ALP_FLDTYPE(pFEJM^.FldType);
         pFLD^.iFldSize := pFEJM^.FldSize;
         pFLD^.iFldDec  := pFEJM^.FldDec;
         pFLD^.iPhysLen := pFEJM^.FldSize;
         pFLD^.iDataLen := pFEJM^.FldSize;
         pFLD^.iOffset  := E;
         inc(pPos, StrLen(pFLD^.szName) + 1);
         inc(E, pFLD^.iDataLen);
         inc(pFEJM);
         inc(pFLD);
        end;{ for }
       end;{ EJM }

      end;{ case }
      { Create Buffer }
      Handle^.BUFFER   := IBuffer.Create(Handle);
      { Set record position }
      Handle^.iRecPos   := Handle^.iOffsData;
      Handle^.iBlockPos := Handle^.iOffsData;
      { Set handle properties }
      _CalcHandleProps( Handle );
     end;{ if }
    end;{ if }
   end;{ if }
  end;{ if }
 end;{ if }
end;{ func }

function ALPCloseTable (               { Closes cursor }
      Handle        : ALP_HANDLE       { Pntr to Cursor handle }
   ): ALPResult;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
  Result := ERR_INVALIDHANDLE else
 begin
  if( Handle^.pFIELDS <> nil )then FreeMem(Handle^.pFIELDS, SizeOf(FLDDESC) * Handle^.iNumFlds);
  if( Handle^.pHEADER <> nil )then FreeMem(Handle^.pHEADER, MAX_HEADERBUFSIZE);
  Handle^.BUFFER.Free;
  FileClose( Handle^.iHandle );
  FreeMem(Handle, SizeOf(_HANDLE));
  TObject(Handle) := nil;
 end;
end;{ func }

function ALPTableCreate (              { Create a table        }
      pTblDesc      : pCRTblDesc;      { Table descriptor      }
      bOpen         : boolean;         { Open after create     }
var   Handle        : ALP_HANDLE       { Returns Cursor handle }
   ): ALPResult;
var
  E, I, F   : Integer;
  H         : Integer;
  Path      : string;
  FileName  : string;
  pFld      : pFldDesc;
  { EJM }
  IHDR_EJM  : HDR_EJM;
  IFLD_EJM  : FLD_EJM;
  IFLD_NAME : Char64;
  HdrLen    : Integer;
  RecLen    : Integer;
  NameLen   : Word;
begin
  Result := ERR_NONE;
  if( pTblDesc = nil )then  { Check valid descriptor }
  Result := ERR_INVALIDCRDESC else
  begin
   { create }
   case( pTblDesc^.iTblType )of
   ttEJM:
     begin
      HdrLen   := SizeOf(HDR_EJM);
      Path     := StrPas(pTblDesc^.szDbName);
      FileName := ChangeFileExt(StrPas(pTblDesc^.szTblName), '.EJM');
      { fill header }
      FillChar(IHDR_EJM, SizeOf(HDR_EJM), 0);
      IHDR_EJM.Ident   := EJM_TBLIDENT;
      IHDR_EJM.Version := 1;
      IHDR_EJM.NumFlds := pTblDesc^.iFldCount;
      { create stream }
      H := FileCreate(Path + FileName);
      if( H = -1 )then Result := ERR_INVALIDFILENAME else
      begin
       FileSeek(H, 0, SEEK_FROMBEGIN);
       E := FileWrite(H, IHDR_EJM, SizeOf(HDR_EJM));
       if( E = -1 )then Result := ERR_CANNOTWRITEFILE else
       begin
        RecLen := 0;
        { write field descs }
        pFld := pTblDesc^.pFldDesc;
        for I := 0 to pTblDesc^.iFldCount - 1 do
        begin
         IFLD_EJM.FldType := Ord(pFld^.iFldType);
         IFLD_EJM.FldSize := ALP_FLDSIZES[ALP_FLDTYPE(pFld^.iFldType)] + pFld^.iFldSize;
         IFLD_EJM.FldDec  := pFld^.iFldDec;
         E := FileWrite(H, IFLD_EJM, SizeOf(FLD_EJM));
         if( E = -1 )then
         begin
          Result := ERR_CANNOTWRITEFILE;
          Break;
         end;
         inc(pFld);
         inc(RecLen, IFLD_EJM.FldSize);
         inc(HdrLen, SizeOf(FLD_EJM));
        end;{ for }
        { write field names }
        if( Result = ERR_NONE )then
        begin
         pFld := pTblDesc^.pFldDesc;
         for I := 0 to pTblDesc^.iFldCount - 1 do
         begin
          StrCopy(IFLD_NAME, pFld^.szName);
          E := FileWrite(H, IFLD_NAME, StrLen(IFLD_NAME) + 1);
          if( E = -1 )then
          begin
           Result := ERR_CANNOTWRITEFILE;
           Break;
          end;
          inc(pFld);
          inc(HdrLen, StrLen(IFLD_NAME) + 1);
         end;{ for }
        end;
        { write header length }
        E := FileSeek(H, 5, SEEK_FROMBEGIN);
        if( E = -1 )then Result := ERR_CANNOTSEEK else
        begin
         E := FileWrite(H, HdrLen, SizeOf(Word));
         if( E = -1 )then Result := ERR_CANNOTWRITEFILE;
        end;
        { write record length }
        E := FileSeek(H, 9, SEEK_FROMBEGIN);
        if( E = -1 )then Result := ERR_CANNOTSEEK else
        begin
         E := FileWrite(H, RecLen, SizeOf(Integer));
         if( E = -1 )then Result := ERR_CANNOTWRITEFILE;
        end;
       end;
       FileClose(H);
      end;
     end;{ ttEJM }
   end;{ case }
  end;
end;

function ALPGetFieldDescs (            { Get field descriptions }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pFldDesc      : pFLDDesc          { Array of field descriptors }
   ): ALPResult;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  _Move(Handle^.pFIELDS, pFLDDesc, SizeOf(FLDDESC)* Handle^.iNumFlds);
 end;
end;{ func }

{=============================================================================}
{                              Cursor Maintenance                             }
{=============================================================================}

function ALPSetToBegin (               { Reset cursor to beginning }
      Handle        : ALP_HANDLE       { Cursor handle }
   ): ALPResult;
var
 E      : Integer;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.iBlockPred := 0;
  Handle^.iBlockNext := Handle^.iBlockFirst;
  Handle^.iBlockCurr := Handle^.iBlockFirst - 1;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.BUFFER.Clear;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 end;{ if }
end;{ func }

function ALPSetToEnd (                 { Reset cursor to ending }
      Handle        : ALP_HANDLE       { Cursor handle }
   ): ALPResult;
var
 E     : Integer;
 Pos   : Integer;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.iBlockNext := 0;
  Handle^.iBlockPred := Handle^.iBlockLast;
  Handle^.iBlockCurr := Handle^.iBlockLast + 1;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.BUFFER.Clear;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 end;{ if }
end;{ func }

function ALPGetBookMark (              { Get a book-mark }
      Handle        : ALP_HANDLE;      { Cursor }
      pBkMark       : Pointer           { Pointer to Book-Mark }
   ): ALPResult;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  pBookmark( pBkMark )^ := Handle^.BUFFER.RecPos;
 end;{ if }
end;{ func }

function ALPSetToBookMark (             { Position to a Book-Mark }
      Handle        : ALP_HANDLE;       { Cursor }
      pBkMark       : Pointer           { Pointer to Book-Mark }
   ): ALPResult;
var
 E           : Integer;
 NewPos      : Integer;
 BlockId     : Integer;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.iRecPos := pBookmark(pBkMark)^;
  if not( Handle^.BUFFER.Locate(Handle^.iRecPos))then
  begin
   BlockId := (Handle^.iRecPos - Handle^.iOffsData)div Handle^.iBlockSize + 1;
   Handle^.iBlockPos  := _GetBlockPos(Handle, BlockId);
   Handle^.iBlockCurr := BlockId;
   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   E := FileSeek(Handle^.iHANDLE, Handle^.iBlockPos, SEEK_FROMBEGIN);
   if( E = -1 )then Result := ERR_CANNOTSEEK else
   begin
    E := FileRead(Handle^.iHANDLE, Handle^.BUFFER.pIntBuf^, Handle^.iBufSize);
    if( E = -1 )then Result := ERR_CANNOTREADFILE else
    begin
     Handle^.iReadBytes := E;
     _SetBuffer(Handle);
     Handle^.BUFFER.Locate(Handle^.iRecPos);
    end;{ if }
   end;{ if }
  end;{ if }
 end;{ if }
end;{ func }


{===========================================================================}
{                      Data Access: Logical Record Level                    }
{===========================================================================}

function ALPGetNextRecord (             { Find/Get the next record }
      Handle        : ALP_HANDLE;       { Cursor handle }
      pRecBuff      : Pointer;          { Record buffer(client) }
      pRecProps     : pRECProps         { Optional record properties }
   ): ALPResult;
label
 LABEL_REPEAT;
var
 E        : Integer;
 NewPos   : Integer;
 pData    : pByte;
 IsAccept : Boolean;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  repeat
   if( Handle^.BUFFER.IsEOF )then
   begin
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LABEL_REPEAT:
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if( Handle^.iBlockCurr > Handle^.iBlockLast )or
      ( Handle^.iBlockNext = 0 )then
    begin
     Result := ERR_EOF;
     Break;
    end;{ if }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NewPos := _GetBlockPos( Handle, Handle^.iBlockNext );
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    E := FileSeek(Handle^.iHandle, NewPos, SEEK_FROMBEGIN);
    if( E = -1 )then Result := ERR_CANNOTSEEK else
    begin
     Handle^.iBlockPos := E;
     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     E := FileRead(Handle^.iHandle, Handle^.BUFFER.pIntBuf^, Handle^.iBufSize);
     if( E = -1 )then Result := ERR_CANNOTREADFILE else
     begin
      Handle^.iReadBytes := E;
      _SetBuffer(Handle);
      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      if( Handle^.BUFFER.IsEMPTY )then
      if( Handle^.iBlockCurr >= Handle^.iBlockLast )or
        ( Handle^.iBlockNext = 0 )then
      Result := ERR_EOF else goto LABEL_REPEAT;
      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     end;{ if }
     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end;{ if }
   end else
   Handle^.BUFFER.Next;

   {----------------------------------------------------------}
   { Get Record                                               }
   {----------------------------------------------------------}
   if( Result = ERR_NONE )then
   begin
    pData := Handle^.BUFFER.pCursor;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IsAccept := False;
    if(( Handle^.iTblType in ALP_DBASETYPES)and
       ( PByte(pData)^ = DELFLAG_DBASE))then Continue else
    if(( Handle^.iTblType in ALP_CLARIONTYPES )and
       ( PByte(pData)^ = DELFLAG_CLARION))then Continue;
    IsAccept := True;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    { Move data buffer }
    if( pRecBuff <> nil )then
    begin
     inc(pData, Handle^.iFldHdrSize);
     _Move(pData, pRecBuff, Handle^.iDataSize);
    end;{ if }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    { Set record properties }
    if( pRecProps <> nil )then
    begin
     pRecProps^.iRecNum     := Handle^.iRecId;
     pRecProps^.iRecStatus  := rsUnmodified;
     pRecProps^.bDeleteFlag := False;
    end;{ if }
   end;{ if }
  until( IsAccept )xor( Result <> ERR_NONE );
 end;{ if }
end;{ func }

function ALPGetPriorRecord (            { Find/Get the prior record }
      Handle        : ALP_HANDLE;       { Cursor handle }
      pRecBuff      : Pointer;          { Record buffer(client) }
      pRecProps     : pRECProps         { Optional record properties }
   ): ALPResult;
label
 LABEL_REPEAT;
var
 E        : Integer;
 pData    : pByte;
 NewPos   : Integer;
 IsAccept : Boolean;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  repeat
   if( Handle^.BUFFER.IsBOF )then
   begin
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    LABEL_REPEAT:
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if( Handle^.iBlockCurr < Handle^.iBlockFirst )or
      ( Handle^.iBlockPred = 0 )then
    begin
     Result := ERR_BOF;
     Break;
    end;{ if }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NewPos := _GetBlockPos( Handle, Handle^.iBlockPred );
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    begin
     E := FileSeek(Handle^.iHandle, NewPos, SEEK_FROMBEGIN);
     if( E = -1 )then Result := ERR_CANNOTSEEK else
     begin
      Handle^.iBlockPos := E;
      E := FileRead(Handle^.iHandle, Handle^.BUFFER.pINTBUF^ , Handle^.iBufSize);
      if( E = -1 )then Result := ERR_CANNOTREADFILE else
      begin
       Handle^.iReadBytes := E;
       _SetBuffer(Handle);
       Handle^.BUFFER.Last;
       //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       if( Handle^.BUFFER.IsEMPTY )then
       if( Handle^.iBlockCurr <= Handle^.iBlockFirst )or
         ( Handle^.iBlockPred = 0 )then
       Result := ERR_BOF else goto LABEL_REPEAT;
      end;{ if }
     end;{ if }
    end;{ if }
   end else
   Handle^.BUFFER.Prior;

   {----------------------------------------------------------}
   { Get Record                                               }
   {----------------------------------------------------------}
   if( Result = ERR_NONE )then
   begin
    pData := Handle^.BUFFER.pCursor;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IsAccept := False;
    if(( Handle^.iTblType in ALP_DBASETYPES)and
       ( PByte(pData)^ = DELFLAG_DBASE))then Continue else
    if(( Handle^.iTblType in ALP_CLARIONTYPES )and
       ( PByte(pData)^ = DELFLAG_CLARION))then Continue;
    IsAccept := True;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    { Move data buffer }
    if( pRecBuff <> nil )then
    begin
     inc(pData, Handle^.iFldHdrSize);
     _Move(pData, pRecBuff, Handle^.iDataSize);
    end;{ if }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    { Set record properties }
    if( pRecProps <> nil )then
    begin
     pRecProps^.iRecNum     := Handle^.iRecId;
     pRecProps^.iRecStatus  := rsUnmodified;
     pRecProps^.bDeleteFlag := False;
    end;{ if }
   end;{ if }
  until( IsAccept )xor( Result <> ERR_NONE );
 end;{ if }
end;{ func }

function ALPGetRecord (                 { Gets the current record }
      Handle        : ALP_HANDLE;       { Cursor handle }
      pRecBuff      : Pointer;          { Record buffer(client) }
      pRecProps     : pRECProps         { Optional record properties }
   ): ALPResult;
var
 pData: pBYTE;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  { Get Record }
  if( Handle^.BUFFER.IsEMPTY )then
   Result := ERR_BUFFERISEMPTY else
  if( Handle^.BUFFER.IsEOF )and
    ( Handle^.iBlockCurr > Handle^.iBlockLast )then
   Result := ERR_EOF else
  if( Handle^.BUFFER.IsBOF )and
    ( Handle^.iBlockCurr < Handle^.iBlockFirst )then
   Result := ERR_BOF else
  begin
   pData := Handle^.BUFFER.pCursor;
   if( Handle^.iTblType in ALP_CLARIONTYPES )and
     ( pData^ = DELFLAG_CLARION )then
   Result := ERR_RECDELETED else
   if( Handle^.iTblType in ALP_DBASETYPES )and
     ( pData^ = DELFLAG_DBASE )then
   Result := ERR_RECDELETED else
   begin
    //~~~ set buffer ~~~~~~~~
    if( pRecBuff <> nil )then
    begin
     inc(pData, Handle^.iFldHdrSize);
     _Move(pData, pRecBuff, Handle^.iDataSize);
    end;{ if }
    //~~~ set record props ~~
    if( pRecProps <> nil )then
    begin
     pRecProps^.iRecNum     := Handle^.iRecId;
     pRecProps^.iRecStatus  := rsUnmodified;
     pRecProps^.bDeleteFlag := False;
    end;{ if }
   end;{ if }
  end;{ if }
 end;{ if }
end;{ func }

function ALPInitRecord (               { Initialize record area }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer           { Record buffer }
   ): ALPResult;
begin
 case( Handle^.iTblType )of
 ttDBASE3..ttDBASE7,
 ttFOXPRO1..ttFOXPRO4   : FillChar(pRecBuff^, Handle^.iDataSize, EMPCHAR_DBASE);
 ttCLARION1..ttCLARION2,
 ttPARADOX3..ttPARADOX7 : FillChar(pRecBuff^, Handle^.iDataSize, 0);
 end;{ case }
end;{ func }

function ALPInsertRecord (             { Inserts a new record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer           { New Record (client) }
   ): ALPResult;
begin
end;{ func }

function ALPModifyRecord (              { Updates the current record }
      Handle        : ALP_HANDLE;       { Cursor handle }
      pRecBuf       : Pointer;          { Modified record }
      bFreeLock     : Boolean           { Free record lock }
   ): ALPResult;
var
 E       : Integer;
 RecPos  : Integer;
 RecSize : Integer;
 pPos    : pBYTE;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  pPos := Handle^.BUFFER.pCursor;
  inc(pPos, Handle^.iFldHdrSize);
  RecSize := Handle^.iRecSize - Handle^.iFldHdrSize;
  _Move(pRecBuf, pPos, RecSize);
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  RecPos := ( Handle^.BUFFER.GetRecPos + Handle^.iFldHdrSize );
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  E := FileSeek(Handle^.iHandle, RecPos, SEEK_FROMBEGIN);
  if( E = -1 )then Result := ERR_CANNOTSEEK else
  begin
   E := FileWrite(Handle^.iHandle, pRecBuf^, RecSize);
   if( E = -1 )then Result := ERR_CANNOTWRITEFILE else
   begin
   end;{ if }
  end;{ if }
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 end;{ if }
end;{ func }

function ALPDeleteRecord (              { Deletes the current record }
      Handle        : ALP_HANDLE;       { Cursor handle }
      pRecBuf       : Pointer           { Copy of deleted record }
   ): ALPResult;
var
 E       : Integer;
 BlcPos  : Integer;
 RecPos  : Integer;
 NumRecs : Longint;
 Offs    : Longint;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Handle^.BUFFER.Delete;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(  Handle^.iTblType in ALP_PDXTYPES )then
  begin
   RecPos := ( Handle^.BUFFER.BufferPos );
   E := FileSeek(Handle^.iHandle, RecPos, SEEK_FROMBEGIN);
   if( E = -1 )then Result := ERR_CANNOTSEEK else
   begin
    E := FileWrite(Handle^.iHandle, Handle^.BUFFER.pIntBuf^, Handle^.iBlockSize);
    if( E = -1 )then Result := ERR_CANNOTWRITEFILE else
    begin
     dec(Handle^.iNumRecs);
     _WriteParam(Handle, PRM_NUMRECS);
    end;{ if }
   end;{ if }
  end else
  begin
   RecPos := ( Handle^.BUFFER.GetRecPos );
   E := FileSeek(Handle^.iHandle, RecPos, SEEK_FROMBEGIN);
   if( E = -1 )then Result := ERR_CANNOTSEEK else
   begin
    E := FileWrite(Handle^.iHandle, Handle^.BUFFER.pCursor^, Handle^.iRecSize);
    dec(Handle^.iNumRecs);
    inc(Handle^.iNumDels);
    _WriteParam(Handle, PRM_NUMDELS);
   end;{ if }
  end;{ if }
 end;{ if }
end;{ func }

function ALPReadBlock (                { Read a block of records }
      Handle        : ALP_HANDLE;      { Cursor handle }
var   iRecords      : Longint;          { Number of records to read }
      pBuf          : Pointer           { Buffer }
   ): ALPResult;
begin
end;{ func }

function ALPWriteBlock (               { Write a block of records }
      Handle        : ALP_HANDLE;      { Cursor handle }
var   iRecords      : Longint;          { Number of records to write/written }
      pBuf          : Pointer           { Buffer }
   ): ALPResult;
begin
end;{ func }

function ALPAppendRecord (             { Inserts a new record }
      Handle        : ALP_HANDLE;      { Cursor handle }
      pRecBuff      : Pointer           { New Record (client) }
   ): ALPResult;
var
 E      : Integer;
 pBuf   : pBYTE;
 pPos   : pBYTE;
 RecPos : Integer;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  Result := ALPSetToEnd(Handle);
  if( Result = ERR_NONE )then
  begin
   RecPos := Handle^.iRecPos + Handle^.iRecSize;
   pBuf   := AllocMem(Handle^.iRecSize + Handle^.iFooterLen);
   try
    { init record }
    ALPInitRecord(Handle, pBuf);
    inc(pPos, Handle^.iFldHdrSize);
    _Move(pRecBuff, pPos, Handle^.iDataSize);
    inc(pPos, Handle^.iDataSize);
    pPos^ := 26;{ end }
    E := FileSeek(Handle^.iHandle, RecPos, SEEK_FROMBEGIN);
    if( E = -1 )then Result := ERR_CANNOTSEEK else
    begin
     Handle^.iFilePos := E;
     E := FileWrite(Handle^.iHandle, pBuf^, Handle^.iRecSize + Handle^.iFooterLen);
     if( E = -1 )then Result := ERR_CANNOTWRITEFILE else
     begin
      Handle^.iRecPos := RecPos;
     end;{ if }
    end;{ if }
   finally
    FreeMem(pBuf, Handle^.iRecSize + Handle^.iFooterLen);
   end;{ fin }
  end;{ if }
 end;{ if }
end;{ func }

function ALPGetRecordCount (           { Get the current number of records }
      Handle        : ALP_HANDLE;      { Cursor handle }
var   iRecCount     : Longint          { Number of records }
   ): ALPResult;
var
 Bk   : IBookmark;
begin
 Result := ERR_NONE;
 if( Handle^.iTblType in ALP_PDXTYPES + [ttEJM] )then
  iRecCount := Handle^.iNumRecs
 else begin
  iRecCount := 0;
  try
   ALPGetBookMark(Handle, @Bk);
   ALPSetToBegin(Handle);
   while( ALPGetNextRecord(Handle, nil, nil) = ERR_NONE )do
   inc(iRecCount);
  finally
   ALPSetToBookMark(Handle, @Bk);
  end;{ fin }
 end;{ else } 
end;{ func }

{============================================================================}
{                            Field Level Access                              }
{============================================================================}

function ALPGetField (                 { Get Field value }
      Handle        : ALP_HANDLE;      { Cursor }
      iField        : Word;             { Field # (1..n) }
      pRecBuff      : Pointer;          { Record buffer }
      pDest         : Pointer;          { Destination field buffer }
var   bBlank        : Boolean           { Returned : is field blank }
   ): ALPResult;
var
 pFLD: pFLDDesc;
 pPos: pBYTE;
 pBuf: pCHAR;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  pFLD := Handle^.pFIELDS;
  inc(pFLD, iField - 1);
  pPos := precBuff;
  inc(pPos, pFLD^.iOffset);
  if( pDest <> nil )then
  begin
   bBlank := _IsBlank(Handle, pFld, pPos);
   if( not bBlank )then
   begin
    try
     FillChar(pDest^, pFLD^.iDataLen, #0);
     pBuf := AllocMem(pFld^.iPhysLen + 1);
     _Move(pPos, pBuf, pFLD^.iPhysLen);
     ALPDataToIDE(Handle, pFld, pBuf);
     if( pFld^.iFldType = uftString )then
     _Move(pBuf, pDest, pFld^.iDataLen + 1)else
     _Move(pBuf, pDest, pFld^.iDataLen);
    finally
     FreeMem(pBuf, pFld^.iPhysLen + 1);
    end;{ fin }
   end;{ fin }
  end;{ if }
 end;{ if }
end;{ func }

function ALPPutField (                  { Put a value in the record buffer }
      Handle        : ALP_HANDLE;       { Cursor }
      iField        : Word;             { Field # (1..n) }
      pRecBuff      : Pointer;          { Record buffer }
      pSrc          : Pointer           { Source field buffer }
   ): ALPResult;
var
 pFLD  : pFLDDesc;
 pPos1 : pBYTE;
 pPos2 : pBYTE;
begin
 Result := ERR_NONE;
 if( Handle = nil )then
 Result := ERR_INVALIDHANDLE else
 begin
  pFLD := Handle^.pFIELDS;
  inc(pFLD, iField - 1);
  pPos1 := pRecBuff;
  pPos2 := Handle^.BUFFER.pCursor;
  inc(pPos1, pFLD^.iOffset);
  inc(pPos2, Handle^.iFldHdrSize + pFld^.iOffset);

  if( pSrc = nil )then
   case( Handle^.iTblType )of
   ttDBASE3..ttDBASE7,
   ttFOXPRO1..ttFOXPRO4:
    begin
     FillChar(pPos1^, pFLD^.iPhysLen, EMPCHAR_DBASE);
     FillChar(pPos2^, pFLD^.iPhysLen, EMPCHAR_DBASE);
    end;{ }
   end{ case }
  else
  begin
   ALPIDEToData(Handle, pFld, pSrc);
   _Move(pSrc, pPos1, pFLD^.iPhysLen);
   _Move(pSrc, pPos2, pFLD^.iPhysLen);
  end;{ else }
 end;{ if }
end;{ func }



{============================================================================}
{                            Formatting data                                 }
{============================================================================}

function ALPDataToIDE (                { Get a formatted value }
      Handle        : ALP_HANDLE;      { Cursor }
      pFld          : pFldDesc;         { Field pointer }
      pBuff         : Pointer           { Value buffer }
   ): ALPResult;
var
 I       : Integer;
 F       : Integer;
 P       : Pointer;
 Len     : Integer;
 Value   : string;
 Int16   : SmallInt;
 Int32   : Integer;
 Card    : Integer;
 Dbl     : Double;
 pDate   : pDATE_DBASE;
 Day     : Word;
 Month   : Word;
 Year    : Word;
 pPos    : pByte;
 EDate   : TDateTime;
 Rslt    : Integer;
 Buf     : array [0..31] of Byte;
begin
  case( pFld^.iFldType )of
  uftString:   case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4,
               ttCLARION1..ttCLARION2:
                begin
                 Value := StrPas(PChar(pBuff));
                 Value := TrimRight(Value);
                 _StrToAnsi(Value);
                 StrPCopy(PChar(pBuff), Value);
                end;
               ttPARADOX3..ttPARADOX7:
                begin
                end;{ Paradox }
               end;{ case }
  uftSmallint: case( Handle^ .iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                  Value := PChar(pBuff);
                  Val(Value, Int16, Rslt);
                  if( Rslt = 0 )then
                  SmallInt(pBuff^) := Int16
                  else
                  SmallInt(pBuff^) := 0;
                end;{ dBase }
               ttPARADOX3..ttPARADOX7:
                begin
                 _PdxToSmall(pBuff);
                end;{ Paradox }
               end;{ case }
  uftInteger,
  uftAutoInc:  case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                 Value := PChar(pBuff);
                 Val(Value, Int32, Rslt);
                 if( Rslt = 0 )then
                 Integer(pBuff^) := Int32
                 else
                 Integer(pBuff^) := 0;
                end;{ dBase }
               ttPARADOX3..ttPARADOX7:
                begin
                 _PdxToInt(pBuff);
                end;{ Paradox }
               end;{ case }
  uftFloat:    case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7:
                begin
                 Value := PChar(pBuff);
                 Val(Value, Dbl, Rslt);
                 if( Rslt = 0 )then
                 Double(pBuff^) := Dbl
                 else
                 Double(pBuff^) := 0;
                end;{ dBase }
               ttCLARION1..ttCLARION2:
                begin
                 if( pFld^.iSubType = sftBCD )then
                 begin
                  _Move(pBuff, @Buf, pFld^.iFldSize);
                  Dbl := 0;
                  for I := 1 to pFld^.iFldSize - 1 do
                  begin
                   Card := 1;
                   for F := 1 to I do Card := Card * Card;
                   Dbl := Dbl + (Buf[I] div 16) * Card * 10;
                   Dbl := Dbl + (Buf[I] mod 16) * Card;
                  end;
                  { znak }
                  if( Buf[0] div 16 ) <> 0 then Dbl := Dbl * -1;
                  { decimal }
                  //for F := 1 to pFld^.iFldDec - 1 do Dbl := Dbl / 10;
                  Double(pBuff^) := Dbl;
                 end else
                 begin
                  Value := PChar(pBuff);
                  Val(Value, Dbl, Rslt);
                  if( Rslt = 0 )then
                  Double(pBuff^) := Dbl
                  else
                  Double(pBuff^) := 0;
                 end;
                end;{ Clarion }
               ttPARADOX3..ttPARADOX7:
                begin
                 _PdxToDouble(pBuff);
                end;{ Paradox }
               end;{ case }
  uftCurrency: case( Handle^.iTblType )of
               ttPARADOX3..ttPARADOX7:
                begin
                 _PdxToDouble(pBuff);
                end;{ Paradox }
               end;{ case }
  uftDate:     case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7:
                begin
                 pDate := pBuff;
                 Year  := StrToIntDef(pDate^.Year, 0);
                 Month := StrToIntDef(pDate^.Month, 1);
                 Day   := StrToIntDef(pDate^.Day, 1);
                 if( Day = 0 )then Day := 1;
                 if( Month = 0 )then Month := 1;
                 if( Year < 1900 )or( Year > 2100 )then Year := 1900;
                 try
                  EDate := EncodeDate(Year, Month, Day);
                  Integer(pBuff^) := DateTimeToTimeStamp(EDate).Date;
                 except
                  Integer(pBuff^) := 0;
                 end;
                end;{ dBase }
               ttCLARION1..ttCLARION2:
                begin
                 Integer(pBuff^) := DateTimeToTimeStamp(Integer(pBuff^) - DELTA_DAYS).Date;
                end;{ clarion }
               ttPARADOX3..ttPARADOX7:
                begin
                 _PdxToInt(pBuff);
                end;{ Paradox }
               end;{ case }
  uftBCD:      case( Handle^.iTblType )of
               ttCLARION1..ttCLARION2:
                begin
                end;{ clarion }
               end;{ case }
  uftBoolean:  case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                 _Move(pBuff, @Buf, pFld^.iPhysLen);
                 if Char(Buf[0]) = 'T'then
                  WordBool(pBuff^) := True else
                 if Char(Buf[0]) = 'F'then
                  WordBool(pBuff^) := False;
                end;{ dBase }
               end;{ case }
  end;{ case }
end;{ func }

function ALPIDEToData (                { Set a formatted value }
      Handle        : ALP_HANDLE;      { Cursor }
      pFld          : pFldDesc;         { Field pointer }
      pBuff         : Pointer           { Value buffer }
   ): ALPResult;
var
 Int16 : SmallInt;
 Int32 : Integer;
 Dbl   : Double;
 TStmp : TTimeStamp;
 Value : string;
 Bool  : Boolean;
 Buf   : array [0..31] of Byte;
begin
  case( pFld^.iFldType )of
  uftString:   case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4,
               ttCLARION1..ttCLARION2:
                begin
                 CharToOemBuff( PChar(pBuff), PChar(pBuff), StrLen(PChar(pBuff)));
                end;{ clarion }
               end;{ case }
  uftSmallint: case( Handle^ .iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                 Int16 := SmallInt( pBuff^ );
                 Str(Int16, Value);
                 StrPCopy(PChar(pBuff), Value);
                end;{ dBase }
               ttPARADOX3..ttPARADOX7:
                begin
                 _SmallToPdx(pBuff);
                end;{ Paradox }
               end;{ case }
  uftInteger:  case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                 Int32 := Integer( pBuff^ );
                 Str(Int32, Value);
                 StrPCopy(PChar(pBuff), Value);
                end;{ dBase }
               ttPARADOX3..ttPARADOX7:
                begin
                 _IntToPdx(pBuff);
                end;{ Paradox }
               end;{ case }
  uftFloat:    case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                 Dbl := Double( pBuff^ );
                 Str(Dbl:pFld^.iPhysLen:pFld^.iFldDec, Value);
                 StrPCopy(PChar(pBuff), Value);
                end;{ dBase }
               ttPARADOX3..ttPARADOX7:
                begin
                 _DoubleToPdx(pBuff);
                end;{ Paradox }
               end;{ case }
  uftCurrency: case( Handle^.iTblType )of
               ttPARADOX3..ttPARADOX7:
                begin
                 _DoubleToPdx(pBuff);
                end;{ Paradox }
               end;{ case }
  uftBoolean:  case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7,
               ttFOXPRO1..ttFOXPRO4:
                begin
                 Bool := Boolean( pBuff^ );
                 if Bool then
                 StrPCopy(PChar(pBuff), 'T')else
                 StrPCopy(PChar(pBuff), 'F');
                end;{ dBase }
               end;{ case }
  uftDate:     case( Handle^.iTblType )of
               ttDBASE3..ttDBASE7, ttFOXPRO1..ttFOXPRO4:
                begin
                 TStmp.Time := 0;
                 TStmp.Date := Integer(pBuff^);
                 Int32 := Trunc(TimeStampToDateTime(TStmp));
                 StrPCopy(PChar(pBuff), FormatDateTime('yyyymmdd', Int32));
                end;{ dBase }
               ttCLARION1..ttCLARION2:
                begin
                 TStmp.Time := 0;
                 TStmp.Date := Integer(pBuff^) + DELTA_DAYS;
                 Integer(pBuff^) := Trunc(TimeStampToDateTime(TStmp));
                end;{ dBase }
               ttPARADOX3..ttPARADOX7:
                begin
                 _IntToPdx(pBuff);
                end;{ Paradox }
               end;{ case }
  end;{ case }
end;{ func }

end.
