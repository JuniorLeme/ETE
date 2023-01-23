unit ClsCFCControl;

interface

uses
  System.SysUtils, System.IniFiles, Winapi.Windows, System.Classes, vcl.Dialogs,
  Xml.XMLIntf, Xml.XMLDoc, cipher, ClsFuncoes;

type
  CFC = class(TObject)
  private
    FAvisoSEITran: Boolean;

  protected
    // CFC
    FURLSEITrans: string;
    FID: string;
    FUsuario: string;
    FSenha: string;
    FComputador: string;
    FUltimo_Acesso: string;
    FNomeCFC: string;
    FVersao: string;
    FCod_Ciretran: string;
    FBiometria: string;
    FFoto: string;
    FComputador1: string;
    Fnome_fantasia: string;
    FCod_Ciretran1: string;
    FURL_Biometria1: string;
    FURL_Foto1: string;
    FURL_Gabarito: string;
    FURL_Prova: string;
    FURL_Gabarito_Operacao: string;
    FURL_Prova_Operacao: string;
    FUF: string;
    FProva: string;
    FMonitoramento_prova: string;
    FSimulado: string;
    FMonitoramento_Simulado: string;
    FFoto_prova: string;
    FBiometria_prova: string;
    FBiometria_Foto_prova: string;
    FBiometria_Foto_Quantidade_prova: string;
    FBiometria_Foto_Tempo_prova: string;
    Ffoto_exame_Prova: string;
    Ffoto_exame_Tempo_Prova: string;
    Ffoto_exame_Quantidade_Prova: string;
    FFoto_Simulado: string;
    FBiometria_Simulado: string;
    FBiometria_Foto_Simulado: string;
    FBiometria_Foto_Quantidade_Simulado: string;
    FBiometria_Foto_Tempo_Simulado: string;
    Ffoto_exame_Simulado: string;
    Ffoto_exame_Tempo_Simulado: string;
    Ffoto_exame_Quantidade_Simulado: string;
    FTela_Confirmacao: string;
    FTela_Instrucoes: string;
    FTela_Teclado: string;
    FFotoMetodo: Integer;
    FImpressao_Automatica: string;
    FImpressao_Gabarito_Simulado: string;
    FImpressao_Questionario_Simulado: string;
    FImpressao_Gabarito_Prova: string;
    FImpressao_Questionario_Prova: string;
    FTela_Cadastro_prova: string;
    FTela_Cadastro_simulado: string;
    procedure SetId_CFC(ID: String);
    function GetId_CFC(): String;
    procedure SetNomeCFC(Nome: String);
    function GetNomeCFC(): String;
    procedure SetUsuario(Usuario: String);
    function GetUsuario(): String;
    procedure SetSenha(arg: String);
    function GetSenha(): String;
    procedure SetComputador(Computador: String);
    function GetComputador(): String;
    function GetUltimoAcesso(): string;
  public
    ListaCursoDescriProva: array [0 .. 10] of string;
    ListaCursoCodProva: array [0 .. 10] of string;
    ListaCursoDescriSimulado: array [0 .. 10] of string;
    ListaCursoCodSimulado: array [0 .. 10] of string;
    property id_cfc: String read GetId_CFC write SetId_CFC;
    property NomeCFC: String read GetNomeCFC write SetNomeCFC;
    property nome_fantasia: string read Fnome_fantasia write Fnome_fantasia;
    property Cod_Ciretran: String read FCod_Ciretran write FCod_Ciretran;
    property URL_Biometria: String read FBiometria write FBiometria;
    property URL_Foto: String read FFoto write FFoto;
    property URL_Gabarito: String read FURL_Gabarito write FURL_Gabarito;
    property URL_Prova: String read FURL_Prova write FURL_Prova;
    property URL_Gabarito_Operacao: string read FURL_Gabarito_Operacao
      write FURL_Gabarito_Operacao;
    property URL_Prova_Operacao: string read FURL_Prova_Operacao
      write FURL_Prova_Operacao;
    property URL_Biometria1: string read FURL_Biometria1 write FBiometria;
    property URL_Foto1: string read FURL_Foto1 write FFoto;
    property UF: string read FUF write FUF;
    property Prova: string read FProva write FProva;
    property Monitoramento_prova: string read FMonitoramento_prova
      write FMonitoramento_prova;
    property Simulado: string read FSimulado write FSimulado;
    property Monitoramento_Simulado: string read FMonitoramento_Simulado
      write FMonitoramento_Simulado;
    property Foto_prova: string read FFoto_prova write FFoto_prova;
    property Biometria_prova: string read FBiometria_prova
      write FBiometria_prova;
    property Biometria_Foto_prova: string read FBiometria_Foto_prova
      write FBiometria_Foto_prova;
    property Biometria_Foto_Quantidade_prova: string
      read FBiometria_Foto_Quantidade_prova
      write FBiometria_Foto_Quantidade_prova;
    property Biometria_Foto_Tempo_prova: string read FBiometria_Foto_Tempo_prova
      write FBiometria_Foto_Tempo_prova;
    property Foto_Simulado: string read FFoto_Simulado write FFoto_Simulado;
    property Biometria_Simulado: string read FBiometria_Simulado
      write FBiometria_Simulado;
    property Biometria_Foto_Simulado: string read FBiometria_Foto_Simulado
      write FBiometria_Foto_Simulado;
    property Biometria_Foto_Quantidade_Simulado: string
      read FBiometria_Foto_Quantidade_Simulado
      write FBiometria_Foto_Quantidade_Simulado;
    property Biometria_Foto_Tempo_Simulado: string
      read FBiometria_Foto_Tempo_Simulado write FBiometria_Foto_Tempo_Simulado;
    property Foto_Exame_Prova: string read Ffoto_exame_Prova
      write Ffoto_exame_Prova;
    property Foto_Exame_Quantidade_Prova: string
      read Ffoto_exame_Quantidade_Prova write Ffoto_exame_Quantidade_Prova;
    property Foto_Exame_Tempo_Prova: string read Ffoto_exame_Tempo_Prova
      write Ffoto_exame_Tempo_Prova;
    property Foto_Exame_Simulado: string read Ffoto_exame_Simulado
      write Ffoto_exame_Simulado;
    property Foto_Exame_Quantidade_Simulado: string
      read Ffoto_exame_Quantidade_Simulado
      write Ffoto_exame_Quantidade_Simulado;
    property Foto_Exame_Tempo_Simulado: string read Ffoto_exame_Tempo_Simulado
      write Ffoto_exame_Tempo_Simulado;
    property Tela_Confirmacao: string read FTela_Confirmacao
      write FTela_Confirmacao;
    property Tela_Instrucoes: string read FTela_Instrucoes
      write FTela_Instrucoes;
    property Tela_Teclado: string read FTela_Teclado write FTela_Teclado;
    property FotoMetodo: Integer read FFotoMetodo write FFotoMetodo;
    property Impressao_Gabarito_Simulado: string read FImpressao_Gabarito_Prova
      write FImpressao_Gabarito_Prova;
    property Impressao_Questionario_Simulado: string
      read FImpressao_Questionario_Simulado
      write FImpressao_Questionario_Simulado;
    property Impressao_Gabarito_Prova: string read FImpressao_Gabarito_Prova
      write FImpressao_Gabarito_Prova;
    property Impressao_Questionario_Prova: string
      read FImpressao_Questionario_Prova write FImpressao_Questionario_Prova;
    property Impressao_Automatica: string read FImpressao_Automatica
      write FImpressao_Automatica;
    property Tela_Cadastro_prova: string read FTela_Cadastro_prova
      write FTela_Cadastro_prova;
    property Tela_Cadastro_Simulado: string read FTela_Cadastro_simulado
      write FTela_Cadastro_simulado;
    property URLSEITrans: string read FURLSEITrans write FURLSEITrans;
    property AvisoSEITran: Boolean read FAvisoSEITran write FAvisoSEITran;
  end;

var
  ParCFC: CFC;

implementation

procedure CFC.SetId_CFC(ID: String);
begin
  FID := ID;
end;

function CFC.GetId_CFC(): String;
begin
  if Trim(FID) = '' then
    Result := '0'
  else
    Result := FID;
end;

procedure CFC.SetNomeCFC(Nome: String);
begin
  FNomeCFC := Nome;
end;

function CFC.GetNomeCFC(): String;
begin
  Result := FNomeCFC;
end;

procedure CFC.SetUsuario(Usuario: String);
begin
  FUsuario := Cifra(Usuario, 'AXF');
end;

function CFC.GetUsuario(): String;
begin
  Result := Decifra(iif(FUsuario = 'Erro', '', FUsuario), 'AXF');
end;

procedure CFC.SetSenha(arg: String);
begin
  FSenha := Cifra(arg, 'AXF');
end;

function CFC.GetSenha(): String;
begin
  Result := Decifra(iif(FSenha = 'Erro', '', FSenha), 'AXF');
end;

procedure CFC.SetComputador(Computador: String);
begin
  FComputador := Computador;
end;

function CFC.GetComputador(): String;
begin
  Result := FComputador;
end;

function CFC.GetUltimoAcesso(): string;
begin
  Result := FUltimo_Acesso;
end;

end.
