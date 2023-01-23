unit ClsMonitoramentoRTSP;

interface

uses
  Winapi.Windows, Vcl.StdCtrls, System.Classes, System.SysUtils, System.Win.ComObj,
  System.Win.ScktComp, System.IOUtils, ClsFuncoes, ClsMonitoramentoRTSPControl,
  ClsConexaoFerramentas, ClsParametros;

type

  TMonitoramentoClntSckt = class(TClientSocket)
  Private    
  
  public

    function SendSocketComand(Arg: string): string;
  end;

implementation

function TMonitoramentoClntSckt.SendSocketComand(Arg: string): string;
var
  intReturnCode: integer;
  Conttimeout: integer;
begin

  Result := '';

  try

    if Self.Active then
      Self.Active := False;

    Self.Host := ParMonitoramentoRTSP.Endereco_Servidor;
    Self.Port := ParMonitoramentoRTSP.Porta_Servidor;

    Self.ClientType := ctBlocking;

    Self.Open;
    Conttimeout := 1;
    intReturnCode := Self.socket.SendText(Arg);

  except
    on E: Exception do
    begin
      intReturnCode := 0;

      ArquivoLog.GravaArquivoLog('Monitoramento - SendSocketComand => Argumento: ' + Arg + ' Host: ' + Self.Host + #13 + 'Porta: ' + IntToStr(Self.Port) +
        ' Retorno: ' + IntToStr(intReturnCode) + ' Falha: ' + E.Message);
    end;
  end;

  if intReturnCode > 0 then { receive the answer }
  begin

    while (Result = '') do { iterate until no more data }
      if Self.socket.ReceiveLength > 0 then
      begin
        Result := Trim(Self.socket.ReceiveText); { try to receive some data }
      end
      else
      begin

        if Conttimeout = 4 then
          Break
        else
        begin
          Sleep(1000);
          Inc(Conttimeout);
        end;

      end;

    ArquivoLog.GravaArquivoLog('Monitoramento - Argumento: ' + Arg + ' Host: ' + Self.Host + #13 + 'Retorno: ' + Result);

  end;

end;

end.
