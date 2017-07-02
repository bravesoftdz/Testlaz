{Unit-Test-Case for TEnvironmentOptions-Class}
unit TestLazEnvironmentOpts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil,
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
    Procedure LoadEnvironment;
    Procedure LoadNewEnvDesktopOpts;
    Procedure LoadandSaveEnvironm;
    Procedure LoadandSaveNewEnvironm;
    Procedure LoadSaveDelDesktop;
    Procedure LoadSaveAppendDesktop;
  end;

implementation

const
    cData = 'Data';
    cTestEnvironment = 'TestEnvironment';
    cEnvironmentoptionsXml = 'environmentoptions.xml';
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
  CheckTrue(FileExists(FDataPath+DirectorySeparator+cEnvironmentoptionsXml),
    Format(rsTestfileExists, [cEnvironmentoptionsXml]));
  CheckTrue(FileExists(FDataPath+DirectorySeparator+cEnvironmentoptions_newXml),
    Format(rsTestfileExists, [cEnvironmentoptions_newXml]));
end;

procedure TTestLazEnvironmentOpts.LoadEnvironment;
begin
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptionsXml;
  FEnvironmentOptions.Load(false);
  CheckEquals(4,FEnvironmentOptions.Desktops.Count,'There should be 4 Desktops');
  CheckEquals(false,FEnvironmentOptions.AskForFilenameOnNewFile,'AskForFilenameOnNewFile should be true');
  CheckEquals('default',FEnvironmentOptions.ActiveDesktopName,'ActiveDesktopName');
  CheckEquals(false,FEnvironmentOptions.AskSaveSessionOnly,'AskSaveSessionOnly');
  CheckEquals(false,FEnvironmentOptions.AutoCloseCompileDialog,'AutoCloseCompileDialog');
  CheckEquals(true,FEnvironmentOptions.AutoSaveActiveDesktop,'AutoSaveActiveDesktop');
end;

procedure TTestLazEnvironmentOpts.LoadNewEnvDesktopOpts;
begin
  if FileExists(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml) then
    DeleteFile(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml);
  FileUtil.CopyFile(
    FDataPath + DirectorySeparator+ cEnvironmentoptionsXml,
    FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml,true);
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Load(false);
  CheckEquals(4,FEnvironmentOptions.Desktops.Count,'There should be 4 Desktops');
  CheckEquals('default',FEnvironmentOptions.Desktops[0].Name,'1. Desktop should be "default"');
  CheckEquals('default (saved)',FEnvironmentOptions.Desktops[1].Name,'2. Desktop should be ');
  CheckEquals('default (test)',FEnvironmentOptions.Desktops[2].Name,'3. Desktop should be ');
  CheckEquals('default docked',FEnvironmentOptions.Desktops[3].Name,'4. Desktop should be ');
  CheckEquals(true,FEnvironmentOptions.Desktops[0].Compatible,'1. Desktop should be "default"');
  CheckEquals(true,FEnvironmentOptions.Desktops[1].Compatible,'2. Desktop should be ');
  CheckEquals(true,FEnvironmentOptions.Desktops[2].Compatible,'3. Desktop should be ');
  CheckEquals(false,FEnvironmentOptions.Desktops[3].Compatible,'4. Desktop should be ');
end;

procedure TTestLazEnvironmentOpts.LoadandSaveEnvironm;
begin
  if FileExists(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml) then
    DeleteFile(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml);
  FileUtil.CopyFile(
    FDataPath + DirectorySeparator+ cEnvironmentoptionsXml,
    FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml,true);
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Load(false);
  CheckEquals(4,FEnvironmentOptions.Desktops.Count,'There should be 4 Desktops');
  FEnvironmentOptions.Save(false);
  // Todo: Check Compare Files;
end;

procedure TTestLazEnvironmentOpts.LoadandSaveNewEnvironm;
begin
  if FileExists(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml) then
    DeleteFile(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml);
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptionsXml;
  FEnvironmentOptions.Load(false);
  CheckEquals(4,FEnvironmentOptions.Desktops.Count,'There should be 4 Desktops');
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Save(false);
  // Todo: Check Compare Files;
end;

procedure TTestLazEnvironmentOpts.LoadSaveDelDesktop;
begin
  if FileExists(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml) then
    DeleteFile(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml);
  FileUtil.CopyFile(
    FDataPath + DirectorySeparator+ cEnvironmentoptionsXml,
    FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml,true);
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Load(false);
  CheckEquals(4,FEnvironmentOptions.Desktops.Count,'There should be 4 Desktops');
  FEnvironmentOptions.Desktops.Delete(2);
  CheckEquals(3,FEnvironmentOptions.Desktops.Count,'There should be 3 Desktops');
  CheckEquals('default',FEnvironmentOptions.Desktops[0].Name,'1. Desktop should be "default"');
  CheckEquals('default (saved)',FEnvironmentOptions.Desktops[1].Name,'2. Desktop should be ');
  CheckEquals('default docked',FEnvironmentOptions.Desktops[2].Name,'3. Desktop should be ');
  CheckEquals(true,FEnvironmentOptions.Desktops[0].Compatible,'1. Desktop should be "default"');
  CheckEquals(true,FEnvironmentOptions.Desktops[1].Compatible,'2. Desktop should be ');
  CheckEquals(false,FEnvironmentOptions.Desktops[2].Compatible,'3. Desktop should be ');
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Save(false);
  // Todo: Check Compare Files;
end;

procedure TTestLazEnvironmentOpts.LoadSaveAppendDesktop;
var
  lNewDtp: TDesktopOpt;
begin
  if FileExists(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml) then
    DeleteFile(FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml);
  FileUtil.CopyFile(
    FDataPath + DirectorySeparator+ cEnvironmentoptionsXml,
    FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml,true);
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Load(false);
  CheckEquals(4,FEnvironmentOptions.Desktops.Count,'There should be 4 Desktops');
  lNewDtp:=TDesktopOpt.Create('NewDesktop');
  FEnvironmentOptions.Desktops.Add(lNewDtp);
  CheckEquals(5,FEnvironmentOptions.Desktops.Count,'There should be 5 Desktops');
  CheckEquals('default',FEnvironmentOptions.Desktops[0].Name,'1. Desktop should be "default"');
  CheckEquals('default (saved)',FEnvironmentOptions.Desktops[1].Name,'2. Desktop should be ');
  CheckEquals('default (test)',FEnvironmentOptions.Desktops[2].Name,'3. Desktop should be ');
  CheckEquals('default docked',FEnvironmentOptions.Desktops[3].Name,'4. Desktop should be ');
  CheckEquals('NewDesktop',FEnvironmentOptions.Desktops[4].Name,'5. Desktop should be ');
  CheckEquals(true,FEnvironmentOptions.Desktops[0].Compatible,'1. Desktop should be "default"');
  CheckEquals(true,FEnvironmentOptions.Desktops[1].Compatible,'2. Desktop should be default (saved)');
  CheckEquals(true,FEnvironmentOptions.Desktops[2].Compatible,'3. Desktop should be ');
  CheckEquals(false,FEnvironmentOptions.Desktops[3].Compatible,'4. Desktop should be default docked');
  CheckEquals(true,FEnvironmentOptions.Desktops[4].Compatible,'5. Desktop should be NewDesktop');
  FEnvironmentOptions.Filename:=FDataPath + DirectorySeparator+ cEnvironmentoptions_newXml;
  FEnvironmentOptions.Save(false);
  // Todo: Check Compare Files;
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

