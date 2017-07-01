{Unit-Test-Case for TEnvironmentOptions-Class}
unit TestLazEnvironmentOpts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  // fpc-unit-test-framework
  fpcunit, testutils, testregistry,
  // Lazarus-IDE
  EnvironmentOpts;

type

  { TTestLazEnvironmentOpts }

  TTestLazEnvironmentOpts= class(TTestCase)
  private
    FEnvironmentOptions:TEnvironmentOptions;
    FDataPath:String;
    // Todo : Write a Compare XML-File - method
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;

implementation

const
    cData = 'Data';
    cTestEnvironment = 'TestEnvironment';
    cEnvironmentoptions_newXml = 'environmentoptions_new.xml';

resourcestring
  rsFDatapathExists = 'FDatapath:''%s'' exists';
  rsFEnvironmentOptionsClassIsTEnvironmentOptions = 'FEnvironmentOptions class'
    +' is TEnvironmentOptions';
  rsFEnvironmentOptionsIsAssigned = 'FEnvironmentOptions is assigned';
  rsTestfileExists = 'Testfile:''%s'' exists';

procedure TTestLazEnvironmentOpts.TestSetUp;
begin
  CheckNotNull(FEnvironmentOptions, rsFEnvironmentOptionsIsAssigned);
  CheckIs(FEnvironmentOptions, TEnvironmentOptions,
    rsFEnvironmentOptionsClassIsTEnvironmentOptions );
  CheckTrue(DirectoryExists(FDataPath), Format(rsFDatapathExists, [FDataPath]));
  CheckTrue(FileExists(FDataPath+DirectorySeparator+cEnvironmentoptions_newXml),
    Format(rsTestfileExists, [cEnvironmentoptions_newXml]));
end;

procedure TTestLazEnvironmentOpts.SetUp;
var
  i: Integer;
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
        FDataPath := FDataPath+DirectorySeparator+cTestEnvironment
      else
        ;// ToDo: define a general solution OS-aware
    end;
end;

procedure TTestLazEnvironmentOpts.TearDown;
begin
  FreeAndNil(FEnvironmentOptions);
end;

initialization

  RegisterTest(TTestLazEnvironmentOpts);
end.

