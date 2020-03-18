package com.brzhang.dalipush;

import android.content.Context;
import android.util.Log;

import com.alibaba.sdk.android.push.MessageReceiver;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

public class MyMessageReceiver extends MessageReceiver {
    // 消息接收部分的LOG_TAG
    public static final String REC_TAG = "receiver";

    @Override
    public void onNotification(Context context, String title, String summary, Map<String, String> extraMap) {
        // TODO 处理推送通知
        Log.i("DalipushPlugin", "Receive notification, title: " + title + ", summary: " + summary + ", extraMap: " + extraMap);
        Map hashMap = new HashMap();
        hashMap.put("title", title);
        hashMap.put("summary", summary);
        hashMap.put("event", "onNotification");
        hashMap.put("extraMap", extraMap);
        DalipushPlugin.getInstance().getEventSink().success(hashMap);
    }

    @Override
    public void onMessage(Context context, CPushMessage cPushMessage) {
        Log.i("DalipushPlugin", "onMessage, messageId: " + cPushMessage.getMessageId() + ", title: " + cPushMessage.getTitle() + ", content:" + cPushMessage.getContent());
        Gson gson = new Gson();
        Log.i("DalipushPlugin", "eventSink: " + DalipushPlugin.getInstance().getEventSink());
        Map<String, String> map = new HashMap<>();
        map.put("messageId", cPushMessage.getMessageId());
        Map hashMap = new HashMap();
        hashMap.put("title", cPushMessage.getTitle());
        hashMap.put("summary", cPushMessage.getContent());
        hashMap.put("event", "onMessage");
        hashMap.put("extraMap", map);
        DalipushPlugin.getInstance().getEventSink().success(hashMap);
    }

    @Override
    public void onNotificationOpened(Context context, String title, String summary, String extraMap) {
        Log.i("DalipushPlugin", "onNotificationOpened, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
        Gson gson = new Gson();
        Type extraMapType = new TypeToken<Map<String, String>>() {}.getType();
        Map<String, String> map = gson.fromJson(extraMap, extraMapType);
        Map hashMap = new HashMap();
        hashMap.put("title", title);
        hashMap.put("summary", summary);
        hashMap.put("event", "onNotificationOpened");
        hashMap.put("extraMap", map);
        DalipushPlugin.getInstance().getEventSink().success(hashMap);
    }

    @Override
    protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
        Log.i("DalipushPlugin", "onNotificationClickedWithNoAction, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
        Gson gson = new Gson();
        Type extraMapType = new TypeToken<Map<String, String>>() {}.getType();
        Map<String, String> map = gson.fromJson(extraMap, extraMapType);
        Map hashMap = new HashMap();
        hashMap.put("title", title);
        hashMap.put("summary", summary);
        hashMap.put("event", "onNotificationOpened");
        hashMap.put("extraMap", map);
        DalipushPlugin.getInstance().getEventSink().success(hashMap);
    }

    @Override
    protected void onNotificationReceivedInApp(Context context, String title, String summary, Map<String, String> extraMap, int openType, String openActivity, String openUrl) {
        Log.i("DalipushPlugin", "onNotificationReceivedInApp, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap + ", openType:" + openType + ", openActivity:" + openActivity + ", openUrl:" + openUrl);
        Map<String, String> map = new HashMap<>();
        map.putAll(extraMap);
        map.put("openType", String.valueOf(openType));
        map.put("openUrl", openUrl);
        Gson gson = new Gson();
        Map hashMap = new HashMap();
        hashMap.put("title", title);
        hashMap.put("summary", summary);
        hashMap.put("event", "onNotificationOpened");
        hashMap.put("extraMap", map);
        DalipushPlugin.getInstance().getEventSink().success(hashMap);
    }

    @Override
    protected void onNotificationRemoved(Context context, String messageId) {
        Log.i("DalipushPlugin", "onNotificationRemoved");
        Map<String, String> map = new HashMap<>();
        map.put("messageId", messageId);
        Gson gson = new Gson();
        Map hashMap = new HashMap();
        hashMap.put("title", "");
        hashMap.put("summary", "");
        hashMap.put("event", "onNotificationOpened");
        hashMap.put("extraMap", map);
        DalipushPlugin.getInstance().getEventSink().success(hashMap);
    }
}