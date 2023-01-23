unit frmFlash;

interface
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw,
    Vcl.StdCtrls, ShockwaveFlashObjects_TLB, Vcl.ExtCtrls, System.AnsiStrings,
    ClsUsb, ClsParametros, System.UITypes, ClsCFCControl, ClsMonitoramentoControl,
    ClsCandidatoControl, ClsListaBloqueio, ClsProva ;

type
  Tfrm_Flash = class(TForm)
    ShockwaveFlash1: TShockwaveFlash;
    Panel1: TPanel;
    LblStatus: TLabel;
    LblRetorno: TLabel;
    Memo1: TMemo;
    TmrMinimiza: TTimer;

    procedure ShockwaveFlash1FSCommand(ASender: TObject;
      const command, args: WideString);
    procedure ShockwaveFlash1ReadyStateChange(ASender: TObject;
      newState: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TmrMinimizaTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FUsb: TUsbClass;

    procedure UsbIN(ASender: TObject; const ADevType, ADriverName,
      AFriendlyName: string);
    procedure UsbOUT(ASender: TObject; const ADevType, ADriverName,
      AFriendlyName: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Flash: Tfrm_Flash;

implementation

uses ClsFuncoes;
{$R *.dfm}

procedure Tfrm_Flash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShockwaveFlash1.Stop;
  ParMonitoramento.Status := 0;
  Action := caFree;
end;

procedure Tfrm_Flash.FormCreate(Sender: TObject);
begin
  if ParCFC.UF = 'SP' then
    Application.Icon.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Peletronica.ico');
end;

procedure Tfrm_Flash.FormShow(Sender: TObject);
var
  FlashVars: WideString;
begin

  { Capta o endereço da página }
  if ParMonitoramento.server = '' then
    ParMonitoramento.server := 'server1.eprova.grupocriar.com.br';

  if Trim(ParMonitoramento.Endereco) = '' then
    ParMonitoramento.Endereco := 'http://www2.e-prova.com.br/'+ParCFC.UF+'/monitoramento/swf/monitoramento_v1.6.swf';

  { Cria o objeto USB }
  FUsb := TUsbClass.Create;
  FUsb.OnUsbInsertion := UsbIN;
  FUsb.OnUsbRemoval := UsbOUT;

 // 'http://vidia.keynet.com.br/e-cfcanet/monitoramento/swf/monitoramento_v1.6.swf';
  ShockwaveFlash1.Base  := ParMonitoramento.Endereco;
  ShockwaveFlash1.Movie := ParMonitoramento.Endereco;

  { Gera o arquivo de parametros para o Flash }
  FlashVars := WideString('ciretran=' + RightStr('000' + ParCFC.Cod_Ciretran, 3) + '&');
  FlashVars := FlashVars + WideString('cfc=' + RightStr('00000' + ParCFC.id_Cfc, 5) + '&');
  FlashVars := FlashVars + WideString('sala=' + RightStr('00' + Parametros.Computador, 2) + '&');
  FlashVars := FlashVars + WideString('camera=' + RightStr('00' + Parametros.Computador, 2) + '&');
  FlashVars := FlashVars + 'taxa=' + ParMonitoramento.Taxa + '&';
  FlashVars := FlashVars + 'compressao=' + ParMonitoramento.Compressao + '&';
  FlashVars := FlashVars + 'largura=' + ParMonitoramento.Largura + '&';
  FlashVars := FlashVars + 'altura=' + ParMonitoramento.Altura + '&';
  FlashVars := FlashVars + 'fps=' + ParMonitoramento.Fps + '&';
  FlashVars := FlashVars + 'tempoatualizacao=' + ParMonitoramento.Tempo + '&';
  FlashVars := FlashVars + 'date=' + ParMonitoramento.Data + '&';
  FlashVars := FlashVars + 'time=' + ParMonitoramento.Hora + '&';
  FlashVars := FlashVars + 'host=' + ParMonitoramento.Host + '&';
  FlashVars := FlashVars + 'uf=' + LowerCase(ParCFC.UF) + '&';
  FlashVars := FlashVars + 'prova=' + IntToStr(ParQuestionario.ID_Prova) + '&';
  FlashVars := FlashVars + 'cpf=' + ParCandidato.CPFCandidato + '&';
  FlashVars := FlashVars + 'idcfc=' + ParCFC.id_Cfc + '&';
  FlashVars := FlashVars + 'dados=' + 'eCFCANet' + '&';

  ShockwaveFlash1.FlashVars := FlashVars;
  ShockwaveFlash1.Play;

end;

procedure Tfrm_Flash.ShockwaveFlash1FSCommand(ASender: TObject;
  const command, args: WideString);
begin

  if Trim(args) <> '' then
  begin
    ParMonitoramento.Arquivo := args;
    GravaArquivoLog('# Arquivo do monitoramento: ' + args);
  end;

  Memo1.Lines.Add('Retorno: ' + command + ' - Arg: ' +
    ParMonitoramento.Arquivo);

  { Atualiza o registro de monitoramento online }
  if command = 'inicia' then
  begin
    ParMonitoramento.Status := 1;
    ParMonitoramento.Situacao := 'V';
    if Self.WindowState <> wsMinimized then
      TmrMinimiza.Enabled := True
    else
      TmrMinimiza.Enabled := False;
  end;

  { Atualiza o registro de monitoramento online }
  if Trim(command) = 'atualiza' then
  begin

    ParMonitoramento.Status := 2;
    ParMonitoramento.Situacao := 'V';
    // Exemplo para chamar o flash

    try
      if ParFotoExame <> nil then
        ParCandidato.Foto := ShockwaveFlash1.CallFunction('<invoke name="captura"><arguments><string>captureImagem</string></arguments></invoke>');
    except on E: Exception do

    end;

  end;

  { Atualiza o registro de monitoramento online }
  if command = 'erro' then
  begin
    ParMonitoramento.Status := 9;
  end;

  LblRetorno.Caption := 'Retorno: ' + command + ' - Arg: ' + args;
end;

procedure Tfrm_Flash.ShockwaveFlash1ReadyStateChange(ASender: TObject;
  newState: Integer);
begin
  LblStatus.Caption := 'Status: ' + IntToStr(newState);
  Memo1.Lines.Add('Status: ' + IntToStr(newState));
end;

procedure Tfrm_Flash.TmrMinimizaTimer(Sender: TObject);
begin
  frm_Flash.WindowState := wsMinimized;
  TmrMinimiza.Enabled := False;
end;

procedure Tfrm_Flash.UsbIN(ASender: TObject; const ADevType, ADriverName,
  AFriendlyName: string);
begin
  { Nada a fazer quando inserir algum device }
end;

procedure Tfrm_Flash.UsbOUT(ASender: TObject; const ADevType, ADriverName,
  AFriendlyName: string);
begin
  if Pos('USB Composite Device', ADevType) > 0 then
  begin
    ParMonitoramento.Status := 9;
//    MessageDLG('ATENÇÂO!' + #13 + #13 +
//      'Houve uma falha na comunicação com o dispositivo de vídeo.' + #13 +
//      'Por favor reinicie o aplicativo.', mtInformation, [mbOK], 0);
    Self.Close;
  end;
end;

end.
