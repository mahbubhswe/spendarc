package com.example.spendarc

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applySystemBarStyle()
    }

    override fun onResume() {
        super.onResume()
        applySystemBarStyle()
    }

    private fun applySystemBarStyle() {
        WindowCompat.setDecorFitsSystemWindows(window, true)
        window.navigationBarColor = Color.WHITE
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            window.isNavigationBarContrastEnforced = false
        }
        WindowCompat.getInsetsController(window, window.decorView)?.isAppearanceLightNavigationBars =
            true
    }
}
