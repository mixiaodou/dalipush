package com.brzhang.dalipush;

import java.util.Map;

public  class Notification {
    String event;
    String title;
    String summary;
    Map<String, String> extraMap;

    public Notification(String event, String title, String summary, Map<String, String> extraMap) {
        this.event = event;
        this.title = title;
        this.summary = summary;
        this.extraMap = extraMap;
    }
}