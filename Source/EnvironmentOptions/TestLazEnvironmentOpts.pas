unit TestLazEnvironmentOpts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, EnvironmentOpts;

type

  TTestLazEnvironmentOpts= class(TTestCase)
  private
    FEnvironmentOptions:TEnvironmentOptions;
    FDataPath:String;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;

implementation

const
    cData = 'Data';

resourcestring
  rsFEnvironmentOptionsClassIsTEnvironmentOptions = 'FEnvironmentOptions class'
    +' is TEnvironmentOptions';
  rsFEnvironmentOptionsIsAssigned = 'FEnvironmentOptions is assigned';

procedure TTestLazEnvironmentOpts.TestHookUp;
begin
  CheckNotNull(FEnvironmentOptions, rsFEnvironmentOptionsIsAssigned);
  CheckIs(FEnvironmentOptions, TEnvironmentOptions,
    rsFEnvironmentOptionsClassIsTEnvironmentOptions );
end;

procedure TTestLazEnvironmentOpts.SetUp;
begin
  FEnvironmentOptions:=TEnvironmentOptions.Create;
  if FDataPath='' then
    begin
      FDataPath:=cData;
      for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
          break
        else
          FDataPath:='..'+DirectorySeparator+FDataPath;
      if DirectoryExists(FDataPath) then
        FDataPath := FDataPath+DirectorySeparator+'
      else

    end;
end;

procedure TTestLazEnvironmentOpts.TearDown;
begin
  FreeAndNil(FEnvironmentOptions);
end;

initialization

  RegisterTest(TTestLazEnvironmentOpts);
end.

