unit Unit1;

interface

uses System.IOUtils,System.SysUtils, System.Classes, Data.Win.ADODB,
ActiveX,
FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  IAlleQrys = interface
      procedure TuIrgendwas(Wert: String);
      function LiesnRecords: Integer;
      procedure SchreibenRecords(NeuerWert: Integer);
      property nRecords: Integer read LiesnRecords write SchreibenRecords;
    end;

  TADOQry = class(TADOQuery, IAlleQrys)
      procedure TuIrgendwas(Wert: String);
    private
      var FnRecords: Integer;
      function LiesnRecords: Integer;
      procedure SchreibenRecords(NeuerWert: Integer);
    public
      property nRecords: Integer read LiesnRecords write SchreibenRecords;
  end;

  TFDQry = class(TFDQuery, IAlleQrys)
      procedure TuIrgendwas(Wert: String);
    private
      var FnRecords: Integer;
      function LiesnRecords: Integer;
      procedure SchreibenRecords(NeuerWert: Integer);
    public
      property nRecords: Integer read LiesnRecords write SchreibenRecords;
  end;

  procedure TestIt();

implementation

    procedure TADOQry.TuIrgendwas(Wert: String);
    begin

    end;

    function TADOQry.LiesnRecords: Integer;
    begin
      Result:=FnRecords;
    end;

    procedure TADOQry.SchreibenRecords(NeuerWert: Integer);
    begin
        FnRecords:=NeuerWert;
    end;

    procedure TFDQry.TuIrgendwas(Wert: String);
    begin

    end;

    function TFDQry.LiesnRecords: Integer;
    begin
      Result:=2*FnRecords;
    end;

    procedure TFDQry.SchreibenRecords(NeuerWert: Integer);
    begin
        FnRecords:=NeuerWert;
    end;

  procedure TestIt();
  var
    Qry1,Qry2:IAlleQrys;
    meineFDQRy:TFDQry;
    meineADOQRy:TADOQry;
    var n:Integer;
  begin
     activeX.CoInitialize(nil);
     meineFDQRy:=TFDQry.Create(nil);
     meineADOQRy:=TADOQry.Create(nil);
     meineFDQRy.nRecords:=10;
     meineADOQRy.nRecords:=10;
     n:=meineFDQRy.nRecords;
     //Writeln('FD ' + Str(meineFDQRy.nRecords) + 'ADO ' + meineADOQRy.nRecords);
     Writeln( Format('FD %d ADO %d', [n,meineADOQRy.nRecords]) );
    Qry1:=meineFDQRy;
    Qry2:=meineADOQRy;
     Writeln( Format('FD %d ADO %d', [Qry1.nRecords,Qry2.nRecords]) );

  end;

end.
