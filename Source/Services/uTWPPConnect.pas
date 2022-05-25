﻿{####################################################################################################################
                              WPPCONNECT - Componente de comunicação (Não Oficial)
                                           https://wppconnect-team.github.io/
                                            Maio de 2022
####################################################################################################################
    Owner.....: Marcelo           - marcelo.broz@hotmail.com   -
    Developer.: Marcelo           - marcelo.broz@hotmail.com   - +55 17 9.8138-8414
            
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi, desde que mantenha os dados dos autores e mantendo sempre o nome do IDEALIZADOR
       Marcelo;
     
####################################################################################################################
}

unit uTWPPConnect;

interface

uses
  uTWPPConnect.Classes, uTWPPConnect.constant, uTWPPConnect.Emoticons, uTWPPConnect.Config,
  uTWPPConnect.JS, uTWPPConnect.Console,
  uTWPPConnect.languages,
  uTWPPConnect.AdjustNumber, UBase64,

  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, System.MaskUtils,
  System.UiTypes,  Generics.Collections, System.TypInfo, Data.DB, Vcl.ExtCtrls,
  uTWPPConnect.Diversos, Vcl.Imaging.jpeg;


type
  {Events}
  TOnGetIsDelivered         = Procedure(Sender : TObject; Status: string) of object;

  //Adicionado Por Marcelo 01/03/2022
  TOnGetCheckIsBeta         = Procedure(Sender : TObject; IsBeta: Boolean) of object;

  TOnGetCheckIsConnected    = Procedure(Sender : TObject; Connected: Boolean) of object;
  TOnGetCheckIsValidNumber  = Procedure(Sender : TObject; Number: String;  IsValid: Boolean) of object;
  TOnGetProfilePicThumb     = Procedure(Sender : TObject; Base64: String) of object;
  TGetUnReadMessages        = procedure(Const Chats: TChatList) of object;
  TOnGetQrCode              = procedure(Const Sender: Tobject; Const QrCode: TResultQRCodeClass) of object;
  TOnAllContacts            = procedure(Const AllContacts: TRetornoAllContacts) of object;
  TOnAllGroups              = procedure(Const AllGroups: TRetornoAllGroups) of object;
  TOnAllGroupContacts       = procedure(Const Contacts: TClassAllGroupContacts) of object;
  TOnAllGroupAdmins         = procedure(Const AllGroups: TRetornoAllGroupAdmins) of object;
  TOnGetStatusMessage       = procedure(Const Result: TResponseStatusMessage) of object;
  TOnGetInviteGroup         = procedure(Const Invite : String) of object;
  TOnGetMe                  = procedure(Const vMe : TGetMeClass) of object;
  TOnNewCheckNumber         = procedure(Const vCheckNumber : TReturnCheckNumber) of object;

  //Adicionado Por Marcelo 06/05/2022
  //TGetMessageById           = procedure(Const Mensagem: TMessagesClass) of object;
  TGetMessageById           = procedure(Const Mensagem: TMessagesList) of object;


  TWPPConnect = class(TComponent)
  private
    FInjectConfig           : TWPPConnectConfig;
    FInjectJS               : TWPPConnectJS;
    FEmoticons              : TWPPConnectEmoticons;
    FAdjustNumber           : TWPPConnectAdjusteNumber;
    FTranslatorInject       : TTranslatorInject;
    FDestroyTmr             : Ttimer;
    FFormQrCodeType         : TFormQrCodeType;
    FMyNumber               : string;
    FserialCorporate        : string;
    FIsDelivered            : string;
    FGetBatteryLevel        : Integer;
    FGetIsConnected         : Boolean;
    Fversion                : String;
    Fstatus                 : TStatusType;
    FDestruido              : Boolean;

    FLanguageInject         : TLanguageInject;
    FOnDisconnectedBrute    : TNotifyEvent;

    { Private  declarations }
    Function  ConsolePronto:Boolean;
    procedure SetAuth(const Value: boolean);
    procedure SetOnLowBattery(const Value: TNotifyEvent);
    procedure Int_OnUpdateJS   (Sender : TObject);
    procedure Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
    Function  GetAppShowing:Boolean;
    procedure SetAppShowing(const Value: Boolean);
    procedure OnCLoseFrmInt(Sender: TObject; var CanClose: Boolean);
    procedure SetQrCodeStyle(const Value: TFormQrCodeType);
    procedure LimparQrCodeInterno;
    procedure SetLanguageInject(const Value: TLanguageInject);
    procedure SetInjectConfig(const Value: TWPPConnectConfig);
    procedure SetdjustNumber(const Value: TWPPConnectAdjusteNumber);
    procedure SetInjectJS(const Value: TWPPConnectJS);
    procedure SetSerialCorporate(const Value: TWPPConnectJS);
    procedure OnDestroyConsole(Sender : TObject);

  protected
    { Protected declarations }
    FOnGetUnReadMessages        : TGetUnReadMessages;
    FOnGetAllGroupContacts      : TOnAllGroupContacts;
    FOnGetAllContactList        : TOnAllContacts;
    FOnGetAllGroupList          : TOnAllGroups;
    FOnGetAllGroupAdmins        : TOnAllGroupAdmins;
    FOnLowBattery               : TNotifyEvent;
    FOnGetBatteryLevel          : TNotifyEvent;

    //Adicionado Por Marcelo 01/03/2022
    FOnGetCheckIsBeta           : TOnGetCheckIsBeta;
    FOnGetCheckIsConnected      : TOnGetCheckIsConnected;
    FOnGetCheckIsValidNumber    : TOnGetCheckIsValidNumber;
    FOnGetProfilePicThumb       : TOnGetProfilePicThumb;
    FOnGetQrCode                : TOnGetQrCode;
    FOnUpdateJS                 : TNotifyEvent;
    FOnGetChatList              : TGetUnReadMessages;
    FOnGetMyNumber              : TNotifyEvent;
    FOnGetIsDelivered           : TNotifyEvent;
    FOnGetStatus                : TNotifyEvent;
    FOnConnected                : TNotifyEvent;
    FOnDisconnected             : TNotifyEvent;
    FOnErroInternal             : TOnErroInternal;
    FOnAfterInjectJs            : TNotifyEvent;
    FOnAfterInitialize          : TNotifyEvent;
    FOnGetStatusMessage         : TOnGetStatusMessage;
    FOnGetInviteGroup           : TOnGetInviteGroup;
    FOnGetMe                    : TOnGetMe;
    FOnNewCheckNumber           : TOnNewCheckNumber;

    //Adicionado Por Marcelo 06/05/2022
    FOnGetMessageById           : TGetMessageById;

    procedure Int_OnNotificationCenter(PTypeHeader: TTypeHeader; PValue: String; Const PReturnClass : TObject= nil);

    procedure Loaded; override;

  public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    Procedure   ShutDown(PWarning:Boolean = True);
    Procedure   Disconnect;
    //funcao experimental para configuracao de proxy de rede(Ainda nao foi testada)
    //Olhar em uTWPPConnect.Console funcao ConfigureNetWork
    //Function    ConfigureNetwork: Boolean;
    procedure ReadMessages(vID: string);
    function  TestConnect:  Boolean;
    procedure Send(PNumberPhone, PMessage: string; PEtapa: string = '');
    procedure SendButtons(phoneNumber: string; titleText: string; buttons: string; footerText: string; etapa: string = '');
    //Adicionado Por Marcelo 01/03/2022
    procedure SendListMenu(phoneNumber, title, subtitle, description, buttonText, menu: string; etapa: string = '');

    //Adicionado Por Marcelo 30/04/2022
    procedure SendListMessage(phoneNumber, buttonText, description, sections: string; etapa: string = '');
    procedure SendFileMessage(phoneNumber, content, options: string; etapa: string = '');
    procedure SendLocationMessage(phoneNumber, options: string; etapa: string = '');

    //Adicionado Por Marcelo 10/05/2022
    procedure SendTextMessage(phoneNumber, content, options: string; etapa: string = '');
    procedure SendReactionMessage(UniqueID, Reaction: string; etapa: string = '');

    //Adicionado Por Marcelo 18/05/2022
    procedure SendRawMessage(phoneNumber, rawMessage, options: string; etapa: string = '');
    procedure markIsComposing(phoneNumber, duration: string; etapa: string = '');

    //Adicionado Por Marcelo 03/05/2022
    procedure getMessageById(UniqueIDs: string; etapa: string = '');

    procedure deleteConversation(PNumberPhone: string);
    procedure SendContact(PNumberPhone, PNumber: string; PNameContact: string = '');
    procedure SendFile(PNumberPhone: String; Const PFileName: String; PMessage: string = '');
    procedure SendBase64(Const vBase64: String; vNum: String;  Const vFileName, vMess: string);     deprecated; //Versao 1.0.2.0 disponivel ate Versao 1.0.6.0
    procedure SendLinkPreview(PNumberPhone, PVideoLink, PMessage: string);
    procedure SendLocation(PNumberPhone, PLat, PLng, PMessage: string);
    procedure Logout();
    procedure GetBatteryStatus;
    procedure CheckIsValidNumber(PNumberPhone: string);
    procedure NewCheckIsValidNumber(PNumberPhone : string);
    //Adicionado Por Marcelo 01/03/2022
    procedure isBeta;
    procedure CheckIsConnected;
    procedure GetAllContacts;
    procedure GetAllGroups;
    procedure GroupAddParticipant(PIDGroup, PNumber: string);
    procedure GroupRemoveParticipant(PIDGroup, PNumber: string);
    procedure GroupPromoteParticipant(PIDGroup, PNumber: string);
    procedure GroupDemoteParticipant(PIDGroup, PNumber: string);
    procedure GroupLeave(PIDGroup: string);
    procedure GroupDelete(PIDGroup: string);

    procedure BloquearContato(PIDContato: String);
    procedure DesbloquearContato(PIDContato: String);

    procedure GroupJoinViaLink(PLinkGroup: string);
    procedure GroupRemoveInviteLink(PIDGroup: string);
    procedure SetProfileName(vName : String);
    procedure SetStatus(vStatus: String);
    procedure GetStatusContact(PNumber: String);
    procedure GetGroupInviteLink(PIDGroup : string);
    procedure CleanALLChat(PNumber: String);
    procedure GetMe;

    Function  GetContact(Pindex: Integer): TContactClass;  deprecated;  //Versao 1.0.2.0 disponivel ate Versao 1.0.6.0
    procedure GetAllChats;
    Function  GetChat(Pindex: Integer):TChatClass;
    function  GetUnReadMessages: String;
    function  CheckDelivered: String;
    procedure getProfilePicThumb(AProfilePicThumbURL: string);
    procedure createGroup(PGroupName, PParticipantNumber: string);
    procedure listGroupContacts(PIDGroup: string);
    Property  BatteryLevel      : Integer              Read FGetBatteryLevel;
    Property  IsConnected       : Boolean              Read FGetIsConnected;
    Property  MyNumber          : String               Read FMyNumber;

    Property  IsDelivered       : String               Read FIsDelivered;

    property  Authenticated     : boolean              read TestConnect;
    property  Status            : TStatusType          read FStatus;
    Function  StatusToStr       : String;
    Property  Emoticons         : TWPPConnectEmoticons     Read FEmoticons                     Write FEmoticons;
    property  FormQrCodeShowing : Boolean              read GetAppShowing                  Write SetAppShowing;
    Procedure FormQrCodeStart(PViewForm:Boolean = true);
    Procedure FormQrCodeStop;
    Procedure FormQrCodeReloader;
    Function  Auth(PRaise: Boolean = true): Boolean;
  published
    { Published declarations }
    Property Version                     : String                     read Fversion;
    Property InjectJS                    : TWPPConnectJS                  read FInjectJS                       Write SetInjectJS;
    property Config                      : TWPPConnectConfig              read FInjectConfig                   Write SetInjectConfig;
    property AjustNumber                 : TWPPConnectAdjusteNumber       read FAdjustNumber                   Write SetdjustNumber;
    property serialCorporate             : string                     read FserialCorporate                write FserialCorporate;
    property FormQrCodeType              : TFormQrCodeType            read FFormQrCodeType                 Write SetQrCodeStyle                      Default Ft_Desktop;
    property LanguageInject              : TLanguageInject            read FLanguageInject                 Write SetLanguageInject                   Default TL_Portugues_BR;
    property OnGetAllContactList         : TOnAllContacts             read FOnGetAllContactList            write FOnGetAllContactList;
    property OnGetAllGroupList           : TOnAllGroups               read FOnGetAllGroupList              write FOnGetAllGroupList;
    property OnGetAllGroupAdmins         : TOnAllGroupAdmins          read FOnGetAllGroupAdmins            write FOnGetAllGroupAdmins;
    property OnAfterInjectJS             : TNotifyEvent               read FOnAfterInjectJs                write FOnAfterInjectJs;
    property OnAfterInitialize           : TNotifyEvent               read FOnAfterInitialize              write FOnAfterInitialize;
    property OnGetQrCode                 : TOnGetQrCode               read FOnGetQrCode                    write FOnGetQrCode;
    property OnGetChatList               : TGetUnReadMessages         read FOnGetChatList                  write FOnGetChatList;
    property OnGetUnReadMessages         : TGetUnReadMessages         read FOnGetUnReadMessages            write FOnGetUnReadMessages;
    property OnGetAllGroupContacts       : TOnAllGroupContacts        read FOnGetAllGroupContacts          write FOnGetAllGroupContacts;
    property OnGetStatus                 : TNotifyEvent               read FOnGetStatus                    write FOnGetStatus;
    property OnGetBatteryLevel           : TNotifyEvent               read FOnGetBatteryLevel              write FOnGetBatteryLevel;


    //Adicionado Por Marcelo 06/05/2022
    property OnGetMessageById            : TGetMessageById            read FOnGetMessageById               write FOnGetMessageById;

    //Adicionado Por Marcelo 01/03/2022
    property OnIsBeta                    : TOnGetCheckIsBeta          read FOnGetCheckIsBeta               write FOnGetCheckIsBeta;

    property OnIsConnected               : TOnGetCheckIsConnected     read FOnGetCheckIsConnected          write FOnGetCheckIsConnected;
    property OnLowBattery                : TNotifyEvent               read FOnLowBattery                   write SetOnLowBattery;
    property OnGetCheckIsValidNumber     : TOnGetCheckIsValidNumber   read FOnGetCheckIsValidNumber        write FOnGetCheckIsValidNumber;
    property OnGetProfilePicThumb        : TOnGetProfilePicThumb      read FOnGetProfilePicThumb           write FOnGetProfilePicThumb;
    property OnGetMyNumber               : TNotifyEvent               read FOnGetMyNumber                  write FOnGetMyNumber;

    property OnGetIsDelivered            : TNotifyEvent               read FOnGetIsDelivered               write FOnGetIsDelivered;


    property OnUpdateJS                  : TNotifyEvent               read FOnUpdateJS                     write FOnUpdateJS;
    property OnConnected                 : TNotifyEvent               read FOnConnected                    write FOnConnected;
    property OnDisconnected              : TNotifyEvent               read FOnDisconnected                 write FOnDisconnected;
    property OnDisconnectedBrute         : TNotifyEvent               read FOnDisconnectedBrute            write FOnDisconnectedBrute;
    property OnErroAndWarning            : TOnErroInternal            read FOnErroInternal                 write FOnErroInternal;
    property OnGetStatusMessage          : TOnGetStatusMessage        read FOnGetStatusMessage             write FOnGetStatusMessage;
    property OnGetInviteGroup            : TOnGetInviteGroup          read FOnGetInviteGroup               write FOnGetInviteGroup;
    property OnGetMe                     : TOnGetMe                   read FOnGetMe                        write FOnGetMe;
    property OnNewGetNumber              : TOnNewCheckNumber          read FOnNewCheckNumber               write FOnNewCheckNumber;
  end;

procedure Register;


implementation

uses
  uCEFTypes, uTWPPConnect.ConfigCEF, Winapi.Windows, Winapi.Messages,
  uCEFConstants, Datasnap.DBClient, Vcl.WinXCtrls, Vcl.Controls, Vcl.StdCtrls,
  uTWPPConnect.FrmQRCode, System.NetEncoding;


procedure Register;
begin
  RegisterComponents('TWPPConnect', [TWPPConnect]);
end;

{ TWPPConnect }

procedure TWPPConnect.GetBatteryStatus();
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetBatteryLevel;
end;

function TWPPConnect.Auth(PRaise: Boolean): Boolean;
begin
  Result := authenticated;

  if (not Result) and  (PRaise) then
     raise Exception.Create(Text_Status_Serv_Disconnected);
end;

//funcao experimental para configuracao de proxy de rede(Ainda nao foi testada)
//Olhar em uTWPPConnect.Console funcao ConfigureNetWork
{function TWPPConnect.ConfigureNetwork: Boolean;
begin
  Result := ConsolePronto;
  if not result then
     Exit;

  Result := FrmConsole.ConfigureNetWork;
end; }

procedure TWPPConnect.BloquearContato(PIDContato: String);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDContato) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDContato);
    Exit;
  end;

  PIDContato := AjustNumber.FormatIn(PIDContato);
  if pos('@', PIDContato) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PIDContato);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.BloquearContato(PIDContato);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

function TWPPConnect.CheckDelivered: String;
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
          if Config.AutoDelay > 0 then
             sleep(random(Config.AutoDelay));

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(FrmConsole) then
               FrmConsole.CheckDelivered;
          end);

      end);
  lThread.Start;
end;

procedure TWPPConnect.CheckIsConnected;
begin
  if Assigned(FrmConsole) then
      FrmConsole.CheckIsConnected;
end;

procedure TWPPConnect.CheckIsValidNumber(PNumberPhone: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.CheckIsValidNumber(PNumberPhone);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.NewCheckIsValidNumber(PNumberPhone: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.NewCheckIsValidNumber(PNumberPhone);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;


function TWPPConnect.ConsolePronto: Boolean;
begin
  try
    Result := Assigned(FrmConsole);
    if Assigned(GlobalCEFApp) then
    Begin
      if GlobalCEFApp.ErrorInt Then
         Exit;
    end;

    if not Assigned(FrmConsole) Then
    Begin
      InjectJS.UpdateNow();
      if InjectJS.Ready then //Read? Get random key....
      Begin
        FDestruido                      := False;
        FrmConsole                      := TFrmConsole.Create(nil);
        FrmConsole.OwnerForm            := Self;
        FrmConsole.OnNotificationCenter := Int_OnNotificationCenter;
        FrmConsole.MonitorLowBattry     := Assigned(FOnLowBattery);
        FrmConsole.OnErrorInternal      := Int_OnErroInterno;
        FrmConsole.Connect;
      end;
    end;
    Result := Assigned(FrmConsole);
  except
    Result := False;
  end
end;

constructor TWPPConnect.Create(AOwner: TComponent);
begin
  inherited;
  FDestroyTmr                         := Ttimer.Create(nil);
  FDestroyTmr.Enabled                 := False;
  FDestroyTmr.Interval                := 4000;     //Tempo exigido pelo CEF
  FDestroyTmr.OnTimer                 := OnDestroyConsole;

  FTranslatorInject                   := TTranslatorInject.create;
  FDestruido                          := False;
  FGetBatteryLevel                    := -1;

  FFormQrCodeType                     := Ft_Http;
  LanguageInject                      := Tl_Portugues_BR;
  Fversion                            := TWPPConnectVersion;
  Fstatus                             := Server_Disconnected;

  if not (csDesigning in ComponentState) then
     if not Assigned(GlobalCEFApp.IniFIle) then
        raise Exception.Create(slinebreak + MSG_Except_CefNull);

  FInjectConfig                       := TWPPConnectConfig.Create(self);
  FInjectConfig.OnNotificationCenter  := Int_OnNotificationCenter;
  FInjectConfig.AutoDelay             := 1000;
  FInjectConfig.SecondsMonitor        := 3;
  FInjectConfig.ControlSend           := True;
  FInjectConfig.LowBatteryis          := 30;
  FInjectConfig.ControlSendTimeSec    := 8;

  FAdjustNumber                    := TWPPConnectAdjusteNumber.Create(self);
  FInjectJS                        := TWPPConnectJS.Create(Self);
  FInjectJS.OnUpdateJS             := Int_OnUpdateJS;
  FInjectJS.OnErrorInternal        := Int_OnErroInterno;
end;

procedure TWPPConnect.createGroup(PGroupName, PParticipantNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PParticipantNumber := AjustNumber.FormatIn(PParticipantNumber);
  if pos('@', PParticipantNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PParticipantNumber);
    Exit;
  end;

  if Trim(PGroupName) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PParticipantNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.CreateGroup(PGroupName, PParticipantNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.deleteConversation(PNumberPhone: string);
var
  lThread : TThread;
begin
  if Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  if Assigned(FrmConsole) then
  begin
    FrmConsole.ReadMessagesAndDelete(PNumberPhone);//Deleta a conversa
  end;

end;

procedure TWPPConnect.DesbloquearContato(PIDContato: String);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDContato) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDContato);
    Exit;
  end;

  PIDContato := AjustNumber.FormatIn(PIDContato);
  if pos('@', PIDContato) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PIDContato);
    Exit;
  end;



  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.DesbloquearContato(PIDContato);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

destructor TWPPConnect.Destroy;
begin

  FormQrCodeStop;
  FreeAndNil(FDestroyTmr);
  FreeAndNil(FTranslatorInject);
  FreeAndNil(FInjectConfig);
  FreeAndNil(FAdjustNumber);
  FreeAndNil(FInjectJS);

  inherited;
end;

procedure TWPPConnect.GetAllContacts;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllContacts;
end;

procedure TWPPConnect.GetAllGroups;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllGroups;
end;

function TWPPConnect.GetChat(Pindex: Integer): TChatClass;
begin
  Result := Nil;
  If not Assigned(FrmConsole)          then     Exit;
  If not Assigned(FrmConsole.ChatList) then     Exit;
  Result := FrmConsole.ChatList.result[Pindex]
end;

function TWPPConnect.GetContact(Pindex: Integer): TContactClass;
begin
  Result := Nil;
end;

procedure TWPPConnect.getMessageById(UniqueIDs, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 01/03/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;


  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            //FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.getMessageById(UniqueIDs);
            if etapa <> '' then
            begin
              //FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.getProfilePicThumb(AProfilePicThumbURL: string);
begin
  if Assigned(FrmConsole) then
    FrmConsole.GetProfilePicThumbURL(AProfilePicThumbURL);
end;

procedure TWPPConnect.GetAllChats;
begin
  if Assigned(FrmConsole) then
     FrmConsole.GetAllChats;
end;

function TWPPConnect.GetUnReadMessages: String;
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
          if Config.AutoDelay > 0 then
             sleep(random(Config.AutoDelay));

          TThread.Synchronize(nil, procedure
          begin
            if Assigned(FrmConsole) then
               FrmConsole.GetUnReadMessages;
          end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.GroupAddParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupAddParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.groupDelete(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupDelete(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.GroupDemoteParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupDemoteParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.GroupJoinViaLink(PLinkGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PLinkGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PLinkGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupJoinViaLink(PLinkGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.groupLeave(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupLeave(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.GroupPromoteParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupPromoteParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.GroupRemoveParticipant(PIDGroup, PNumber: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.GroupRemoveParticipant(PIDGroup, PNumber);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.SetProfileName(vName: String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.setNewName(vName);

end;

procedure TWPPConnect.SetSerialCorporate(const Value: TWPPConnectJS);
begin
  FInjectJS.Assign(Value);
end;

procedure TWPPConnect.SetStatus(vStatus: String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.setNewStatus(vStatus);
end;

procedure TWPPConnect.GetMe();
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.fGetMe();
end;

procedure TWPPConnect.GetStatusContact(PNumber : String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;


  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  FrmConsole.getStatus(PNumber);
end;

procedure TWPPConnect.GetGroupInviteLink(PIDGroup : string);
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  FrmConsole.getGroupInviteLink(PIDGroup);
end;

procedure TWPPConnect.GroupRemoveInviteLink(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.revokeGroupInviteLink(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.CleanALLChat(PNumber : String);
begin
   If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;


  PNumber := AjustNumber.FormatIn(PNumber);

  if pos('@', PNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumber);
    Exit;
  end;

  FrmConsole.CleanChat(PNumber);
end;

procedure TWPPConnect.Int_OnErroInterno(Sender : TObject; Const PError: String; Const PInfoAdc:String);
begin
  if Assigned(FOnErroInternal) then
     FOnErroInternal(Sender, PError, PInfoAdc);
end;

procedure TWPPConnect.Int_OnUpdateJS(Sender: TObject);
begin
  if Assigned(FOnUpdateJS) then
     FOnUpdateJS(Self);
end;

procedure TWPPConnect.isBeta;
begin
  //Adicionado Por Marcelo 01/03/2022
  if Assigned(FrmConsole) then
    FrmConsole.isBeta;
end;

procedure TWPPConnect.LimparQrCodeInterno;
var
  ltmp: TResultQRCodeClass;
begin
  if not Assigned(FOnGetQrCode) then     Exit;

  ltmp:= TResultQRCodeClass.Create(FrmConsole_JS_RetornoVazio);
  Try
    FOnGetQrCode(self, ltmp);
  Finally
    FreeAndNil(ltmp);
  end;
end;

procedure TWPPConnect.listGroupContacts(PIDGroup: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;

  if not Assigned(FrmConsole) then
     Exit;

  if Trim(PIDGroup) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PIDGroup);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.listGroupContacts(PIDGroup);
            FrmConsole.listGroupAdmins(PIDGroup);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.Loaded;
begin
  inherited;
  if (csDesigning in ComponentState) then
     Exit;

  if Config.AutoStart then
     FormQrCodeStart(False);
end;

procedure TWPPConnect.Logout;
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.Logout();
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.markIsComposing(phoneNumber, duration, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 18/05/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(duration) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.markIsComposing(phoneNumber, duration);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.Int_OnNotificationCenter(PTypeHeader: TTypeHeader; PValue: String; Const PReturnClass : TObject);
begin
  {###########################  ###########################}
  if (PTypeHeader In [Th_AlterConfig]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    FrmConsole.SetZoom(Config.Zoom);
    exit;
  end;


  if (PTypeHeader In [Th_GetCheckIsValidNumber]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetCheckIsValidNumber) then
       Exit;


    FOnGetCheckIsValidNumber(Self,
                             TResponseCheckIsValidNumber(PReturnClass).Number,
                             TResponseCheckIsValidNumber(PReturnClass).result
                             );
    exit;
  end;



  if (PTypeHeader In [Th_GetProfilePicThumb]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetProfilePicThumb) then
       Exit;


    FOnGetProfilePicThumb(Self,
                          TResponseGetProfilePicThumb(PReturnClass).Base64);
    exit;
  end;


  if (PTypeHeader In [Th_GetAllChats, Th_getUnreadMessages, Th_GetMessageById]) then
  Begin
    if not Assigned(PReturnClass) then
      raise Exception.Create(MSG_ExceptMisc + ' in Int_OnNotificationCenter' );

    If PTypeHeader = Th_GetAllChats Then
    Begin
      if Assigned(OnGetChatList) then
         OnGetChatList(TChatList(PReturnClass));
    end;

    If PTypeHeader = Th_getUnreadMessages Then
    Begin
      if Assigned(OnGetUnReadMessages) then
         OnGetUnReadMessages(TChatList(PReturnClass));

    end;

    If PTypeHeader = Th_GetMessageById Then
    Begin
      if Assigned(OnGetMessageById) then
         OnGetMessageById(TMessagesList(PReturnClass));
         //OnGetMessageById(TMessagesClass(PReturnClass));

    end;

    Exit;
  end;


  if PTypeHeader in [Th_ConnectedDown] then
  Begin
    FStatus := Server_ConnectedDown;
    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
    Disconnect;
    exit;
  end;


  if PTypeHeader in [Th_ForceDisconnect] then
  Begin
    if Assigned(FOnDisconnectedBrute) then
       FOnDisconnectedBrute(Self);
    Disconnect;
    exit;
  end;


  if PTypeHeader = Th_Initialized then
  Begin
    FStatus := Inject_Initialized;
    if Assigned(FOnAfterInitialize) then
       FOnAfterInitialize(Self);

    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
  end;


  if PTypeHeader = Th_Initializing then
  begin
    if not Assigned(FrmConsole) then
       Exit;

    FrmConsole.GetMyNumber;
    SleepNoFreeze(40);


    FrmConsole.GetAllContacts(true);
    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
    Exit;
  end;

  if PTypeHeader = Th_getAllGroups then
  Begin
    if Assigned(FOnGetAllGroupList) then
      FOnGetAllGroupList(TRetornoAllGroups(PReturnClass))
  end;

  if PTypeHeader = Th_getAllGroupAdmins then
  Begin
    if Assigned(FOnGetAllGroupAdmins) then
      FOnGetAllGroupAdmins(TRetornoAllGroupAdmins(PReturnClass))
  end;

  //03/06/2020
  If PTypeHeader = Th_getAllGroupContacts Then
  Begin
    if Assigned(OnGetAllGroupContacts) then
       OnGetAllGroupContacts(TClassAllGroupContacts(PReturnClass));
  end;


  if PTypeHeader = Th_getMyNumber then
  Begin
    FMyNumber := FAdjustNumber.FormatOut(PValue);
    if Assigned(FOnGetMyNumber) then
       FOnGetMyNumber(Self);
  end;


  //29/12/2020
  if PTypeHeader = Th_getIsDelivered then
  Begin
    FIsDelivered := FAdjustNumber.FormatOut(PValue);
    if Assigned(FOnGetIsDelivered) then
       FOnGetIsDelivered(Self);
  end;


  if PTypeHeader = Th_GetStatusMessage then
  Begin
   if Assigned(FOnGetStatusMessage) then
       FOnGetStatusMessage(TResponseStatusMessage(PReturnClass));
  end;

  if PTypeHeader = Th_GetMe  then
  begin
    if Assigned(FOnGetMe) then
       FOnGetMe(TGetMeClass(PReturnClass));
  end;

  if PTypeHeader = Th_NewCheckIsValidNumber  then
  begin
    if Assigned(FOnNewCheckNumber) then
       FOnNewCheckNumber(TReturnCheckNumber(PReturnClass));
  end;


  if PTypeHeader = Th_GetBatteryLevel then
  Begin
    FGetBatteryLevel :=  StrToIntDef(PValue, -1);
    if Assigned(FOnLowBattery) then
    Begin
      if FGetBatteryLevel <= Config.LowBatteryIs Then
      Begin
        FOnLowBattery(Self);
      end else
      Begin
        if Assigned(fOnGetBatteryLevel) then
           fOnGetBatteryLevel(Self);
      end;
    end;
    Exit;
  end;


  if (PTypeHeader In [Th_GetCheckIsConnected]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetCheckIsConnected) then
       Exit;

    FOnGetCheckIsConnected(Self,
                             TResponseCheckIsConnected(PReturnClass).result
                             );
    exit;
  end;

  //Adicionado Por Marcelo 01/03/2022
  if (PTypeHeader In [Th_GetCheckIsBeta]) then
  Begin
    if not Assigned(FrmConsole) then
       Exit;

    if not Assigned(FOnGetCheckIsBeta) then
       Exit;

    FOnGetCheckIsBeta(Self,
                             TResponseCheckIsBeta(PReturnClass).result
                             );
    exit;
  end;


  if PTypeHeader in [Th_Connected, Th_Disconnected]  then
  Begin
    if PTypeHeader = Th_Connected then
       SetAuth(True) else
       SetAuth(False);
    LimparQrCodeInterno;
    Exit;
  end;


  if PTypeHeader in [Th_Abort]  then
  Begin
    Fstatus     := Server_Disconnected;
    if Assigned(fOnGetStatus) then
       fOnGetStatus(Self);
    Exit;
  end;


  if PTypeHeader in [Th_Connecting, Th_Disconnecting, Th_ConnectingNoPhone, Th_getQrCodeForm, Th_getQrCodeForm, TH_Destroy, Th_Destroying]  then
  begin
    case PTypeHeader of
      Th_Connecting            : Fstatus := Server_Connecting;
      Th_Disconnecting         : Fstatus := Server_Disconnecting;
      Th_ConnectingNoPhone     : Fstatus := Server_ConnectingNoPhone;
      TH_Destroy               : Fstatus := Inject_Destroy;
      Th_Destroying            : Fstatus := Inject_Destroying;
      Th_ConnectingFt_Desktop,
      Th_getQrCodeForm         : Fstatus := Server_ConnectingReaderCode;
    end;
    if Assigned(fOnGetStatus ) then
       fOnGetStatus(Self);
    Exit;
  end;
end;

procedure TWPPConnect.ReadMessages(vID: string);
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  if Config.AutoDelete Then
  begin
    if assigned(FrmConsole) then
       FrmConsole.ReadMessagesAndDelete(vID);
  end else
  Begin
    if assigned(FrmConsole) then
       FrmConsole.ReadMessages(vID);
  end;
end;

procedure TWPPConnect.send(PNumberPhone, PMessage: string; PEtapa: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  if Trim(PMessage) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.Send(PNumberPhone, PMessage);
            if PEtapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(PNumberPhone);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;


procedure TWPPConnect.SendFile(PNumberPhone: string;
  const PFileName: String; PMessage: string);
var
  lThread     : TThread;
  LStream     : TMemoryStream;
  LBase64File : TBase64Encoding;
  LExtension  : String;
  LBase64     : String;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  LExtension   := LowerCase(Copy(ExtractFileExt(PFileName),2,5));
  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, 'SendFile: ' + MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  If not FileExists(Trim(PFileName)) then
  begin
    Int_OnErroInterno(Self, 'SendFile: ' + Format(MSG_ExceptPath, [PNumberPhone]), PNumberPhone);
    Exit;
  end;

  LStream     := TMemoryStream.Create;
  LBase64File := TBase64Encoding.Create;
  try
    try
      LStream.LoadFromFile(PFileName);
      if LStream.Size = 0 then
      Begin
        Int_OnErroInterno(Self, 'SendFile: ' + Format(MSG_WarningErrorFile, [PNumberPhone]), PNumberPhone);
        Exit;
      end;

      LStream.Position := 0;
      LBase64      := LBase64File.EncodeBytesToString(LStream.Memory, LStream.Size);
      LBase64      := StrExtFile_Base64Type(PFileName) + LBase64;
    except
      Int_OnErroInterno(Self, 'SendFile: ' + MSG_ExceptMisc, PNumberPhone);
    end;
  finally
    FreeAndNil(LStream);
    FreeAndNil(LBase64File);
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
         if Config.AutoDelay > 0 then
            sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.sendBase64(LBase64, PNumberPhone, PFileName, PMessage);
          end;
        end);
      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;
end;

procedure TWPPConnect.SendFileMessage(phoneNumber, content, options, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 01/03/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(content) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendFileMessage(phoneNumber, content, options);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendLinkPreview(PNumberPhone, PVideoLink, PMessage: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  if Trim(PMessage) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
    Exit;
  end;

  if Trim(PVideoLink) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PVideoLink);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.sendLinkPreview(PNumberPhone, PVideoLink, PMessage);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendListMenu(phoneNumber, title, subtitle, description, buttonText, menu, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 01/03/2022
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(title) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendListMenu(phoneNumber, title, subtitle, description, buttonText, menu);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.sendListMessage(phoneNumber, buttonText, description, sections, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 01/03/2022
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(buttonText) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.sendListMessage(phoneNumber, buttonText, description, sections);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendLocation(PNumberPhone, PLat, PLng, PMessage: string);
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);
  if pos('@', PNumberPhone) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  if Trim(PMessage) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
    Exit;
  end;

  if (Trim(PLat) = '') or (Trim(PLng) = '') then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PLat+PLng);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(PNumberPhone); //Marca como lida a mensagem
            FrmConsole.sendLocation(PNumberPhone, PLat, PLng, PMessage);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendLocationMessage(phoneNumber, options, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 01/03/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(options) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendLocationMessage(phoneNumber, options);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendRawMessage(phoneNumber, rawMessage, options, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 18/05/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(rawMessage) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendTextMessage(phoneNumber, rawMessage, options);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendReactionMessage(UniqueID, Reaction, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 10/05/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;

  if Trim(UniqueID) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, UniqueID);
    Exit;
  end;

  if Trim(Reaction) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, Reaction);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.SendReactionMessage(UniqueID, Reaction);

          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendTextMessage(phoneNumber, content, options, etapa: string);
var
  lThread : TThread;
begin
  //Adicionado Por Marcelo 10/05/2022
  if Application.Terminated Then
    Exit;
  if not Assigned(FrmConsole) then
    Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(content) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendTextMessage(phoneNumber, content, options);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.sendBase64(Const vBase64: String; vNum: String;  Const vFileName, vMess: string);
Var
  lThread : TThread;
begin
  inherited;
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  vNum := AjustNumber.FormatIn(vNum);
  if pos('@', vNum) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, vNum);
    Exit;
  end;

  if (Trim(vBase64) = '') then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, vNum);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
         if Config.AutoDelay > 0 then
            sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(vNum); //Marca como lida a mensagem
            FrmConsole.sendBase64(vBase64, vNum, vFileName, vMess);
          end;
        end);
      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;


procedure TWPPConnect.SendButtons(phoneNumber, titleText, buttons,
  footerText: string; etapa: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  phoneNumber := AjustNumber.FormatIn(phoneNumber);
  if pos('@', phoneNumber) = 0 then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, phoneNumber);
    Exit;
  end;

  if Trim(titleText) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, phoneNumber);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.ReadMessages(phoneNumber); //Marca como lida a mensagem
            FrmConsole.SendButtons(phoneNumber, titleText, buttons, footerText);
            if etapa <> '' then
            begin
              FrmConsole.ReadMessagesAndDelete(phoneNumber);//Deleta a conversa
            end;
          end;
        end);

      end);
  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SendContact(PNumberPhone, PNumber: string; PNameContact: string = '');
var
  lThread : TThread;
begin
  If Application.Terminated Then
     Exit;
  if not Assigned(FrmConsole) then
     Exit;

  PNumberPhone := AjustNumber.FormatIn(PNumberPhone);

  if (pos('@', PNumberPhone) = 0) then
  Begin
    Int_OnErroInterno(Self, MSG_ExceptPhoneNumberError, PNumberPhone);
    Exit;
  end;

  if Trim(PNumber) = '' then
  begin
    Int_OnErroInterno(Self, MSG_WarningNothingtoSend, PNumberPhone);
    Exit;
  end;

  lThread := TThread.CreateAnonymousThread(procedure
      begin
        if Config.AutoDelay > 0 then
           sleep(random(Config.AutoDelay));

        TThread.Synchronize(nil, procedure
        begin
          if Assigned(FrmConsole) then
          begin
            FrmConsole.SendContact(PNumberPhone, PNumber, PNameContact);
          end;
        end);

      end);

  lThread.FreeOnTerminate := true;
  lThread.Start;

end;

procedure TWPPConnect.SetAuth(const Value: boolean);
begin
  if Value then
  Begin
    If (Fstatus = Server_Connected) = Value Then
       Exit;
  end;

  if (Not (Fstatus = Server_Connected)) and (Value) then
  Begin
    Fstatus := Server_Connected;
    if Assigned(FrmConsole) then
       FrmConsole.FormQrCode.FTimerGetQrCode.Enabled := False;

     if Assigned(FOnConnected) then
         FOnConnected(Self);
  end;

  if ((Fstatus = Server_Connected)) and (not Value) then
  Begin
    Fstatus := Server_Disconnected;
    if Assigned(FrmConsole) then
       FrmConsole.DisConnect;

    if Assigned(FOnDisconnected) then
       FOnDisconnected(Self);
  end;

  if Assigned(OnGetStatus ) then
  Begin
    OnGetStatus(Self);
  end;
end;

procedure TWPPConnect.SetdjustNumber(const Value: TWPPConnectAdjusteNumber);
begin
  FAdjustNumber.Assign(Value);
end;

procedure TWPPConnect.SetInjectConfig(const Value: TWPPConnectConfig);
begin
  FInjectConfig.Assign(Value);
end;

procedure TWPPConnect.SetInjectJS(const Value: TWPPConnectJS);
begin
  FInjectJS.Assign(Value);
end;

procedure TWPPConnect.SetLanguageInject(const Value: TLanguageInject);
begin
  FLanguageInject := Value;
  FTranslatorInject.SetTranslator(Value);
end;

procedure TWPPConnect.SetOnLowBattery(const Value: TNotifyEvent);
begin
  FOnLowBattery := Value;
  if Assigned(FrmConsole) then
     FrmConsole.MonitorLowBattry := Assigned(FOnLowBattery);
end;

procedure TWPPConnect.SetQrCodeStyle(const Value: TFormQrCodeType);
begin
  if FFormQrCodeType = Value Then
     Exit;

  if (Status = Inject_Initialized) then
     raise Exception.Create(MSG_ExceptOnAlterQrCodeStyle);
  try
    LimparQrCodeInterno;
    if Assigned(FrmConsole) then
       FrmConsole.StopWebBrowser;
  finally
    FFormQrCodeType := Value;
    Fstatus      := Server_Disconnected;
  end;
end;

procedure  TWPPConnect.Disconnect;
Var
  Ltime  : Cardinal;
  LForced: Boolean;
begin
  If Status In [Server_Disconnecting, Inject_Destroying] Then
     raise Exception.Create(MSG_WarningClosing);

  if FDestruido then
     Exit;

  FDestruido := true;
  Ltime      := GetTickCount;
  if Assigned(FrmConsole) then
  Begin
    LForced:= False;
    PostMessage(FrmConsole.Handle, FrmConsole_Browser_Direto, 0, 0);
    Repeat
      SleepNoFreeze(10);
      //Time OutLimite para o componente FORCAR a finalizacao
      if ((GetTickCount - Ltime) >= 6000) and (Not LForced) and (Status <> Inject_Destroy)  then
      Begin
         LForced := true;
         FrmConsole.CEFSentinel1.Start;
         SleepNoFreeze(1000);
         FrmConsole.Chromium1.ShutdownDragAndDrop;
         PostMessage(FrmConsole.Handle, CEF_DESTROY, 0, 0);
      end
    Until Status = Inject_Destroy;
  end;

  //Tempo exigido pelo CEF para pder finalizar sem AV
  FDestroyTmr.Enabled := True;
end;


function TWPPConnect.TestConnect: Boolean;
begin
  Result := (Fstatus = Inject_Initialized);
end;

function TWPPConnect.GetAppShowing: Boolean;
var
  lForm: Tform;
begin
  Result := False;
  lForm  := nil;
  try
    try
      case FFormQrCodeType of
        Ft_Desktop : lForm := FrmConsole.FormQrCode;
        Ft_Http    : lForm := FrmConsole;
      end;
    finally
     if Assigned(lForm) then
        Result := lForm.Showing;
    end;
  except
    Result := False;
  end;
end;

procedure TWPPConnect.SetAppShowing(const Value: Boolean);
var
  lForm: Tform;
begin
  lForm := Nil;
  try
    case FFormQrCodeType of
      Ft_None    : Begin
                     if Status = Inject_Initialized then
                        lForm := FrmConsole;
                   end;

      Ft_Desktop : lForm := FrmConsole.FormQrCode;
      Ft_Http    : lForm := FrmConsole;
    end;
  finally
    if Assigned(lForm) then
    Begin
      if lForm is  TFrmQRCode then
         TFrmQRCode(lForm).ShowForm(FFormQrCodeType) else
         lForm.Show;
    end else
    Begin
      if FFormQrCodeType <> Ft_None then
         raise Exception.Create(MSG_ExceptMisc);
    end;
  end;
end;

Procedure TWPPConnect.OnCLoseFrmInt(Sender: TObject; var CanClose: Boolean);
Begin
  CanClose := Fstatus = Inject_Destroy;
end;

procedure TWPPConnect.OnDestroyConsole(Sender: TObject);
begin
  FDestroyTmr.Enabled := False;
  try
    if Assigned  (FrmConsole) then
       FrmConsole := Nil;
  except
  end;
end;

procedure TWPPConnect.ShutDown(PWarning:Boolean);
Var
  LForm  : Tform;
  LPanel1: Tpanel;
  LAbel1 : TLabel;
  LActivityIndicator1: TActivityIndicator;
begin
  if PWarning then
  Begin
    if MessageDlg(Text_FrmClose_WarningClose, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
       Abort;
  end;


  LForm := Tform.Create(Nil);
  try
    LForm.BorderStyle                 := bsDialog;
    LForm.BorderIcons                 := [biMinimize,biMaximize];
    LForm.FormStyle                   := fsStayOnTop;
    LForm.Caption                     := Text_FrmClose_Caption;
    LForm.Height                      := 124;
    LForm.Width                       := 298;
    LForm.Position                    := poScreenCenter;
    LForm.Visible                     := False;
    LForm.OnCloseQuery                := OnCLoseFrmInt;

    LPanel1                           := Tpanel.Create(LForm);
    LPanel1.Parent                    := LForm;
    LPanel1.ShowCaption               := False;
    LPanel1.BevelOuter                := bvNone;
    LPanel1.Width                     := 81;
    LPanel1.Align                     := alLeft;

    LActivityIndicator1               := TActivityIndicator.Create(LPanel1);
    LActivityIndicator1.Parent        := LPanel1;
    LActivityIndicator1.IndicatorSize := aisXLarge;
    LActivityIndicator1.Animate       := True;
    LActivityIndicator1.Left          := (LPanel1.Width  - LActivityIndicator1.Width)  div 2;
    LActivityIndicator1.Top           := (LPanel1.Height - LActivityIndicator1.Height) div 2;

    LAbel1                            := TLabel.Create(LForm);
    LAbel1.Parent                     := LForm;
    LAbel1.Align                      := alClient;
    LAbel1.Alignment                  := taCenter;
    LAbel1.Layout                     := tlCenter;
    LAbel1.Font.Size                  := 10;
    LAbel1.WordWrap                   := True;
    LAbel1.Caption                    := Text_FrmClose_Label;
    LAbel1.AlignWithMargins           := true;
    LForm.Visible                     := True;
    Application.MainForm.Visible      := False;
    LForm.Show;

    Disconnect;
    LForm.close;
  finally
    FreeAndNil(LForm);
    //FreeAndNil(GlobalCEFApp);
    //if CallTerminateProcs then PostQuitMessage(0);
  end
end;

procedure TWPPConnect.FormQrCodeReloader;
begin
  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.ReloaderWeb;
end;


procedure TWPPConnect.FormQrCodeStart(PViewForm: Boolean);
var
   LState: Boolean;
begin
  if Application.Terminated Then
     Exit;
  LState := Assigned(FrmConsole);

  if Status in [Inject_Destroying, Server_Disconnecting] then
  begin
    Application.MessageBox(PWideChar(MSG_WarningQrCodeStart1), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
    Exit;
  end;

  if Status in [Server_Disconnected, Inject_Destroy] then
  begin
    if not ConsolePronto then
    begin
      Application.MessageBox(PWideChar(MSG_ConfigCEF_ExceptConsoleNaoPronto), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      Exit;
    end;
    //Reseta o FORMULARIO
    if LState Then
       FormQrCodeReloader;
  end else
    begin
      //Ja esta logado. chamou apenas por chamar ou porque nao esta visivel..
      PViewForm :=true
    end;

  //Faz uma parada forçada para que tudo seja concluido
  SleepNoFreeze(30);
  FrmConsole.StartQrCode(FormQrCodeType, PViewForm);
end;

procedure TWPPConnect.FormQrCodeStop;
begin
  if not Assigned(FrmConsole) then
     Exit;

  FrmConsole.StopQrCode(FormQrCodeType);
end;


function TWPPConnect.StatusToStr: String;
begin
  case Fstatus of
    Inject_Initialized         : Result := Text_Status_Serv_Initialized;
    Inject_Initializing        : Result := Text_Status_Serv_Initializing;
    Server_Disconnected        : Result := Text_Status_Serv_Disconnected;
    Server_Disconnecting       : Result := Text_Status_Serv_Disconnecting;
    Server_Connected           : Result := Text_Status_Serv_Connected;
    Server_ConnectedDown       : Result := Text_Status_Serv_ConnectedDown;
    Server_Connecting          : Result := Text_Status_Serv_Connecting;
    Server_ConnectingNoPhone   : Result := Text_Status_Serv_ConnectingNoPhone;
    Server_ConnectingReaderCode: Result := Text_Status_Serv_ConnectingReaderQR;
    Server_TimeOut             : Result := Text_Status_Serv_TimeOut;
    Inject_Destroying          : Result := Text_Status_Serv_Destroying;
    Inject_Destroy             : Result := Text_Status_Serv_Destroy;
  end;
end;


end.
