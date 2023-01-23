unit ClsOper100100;

interface
  uses ClsOperacoes,Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
       System.SysUtils, System.Classes, ClsParametros, Datasnap.DSClientRest,
       ClsListaBloqueio;

type
  Operacao100100 = class(TComponent)

  protected
    FUsuario: string;
    FSenha: string;
    FCodigo: string;
    FMensagem: string;
    FMensagemTipo: string;
    FIdentificacao: string;
    FRetorno : TNotifyEvent;
    FXMLRetorno: WideString;
    Operacao : MainOperacao;

    Procedure onXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure SetSenha(ParSenha: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property Usuario: String        read FUsuario      write SetUsuario;
    property Senha: String          read FSenha        write SetSenha;
    property codigo: String         read Fcodigo       write Fcodigo;
    property Mensagem: String       read Fmensagem     write Fmensagem;
    property MensagemTipo: String   read FMensagemTipo write FMensagemTipo;
    property Retorno : TNotifyEvent read FRetorno      write FRetorno;
    property Identificacao: String read FIdentificacao write FIdentificacao;
  end;

implementation
  uses ClsFuncoes;

Procedure Operacao100100.onXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  I: Integer;
  indice: Integer;
begin

  try
    LerXML := NewXMLDocument;
    // Aqui emplemeta a rotina de retorno
    if (Operacao.XMLRetorno <> '') then
    begin
      try
        LerXML.Active := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except on Erro : Exception do
      begin
        GravaArquivoLog(self,'Operação 100100 - Retorno Padrão - '+Erro.Message);
        LerXML.Active   := False;
        LerXML.XML.Clear;
        LerXML.XML.Text := Operacao.XMLRetornoPadrao;
        LerXML.Active := True;
      end;
      end;

      if LerXML.XML.Text <> '' then
      begin
        NoRetorno := LerXML.ChildNodes.FindNode('retorno');
        if NoRetorno <> nil then
        begin
          if NoRetorno.HasAttribute('codigo') then
          begin
            if NoRetorno.Attributes['codigo'] <> 'B000' then
            begin
              if  NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];

              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem').ChildNodes.FindNode('texto');

              if NoRetorno.ChildNodes.FindNode('mensagem').HasAttribute('tipo') then
                MensagemTipo := NoRetorno.ChildNodes.FindNode('mensagem').Attributes['tipo']
              else
                MensagemTipo :=  'I';

              if NoMensagem <> nil then
                mensagem := NoMensagem.Text;
            end
            else
            begin

              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];

              // <cfc>
              if NoRetorno.ChildNodes.FindNode('cfc') <> nil then
              begin

                GravaArquivoLog(self,'Operação 100100 - Parametros do CFC');
                ParCFC.id_cfc := NoRetorno.ChildNodes.FindNode('cfc').Attributes['id'];

                if NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode('nome_fantasia') <> nil then
                  ParCFC.nome_fantasia := NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode('nome_fantasia').Text;

                if NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode('cod_ciretran') <> NIL then
                  ParCFC.cod_ciretran := NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode('cod_ciretran').Text;

                if NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode('offline') <> NIL then
                  ParCFC.offline := NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode('offline').Text
                else
                  ParCFC.offline := 'S';

              end;

              // <parametros>
              with NoRetorno.ChildNodes.FindNode('parametros') do
              begin
                if HasChildNodes then
                begin
                  ParCFC.Secao := Attributes['secao'];
                  ParCFC.UF    := Attributes['uf'];

                  // <url>
                  if ChildNodes.FindNode('url') <> nil then
                  begin
                    GravaArquivoLog(self,'Operação 100100 - Parametros da Biometria');

                    // Url Foto e Biometria
                    if ChildNodes.FindNode('url').ChildNodes.FindNode('biometria') <> NIL then
                      ParCFC.URL_Biometria := ChildNodes.FindNode('url').ChildNodes.FindNode('biometria').Text;

                    // Url Foto
                    if ChildNodes.FindNode('url').ChildNodes.FindNode('foto') <> NIL then
                      ParCFC.URL_Foto := ChildNodes.FindNode('url').ChildNodes.FindNode('foto').Text;

                    // Url Gabarito
                    if ChildNodes.FindNode('url').ChildNodes.FindNode('gabarito') <> NIL then
                    begin
                      ParCFC.URL_Gabarito_Operacao := ChildNodes.FindNode('url').ChildNodes.FindNode('gabarito').Attributes['operacao'];
                      ParCFC.URL_Gabarito := ChildNodes.FindNode('url').ChildNodes.FindNode('gabarito').Text;
                    end;

                    // Url Questões da Prova
                    if ChildNodes.FindNode('url').ChildNodes.FindNode('prova') <> NIL then
                    begin
                      ParCFC.URL_Prova_Operacao := ChildNodes.FindNode('url').ChildNodes.FindNode('prova').Attributes['operacao'];
                      ParCFC.URL_Prova := ChildNodes.FindNode('url').ChildNodes.FindNode('prova').Text;
                    end;

                  end;

                  // <tela>
                  if ChildNodes.FindNode('tela') <> nil then
                  begin
                    GravaArquivoLog(self,'Operação 100100 - Parametros de Tela');

                    //Telas Padrão
                    if ChildNodes.FindNode('tela').ChildNodes.FindNode('confirmacao') <> NIL then
                      ParCFC.Tela_Confirmacao := ChildNodes.FindNode('tela').ChildNodes.FindNode('confirmacao').Text;

                    if ChildNodes.FindNode('tela').ChildNodes.FindNode('instrucoes') <> NIL then
                      ParCFC.Tela_Instrucoes := ChildNodes.FindNode('tela').ChildNodes.FindNode('instrucoes').Text;

                    if ChildNodes.FindNode('tela').ChildNodes.FindNode('teclado') <> NIL then
                      ParCFC.Tela_Teclado := ChildNodes.FindNode('tela').ChildNodes.FindNode('teclado').Text;

                    if ChildNodes.FindNode('tela').ChildNodes.FindNode('foto') <> NIL then
                      ParCFC.FotoMetodo := ChildNodes.FindNode('tela').ChildNodes.FindNode('foto').Attributes['metodo']
                    else
                      ParCFC.FotoMetodo := 1;
                  end;

                  // <impressao>
                  if ChildNodes.FindNode('impressao') <> nil then
                  begin
                    GravaArquivoLog(self,'Operação 100100 - Parametros de Impressão');
                    // Gabarito
                    if ChildNodes.FindNode('impressao').ChildNodes.FindNode('gabarito') <> NIL then
                      ParCFC.Impressao_Gabarito_Prova := ChildNodes.FindNode('impressao').ChildNodes.FindNode('gabarito').Text;

                    if ChildNodes.FindNode('impressao').ChildNodes.FindNode('gabarito_simulado') <> NIL then
                      ParCFC.Impressao_Gabarito_Simulado := ChildNodes.FindNode('impressao').ChildNodes.FindNode('gabarito_simulado').Text
                    else
                      ParCFC.Impressao_Gabarito_Simulado := ParCFC.Impressao_Gabarito_Prova;

                    // Prova
                    if ChildNodes.FindNode('impressao').ChildNodes.FindNode('prova') <> NIL then
                      ParCFC.Impressao_Questionario_Prova := ChildNodes.FindNode('impressao').ChildNodes.FindNode('prova').Text;

                    if ChildNodes.FindNode('impressao').ChildNodes.FindNode('prova_simulado') <> NIL then
                      ParCFC.Impressao_Questionario_Simulado := ChildNodes.FindNode('impressao').ChildNodes.FindNode('prova_simulado').Text
                    else
                      ParCFC.Impressao_Questionario_Simulado := ParCFC.Impressao_Questionario_Prova;

                    // Impressão Automatica
                    if ChildNodes.FindNode('impressao').ChildNodes.FindNode('automatica') <> NIL then
                      ParCFC.Impressao_Automatica := ChildNodes.FindNode('impressao').ChildNodes.FindNode('automatica').Text;
                  end;

                  // <monitoremento>
                  if ChildNodes.FindNode('monitoramento') <> nil then
                  begin
                    GravaArquivoLog(self,'Operação 100100 - Parametros de Monitoramento');

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('taxa') <> NIL then
                      ParMonitoramento.Taxa := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('taxa').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('compressao') <> NIL then
                      ParMonitoramento.Compressao := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('compressao').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('largura') <> NIL then
                      ParMonitoramento.Largura := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('largura').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('altura') <> NIL then
                      ParMonitoramento.Altura := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('altura').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('fps') <> NIL then
                      ParMonitoramento.Fps := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('fps').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('tempo') <> NIL then
                      ParMonitoramento.Tempo := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('tempo').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('host') <> NIL then
                      ParMonitoramento.Host := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('host').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('endereco') <> NIL then
                      ParMonitoramento.Endereco := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('endereco').Text;

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('data') <> NIL then
                      ParMonitoramento.Data :=
                          Copy(ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('data').Text,1,4) +
                          Copy(ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('data').Text,5,2) +
                          Copy(ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('data').Text,7,2);

                    if ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('hora') <> NIL then
                      ParMonitoramento.Hora := ChildNodes.FindNode('monitoramento').ChildNodes.FindNode('hora').Text;

                  end;

                  // <monitoramento_sala> Monitoramento do por DVR da Sala
                  if ChildNodes.FindNode('monitoramento_sala') <> nil then
                  begin
                    if ChildNodes.FindNode('monitoramento_sala').ChildNodes.FindNode('dispositivo') <> nil then
                    begin
                       ParMonitoramento.cfcliveURLID := StrToIntDef(ChildNodes.FindNode('monitoramento_sala').ChildNodes.FindNode('dispositivo').Attributes['id'], 0);

                      if ChildNodes.FindNode('monitoramento_sala').ChildNodes.FindNode('dispositivo').ChildNodes.FindNode('url') <> nil then
                      begin
                        ParMonitoramento.cfcliveURL := ChildNodes.FindNode('monitoramento_sala').ChildNodes.FindNode('dispositivo').ChildNodes.FindNode('url').Text;
                        ParMonitoramento.cfcliveURLPorta := StrToIntDef ( ChildNodes.FindNode('monitoramento_sala').ChildNodes.FindNode('dispositivo').ChildNodes.FindNode('porta').Text, 9090);
                      end;
                    end;
                  end;

                  // <configuracao_exame> Prova\Simulado
                  indice := ChildNodes.IndexOf('configuracao_exame');
                  repeat
                    if ChildNodes.Get(indice) <> nil then
                    begin
                      GravaArquivoLog(self,'Operação 100100 - Parametros do Exame - '+
                                       ChildNodes.Get(indice).Attributes['tipo']);
                      // Telas Provas
                      if ChildNodes.Get(indice).Attributes['tipo'] = 'Prova' then
                      begin
                        ParCFC.Prova := ChildNodes.Get(indice).Attributes['ativo'];

                        // Telas Monitoramento
                        if ChildNodes.Get(indice).ChildNodes.FindNode('monitoramento') <> NIL then
                          ParCFC.Monitoramento_prova := ChildNodes.Get(indice).ChildNodes.FindNode('monitoramento').Text;

                        // Modo Off Line
                        if ChildNodes.Get(indice).ChildNodes.FindNode('offline') <> NIL then
                          ParCFC.ProvaOffline := (ChildNodes.Get(indice).ChildNodes.FindNode('offline').Text = 'S')
                        else
                          ParCFC.ProvaOffline := False;

                        // Telas Foto
                        if ChildNodes.Get(indice).ChildNodes.FindNode('foto') <> NIL then
                          ParCFC.Foto_prova := ChildNodes.Get(indice).ChildNodes.FindNode('foto').Text;

                        // Telas Biometria
                        if ChildNodes.Get(indice).ChildNodes.FindNode('biometria') <> NIL then
                          ParCFC.Biometria_prova := ChildNodes.Get(indice).ChildNodes.FindNode('biometria').Text;

                        // Telas Biometria e Foto
                        if ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto') <> NIL then
                          ParCFC.Biometria_foto_prova := ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Text;

                        // Telas Foto Exame
                        if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL then
                        begin
                          ParFotoExame.Prova_Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Text = 'S');
                          ParFotoExame.Prova_Quantidades := ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Attributes['quantidade'];
                          ParFotoExame.Prova_Tempo := ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Attributes['tempo'];
                        end;

                        // Foto Exame
                        if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL then
                        begin
                          ParCFC.Foto_Exame_Prova := ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame').Text;
                          ParCFC.Foto_Exame_Quantidade_Prova := ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame').Attributes['quantidade'];
                          ParCFC.Foto_Exame_Tempo_Prova := ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame').Attributes['tempo'];

                        end;

                        if ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes') <> NIL then
                        begin

                          ParListaAplicativos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('software').Attributes['ativo'] = 'S');
                          ParListaDispositivos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('hardware').Attributes['ativo'] = 'S');
                          ParListaProcessosAtivos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('processos').Attributes['ativo'] = 'S');
                          ParListaServicosAtivos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('servicos').Attributes['ativo'] = 'S');

                          if (ParListaAplicativos.Ativo) or
                             (ParListaDispositivos.Ativo) or
                             (ParListaProcessosAtivos.Ativo) or
                             (ParListaServicosAtivos.Ativo) then
                          begin
                            ParShisnine.Prova_Ativo := true;
                          end;
                        end;

                        // verifica_processos
                        if ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos') <> NIL then
                        begin
                          ParShisnine.Verifica_Processos_Quantidade_Prova := StrToIntDef (ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos').Attributes['quantidade'],0);

                          if ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos').ChildNodes.FindNode('tempo') <> nil then
                            ParShisnine.Verifica_Processos_tempo_Prova := StrToIntDef (ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos').ChildNodes.FindNode('tempo').Text, 0)
                          else
                            ParShisnine.Verifica_Processos_tempo_Prova := 0;

                          if ParShisnine.Prova_Tempo < ParShisnine.Verifica_Processos_tempo_Prova then
                            ParShisnine.Prova_Tempo := ParShisnine.Verifica_Processos_tempo_Prova;

                        end;

                        if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro') <> NIL then
                        begin

                          if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').HasAttribute('ativo') then
                            ParCFC.Tela_Cadastro_prova := ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').Attributes['ativo']
                          else
                            ParCFC.Tela_Cadastro_prova := 'N';

                          if ParCFC.Tela_Cadastro_prova = 'S' then
                          begin
                            for I := 0 to ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').ChildNodes.Count do
                            begin
                              ParCFC.ListaCursoCodProva[I] := ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').ChildNodes.FindNode ('curso').Attributes['codigo'];
                              ParCFC.ListaCursoDescriProva[I] := ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').ChildNodes.FindNode ('curso').Text ;
                              ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').NextSibling;
                            end;
                          end;
                        end;
                      end
                      else
                      begin

                        ParCFC.Simulado := ChildNodes.Get(indice).Attributes['ativo'];

                        // Telas Monitoramento
                        if ChildNodes.Get(indice).ChildNodes.FindNode('monitoramento') <> NIL then
                          ParCFC.Monitoramento_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('monitoramento').Text;

                        // Modo Off Line
                        if ChildNodes.Get(indice).ChildNodes.FindNode('offline') <> NIL then
                          ParCFC.SimuladoOffline := (ChildNodes.Get(indice).ChildNodes.FindNode('offline').Text = 'S')
                        else
                          ParCFC.SimuladoOffline := False;

                        // Telas Foto
                        if ChildNodes.Get(indice).ChildNodes.FindNode('foto') <> NIL then
                          ParCFC.Foto_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('foto').Text;

                        // Telas Biometria
                        if ChildNodes.Get(indice).ChildNodes.FindNode('biometria') <> NIL then
                          ParCFC.Biometria_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('biometria').Text;

                        // Telas Biometria e Foto
                        if ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto') <> NIL then
                          ParCFC.Biometria_Foto_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Text;

                        // Telas Foto Exame
                        if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL then
                        begin
                          ParFotoExame.Simulado_Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Text = 'S');
                          ParFotoExame.Simulado_Quantidades := ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Attributes['quantidade'];
                          ParFotoExame.Simulado_Tempo := ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto').Attributes['tempo'];
                        end;

                        // Foto Exame
                        if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL then
                        begin
                          ParCFC.Foto_Exame_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame').Text;
                          ParCFC.Foto_Exame_Quantidade_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame').Attributes['quantidade'];
                          ParCFC.Foto_Exame_Tempo_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame').Attributes['tempo'];
                        end;

                        if ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes') <> NIL then
                        begin

                          ParListaAplicativos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('software').Attributes['ativo'] = 'S');
                          ParListaDispositivos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('hardware').Attributes['ativo'] = 'S');
                          ParListaProcessosAtivos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('processos').Attributes['ativo'] = 'S');
                          ParListaServicosAtivos.Ativo := (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes').ChildNodes.FindNode('servicos').Attributes['ativo'] = 'S');

                          if (ParListaAplicativos.Ativo) or
                             (ParListaDispositivos.Ativo) or
                             (ParListaProcessosAtivos.Ativo) or
                             (ParListaServicosAtivos.Ativo) then
                          begin
                            ParShisnine.Simulado_Ativo := true;
                          end;
                        end;

                        // verifica_processos
                        if ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos') <> NIL then
                        begin
                          ParShisnine.Verifica_Processos_Quantidade_simulado := StrToIntDef (ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos').Attributes['quantidade'],0);

                          if  ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos').ChildNodes.FindNode('tempo') <> nil then
                            ParShisnine.Verifica_Processos_tempo_simulado := StrToIntDef (ChildNodes.Get(indice).ChildNodes.FindNode('verifica_processos').ChildNodes.FindNode('tempo').Text, 0)
                          else
                           ParShisnine.Verifica_Processos_tempo_simulado := 0;

                          if ParShisnine.Simulado_Tempo < ParShisnine.Verifica_Processos_tempo_simulado then
                            ParShisnine.Simulado_Tempo := ParShisnine.Verifica_Processos_tempo_simulado;

                        end;

                        if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro') <> NIL then
                        begin

                          if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').HasAttribute('ativo') then
                            ParCFC.Tela_Cadastro_Simulado := ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').Attributes['ativo']
                          else
                            ParCFC.Tela_Cadastro_Simulado := 'N';

                          if ParCFC.Tela_Cadastro_Simulado = 'S' then
                          begin
                            for I := 0 to ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').ChildNodes.Count do
                            begin
                              ParCFC.ListaCursoCodProva[I] := ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').ChildNodes.FindNode ('curso').Attributes['codigo'];
                              ParCFC.ListaCursoDescriProva[I] := ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').ChildNodes.FindNode ('curso').Text ;
                              ChildNodes.Get(indice).ChildNodes.FindNode('cadastro').NextSibling;
                            end;
                          end;
                        end;
                      end;
                    end;
                    Inc(indice);
                  until ((ParCFC.Prova <> '') and (ParCFC.Simulado <> ''));
                end;
              end;
            end;
          end;
        end;
      end;
    end;

//    LerXML.XML.SaveToFile(UserProgranData+'\Criar\e-Prova XE\Log100100.cfg');
  except on E: Exception do
  begin
    //LerXML.XML.SaveToFile(UserProgranData+'\Criar\e-Prova XE\Log100100.cfg');

    GravaArquivoLog(self,'Operação 100100 - Retorno Padrão - '+e.Message);
    LerXML.Active := False;
    LerXML.XML.Clear;
    LerXML.XML.Text := Operacao.XMLRetornoPadrao;
    LerXML.Active := True;
  end;
  end;

  FRetorno(self);

end;

procedure Operacao100100.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Trim(FUsuario) <> '') and
     (Trim(FSenha) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao100100.SetSenha(ParSenha: String);
begin
  FSenha := ParSenha;
  if (Trim(FUsuario) <> '') and
     (Trim(FSenha) <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao100100.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLacesso : IXMLNode;
  XMLUsuario: IXMLNode;
  XMLSenha: IXMLNode;
  XMLComputador: IXMLNode;
  XMLVersao: IXMLNode;
  XmlTexto: string;

begin

  if (Trim(FUsuario) = '') or (Trim(FSenha) = '') then
  begin
    codigo := 'B999';
    mensagem := 'Falta parametros para executar a consulta!';
  end;

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';

  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario']  := '0';
  XMLElementoEnvio.Attributes['operacao'] := '100100';
  XMLElementoEnvio.Attributes['versao']   := GetVersaoArq;

  XMLAcesso := XMLElementoEnvio.AddChild('acesso');
  XMLAcesso.Text := ' ';

  XMLUsuario := XMLAcesso.AddChild('usuario');
  XMLUsuario.Text := Trim(Usuario);

  XMLSenha := XMLAcesso.AddChild('senha');
  XMLSenha.Text := Trim(Senha);

  XMLComputador := XMLAcesso.AddChild('computador');
  XMLComputador.Text := Trim(ParCFC.Computador);
  XMLComputador.Attributes['identificacao'] := Trim(FIdentificacao);


  XMLVersao := XMLAcesso.AddChild('versao');
  XMLVersao.Text := Trim(GetVersaoArq);

  XMLDoc.SaveToXML(XmlTexto);

  Operacao := MainOperacao.Create(Self,'<?xml version="1.0" encoding="UTF-8"?>'+XmlTexto,onXMLRetorno);
  Operacao.consutar;

end;

end.
