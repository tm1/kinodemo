{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uPrint.pas
Version      : 18.10.2002 7:07:07
Description  : 
Creation     : 12.10.2002 9:03:07
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uPrint;

interface

  // --------------------------------------------------------------------------
  // Инициализация печати глобальная
  // --------------------------------------------------------------------------
  function Init_Global_Print(i_Zal: Byte; Zal_Nam: string): Integer; //ready partially
  // --------------------------------------------------------------------------
  // Инициализация печати
  // --------------------------------------------------------------------------
  function Init_TC_Print(Zal: Integer; Film_Date: TDateTime;
    str_Zal_Nam, Film_Name, Seans_Desc: string): Integer; //ready
  // --------------------------------------------------------------------------
  // Добавление в буфер печати
  // --------------------------------------------------------------------------
  function Add_TC_Print(Print_Type: byte; _TC_Kod, _Tarifpl, _Repert, _Row_Num,
    _Column_Num, _Owner, _Sum: Integer; _Group: string; Add_Elem: boolean): Integer; //ready partially
  // --------------------------------------------------------------------------
  // Печать пакета подготовленных билетов
  // --------------------------------------------------------------------------
  function Final_TC_Print(TC_Print_Count: integer): Integer; //ready
  // --------------------------------------------------------------------------
  // Отмена печати пакета подготовленных билетов
  // --------------------------------------------------------------------------
  function Cancel_TC_Print: Integer; //ready
  // --------------------------------------------------------------------------

const
  PrintJobFirst: Boolean = True;

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uPrint_DEBUG}
{$ENDIF}

uses
  Bugger,
  uAddon,
  uRescons,
  uTools,
  uImports,
  uDatamod,
  SysUtils,
  Graphics;

{-----------------------------------------------------------------------------
  Procedure: Init_Global_Print
  Author:    n0mad
  Date:      23-окт-2002
  Arguments: i_Zal: Byte; Zal_Nam: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Init_Global_Print(i_Zal: Byte; Zal_Nam: string): Integer; //ready partially
const
  ProcName: string = 'Init_Global_Print';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  buffer: string;
begin
  // --------------------------------------------------------------------------
  // Инициализация печати
  // --------------------------------------------------------------------------
  Time_Start := Now;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Result := 0;
  if True then
  begin
  // --------------------------------------------------------------------------
  // Загрузка логотипа
  // --------------------------------------------------------------------------
    gfx_Emblema := LoadBitmapFromFile(PChar('@1,' + dm.db.Directory + 'Emblema_' + IntToStr(i_Zal) + '.bmp'), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Emblema = [' + IntToStr(gfx_Emblema) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка названия зала
  // --------------------------------------------------------------------------
    buffer := '@2,050,050' + CRLF + '#Courier New,1000,20,204' + CRLF;
    // buffer := buffer + '^0090,0000;' + 'Зеленый зал';
    buffer := buffer + '^0090,0000;' + Zal_Nam;
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Address := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Address = [' + IntToStr(gfx_Address) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,16,204' + CRLF;
    buffer := buffer + '^0029,0000;' + 'ряд';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Ryad := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Ryad = [' + IntToStr(gfx_Ryad) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,16,204' + CRLF;
    buffer := buffer + '^0040,0000;' + 'место';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Mesto := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Mesto = [' + IntToStr(gfx_Mesto) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,16,204' + CRLF;
    buffer := buffer + '^0032,0000;' + 'цена';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Cena := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Cena = [' + IntToStr(gfx_Cena) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,16,204' + CRLF;
    buffer := buffer + '^0032,0000;' + 'сумма';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Summa := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Summa = [' + IntToStr(gfx_Summa) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,16,204' + CRLF;
    buffer := buffer + '^0028,0000;' + 'тенге';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Tenge := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Tenge = [' + IntToStr(gfx_Tenge) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,18,204' + CRLF;
    buffer := buffer + '^0105,0000;' + 'Бесплатный билет';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Halyava := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Halyava = [' + IntToStr(gfx_Halyava) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,18,204' + CRLF;
    buffer := buffer + '^0105,0000;' + 'Студенч./Пенсион.';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Studpens := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Studpens = [' + IntToStr(gfx_Studpens) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,18,204' + CRLF;
    buffer := buffer + '^0105,0000;' + 'Детский билет';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Detski := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Detski = [' + IntToStr(gfx_Detski) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,18,204' + CRLF;
    buffer := buffer + '^0105,0000;' + 'Пригласительный';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Priglas := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Priglas = [' + IntToStr(gfx_Priglas) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,18,204' + CRLF;
    buffer := buffer + '^0105,0000;' + 'VIP карточка';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Vip := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Vip = [' + IntToStr(gfx_Vip) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,16,204' + CRLF;
    buffer := buffer + '^0092,0000;' + 'Кол-во мест';
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Kolvomest := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx_Kolvomest = [' + IntToStr(gfx_Kolvomest) + ']');
{$ENDIF}
  end;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: ' + 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Init_TC_Print
  Author:    n0mad
  Date:      23-окт-2002
  Arguments: Zal: Integer; Film_Date: TDateTime; str_Zal_Nam, Film_Name, Seans_Desc: string
  Result:    Integer
-----------------------------------------------------------------------------}
function Init_TC_Print(Zal: Integer; Film_Date: TDateTime;
  str_Zal_Nam, Film_Name, Seans_Desc: string): Integer; //ready
const
  ProcName: string = 'Init_TC_Print';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  buffer: string;
begin
  // --------------------------------------------------------------------------
  // Инициализация печати
  // --------------------------------------------------------------------------
  Time_Start := Now;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Result := 0;
  if Exist_Zal_Desc(Zal) then
  begin
    if Emblema_Loaded = 0 then
    begin
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
      FlushGfxCache;
      Init_Global_Print(Zal, str_Zal_Nam);
      InitializePrinterJob;
      PrintBuffer('', 'Demokino - Preload images.');
      Emblema_Loaded := 1;
{$IFDEF uPrint_DEBUG}
      DEBUGMess(0, '[' + ProcName + ']: Hurra - gfx_Emblema = (' + IntToStr(gfx_Emblema) + ')');
{$ENDIF}
    end;
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,025,050' + CRLF + '#Times New Roman,1000,25,204' + CRLF;
    buffer := buffer + '^0266,0000;' + Film_Name;
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx1_Filmname := PrepareBitmapFromText(PChar(buffer), 0, 0);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx1_Filmname = [' + IntToStr(gfx1_Filmname) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Загрузка
  // --------------------------------------------------------------------------
    buffer := '@2,000,050' + CRLF;
    buffer := buffer + '#Arial,0000,19,204' + CRLF;
    buffer := buffer + '^0120,0000;' + FormatDateTime('d mmmm yyyy', Film_Date) + CRLF;
    buffer := buffer + '#Arial,0000,18,204' + CRLF;
    buffer := buffer + '^0049,0000;' + '  время  ' + CRLF;
    buffer := buffer + '#Arial,1000,19,204' + CRLF;
    buffer := buffer + '^0100,0000;' + Seans_Desc;
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: buffer = [' + buffer + ']');
{$ENDIF}
    gfx1_Datavremya := PrepareBitmapFromText(PChar(buffer), 0, 0);
{$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: gfx1_Datavremya = [' + IntToStr(gfx1_Datavremya) + ']');
{$ENDIF}
    InitializePrinterJob;
  end;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: ' + 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Add_TC_Print
  Author:    n0mad
  Date:      25-окт-2002
  Arguments: Print_Type: byte; _TC_Kod, _Tarifpl, _Repert, _Row_Num, _Column_Num, _Owner, _Sum: Integer; _Group: string; ; Add_Elem: boolean
  Result:    Integer
-----------------------------------------------------------------------------}
function Add_TC_Print(Print_Type: byte; _TC_Kod, _Tarifpl, _Repert, _Row_Num,
  _Column_Num, _Owner, _Sum: Integer; _Group: string; Add_Elem: boolean): Integer; //ready partially
const
  ProcName: string = 'Add_TC_Print';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i_Tarifpl_TYPE, i_Tarifpl_TAG, i_Cost, i_Seans, i_Film, i_Tarifet, i_Zal, i_Repert_TAG: Integer;
  b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS: Boolean;
  c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR: TColor;
  d_Film_Date: TDateTime;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Check_print: boolean;
var
  tmp_result: Integer;
begin
  Result := False;
  if Get_Tarifpl(_Tarifpl, b_Tarifpl_PRINT, b_Tarifpl_REPORT, b_Tarifpl_FREE, b_Tarifpl_SHOW, b_Tarifpl_SYS,
    i_Tarifpl_TYPE, c_Tarifpl_BGCOLOR, c_Tarifpl_FNTCOLOR, i_Tarifpl_TAG) = 1 then
    if b_Tarifpl_PRINT and (not b_Tarifpl_SYS) and b_Tarifpl_SHOW and
      ((Print_Type = 0) or ((Print_Type = 1) and (Length(_Group) > 0))) then
    begin
      case Print_Type of
      0, 1:
      begin
        {unknown}
        tmp_result := Get_Repert_Desc(_Repert, d_Film_Date, i_Seans, i_Film, i_Tarifet, i_Zal, i_Repert_TAG);
        if (tmp_result > 0) then
          {ready}
          tmp_result := Get_Tarifet_Desc(i_Tarifet, _Tarifpl, i_Cost);
          if (tmp_result = 0) then
            i_Cost := 0;
          if tmp_result > 0 then
            Result := True;
      end;
      else // case
        Result := False;
      end; // case
    end; // if
end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var
  gfx2_Ryadnum, gfx2_Mestonum, gfx2_Cenamesta, gfx2_Primechanie, gfx2_Serial: Integer;
  NomerRyada, NomerMesta, Sum_Group: string;
  buffer: string;
  str_Zal_Nam, str_Film_Name, str_Seans_Desk: string;
begin
  // --------------------------------------------------------------------------
  // Добавление в буфер печати
  // --------------------------------------------------------------------------
  Time_Start := Now;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: Add_Elem = ' + FALSE_OR_TRUE[Add_Elem]);
{!$ENDIF}
  Result := 0;
  if Check_print then
  begin
     gfx2_Mestonum := 0;
  // --------------------------------------------------------------------------
  // Выбор примечания к типу билета
  // --------------------------------------------------------------------------
     case _Tarifpl of
     // Студенческий/Пенсионный
     2:
       gfx2_Primechanie := gfx_Studpens;
     // Школьный
     3:
       gfx2_Primechanie := gfx_Detski;
     // Пригласительный
     10:
       gfx2_Primechanie := gfx_Priglas;
     // VIP карточка
     12:
       gfx2_Primechanie := gfx_Vip;
     else
       gfx2_Primechanie := 0;
     end;
  // --------------------------------------------------------------------------
     if PrintJobFirst then
     begin
       Get_Repert_Film_Desc(_Repert, d_Film_Date, str_Zal_Nam, str_Film_Name, str_Seans_Desk);
       Init_TC_Print(i_Zal, d_Film_Date, str_Zal_Nam, str_Film_Name, str_Seans_Desk);
       PrintJobFirst := False;
     end;
     if Print_Type = 1 then
     begin
       // групповой
       buffer := '@2,000,050' + CRLF;
       buffer := buffer + '#Arial,1100,20,204' + CRLF;
       buffer := buffer + '^0181,0000;' + _Group + CRLF;
       gfx2_Ryadnum := PrepareBitmapFromText(PChar(buffer), 0, 0);

       Sum_Group := IntToStr(_Sum);
       buffer := '@2,000,050' + CRLF;
       buffer := buffer + '#Arial,0000,18,204' + CRLF;
       buffer := buffer + '^0030,0000;' + Sum_Group;
       gfx2_Primechanie := PrepareBitmapFromText(PChar(buffer), 0, 0);
     end
     else
     begin
       // обычный
       NomerRyada := IntToStr(_Row_Num);
       buffer := '@2,000,050' + CRLF;
       buffer := buffer + '#Arial,1100,20,204' + CRLF;
       buffer := buffer + '^0039,0000;' + NomerRyada + CRLF;
       gfx2_Ryadnum := PrepareBitmapFromText(PChar(buffer), 0, 0);

       NomerMesta := IntToStr(_Column_Num);
       buffer := '@2,000,050' + CRLF;
       buffer := buffer + '#Arial,1100,20,204' + CRLF;
       buffer := buffer + '^0039,0000;' + NomerMesta;
       gfx2_Mestonum := PrepareBitmapFromText(PChar(buffer), 0, 0);
     end;
     if b_Tarifpl_FREE then
     begin
       // Бесплатный
       gfx2_Cenamesta := gfx_Halyava;
     end
     else
     begin
       // Платный
       buffer := '@2,000,050' + CRLF;
       buffer := buffer + '#Arial,1000,19,204' + CRLF;
       buffer := buffer + '^0032,0000;' + IntToStr(i_Cost);
       gfx2_Cenamesta := PrepareBitmapFromText(PChar(buffer), 0, 0);
     end;
     //*****************************************************************************************
     if Add_Elem and _Print_Serial then
     begin
       buffer := '@2,000,050' + CRLF;
       buffer := buffer + '#Arial,1000,20,204' + CRLF;
       // ----------------
       // Length(WWWWWWW) is 7, width is 175 dots ~ 0,86 inches ~ 21,90 mm.
       // buffer := buffer + '^0094,0000;' + 'WWWWWWW'; 
       // ----------------
       // Length(WW00000) is 7, width is 125 dots ~ 0,62 inches ~ 15,60 mm.
       // buffer := buffer + '^0068,0000;' + 'WW' + '00000';
       // ----------------
       // Length(AL00001) is 7, width is 111 dots ~ 0,55 inches ~ 13,90 mm.
       buffer := buffer + '^0068,0000;' + _Zal_Prefix + FixFmt(_Serial, 5, '0');
       // ----------------
       gfx2_Serial := PrepareBitmapFromText(PChar(buffer), 0, 0);
     end
     else
       gfx2_Serial := 0;
     //#########################################################################################
     BeginLabelCmd;
     //*****************************************************************************************
     PlaceBitmap(1, 1, 70, 250, gfx_Emblema); // 190, 150
{$IFDEF uPrint_DEBUG}
     //DEBUGMess(0, '' + 'gfx_Emblema:=' + строка(gfx_Emblema));
{$ENDIF}
     //*****************************************************************************************
     PlaceBitmap(1, 1, 110, 235, gfx_Address); // 140, 140
{$IFDEF uPrint_DEBUG}
     //DEBUGMess(0, '' + 'gfx_Address:=' + строка(gfx_Address));
{$ENDIF}
     //*****************************************************************************************
     PlaceBitmap(1, 1, 21, 215, gfx1_Filmname); // 95, 105
{$IFDEF uPrint_DEBUG}
     //DEBUGMess(0, '' + 'gfx1_Filmname:=' + строка(gfx1_Filmname));
{$ENDIF}
     //*****************************************************************************************
     PlaceBitmap(1, 1, 15, 188, gfx1_Datavremya); // 110, 80
{$IFDEF uPrint_DEBUG}
     //DEBUGMess(0, '' + 'gfx1_Datavremya:=' + строка(gfx1_Datavremya));
{$ENDIF}
     //*****************************************************************************************
     PlaceBitmap(1, 1, 228, 167, gfx_Ryad); // 340, 60
{$IFDEF uPrint_DEBUG}
     //DEBUGMess(0, '' + 'gfx_Ryad:=' + строка(gfx_Ryad));
{$ENDIF}
     if Print_Type = 1 then
     begin
       // групповой
       PlaceBitmap(1, 1, 30, 167, gfx2_Ryadnum); // 150, 60
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx2_Ryadnum=' + строка(gfx2_Ryadnum));
{$ENDIF}
     end
     else
     begin
       // обычный
       PlaceBitmap(1, 1, 189, 167, gfx2_Ryadnum); // 300, 60
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx2_Ryadnum=' + строка(gfx2_Ryadnum));
{$ENDIF}
       PlaceBitmap(1, 1, 149, 167, gfx_Mesto); // 230, 60
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx_Mesto=' + строка(gfx_Mesto));
{$ENDIF}
       PlaceBitmap(1, 1, 110, 167, gfx2_Mestonum); // 190, 60
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx2_Mestonum=' + строка(gfx2_Mestonum));
{$ENDIF}
     end;
     //*****************************************************************************************
     if b_Tarifpl_FREE then
     begin
       // Бесплатный
       PlaceBitmap(1, 1, 152, 146, gfx_Halyava); // 225, 45
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx_Halyava=' + строка(gfx_Halyava));
{$ENDIF}
     end
     else
     begin
       // Платный
       if Print_Type = 1 then
       begin
            PlaceBitmap(1, 1, 225, 146, gfx_Summa); // 320, 45
{$IFDEF uPrint_DEBUG}
            //DEBUGMess(0, '' + 'gfx_Summa=' + строка(gfx_Summa));
{$ENDIF}
       end
       else
       begin
            PlaceBitmap(1, 1, 225, 146, gfx_Cena); // 320, 45
{$IFDEF uPrint_DEBUG}
            //DEBUGMess(0, '' + 'gfx_Cena=' + строка(gfx_Cena));
{$ENDIF}
       end;
       PlaceBitmap(1, 1, 193, 146, gfx2_Cenamesta); // 250, 45
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx2_Cenamesta=' + строка(gfx2_Cenamesta));
{$ENDIF}
       PlaceBitmap(1, 1, 165, 146, gfx_Tenge); // 190, 45
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx_Tenge=' + строка(gfx_Tenge));
{$ENDIF}
     end;
     //*****************************************************************************************
     if Print_Type = 1 then
     begin
       PlaceBitmap(1, 1, 170, 131, gfx_Kolvomest); // 290, 30
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx_Kolvomest=' + строка(gfx_Kolvomest));
{$ENDIF}
       PlaceBitmap(1, 1, 132, 131, gfx2_Primechanie); // 220, 30
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx2_Primechanie=' + строка(gfx2_Primechanie));
{$ENDIF}
     end
     else
     begin
       PlaceBitmap(1, 1, 152, 131, gfx2_Primechanie); // 225, 30
{$IFDEF uPrint_DEBUG}
       //DEBUGMess(0, '' + 'gfx2_Primechanie=' + строка(gfx2_Primechanie));
{$ENDIF}
     end;
     //*****************************************************************************************
     if Add_Elem and _Print_Serial then
     begin
       PlaceBitmap(1, 1, 149, 109, gfx2_Serial); // 225, 30
       PlaceBitmap(1, 1, 149, 73, gfx2_Serial); // 225, 30
     end;
     //*****************************************************************************************
     EndLabelCmd;
     //#########################################################################################
     // Inc(Printed_Ticket_Count);
     Result := 1;
  end;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: ' + 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Final_TC_Print
  Author:    n0mad
  Date:      24-окт-2002
  Arguments: TC_Print_Count: integer
  Result:    Integer
-----------------------------------------------------------------------------}
function Final_TC_Print(TC_Print_Count: integer): Integer; //ready
const
  ProcName: string = 'Final_TC_Print';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  s: string;
begin
  Time_Start := Now;
{$IFDEF uPrint_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{$ENDIF}
  Result := FinalizePrinterJob;
  if Result > -1 then
  begin
    s := 'Demokino - ' + IntToStr(TC_Print_Count) + ' tickets loaded.';
{!$IFDEF uPrint_DEBUG}
    DEBUGMess(0, '[' + ProcName + ']: Sent to printer. (' + s + ')');
{!$ENDIF}
    Result := PrintBuffer('', PChar(s));
    Inc(Printed_Ticket_Count, TC_Print_Count);
  end;
{$IFDEF uPrint_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(0, '[' + ProcName + ']: ' + 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
{!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Cancel_TC_Print
  Author:    n0mad
  Date:      18-окт-2002
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}
function Cancel_TC_Print: Integer; // ready
const
  ProcName: string = 'Cancel_TC_Print';
begin
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(1, '[' + ProcName + ']: ->');
{!$ENDIF}
  Result := ClearPrinterBuffer;
{!$IFDEF uPrint_DEBUG}
  DEBUGMess(-1, '[' + ProcName + ']: <-');
{!$ENDIF}
end;

{$IFDEF uPrint_DEBUG}
initialization
  DEBUGMess(0, 'uPrint.Init');
{$ENDIF}

{$IFDEF uPrint_DEBUG}
finalization
  DEBUGMess(0, 'uPrint.Final');
{$ENDIF}

end.
