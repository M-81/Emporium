unit uUtils;

interface

uses Classes, SysUtils, StrUtils;

function GetDouble2Str(AValue: Double): string;

implementation

function GetDouble2Str(AValue: Double): string;
begin
  Result := Format('%.2f', [AValue]);
end;

end.
