unit ClsResourceMG;

interface

uses System.SysUtils, System.Classes;

Function Frm_Login_XML872461: WideString;
Function Frm_IdentificaCandidato_XML872461: WideString;
Function frm_CadastroCandidato_XML872461: WideString;
Function Frm_Foto_XML872461: WideString;
Function Frm_BiometriaFotos_XML872461: WideString;
Function Frm_Informacoes_XML872461: WideString; export;
Function Frm_Confirmacao_XML872461: WideString;
Function frm_Flash_XML872461: WideString;
Function Frm_Questionario_XML872461: WideString;
Function Frm_Resultado_XML872461: WideString;

implementation

Function Frm_Login_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?><Frm_Login ClientHeight="268"'
    + ' ClientWidth="486" Caption="e-Prova XE"><Label1 tipo="TLabel" Left="24"'
    + ' Top="72" ClientHeight="13" ClientWidth="80"/><Label2 tipo="TLabel"' +
    ' Left="24" Top="118" ClientHeight="13" ClientWidth="30"/><Image1' +
    ' tipo="TImage" Left="272" Top="91" ClientHeight="74" ClientWidth="192"' +
    ' ImageResource="LogoMG"/><Label3 tipo="TLabel" Left="24" Top="164"' +
    ' ClientHeight="13" ClientWidth="59"/><SpeedButton1 tipo="TSpeedButton"' +
    ' Left="103" Top="212" ClientHeight="29" ClientWidth="113"/><Label4' +
    ' tipo="TLabel" Left="24" Top="8" ClientHeight="25" ClientWidth="153"/>' +
    '<Label5 tipo="TLabel" Left="24" Top="39" ClientHeight="13" ClientWidth="228"/>'
    + '<SpeedButton2 tipo="TSpeedButton" Left="264" Top="212" ClientHeight="29"'
    + ' ClientWidth="113"/><Image2 tipo="TImage" Left="24" Top="246" ClientHeight="16"'
    + ' ClientWidth="16"/><EdUsuario tipo="TButtonedEdit" Left="24" Top="91"' +
    ' ClientHeight="17" ClientWidth="188"/><EdSenha tipo="TButtonedEdit" Left="24"'
    + ' Top="137" ClientHeight="17" ClientWidth="188"/><EdComputador tipo="TButtonedEdit"'
    + ' Left="24" Top="183" ClientHeight="17" ClientWidth="55"/></Frm_Login>';
end;

Function Frm_IdentificaCandidato_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?><Frm_IdentificaCandidato ClientHeight="430"'
    + ' ClientWidth="583" Caption="e-Prova XE"><Label1 tipo="TLabel" Left="24" Top="69"'
    + ' ClientHeight="13" ClientWidth="41" Caption="CPF"/><Label2 tipo="TLabel" Left="24"'
    + ' Top="115" ClientHeight="13" ClientWidth="19" Caption="RENACH"/><Label3 tipo="TLabel"'
    + ' Left="24" Top="161" ClientHeight="16" ClientWidth="33"/><Label4' +
    ' tipo="TLabel" Left="24" Top="210" ClientHeight="16" ClientWidth="33"/>' +
    '<Label5 tipo="TLabel" Left="24" Top="259" ClientHeight="16"' +
    ' ClientWidth="39"/><Label6 tipo="TLabel" Left="24" Top="311"' +
    ' ClientHeight="16" ClientWidth="117"/><Label7 tipo="TLabel" Left="166"' +
    ' Top="311" ClientHeight="16" ClientWidth="28"/><SBtConsultaCandidato' +
    ' tipo="TSpeedButton" Left="151" Top="88" ClientHeight="22" ClientWidth="87"/>'
    + '<SBtProva tipo="TSpeedButton" Left="310" Top="365" ClientHeight="29"' +
    ' ClientWidth="137"/><SBtSimulado tipo="TSpeedButton" Left="167" Top="365"'
    + ' ClientHeight="29" ClientWidth="137"/><SBtRegistro tipo="TSpeedButton"' +
    ' Left="24" Top="365" ClientHeight="29" ClientWidth="137"/><Image2 tipo="TImage"'
    + ' Left="20" Top="408" ClientHeight="16" ClientWidth="16"/><SpeedButton2' +
    ' tipo="TSpeedButton" Left="464" Top="365" ClientHeight="29" ClientWidth="95"/>'
    + '<Label9 tipo="TLabel" Left="24" Top="8" ClientHeight="25" ClientWidth="214"/>'
    + '<Label10 tipo="TLabel" Left="24" Top="39" ClientHeight="13" ClientWidth="254"/>'
    + '<Image3 tipo="TImage" Left="367" Top="134" ClientHeight="74" ClientWidth="192"'
    + ' ImageResource="LogoMG"/><Image1 tipo="TImage" Left="52" Top="408" ClientHeight="16"'
    + ' ClientWidth="16"/><EdRENACH tipo="TButtonedEdit" Left="24" Top="88"' +
    ' ClientHeight="17" ClientWidth="117"/><EditCpf tipo="TEdit" Left="24"' +
    ' Top="134" ClientHeight="17" ClientWidth="117"/><EditNome tipo="TEdit"' +
    ' Left="24" Top="183" ClientHeight="17" ClientWidth="317"/><EditCurso' +
    ' tipo="TEdit" Left="24" Top="232" ClientHeight="17" ClientWidth="317"/>' +
    '<EditCidade tipo="TEdit" Left="24" Top="281" ClientHeight="17"' +
    ' ClientWidth="317"/><EditNascimento tipo="TEdit" Left="24" Top="330"' +
    ' ClientHeight="17" ClientWidth="113"/><EditSexo tipo="TEdit" Left="166"' +
    ' Top="330" ClientHeight="17" ClientWidth="175"/></Frm_IdentificaCandidato>';
end;

Function frm_CadastroCandidato_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<frm_CadastroCandidato ClientHeight="327" ClientWidth="583" Caption="e-Prova XE">'
    + '<Label9 tipo="TLabel" Left="24" Top="8" ClientHeight="25" ClientWidth="176" Caption="Cadastro do aluno."/>'
    + '<Label10 tipo="TLabel" Left="24" Top="39" ClientHeight="13" ClientWidth="261" Caption="Informe os dados do aluno que vai realizar o simulado."/>'
    + '<SBtSimulado tipo="TSpeedButton" Left="135" Top="283" ClientHeight="29" ClientWidth="137"/>'
    + '<SpeedButton2 tipo="TSpeedButton" Left="464" Top="283" ClientHeight="29" ClientWidth="95"/>'
    + '<Label2 tipo="TLabel" Left="24" Top="67" ClientHeight="13" ClientWidth="19" Caption="CPF"/>'
    + '<Label3 tipo="TLabel" Left="24" Top="113" ClientHeight="16" ClientWidth="33" Caption="Nome"/>'
    + '<Label4 tipo="TLabel" Left="24" Top="162" ClientHeight="16" ClientWidth="33" Caption="Curso"/>'
    + '<Label6 tipo="TLabel" Left="24" Top="211" ClientHeight="16" ClientWidth="117" Caption="Data de nascimento "/>'
    + '<Label7 tipo="TLabel" Left="166" Top="211" ClientHeight="16" ClientWidth="28" Caption="Sexo"/>'
    + '<Image3 tipo="TImage" Left="367" Top="113" ClientHeight="74" ClientWidth="192" ImageResource="LogoMG"/>'
    + '<SBtCancelar tipo="TSpeedButton" Left="24" Top="283" ClientHeight="29" ClientWidth="105"/>'
    + '<EditCpf tipo="TEdit" Left="24" Top="86" ClientHeight="17" ClientWidth="117" MaxLength="14"/>'
    + '<EditNome tipo="TEdit" Left="24" Top="135" ClientHeight="17" ClientWidth="317" MaxLength="0"/>'
    + '<CbBSexo tipo="TComboBox" Left="167" Top="233" ClientHeight="21" ClientWidth="179"/>'
    + '<cbbCurso tipo="TComboBox" Left="24" Top="184" ClientHeight="21" ClientWidth="321"/>'
    + '<EditNascimento tipo="TMaskEdit" Left="24" Top="233" ClientHeight="17" ClientWidth="116"/>'
    + '</frm_CadastroCandidato>';
end;

Function Frm_Foto_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Frm_Foto ClientHeight="486" ClientWidth="642" Caption="e-Prova XE">' +
    '<PaintBox_Video tipo="TPaintBox" Left="18" Top="82" ClientHeight="234"' +
    ' ClientWidth="314"/><ImgCapturada tipo="TImage" Left="18" Top="82"' +
    ' ClientHeight="234" ClientWidth="314"/><SpeedButton_Stop tipo="TSpeedButton"'
    + ' Left="300" Top="322" ClientHeight="35" ClientWidth="35"/><SpeedButton_RunVideo'
    + ' tipo="TSpeedButton" Left="259" Top="322" ClientHeight="35" ClientWidth="35"/>'
    + '<Label_Cameras tipo="TLabel" Left="17" Top="322" ClientHeight="13" ClientWidth="37"/>'
    + '<Label_fps tipo="TLabel" Left="115" Top="323" ClientHeight="13" ClientWidth="138"/>'
    + '<Panel5 tipo="TPanel" Left="342" Top="73" ClientHeight="346" ClientWidth="300"/>'
    + '<Image3 tipo="TImage" Left="14" Top="81" ClientHeight="74" ClientWidth="192" ImageResource="LogoMG"/>'
    + '<SpeedButton1 tipo="TSpeedButton" Left="456" Top="188" ClientHeight="29" ClientWidth="29"/>'
    + '<Label1 tipo="TLabel" Left="387" Top="161" ClientHeight="13" ClientWidth="63"/>'
    + '<ComboBox_DisplayMode tipo="TComboBox" Left="456" Top="161" ClientHeight="21"'
    + ' ClientWidth="157"/><Panel1 tipo="TPanel" Left="0" Top="419" ClientHeight="67"'
    + ' ClientWidth="642"/><SBtAplicar tipo="TSpeedButton" Left="268" Top="14"'
    + ' ClientHeight="29" ClientWidth="105"/><SBtRecarregar tipo="TSpeedButton"'
    + ' Left="11" Top="14" ClientHeight="29" ClientWidth="29"/><SBtSair tipo="TSpeedButton"'
    + ' Left="433" Top="14" ClientHeight="29" ClientWidth="105"/><SBtCancelar' +
    ' tipo="TSpeedButton" Left="15" Top="14" ClientHeight="29" ClientWidth="105"/>'
    + '<SpeedButton_Pause tipo="TSpeedButton" Left="141" Top="14" ClientHeight="29"'
    + ' ClientWidth="105"/><Image1 tipo="TImage" Left="15" Top="49" ClientHeight="16"'
    + ' ClientWidth="16"/><Panel2 tipo="TPanel" Left="0" Top="0" ClientHeight="73"'
    + ' ClientWidth="642"/><Label9 tipo="TLabel" Left="24" Top="8" ClientHeight="25"'
    + ' ClientWidth="188"/><Label10 tipo="TLabel" Left="24" Top="39" ClientHeight="13"'
    + ' ClientWidth="402"/><Panel4 tipo="TPanel" Left="0" Top="73" ClientHeight="346"'
    + ' ClientWidth="9"/><PnlConfiguracao tipo="TPanel" Left="766" Top="19" ClientHeight="305"'
    + ' ClientWidth="339"/><SpeedButton_VidSettings tipo="TSpeedButton" Left="293" Top="273"'
    + ' ClientHeight="22" ClientWidth="23"/><SpeedButton_VidSize tipo="TSpeedButton"'
    + ' Left="314" Top="273" ClientHeight="22" ClientWidth="23"/><Label2 tipo="TLabel"'
    + ' Left="1" Top="277" ClientHeight="13" ClientWidth="50"/><ComboBox_Cams' +
    ' tipo="TComboBox" Left="17" Top="336" ClientHeight="21" ClientWidth="236"/>'
    + '<ComboBox1 tipo="TComboBox" Left="24" Top="376" ClientHeight="21" ClientWidth="78"/>'
    + '</Frm_Foto>'
end;

Function Frm_BiometriaFotos_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Frm_BiometriaFotos ClientHeight="505" ClientWidth="703" Caption="e-Prova XE">'
    + '<Label1 tipo="TLabel" Left="823" Top="397" ClientHeight="13" ClientWidth="63"/>'
    + '<Label2 tipo="TLabel" Left="715" Top="416" ClientHeight="13" ClientWidth="50"/>'
    + '<WebBrowser1 tipo="TWebBrowser" Left="9" Top="73" ClientHeight="383"' +
    ' ClientWidth="356"/><Panel1 tipo="TPanel" Left="0" Top="456" ClientHeight="49"'
    + ' ClientWidth="703"/><SBtAplicar tipo="TSpeedButton" Left="402" Top="10"'
    + ' ClientHeight="29" ClientWidth="105"/><SBtRecarregar tipo="TSpeedButton"'
    + ' Left="200" Top="14" ClientHeight="29" ClientWidth="29"/><SBtSair tipo="TSpeedButton"'
    + ' Left="589" Top="10" ClientHeight="29" ClientWidth="105"/><SBtCancelar' +
    ' tipo="TSpeedButton" Left="291" Top="10" ClientHeight="29" ClientWidth="105"/>'
    + '<Image1 tipo="TImage" Left="194" Top="18" ClientHeight="16" ClientWidth="16"/>'
    + '<SpeedButton_RunVideo tipo="TSpeedButton" Left="9" Top="10" ClientHeight="29"'
    + ' ClientWidth="105"/><Panel5 tipo="TPanel" Left="368" Top="73" ClientHeight="383"'
    + ' ClientWidth="335"/><PaintBox_Video tipo="TPaintBox" Left="500" Top="2" ClientHeight="240"'
    + ' ClientWidth="320"/><ImgCapturada tipo="TImage" Left="8" Top="2" ClientHeight="240"'
    + ' ClientWidth="320"/><SpeedButton_Pause tipo="TSpeedButton" Left="217" Top="289"'
    + ' ClientHeight="33" ClientWidth="32"/><SpeedButton_Stop tipo="TSpeedButton" Left="294"'
    + ' Top="248" ClientHeight="34" ClientWidth="34"/><Label_Cameras tipo="TLabel" Left="8"'
    + ' Top="248" ClientHeight="13" ClientWidth="37"/><Label_fps tipo="TLabel" Left="130"'
    + ' Top="248" ClientHeight="13" ClientWidth="150"/><Label_VideoSize tipo="TLabel"'
    + ' Left="255" Top="324" ClientHeight="13" ClientWidth="75"/><Label3 tipo="TLabel"'
    + ' Left="255" Top="288" ClientHeight="13" ClientWidth="50"/><ComboBox_Cams tipo="TComboBox"'
    + ' Left="7" Top="262" ClientHeight="21" ClientWidth="274"/><ComboBox1 tipo="TComboBox"'
    + ' Left="255" Top="304" ClientHeight="21" ClientWidth="68"/><Panel2 tipo="TPanel"'
    + ' Left="0" Top="0" ClientHeight="73" ClientWidth="703"/><Label9 tipo="TLabel"'
    + ' Left="24" Top="4" ClientHeight="25" ClientWidth="462"/><Label10 tipo="TLabel"'
    + ' Left="24" Top="32" ClientHeight="13" ClientWidth="605"/><Panel4 tipo="TPanel"'
    + ' Left="0" Top="73" ClientHeight="383" ClientWidth="9"/><PnlConfiguracao tipo="TPanel"'
    + ' Left="715" Top="86" ClientHeight="305" ClientWidth="339"/><SpeedButton_VidSettings'
    + ' tipo="TSpeedButton" Left="293" Top="273" ClientHeight="22" ClientWidth="23"/>'
    + '<SpeedButton_VidSize tipo="TSpeedButton" Left="314" Top="273" ClientHeight="22"'
    + ' ClientWidth="23"/><ComboBox_DisplayMode tipo="TComboBox" Left="823" Top="413"'
    + ' ClientHeight="21" ClientWidth="157"/></Frm_BiometriaFotos>';
end;

Function Frm_Informacoes_XML872461: WideString; export;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Frm_Informacoes ClientHeight="580" ClientWidth="920" Caption="e-Prova XE">'
    + '<Image1 tipo="TImage" Left="0" Top="0" ClientHeight="580" ClientWidth="920"/>'
    + '<Label1 tipo="TLabel" Left="8" Top="8" ClientHeight="36" ClientWidth="898" Caption="Seja bem-vindo ao Sistema e-PROVA XE."/>'
    + '<SBtCancelar tipo="TSpeedButton" Left="801" Top="545" ClientHeight="29" ClientWidth="105"/>'
    + '<SBtAplicar tipo="TSpeedButton" Left="656" Top="545" ClientHeight="29" ClientWidth="105"/>'
    + '<Image2 tipo="TImage" Left="3" Top="3" ClientHeight="44" ClientWidth="96" ImageResource="LogoBA"/>'
    + '<Memo1 tipo="TMemo" Left="8" Top="56" ClientHeight="473" ClientWidth="898"/></Frm_Informacoes>';
end;

Function Frm_Confirmacao_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Frm_Confirmacao ClientHeight="581" ClientWidth="921" Caption="e-Prova XE">'
    + '<Image1 tipo="TImage" Left="0" Top="0" ClientHeight="581" ClientWidth="921"></Image1>'
    + '<SBtAplicar tipo="TSpeedButton" Left="664" Top="545" ClientHeight="29" ClientWidth="105"></SBtAplicar>'
    + '<SBtCancelar tipo="TSpeedButton" Left="553" Top="545" ClientHeight="29" ClientWidth="105"></SBtCancelar>'
    + '<Label1 tipo="TLabel" Left="8" Top="16" ClientHeight="18" ClientWidth="898"></Label1>'
    + '<Label_NomeCandidato tipo="TLabel" Left="9" Top="72" ClientHeight="30" ClientWidth="904"></Label_NomeCandidato>'
    + '<Label_CPF tipo="TLabel" Left="373" Top="103" ClientHeight="24" ClientWidth="176"></Label_CPF>'
    + '<LabelSexo tipo="TLabel" Left="380" Top="135" ClientHeight="24" ClientWidth="161"></LabelSexo>'
    + '<LabelNascimento tipo="TLabel" Left="389" Top="159" ClientHeight="24" ClientWidth="144"></LabelNascimento>'
    + '<Label_Curso tipo="TLabel" Left="9" Top="208" ClientHeight="24" ClientWidth="904"></Label_Curso>'
    + '<LabelData tipo="TLabel" Left="397" Top="233" ClientHeight="24" ClientWidth="128"></LabelData>'
    + '<LabelHora tipo="TLabel" Left="409" Top="257" ClientHeight="24" ClientWidth="104"></LabelHora>'
    + '<Label59 tipo="TLabel" Left="136" Top="315" ClientHeight="18" ClientWidth="649"></Label59>'
    + '<Label58 tipo="TLabel" Left="136" Top="294" ClientHeight="18" ClientWidth="649"></Label58>'
    + '<SBtInformacoes tipo="TSpeedButton" Left="30" Top="545" ClientHeight="29" ClientWidth="105"></SBtInformacoes>'
    + '<Image2 tipo="TImage" Left="3" Top="3" ClientHeight="44" ClientWidth="96" ImageResource="LogoMG"></Image2>'
    + '<Label_aguarde tipo="TLabel" Left="8" Top="339" ClientHeight="47" ClientWidth="904"></Label_aguarde>'
    + '<Image14 tipo="TImage" Left="8" Top="545" ClientHeight="16" ClientWidth="16"></Image14>'
    + '<SBtSair tipo="TSpeedButton" Left="805" Top="545" ClientHeight="29" ClientWidth="105"></SBtSair>'
    + '<GroupBox1 tipo="TGroupBox" Left="168" Top="392" ClientHeight="105" ClientWidth="577"></GroupBox1>'
    + '<Image3 tipo="TImage" Left="14" Top="15" ClientHeight="48" ClientWidth="48"></Image3>'
    + '<Image4 tipo="TImage" Left="514" Top="15" ClientHeight="48" ClientWidth="48"></Image4>'
    + '<Image5 tipo="TImage" Left="214" Top="15" ClientHeight="48" ClientWidth="48"></Image5>'
    + '<Image6 tipo="TImage" Left="314" Top="15" ClientHeight="48" ClientWidth="48"></Image6>'
    + '<Image7 tipo="TImage" Left="414" Top="15" ClientHeight="48" ClientWidth="48"></Image7>'
    + '<LblGerandoQuestionario tipo="TLabel" Left="6" Top="66" ClientHeight="26" ClientWidth="59"></LblGerandoQuestionario>'
    + '<LblAtualizandoandamento tipo="TLabel" Left="506" Top="66" ClientHeight="26" ClientWidth="65"></LblAtualizandoandamento>'
    + '<LblEnviandoimagemcandidato tipo="TLabel" Left="192" Top="69" ClientHeight="26" ClientWidth="95"></LblEnviandoimagemcandidato>'
    + '<LblIniciandomonitoramento tipo="TLabel" Left="302" Top="66" ClientHeight="26" ClientWidth="72"></LblIniciandomonitoramento>'
    + '<LblVerificandomonitoramento tipo="TLabel" Left="402" Top="66" ClientHeight="26" ClientWidth="72"></LblVerificandomonitoramento>'
    + '<Image8 tipo="TImage" Left="114" Top="15" ClientHeight="48" ClientWidth="48"></Image8>'
    + '<Lbl_VerificaBloqueio tipo="TLabel" Left="112" Top="66" ClientHeight="26" ClientWidth="53"></Lbl_VerificaBloqueio>'
    + '<Image9 tipo="TImage" Left="114" Top="15" ClientHeight="48" ClientWidth="48"></Image9>'
    + '<Image10 tipo="TImage" Left="214" Top="15" ClientHeight="48" ClientWidth="48"></Image10>'
    + '<Image11 tipo="TImage" Left="314" Top="15" ClientHeight="48" ClientWidth="48"></Image11>'
    + '<Image12 tipo="TImage" Left="414" Top="15" ClientHeight="48" ClientWidth="48"></Image12>'
    + '<Image13 tipo="TImage" Left="514" Top="15" ClientHeight="48" ClientWidth="48"></Image13>'
    + '</Frm_Confirmacao>';
end;

Function frm_Flash_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<frm_Flash ClientHeight="392" ClientWidth="314" Caption="e-Prova XE">' +
    '<ShockwaveFlash1 tipo="TShockwaveFlash" Left="0" Top="0" ClientHeight="389" ClientWidth="313"></ShockwaveFlash1>'
    + '<Panel1 tipo="TPanel" Left="367" Top="0" ClientHeight="35" ClientWidth="283"></Panel1>'
    + '<LblStatus tipo="TLabel" Left="2" Top="2" ClientHeight="13" ClientWidth="35"></LblStatus>'
    + '<LblRetorno tipo="TLabel" Left="2" Top="18" ClientHeight="13" ClientWidth="43"></LblRetorno>'
    + '<Memo1 tipo="TMemo" Left="367" Top="37" ClientHeight="376" ClientWidth="262"></Memo1>'
    + '</frm_Flash>';
end;

Function Frm_Questionario_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Frm_Questionario ClientHeight="651" ClientWidth="994" Caption="e-Prova XE">'
    + '<Image1 tipo="TImage" Left="0" Top="0" ClientHeight="651" ClientWidth="994"></Image1>'
    + '<Image25 tipo="TImage" Left="861" Top="4" ClientHeight="25" ClientWidth="25"></Image25>'
    + '<Image2 tipo="TImage" Left="3" Top="3" ClientHeight="51" ClientWidth="103" ImageResource="LogoMG"></Image2>'
    + '<Label_CPFProva tipo="TLabel" Left="130" Top="30" ClientHeight="16" ClientWidth="153"></Label_CPFProva>'
    + '<Label_NomeProva tipo="TLabel" Left="130" Top="8" ClientHeight="16" ClientWidth="731"></Label_NomeProva>'
    + '<Label_CursoProva tipo="TLabel" Left="616" Top="30" ClientHeight="16" ClientWidth="225"></Label_CursoProva>'
    + '<Label100 tipo="TLabel" Left="8" Top="69" ClientHeight="13" ClientWidth="59"></Label100>'
    + '<Label_Numero tipo="TLabel" Left="8" Top="82" ClientHeight="24" ClientWidth="59"></Label_Numero>'
    + '<LabelMateria tipo="TLabel" Left="73" Top="67" ClientHeight="16" ClientWidth="824"></LabelMateria>'
    + '<Label_RespostaC tipo="TLabel" Left="50" Top="365" ClientHeight="44" ClientWidth="930"></Label_RespostaC>'
    + '<Label_RespostaD tipo="TLabel" Left="52" Top="415" ClientHeight="44" ClientWidth="930"></Label_RespostaD>'
    + '<Label_RespostaE tipo="TLabel" Left="50" Top="466" ClientHeight="44" ClientWidth="930"></Label_RespostaE>'
    + '<Image_OpcaoA_Over tipo="TImage" Left="8" Top="265" ClientHeight="32" ClientWidth="32"></Image_OpcaoA_Over>'
    + '<Image_OpcaoB_Over tipo="TImage" Left="8" Top="315" ClientHeight="32" ClientWidth="32"></Image_OpcaoB_Over>'
    + '<Image_OpcaoC_Over tipo="TImage" Left="8" Top="365" ClientHeight="32" ClientWidth="32"></Image_OpcaoC_Over>'
    + '<Image_OpcaoD_Over tipo="TImage" Left="8" Top="415" ClientHeight="32" ClientWidth="32"></Image_OpcaoD_Over>'
    + '<Image_OpcaoE_Over tipo="TImage" Left="8" Top="466" ClientHeight="32" ClientWidth="32"></Image_OpcaoE_Over>'
    + '<Image_OpcaoA tipo="TImage" Left="8" Top="265" ClientHeight="32" ClientWidth="32"></Image_OpcaoA>'
    + '<Image_OpcaoB tipo="TImage" Left="8" Top="315" ClientHeight="32" ClientWidth="32"></Image_OpcaoB>'
    + '<Image_OpcaoC tipo="TImage" Left="8" Top="365" ClientHeight="32" ClientWidth="32"></Image_OpcaoC>'
    + '<Image_OpcaoD tipo="TImage" Left="8" Top="415" ClientHeight="32" ClientWidth="32"></Image_OpcaoD>'
    + '<Image_OpcaoE tipo="TImage" Left="8" Top="466" ClientHeight="32" ClientWidth="32"></Image_OpcaoE>'
    + '<Label_Tempo tipo="TLabel" Left="919" Top="11" ClientHeight="32" ClientWidth="70"></Label_Tempo>'
    + '<Label25 tipo="TLabel" Left="866" Top="10" ClientHeight="12" ClientWidth="18"></Label25>'
    + '<Image42 tipo="TImage" Left="887" Top="4" ClientHeight="25" ClientWidth="25"></Image42>'
    + '<Label33 tipo="TLabel" Left="889" Top="11" ClientHeight="12" ClientWidth="22"></Label33>'
    + '<Image45 tipo="TImage" Left="861" Top="28" ClientHeight="25" ClientWidth="25"></Image45>'
    + '<Label34 tipo="TLabel" Left="862" Top="33" ClientHeight="12" ClientWidth="24"></Label34>'
    + '<Image43 tipo="TImage" Left="887" Top="28" ClientHeight="25" ClientWidth="25"></Image43>'
    + '<Label60 tipo="TLabel" Left="889" Top="33" ClientHeight="12" ClientWidth="20"></Label60>'
    + '<SBtAnterior tipo="TSpeedButton" Left="30" Top="613" ClientHeight="29" ClientWidth="105"></SBtAnterior>'
    + '<SBtCancelar tipo="TSpeedButton" Left="879" Top="613" ClientHeight="29" ClientWidth="105"></SBtCancelar>'
    + '<SBtFinalizar tipo="TSpeedButton" Left="759" Top="614" ClientHeight="29" ClientWidth="105"></SBtFinalizar>'
    + '<SBtProximo tipo="TSpeedButton" Left="152" Top="613" ClientHeight="29" ClientWidth="105"></SBtProximo>'
    + '<Image14 tipo="TImage" Left="8" Top="613" ClientHeight="16" ClientWidth="16"></Image14>'
    + '<LblPergunta tipo="TLabel" Left="8" Top="519" ClientHeight="13" ClientWidth="48"></LblPergunta>'
    + '<Label_RespostaA tipo="TLabel" Left="47" Top="265" ClientHeight="44" ClientWidth="930"></Label_RespostaA>'
    + '<Label_Questao tipo="TLabel" Left="8" Top="112" ClientHeight="94" ClientWidth="745"></Label_Questao>'
    + '<Label_RespostaB tipo="TLabel" Left="52" Top="315" ClientHeight="44" ClientWidth="930"></Label_RespostaB>'
    + '<Panel1 tipo="TPanel" Left="683" Top="69" ClientHeight="299" ClientWidth="299"></Panel1>'
    + '<WBImage tipo="TWebBrowser" Left="500" Top="-4" ClientHeight="304" ClientWidth="305"></WBImage>'
    + '<GridPanel1 tipo="TGridPanel" Left="8" Top="538" ClientHeight="30" ClientWidth="879"></GridPanel1>'
    + '<EdtControledeTeclas tipo="TEdit" Left="1000" Top="98" ClientHeight="17" ClientWidth="117"></EdtControledeTeclas>'
    + '<LblNumeroQuestao01 tipo="TLabel" Left="0" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao01>'
    + '<LblNumeroQuestao02 tipo="TLabel" Left="22" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao02>'
    + '<LblNumeroQuestao03 tipo="TLabel" Left="44" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao03>'
    + '<LblNumeroQuestao04 tipo="TLabel" Left="66" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao04>'
    + '<LblNumeroQuestao05 tipo="TLabel" Left="88" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao05>'
    + '<LblNumeroQuestao06 tipo="TLabel" Left="110" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao06>'
    + '<LblNumeroQuestao07 tipo="TLabel" Left="132" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao07>'
    + '<LblNumeroQuestao08 tipo="TLabel" Left="154" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao08>'
    + '<LblNumeroQuestao09 tipo="TLabel" Left="176" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao09>'
    + '<LblNumeroQuestao10 tipo="TLabel" Left="198" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao10>'
    + '<LblNumeroQuestao11 tipo="TLabel" Left="220" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao11>'
    + '<LblNumeroQuestao12 tipo="TLabel" Left="242" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao12>'
    + '<LblNumeroQuestao13 tipo="TLabel" Left="264" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao13>'
    + '<LblNumeroQuestao14 tipo="TLabel" Left="286" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao14>'
    + '<LblNumeroQuestao15 tipo="TLabel" Left="308" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao15>'
    + '<LblNumeroQuestao16 tipo="TLabel" Left="330" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao16>'
    + '<LblNumeroQuestao17 tipo="TLabel" Left="352" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao17>'
    + '<LblNumeroQuestao18 tipo="TLabel" Left="374" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao18>'
    + '<LblNumeroQuestao19 tipo="TLabel" Left="396" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao19>'
    + '<LblNumeroQuestao20 tipo="TLabel" Left="418" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao20>'
    + '<LblNumeroQuestao21 tipo="TLabel" Left="440" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao21>'
    + '<LblNumeroQuestao22 tipo="TLabel" Left="462" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao22>'
    + '<LblNumeroQuestao23 tipo="TLabel" Left="484" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao23>'
    + '<LblNumeroQuestao24 tipo="TLabel" Left="506" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao24>'
    + '<LblNumeroQuestao25 tipo="TLabel" Left="528" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao25>'
    + '<LblNumeroQuestao26 tipo="TLabel" Left="550" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao26>'
    + '<LblNumeroQuestao27 tipo="TLabel" Left="572" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao27>'
    + '<LblNumeroQuestao28 tipo="TLabel" Left="594" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao28>'
    + '<LblNumeroQuestao29 tipo="TLabel" Left="616" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao29>'
    + '<LblNumeroQuestao30 tipo="TLabel" Left="638" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao30>'
    + '<LblNumeroQuestao31 tipo="TLabel" Left="660" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao31>'
    + '<LblNumeroQuestao32 tipo="TLabel" Left="682" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao32>'
    + '<LblNumeroQuestao33 tipo="TLabel" Left="704" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao33>'
    + '<LblNumeroQuestao34 tipo="TLabel" Left="726" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao34>'
    + '<LblNumeroQuestao35 tipo="TLabel" Left="748" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao35>'
    + '<LblNumeroQuestao36 tipo="TLabel" Left="770" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao36>'
    + '<LblNumeroQuestao37 tipo="TLabel" Left="792" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao37>'
    + '<LblNumeroQuestao38 tipo="TLabel" Left="814" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao38>'
    + '<LblNumeroQuestao39 tipo="TLabel" Left="836" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao39>'
    + '<LblNumeroQuestao40 tipo="TLabel" Left="858" Top="0" ClientHeight="30" ClientWidth="22"></LblNumeroQuestao40>'
    + '</Frm_Questionario>';
end;

Function Frm_Resultado_XML872461: WideString;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' +
    '<Frm_Resultado ClientHeight="651" ClientWidth="994" Caption="e-Prova XE">'
    + '<Image1 tipo="TImage" Left="0" Top="0" ClientHeight="650" ClientWidth="993"></Image1>'
    + '<Label_CPFProva tipo="TLabel" Left="130" Top="30" ClientHeight="16" ClientWidth="153"></Label_CPFProva>'
    + '<Label_NomeProva tipo="TLabel" Left="122" Top="8" ClientHeight="16" ClientWidth="729"></Label_NomeProva>'
    + '<Image2 tipo="TImage" Left="3" Top="4" ClientHeight="51" ClientWidth="105" ImageResource="LogoMG"></Image2>'
    + '<Label_CursoProva tipo="TLabel" Left="618" Top="30" ClientHeight="16" ClientWidth="225"></Label_CursoProva>'
    + '<SBtFinalizar tipo="TSpeedButton" Left="769" Top="611" ClientHeight="29" ClientWidth="105"></SBtFinalizar>'
    + '<SBtCancelar tipo="TSpeedButton" Left="880" Top="611" ClientHeight="29" ClientWidth="105"></SBtCancelar>'
    + '<SpeedButton1 tipo="TSpeedButton" Left="30" Top="611" ClientHeight="29" ClientWidth="105"></SpeedButton1>'
    + '<SpeedButton2 tipo="TSpeedButton" Left="252" Top="611" ClientHeight="29" ClientWidth="166"></SpeedButton2>'
    + '<Image14 tipo="TImage" Left="8" Top="613" ClientHeight="16" ClientWidth="16"></Image14>'
    + '<SpeedButton3 tipo="TSpeedButton" Left="424" Top="611" ClientHeight="29" ClientWidth="166"></SpeedButton3>'
    + '<SpeedButton4 tipo="TSpeedButton" Left="141" Top="611" ClientHeight="29" ClientWidth="105"></SpeedButton4>'
    + '<ListBox1 tipo="TListBox" Left="8" Top="64" ClientHeight="525" ClientWidth="237"></ListBox1>'
    + '<PageControl1 tipo="TPageControl" Left="270" Top="62" ClientHeight="532" ClientWidth="721"></PageControl1>'
    + '<TSGrafico tipo="TTabSheet" Left="4" Top="6" ClientHeight="519" ClientWidth="722"></TSGrafico>'
    + '<DBChart1 tipo="TDBChart" Left="0" Top="0" ClientHeight="519" ClientWidth="722"></DBChart1>'
    + '<TSImpressao tipo="TTabSheet" Left="4" Top="6" ClientHeight="519" ClientWidth="722"></TSImpressao>'
    + '<WebBrowser1 tipo="TWebBrowser" Left="0" Top="0" ClientHeight="519" ClientWidth="722"></WebBrowser1>'
    + '<TSGrafico2 tipo="TTabSheet" Left="4" Top="6" ClientHeight="519" ClientWidth="722"></TSGrafico2>'
    + '<DBChart2 tipo="TDBChart" Left="0" Top="0" ClientHeight="519" ClientWidth="722"></DBChart2>'
    + '<TSGrafico3 tipo="TTabSheet" Left="4" Top="6" ClientHeight="519" ClientWidth="722"></TSGrafico3>'
    + '<Chart1 tipo="TChart" Left="0" Top="0" ClientHeight="519" ClientWidth="722"></Chart1>'
    + '<Label1 tipo="TLabel" Left="1" Top="505" ClientHeight="13" ClientWidth="720"></Label1>'
    + '</Frm_Resultado>';
end;

end.
