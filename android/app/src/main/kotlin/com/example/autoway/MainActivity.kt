package com.example.autoway

import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // MapKit needs the key before the yandex_mapkit plugin registers.
        MapKitFactory.setApiKey("50ebf913-c20f-4f97-ba93-8b0995fedb5e")
        super.configureFlutterEngine(flutterEngine)
    }
}
