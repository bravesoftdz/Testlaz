unit TestDesktopManager;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fpcunit, testutils, testregistry, DesktopManager;

type

    { TTestDesktopManager }

    TTestDesktopManager = class(TTestCase)
    private
        FDesktopForm: TDesktopForm;
        FDataPath: string;
    protected
        procedure SetUp; override;
        procedure TearDown; override;
    published
        destructor Destroy; override;
        procedure TestSetUp;
    end;

implementation

uses Forms, EnvironmentOpts;

const
    cData = 'Data';
    cTestEnvironment = 'TestEnvironment';
    cEnvironmentoptionsXml = 'environmentoptions.xml';
    cEnvironmentoptions_newXml = 'environmentoptions_new.xml';

resourcestring
    rsFDatapathExists = 'FDatapath:''%s'' exists';
    rsEnvironmentOptionsClassIsTEnvironmentOptions = 'EnvironmentOptions class' + ' is TEnvironmentOptions';
    rsFDesktopFormClassIsTDesktopForm = 'FDesktopForm class' + ' is TDesktopForm';
    rsEnvironmentOptionsIsAssigned = 'EnvironmentOptions is assigned';
    rsFDesktopFormIsAssigned = 'FDesktopForm is assigned';
    rsTestfileExists = 'Testfile:''%s'' exists';

procedure TTestDesktopManager.TestSetUp;
begin
    CheckNotNull(EnvironmentOptions, rsEnvironmentOptionsIsAssigned);
    CheckIs(EnvironmentOptions, TEnvironmentOptions,
        rsEnvironmentOptionsClassIsTEnvironmentOptions);
    CheckNotNull(FDesktopForm, rsFDesktopFormIsAssigned);
    CheckIs(FDesktopForm, TDesktopForm, rsFDesktopFormClassIsTDesktopForm);
    CheckTrue(DirectoryExists(FDataPath), Format(rsFDatapathExists, [FDataPath]));
    CheckTrue(FileExists(FDataPath + DirectorySeparator + cEnvironmentoptionsXml),
        Format(rsTestfileExists, [cEnvironmentoptionsXml]));
    CheckTrue(FileExists(FDataPath + DirectorySeparator + cEnvironmentoptions_newXml),
        Format(rsTestfileExists, [cEnvironmentoptions_newXml]));
end;

procedure TTestDesktopManager.SetUp;
var
  i: Integer;
begin
    if not assigned(EnvironmentOptions) then
        EnvironmentOptions := TEnvironmentOptions.Create;
    if FDataPath = '' then
      begin
        FDataPath := cData;
        for i := 0 to 2 do
            if DirectoryExists(FDataPath) then
                break
            else
                FDataPath := '..' + DirectorySeparator + FDataPath;
        if DirectoryExists(FDataPath) then
            FDataPath := FDataPath + DirectorySeparator + cTestEnvironment
        else
        ;// ToDo: define a general solution OS-aware
      end;
    Application.CreateForm(TDesktopForm, FDesktopForm);
end;

procedure TTestDesktopManager.TearDown;
begin
    FreeAndNil(FDesktopForm);
end;

destructor TTestDesktopManager.Destroy;
begin
    FreeAndNil(EnvironmentOptions);
    inherited Destroy;
end;

initialization

    RegisterTest(TTestDesktopManager);
end.



