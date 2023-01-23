unit ClsWMI;

interface
  uses
    System.Classes, Winapi.MMSystem, ClsMagwmi, Vcl.Forms, Clsmagsubs,
    System.Generics.Collections, System.SysUtils, IdCoderMIME, ActiveX;

  {
    Win32_Keyboard
    Win32_PointingDevice
    Win32_DesktopMonitor
    Win32_ServiceControl
    Win32_Process
    Win32_OperatingSystem
  }

type
  TWMI = class

  public
    function GetSistemResource(ArgClass: string; ArgPropertyName: string; ArgPropertyFilterName: string; ArgPropertyFilterValue: string ): TStringList;
    Function GetListSistemResource(ArgClass: string): TStringList;
    Function GetStringSistemResource(ArgClass: string): String;
  protected
    function Preenche(Texto: string; cDigitos : Integer): String;
  end;

implementation

function TWMI.GetSistemResource(ArgClass: string; ArgPropertyName: string; ArgPropertyFilterName: string; ArgPropertyFilterValue: string ): TStringList;
  var
    intFilter, intcaption, rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    Texto, errstr : string;

    IdEncoderMIME1: TIdEncoderMIME;
    NetConectionID, NetEnabled : Integer;
begin

  try

    NetEnabled := 0;
    NetConectionID := 0;
    intcaption := 0;

    Result := TStringList.Create;

    Application.ProcessMessages;
    rows := MagWmiGetInfoEx('.', 'root\CIMV2', '', '', ArgClass, WmiResults, instances, errstr);
    if rows > 0 then
    begin

      for I := 1 to rows do
      begin

        if WmiResults[0, I] = ArgPropertyName then
          intcaption := I;

        if WmiResults[0, I] = ArgPropertyFilterName then
          intFilter := I;

      end;

      for J := 1 to instances do
      begin

        if WmiResults[J, intFilter] = ArgPropertyFilterValue then
        begin
          Texto := WmiResults[J, intcaption];
          Texto := StringReplace(Texto,'''',' ',[rfReplaceAll, rfIgnoreCase]);
        end
        else
          Texto := '';

        if Trim(Texto) <> '' then
          Result.Add(Texto);

      end;

    end;

  finally
    WmiResults := Nil;
  end;
end;

function TWMI.GetListSistemResource(ArgClass: string): TStringList;
  var
    intDescricao, intRotulo, rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    Texto, Descricao, rotulo, errstr : string;
    IdEncoderMIME1: TIdEncoderMIME;
    AdapterTypeID, NetEnabled : Integer;
begin

  try

    NetEnabled := -1;
    AdapterTypeID := -1;
    intDescricao := -1;
    intRotulo := -1;

    Result := TStringList.Create;

    rows := MagWmiGetInfoEx('.', 'root\CIMV2', '', '', ArgClass, WmiResults, instances, errstr);
    if rows > 0 then
    begin

          if (ArgClass = 'Win32_NetworkAdapter') then
            rotulo := 'MACAddress'
          else
            rotulo := 'DeviceID';

      for I := 1 to rows do
      begin

        if WmiResults[0, I] = 'Caption' then
          intDescricao := I
        else
        if WmiResults[0, I] = 'Description' then
          intDescricao := I;

        if WmiResults[0, I] = rotulo then
          intRotulo := I;

        if (WmiResults[0, I] = 'NetEnabled') or
           (WmiResults[0, I] = 'Installed')  then
          NetEnabled := I;

        if WmiResults[0, I] = 'AdapterTypeId' then
          AdapterTypeID := I;

      end;

      for J := 1 to instances do
      begin

        if ArgClass = 'Win32_NetworkAdapter' then
        begin

          if WmiResults[J, NetEnabled] = 'True' then
          begin
            if WmiResults[J, AdapterTypeID] = '0' then
            begin
//              Texto := ArgClass +'|'+ WmiResults[J, intcaption];

              if intRotulo > -1 then
              begin
                try
                  Texto := Trim(WmiResults[J, intRotulo]);

                  if Texto <> '' then
                    Texto := StringReplace(Texto,'''',' ',[rfReplaceAll, rfIgnoreCase]);

                except on E: Exception do

                end;
              end;

            end;
          end
          else
            Texto := ' ';
        end
        else
        begin
//          Texto := ArgClass +'|'+ WmiResults[J, intcaption];

          if intRotulo > -1 then
          begin
            try
              Texto := Trim(WmiResults[J, intRotulo]);

              if Texto <> '' then
                Texto := StringReplace(Texto,'''',' ',[rfReplaceAll, rfIgnoreCase]);
            except on E: Exception do

            end;
          end;

        if not ((ArgClass = 'Win32_Service') or
           (ArgClass = 'Win32_ServiceControl') or
           (ArgClass = 'Win32_Process') or
           (ArgClass = 'Win32_OperatingSystem') or
           (ArgClass = 'Win32_Product')) then
          Texto := ArgClass+'|'+Texto;


        end;

//        if (rotulo = 'DeviceID') or
//           (ArgClass = 'Win32_Product') then
//        begin
//          IdEncoderMIME1 := TIdEncoderMIME.Create(nil);
//          Texto := IdEncoderMIME1.EncodeString(texto);
//        end;

        if Trim(Texto) <> '' then
          Result.Add(Texto);
      end;

    end;
  finally
    WmiResults := Nil;
  end;
end;

function TWMI.Preenche(Texto: string; cDigitos : Integer): String;
begin
     Result := Copy(Texto+'                                                    ',1,CDigitos);
end;

function TWMI.GetStringSistemResource(ArgClass: string): String;
var
  intcaption, rows, instances, I, J: integer;
  WmiResults: T2DimStrArray;
  errstr: string;
begin

  try
    Application.ProcessMessages;
    rows := MagWmiGetInfoEx('.', 'root\CIMV2', '', '', ArgClass, WmiResults,
      instances, errstr);
    if rows > 0 then
    begin

      for I := 1 to rows do
        if WmiResults[0, I] = 'Caption' then
          intcaption := I;

      for J := 1 to instances do
        Result := WmiResults[J, intcaption];
    end;
  finally
    WmiResults := Nil;
  end;
end;

end.
