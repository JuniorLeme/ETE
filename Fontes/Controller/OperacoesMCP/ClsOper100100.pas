unit ClsOper100100;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils,
  System.Classes, ClsParametros, Datasnap.DSClientRest, ClsCFCControl,
  ClsListaBloqueio,
  clsDVRFerramentas, ClsEnvioMCP, ClsRetornoMCP, ClsDetecta,
  clsMonitoramentoRTSPControl,
  ClsDigitalFotoExame;

type
  T100100Retorno = class(TRetornoMCP)
    Procedure MontaRetorno(XMLDoc: IXMLDocument);
  end;

  T100100Envio = class
    Function MontaXMLEnvio(FUsuario, FSenha, FIdentificacao: string)
      : IXMLDocument;
  end;

implementation

uses ClsFuncoes;

Procedure T100100Retorno.MontaRetorno(XMLDoc: IXMLDocument);
var
  NoRetorno: IXMLNode;
  monitoramentos_rtsp: IXMLNode;
  monitoramentos_sala: IXMLNode;
  I: Integer;
  indice: Integer;
  TmpMonitoramentoRTSP: TMonitoramentoRTSP;
begin

  try
    Parametros.TipoBiometria := '';

    Self.Retorno(XMLDoc);
    if Self.IsValid then
    begin

      try
        XMLDoc.Active := False;
        XMLDoc.Active := True;
      except
        on Erro: Exception do
          ArquivoLog.GravaArquivoLog('Opera��o 100100 - Retorno Padr�o - ' +
            Erro.Message);
      end;

      NoRetorno := XMLDoc.ChildNodes.FindNode('retorno');

      // <cfc>
      if NoRetorno.ChildNodes.FindNode('cfc') <> nil then
      begin
        ArquivoLog.GravaArquivoLog('Opera��o 100100 - Parametros do CFC');
        ParCFC.id_cfc := NoRetorno.ChildNodes.FindNode('cfc').Attributes['id'];

        if NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode
          ('nome_fantasia') <> nil then
          ParCFC.nome_fantasia := NoRetorno.ChildNodes.FindNode('cfc')
            .ChildNodes.FindNode('nome_fantasia').Text;

        if NoRetorno.ChildNodes.FindNode('cfc').ChildNodes.FindNode
          ('cod_ciretran') <> NIL then
          ParCFC.cod_ciretran := NoRetorno.ChildNodes.FindNode('cfc')
            .ChildNodes.FindNode('cod_ciretran').Text;
      end;

      // <parametros>
      with NoRetorno.ChildNodes.FindNode('parametros') do
      begin

        if HasChildNodes then
        begin

          ParCFC.UF := Attributes['uf'];

          // <url>
          if ChildNodes.FindNode('url') <> nil then
          begin
            ArquivoLog.GravaArquivoLog
              ('Opera��o 100100 - Parametros da Biometria');
            // Url Foto e Biometria
            if ChildNodes.FindNode('url').ChildNodes.FindNode('biometria') <> NIL
            then
              ParCFC.URL_Biometria := ChildNodes.FindNode('url')
                .ChildNodes.FindNode('biometria').Text;
            // Url Foto
            if ChildNodes.FindNode('url').ChildNodes.FindNode('foto') <> NIL
            then
              ParCFC.URL_Foto := ChildNodes.FindNode('url')
                .ChildNodes.FindNode('foto').Text;

            // Url Gabarito
            if ChildNodes.FindNode('url').ChildNodes.FindNode('gabarito') <> NIL
            then
            begin
              ParCFC.URL_Gabarito_Operacao := ChildNodes.FindNode('url')
                .ChildNodes.FindNode('gabarito').Attributes['operacao'];
              ParCFC.URL_Gabarito := ChildNodes.FindNode('url')
                .ChildNodes.FindNode('gabarito').Text;
            end;

            // Url Quest�es da Prova
            if ChildNodes.FindNode('url').ChildNodes.FindNode('prova') <> NIL
            then
            begin
              ParCFC.URL_Prova_Operacao := ChildNodes.FindNode('url')
                .ChildNodes.FindNode('prova').Attributes['operacao'];
              ParCFC.URL_Prova := ChildNodes.FindNode('url')
                .ChildNodes.FindNode('prova').Text;
            end;

          end;

          // <tela>
          if ChildNodes.FindNode('tela') <> nil then
          begin
            ArquivoLog.GravaArquivoLog('Opera��o 100100 - Parametros de Tela');
            // Telas Padr�o
            if ChildNodes.FindNode('tela').ChildNodes.FindNode('confirmacao') <> NIL
            then
              ParCFC.Tela_Confirmacao := ChildNodes.FindNode('tela')
                .ChildNodes.FindNode('confirmacao').Text;

            if ChildNodes.FindNode('tela').ChildNodes.FindNode('instrucoes') <> NIL
            then
              ParCFC.Tela_Instrucoes := ChildNodes.FindNode('tela')
                .ChildNodes.FindNode('instrucoes').Text;

            if ChildNodes.FindNode('tela').ChildNodes.FindNode('teclado') <> NIL
            then
              ParCFC.Tela_Teclado := ChildNodes.FindNode('tela')
                .ChildNodes.FindNode('teclado').Text;

            if ChildNodes.FindNode('tela').ChildNodes.FindNode('foto') <> NIL
            then
              ParCFC.FotoMetodo := ChildNodes.FindNode('tela')
                .ChildNodes.FindNode('foto').Attributes['metodo']
            else
              ParCFC.FotoMetodo := 1;
          end;

          // <impressao>
          if ChildNodes.FindNode('impressao') <> nil then
          begin
            ArquivoLog.GravaArquivoLog
              ('Opera��o 100100 - Parametros de Impress�o');
            // Gabarito
            if ChildNodes.FindNode('impressao').ChildNodes.FindNode('gabarito')
              <> NIL then
              ParCFC.Impressao_Gabarito_Prova :=
                ChildNodes.FindNode('impressao').ChildNodes.FindNode
                ('gabarito').Text;

            if ChildNodes.FindNode('impressao').ChildNodes.FindNode
              ('gabarito_simulado') <> NIL then
              ParCFC.Impressao_Gabarito_Simulado :=
                ChildNodes.FindNode('impressao').ChildNodes.FindNode
                ('gabarito_simulado').Text
            else
              ParCFC.Impressao_Gabarito_Simulado :=
                ParCFC.Impressao_Gabarito_Prova;

            // Prova
            if ChildNodes.FindNode('impressao').ChildNodes.FindNode('prova') <> NIL
            then
              ParCFC.Impressao_Questionario_Prova :=
                ChildNodes.FindNode('impressao').ChildNodes.FindNode
                ('prova').Text;

            if ChildNodes.FindNode('impressao').ChildNodes.FindNode
              ('prova_simulado') <> NIL then
              ParCFC.Impressao_Questionario_Simulado :=
                ChildNodes.FindNode('impressao').ChildNodes.FindNode
                ('prova_simulado').Text
            else
              ParCFC.Impressao_Questionario_Simulado :=
                ParCFC.Impressao_Questionario_Prova;

            // Impress�o Automatica
            if ChildNodes.FindNode('impressao').ChildNodes.FindNode
              ('automatica') <> NIL then
              ParCFC.Impressao_Automatica := ChildNodes.FindNode('impressao')
                .ChildNodes.FindNode('automatica').Text;
          end;

          // <tela>
          if ChildNodes.FindNode('dispositivos') <> nil then
          begin

            ArquivoLog.GravaArquivoLog
              ('Opera��o 100100 - Parametros de Dispositivos');

            // Scanners Padr�o
            if ChildNodes.FindNode('dispositivos').ChildNodes.FindNode
              ('scanners') <> NIL then
              Parametros.Scanners := ChildNodes.FindNode('dispositivos')
                .ChildNodes.FindNode('scanners').Text;

          end;

          // <biometria>
          if ChildNodes.FindNode('biometria') <> nil then
          begin
            if ChildNodes.FindNode('biometria').ChildNodes.FindNode('tipo') <> nil
            then
              Parametros.TipoBiometria := ChildNodes.FindNode('biometria')
                .ChildNodes.FindNode('tipo').Text;
          end;

          if ChildNodes.FindNode('seitran') <> nil then
          begin
            if ChildNodes.FindNode('seitran').ChildNodes.FindNode('endereco_servidor') <> nil then
              ParCFC.URLSEITrans := ChildNodes.FindNode('seitran').ChildNodes.FindNode('endereco_servidor').Text;
          end;

          // <monitoremento_sala>
          if ChildNodes.FindNode('monitoramento_sala') <> nil then
          begin

            monitoramentos_sala := ChildNodes.FindNode('monitoramento_sala')
              .ChildNodes.FindNode('dispositivo');

            if monitoramentos_sala <> nil then
            begin

              DVRFerramentas := TDVRFerramentas.Create;

              if monitoramentos_sala.HasAttribute('verificar') then
                DVRFerramentas.Verificar := monitoramentos_sala.Attributes
                  ['verificar'];

              if monitoramentos_sala.HasAttribute('id') then
                DVRFerramentas.id :=
                  StrToIntDef(monitoramentos_sala.Attributes['id'], 0);

              if monitoramentos_sala.HasAttribute('tempo') then
                DVRFerramentas.Tempo :=
                  StrToIntDef(monitoramentos_sala.Attributes['tempo'], 90000);

              if monitoramentos_sala.ChildNodes.FindNode('url') <> nil then
                DVRFerramentas.Endereco :=
                  monitoramentos_sala.ChildNodes.FindNode('url').Text;

              if monitoramentos_sala.ChildNodes.FindNode('porta') <> nil then
                DVRFerramentas.Porta :=
                  StrToIntDef(monitoramentos_sala.ChildNodes.FindNode('porta')
                  .Text, 37777);

              if monitoramentos_sala.ChildNodes.FindNode('usuario') <> nil then
                DVRFerramentas.Usuario :=
                  monitoramentos_sala.ChildNodes.FindNode('usuario').Text;

              if monitoramentos_sala.ChildNodes.FindNode('senha') <> nil then
                DVRFerramentas.Senha := monitoramentos_sala.ChildNodes.FindNode
                  ('senha').Text;

            end;

          end;

          // <monitoremento RTSP>
          if ChildNodes.FindNode('monitoramentos_rtsp') <> nil then
          begin
            monitoramentos_rtsp := ChildNodes.FindNode('monitoramentos_rtsp');

            for I := 0 to monitoramentos_rtsp.ChildNodes.Count - 1 do
            begin

              TmpMonitoramentoRTSP := TMonitoramentoRTSP.Create;
              ArquivoLog.GravaArquivoLog
                ('Opera��o 100100 - Parametros de Monitoramento RTSP');

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('endereco_servidor') <> nil then
                TmpMonitoramentoRTSP.Endereco_Servidor :=
                  monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                  ('endereco_servidor').Text;

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('porta_servidor') <> nil then
                TmpMonitoramentoRTSP.Porta_Servidor :=
                  StrToIntDef(monitoramentos_rtsp.ChildNodes[I]
                  .ChildNodes.FindNode('porta_servidor').Text, 8888);

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('iniciar_gravacao') <> nil then
                TmpMonitoramentoRTSP.Iniciar_Gravacao :=
                  monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                  ('iniciar_gravacao').Text;

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('verificar_fluxo') <> nil then
                TmpMonitoramentoRTSP.Verificar_Fluxo :=
                  monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                  ('verificar_fluxo').Text;

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('finalizar_gravacao') <> nil then
                TmpMonitoramentoRTSP.finalizar_Gravacao :=
                  monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                  ('finalizar_gravacao').Text;

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('verificar_servidor') <> nil then
                TmpMonitoramentoRTSP.Verificar_Servidor :=
                  monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                  ('verificar_servidor').Text;

              if monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                ('verificar_cameras') <> nil then
                TmpMonitoramentoRTSP.Verificar_Cameras :=
                  monitoramentos_rtsp.ChildNodes[I].ChildNodes.FindNode
                  ('verificar_cameras').Text;

              ParListaMonitoramentoRTSP.AddObject
                (TmpMonitoramentoRTSP.Endereco_Servidor, TmpMonitoramentoRTSP);

            end;

          end;

          if ChildNodes.FindNode('monitoramento_rtsp') <> nil then
          begin

            ArquivoLog.GravaArquivoLog
              ('Opera��o 100100 - Parametros de Monitoramento RTSP');

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('endereco_servidor') <> NIL then
              ParMonitoramentoRTSP.Endereco_Servidor :=
                ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('endereco_servidor').Text;

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('porta_servidor') <> NIL then
              ParMonitoramentoRTSP.Porta_Servidor :=
                StrToIntDef(ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('porta_servidor').Text, 9001);

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('iniciar_gravacao') <> NIL then
              ParMonitoramentoRTSP.Iniciar_Gravacao :=
                ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('iniciar_gravacao').Text;

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('verificar_fluxo') <> NIL then
              ParMonitoramentoRTSP.Verificar_Fluxo :=
                ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('verificar_fluxo').Text;

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('finalizar_gravacao') <> NIL then
              ParMonitoramentoRTSP.finalizar_Gravacao :=
                ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('finalizar_gravacao').Text;

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('verificar_servidor') <> NIL then
              ParMonitoramentoRTSP.Verificar_Servidor :=
                ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('verificar_servidor').Text;

            if ChildNodes.FindNode('monitoramento_rtsp')
              .ChildNodes.FindNode('verificar_cameras') <> NIL then
              ParMonitoramentoRTSP.Verificar_Cameras :=
                ChildNodes.FindNode('monitoramento_rtsp')
                .ChildNodes.FindNode('verificar_cameras').Text;

          end;

          // <configuracao_exame> Prova\Simulado
          indice := ChildNodes.IndexOf('configuracao_exame');
          repeat
            if ChildNodes.Get(indice) <> nil then
            begin
              ArquivoLog.GravaArquivoLog
                ('Opera��o 100100 - Parametros do Exame - ' +
                ChildNodes.Get(indice).Attributes['tipo']);
              // Telas Provas
              if ChildNodes.Get(indice).Attributes['tipo'] = 'Prova' then
              begin
                ParCFC.Prova := ChildNodes.Get(indice).Attributes['ativo'];

                // Telas Monitoramento
                if ChildNodes.Get(indice).ChildNodes.FindNode('monitoramento')
                  <> NIL then
                  ParCFC.Monitoramento_prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('monitoramento').Text;

                // Telas Foto
                if ChildNodes.Get(indice).ChildNodes.FindNode('foto') <> NIL
                then
                  ParCFC.Foto_prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto').Text;

                // Telas Biometria
                if ChildNodes.Get(indice).ChildNodes.FindNode('biometria') <> NIL
                then
                  ParCFC.Biometria_prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria').Text;

                // Telas Biometria e Foto
                if ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto')
                  <> NIL then
                  ParCFC.Biometria_foto_prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria_foto').Text;

                // Telas Foto Exame
                if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL
                then
                begin
                  ParFotoExame.Prova_Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode
                    ('biometria_foto').Text = 'S');
                  ParFotoExame.Prova_Quantidades := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria_foto').Attributes
                    ['quantidade'];
                  ParFotoExame.Prova_Tempo := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria_foto').Attributes['tempo'];
                end;

                // Foto Exame
                if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL
                then
                begin
                  ParCFC.Foto_Exame_Prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto_exame').Text;
                  ParCFC.Foto_Exame_Quantidade_Prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto_exame').Attributes['quantidade'];
                  ParCFC.Foto_Exame_Tempo_Prova := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto_exame').Attributes['tempo'];

                end;

                if ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes') <> NIL
                then
                begin

                  ParListaAplicativos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('software').Attributes['ativo'] = 'S');
                  ParListaDispositivos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('hardware').Attributes['ativo'] = 'S');
                  ParListaProcessosAtivos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('processos').Attributes
                    ['ativo'] = 'S');
                  ParListaServicosAtivos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('servicos').Attributes['ativo'] = 'S');

                  if (ParListaAplicativos.Ativo) or (ParListaDispositivos.Ativo)
                    or (ParListaProcessosAtivos.Ativo) or
                    (ParListaServicosAtivos.Ativo) then
                  begin
                    ParDetecta.Prova_Ativo := True;
                  end;
                end;

                // verifica_processos
                if ChildNodes.Get(indice).ChildNodes.FindNode
                  ('verifica_processos') <> NIL then
                begin
                  ParDetecta.Verifica_Processos_Quantidade_Prova :=
                    StrToIntDef(ChildNodes.Get(indice)
                    .ChildNodes.FindNode('verifica_processos').Attributes
                    ['quantidade'], 0);

                  if ChildNodes.Get(indice).ChildNodes.FindNode
                    ('verifica_processos').ChildNodes.FindNode('tempo') <> nil
                  then
                    ParDetecta.Verifica_Processos_tempo_Prova :=
                      StrToIntDef(ChildNodes.Get(indice)
                      .ChildNodes.FindNode('verifica_processos')
                      .ChildNodes.FindNode('tempo').Text, 0)
                  else
                    ParDetecta.Verifica_Processos_tempo_Prova := 0;

                  if ParDetecta.Prova_Tempo < ParDetecta.Verifica_Processos_tempo_Prova
                  then
                    ParDetecta.Prova_Tempo :=
                      ParDetecta.Verifica_Processos_tempo_Prova;

                end;

                if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro') <> NIL
                then
                begin

                  if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro')
                    .HasAttribute('ativo') then
                    ParCFC.Tela_Cadastro_prova := ChildNodes.Get(indice)
                      .ChildNodes.FindNode('cadastro').Attributes['ativo']
                  else
                    ParCFC.Tela_Cadastro_prova := 'N';

                  if ParCFC.Tela_Cadastro_prova = 'S' then
                  begin
                    for I := 0 to ChildNodes.Get(indice)
                      .ChildNodes.FindNode('cadastro').ChildNodes.Count - 1 do
                    begin
                      ParCFC.ListaCursoCodProva[I] := ChildNodes.Get(indice)
                        .ChildNodes.FindNode('cadastro')
                        .ChildNodes.FindNode('curso').Attributes['codigo'];
                      ParCFC.ListaCursoDescriProva[I] := ChildNodes.Get(indice)
                        .ChildNodes.FindNode('cadastro')
                        .ChildNodes.FindNode('curso').Text;
                      ChildNodes.Get(indice).ChildNodes.FindNode('cadastro')
                        .NextSibling;
                    end;
                  end;
                end;
              end
              else
              begin

                ParCFC.Simulado := ChildNodes.Get(indice).Attributes['ativo'];

                // Telas Monitoramento
                if ChildNodes.Get(indice).ChildNodes.FindNode('monitoramento')
                  <> NIL then
                  ParCFC.Monitoramento_Simulado := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('monitoramento').Text;

                // Telas Foto
                if ChildNodes.Get(indice).ChildNodes.FindNode('foto') <> NIL
                then
                  ParCFC.Foto_Simulado := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto').Text;

                // Telas Biometria
                if ChildNodes.Get(indice).ChildNodes.FindNode('biometria') <> NIL
                then
                  ParCFC.Biometria_Simulado := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria').Text;

                // Telas Biometria e Foto
                if ChildNodes.Get(indice).ChildNodes.FindNode('biometria_foto')
                  <> NIL then
                  ParCFC.Biometria_Foto_Simulado := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria_foto').Text;

                // Telas Foto Exame
                if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL
                then
                begin
                  ParFotoExame.Simulado_Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode
                    ('biometria_foto').Text = 'S');
                  ParFotoExame.Simulado_Quantidades := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria_foto').Attributes
                    ['quantidade'];
                  ParFotoExame.Simulado_Tempo := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('biometria_foto').Attributes['tempo'];
                end;

                // Foto Exame
                if ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame') <> NIL
                then
                begin
                  ParCFC.Foto_Exame_Simulado := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto_exame').Text;
                  ParCFC.Foto_Exame_Quantidade_Simulado :=
                    ChildNodes.Get(indice).ChildNodes.FindNode('foto_exame')
                    .Attributes['quantidade'];
                  ParCFC.Foto_Exame_Tempo_Simulado := ChildNodes.Get(indice)
                    .ChildNodes.FindNode('foto_exame').Attributes['tempo'];
                end;

                if ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes') <> NIL
                then
                begin

                  ParListaAplicativos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('software').Attributes['ativo'] = 'S');
                  ParListaDispositivos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('hardware').Attributes['ativo'] = 'S');
                  ParListaProcessosAtivos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('processos').Attributes
                    ['ativo'] = 'S');
                  ParListaServicosAtivos.Ativo :=
                    (ChildNodes.Get(indice).ChildNodes.FindNode('verificacoes')
                    .ChildNodes.FindNode('servicos').Attributes['ativo'] = 'S');

                  if (ParListaAplicativos.Ativo) or (ParListaDispositivos.Ativo)
                    or (ParListaProcessosAtivos.Ativo) or
                    (ParListaServicosAtivos.Ativo) then
                  begin
                    ParDetecta.Simulado_Ativo := True;
                  end;
                end;

                // verifica_processos
                if ChildNodes.Get(indice).ChildNodes.FindNode
                  ('verifica_processos') <> NIL then
                begin
                  ParDetecta.Verifica_Processos_Quantidade_simulado :=
                    StrToIntDef(ChildNodes.Get(indice)
                    .ChildNodes.FindNode('verifica_processos').Attributes
                    ['quantidade'], 0);

                  if ChildNodes.Get(indice).ChildNodes.FindNode
                    ('verifica_processos').ChildNodes.FindNode('tempo') <> nil
                  then
                    ParDetecta.Verifica_Processos_tempo_simulado :=
                      StrToIntDef(ChildNodes.Get(indice)
                      .ChildNodes.FindNode('verifica_processos')
                      .ChildNodes.FindNode('tempo').Text, 0)
                  else
                    ParDetecta.Verifica_Processos_tempo_simulado := 0;

                  if ParDetecta.Simulado_Tempo < ParDetecta.Verifica_Processos_tempo_simulado
                  then
                    ParDetecta.Simulado_Tempo :=
                      ParDetecta.Verifica_Processos_tempo_simulado;

                end;

                if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro') <> NIL
                then
                begin

                  if ChildNodes.Get(indice).ChildNodes.FindNode('cadastro')
                    .HasAttribute('ativo') then
                    ParCFC.Tela_Cadastro_Simulado := ChildNodes.Get(indice)
                      .ChildNodes.FindNode('cadastro').Attributes['ativo']
                  else
                    ParCFC.Tela_Cadastro_Simulado := 'N';

                  if ParCFC.Tela_Cadastro_Simulado = 'S' then
                  begin
                    for I := 0 to ChildNodes.Get(indice)
                      .ChildNodes.FindNode('cadastro').ChildNodes.Count - 1 do
                    begin
                      ParCFC.ListaCursoCodSimulado[I] := ChildNodes.Get(indice)
                        .ChildNodes.FindNode('cadastro')
                        .ChildNodes.FindNode('curso').Attributes['codigo'];
                      ParCFC.ListaCursoDescriSimulado[I] :=
                        ChildNodes.Get(indice).ChildNodes.FindNode('cadastro')
                        .ChildNodes.FindNode('curso').Text;
                      ChildNodes.Get(indice).ChildNodes.FindNode('cadastro')
                        .NextSibling;
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

    Parametros.GravarParametrosCRC;
  except
    on E: Exception do
      if Debug then
        ArquivoLog.GravaArquivoLog('Opera��o 100100 - Retorno Padr�o - ' +
          E.Message);
  end;

end;

Function T100100Envio.MontaXMLEnvio(FUsuario, FSenha, FIdentificacao: string)
  : IXMLDocument;
var
  XMLElementoEnvio: IXMLNode;
  EnvioMCP: TEnvioMCP;
  XMLacesso: IXMLNode;
  XMLUsuario: IXMLNode;
  XMLSenha: IXMLNode;
  XMLComputador: IXMLNode;
  XMLVersao: IXMLNode;
begin

  Result := TXMLDocument.Create(nil);
  Result.Active := False;
  Result.Active := True;

  EnvioMCP := TEnvioMCP.GetInstance;
  XMLElementoEnvio := EnvioMCP.GetEnvioMCP('100100', Result);

  XMLacesso := XMLElementoEnvio.AddChild('acesso');
  XMLacesso.Text := ' ';

  XMLUsuario := XMLacesso.AddChild('usuario');
  XMLUsuario.Text := Trim(FUsuario);

  XMLSenha := XMLacesso.AddChild('senha');
  XMLSenha.Text := Trim(FSenha);

  XMLComputador := XMLacesso.AddChild('computador');
  XMLComputador.Text := Trim(Parametros.Computador);
  XMLComputador.Attributes['identificacao'] := Trim(FIdentificacao);

  XMLVersao := XMLacesso.AddChild('versao');
  XMLVersao.Text := Trim(GetVersaoArq);

end;

end.
