package com.demo.gitthub_proj

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.demo.gitthub_proj/auth"

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val data: Uri? = intent.data
        if (data != null && data.scheme == "myapp" && data.host == "callback") {
            val code = data.getQueryParameter("code")
            // Pass the code to Flutter
            val messenger = flutterEngine?.dartExecutor?.binaryMessenger
            if (messenger != null) {
                MethodChannel(messenger, CHANNEL).invokeMethod("onAuthCodeReceived", code)
            } else {
                println("Flutter Engine or Binary Messenger is null")
            }
        }
    }
}
