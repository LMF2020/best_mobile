package com.spark_rxeagle.startjoinmeeting;

import com.spark_rxeagle.FlutterContextPlugin;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingViewsOptions;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.StartMeetingParams4NormalUser;
import us.zoom.sdk.ZoomSDK;

public class LoginUserStartMeetingHelper {
    private final static String TAG = "LoginUserStartMeetingHelper";

    private static LoginUserStartMeetingHelper mEmailLoginUserStartMeetingHelper;

    private final ZoomSDK mZoomSDK;

    private LoginUserStartMeetingHelper() {
        mZoomSDK = ZoomSDK.getInstance();
    }

    public synchronized static LoginUserStartMeetingHelper getInstance() {
        mEmailLoginUserStartMeetingHelper = new LoginUserStartMeetingHelper();
        return mEmailLoginUserStartMeetingHelper;
    }

    public int startInstanceMeeting(MethodCall methodCall) {
        int ret = -1;
        MeetingService meetingService = mZoomSDK.getMeetingService();
        if (meetingService == null) {
            return ret;
        }
        Map<String, String> options = methodCall.arguments();
        // 获取 pmi
        String pmi = options.get("pmi");

        StartMeetingOptions opts = new StartMeetingOptions();
        opts.no_audio = false;
        opts.no_video = !parseBoolean(options, "enableVideo");

        opts.no_invite = parseBoolean(options, "disableInvite");
        opts.no_share = parseBoolean(options, "disableShare");
        opts.no_driving_mode = parseBoolean(options, "disableDrive");
        opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn");
        opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio");
        opts.no_audio = parseBoolean(options, "noAudio");
        opts.no_titlebar = parseBoolean(options, "disableTitlebar");
        boolean view_options = parseBoolean(options, "viewOptions");
        if (view_options) {
            opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
        }
        System.out.println("--- enableVideo --- " + opts.no_video);

        // 开启PMI会议
        if (pmi != null && pmi.length() > 0) {
            StartMeetingParams4NormalUser params = new StartMeetingParams4NormalUser();
            params.meetingNo = pmi;
            return meetingService.startMeetingWithParams(FlutterContextPlugin.getContext(), params, opts);
        }
        // 开启即时会议
        return meetingService.startInstantMeeting(FlutterContextPlugin.getContext(), opts);
    }

    private boolean parseBoolean(Map<String, String> options, String property) {
        return options.get(property) != null && Boolean.parseBoolean(options.get(property));
    }
}
