unit ClsOperacoesControl;

interface

uses
  // Class Systema
  System.SysUtils,

  // Class de Objetos
  ClsCandidatoControl, ClsProva, ClsParametros, ClsServidorControl,

  // Class de Operações
  ClsOper200100, ClsOper200110, ClsOper200500, ClsOper200200, ClsOper200710, ClsOperacoes;

type

  T200100 = class
    Retorno: T200100Retorno;
    function Consulta200100: T200100Retorno;
  end;

  T200200 = class
    Retorno: T200200Retorno;
    function Consulta200200: T200200Retorno;
  end;

  T200500 = class
    Retorno: T200500Retorno;
    function Consulta200500: T200500Retorno;
  end;

  T200110 = class
    Retorno: T200110Retorno;
    function Consulta200110: T200110Retorno;
  end;

  T200710 = class
    Retorno: T200710Retorno;
    function Consulta200710: T200710Retorno;
  end;

implementation

{ T200710 }

function T200710.Consulta200710: T200710Retorno;
var
  Consulta: MainOperacao;
  Oper200710Env: T200710Envio;
begin

  Consulta := MainOperacao.Create(nil, '200710');
  Oper200710Env := T200710Envio.Create;
  Result := T200710Retorno.Create;
  Result.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper200710Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
    ParCandidato.TipoProva, ParCandidato.IdCandidato, ParCandidato.CPFCandidato)));

end;

{ T200100 }

function T200100.Consulta200100: T200100Retorno;
var
  Consulta: MainOperacao;
  Oper200100Env: T200100Envio;
begin

  // Efetuar a operação 200100
  Consulta := MainOperacao.Create(nil, '200100');
  Oper200100Env := T200100Envio.Create;
  Result := T200100Retorno.Create;
  Result.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper200100Env.MontaXMLEnvio(ParCandidato.TipoProva, ParCandidato.IdCandidato,
    Parametros.Identificacao, Parametros.Computador)));

end;

{ T200110 }

function T200110.Consulta200110: T200110Retorno;
var
  Consulta: MainOperacao;
  Oper200110Env: T200110Envio;
begin

  Consulta := MainOperacao.Create(nil, '200110');
  Oper200110Env := T200110Envio.Create;
  Result := T200110Retorno.Create;
  Result.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper200110Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
    ParCandidato.TipoProva)));

end;

{ T200200 }

function T200200.Consulta200200: T200200Retorno;
var
  Consulta: MainOperacao;
  Oper200200Env: T200200Envio;
begin

  // Efetuar a operação 200200
  Consulta := MainOperacao.Create(nil, '200200');
  Oper200200Env := T200200Envio.Create;
  Result := T200200Retorno.Create;
  Result.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper200200Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
    ParCandidato.TipoProva)));

end;

{ T200500 }

function T200500.Consulta200500: T200500Retorno;
var
  Consulta: MainOperacao;
  Oper200500Env: T200500Envio;
begin

  Consulta := MainOperacao.Create(nil, '200500');
  Oper200500Env := T200500Envio.Create;
  Result := T200500Retorno.Create;
  Result.MontaRetorno(Consulta.Consultar(IntToStr(ParServidor.ID_Sistema), Oper200500Env.MontaXMLEnvio(IntToStr(ParQuestionario.Id_prova),
    ParCandidato.TipoProva, ParCandidato.Bloqueado, ParCandidato.Foto)));

end;

end.
