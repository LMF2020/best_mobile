package com.spark_rxeagle;

import android.content.Context;

public class FlutterContextPlugin {
    private static Context sContext;

    public static void setContext(Context context) {
        sContext = context;
    }

    public static Context getContext() {
        return sContext;
    }
}