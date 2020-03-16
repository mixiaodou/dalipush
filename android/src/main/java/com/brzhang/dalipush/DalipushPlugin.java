package com.brzhang.dalipush;

import android.app.Notification;
import android.content.Context;
import android.os.Build;
import android.util.Log;

import com.alibaba.sdk.android.push.MessageReceiver;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import android.graphics.BitmapFactory;

import com.google.gson.Gson;

import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * DalipushPlugin
 */
public class DalipushPlugin implements MethodCallHandler, EventChannel.StreamHandler {

    private static DalipushPlugin dalipushPlugin;

    private EventChannel.EventSink eventSink;

    public static DalipushPlugin getInstance() {
        return dalipushPlugin;
    }

    public EventChannel.EventSink getEventSink() {
        return this.eventSink;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        Log.e("DalipushPlugin", "registerWith() called with: registrar = [" + registrar + "]");
        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "dalipush");
        final EventChannel eventChannel = new EventChannel(registrar.messenger(), "dalipush_event");
        Log.e("DalipushPlugin", "eventChannel called with: registrar = [" + eventChannel + "]");
        dalipushPlugin = new DalipushPlugin();
        methodChannel.setMethodCallHandler(dalipushPlugin);
        eventChannel.setStreamHandler(dalipushPlugin);

    }

    private void addAlias(final Result result, String alias) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.addAlias(alias, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });
    }

    private void removeAlias(final Result result, String alias) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.removeAlias(alias, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });

    }

    private void bindAccount(final Result result, String account) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.bindAccount(account, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });

    }

    private void bindPhoneNumber(final Result result, String phoneNumber) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.bindPhoneNumber(phoneNumber, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });

    }

    private void bindTag(final Result result, int target, String[] tags, String alias) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.bindTag(target, tags, alias, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });

    }

    private void unbindAccount(final Result result) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.unbindAccount(new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });
    }

    private void checkPushChannelStatus(final Result result) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.checkPushChannelStatus(new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });

    }

    private void turnOffPushChannel(final Result result) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.turnOffPushChannel(new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });
    }

    private void turnOnPushChannel(final Result result) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.turnOnPushChannel(new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });
    }

    private void unbindPhoneNumber(final Result result) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();

        pushService.unbindPhoneNumber(new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });
    }


    private void unbindTag(final Result result, int target, String[] tags, String alias) {
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();
        pushService.unbindTag(target, tags, alias, new CommonCallback() {
            @Override
            public void onSuccess(String s) {
                result.success(s);
            }

            @Override
            public void onFailed(String s, String s1) {
                result.error(s, s1, null);
            }
        });
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE + "packageName" + BuildConfig.APPLICATION_ID);
        } else if (call.method.equals("getDeviceId")) {
            final CloudPushService pushService = PushServiceFactory.getCloudPushService();

            result.success(pushService.getDeviceId());
        }  else if (call.method.equals("getDeviceToken")) {
            // Android 下没有deviceToken
            result.success(null);
        } else if (call.method.equals("clearNotifications")) {
            final CloudPushService pushService = PushServiceFactory.getCloudPushService();
            pushService.clearNotifications();
            // Android 下没有deviceToken
            result.success(true);
        } else if (call.method.equals("closeDoNotDisturbMode")) {
            final CloudPushService pushService = PushServiceFactory.getCloudPushService();
            pushService.closeDoNotDisturbMode();
            // Android 下没有deviceToken
            result.success(true);
        } else if (call.method.equals("addAlias")) {
            String alias = call.argument("alias");
            addAlias(result, alias);
        } else if (call.method.equals("removeAlias")) {
            String alias = call.argument("alias");
            removeAlias(result, alias);
        } else if (call.method.equals("bindAccount")) {
            String account = call.argument("account");
            bindAccount(result, account);
        } else if (call.method.equals("unbindAccount")) {
            unbindAccount(result);
        } else if (call.method.equals("bindPhoneNumber")) {
            String phoneNumber = call.argument("phoneNumber");
            bindPhoneNumber(result, phoneNumber);
        } else if (call.method.equals("bindTag")) {
            int target = call.argument("target");
            String[] tags = call.argument("tags");
            String alias = call.argument("alias");
            bindTag(result, target, tags, alias);
        } else if (call.method.equals("unbindTag")) {
            int target = call.argument("target");
            String[] tags = call.argument("tags");
            String alias = call.argument("alias");
            unbindTag(result, target, tags, alias);
        } else if (call.method.equals("checkPushChannelStatus")) {
            checkPushChannelStatus(result);
        } else if (call.method.equals("unbindPhoneNumber")) {
            unbindPhoneNumber(result);
        } else if (call.method.equals("turnOffPushChannel")) {
            turnOffPushChannel(result);
        } else if (call.method.equals("turnOnPushChannel")) {
            turnOnPushChannel(result);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        Log.e("DalipushPlugin", "onListen() called with: o = [" + o + "], eventSink = [" + eventSink + "]");
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {

    }


}
