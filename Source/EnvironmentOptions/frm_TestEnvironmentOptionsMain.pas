unit frm_TestEnvironmentOptionsMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls,
  // lazarus
  EnvironmentOpts,DesktopManager;

type

  { TfrmTestEnvironmentOptMain }

  TfrmTestEnvironmentOptMain = class(TForm)
    btnLoadEnv: TButton;
    btnSaveEnv: TButton;
    btnNewDT: TButton;
    btnDeleteDT: TButton;
    btnShowDesktopMgr: TButton;
    edtDesktopName: TEdit;
    edtDirectory: TEdit;
    btnSelectDir: TSpeedButton;
    lblDsktpInfo: TLabel;
    lblCInfo: TLabel;
    lbxDesktops: TListBox;
    tmrUpdate: TTimer;
    procedure btnDeleteDTClick(Sender: TObject);
    procedure btnLoadEnvClick(Sender: TObject);
    procedure btnSaveEnvClick(Sender: TObject);
    procedure btnNewDTClick(Sender: TObject);
    procedure btnShowDesktopMgrClick(Sender: TObject);
    procedure edtDesktopNameExit(Sender: TObject);
    procedure edtDesktopNameKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbxDesktopsDblClick(Sender: TObject);
    procedure lbxDesktopsKeyPress(Sender: TObject; var Key: char);
    procedure lbxDesktopsSelectionChange(Sender: TObject; {%H-}User: boolean);
    procedure tmrUpdateTimer(Sender: TObject);
    procedure UpdateDesktopList(Sender: Tobject);
  private
     FDataPath: String;
     FEnvironmentOptions:TEnvironmentOptions;
     procedure ActivateInplaceEditor;
  public

  end;

var
  frmTestEnvironmentOptMain: TfrmTestEnvironmentOptMain;
  DesktopForm:TdesktopForm;

implementation

uses unt_cdate;
{$R *.lfm}

const
  cData = 'Data';
  cTestEnvironment = '%sTestEnvironment';
  cEnvironmentoptionsXml = 'environmentoptions.xml';
  cEnvironmentoptions_newXml = 'environmentoptions_new.xml';

resourceString
  rsEnterNewName = 'Enter new Name';
  rsDesktopInfoComatible = '[%s] compatible';
  rsDesktopInfoIsDocked = '[%s] docked';

{ TfrmTestEnvironmentOptMain }

procedure TfrmTestEnvironmentOptMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FEnvironmentOptions:=TEnvironmentOptions.Create;
  FDataPath:=cData;
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:= '..'+DirectorySeparator+FDataPath;
  FDataPath:=Format(cTestEnvironment, [FDataPath+DirectorySeparator]);
  lblCInfo.Caption:=format(lblCInfo.Caption,[CDate,CName]);
end;

procedure TfrmTestEnvironmentOptMain.btnLoadEnvClick(Sender: TObject);
begin
  FEnvironmentOptions.Filename:=FDataPath+DirectorySeparator+
    cEnvironmentoptionsXml;
  FEnvironmentOptions.load(false);
  UpdateDesktopList(Sender);
end;

procedure TfrmTestEnvironmentOptMain.btnDeleteDTClick(Sender: TObject);
var
  lidx: Integer;
begin
  if lbxDesktops.ItemIndex >=0 then
    begin;
      lidx := FEnvironmentOptions.Desktops.IndexOf(lbxDesktops.Items[lbxDesktops.ItemIndex]);
      FEnvironmentOptions.Desktops.Delete(lidx);
      lbxDesktops.DeleteSelected;
    end;
end;

procedure TfrmTestEnvironmentOptMain.btnSaveEnvClick(Sender: TObject);
begin
  FEnvironmentOptions.Filename:=FDataPath+DirectorySeparator+cEnvironmentoptions_newXml;
  FEnvironmentOptions.Save(false);
end;

procedure TfrmTestEnvironmentOptMain.btnNewDTClick(Sender: TObject);
begin
  edtDesktopName.Text:='';
  edtDesktopName.Tag:=0;
  edtDesktopName.TextHint:=rsEnterNewName;
  edtDesktopName.visible := true;
end;

procedure TfrmTestEnvironmentOptMain.btnShowDesktopMgrClick(Sender: TObject);
begin
  EnvironmentOptions := FEnvironmentOptions;
  DesktopForm.show;
  UpdateDesktopList(sender);
end;

procedure TfrmTestEnvironmentOptMain.edtDesktopNameExit(Sender: TObject);
begin
  edtDesktopName.Visible:=false;
end;

procedure TfrmTestEnvironmentOptMain.edtDesktopNameKeyPress(Sender: TObject; var Key: char);
var
  lnd: TCustomDesktopOpt;
  lix: Integer;
begin
  if key = #27 then
    begin
    edtDesktopName.Visible:=false;
     ActiveControl:= lbxDesktops;
    end;
  if key = #13 then
    begin
      // Check if Name is OK
      if edtDesktopName.tag = 0 then
        begin
          lnd:= TDesktopOpt.Create(edtDesktopName.Text);
          FEnvironmentOptions.Desktops.Add(lnd);
          lbxDesktops.AddItem(edtDesktopName.Text,lnd);
        end
      else
        begin
          lnd := TDesktopOpt(edtDesktopName.tag);
          lnd.Name:= edtDesktopName.text;
          lix := lbxDesktops.Items.IndexOfObject(lnd);
          if lix>-1 then
            lbxDesktops.Items[lix]:=edtDesktopName.text;
        end;
      edtDesktopName.Visible:=false;
     ActiveControl:= lbxDesktops;
    end;

end;

procedure TfrmTestEnvironmentOptMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEnvironmentOptions);
end;

procedure TfrmTestEnvironmentOptMain.lbxDesktopsDblClick(Sender: TObject);
begin
  ActivateInplaceEditor;
end;

procedure TfrmTestEnvironmentOptMain.lbxDesktopsKeyPress(Sender: TObject; var Key: char);
begin
  if key = #29 then
    begin
      ActivateInplaceEditor;
    end;
end;

procedure TfrmTestEnvironmentOptMain.lbxDesktopsSelectionChange(
  Sender: TObject; User: boolean);
var
  lSelDt: TCustomDesktopOpt;

begin
  if lbxDesktops.Itemindex <0 then exit; // No selection
  lSelDt := TCustomDesktopOpt(lbxDesktops.Items.Objects[lbxDesktops.Itemindex]);
  lblDsktpInfo.caption := format(rsDesktopInfoComatible,[booltostr(lSelDt.Compatible,'X','-')]);
  lblDsktpInfo.caption := lblDsktpInfo.caption+#9+format(rsDesktopInfoIsDocked,[booltostr(lSelDt.IsDocked,'X','-')]);
end;

var lIdx:integer;
   lDiff:boolean;

procedure TfrmTestEnvironmentOptMain.tmrUpdateTimer(Sender: TObject);

var
  lIsEqual: Boolean;
begin
  if not assigned(FEnvironmentOptions) then exit;
  lIsEqual:= FEnvironmentOptions.Desktops.Count = lbxDesktops.Count;
  if lIsEqual and (FEnvironmentOptions.Desktops.Count>0) then
    begin
      lIdx := (lidx + 1) mod FEnvironmentOptions.Desktops.Count;
      lIsEqual:= FEnvironmentOptions.Desktops[lIdx] = TCustomDesktopOpt(lbxDesktops.Items.Objects[lidx]);
    end;
  if not lDiff and not lisEqual then
    UpdateDesktopList(sender); // This event is only fired once after a difference is detected;
  ldiff := not lisEqual;
end;

procedure TfrmTestEnvironmentOptMain.UpdateDesktopList(Sender:Tobject);
var
  p: TCustomDesktopOpt;
begin
  lbxDesktops.clear;
  for pointer(p) in FEnvironmentOptions.Desktops do
    lbxDesktops.AddItem(p.Name, p);
end;

procedure TfrmTestEnvironmentOptMain.ActivateInplaceEditor;
begin
  edtDesktopName.top := lbxDesktops.ItemRect(lbxDesktops.ItemIndex).top+lbxDesktops.top-1;
  edtDesktopName.Text:=lbxDesktops.Items[lbxDesktops.ItemIndex];
  edtDesktopName.tag:=ptrint(lbxDesktops.Items.Objects[lbxDesktops.ItemIndex]);
  edtDesktopName.visible := true;
end;

end.

