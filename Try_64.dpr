program Try_64;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  dataunit in 'dataunit.pas' {DataModule1: TDataModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
