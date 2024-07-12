import UIKit
import ReplayKit
import Flutter
import MobileRTC

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    
    private var channelName  = "com.meetspark/spark_sdk"
    
    var authenticationDelegate: AuthenticationDelegate
    var eventSink: FlutterEventSink?
    var appGroupID = "group.com.sanyuanshi.mobile.meeting.g"
    
    override init() {
        authenticationDelegate = AuthenticationDelegate()
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let deviceChannel = FlutterMethodChannel(name: self.channelName,
                                                 binaryMessenger: controller.binaryMessenger)
        prepareMethodHandler(deviceChannel: deviceChannel)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        deviceChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "init" {
                guard let args = call.arguments as? Dictionary<String, String> else { return }
                self.inititalizeSDK(args: args, result: result)
            }else if  call.method == "joinMeeting" {
                guard let args = call.arguments as? Dictionary<String, String?> else { return }
                self.joinMeeting(arguments: args, result: result)
            }else if call.method == "isSdkInit" {
                self.isSdkInit(result: result)
            }else if call.method == "startInstantMeeting" {
                guard let args = call.arguments as? Dictionary<String, String?> else { print("can not start meeting, args error!"); return }
                self.startMeeting(arguments: args, result: result)
            }else if  call.method == "startMeetingWithNumber" {
                guard let args = call.arguments as? Dictionary<String, String?> else { print("can not start meeting, args error!"); return }
                self.startMeeting(arguments: args, result: result)
            }else if call.method == "meeting_status" {
                self.meetingStatus(result: result)
            }else if call.method == "meeting_details" {
                self.meetingDetails(result: result)
            }
            else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }
    
    private func inititalizeSDK(args: Dictionary<String, String>, result: @escaping FlutterResult) {
        self.initialiseSDK(arguments: args, result: result)
    }
    
    //Helper Function for parsing string to boolean value
    private func parseBoolean(data: String?, defaultValue: Bool) -> Bool {
        var result: Bool

        if let unwrappeData = data {
            result = NSString(string: unwrappeData).boolValue
        } else {
           result = defaultValue
        }
        return result
    }
    
    // Flutter stream handler -- Listen to initializing sdk events
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        let meetingService = MobileRTC.shared().getMeetingService()
        if meetingService == nil {
            return FlutterError(code: "Zoom SDK error", message: "ZoomSDK is not initialized", details: nil)
        }
        meetingService?.delegate = self

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    //Listen to meeting status on joinning and starting the meeting
    public func meetingStatus(result: FlutterResult) {
        let meetingService = MobileRTC.shared().getMeetingService()
        if meetingService != nil {
            let meetingState = meetingService?.getMeetingState()
            result(getStateMessage(meetingState))
        } else {
            result(["MEETING_STATUS_UNKNOWN", ""])
        }
   }
    
    //Get Meeting Details Programmatically after Starting the Meeting
    public func meetingDetails(result: FlutterResult) {
        let meetingService = MobileRTC.shared().getMeetingService()
        if meetingService != nil {
            let meetingPassword = MobileRTCInviteHelper.sharedInstance().rawMeetingPassword
            let meetingNumber = MobileRTCInviteHelper.sharedInstance().ongoingMeetingNumber
            
            result([meetingNumber, meetingPassword])
            
        } else {
            result(["MEETING_STATUS_UNKNOWN", "No status available"])
        }
    }
    
}

extension AppDelegate {
        
    func initialiseSDK(arguments: Dictionary<String, String>, result: @escaping FlutterResult) {
        let pluginBundle = Bundle(for: type(of: self))
        let pluginBundlePath = pluginBundle.bundlePath
        let context = MobileRTCSDKInitContext()
        context.domain = "https://" + arguments["domain"]!
        context.enableLog = true
        context.bundleResPath = pluginBundlePath
        context.appGroupId = self.appGroupID
        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)
        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
            // authorizationService.delegate = self
            authorizationService.delegate = self.authenticationDelegate.onAuth(result)
            authorizationService.jwtToken = arguments["jwtToken"]
            authorizationService.sdkAuth()
        }
    }
    
    func isSdkInit(result: @escaping FlutterResult) {
        let meetingService = MobileRTC.shared().getMeetingService()
        if meetingService == nil {
            result(false)
            return
        }
        if(MobileRTC.shared().isRTCAuthorized()){
            result(true)
        }else{
            result(false)
        }
    }
    
    func joinMeeting(arguments: Dictionary<String, String?>, result: @escaping FlutterResult) {
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        let meetingService = MobileRTC.shared().getMeetingService()
        let meetingSettings = MobileRTC.shared().getMeetingSettings()

        if (meetingService != nil) {
            meetingService?.delegate = self
            //Setting up meeting settings for zoom sdk
            meetingSettings?.disableDriveMode(parseBoolean(data: arguments["disableDrive"]!, defaultValue: false))
            meetingSettings?.disableCall(in: parseBoolean(data: arguments["disableDialIn"]!, defaultValue: false))
            meetingSettings?.setAutoConnectInternetAudio(parseBoolean(data: arguments["noDisconnectAudio"]!, defaultValue: false))
            meetingSettings?.setMuteAudioWhenJoinMeeting(parseBoolean(data: arguments["noAudio"]!, defaultValue: false))
            meetingSettings?.meetingShareHidden = parseBoolean(data: arguments["disableShare"]!, defaultValue: false)
            meetingSettings?.meetingInviteHidden = parseBoolean(data: arguments["disableInvite"]!, defaultValue: false)
            meetingSettings?.meetingTitleHidden = parseBoolean(data:arguments["disableTitlebar"]!, defaultValue: false)
            let viewopts = parseBoolean(data:arguments["viewOptions"]!, defaultValue: false)
            //if viewopts {
                meetingSettings?.meetingTitleHidden = viewopts
                meetingSettings?.meetingPasswordHidden = viewopts
            //}
            
            //Setting up Join Meeting parameter
            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            
            //Setting up Custom Join Meeting parameter
            joinMeetingParameters.userName = arguments["userId"]!
            joinMeetingParameters.meetingNumber = arguments["meetingId"]!

            let hasPassword = (arguments["meetingPassword"]) != nil
            if hasPassword {
                joinMeetingParameters.password = arguments["meetingPassword"]!
            }

            //Joining the meeting and storing the response
//            meetingService?.customizeMeetingTitle(productName)
            let response = meetingService?.joinMeeting(with: joinMeetingParameters)

            if let response = response {
                print("Got response from join: \(response)")
            }
            result(true)
        } else {
            result(false)
        }
        
    }
    
    private func startMeeting(arguments: Dictionary<String, String?>, result: @escaping FlutterResult) {

        MobileRTC.shared().getMeetingSettings()?.meetingInviteUrlHidden = true
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        let startParams = MobileRTCMeetingStartParam4WithoutLoginUser()
        startParams.zak = arguments["zak"]!!
        startParams.meetingNumber =  arguments["meetingId"]!
        startParams.userName = arguments["displayName"] ?? "My Personal Meeting"
        startParams.noVideo = parseBoolean(data: arguments["enableVideo"] ?? "false", defaultValue: false)
        print("1. start params \(startParams)")
        if let meetingService = MobileRTC.shared().getMeetingService() {
            meetingService.delegate = self
            meetingService.customizeMeetingTitle(productName)
//            meetingService.muteMyVideo(false)
            meetingService.startMeeting(with: startParams)
        }
    }
    
//    private func handleAuthResult(callbackUrl: URL?, error: Error?) {
//        guard let callbackUrl = callbackUrl else { return }
//        if (error == nil) {
//            guard let url = URLComponents(string: callbackUrl.absoluteString) else { return }
//            guard let code = url.queryItems?.first(where: { $0.name == "code" })?.value else { return }
//            // self.requestAccessToken(code: code, codeChallengeHelper: self.codeChallengeHelper)
//        }
//    }
    
    public class AuthenticationDelegate: NSObject, MobileRTCAuthDelegate {

        private var result: FlutterResult?

        //Zoom SDK Authentication Listner - On Auth get result
        public func onAuth(_ result: FlutterResult?) -> AuthenticationDelegate {
            self.result = result
            return self
        }

        //Zoom SDK Authentication Listner - On MobileRTCAuth get result
        public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
            switch returnValue {
            case .success:
                print("SDK successfully initialized.")
                self.result?([0, 0])
            case .keyOrSecretEmpty:
                print("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
                self.result?([1, returnValue.rawValue])
            case .keyOrSecretWrong, .unknown:
                print("SDK Key/Secret is not valid.")
                self.result?([1, returnValue.rawValue])
            default:
                print("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
                self.result?([1, returnValue.rawValue])
            }
        }

        //Zoom SDK Authentication Listner - On onMobileRTCLogoutReturn get message
        public func onMobileRTCLogoutReturn(_ returnValue: Int) {

        }
        
        //Zoom SDK Authentication Listner - On getAuthErrorMessage get message
        public func getAuthErrorMessage(_ errorCode: MobileRTCAuthError) -> String {
            print("getAuthErrorMessage \(errorCode)")
            let message = ""
            return message
        }
    }
}

/// meeting service delegate
extension AppDelegate: MobileRTCMeetingServiceDelegate {
    
    @available(iOS 12.0, *)
    func onClickShareScreen(_ parentVC: UIViewController) {
        let broadcastView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.height / 2))
        broadcastView.preferredExtension = "com.sanyuanshi.mobile.meeting.ScreenShare"
        let buttonPressed = NSSelectorFromString("buttonPressed:")
        if broadcastView.responds(to: buttonPressed) {
            broadcastView.perform(buttonPressed, with: nil)
        }
    }
    
//    private func onClickedShareButton(parentVC: UIViewController, addShareActionItem array: inout [MobileRTCMeetingShareActionItem]) -> Bool {
//        print("go here.....")
//        if let meetingService = MobileRTC.shared().getMeetingService() {
//            if meetingService.isDirectAppShareMeeting() {
////                if meetingService.isStartingShare() || meetingService.isViewingShare() {
////                    print("There exist an ongoing share")
////                    return true
////                }
//                
////                meetingService.hideMobileRTCMeeting {
////                    meetingService.startAppShare()
////                }
//                
//                meetingService.hideMobileRTCMeeting {
//                    if !meetingService.isStartingShare() && !meetingService.isViewingShare() {
//                        meetingService.startAppShare()
//                    }
//                }
//                
//                return true
//            }
//        }
//        
//        return false
//    }
    
    public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        switch error {
        case MobileRTCMeetError.passwordError:
            print("MobileRTCMeeting   :   Could not join or start meeting because the meeting password was incorrect.")
        default:
            print("MobileRTCMeeting   :   Could not join or start meeting with MobileRTCMeetError: \(error) \(message ?? "")")
        }
    }
    
    public func onJoinMeetingConfirmed() {
        print("MobileRTCMeeting   :   Join meeting confirmed.")
    }
    
    public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        guard let eventSink = eventSink else { return }
        eventSink(getStateMessage(state))
        
    }
    
    //Get Meeting Status message with proper codes
    private func getStateMessage(_ state: MobileRTCMeetingState?) -> [String] {

        var message: [String]
            switch state {
            case  .idle:
                message = ["MEETING_STATUS_IDLE", "No meeting is running"]
                break
            case .connecting:
                message = ["MEETING_STATUS_CONNECTING", "Connect to the meeting server"]
                break
            case .inMeeting:
                message = ["MEETING_STATUS_INMEETING", "Meeting is ready and in process"]
                break
            case .webinarPromote:
                message = ["MEETING_STATUS_WEBINAR_PROMOTE", "Upgrade the attendees to panelist in webinar"]
                break
            case .webinarDePromote:
                message = ["MEETING_STATUS_WEBINAR_DEPROMOTE", "Demote the attendees from the panelist"]
                break
            case .disconnecting:
                message = ["MEETING_STATUS_DISCONNECTING", "Disconnect the meeting server, leave meeting status"]
                break;
            case .ended:
                message = ["MEETING_STATUS_ENDED", "Meeting ends"]
                break;
            case .failed:
                message = ["MEETING_STATUS_FAILED", "Failed to connect the meeting server"]
                break;
            case .reconnecting:
                message = ["MEETING_STATUS_RECONNECTING", "Reconnecting meeting server status"]
                break;
            case .waitingForHost:
                message = ["MEETING_STATUS_WAITINGFORHOST", "Waiting for the host to start the meeting"]
                break;
            case .joinBO:
                message = ["MEETING_STATUS_JOINBO", "Participant joined BO"]
                break;
            case .leaveBO:
                message = ["MEETING_STATUS_LEAVEBO", "Participant Left BO"]
                break;
            case .inWaitingRoom:
                message = ["MEETING_STATUS_IN_WAITING_ROOM", "Participants who join the meeting before the start are in the waiting room"]
                break;
            case .unlocked:
                message = ["MEETING_STATUS_UNLOCK", "Meeting is unlocked"]
                break;
            case .locked:
                message = ["MEETING_STATUS_LOCK", "Meeting is locked"]
                break;
            default:
                message = ["MEETING_STATUS_UNKNOWN", "'(state?.rawValue ?? 9999)'"]
            }
        return message
        }
}
