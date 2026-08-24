package com.canieatthis.can_i_eat_this1

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences

object HomeWidgetStore {
    private const val PREFS = "canieatit_home_widget"

    fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun write(context: Context, data: Map<String, String>) {
        val editor = prefs(context).edit()
        data.forEach { (key, value) -> editor.putString(key, value) }
        editor.apply()
        refresh(context)
    }

    fun refresh(context: Context) {
        notifyProvider(context, TodayMealWidgetProvider::class.java)
        notifyProvider(context, TodayMealWidgetSmallProvider::class.java)
    }

    private fun notifyProvider(context: Context, provider: Class<out AppWidgetProvider>) {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(ComponentName(context, provider))
        if (ids.isEmpty()) return
        val intent = Intent(context, provider).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        }
        context.sendBroadcast(intent)
    }
}
