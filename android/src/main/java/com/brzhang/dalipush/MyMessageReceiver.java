package com.brzhang.dalipush;

import android.content.Context;
import android.util.Log;

import com.alibaba.sdk.android.push.MessageReceiver;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

public class MyMessageReceiver extends MessageReceiver {
    // 消息接收部分的LOG_TAG
    public static final String REC_TAG = "receiver";

    @Override
    public void onNotification(Context context, String title, String summary, Map<String, String> extraMap) {
        // TODO 处理推送通知
        Log.e("DalipushPlugin", "Receive notification, title: " + title + ", summary: " + summary + ", extraMap: " + extraMap);
        Gson gson = new Gson();
        DalipushPlugin.getInstance().getEventSink().success(gson.toJson(new Notification("onNotification", title, summary, extraMap), Notification.class));
    }

    @Override
    public void onMessage(Context context, CPushMessage cPushMessage) {
        Log.e("DalipushPlugin", "onMessage, messageId: " + cPushMessage.getMessageId() + ", title: " + cPushMessage.getTitle() + ", content:" + cPushMessage.getContent());
        Gson gson = new Gson();
        Log.e("DalipushPlugin", "eventSink: " + DalipushPlugin.getInstance().getEventSink());
        Map<String, String> map = new HashMap<>();
        map.put("messageId", cPushMessage.getMessageId());
        Notification message = new Notification("onMessage", cPushMessage.getTitle(), cPushMessage.getContent(), map);
        DalipushPlugin.getInstance().getEventSink().success(gson.toJson(message, Notification.class));
    }

    @Override
    public void onNotificationOpened(Context context, String title, String summary, String extraMap) {
        Log.e("DalipushPlugin", "onNotificationOpened, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
        Map<String, String> map = new HashMap<>();
        map.put("extraMap", extraMap);
        Gson gson = new Gson();
        DalipushPlugin.getInstance().getEventSink().success(gson.toJson(new Notification("onNotificationOpened", title, summary, map), Notification.class));
    }

    @Override
    protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
        Log.e("DalipushPlugin", "onNotificationClickedWithNoAction, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
        Map<String, String> map = new HashMap<>();
        map.put("extraMap", extraMap);
        Gson gson = new Gson();
        DalipushPlugin.getInstance().getEventSink().success(gson.toJson(new Notification("onNotificationClickedWithNoAction", title, summary, map), Notification.class));
    }

    @Override
    protected void onNotificationReceivedInApp(Context context, String title, String summary, Map<String, String> extraMap, int openType, String openActivity, String openUrl) {
        Log.e("DalipushPlugin", "onNotificationReceivedInApp, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap + ", openType:" + openType + ", openActivity:" + openActivity + ", openUrl:" + openUrl);
        Map<String, String> map = new HashMap<>();
        map.putAll(extraMap);
        map.put("openType", String.valueOf(openType));
        map.put("openUrl", openUrl);
        Gson gson = new Gson();
        DalipushPlugin.getInstance().getEventSink().success(gson.toJson(new Notification("onNotificationReceivedInApp", title, summary, map), Notification.class));
    }

    @Override
    protected void onNotificationRemoved(Context context, String messageId) {
        Log.e("DalipushPlugin", "onNotificationRemoved");
        Map<String, String> map = new HashMap<>();
        map.put("messageId", messageId);
        Gson gson = new Gson();
        DalipushPlugin.getInstance().getEventSink().success(gson.toJson(new Notification("onNotificationRemoved", "", "", map), Notification.class));
    }
}