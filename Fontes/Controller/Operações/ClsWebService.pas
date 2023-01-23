// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://cesio.keynet.com.br:443/mcp/Operations?WSDL
//  >Import : http://cesio.keynet.com.br:443/mcp/Operations?WSDL>0
//  >Import : http://cesio.keynet.com.br:443/mcp/Operations?xsd=1
// Encoding : UTF-8
// Version  : 1.0
// (05/01/2016 15:35:41 - - $Rev: 76228 $)
// ************************************************************************ //

unit ClsWebService;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNQL = $0008;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]



  // ************************************************************************ //
  // Namespace : http://mcp.grupocriar/
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : MainPortBinding
  // service   : Operations
  // port      : MainPort
  // URL       : http://cesio.keynet.com.br:443/mcp/Operations
  // ************************************************************************ //
  Main = interface(IInvokable)
  ['{3C542A48-CAF6-84C4-BF94-06536E4641CE}']
    function  secure_execute(const program_server: string; const token: string; const xml: string): string; stdcall;
    function  execute(const program_server: string; const xml: string): string; stdcall;
    function  token(const program_server: string; const program_version: string; const user: string; const password: string): string; stdcall;
    function  validate(const program_server: string; const token: string): string; stdcall;
  end;

function GetMain(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): Main;


implementation
  uses System.SysUtils;

function GetMain(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): Main;
const
  defWSDL = 'http://cesio.keynet.com.br:443/mcp/Operations?WSDL';
  defURL  = 'http://cesio.keynet.com.br:443/mcp/Operations';
  defSvc  = 'Operations';
  defPrt  = 'MainPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as Main);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  { Main }
  InvRegistry.RegisterInterface(TypeInfo(Main), 'http://mcp.grupocriar/', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(Main), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(Main), ioDocument);
  { Main.secure_execute }
  InvRegistry.RegisterMethodInfo(TypeInfo(Main), 'secure_execute', '',
                                 '[ReturnName="return"]', IS_OPTN or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'secure_execute', 'program_server', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'secure_execute', 'token', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'secure_execute', 'xml', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'secure_execute', 'return', '',
                                '', IS_UNQL);
  { Main.execute }
  InvRegistry.RegisterMethodInfo(TypeInfo(Main), 'execute', '',
                                 '[ReturnName="return"]', IS_OPTN or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'execute', 'program_server', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'execute', 'xml', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'execute', 'return', '',
                                '', IS_UNQL);
  { Main.token }
  InvRegistry.RegisterMethodInfo(TypeInfo(Main), 'token', '',
                                 '[ReturnName="return"]', IS_OPTN or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'token', 'program_server', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'token', 'program_version', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'token', 'user', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'token', 'password', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'token', 'return', '',
                                '', IS_UNQL);
  { Main.validate }
  InvRegistry.RegisterMethodInfo(TypeInfo(Main), 'validate', '',
                                 '[ReturnName="return"]', IS_OPTN or IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'validate', 'program_server', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'validate', 'token', '',
                                '', IS_UNQL);
  InvRegistry.RegisterParamInfo(TypeInfo(Main), 'validate', 'return', '',
                                '', IS_UNQL);

end.