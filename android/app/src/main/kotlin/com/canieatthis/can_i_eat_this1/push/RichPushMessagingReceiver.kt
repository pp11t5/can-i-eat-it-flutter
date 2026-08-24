package com.canieatthis.can_i_eat_this1.push

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingReceiver

/**
 * 식후 리치 푸시는 네이티브 커스텀 알림 1장만 띄운다.
 * Flutter 포그라운드 로컬 알림은 Dart에서 같은 타입을 스킵한다.
 */
class RichPushMessagingReceiver : FlutterFirebaseMessagingReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        try {
            val extras = intent.extras
            val data = extras?.let { stringExtras(it) }.orEmpty()
            val type = data["type"]
            if (type == "post_meal" || type == "post_meal_delayed_single") {
                RichPushNotificationBuilder.showFromMessage(context, data)
            }
        } catch (e: Exception) {
            Log.e(TAG, "rich push display failed", e)
        }
        super.onReceive(context, intent)
    }

    @Suppress("DEPRECATION")
    private fun stringExtras(extras: Bundle): Map<String, String> {
        val data = linkedMapOf<String, String>()
        for (key in extras.keySet()) {
            val value = extras.get(key) ?: continue
            val text = when (value) {
                is String -> value
                is CharSequence -> value.toString()
                else -> continue
            }
            if (text.isNotEmpty()) data[key] = text
        }
        return data
    }

    companion object {
        private const val TAG = "RichPush"
    }
}
