unit ClsOper100310;

interface

uses
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, ClsParametros,
  System.SysUtils, ClsCandidatoControl, ClsEnvioMCP, ClsRetornoMCP;

type
  T100310Envio = class(TEnvioMCP)
    Function MontaXMLEnvio(ArgCandidato: TCandidato): IXMLDocument;
  end;

  T100310Retorno = class(TRetornoMCP)
    Procedure MontaXMLRetorno(XMLDoc: IXMLDocument);
  end;

implementation

uses ClsFuncoes;

Procedure T100310Retorno.MontaXMLRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  NoAluno: IXMLNode;
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
        ParCandidato.IdCandidato := NoAluno.Attributes['id'];
        ParCandidato.CPFCandidato := NoAluno.ChildNodes.FindNode('cpf').Text;

        if StrToInt(NoAluno.ChildNodes.FindNode('renach').Text) > 0 then
          ParCandidato.RENACHCandidato := NoAluno.ChildNodes.FindNode
            ('renach').Text
        else
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
      end;

    end;

  except
    on E: Exception do
    begin

      if Debug then
        ArquivoLog.GravaArquivoLog('Opera��o 100300 - Retorno Padr�o - ' +
          E.Message);

      XMLDoc.Active := False;
    end;
  end;

end;

Function T100310Envio.MontaXMLEnvio(ArgCandidato: TCandidato): IXMLDocument;
var

  EnvioMCP: TEnvioMCP;
  XMLElementoEnvio: IXMLNode;
  XMLaluno: IXMLNode;
  XMLrenach: IXMLNode;
  XMLcpf: IXMLNode;
  XMLnome: IXMLNode;
  XMLMunicipio: IXMLNode;
  XMLnascimento: IXMLNode;
  XMLcurso: IXMLNode;
  XMLsexo: IXMLNode;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('100310', Result);

  XMLaluno := XMLElementoEnvio.AddChild('aluno');
  XMLaluno.Text := '';

  XMLcpf := XMLaluno.AddChild('cpf');
  XMLcpf.Text := ArgCandidato.CPFCandidato;
  XMLrenach := XMLaluno.AddChild('renach');
  XMLrenach.Text := ArgCandidato.RENACHCandidato;
  XMLnome := XMLaluno.AddChild('nome');
  XMLnome.Text := ArgCandidato.NomeCandidato;
  XMLMunicipio := XMLaluno.AddChild('cidade');
  XMLMunicipio.Text := ArgCandidato.Municipio_Candidato;
  XMLnascimento := XMLaluno.AddChild('nascimento');
  XMLnascimento.Text := ArgCandidato.Nascimento;
  XMLcurso := XMLaluno.AddChild('curso');
  XMLcurso.Text := ArgCandidato.CursoCandidato;
  XMLsexo := XMLaluno.AddChild('sexo');
  XMLsexo.Text := ArgCandidato.Sexo;

end;

end.
