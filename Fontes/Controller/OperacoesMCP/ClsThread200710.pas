unit ClsThread200710;

interface

uses
  Winapi.Windows, Vcl.StdCtrls, System.Classes, System.SysUtils,
  System.Win.ComObj,
  System.Win.ScktComp, System.IOUtils, ClsFuncoes, ClsOper200710, ClsOperacoes,
  ClsCandidatoControl, ClsServidorControl, ClsParametros, ClsCFCControl,
  ClsListaBloqueio,
  ClsDetecta, Vcl.Dialogs, ClsQuestionario;

type
  TThread200710 = class(TThread)
  protected
    procedure Execute; override;
    procedure HandleThreadException;
    procedure ThreadDone;
  private
    ReturnExecut: TNotifyEvent;
  public
    constructor Create(Return: TNotifyEvent);
    destructor Destroy; override;
  end;

implementation

destructor TThread200710.Destroy;
begin
  inherited Destroy;
end;

constructor TThread200710.Create(Return: TNotifyEvent);
begin
  ReturnExecut := Return;
  FreeOnTerminate := True;
  inherited Create(True);
  Execute;
end;

procedure TThread200710.Execute;
var

  Consulta: MainOperacao;
  Oper200710Env: T200710Envio;
  Oper200710Ret: T200710Retorno;

begin

  Self.Priority := tpNormal;

  try

    try

      CoInitializeEx(nil, 2);

      if ParQuestionario.tempo > 0 then
      begin

        ArquivoLog.GravaArquivoLog('Verifica Bloqueio');

        if ((ParCandidato.TipoProva = 'P') and
          (ParDetecta.Verifica_Processos_Quantidade_Prova > 0)) or
          ((ParCandidato.TipoProva = 'S') and
          (ParDetecta.Verifica_Processos_Quantidade_simulado > 0)) then
        begin

          ParListaDispositivos.Assign
            (GetListSistemResource(ParListaDispositivos.Classe));

          ParListaServicosAtivos.Assign
            (GetListSistemResource(ParListaServicosAtivos.Classe));

          ParListaProcessosAtivos.Assign
            (GetListSistemResource(ParListaProcessosAtivos.Classe));

          Consulta := MainOperacao.Create(nil, '200710');
          Oper200710Env := T200710Envio.Create;
          Oper200710Ret := T200710Retorno.Create;
          Oper200710Ret.MontaRetorno
            (Consulta.Consultar(IntToStr(ParServidor.ID_Sistema),
            Oper200710Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
            ParCandidato.TipoProva, ParCandidato.IdCandidato,
            ParCandidato.CPFCandidato)));

          if not Oper200710Ret.IsValid then
          begin

            if (Oper200710Ret.MensagemTipo = 'E') or
              (Oper200710Ret.MensagemTipo = 'R') then
            begin

              ParDetecta.MensagemTipo := Oper200710Ret.MensagemTipo;

              if Oper200710Ret.MensagemTipo = 'R' then
                ParDetecta.MensagemDetecta :=
                  Oper200710Ret.MensagemDetecta.Text;

              if Oper200710Ret.MensagemTipo = 'E' then
                ParDetecta.MensagemDetecta := Oper200710Ret.Mensagem;

            end;

          end;

        end;

      end;

    except
      on E: Exception do
      begin

        ArquivoLog.GravaArquivoLog('Thread Cronometro - Execute: ' + E.Message);
        Self.Terminate;

        if not(ExceptObject is EAbort) then
          Synchronize(HandleThreadException);

      end;

    end;

  finally
    // Tell the main form that we are done
    Synchronize(ThreadDone);
  end;

end;

procedure TThread200710.HandleThreadException;
begin
  ArquivoLog.GravaArquivoLog('Opera��o - 200710');
end;

procedure TThread200710.ThreadDone;
begin
  ReturnExecut(Self);
  Self.Terminate;
end;

end.
