unit ClsRetornoMCP;

interface

uses
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, System.Classes;

type

  TRetornoMCP = class
    RetonoXML: IXMLDocument;
  protected
    FCodigo: string;
    FMensagem: string;
    FMensagemTipo: string;
    Procedure Retorno(Retorno: IXMLDocument);
  Public
    property codigo: String read FCodigo write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property MensagemTipo: String read FMensagemTipo write FMensagemTipo;

    function IsValid: Boolean;

  end;

implementation

{ TRetorno }

Procedure TRetornoMCP.Retorno(Retorno: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
begin

  try
    Retorno.Active := False;
    Retorno.Active := True;

    NoRetorno := Retorno.ChildNodes.FindNode('retorno');

    if NoRetorno <> nil then
    begin

      if NoRetorno.HasAttribute('codigo') then
        FCodigo := NoRetorno.Attributes['codigo'];

      if NoRetorno.ChildNodes.FindNode('mensagem') <> nil then
      begin

        NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem')
          .ChildNodes.FindNode('texto');
        FMensagem := NoMensagem.Text;

        if NoRetorno.ChildNodes.FindNode('mensagem').HasAttribute('tipo') then
          MensagemTipo := NoRetorno.ChildNodes.FindNode('mensagem')
            .Attributes['tipo']
        else
          MensagemTipo := 'I';

        if NoRetorno.ChildNodes.FindNode('mensagem').HasAttribute('id') then
          if StrToIntDef(NoRetorno.ChildNodes.FindNode('mensagem').Attributes
            ['id'], 1) > 1 then
            FCodigo := 'B' + NoRetorno.ChildNodes.FindNode('mensagem')
              .Attributes['id'];

      end;

      if (FCodigo <> 'B000') and (NoRetorno.ChildNodes.FindNode('token') <> nil)
      then
      begin

        NoMensagem := NoRetorno.ChildNodes.FindNode('token');
        FMensagem := NoMensagem.Text;

        if NoMensagem.HasAttribute('tipo') then
          MensagemTipo := NoMensagem.Attributes['tipo']
        else
          MensagemTipo := 'I';

      end;

      RetonoXML := TXMLDocument.Create(nil);
      RetonoXML.Xml.Text := Retorno.Xml.Text;

    end;

  except
    on E: Exception do
    begin
      Retorno.Active := False;
    end;
  end;

end;

function TRetornoMCP.IsValid: Boolean;
begin

  if FCodigo = 'B000' then
    Result := True
  else
    Result := False;

end;

end.
