package com.ivis.duary

import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Native Splash Screen 의 종료 애니메이션 제거 -> Flutter Splash Screen 으로 자연스럽게 overwrite
        val splashScreen = installSplashScreen();
        splashScreen.setOnExitAnimationListener{ splashScreen ->
            splashScreen.remove();
        }
        super.onCreate(savedInstanceState)
    }
}
