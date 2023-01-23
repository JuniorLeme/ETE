unit ClsListaBloqueio;

interface
  uses
    System.Classes, System.SysUtils, System.IniFiles, System.Win.Registry,
    Winapi.Windows, Winapi.WinSvc, Vcl.Dialogs, Tlhelp32, System.JSON,
    ClsParametros, ClsFuncoes, Datasnap.DSClientRest;

type
  TShisnine = class
  protected

    FEnviar_Processos: string;
    FVerifica_Processos_Quantidade_simulado: Integer;
    FVerifica_Processos_tempo_simulado: Integer;

    FVerifica_Processos_Quantidade_Prova: Integer;
    FVerifica_Processos_tempo_Prova: Integer;

  public
    Prova_Tempo: Integer;
    Prova_Ativo: Boolean;

    Simulado_Tempo: Integer;
    Simulado_Ativo: Boolean;

    property Enviar_Processos: string read Fenviar_processos write Fenviar_processos;
    property Verifica_Processos_Quantidade_simulado: Integer read FVerifica_Processos_Quantidade_simulado write FVerifica_Processos_Quantidade_simulado;
    property Verifica_Processos_tempo_simulado: Integer read FVerifica_Processos_tempo_simulado write FVerifica_Processos_tempo_simulado;

    property Verifica_Processos_Quantidade_Prova: Integer read FVerifica_Processos_Quantidade_Prova write FVerifica_Processos_Quantidade_Prova;
    property Verifica_Processos_tempo_Prova: Integer read FVerifica_Processos_tempo_Prova write FVerifica_Processos_tempo_Prova;

//    Procedure GetListaWMI(arg:Boolean);
  end;

  TFotoExame = class(TComponent)
  protected
  public
    Prova_Ativo: Boolean;
    Prova_Quantidades: Integer;
    Prova_Tempo: Integer;

    Simulado_Ativo: Boolean;
    Simulado_Quantidades: Integer;
    Simulado_Tempo: Integer;
  end;

  TMacAdress = class(TStringList)
  protected
  public
    Ativo: Boolean;
    Classe: TStringList;
    Quantidades: Integer;
  end;

  TSistemaOperacional = class(TStringList)
  protected
  public
    Ativo: Boolean;
    Classe: TStringList;
    Quantidades: Integer;
  end;

  TListaAplicativos = class(TStringList)
  protected

  public
    Ativo: Boolean;
    Classe: TStringList;
    Quantidades: Integer;
    ListaSoftwaresIgnodos : TStringList;
  end;

  TListaDispositivos = class(TStringList)
  protected
  public
    Ativo: Boolean;
    Classe: TStringList;
    Quantidades: Integer;
  end;

  TListaProcessosAtivos = class(TStringList)
  protected
  public
    Ativo: Boolean;
    Classe: TStringList;
    Quantidades: Integer;
  end;

  TListaServicosAtivos = class(TStringList)
  protected
  public
    Ativo: Boolean;
    Classe: TStringList;
    Quantidades: Integer;
  end;

  ProcessosServicosProibidos = class
    ID: TStringList;
    Janelas: TStringList;
    Processos: TStringList;
    Servicos: TStringList;
  protected
    function getProcessosProibido(arg: string): Boolean;
    function getServicosProibido(arg: string): Boolean;
  public
    constructor Create;
  end;

  ProcessosServicosProibidosAtivos = class
    ID: TStringList;
    Janelas: TStringList;
    Processos: TStringList;
    Servicos: TStringList;
  protected
    function setIDServicosProcessosProibido(arg: string): Boolean;
    function setDescServicosProcessosProibido(arg: string): Boolean;
  public
    constructor Create;
  end;

var
  ParProcessosServicosProibidos: ProcessosServicosProibidos;
  ParProcessosServicosProibidosAtivos: ProcessosServicosProibidosAtivos;

  ParMacAdress: TMacAdress;
  ParSistemaOperacional: TSistemaOperacional;
  ParListaProcessosAtivos: TListaProcessosAtivos;
  ParListaServicosAtivos: TListaServicosAtivos;
  ParListaDispositivos: TListaDispositivos;
  ParListaAplicativos : TListaAplicativos;
  ParFotoExame: TFotoExame;
  ParShisnine: TShisnine;

implementation

function ProcessosServicosProibidosAtivos.setIDServicosProcessosProibido(arg: string): Boolean;
begin
  // Lista de Identificação
  Self.ID.Add(arg);
  Result := True;
end;

function ProcessosServicosProibidosAtivos.setDescServicosProcessosProibido(arg: string): Boolean;
begin
  // Lista de Processos
  Self.Processos.Add(arg);
  Result := True;
end;

constructor ProcessosServicosProibidos.Create;
begin
  // Lista de Processos/ Serviços
  ID := TStringList.Create;
  Janelas := TStringList.Create;
  Processos := TStringList.Create;
  Servicos := TStringList.Create;
end;

constructor ProcessosServicosProibidosAtivos.Create;
var
  I: integer;
  P: integer;
  S: integer;
begin

  // Lista de Identificador
  ID := TStringList.Create;

  // Lista de janelas
  Janelas := TStringList.Create;

  // Lista de Processos
  Processos := TStringList.Create;

  // Lista de Serviço
  Servicos := TStringList.Create;

  if ParProcessosServicosProibidos = nil then
    ParProcessosServicosProibidos := ProcessosServicosProibidos.Create;

  for I := 0 to ParProcessosServicosProibidos.ID.Count - 1 do
  begin

    // Lista de Processos
    if ParListaProcessosAtivos.IndexOf(ParProcessosServicosProibidos.Processos[I]) > 0 then
    begin
      Self.setIDServicosProcessosProibido (ParProcessosServicosProibidos.ID[I]);
      Self.setDescServicosProcessosProibido (ParProcessosServicosProibidos.Janelas[I]);
    end;

    // Lista de Serviço Proibidos
    if ParListaServicosAtivos.IndexOf(ParProcessosServicosProibidos.Servicos[I]) > 0 then
    begin
      Self.setIDServicosProcessosProibido (ParProcessosServicosProibidos.ID[I]);
      Self.setDescServicosProcessosProibido (ParProcessosServicosProibidos.Servicos[I]);
    end;
  end;

end;

function ProcessosServicosProibidos.getProcessosProibido(arg: string): Boolean;
begin
  Result := (Self.Processos.IndexOf(arg) > -1);
end;

function ProcessosServicosProibidos.getServicosProibido(arg: string): Boolean;
begin
  Result := (Self.Servicos.IndexOf(arg) > -1);
end;

end.
