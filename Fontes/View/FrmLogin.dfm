object Frm_Login: TFrm_Login
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CRIAR Sistemas Inteligentes'
  ClientHeight = 337
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 122
    Width = 80
    Height = 13
    Caption = 'Nome de usu'#225'rio'
  end
  object Label2: TLabel
    Left = 24
    Top = 168
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object Image1: TImage
    Tag = 1
    Left = 272
    Top = 124
    Width = 192
    Height = 74
    Center = True
    Proportional = True
    OnDblClick = Image1DblClick
  end
  object Label3: TLabel
    Left = 24
    Top = 214
    Width = 59
    Height = 13
    Caption = 'Computador'
  end
  object SpeedButton1: TSpeedButton
    Left = 103
    Top = 278
    Width = 113
    Height = 29
    Caption = '&Entrar'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
      FBFBFBF1F1F1E8E8E8E2E2E2DDDDDDDBDBDBDCDCDCDEDEDEE4E4E4EDEDEDF8F8
      F8FEFEFEFFFFFFFFFFFFFFFFFFF8F8F8DCDCDCB8B8B89D9D9D8A8A8A7F7F7F79
      79797A7A7A8181818F8F8FA9A9A9CECECEF1F1F1FEFEFEFFFFFFFFFFFFE9E2DC
      B59981AA7D52BD8347C9843AD18936C9781FC58338B27E439576577069648484
      84D2D2D2F9F9F9FFFFFFFFFFFFF0A355EEAC52E3963AF5BA6CF5BC6EF9B75BB5
      5D18F5B14AEAA742DC8B1FDA801480756CC7C7C7F8F8F8FFFFFFFFFFFFF3AF68
      F3B864F4B86CF7BE7AEFA654DB75040002A6E77C00EDAA4CE59C34DE8E1C8E7F
      72D1D1D1FBFBFBFFFFFFFFFFFFF2C095F5B869F8C07CECA65CF0A350BB7A4F00
      08FCF89313DB811DE8A53FE28A1C9D9691E3E3E3FEFEFEFFFFFFFFFFFFFEF4EA
      EB9C46FFCF91DE8833FFD99FCA99732A5DFFF69F2CE18D2EE79F37CF8E47CACA
      CAF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFBCEA2E38728EA9942FFA541BDB0D05E
      73F4F89F31E0851ED9862CD1C4B8F2F2F2FEFEFEFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFF9D8BCE8913C7A94AA39A8FF3AA3FF9C8A6DB97B4CB5ABA4ECECECFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF66B6E35ABBFF69BDFF67
      BDFF48B0FE6578819F9F9FE9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF8BBDD968C2FF7CC7FF80CAFF7DC8FF75C3FF6799B9929292E5E5E5FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4390BA2583BD8ED4FF9EDBFF94
      D6FF85CDFF69A7CB949494E5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF3098C6006DA055A1D591CFFA77BDEC5DADE4679FC29D9D9DE8E8E8FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40A3CE0095C80081B50070A400
      6FA20070A24B86A1BBBBBBF2F2F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFA0CFE70291C30096C9008BBE0086B9017DB18AACBCE7E7E7FCFCFCFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFACCFE21C87B3037AAD2D
      88B099BDD0F0F0F0FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = SpeedButton1Click
  end
  object Label4: TLabel
    Left = 24
    Top = 8
    Width = 153
    Height = 25
    Caption = 'Seja bem-vindo!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 24
    Top = 39
    Width = 226
    Height = 13
    Caption = 'Identifique-se por favor para utilizar o sistema.'
  end
  object SpeedButton2: TSpeedButton
    Left = 264
    Top = 278
    Width = 113
    Height = 29
    Caption = 'Sai&r'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
      FFFFFFFEFEFEFCFCFCFBFBFBF9F9F9F9F9F9F9F9F9F9F9F9FBFBFBFCFCFCFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6DADADACECECFB5B6C18385AA62
      649A5E62997779A4A9AABCCECECFDADADAF6F6F6FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFDFDFDC9CAE05D60A4232885191E7F191E7F1B2080494D9AACADD0FDFD
      FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFB1D6181E86181E860F15810C
      12800C12800D1381161C85161C848689C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      D0D1E8171D8D181E8D12188A676AB3B6B8DBBFC1DE8084BD1D238D151B8C151B
      8B9EA1CFFFFFFFFFFFFFFFFFFFFBFBFD5257AF181E94111791999BCFFFFFFFD8
      D9EBCCCEE9FFFFFFC7C8DF1B2190181D95222898EFEFF7FFFFFFFFFFFFCCCDE9
      191F9B1218985458B5FFFFFF7679BA0B1193090F94474BAFFFFFFF9093C40E14
      95181E9BAEB0DCFFFFFFFFFFFF9396D41920A20D139E9396D5F3F3F5161C991B
      21A52027A5070E9BBBBDE5D5D7E51118991A20A47B7FCAFFFFFFFFFFFF7F82D0
      1C22AB0E14A68E91D6F6F6F611179C8589D5C2C4DF02099DC4C6EBD0D1E31117
      A01B22AC7377CBFFFFFFFFFFFFB0B3E41E25B4141AAE494FC1FFFFFF7E81C394
      97D9D5D6E74D52BBFFFFFF8285C30F15AC1C24B39194DAFFFFFFFFFFFFE9E9F8
      343CC41B22B9121AB68185DAA7AADA9497D8CECFE57D81D1A9ABDB191FAF191F
      B9202ABED1D3F1FFFFFFFFFFFFFFFFFF9296E2222CC51A20BF121ABD050EB9A0
      A4E7E3E4E90C14B2121ABD1920BF1F28C25B63D4FEFEFFFFFFFFFFFFFFFFFFFF
      F8F9FD5A63DA2631CD1A20C6141AC5585DD77C80D4141BC21920C6222BCA3944
      D3E3E3F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F3FC6E76E22E3BD52631D21A
      24CE1620CE242FD22C39D4555EDDD8D9F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFD0D2F68E94EB5F69E35862E28088E9BFC2F3FCFCFEFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = SpeedButton2Click
  end
  object Label6: TLabel
    Left = 24
    Top = 74
    Width = 95
    Height = 13
    Caption = 'Selecione o Produto'
  end
  object EdUsuario: TButtonedEdit
    Left = 24
    Top = 137
    Width = 192
    Height = 21
    Hint = 'Informe o seu nome de usu'#225'rio.'
    CharCase = ecLowerCase
    Images = ImageList1
    ParentShowHint = False
    RightButton.HotImageIndex = 1
    RightButton.ImageIndex = 1
    RightButton.PressedImageIndex = 1
    RightButton.Visible = True
    ShowHint = True
    TabOrder = 1
    OnRightButtonClick = EdUsuarioRightButtonClick
  end
  object EdSenha: TButtonedEdit
    Left = 24
    Top = 183
    Width = 192
    Height = 21
    Hint = 'Informe a sua senha.'
    Images = ImageList1
    ParentShowHint = False
    PasswordChar = '*'
    RightButton.HotImageIndex = 1
    RightButton.ImageIndex = 1
    RightButton.PressedImageIndex = 1
    RightButton.Visible = True
    ShowHint = True
    TabOrder = 2
    OnRightButtonClick = EdUsuarioRightButtonClick
  end
  object EdComputador: TButtonedEdit
    Left = 24
    Top = 229
    Width = 59
    Height = 21
    Hint = 'Informe o n'#250'mero do computador que est'#225' sendo utilizado.'
    CharCase = ecUpperCase
    Images = ImageList1
    MaxLength = 2
    NumbersOnly = True
    ParentShowHint = False
    RightButton.HotImageIndex = 1
    RightButton.ImageIndex = 1
    RightButton.PressedImageIndex = 1
    RightButton.Visible = True
    ShowHint = True
    TabOrder = 3
    OnRightButtonClick = EdUsuarioRightButtonClick
  end
  object CmbBxEstado: TComboBox
    Left = 24
    Top = 93
    Width = 192
    Height = 21
    Style = csDropDownList
    Color = clWhite
    TabOrder = 0
    OnChange = CmbBxEstadoChange
  end
  object ImageList1: TImageList
    BlendColor = clSilver
    BkColor = clWhite
    Left = 112
    Top = 214
    Bitmap = {
      494C010104000800040010001000FFFFFF00FF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FEFE
      FE00F9F9F900EDEDED00E1E1E100DCDCDC00DCDCDC00E1E1E100EDEDED00F9F9
      F900FEFEFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F6F6F600E5E5E500E0E0
      E000ECECEC00FAFAFA00FFFFFF00FFFFFF00FFFFFF00FBFBFB00EEEEEE00EDED
      ED00F6F6F600FFFFFF00FFFFFF00FFFFFF00FFFFFF00EDEDED00DEDEDE00DADA
      DA00DADADA00D9D9D900D9D9D900D9D9D900D9D9D900D9D9D900D9D9D900DADA
      DA00DADADA00DEDEDE00EDEDED00FFFFFF00FFFFFF00FFFFFF00FCFCFC00EFEF
      EF00D1D1D100A8A8A800898989007A7A7A007A7A7A0089898900A8A8A800D1D1
      D100EFEFEF00FCFCFC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F00FFFFFF00FFFFFF00FFFFFF00F8F8F800D3D3D300969696008686
      8600A7A7A700D6D6D600F3F3F300FFFFFF00F9F9F900DDDDDD00B0B0B000A8A8
      A800C5C5C500E5E5E500FAFAFA00FFFFFF00EDEDED00B0B0B000818181007474
      7400737373007373730073737300737373007373730073737300737373007373
      73007474740081818100B1B1B100EDEDED00FFFFFF00FDFDFD00E8E8E800B1B1
      B80061649C003033A100131AA5001319A2002F31960056568400626265007E7E
      7E00B7B7B700E8E8E800FDFDFD00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F
      7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF00DADAE6003234B3001F24AA005555
      89006262640089898900C4C4C400E8E8E800D9D9D9006464AB00555592006464
      710071717100A3A3A300E1E1E100FBFBFB007F85CE001826BB000D18B2000D17
      AF000D16AB000D14A7000D12A4000D10A0000D109D000D0D9B000D0E9B000D0E
      9900111199005757820080808000DEDEDE00FFFFFF00EFEFEF008E91C1001222
      BB000020D8000023E0000020D9000019CC000011BD00000BB00013169F005C5C
      770071717100B7B7B700EFEFEF00FEFEFE00FFFFFF007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF006D6DC6001844F600194DF8001031
      D2002A2BA2005D5D68007A7A7A00A5A5A5005959AC000928D700092ED7000313
      B3004D4D90006A6A6A00B5B5B500F0F0F0001F32CA002441E000001ED7000019
      D3000526DB000014CB000016C8000015C300000BBC000921C7000006B100000A
      AE000004A2000F0F990073737300DADADA00FAFAFA009CA0D6000420D400002F
      FF00002AFB00002DF800002BF2000029EE00001FE5000012CA00000DB5000409
      A2005C5C77007E7E7E00D1D1D100F9F9F900FFFFFF00FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF002F30BE002451F9001F52FF001D4F
      FF001744E800161BAC005C5C6F004D4D98000D2EDD001142F9000D3DF5000B3B
      F000041ABC00606084009E9E9E00E9E9E9002137D200264AEE000020E6000533
      F200B0C1EF001641F1000019D8000014D2001C40E500CFE1FF002144E1000007
      B8000009AB000A0B9B0072727200DADADA00E4E4EB001931D1000035FF0097A9
      E8006888F4000034FF00002DFF000033FA0095B1FD004570FB000019D400000D
      B60012159E0062626500A8A8A800EDEDED00FFFFFF00FFFFFF00FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00B8B8E4001832DB00285BFF002456
      FF002253FF001B4BF1000911B0000F30DD00164AFE001344F9001041F6000E3E
      F6000A3CF0003838A000C0C0C000F3F3F300263ED600294FF7000028F800C0C7
      E400F1EDE000D9DFEC000F3BF1000C34EB00E2EBFC00FFFFFB00EFF8FF002043
      E0000004AD000A0B9B0071717100D9D9D9007983D700254EF8000034FF00CACD
      DC00F5EFDE00B1C0EF00063DFF00B1C4FA00FFFFFB00FFFFFF006187FD000012
      CA00000CB2005555850089898900E1E1E100FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ADADE8001F37DD003A6FFF002C5E
      FF00295AFF002657FF002052FC001C4FFF00194AFD001646FA001445FA000F3D
      F2001920B1009E9EC300EFEFEF00FDFDFD002941DB002852FF00A0ACE200EEEA
      DD00E4E4E300F1EFE900D4DCF300CFD9F800FFFFFA00FFFFFF00FFFFFF00DEED
      FF000F27C8000A0A9B0071717100D9D9D900394FD9003D6AFF00083CFE0097A3
      E200F4F1E100F6F3EA00E4E8F300FFFFF800FFFFFF00F3F7FF00446DFD000022
      E7000012BE002F329B007A7A7A00DBDBDB00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009898E700202ACA003D6A
      FB003567FF002C5DFF002859FF002253FF001D4EFF001A4DFF00123DED002E30
      A900B9B9C800F3F3F300FFFFFF00FFFFFF002C48DE003764FF000334F700D7D7
      E000ECEBE500EDECEB00F4F4F100FBFAF700FEFEFD00FFFFFF00F8FDFF002E54
      EC000008B7000A0EA10071717100D9D9D9002341E1004B76FF002255FF000D41
      FE005C7AF000EFEDEB00F6F6F300FFFFFB00CDDAFE00174AFF00002AFC00002C
      F3000019CB001119A9007A7A7A00DCDCDC00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E2E2F8004343
      C5002E4EE7003668FF002E5EFF002859FF002254FF00163DEA0036369C007A7A
      7D00CDCDCD00F8F8F800FFFFFF00FFFFFF00314CE2004473FF00003DFF000537
      F800D2D6E800EEEEEB00F1F1F100F9F9F900FFFFFE00EAEFFF001D46EF000012
      D1000012BF000A11A40071717100D9D9D9002545E5006489FF002E5FFF003364
      FF000639FC00DADCED00FBF9F300FFFFFB00ADC0FE000033FF000236FF000030
      FA000020DA00111AAC008A8A8A00E2E2E200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDFDFD00A3A3
      D700253FDF003B6DFF003464FF002E5EFF002759FF001B46EA002A2BA3005F5F
      61009D9D9D00E3E3E300FCFCFC00FFFFFF003353E7004D81FF00054BFF00002C
      F600B0BAE800F0EFEB00F1F1F100F7F7F700FFFFFE00D4DFFF00012DED000019
      D8000015C5000A13A90071717100D9D9D9003B56E60083A2FF003D6CFF003C6C
      FF00526DE900FFFBE900B2BFF300D4DAF900FFFFFF006D8FFF000033FF000032
      FF000023E2003137A600AAAAAA00EDEDED00FFFFFF00FFFFFF00FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F6F6F6003C3C
      C9004B7CFF004170FF003B6BFF00396CFF002D5EFF002558FF001336D7004C4C
      96006B6B6B00B6B6B600EFEFEF00FFFFFF003758EA00568EFF000031EB00B6B8
      DC00EEEDE400EBEBEA00F3F3F000F9F9F600FEFEFD00FFFFFF00E0EAFF000733
      ED000013C7000A15AD0071717100D9D9D9008290EE00688AFA007096FF002958
      F700BABEDE00F5F3E7001543F7000E41FD00E7ECFB00FFFFFF002958FE000035
      FF000021DA006367A000D2D2D200FAFAFA00FFFFFF00FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C5C5E800273D
      DB005080FF004575FF003662FA000E15C2003C6DFF002A5BFF002053FD000D1F
      C3005D5D78007F7F7F00CFCFCF00F8F8F8003D5FEF004F77EC009A98CB00EDEB
      DE00E5E5E300F1F0E900D3D7EE00DFE3F400FFFFF900FFFFFE00FFFFFF00D0DE
      FF000223D8000A16B20072727200DADADA00F2F3FE00294EEE0097B6FF004C75
      F9005B6CD800546BE1003365FF002D5FFF001745FC00C7D1FA004C73FF000135
      FF001527C200B4B4BA00F0F0F000FEFEFE00FFFFFF007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF006E6ED700527C
      FA005081FF004B7DFF001D25C3009090B5002329C900386AFF002456FF001A4A
      F2001C1FAC0061616500A1A1A100EAEAEA004062F20067A4FF000F35D200D8D4
      D800EEEDE300D9D8E4000133F0000638F600EEEEF500FFFFF900FAFBFF001C48
      F7000016CF000A19B90073737300DADADA00FFFFFF00B6C1FE002F53F30096B3
      FF006F95FF003966FA00396AFF002F60FF002153FE00083CFF000C40FF000725
      D9009599C500EAEAEA00FDFDFD00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F
      7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F007F7F7F007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF003038DF006A9C
      FF005788FF002B46E7007575AA00DBDBDB00C8C8EF001B27CD003065FF001F51
      FF001439DD004C4CA0009F9F9F00E8E8E8004265F4006DABFF00116EFF001136
      D300BDB9D4000633E300044AFF00003CFF000534F500D6DCF5000C3BF900001D
      E600001BD3000A1ABC0082828200DEDEDE00FFFFFF00FFFFFF00B7C2FD00294D
      F1006688FA0088A9FF006A8FFF004F7AFF003E6DFF00204CF6001D36D500A3A9
      D800F0F0F000FCFCFC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006D6DEA003B53
      E4005782FB003939CA00CCCCCC00F4F4F400FFFFFF00B7B7F000192AD700265A
      FF000F2EE3002F30BC00DDDDDD00F8F8F8003B62F800BAE0FF005CA0FF00569A
      FF003A60E4004584FF003F76FF003669FF00295AFF001944F9001E45F6001D40
      ED001D38DB00182BC300B4B4B400EDEDED00FFFFFF00FFFFFF00FFFFFF00F3F4
      FD008A97F2003F5CE9002C4BE9002A49E6003E55DD008590DE00E5E6ED00FAFA
      FA00FEFEFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C1C1
      F2005A5AD300C3C3E700F6F6F600FFFFFF00FFFFFF00FFFFFF009B9BE6004243
      C700ABABDB00F0F0F100FCFCFC00FFFFFF0090A0FB004066F8004769F4004566
      F2004265EE003E5DED003B5AE9003853E8003350E300314CE1002D47DE002942
      D800283ED2008990D700EDEDED00FFFFFF00424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E007FFFF80048001C003EFF701000000
      8001C7E300000000800083C1000000000000C183000000000000E00700000000
      0040F00F000000000080F81F800200000000F81F000000000000F00F00000000
      0080E007000100000040C18300000000000083C1000000008001C7E300000000
      C003EFF700000000E007FFFF0100000100000000000000000000000000000000
      000000000000}
  end
  object IdEncoderMIME1: TIdEncoderMIME
    FillChar = '='
    Left = 304
    Top = 128
  end
end
