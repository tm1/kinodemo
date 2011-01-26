{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uCells.pas
Version      : 15.10.2002 9:01:26
Description  : 
Creation     : 12.10.2002 9:01:26
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uCells;

interface

uses
  Bugger,
  uRescons,
  uTools,
  uDatamod,
  uThreads,
  uMain,
  ShpCtrl,
  Windows,
  Controls,
  Sysutils,
  Extctrls,
  Gauges,
  Math,
  Classes;

type
  TCreateZalRec = record
    fList: TStrings;
    fZalNum: integer;
    fggProgress: TGauge;
    fpnContainer: TPanel;
    fElemType: integer;
    fMultiplr: real;
    fAutosize: boolean;
  end;
  
  TImportZalRec = record
    fList: TStrings;
    fZalNum: integer;
    fggProgress: TGauge;
  end;

const
  StepBy: byte = 10;

//
procedure MoveComponents(Panel_From, Panel_To: TPanel);
//
procedure CreateCell(Zal_Num: integer; Panel: TPanel; var _TTickeTControl: TTickeTControl; Multiplr: real; n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height, n_Type: integer);
procedure CreateSimpleCell(Zal_Num: integer; Panel: TPanel; var _Shape: TShape; Multiplr: real; n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height, n_State: integer);
//
procedure CreateZal_ThreadProcInit(PointerToData: Pointer; var Terminated: boolean);
procedure CreateZal_ThreadProcFinal(PointerToData: Pointer; var Terminated: boolean);
procedure CreateZal_ThreadProc(PointerToData: Pointer; var Terminated: boolean);
procedure CreateZal(List: TStrings; _Zal_Num: integer; _ggProgress: TGauge; _pnContainer: TPanel; ElemType: integer; Multiplr: real; _Autosize: boolean);
//
procedure ImportZal_ThreadProcInit(PointerToData: Pointer; var Terminated: boolean);
procedure ImportZal_ThreadProcFinal(PointerToData: Pointer; var Terminated: boolean);
procedure ImportZal_ThreadProc(PointerToData: Pointer; var Terminated: boolean);
procedure ImportZal(List: TStrings; ZalNum: integer; ggProgress: TGauge);
//

const
  CreateZal_ThreadExecuted: boolean = false;
  CreateZal_Storage: TCreateZalRec = (
    fList: nil;
    fZalNum: -1;
    fggProgress: nil;
    fpnContainer: nil;
    fElemType: -1;
    fMultiplr: 0;
    fAutosize: false;
    );
  CreateZal_Thread: TGenericThread = nil;
//
  ImportZal_ThreadExecuted: boolean = false;
  ImportZal_Storage: TImportZalRec = (
    fList: nil;
    fZalNum: -1;
    fggProgress: nil
    );
  ImportZal_Thread: TGenericThread = nil;

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uCells_DEBUG}
{$ENDIF}

procedure MoveComponents(Panel_From, Panel_To: TPanel);
const
  ProcName: string = 'MoveComponents';
var
  i: Integer;
  Temp: TComponent;
begin
  DEBUGMess(1, '[' + ProcName + ']: ->');
  if Assigned(Panel_From) and Assigned(Panel_From) then
  begin
    DEBUGMess(0, '[' + ProcName + ']: Panel_From.Name = "' + Panel_From.Name + '"');
    DEBUGMess(0, '[' + ProcName + ']: Panel_To.Name = "' + Panel_To.Name + '"');
    Panel_From.Enabled := false;
    Panel_To.Enabled := false;
    DEBUGMess(0, '[' + ProcName + ']: Before - Panel_From.ComponentCount = (' + IntToStr(Panel_From.ComponentCount) + ')');
    DEBUGMess(0, '[' + ProcName + ']: Before - Panel_To.ComponentCount = (' + IntToStr(Panel_To.ComponentCount) + ')');
    for i := Panel_From.ComponentCount - 1 downto 0 do
    begin
      Temp := Panel_From.Components[i];
      if (Temp is TControl) then
      begin
        Panel_From.RemoveComponent(Temp);
        Panel_To.InsertComponent(Temp);
        (Temp as TControl).Parent := Panel_To;
      end;
    end;
    DEBUGMess(0, '[' + ProcName + ']: After - Panel_From.ComponentCount = (' + IntToStr(Panel_From.ComponentCount) + ')');
    DEBUGMess(0, '[' + ProcName + ']: After - Panel_To.ComponentCount = (' + IntToStr(Panel_To.ComponentCount) + ')');
    Panel_From.Enabled := true;
    Panel_To.Enabled := true;
  end;
  DEBUGMess(-1, '[' + ProcName + ']: <-');
end;

procedure CreateCell(Zal_Num: integer; Panel: TPanel; var _TTickeTControl: TTickeTControl; Multiplr: real; n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height, n_Type: integer);
begin
  _TTickeTControl := TTickeTControl.Create(Panel);
  _TTickeTControl.Name := Panel.Name + '_TC_Z' + IntToStr(Zal_Num) + '_R' + IntToStr(n_Row) + '_C' + IntToStr(n_Column);
  _TTickeTControl.Parent := Panel;
  _TTickeTControl.Column := n_Column;
  _TTickeTControl.Row := n_Row;
  _TTickeTControl.Left := round(n_Left  * Multiplr) + round(MarginWidth * Multiplr);
  _TTickeTControl.Top := round(n_Top * Multiplr) + round(MarginHeight * Multiplr);
  _TTickeTControl.Width := round(n_Width * Multiplr);
  _TTickeTControl.Height := round(n_Height * Multiplr);
  _TTickeTControl.Ticket_Kod := 0;
  _TTickeTControl.Ticket_Tarifpl := 0;
  _TTickeTControl.Ticket_Repert := 0;
  _TTickeTControl.Ticket_DateTime := Now;
  _TTickeTControl.Ticket_Type := n_Type;
  if Assigned(fmMain) then
  begin
    _TTickeTControl.PopupMenu := fmMain.popTicket;
    _TTickeTControl.OnClick := fmMain.TicketLeftClick;
    _TTickeTControl.OnChangeState := fmMain.TicketChangeState;
    _TTickeTControl.OnChangeTarifpl := fmMain.TicketChangeTarifpl;
    _TTickeTControl.OnChangeUsedByNet := fmMain.TicketChangeUsedByNet;
    _TTickeTControl.OnMouseDown := nil;//TTickeTControlMouseDown;
    _TTickeTControl.OnMouseMove := nil;//TTickeTControlMouseMove;
    _TTickeTControl.OnMouseUp := nil;//TTickeTControlMouseUp;
  end;
  _TTickeTControl.Hint := 'Name: ' + _TTickeTControl.Name + CRLF + 'Left: ' + IntToStr(_TTickeTControl.Left) + CRLF + 'Top: ' + IntToStr(_TTickeTControl.Top);
  _TTickeTControl.ShowHint := True;
end;

procedure CreateSimpleCell(Zal_Num: integer; Panel: TPanel; var _Shape: TShape; Multiplr: real; n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height, n_State: integer);
begin
  _Shape := TShape.Create(Panel);
  _Shape.Name := Panel.Name + '_Sh_Z' + IntToStr(Zal_Num) + '_R' + IntToStr(n_Row) + '_C' + IntToStr(n_Column);
  _Shape.Parent := Panel;
  _Shape.Left := round(n_Left  * Multiplr) + round(MarginWidth * Multiplr);
  _Shape.Top := round(n_Top * Multiplr) + round(MarginHeight * Multiplr);
  _Shape.Width := round(n_Width * Multiplr);
  _Shape.Height := round(n_Height * Multiplr);
  _Shape.Tag := n_State;
  _Shape.OnMouseDown := nil;//TTickeTControlMouseDown;
  _Shape.OnMouseMove := nil;//TTickeTControlMouseMove;
  _Shape.OnMouseUp := nil;//TTickeTControlMouseUp;
  _Shape.Hint := 'Name: ' + _Shape.Name + CRLF + 'Left: ' + IntToStr(_Shape.Left) + CRLF + 'Top: ' + IntToStr(_Shape.Top);
  _Shape.ShowHint := True;
end;

procedure CreateZal(List: TStrings; _Zal_Num: integer; _ggProgress: TGauge; _pnContainer: TPanel; ElemType: integer; Multiplr: real; _Autosize: boolean);
begin
  if Assigned(List) and (_Zal_Num >= 0) then
  begin
    CreateZal_Storage.fList := List;
    CreateZal_Storage.fZalNum := _Zal_Num;
    CreateZal_Storage.fggProgress := _ggProgress;
    CreateZal_Storage.fpnContainer := _pnContainer;
    CreateZal_Storage.fElemType := ElemType;
    CreateZal_Storage.fMultiplr := Multiplr;
    CreateZal_Storage.fAutosize := _Autosize;
    try
      CreateZal_Thread := TGenericThread.Create(tpNormal, @CreateZal_ThreadProcInit, @CreateZal_ThreadProc, @CreateZal_ThreadProcFinal, @CreateZal_Storage);
    except
    end;
  end;
end;

procedure CreateZal_ThreadProcInit(PointerToData: Pointer; var Terminated: boolean);
begin
  CreateZal_ThreadExecuted := true;
end;

procedure CreateZal_ThreadProcFinal(PointerToData: Pointer; var Terminated: boolean);
begin
  CreateZal_ThreadExecuted := false;
end;

procedure CreateZal_ThreadProc(PointerToData: Pointer; var Terminated: boolean);
var
  count, max_count: integer;
  Data: TCreateZalRec;
  s: string;
  i: integer;
  SC_Cell: TTickeTControl;
  SC: TShape;
  n_Row, n_Column: Byte;
  n_Left, n_Top, n_Width, n_Height, n_State: integer;
  Max_Width, Max_Height: integer;
begin
  if Assigned(PointerToData) then
  begin
    Data := TCreateZalRec(PointerToData^);
    if Assigned(Data.fList) and Assigned(Data.fpnContainer) and (Data.fList.Count > 1) then
    begin
      // init
      count := 0;
      if Assigned(Data.fggProgress) then
      begin
        if StepBy = 0 then
          StepBy := 1
        else
          if StepBy > 100 then
            StepBy := 100;
//        Data.fggProgress.Visible := true;
        Data.fggProgress.MinValue := 0;
        Data.fggProgress.Progress := Data.fggProgress.MinValue;
      end;
      // start
      Data.fpnContainer.Visible := false;
      if Assigned(Data.fggProgress) then
      begin
        max_count := Data.fList.Count;
        Data.fggProgress.MaxValue := max_count;
      end
      else
        max_count := 0;
      // Filter := s_Place_Zal + ' = ' + IntToStr(ZalNum);
      Max_Width := 0;
      Max_Height := 0;
      i := 0;
      s := Data.fList[i];
      inc(i);
      // length(s) must be 13
      if length(s) = 13 then
        if s[1] = global_var_prefix then
        begin
          n_Width := Str2Byte4(Copy(s, 2, 4));
          n_Height := Str2Byte4(Copy(s, 6, 4));
          // ZalNum := Str2Byte4(Copy(s, 10, 4));
          while i < Data.fList.Count do
          begin
            if Assigned(Data.fggProgress) then
            begin
              inc(count);
              if ((count * 100) div max_count) mod StepBy = 0 then
                Data.fggProgress.AddProgress(StepBy);
            end;
            SC_Cell := nil;
            SC := nil;
            s := Data.fList[i];
            inc(i);
            // length(s) must be 15
            if length(s) = 15 then
              if s[1] = local_var_prefix then
              begin
                n_Row := Str2Byte1(s[2]);
                n_Column := Str2Byte1(s[3]);
                n_Left := Str2Byte4(Copy(s, 4, 4));
                n_Top := Str2Byte4(Copy(s, 8, 4));
                n_State := Str2Byte4(Copy(s, 12, 4));
                case Data.fElemType of
                  0:
                  begin
                    CreateCell(Data.fZalNum, Data.fpnContainer, SC_Cell, Data.fMultiplr, n_Row, n_Column, n_Left, n_Top, n_Width, n_Height, n_State);
                    if Assigned(SC_Cell) then
                    begin
                      Max_Width := Max(Max_Width, SC_Cell.Left + SC_Cell.Width + round(MarginWidth * Data.fMultiplr));
                      Max_Height := Max(Max_Height, SC_Cell.Top + SC_Cell.Height + round(MarginHeight * Data.fMultiplr));
                    end;
                  end;
                  1:
                  begin
                    CreateSimpleCell(Data.fZalNum, Data.fpnContainer, SC, Data.fMultiplr, n_Row, n_Column, n_Left, n_Top, n_Width, n_Height, n_State);
                    if Assigned(SC) then
                    begin
                      Max_Width := Max(Max_Width, SC.Left + SC.Width + round(MarginWidth * Data.fMultiplr));
                      Max_Height := Max(Max_Height, SC.Top + SC.Height + round(MarginHeight * Data.fMultiplr));
                    end;
                  end;
                else
                end; // case
              end; // if
          end; // while
        end; // if
      if Assigned(Data.fggProgress) then
      begin
        Data.fggProgress.Progress := Data.fggProgress.MaxValue;
//        Data.fggProgress.Visible := false;
      end;
      if Data.fAutosize then
      begin
        Data.fpnContainer.Width := Max_Width;
        Data.fpnContainer.Height := Max_Height;
      end;
      Data.fpnContainer.Visible := true;
      // finish
    end; // if
  end; // if
  Terminated := true;
end;

procedure ImportZal(List: TStrings; ZalNum: integer; ggProgress: TGauge);
begin
  if Assigned(List) and (ZalNum >= 0) then
  begin
    ImportZal_Storage.fList := List;
    ImportZal_Storage.fZalNum := ZalNum;
    ImportZal_Storage.fggProgress := ggProgress;
    try
      ImportZal_Thread := TGenericThread.Create(tpNormal, @ImportZal_ThreadProcInit, @ImportZal_ThreadProc, @ImportZal_ThreadProcFinal, @ImportZal_Storage);
    except
    end;
  end;
end;

procedure ImportZal_ThreadProcInit(PointerToData: Pointer; var Terminated: boolean);
begin
  ImportZal_ThreadExecuted := true;
end;

procedure ImportZal_ThreadProcFinal(PointerToData: Pointer; var Terminated: boolean);
begin
  ImportZal_ThreadExecuted := false;
end;

procedure ImportZal_ThreadProc(PointerToData: Pointer; var Terminated: boolean);
var
  count, max_count: integer;
  Data: TImportZalRec;
  s: string;
  n_Row, n_Column: Byte;
  n_Left, n_Top, n_Width, n_Height, n_State: integer;
begin
  if Assigned(PointerToData) then
  begin
    Data := TImportZalRec(PointerToData^);
    if Assigned(Data.fList) then
    begin
      // init
      count := 0;
      if Assigned(Data.fggProgress) then
      begin
        if StepBy = 0 then
          StepBy := 1
        else
          if StepBy > 100 then
            StepBy := 100;
//        Data.fggProgress.Visible := true;
        Data.fggProgress.MinValue := 0;
        Data.fggProgress.Progress := Data.fggProgress.MinValue;
      end;
      // start
      with dm.tPlace do
      begin
        DisableControls;
        Filtered := false;
        Filter := s_Place_Zal + ' = ' + IntToStr(Data.fZalNum);
        Filtered := true;
        First;
        if Assigned(Data.fggProgress) then
        begin
          max_count := RecordCount;
          Data.fggProgress.MaxValue := max_count;
        end
        else
          max_count := 0;
        n_Width := Integer(CellWidth);
        n_Height := Integer(CellHeight);
        // length(s) must be 13
        s := global_var_prefix + Byte2Str4(n_Width) + Byte2Str4(n_Height) + Byte2Str4(Data.fZalNum);
        Data.fList.Add(s);
        while not Eof do
        begin
          try
            if Assigned(Data.fggProgress) then
            begin
              inc(count);
              if ((count * 100) div max_count) mod StepBy = 0 then
                Data.fggProgress.AddProgress(StepBy);
            end;
            n_Row := Byte(FieldValues[s_Place_ROW]);
            n_Column := Byte(FieldValues[s_Place_COL]);
            n_Left := Integer(FieldValues[s_Place_X]);
            n_Top := Integer(FieldValues[s_Place_Y]);
            n_State := Integer(FieldValues[s_Place_TYPE]);
            //FieldValues[s_Place_Zal]
            // length(s) must be 15
            s := local_var_prefix + Byte2Str1(n_Row) + Byte2Str1(n_Column) + Byte2Str4(n_Left) + Byte2Str4(n_Top) + Byte2Str4(n_State);
            Data.fList.Add(s);
          finally
            Next;
          end;
        end;
        if Assigned(Data.fggProgress) then
          Data.fggProgress.Progress := Data.fggProgress.MaxValue;
        Filtered := false;
        Filter := '';
        First;
        EnableControls;
      end;
      if Assigned(Data.fggProgress) then
//        Data.fggProgress.Visible := false;
      end;
      // finish
    end;
  Terminated := true;
end;

{$IFDEF uCells_DEBUG}
initialization
  DEBUGMess(0, 'uCells.Init');
{$ENDIF}

{$IFDEF uCells_DEBUG}
finalization
  DEBUGMess(0, 'uCells.Final');
{$ENDIF}

end.
