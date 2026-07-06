package com.example.autoway

import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // MapKit needs the key before the yandex_mapkit plugin registers.
        MapKitFactory.setApiKey("c1b6e4ac-a901-44d2-a433-1d2ad97c8de8")
        super.configureFlutterEngine(flutterEngine)
    }
}
