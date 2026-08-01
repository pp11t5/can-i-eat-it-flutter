package com.canieatthis.can_i_eat_this

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build

/**
 * FCM이 앱 UI를 시작하기 전에 notification payload를 표시할 때도 사용할
 * 기본 알림 채널을 만든다.
 */
class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "default_high_importance",
                "일반 알림",
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = "식사 후 증상 기록 등 앱 알림"
            }
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }
}
