package com.canieatthis.can_i_eat_this1

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import com.canieatthis.can_i_eat_this1.auth.AuthTokenChannel
import com.canieatthis.can_i_eat_this1.push.RichPushLaunchHolder
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val appSettingsChannel = "canieatit/app_settings"
    private val homeWidgetChannel = "canieatit/home_widget"
    private val homeWidgetClicks = "canieatit/home_widget/clicks"

    private var initialWidgetUri: String? = null
    private var widgetClickSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initialWidgetUri = widgetUriFrom(intent)
        RichPushLaunchHolder.capture(this, intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        RichPushLaunchHolder.capture(this, intent)
        val uri = widgetUriFrom(intent) ?: return
        val sink = widgetClickSink
        if (sink != null) {
            sink.success(uri)
        } else {
            initialWidgetUri = uri
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        AuthTokenChannel.register(messenger, this)
        RichPushLaunchHolder.register(messenger)

        MethodChannel(messenger, appSettingsChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "openNotificationSettings") {
                    try {
                        val settingsIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                        } else {
                            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                                .setData(Uri.fromParts("package", packageName, null))
                        }
                        settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(settingsIntent)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("OPEN_SETTINGS_FAILED", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, homeWidgetChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "write" -> {
                        val raw = call.arguments as? Map<*, *> ?: emptyMap<Any, Any>()
                        val data = raw.entries.associate { "${it.key}" to "${it.value}" }
                        HomeWidgetStore.write(this, data)
                        result.success(null)
                    }
                    "update" -> {
                        HomeWidgetStore.refresh(this)
                        result.success(null)
                    }
                    "getInitialUri" -> {
                        val uri = initialWidgetUri
                        initialWidgetUri = null
                        result.success(uri)
                    }
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, homeWidgetClicks)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    widgetClickSink = events
                    val pending = initialWidgetUri
                    if (pending != null) {
                        initialWidgetUri = null
                        events?.success(pending)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    widgetClickSink = null
                }
            })
    }

    private fun widgetUriFrom(intent: Intent?): String? {
        val data = intent?.data?.toString() ?: return null
        return if (data.startsWith("canieatit://widget")) data else null
    }
}
