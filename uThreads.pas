{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      : 
Author       : n0mad
Module       : uThreads.pas
Version      : 
Description  : 
Creation     : 12.10.2002 9:04:16
Installation : 


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit uThreads;

interface

uses
  Classes, Comctrls, Bugger;

type
  TGenericThreadProc = procedure (PointerToData: Pointer; var Terminated: boolean);
  TGenericThread = class(TThread)
  private
    FProcToInit: TGenericThreadProc;
    FProcToCall: TGenericThreadProc;
    FProcToFinal: TGenericThreadProc;
    FPointerToData: Pointer;
    FForceTerminated: boolean;
  protected
    procedure Execute; override; // Main thread execution
    procedure ProcInit;
    procedure ProcExecute;
    procedure ProcFinal;
  published
    constructor Create(PriorityLevel: TThreadPriority; ProcToInit, ProcToCall , ProcToFinal: TGenericThreadProc; PointerToData: Pointer);
    destructor Destroy; override;
  end;

implementation

{$INCLUDE Defs.inc}
{$IFDEF NO_DEBUG}
  {$UNDEF uThreads_DEBUG}
{$ENDIF}

uses
 Windows;

constructor TGenericThread.Create(PriorityLevel: TThreadPriority; ProcToInit, ProcToCall , ProcToFinal: TGenericThreadProc; PointerToData: Pointer);
begin
  inherited Create(true);      // Create thread suspended
  Priority := TThreadPriority(PriorityLevel); // Set Priority Level
  FreeOnTerminate := true; // Thread Free Itself when terminated
  FProcToInit := ProcToInit;    // Set reference
  FProcToCall := ProcToCall;    // Set reference
  FProcToFinal := ProcToFinal;    // Set reference
  FForceTerminated := false;
  FPointerToData := PointerToData;
  if @ProcToCall <> nil then
    Suspended := false;         // Continue the thread
end;

destructor TGenericThread.Destroy;
begin
  inherited Destroy;
end;


procedure TGenericThread.Execute; // Main execution for thread
begin
  if @FProcToInit <> nil then
    Synchronize(ProcInit);
  while not (Terminated or FForceTerminated) do
  begin
    if @FProcToCall <> nil then
      Synchronize(ProcExecute);
    // if Terminated is true, this loop exits prematurely so the thread will terminate
  end;
  if @FProcToFinal <> nil then
    Synchronize(ProcFinal);
end;

procedure TGenericThread.ProcInit;
begin
  if @FProcToInit <> nil then
    FProcToInit(FPointerToData, FForceTerminated);
end;

procedure TGenericThread.ProcExecute;
begin
  if @FProcToCall <> nil then
    FProcToCall(FPointerToData, FForceTerminated);
end;

procedure TGenericThread.ProcFinal;
begin
  if @FProcToFinal <> nil then
    FProcToFinal(FPointerToData, FForceTerminated);
end;

{$IFDEF uThreads_DEBUG}
initialization
  DEBUGMess(0, 'uThreads.Init');
{$ENDIF}

{$IFDEF uThreads_DEBUG}
finalization
  DEBUGMess(0, 'uThreads.Final');
{$ENDIF}

end.
