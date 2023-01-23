unit ClsThread;

interface
  uses
    System.Classes, System.SysUtils, IdCoderMIME, ClsFuncoes, ClsListaBloqueio,
    System.JSON, Datasnap.DSClientRest, ClsWMI;

  type

  TThrdX9 = class(TThread)

  private
    FEnvio : TJSONObject;
    FTipo : Integer;
    FNumLista: Integer;
    function ListWMI(ListTmp: TStringList): TStringList;
  public
    Property Envio : TJSONObject read FEnvio Write FEnvio;
    Property Tipo : Integer read FTipo Write FTipo;
    Property NumLista : Integer read FNumLista Write FNumLista;
    procedure Execute; Override;
  end;

var
  ThrdMAC : TThrdX9;
  ThrdSO : TThrdX9;
  ThrdAplicativos : TThrdX9;
  ThrdDispositivos : TThrdX9;
  ThrdProcessos : TThrdX9;
  ThrdServicos : TThrdX9;

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
procedure TThrdX9.Execute;
begin

  case Tipo of

    1:
    begin

      Synchronize(
        procedure
        begin
          case FNumLista of
            1:ParListaAplicativos.Assign(ListWMI(ParListaAplicativos.Classe));
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

//          case FNumLista of
//            1:ParListaAplicativos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaAplicativos.ClassName+'.txt');
//            2:ParListaDispositivos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaDispositivos.ClassName+'.txt');
//            3:ParListaServicosAtivos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaServicosAtivos.ClassName+'.txt');
//            4:ParListaProcessosAtivos.SaveToFile(ExtractFilePath(ParamStr(0))+ParListaProcessosAtivos.ClassName+'.txt');
//            5:ParMacAdress.SaveToFile(ExtractFilePath(ParamStr(0))+ParMacAdress.ClassName+'.txt');
//            6:ParSistemaOperacional.SaveToFile(ExtractFilePath(ParamStr(0))+ParSistemaOperacional.ClassName+'.txt');
//          end;

        end
      );

      FTipo := 9;
    end;

    9: Self.Terminate;
    end;

end;

function TThrdX9.ListWMI(ListTmp: TStringList): TStringList;
var
  WMI: TWMI;
  tmp: TStringList;
  I: Integer;
  J: Integer;
begin

  Result := TStringList.Create;
  Result.Clear;

  tmp := TStringList.Create;

  for I := 0 to ListTmp.Count -1 do
  begin
    tmp.Clear;
    tmp.Assign (WMI.GetListSistemResource(ListTmp[I]));
    for J := 0 to tmp.Count -1 do
      Result.Add(tmp[J]);
  end;

end;


end.
