package com.spark_rxeagle.startjoinmeeting;

import android.content.Context;
import android.util.Log;

import com.spark_rxeagle.FlutterContextPlugin;

import java.util.Map;

import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParam4WithoutLogin;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.StartMeetingParamsWithoutLogin;
import us.zoom.sdk.ZoomSDK;

public class ApiUserStartMeetingHelper {
    private final static String TAG = "ApiUserStart";

    private static ApiUserStartMeetingHelper mApiUserStartMeetingHelper;

    private ZoomSDK mZoomSDK;

    public final static String DISPLAY_NAME = "我的个人会议";

    private ApiUserStartMeetingHelper() {
        mZoomSDK = ZoomSDK.getInstance();
    }

    public synchronized static ApiUserStartMeetingHelper getInstance() {
        mApiUserStartMeetingHelper = new ApiUserStartMeetingHelper();
        return mApiUserStartMeetingHelper;
    }

    /**
     * Start meeting via meeting number
     */
    public int startMeetingWithNumber(StartMeetingParamsWithoutLogin params, StartMeetingOptions startMeetingOptions) {
        int ret = -1;
        MeetingService meetingService = mZoomSDK.getMeetingService();
        if(meetingService == null) {
            return ret;
        }
        StartMeetingOptions opts = ZoomMeetingUISettingHelper.getStartMeetingOptions(startMeetingOptions);
        ///// 这是bug吗???
        opts.no_disconnect_audio = true;
        opts.no_audio = false;
        opts.no_video = false;
        ret = meetingService.startMeetingWithParams(FlutterContextPlugin.getContext(), params, opts);
        Log.i(TAG, "startMeetingWithNumber, ret=" + ret);
        return ret;
    }

    /**
     * Start meeting via meeting vanity id
     * @param context Android context
     */
//    public int startMeetingWithVanityId(Context context, String vanityId,String zak) {
//        int ret = -1;
//        MeetingService meetingService = mZoomSDK.getMeetingService();
//        if(meetingService == null) {
//            return ret;
//        }
//
//        StartMeetingOptions opts = ZoomMeetingUISettingHelper.getStartMeetingOptions();
//
//        StartMeetingParamsWithoutLogin params = new StartMeetingParamsWithoutLogin();
//        params.userType = MeetingService.USER_TYPE_API_USER;
//        params.displayName = DISPLAY_NAME;
//        params.zoomAccessToken = zak;
//        params.vanityID = vanityId;
//        ret = meetingService.startMeetingWithParams(context, params, opts);
//        Log.i(TAG, "startMeetingWithVanityId, ret=" + ret);
//        return ret;
//    }

    public int joinMeetingWithNumber(Context context, String meetingNo, String meetingPassword,String zak) {
        int ret = -1;
        MeetingService meetingService = mZoomSDK.getMeetingService();
        if (meetingService == null) {
            return ret;
        }

        JoinMeetingOptions opts = ZoomMeetingUISettingHelper.getJoinMeetingOptions();

        JoinMeetingParam4WithoutLogin params = new JoinMeetingParam4WithoutLogin();

        params.displayName = DISPLAY_NAME;
        params.meetingNo = meetingNo;
        params.password = meetingPassword;
        params.zoomAccessToken =zak;



        return meetingService.joinMeetingWithParams(context, params, opts);
    }

    public int joinMeetingWithVanityId(Context context, String vanityId, String meetingPassword,String zak) {
        int ret = -1;
        MeetingService meetingService = mZoomSDK.getMeetingService();
        if (meetingService == null) {
            return ret;
        }

        JoinMeetingOptions opts = ZoomMeetingUISettingHelper.getJoinMeetingOptions();
        JoinMeetingParam4WithoutLogin params = new JoinMeetingParam4WithoutLogin();
        params.displayName = DISPLAY_NAME;
        params.vanityID = vanityId;
        params.password = meetingPassword;

        params.zoomAccessToken = zak;
        return meetingService.joinMeetingWithParams(context, params, opts);
    }

    private boolean parseBoolean(Map<String, String> options, String property) {
        return options.get(property) != null && Boolean.parseBoolean(options.get(property));
    }
}
