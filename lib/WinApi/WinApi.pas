unit WinApi;

interface

uses System.SysUtils,  Winapi.Windows;

function GetCurrentVersion(level: Integer): String;
function GetWinUsername: String;

implementation

function GetWinUsername: String;
var
  Buffer: array[0..256] of Char; // UNLEN (= 256) +1 (definiert in Lmcons.h)
  Size: DWord;
begin
  Size := length(Buffer); // length stat SizeOf, da Anzahl in TChar und nicht BufferSize in Byte
   if not Winapi.Windows.GetUserName(Buffer, Size) then
    RaiseLastOSError;
  SetString(Result, Buffer, Size - 1);
end;

function GetCurrentVersion(level: Integer): String;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  VersIntM,VersIntL:Integer; //MSW und LSW des API-CAll-Ergebnisses
  V1,V2,V3,V4:Integer;      //Haupt- u Nebenversion, Ausgabe und Build-Nr
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  VersIntM:= VerValue^.dwFileVersionMS;
  VersIntL:= VerValue^.dwFileVersionLS;
  V1:=VersIntM shr 16;
  V2:=VersIntM and $FFFF;
  V3:=VersIntL shr 16;
  V4:=VersIntL and $FFFF;
  if level=2 then
     Result := Format('%d.%d',[V1,V2]) ;
  if level=3 then
     Result := Format('%d.%d.%d',[V1,V2,V3]) ;
  if level=4 then
     Result := Format('%d.%d.%d.%d',[V1,V2,V3,V4]) ;
  FreeMem(VerInfo, VerInfoSize);
end;

end.
