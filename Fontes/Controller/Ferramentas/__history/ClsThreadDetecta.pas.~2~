unit ClsThreadDetecta;

interface

uses
  System.Classes, System.SysUtils, IdCoderMIME, System.JSON,
  Datasnap.DSClientRest, ClsFuncoes, ClsListaBloqueio;

type

  TThrdDetecta = class(TThread)

  private
    FTipo: Integer;
    FNumLista: Integer;
    function ListWMI(ListTmp: TStringList): TStringList;
  public
    Property Tipo: Integer read FTipo Write FTipo;
    Property NumLista: Integer read FNumLista Write FNumLista;
    procedure Execute; Override;
    destructor Destroy;
    constructor Create;
  end;

var
  ThrdMAC: TThrdDetecta;
  ThrdSO: TThrdDetecta;
  ThrdAplicativos: TThrdDetecta;
  ThrdDispositivos: TThrdDetecta;
  ThrdProcessos: TThrdDetecta;
  ThrdServicos: TThrdDetecta;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

  Synchronize(UpdateCaption);

  and UpdateCaption could look like,

  procedure MainThread.UpdateCaption;
  begin
  Form1.Caption := 'Updated in a thread';
  end;

  or

  Synchronize(
  procedure
  begin
  Form1.Caption := 'Updated in thread via an anonymous method'
  end
  )
  );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ MainThread }
destructor TThrdDetecta.Destroy;
begin
  inherited Destroy;
end;

constructor TThrdDetecta.Create;
begin
  FreeOnTerminate := True;
  inherited Create(True);
end;

procedure TThrdDetecta.Execute;
begin

  case FNumLista of
    1:
      ParListaAplicativos.Assign(ListWMI(ParListaAplicativos.Classe));
    2:
      begin
        ParListaDispositivos.Clear;
        ParListaDispositivos.Assign(ListWMI(ParListaDispositivos.Classe));
      end;
    3:
      begin
        ParListaServicosAtivos.Clear;
        ParListaServicosAtivos.Assign(ListWMI(ParListaServicosAtivos.Classe));
      end;
    4:
      begin
        ParListaProcessosAtivos.Clear;
        ParListaProcessosAtivos.Assign(ListWMI(ParListaProcessosAtivos.Classe));
      end;
    5:
      begin
        if ParMacAdress.Classe.Count = 0 then
          ParMacAdress.Classe.Add('Win32_NetworkAdapter');
        ParMacAdress.Assign(ListWMI(ParMacAdress.Classe));
      end;
    6:
      begin
        if ParSistemaOperacional.Classe.Count = 0 then
          ParSistemaOperacional.Classe.Add('Win32_OperatingSystem');
        ParSistemaOperacional.Assign(ListWMI(ParSistemaOperacional.Classe));
      end;
  end;

  // case FNumLista of
  // 1:ParListaAplicativos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaAplicativos.ClassName+'.txt');
  // 2:ParListaDispositivos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaDispositivos.ClassName+'.txt');
  // 3:ParListaServicosAtivos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaServicosAtivos.ClassName+'.txt');
  // 4:ParListaProcessosAtivos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaProcessosAtivos.ClassName+'.txt');
  // 5:ParMacAdress.SaveToFile(ExtractFilePath(ParamStr(0))+ParMacAdress.ClassName+'.txt');
  // 6:ParSistemaOperacional.SaveToFile(ExtractFilePath(ParamStr(0))+ParSistemaOperacional.ClassName+'.txt');
  // end;

end;

function TThrdDetecta.ListWMI(ListTmp: TStringList): TStringList;
var
  tmp: TStringList;
  I: Integer;
  J: Integer;
begin

  Result := TStringList.Create;
  Result.Clear;

  tmp := TStringList.Create;

  for I := 0 to ListTmp.Count - 1 do
  begin
    tmp.Clear;
    tmp.Assign(GetListSistemResource(ListTmp));
    for J := 0 to tmp.Count - 1 do
      Result.Add(tmp[J]);
  end;

end;

end.
