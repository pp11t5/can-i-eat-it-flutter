package com.canieatthis.can_i_eat_this1

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.Bundle

class TodayMealWidgetSmallProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        TodayMealWidgetBinder.updateAll(
            context,
            appWidgetManager,
            appWidgetIds,
            R.layout.today_meal_widget_small,
            showStory = false,
            requestCode = 1,
        )
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
    }
}
