package com.spark_android;

import static com.spark_android.startjoinmeeting.ApiUserStartMeetingHelper.DISPLAY_NAME;

import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.google.common.base.Strings;
import com.spark_android.startjoinmeeting.ApiUserStartMeetingHelper;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import us.zoom.sdk.CustomizedNotificationData;
import us.zoom.sdk.InMeetingNotificationHandle;
import us.zoom.sdk.InMeetingService;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.MeetingViewsOptions;
import us.zoom.sdk.SDKNotificationServiceError;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.StartMeetingParams4NormalUser;
import us.zoom.sdk.StartMeetingParamsWithoutLogin;
import us.zoom.sdk.ZoomApiError;
import us.zoom.sdk.ZoomAuthenticationError;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomSDKAuthenticationListener;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;
import us.zoom.sdk.ZoomSDKRawDataMemoryMode;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.meetspark/spark_sdk";
    private static final String EVENT_CHANNEL = "com.meetspark/spark_sdk_event_stream";
    private EventChannel meetingStatusChannel = null;
    private MethodChannel.Result pendingResult;
    private InMeetingService inMeetingService;

    private final static String TAG = "[SparkAndroid]";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        FlutterContextPlugin.setContext(this);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "init":
                    init(call, result);
                    break;
                case "login":
                    login(call, result);
                    break;
                case "startInstantMeeting":
                    startInstantMeeting(call, result);
                    break;
                case "startMeetingWithNumber":
                    startMeetingWithNumber(call, result);
                    break;
                case "joinMeeting":
                    joinMeeting(call, result);
                    break;
                case "meeting_status":
                    meetingStatus(result);
                    break;
                case "meeting_details":
                    meetingDetails(result);
                    break;
                case "isSdkInit":
                    isSdkInit(result);
                    break;
                case "logout":
                    logout(result);
                    break;
                default:
                    result.notImplemented();
            }
        });

        meetingStatusChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL);
    }

    private void sendReply(List data) {
        if (this.pendingResult == null) {
            return;
        }
        this.pendingResult.success(data);
        this.clearPendingResult();
    }

    private void clearPendingResult() {
        this.pendingResult = null;
    }

    private void init(MethodCall call, MethodChannel.Result result) {
        Map<String, String> options = call.arguments();
        ZoomSDK zoomSDK = ZoomSDK.getInstance();
        if (zoomSDK.isInitialized()) {
            List<Integer> response = Arrays.asList(ZoomError.ZOOM_ERROR_SUCCESS, 0);
            result.success(response);
            return;
        }

        ZoomSDKInitParams initParams = new ZoomSDKInitParams();
        assert options != null;
        initParams.jwtToken = options.get("jwtToken");
        initParams.domain = "https://" + options.get("domain");
        initParams.enableLog = true;
        initParams.enableGenerateDump =true;
        initParams.logSize = 5;
        initParams.videoRawDataMemoryMode = ZoomSDKRawDataMemoryMode.ZoomSDKRawDataMemoryModeStack;

        // 收到会议通知回调，打开新页面
        final InMeetingNotificationHandle handle = (context, intent) -> {
            intent = new Intent(context, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            if (context == null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            }
            intent.setAction(InMeetingNotificationHandle.ACTION_RETURN_TO_CONF);
            assert context != null;
            context.startActivity(intent);
            return true;
        };

        // 设置一些自定义的通知
        final CustomizedNotificationData data = new CustomizedNotificationData();
        data.setContentTitleId(R.string.app_name_spark_local);
//        data.setLargeIconId(R.drawable.zm_mm_type_emoji);
//        data.setSmallIconId(R.drawable.zm_mm_type_emoji);
//        data.setSmallIconForLorLaterId(R.drawable.zm_mm_type_emoji);
        ZoomSDKInitializeListener listener = new ZoomSDKInitializeListener() {
            /**
             * @param errorCode {@link us.zoom.sdk.ZoomError#ZOOM_ERROR_SUCCESS} if the SDK has been initialized successfully.
             */
            @Override
            public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
                List<Integer> response = Arrays.asList(errorCode, internalErrorCode);

                if (errorCode != ZoomError.ZOOM_ERROR_SUCCESS) {
                    Log.e(TAG, "[initSDK], ret = " + errorCode);
                    result.success(response);
                    return;
                }

                ZoomSDK zoomSDK = ZoomSDK.getInstance();
                ZoomSDK.getInstance().getMeetingSettingsHelper().enableShowMyMeetingElapseTime(true);
                ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedNotificationData(data, handle);

                MeetingService meetingService = zoomSDK.getMeetingService();
                meetingStatusChannel.setStreamHandler(new StatusStreamHandler(meetingService));

                if (zoomSDK.tryAutoLoginZoom() == ZoomApiError.ZOOM_API_ERROR_SUCCESS) {
                    // 初始化成功，尝试自动登录
                    result.success(Arrays.asList(ZoomLoginConstants.AUTO_LOGIN_SUCCESS, 0));
                    Log.i(TAG, "[initSDK], ret = autoLogin success");
                } else {
                    // 初始化成功，但自动登录失败
                    result.success(response);
                    Log.i(TAG, "[initSDK] success");
                }

                // custom resource
            }

            @Override
            public void onZoomAuthIdentityExpired() {
            }
        };

        zoomSDK.initialize(FlutterContextPlugin.getContext(), listener, initParams);
    }

    private void login(MethodCall call, MethodChannel.Result result) {
        this.pendingResult = result;
        Map<String, String> options = call.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            System.out.println("[Login] error init failed");
            result.success(Arrays.asList("SDK_ERROR", "-1"));
            Toast.makeText(FlutterContextPlugin.getContext(), "App init failed", Toast.LENGTH_LONG).show();
            return;
        }

        ZoomSDKAuthenticationListener authenticationListener = new ZoomSDKAuthenticationListener() {
            @Override
            public void onZoomSDKLoginResult(long results) {
                if (results != ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS) {
                    System.out.println("[Login] error " + results);
                    sendReply(Arrays.asList("LOGIN_ERROR", String.valueOf(results)));
                    return;
                }
                Log.i(TAG, "[login] success");
                System.out.println("[Login] success");
                String userEmail = zoomSDK.getAccountService().getAccountEmail(); // 获取email
                sendReply(Arrays.asList("LOGIN_SUCCESS", userEmail));
            }

            @Override
            public void onZoomSDKLogoutResult(long l) {
                Log.i(TAG, "[logout], ret = " + l);
            }

            @Override
            public void onZoomIdentityExpired() {
                Log.i(TAG, "[login], ret = onZoomIdentityExpired");
            }

            @Override
            public void onZoomAuthIdentityExpired() {
                Log.i(TAG, "[login], ret = AuthIdentityExpired");
            }

            @Override
            public void onNotificationServiceStatus(SDKNotificationServiceStatus sdkNotificationServiceStatus) {

            }

            @Override
            public void onNotificationServiceStatus(SDKNotificationServiceStatus sdkNotificationServiceStatus, SDKNotificationServiceError sdkNotificationServiceError) {

            }
        };

        if (!zoomSDK.isLoggedIn()) {
            System.out.println("[Login] start Login ....");
//            zoomSDK.loginWithZoom(options.get("userId"), options.get("userPassword"));
//            String schemeUrl = "bestmtg://best-meeting.com/saml/login?cmd=&from=mobile&zm-cid=Ar%2F1cNPcvwD4EUCJHe5LZQu7Ku6QFEc3cQFhiFT5cSc%3D&code_challenge=0gttWB1rSPCm9ZwNY7TEhb73U%2ByOq20BjequgRlGy%2Bw%3D";
//            String schemeUrl = "bestmtg://best-meeting.com/sim?wd=dcdcdcdcdc";
                String schemeURL = "bestmtg://best-meeting.com/sso?token=NuVJH7nCfNoyuNJi1UuoTM-qXr6hR-YktHHdOGJ6AYPJ3UPTjHMWt9olHUy6hucCMSvVZ4YXPOYIieJlyBV1DyPbznS-O8waQqf-2OKBM9OuK53ZmycgvZOJkd4zy_3EpoZv_KuVFFZDQfM-QnTcIIWxZFwxkRiowX9iQeJmXNnsf48RSs3Il5rYVoDfuUCujh3gH1oPbR8v-o2G-L4u054vMIN6lkjIkbucp-_9PDBGQexJcAzP4ILVRnhDk_FKyx8FMMxiESGGuA25Bo8_3UXQnriOih0Ja9hvIpUJHS2RDTs0RJyoGFRt3TVCqHYsme6-pR5910j4jfW52l3u7mt4qjXa7Y9XB2572Q5E4sG5O4V2alUEVIruqhtPGyht.-bz8-E67KfSd0dOn&code_challenge=Uj8wUXifz4KCVgk2on55sLQSEhKu88UNki1kXRY063E=";
//            String ssoUrl = ZoomSDK.getInstance().generateSSOLoginURL("sso");
//            System.out.println(ssoUrl);
            boolean isLoginSuccess = zoomSDK.handleSSOLoginURIProtocol(schemeURL);
            Log.i(TAG, "[login] status" + isLoginSuccess);
            System.out.println("[Login] status" + isLoginSuccess);
            zoomSDK.addAuthenticationListener(authenticationListener);
        }
    }

    /// API user start instant meeting
    private void startInstantMeeting(MethodCall methodCall, MethodChannel.Result result) {
        this.pendingResult = result;
        Map<String, String> startInstantOptions = methodCall.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            Log.e(TAG, "[startInstantMeeting], ret = sdkInitFail");
            sendReply(Arrays.asList("SDK_ERROR", "-1"));
            return;
        }
//        if (!zoomSDK.isLoggedIn()) {
//            Log.e(TAG, "[startInstantMeeting], ret = loginFail");
//            sendReply(Arrays.asList("LOGIN_ERROR", "-1"));
//            return;
//        }
        inMeetingService = zoomSDK.getInMeetingService();
        // 新方法
//        int ret = LoginUserStartMeetingHelper.getInstance().startInstanceMeeting(methodCall);

        StartMeetingOptions opts = new StartMeetingOptions();
        opts.no_video = !parseBoolean(startInstantOptions, "enableVideo");
        opts.no_disconnect_audio = parseBoolean(startInstantOptions, "noDisconnectAudio");
        opts.no_audio = parseBoolean(startInstantOptions, "noAudio");
        boolean view_options = parseBoolean(startInstantOptions, "viewOptions");
        if (view_options) {
            opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
        }
        StartMeetingParamsWithoutLogin params = new StartMeetingParamsWithoutLogin();

        params.displayName = startInstantOptions.get("displayName");
        params.userType = MeetingService.USER_TYPE_ZOOM;
        params.zoomAccessToken = startInstantOptions.get("zak");;
        params.meetingNo = startInstantOptions.get("meetingId");

        if(Strings.isNullOrEmpty(params.displayName)) {
            params.displayName = DISPLAY_NAME;
        }

        int ret = ApiUserStartMeetingHelper.getInstance().startMeetingWithNumber(params, opts);

        Log.i(TAG, "[startInstanceMeeting], ret = " + ret);
        sendReply(Arrays.asList("START_MEETING_SUCCESS", String.valueOf(ret)));
    }

    // Meeting ID passed Start Meeting Function called on startMeetingNormal triggered via startMeetingNormal function
    private void startMeetingWithNumber(MethodCall methodCall, MethodChannel.Result result) {
        this.pendingResult = result;
        Map<String, String> startOptions = methodCall.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            sendReply(Arrays.asList("SDK_ERROR", "-1"));
            return;
        }

//        if (zoomSDK.isLoggedIn()) {
//            MeetingService meetingService = zoomSDK.getMeetingService();
        StartMeetingOptions opts = new StartMeetingOptions();
        opts.no_invite = parseBoolean(startOptions, "disableInvite");
        opts.no_share = parseBoolean(startOptions, "disableShare");
        opts.no_driving_mode = parseBoolean(startOptions, "disableDrive");
        opts.no_dial_in_via_phone = parseBoolean(startOptions, "disableDialIn");
        opts.no_disconnect_audio = parseBoolean(startOptions, "noDisconnectAudio");
        opts.no_audio = parseBoolean(startOptions, "noAudio");
        opts.no_titlebar = parseBoolean(startOptions, "disableTitlebar");
        boolean view_options = parseBoolean(startOptions, "viewOptions");
        if (view_options) {
            opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
        }

        StartMeetingParamsWithoutLogin params = new StartMeetingParamsWithoutLogin();
        params.zoomAccessToken = startOptions.get("zak");
        params.meetingNo = startOptions.get("meetingId");
        params.userType = MeetingService.USER_TYPE_ZOOM; // SNS_MOBILE_DEVICE

        int ret = ApiUserStartMeetingHelper.getInstance().startMeetingWithNumber(params, opts);
        inMeetingService = zoomSDK.getInMeetingService();
        sendReply(Arrays.asList("MEETING_SUCCESS", String.valueOf(ret)));

//        }
    }

    public void isSdkInit(MethodChannel.Result result) {
        ZoomSDK zoomSDK = ZoomSDK.getInstance();
        result.success(zoomSDK.isInitialized());
    }

    public void logout(MethodChannel.Result result) {
        ZoomSDK zoomSDK = ZoomSDK.getInstance();
        if (!zoomSDK.isInitialized()) {
            sendReply(Arrays.asList("SDK_ERROR", "-1"));
            return;
        }
        boolean success = zoomSDK.logoutZoom();
        System.out.println("android :: logout success " + success);
        result.success(success);
    }

    //Join Meeting with passed Meeting ID and Passcode
    private void joinMeeting(MethodCall methodCall, MethodChannel.Result result) {
        this.pendingResult = result;
        Map<String, String> joinOptions = methodCall.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            sendReply(Arrays.asList("SDK_ERROR", "-1"));
            return;
        }

        MeetingService meetingService = zoomSDK.getMeetingService();

        JoinMeetingOptions opts = new JoinMeetingOptions();
        opts.no_invite = parseBoolean(joinOptions, "disableInvite");
        opts.no_share = parseBoolean(joinOptions, "disableShare");
        opts.no_titlebar = parseBoolean(joinOptions, "disableTitlebar");
        opts.no_driving_mode = parseBoolean(joinOptions, "disableDrive");
        opts.no_dial_in_via_phone = parseBoolean(joinOptions, "disableDialIn");
        opts.no_disconnect_audio = parseBoolean(joinOptions, "noDisconnectAudio");
        opts.no_audio = parseBoolean(joinOptions, "noAudio");
        opts.no_video = !parseBoolean(joinOptions, "enableVideo");
        boolean view_options = parseBoolean(joinOptions, "viewOptions");
        if (view_options) {
            opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
        }

        JoinMeetingParams params = new JoinMeetingParams();

        params.displayName = joinOptions.get("userId");
        params.meetingNo = joinOptions.get("meetingId");
        params.password = joinOptions.get("meetingPassword");

        meetingService.joinMeetingWithParams(FlutterContextPlugin.getContext(), params, opts);
        inMeetingService = zoomSDK.getInMeetingService();
        result.success(true);
    }

    //Listen to meeting status on joinning and starting the mmeting
    private void meetingStatus(MethodChannel.Result result) {

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "SDK not initialized"));
            return;
        }
        MeetingService meetingService = zoomSDK.getMeetingService();

        if (meetingService == null) {
            result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
            return;
        }

        MeetingStatus status = meetingService.getMeetingStatus();
        result.success(status != null ? Arrays.asList(status.name(), "") : Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
    }

    //Get Meeting Details Programmatically after Starting the Meeting
    private void meetingDetails(MethodChannel.Result result) {
        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if (!zoomSDK.isInitialized()) {
            result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "SDK not initialized"));
            return;
        }
        MeetingService meetingService = zoomSDK.getMeetingService();

        if (meetingService == null) {
            result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
            return;
        }
        MeetingStatus status = meetingService.getMeetingStatus();

        result.success(status != null ? Arrays.asList(inMeetingService.getCurrentMeetingNumber(), inMeetingService.getMeetingPassword()) : Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
    }

    //Helper Function for parsing string to boolean value
    private boolean parseBoolean(Map<String, String> options, String property) {
        return options.get(property) != null && Boolean.parseBoolean(options.get(property));
    }
}
