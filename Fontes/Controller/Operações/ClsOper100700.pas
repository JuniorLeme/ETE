unit ClsOper100700;

interface

uses
  ClsOperacoes, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  System.SysUtils, System.Classes, ClsParametros, ClsListaBloqueio;

type
  Operacao100700 = class(TComponent)
  protected
    FUsuario: string;
    FSenha: string;
    FCodigo: string;
    FMensagem: string;
    FMensagemTipo: string;
    FRetorno: TNotifyEvent;
    FXMLRetorno: WideString;
    Operacao: MainOperacao;

    Procedure onXMLRetorno(Sender: TObject);
    procedure SetUsuario(ParUsuario: String);
    procedure SetSenha(ParSenha: String);
    Procedure MontaXMLEnvio(Sender: TObject);
  public
    property Usuario: String read FUsuario write SetUsuario;
    property Senha: String read FSenha write SetSenha;
    property codigo: String read FCodigo write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property MensagemTipo: String read FMensagemTipo write FMensagemTipo;
    property Retorno: TNotifyEvent read FRetorno write FRetorno;
  end;

implementation

uses ClsFuncoes;

Procedure Operacao100700.onXMLRetorno(Sender: TObject);
var
  LerXML: IXMLDocument;
  NoRetorno: IXMLNode;
  NoMensagem: IXMLNode;
  I: Integer;
begin

  try
    LerXML := NewXMLDocument;
    // Aqui emplemeta a rotina de retorno
    if (Operacao.XMLRetorno <> '') then
    begin
      try
        LerXML.Active := False;
        LerXML.Xml.Clear;
        LerXML.Xml.Text := Operacao.XMLRetorno;
        LerXML.Active := True;
      except
        on Erro: Exception do
        begin
          GravaArquivoLog(self, 'Operação 100700 - Retorno Padrão - ' +
            Erro.Message);
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
          begin

            if NoRetorno.HasAttribute('codigo') then
              codigo := NoRetorno.Attributes['codigo'];

            if codigo <> 'B000' then
            begin
              if NoRetorno.HasAttribute('codigo') then
                codigo := NoRetorno.Attributes['codigo'];

              NoMensagem := NoRetorno.ChildNodes.FindNode('mensagem')
                .ChildNodes.FindNode('texto');

              if NoRetorno.ChildNodes.FindNode('mensagem').HasAttribute('tipo')
              then
                MensagemTipo := NoRetorno.ChildNodes.FindNode('mensagem')
                  .Attributes['tipo']
              else
                MensagemTipo := 'I';

              if NoMensagem <> nil then
                Mensagem := NoMensagem.Text;
            end
            else
            begin

              ParProcessosServicosProibidos :=
                ProcessosServicosProibidos.Create;

              ParShisnine.Enviar_Processos := NoRetorno.ChildNodes.FindNode
                ('programas').Attributes['enviar_processos'];

              for I := 0 to NoRetorno.ChildNodes.FindNode('programas')
                .ChildNodes.Count - 1 do
              begin
                ParProcessosServicosProibidos.ID.Add
                  (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
                  .Attributes['id']);

                ParProcessosServicosProibidos.Processos.Add
                  (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
                  .ChildNodes.FindNode('executavel').Text);

                ParProcessosServicosProibidos.Janelas.Add
                  (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
                  .ChildNodes.FindNode('janela').Text);

                ParProcessosServicosProibidos.Servicos.Add
                  (NoRetorno.ChildNodes.FindNode('programas').ChildNodes.Get(I)
                  .ChildNodes.FindNode('servico').Text);
              end;

              if NoRetorno.ChildNodes.FindNode('hardwares') <> nil then
              begin
                ParListaDispositivos.Quantidades :=
                  StrToIntDef(NoRetorno.ChildNodes.FindNode
                  ('softwares_ignorados').Attributes['quantidade'], 0);

                if NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                  .HasAttribute('ativo') then
                  ParListaDispositivos.Ativo :=
                    (NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                    .Attributes['ativo'] = 'S');

                ParListaDispositivos.Classe.Clear;
                for I := 0 to NoRetorno.ChildNodes.FindNode('hardwares')
                  .ChildNodes.Count - 1 do
                  ParListaDispositivos.Classe.Add
                    (NoRetorno.ChildNodes.FindNode('hardwares')
                    .ChildNodes.Get(I).Text);
              end;

              if NoRetorno.ChildNodes.FindNode('softwares_ignorados') <> nil
              then
              begin

                ParListaAplicativos.Quantidades :=
                  StrToIntDef(NoRetorno.ChildNodes.FindNode
                  ('softwares_ignorados').Attributes['quantidade'], 0);

                if NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                  .HasAttribute('ativo') then
                  ParListaAplicativos.Ativo :=
                    (NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                    .Attributes['ativo'] = 'S');

                if NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                  .HasAttribute('classe') then
                  ParListaAplicativos.Classe.Add
                    (NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                    .Attributes['classe']);

                ParListaAplicativos.ListaSoftwaresIgnodos.Clear;
                for I := 0 to NoRetorno.ChildNodes.FindNode
                  ('softwares_ignorados').ChildNodes.Count - 1 do
                  ParListaAplicativos.ListaSoftwaresIgnodos.Add
                    (NoRetorno.ChildNodes.FindNode('softwares_ignorados')
                    .ChildNodes.Get(I).Text);
              end;

              if NoRetorno.ChildNodes.FindNode('processos') <> nil then
              begin
                ParListaProcessosAtivos.Quantidades :=
                  StrToIntDef(NoRetorno.ChildNodes.FindNode('processos')
                  .Attributes['quantidade'], 0);

                if NoRetorno.ChildNodes.FindNode('processos')
                  .HasAttribute('ativo') then
                  ParListaProcessosAtivos.Ativo :=
                    (NoRetorno.ChildNodes.FindNode('processos').Attributes
                    ['ativo'] = 'S');

                for I := 0 to NoRetorno.ChildNodes.FindNode('processos')
                  .ChildNodes.Count - 1 do
                  ParListaProcessosAtivos.Classe.Add
                    (NoRetorno.ChildNodes.FindNode('processos')
                    .ChildNodes.Get(I).Text);
              end;

              if NoRetorno.ChildNodes.FindNode('servicos') <> nil then
              begin
                ParListaServicosAtivos.Quantidades :=
                  StrToIntDef(NoRetorno.ChildNodes.FindNode('servicos')
                  .Attributes['quantidade'], 0);

                if NoRetorno.ChildNodes.FindNode('servicos')
                  .HasAttribute('ativo') then
                  ParListaServicosAtivos.Ativo :=
                    (NoRetorno.ChildNodes.FindNode('servicos').Attributes
                    ['ativo'] = 'S');

                for I := 0 to NoRetorno.ChildNodes.FindNode('servicos')
                  .ChildNodes.Count - 1 do
                  ParListaServicosAtivos.Classe.Add
                    (NoRetorno.ChildNodes.FindNode('servicos')
                    .ChildNodes.Get(I).Text);
              end;

              if NoRetorno.ChildNodes.FindNode('mac_adress') <> nil then
              begin
                ParMacAdress.Quantidades :=
                  StrToIntDef(NoRetorno.ChildNodes.FindNode('mac_adress')
                  .Attributes['quantidade'], 0);

                if NoRetorno.ChildNodes.FindNode('mac_adress')
                  .HasAttribute('ativo') then
                  ParMacAdress.Ativo :=
                    (NoRetorno.ChildNodes.FindNode('mac_adress').Attributes
                    ['ativo'] = 'S');

                ParMacAdress.Classe.Clear;
                for I := 0 to NoRetorno.ChildNodes.FindNode('mac_adress')
                  .ChildNodes.Count - 1 do
                  ParMacAdress.Classe.Add
                    (NoRetorno.ChildNodes.FindNode('mac_adress')
                    .ChildNodes.Get(I).Text);
              end;

              if NoRetorno.ChildNodes.FindNode('so') <> nil then
              begin
                ParSistemaOperacional.Quantidades :=
                  StrToIntDef(NoRetorno.ChildNodes.FindNode('so').Attributes
                  ['quantidade'], 0);

                if NoRetorno.ChildNodes.FindNode('so').HasAttribute('ativo')
                then
                  ParSistemaOperacional.Ativo :=
                    (NoRetorno.ChildNodes.FindNode('so').Attributes
                    ['ativo'] = 'S');

                ParSistemaOperacional.Classe.Clear;
                for I := 0 to NoRetorno.ChildNodes.FindNode('so')
                  .ChildNodes.Count - 1 do
                  ParSistemaOperacional.Classe.Add
                    (NoRetorno.ChildNodes.FindNode('so')
                    .ChildNodes.Get(I).Text);
              end;
            end;
          end;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      GravaArquivoLog(self, 'Operação 100700 - Retorno Padrão - ' + E.Message);
      LerXML.Active := False;
      LerXML.Xml.Clear;
      LerXML.Xml.Text := Operacao.XMLRetornoPadrao;
      LerXML.Active := True;
    end;
  end;

  FRetorno(self);

end;

procedure Operacao100700.SetUsuario(ParUsuario: String);
begin
  FUsuario := ParUsuario;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') then
    MontaXMLEnvio(self);
end;

procedure Operacao100700.SetSenha(ParSenha: String);
begin
  FSenha := ParSenha;
  if (Trim(FUsuario) <> '') and (Trim(FSenha) <> '') then
    MontaXMLEnvio(self);
end;

Procedure Operacao100700.MontaXMLEnvio(Sender: TObject);
var
  XMLDoc: IXMLDocument;
  XMLElementoEnvio: IXMLNode;
  XMLacesso: IXMLNode;
  XmlTexto: string;
begin
  if (Trim(FUsuario) = '') or (Trim(FSenha) = '') then
  begin
    codigo := 'B999';
    Mensagem := 'Falta parametros para executar a consulta!';
  end;

  XMLDoc := NewXMLDocument;
  XMLDoc.Active := False;
  XMLDoc.Active := True;

  XMLElementoEnvio := XMLDoc.AddChild('envio');
  XMLElementoEnvio.Text := ' ';

  XMLElementoEnvio.Attributes['servidor'] := ParServidor.ID_Sistema;
  XMLElementoEnvio.Attributes['usuario'] := ParCFC.id_cfc;
  XMLElementoEnvio.Attributes['operacao'] := '100700';
  XMLElementoEnvio.Attributes['versao'] := GetVersaoArq;

  XMLacesso := XMLElementoEnvio.AddChild('acesso');
  XMLacesso.Text := ' ';

  XMLDoc.SaveToXML(XmlTexto);

  Operacao := MainOperacao.Create(self, '<?xml version="1.0" encoding="UTF-8"?>'
    + XmlTexto, onXMLRetorno);
  Operacao.consutar;

end;

end.
