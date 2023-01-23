unit ClsOper100310;

interface

uses ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, ClsParametros, System.Classes;

type
  Operacao100310 = class(TComponent)
  protected
    Fid_cfc: string;
    FID_Aluno: string;
    Fcpf: string;
    Fnome: string;
    Frenach: string;
    FNome_Aluno: string;
    FCurso: string;
    FModalidade: string;
    FNascimento: string;
    FSexo: string;
    FMunicipio: string;
    FExcecao: string;
    FRegistro: string;
    Fcodigo: string;
    Fmensagem: string;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;
    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure Setrenach(Parrenach: String);
    procedure Setcpf(Parcpf: String);
    procedure SetNome_Aluno(ParNome_Aluno: String);
    procedure SetCurso(ParCurso: String);
    procedure SetNascimento(ParNascimento: String);
    procedure SetSexo(ParSexo: String);
    procedure SetMunicipio(ParMunicipio: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public

    property id_cfc: String read Fid_cfc write Fid_cfc;
    property ID_Aluno: String read FID_Aluno write FID_Aluno;
    property cpf: String read Fcpf write Setcpf;
    property renach: String read Frenach write Setrenach;
    property nome_Aluno: String read FNome_Aluno write SetNome_Aluno;
    property Curso: String read FCurso write SetCurso;
    property Modalidade: String read FModalidade write FModalidade;
    property Nascimento: String read FNascimento write SetNascimento;
    property Sexo: String read FSexo write SetSexo;
    property Municipio: String read FMunicipio write SetMunicipio;
    property Excecao: String read FExcecao write FExcecao;
    property Registro: String read FRegistro write FRegistro;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

uses ClsFuncoes;

Procedure Operacao100310.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  NoAluno: IXMLNode;
begin
  try
    // Aqui emplemeta a rotina de retorno
    if (Operacao.XMLRetorno <> '') then
    begin
      LerXML := NewXMLDocument;
      try
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except
        on E: Exception do
        begin
          GravaArquivoLog(self,'Operação 100300 - Retorno Padrão - ' + E.Message);
          LerXML.Active := False;
          LerXML.Xml.Clear;
          LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
          LerXML.Active := True;
        end;
      end;
      if LerXML.Xml.Text <> '' then
      begin
        NoRetorno := LerXML.ChildNodes.FindNode('retorno');
        if NoRetorno <> nil then
        begin
          if NoRetorno.HasAttribute('codigo') then
            if NoRetorno.Attributes['codigo'] <> 'B000' then
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem')
                .ChildNodes.FindNode('texto');
              if NoMensagem <> nil then
                mensagem := NoMensagem.Text;
            end
            else
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
              NoAluno := NoRetorno.ChildNodes.FindNode('aluno');
              if NoAluno <> nil then
              begin
                ID_Aluno := NoAluno.Attributes['id'];
                renach := NoAluno.ChildNodes.FindNode('renach').Text;
                cpf := NoAluno.ChildNodes.FindNode('cpf').Text;
                nome_Aluno := NoAluno.ChildNodes.FindNode('nome').Text;
                Curso := NoAluno.ChildNodes.FindNode('curso').Text;
                Modalidade := NoAluno.ChildNodes.FindNode('modalidade').Text;
                Nascimento := NoAluno.ChildNodes.FindNode('nascimento').Text;
                Sexo := NoAluno.ChildNodes.FindNode('sexo').Text;
                Municipio := NoAluno.ChildNodes.FindNode('municipio').Text;
                Excecao := NoAluno.ChildNodes.FindNode('excecao').Text;
                Registro := NoAluno.ChildNodes.FindNode('registro').Text;
              end;
            end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      GravaArquivoLog(self,'Operação 100300 - Retorno Padrão - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;
  FRetorno(Self);
end;

procedure Operacao100310.Setrenach(Parrenach: String);
begin
  Frenach := Parrenach;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

procedure Operacao100310.Setcpf(Parcpf: String);
begin
  Fcpf := Parcpf;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

procedure Operacao100310.SetNome_Aluno(ParNome_Aluno: String);
begin
  FNome_Aluno := ParNome_Aluno;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

procedure Operacao100310.SetCurso(ParCurso: String);
begin
  FCurso := ParCurso;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

procedure Operacao100310.SetNascimento(ParNascimento: String);
begin
  FNascimento := ParNascimento;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

procedure Operacao100310.SetSexo(ParSexo: String);
begin
  FSexo := ParSexo;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

procedure Operacao100310.SetMunicipio(ParMunicipio: String);
begin
  FMunicipio := ParMunicipio;
  if (Frenach <> '') and (Fcpf <> '') and (FNome_Aluno <> '') and (FCurso <> '')
    and (FMunicipio <> '') and (FNascimento <> '') and (FSexo <> '') then
    if codigo = '' then
      MontaXMLEnvio(Self);
end;

Procedure Operacao100310.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLaluno: IXMLNode;
  XMLrenach: IXMLNode;
  XMLcpf: IXMLNode;
  XMLnome: IXMLNode;
  XMLMunicipio: IXMLNode;
  XMLnascimento: IXMLNode;
  XMLcurso: IXMLNode;
  XMLsexo: IXMLNode;
  XmlTexto: string;
begin
  if (Frenach = '') or (Fcpf = '') then
  begin
    codigo := 'B999';
    mensagem := 'Falta parametros para executar a consulta!';
  end;

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;
  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;;
  XMLElementoEnvio.Attributes['usuario'] := id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '100310';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;
  XMLaluno := XMLElementoEnvio.AddChild('aluno');
  XMLaluno.Text := '';

  XMLcpf := XMLaluno.AddChild('cpf');
  XMLcpf.Text := cpf;
  XMLrenach := XMLaluno.AddChild('renach');
  XMLrenach.Text := renach;
  XMLnome := XMLaluno.AddChild('nome');
  XMLnome.Text := nome_Aluno;
  XMLMunicipio := XMLaluno.AddChild('cidade');
  XMLMunicipio.Text := Municipio;
  XMLnascimento := XMLaluno.AddChild('nascimento');
  XMLnascimento.Text := Nascimento;
  XMLcurso := XMLaluno.AddChild('curso');
  XMLcurso.Text := Curso;
  XMLsexo := XMLaluno.AddChild('sexo');
  XMLsexo.Text := Sexo;

  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(Self,
    ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
