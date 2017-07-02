program fpcLazTestDesktopManager;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, TestDesktopManager;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

