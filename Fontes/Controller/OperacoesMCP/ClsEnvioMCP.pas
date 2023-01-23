unit ClsEnvioMCP;

interface

uses
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  ClsFuncoes, ClsParametros, ClsServidorControl, ClsCFCControl;

type
  TEnvioMCP = class
  strict private
    class var FInstance: TEnvioMCP;
  private
    class procedure ReleaseInstance();
  public
    class function GetInstance(): TEnvioMCP;
    function GetEnvioMCP(Foperacao: String; XMLDoc: IXMLDocument): IXMLNode;
  end;

implementation

{ TEnvioMCP }

function TEnvioMCP.GetEnvioMCP(Foperacao: String; XMLDoc: IXMLDocument)
  : IXMLNode;
begin

  Result := XMLDoc.AddChild('envio');
  Result.Text := ' ';

  if ParServidor = nil then
    Result.Attributes['servidor'] := '0'
  else
    Result.Attributes['servidor'] := ParServidor.ID_Sistema;

  if ParCFC = nil then
    Result.Attributes['usuario'] := '0'
  else
    Result.Attributes['usuario'] := ParCFC.id_cfc;

  Result.Attributes['operacao'] := Foperacao;

  Result.Attributes['identificacao'] := LRPad(parametros.Identificacao, 6,
    '0', 'L');

  Result.Attributes['versao'] := GetVersaoArq;

end;

class function TEnvioMCP.GetInstance: TEnvioMCP;
begin
  if not Assigned(Self.FInstance) then
    Self.FInstance := TEnvioMCP.Create;
  Result := Self.FInstance;
end;

class procedure TEnvioMCP.ReleaseInstance;
begin
  if Assigned(Self.FInstance) then
    Self.FInstance.Free;
end;

initialization

finalization

TEnvioMCP.ReleaseInstance();

end.
