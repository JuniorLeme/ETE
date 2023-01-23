unit ClsOperacoesRest;

interface

uses
  System.Classes, System.SysUtils, Vcl.StdCtrls, Vcl.Graphics, Vcl.Controls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Forms, Vcl.Dialogs, REST.Client, System.JSON;

type
  TOperacaoRestful = class(TComponent)
  private
    FRetorno: string;
  protected
  public
    property Retorno: string read FRetorno write FRetorno;
    function ExecutarConsultar(strURL: string; strEnvio: string;
      Aviso: String = ''): string;
  end;

implementation

uses ClsFuncoes, FrmAvisoConexao, ClsConexaoFerramentas, REST.Types,
  ClsRetorno.SEITran;

function TOperacaoRestful.ExecutarConsultar(strURL: string; strEnvio: string;
  Aviso: String = ''): string;
var
  restClient: TRESTClient;
  restRequest: TRESTRequest;
  restResponse: TRESTResponse;
begin
  Result := '';

  restClient := TRESTClient.Create('');
  restRequest := TRESTRequest.Create(nil);
  restResponse := TRESTResponse.Create(nil);

  try
    try
      if (Not strEnvio.IsEmpty) then
      begin
        restRequest.Client := restClient;
        restRequest.Response := restResponse;
        restClient.BaseURL := strURL;
        restRequest.Method := TRESTRequestMethod.rmPOST;
        restRequest.Body.Create;
        restRequest.Body.Add(strEnvio, ctAPPLICATION_JSON);

        restRequest.Execute;
        FRetorno := restRequest.Response.Content;

        Result := FRetorno;
      end;
    except
      on E: ERESTException do
      begin
        FRetorno := E.Message;
      end;

      on E: ERequestError do
      begin
        FRetorno := E.Message;
      end;
    end;

  finally
    if FRetorno = EmptyStr then
      FRetorno := restRequest.Response.ErrorMessage;

    FreeAndNil(restClient);
    FreeAndNil(restResponse);
    FreeAndNil(restRequest);
  end;
end;

end.
