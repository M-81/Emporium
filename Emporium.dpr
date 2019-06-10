program Emporium;

uses
  Vcl.Forms,
  uEmporium in 'uEmporium.pas' {Form1},
  uUtils in 'uUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEmporium, Form1);
  Application.Run;
end.
