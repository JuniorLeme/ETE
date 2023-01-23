unit ClsOper200110;

interface

type
  Operacao200110 = class(TComponent)
  protected
    FUsuario: string;
    FAndamento: string;
    FId_prova: string;
    Fcodigo: string;
    Fmensagem: string;
    FTipo: string;
    Fid_cfc: string;
    Fduracao: String;
    FRetorno: TNotifyEvent;
    Operacao: MainOperacao;
    Procedure onMontaXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure SetAndamento(ParAndamento: String);
    procedure SetTipo(ParTipo: String);
    procedure SetId_prova(ParId_prova: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    // ParQuestionario: TProva;
    property Usuario: String read FUsuario write SetUsuario;
    property Andamento: String read FAndamento write SetAndamento;
    property Id_prova: String read FId_prova write SetId_prova;
    property codigo: String read Fcodigo write Fcodigo;
    property mensagem: String read Fmensagem write Fmensagem;
    property Tipo: String read FTipo write SetTipo;
    property id_cfc: String read Fid_cfc write Fid_cfc;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
    property duracao: String read Fduracao write Fduracao;
  end;

implementation

Procedure Operacao200110.onMontaXMLRetorno(Sender: TObject);
var
  LerXML: TXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  NoExame: IXMLNode;
  NoResultado: IXMLNode;
  NoDisciplina: IXMLNode;
  I: Integer;
  ParDisciplina: TDisciplina;
begin
  try
    LerXML := TXMLDocument.Create(Self);
    // Aqui emplemeta a rotina de retorno
    try
      LerXML.Active := False;
      LerXML.XML.Clear;
      LerXML.XML.Text := Operacao.XMLRetorno;
      LerXML.Active := True;
    except
      on Erro: Exception do
      begin
        GravaArquivoLog('Operação 200400 - Retorno Padrão - ' + Erro.Message);
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
    end;
    // Aqui emplemeta a rotina de retorno
    if (Trim(Operacao.XMLRetorno) <> '') then
    begin
      if Trim(LerXML.XML.Text) <> '' then
      begin
        NoRetorno := LerXML.ChildNodes.FindNode('retorno');
        if NoRetorno <> nil then
        begin
          if NoRetorno.HasAttribute('codigo') then
            if NoRetorno.Attributes['codigo'] <> 'B000' then
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('texto');
              if NoMensagem <> nil then
                mensagem := NoMensagem.Text;
            end
            else
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];
              // Só vai rodar essa etapa se o andamento for finalizar
              if Andamento = 'E' then
              begin
                NoExame := NoRetorno.ChildNodes.FindNode('exame');
                if NoExame <> nil then
                begin
                  NoResultado := NoExame.ChildNodes.FindNode('resultado');
                  ParQuestionario.Aproveitamento := NoResultado.Attributes['avaliacao'];
                  // NoDisciplina := NoResultado.ChildNodes.FindNode('disciplina');
                  ParQuestionario.TotalRespostasCorretas := 0;
                  ParQuestionario.TotalRespostasErradas := 0;
                  for I := 1 to NoResultado.ChildNodes.Count do
                  begin
                    NoDisciplina := NoResultado.ChildNodes.Get(I - 1);
                    // ParQuest.DisciplinaNumero := I;
                    ParDisciplina := TDisciplina.Create;
                    ParDisciplina.ResultadoDisciplinaPerg := StrToIntDef(NoDisciplina.Attributes['total'], 0);
                    ParDisciplina.ResultadoDisciplina := NoDisciplina.ChildNodes.FindNode('descricao').Text;
                    ParDisciplina.ResultadoDisciplinaCertas := StrToIntDef(NoDisciplina.ChildNodes.FindNode('certas').Text, 0);
                    ParDisciplina.ResultadoDisciplinaErradas := StrToIntDef(NoDisciplina.ChildNodes.FindNode('erradas').Text, 0);
                    ParQuestionario.TotalRespostasCorretas := ParQuestionario.TotalRespostasCorretas + ParDisciplina.ResultadoDisciplinaCertas;
                    ParQuestionario.TotalRespostasErradas := ParQuestionario.TotalRespostasErradas + ParDisciplina.ResultadoDisciplinaErradas;
                    ParQuestionario.Disciplinas.Add(I, ParDisciplina);
                  end;
                end;
              end;
            end;
        end;
      end;
    end;
  except
    on Erro: Exception do
    begin
      GravaArquivoLog('Operação 200400 - Retorno Padrão - ' + Erro.Message);
      LerXML.Active := False;
      LerXML.XML.Clear;
      LerXML.XML.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;
  FRetorno(Self);
end;

procedure Operacao200110.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Trim(FUsuario) <> '') and (Trim(FAndamento) <> '') and (Trim(FId_prova) <> '') and (Trim(FTipo) <> '') then
    MontaXMLEnvio(Self);
end;

procedure Operacao200110.SetAndamento(ParAndamento: String);
begin
  FAndamento := ParAndamento;
  if (Trim(FUsuario) <> '') and (Trim(FAndamento) <> '') and (Trim(FId_prova) <> '') and (Trim(FTipo) <> '') then
    MontaXMLEnvio(Self);
end;

procedure Operacao200110.SetId_prova(ParId_prova: String);
begin
  FId_prova := ParId_prova;
  if (Trim(FUsuario) <> '') and (Trim(FAndamento) <> '') and (Trim(FId_prova) <> '') and (Trim(FTipo) <> '') then
    MontaXMLEnvio(Self);
end;

procedure Operacao200110.SetTipo(ParTipo: String);
begin
  FTipo := ParTipo;
  if (Trim(FUsuario) <> '') and (Trim(FAndamento) <> '') and (Trim(FId_prova) <> '') and (Trim(FTipo) <> '') then
    MontaXMLEnvio(Self);
end;

Procedure Operacao200110.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: TXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLExame: IXMLNode;
  XMLAndamento: IXMLNode;
  XMLDuracao: IXMLNode;
  XMLQuestoes: IXMLNode;
  XmlQuestao: IXMLNode;
  XmlResposta: IXMLNode;
  XmlTexto: string;
  I: Integer;
begin
  if (Trim(FUsuario) = '') or (Trim(FAndamento) = '') or (Trim(FId_prova) = '') or (Trim(FTipo) = '') then
  begin
    codigo := 'D998';
    mensagem := 'Falta parametros para executar a consulta!';
  end;
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := False;
  XMLDoc.Active := True;
  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';
  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := Usuario;
  XMLElementoEnvio.Attributes['operacao'] := '200400';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;
  XMLExame := XMLElementoEnvio.AddChild('exame');
  XMLExame.Text := ' ';
  XMLExame.Attributes['id'] := Id_prova;
  XMLExame.Attributes['tipo'] := Tipo;
  XMLAndamento := XMLExame.AddChild('andamento');
  XMLAndamento.Attributes['tipo'] := Andamento;
  XMLDuracao := XMLAndamento.AddChild('duracao');
  XMLDuracao.Text := Fduracao;
  XMLQuestoes := XMLExame.AddChild('questoes');
  XMLQuestoes.Attributes['total'] := IntToStr(ParQuestionario.TotalPerguntas);
  XMLQuestoes.Text := '';
  for I := 1 to ParQuestionario.Perguntas.Count do
  begin
    if ParQuestionario.Perguntas.Items[I].RespostaEscolhida <> '' then
    begin
      XmlQuestao := XMLQuestoes.AddChild('questao');
      XmlQuestao.Attributes['id'] := IntToStr(ParQuestionario.Perguntas.Items[I].id_questoes);
      XmlQuestao.Text := ' ';
      XmlResposta := XmlQuestao.AddChild('resposta');
      XmlResposta.Text := ParQuestionario.Perguntas.Items[I].RespostaEscolhida;
    end;
  end;
  XMLDoc.SaveToXML(XmlTexto);
  Operacao := MainOperacao.Create(Self, XMLElementoEnvio.Attributes['operacao'], ' <?xml version="1.0" encoding="UTF-8"?> ' + XmlTexto, onMontaXMLRetorno);
  Operacao.consutar;
end;

end.
