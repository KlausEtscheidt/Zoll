unit Worker;

interface

uses System.SysUtils,classes;

type TmyWorker = class(TThread)
     private
       j: Integer;
       ende: Boolean;
     public
       procedure Execute; override;
       procedure GetResult;
       procedure Start;
     end;

implementation

uses mainfrm;

procedure TmyWorker.Start;
begin
    mainForm.Edit1.Text:=mainForm.Edit1.Text+'#';
end;


procedure TmyWorker.GetResult;
begin
    mainForm.Label1.Caption:=IntToStr(j);
    ende:=mainForm.stop;
end;

procedure TmyWorker.Execute;
var
  i,c: Integer;
begin
  j:=1;
  c:=1;
  FreeOnTerminate:=True;
  Synchronize(Start);

  for i:=1 to 90000000 do
  begin
    if Terminated then break;
    Inc(j, Round(Abs(Sin(Sqrt(i)))));
    Inc(c);
    if c=1000 then
    begin
      Synchronize(GetResult);
      c:=1;
      if ende then
        break;
    end;

  end;

  Synchronize(procedure begin mainForm.Edit1.Text:='Ende.' end)
end;

end.
