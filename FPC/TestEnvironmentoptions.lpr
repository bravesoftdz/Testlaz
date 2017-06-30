program TestEnvironmentoptions;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, SysUtils, IDETranslations, frm_TestEnvironmentOptionsMain
  { you can add units after this };

{$R *.res}

function ApplicationName: String;
begin
  result:='LazTestEnvironmentOpts'
end;

function VendorName: String;
begin
  result := 'JC-Soft'
end;

begin
  RequireDerivedFormResource:=True;
  OnGetVendorName:=@VendorName;
  OnGetApplicationName:=@ApplicationName;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

