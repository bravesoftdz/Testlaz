program fpcLazTestEnvironmentOpts;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, EnvironmentOpts, GuiTestRunner, TestLazEnvironmentOpts,sysutils;

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
  Application.Initialize;
  OnGetApplicationName:=@ApplicationName;
  OnGetVendorName:=@VendorName;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

