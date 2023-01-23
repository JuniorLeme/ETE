unit ClsOper100300;

interface

uses
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, System.SysUtils,
  ClsParametros,
  ClsEnvioMCP, ClsRetornoMCP, ClsCandidatoControl, System.Classes;

type

  T100300Retorno = class(TRetornoMCP)
    Procedure MontaXMLRetorno(XMLDoc: IXMLDocument);
  end;

  T100300Envio = class(TEnvioMCP)
    function MontaXMLEnvio(Arg: string): IXMLDocument;
  end;

implementation

uses ClsFuncoes;

Procedure T100300Retorno.MontaXMLRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoAluno: IXMLNode;
  NoPermissoes: IXMLNode;
begin

  try

    Self.Retorno(XMLDoc);

    if Self.IsValid then
    begin
      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');

      if NoRetorno.HasAttribute('codigo') then
        codigo := NoRetorno.Attributes['codigo'];

      NoAluno := NoRetorno.ChildNodes.FindNode('aluno');
      if NoAluno <> nil then
      begin

        if ParCandidato = nil then
          ParCandidato := TCandidato.Create;

        ParCandidato.IdCandidato := NoAluno.Attributes['id'];
        ParCandidato.RENACHCandidato := NoAluno.ChildNodes.FindNode
          ('renach').Text;
        ParCandidato.CPFCandidato := NoAluno.ChildNodes.FindNode('cpf').Text;

        if ParCandidato.RENACHCandidato = '' then
          ParCandidato.RENACHCandidato := ParCandidato.CPFCandidato;

        ParCandidato.NomeCandidato := NoAluno.ChildNodes.FindNode('nome').Text;
        ParCandidato.CursoCandidato := NoAluno.ChildNodes.FindNode
          ('curso').Text;
        ParCandidato.Modalidade := NoAluno.ChildNodes.FindNode
          ('modalidade').Text;
        ParCandidato.Nascimento := NoAluno.ChildNodes.FindNode
          ('nascimento').Text;
        ParCandidato.Sexo := NoAluno.ChildNodes.FindNode('sexo').Text;
        ParCandidato.Municipio_Candidato := NoAluno.ChildNodes.FindNode
          ('municipio').Text;
        ParCandidato.Excecao := NoAluno.ChildNodes.FindNode('excecao').Text;
        ParCandidato.RegistroPresenca := NoAluno.ChildNodes.FindNode
          ('registro').Text;

        NoPermissoes := NoAluno.ChildNodes.FindNode('permissoes');
        if NoPermissoes <> nil then
        begin
          ParCandidato.Prova := NoPermissoes.ChildNodes.FindNode('prova').Text;
          ParCandidato.Simulado := NoPermissoes.ChildNodes.FindNode
            ('simulado').Text;
        end
        else
        begin
          ParCandidato.Prova := 'S';
          ParCandidato.Simulado := 'S';
        end;
      end;
    end;

  except
    on E: Exception do
    begin

      if Debug then
        ArquivoLog.GravaArquivoLog('Operação 100300 - Retorno Padrão - ' +
          E.Message);

      XMLDoc.Active := False;
    end;
  end;

end;

function T100300Envio.MontaXMLEnvio(Arg: string): IXMLDocument;
var
  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLaluno: IXMLNode;
  XMLrenach: IXMLNode;
  XMLcpf: IXMLNode;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('100300', Result);

  XMLaluno := XMLElementoEnvio.AddChild('aluno');
  XMLaluno.Text := '';

  if Length(Arg) = 11 then
  begin
    XMLcpf := XMLaluno.AddChild('cpf');
    XMLcpf.Text := Arg;
  end;

  if Length(Arg) = 9 then
  begin
    XMLrenach := XMLaluno.AddChild('renach');
    XMLrenach.Text := Arg;
  end;

end;

end.
