package com.brzhang.dalipush;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import com.alibaba.sdk.android.push.AndroidPopupActivity;

import java.util.Map;

public class PopupPushActivity extends AndroidPopupActivity {
    static final String TAG = "DalipushPlugin";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    /**
     * 实现通知打开回调方法，获取通知相关信息
     * @param title     标题
     * @param summary   内容
     * @param extMap    额外参数
     */
    @Override
    protected void onSysNoticeOpened(String title, String summary, Map<String, String> extMap) {
        Log.d(TAG,"Oitle: " + title + ", content: " + summary + ", extMap: " + extMap);
        PackageManager pm = this.getPackageManager();
        Intent intent = pm.getLaunchIntentForPackage(getApplicationContext().getPackageName());
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_TASK_ON_HOME);
        intent.setAction(Intent.ACTION_VIEW);
        String uri = extMap.get("uri");
        if (uri != null && !uri.isEmpty()) {
            Uri data = Uri.parse(uri);
            Log.d(TAG,"uri: " + uri + " schema:" + data.getScheme());
            intent.setData(data);
        }
        startActivity(intent);
        this.finish();
    }
}