package com.example.my_app

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "scalemonk.com/ads"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when(call.method){
                "initializeSMAds" -> { Log.d("MainActivity","initialize called")} // here we will initialize SMAds
                "showInterstitial" -> { Log.d("MainActivity","show interstitial called") }// here we will show an interstitial
                "showRewarded" -> { Log.d("MainActivity","show rewarded called")}// here we will show a rewarded video
            }
        }
    }
}
