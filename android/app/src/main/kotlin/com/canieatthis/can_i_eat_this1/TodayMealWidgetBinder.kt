package com.canieatthis.can_i_eat_this1

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.view.View
import android.widget.RemoteViews

internal object TodayMealWidgetBinder {
    fun updateAll(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        layoutRes: Int,
        showStory: Boolean,
        requestCode: Int,
    ) {
        val prefs = HomeWidgetStore.prefs(context)
        appWidgetIds.forEach { widgetId ->
            try {
                val views = RemoteViews(context.packageName, layoutRes)
                bind(context, views, prefs, showStory, requestCode)
                appWidgetManager.updateAppWidget(widgetId, views)
            } catch (e: RuntimeException) {
                android.util.Log.e("TodayMealWidget", "bind failed id=$widgetId", e)
            }
        }
    }

    private fun bind(
        context: Context,
        views: RemoteViews,
        prefs: SharedPreferences,
        showStory: Boolean,
        requestCode: Int,
    ) {
        views.setTextViewText(
            R.id.widget_recommend_count,
            prefs.getString("recommendCount", "0") ?: "0",
        )
        views.setTextViewText(
            R.id.widget_caution_count,
            prefs.getString("cautionCount", "0") ?: "0",
        )
        views.setTextViewText(
            R.id.widget_risk_count,
            prefs.getString("riskCount", "0") ?: "0",
        )

        val mealCta = context.getString(R.string.home_widget_cta_meal)
            .removeSuffix(" +")
            .removeSuffix("+")
            .trim()
        val snapshotCta = (prefs.getString("ctaLabel", null) ?: mealCta)
            .removeSuffix(" +")
            .removeSuffix("+")
            .trim()
        // 작은 위젯은 상태와 무관하게 음식 기록하기만 보여 준다.
        val cta = if (showStory) snapshotCta else mealCta
        views.setTextViewText(R.id.widget_cta_label, cta)
        val history = showStory && when (prefs.getString("kind", "")) {
            "allRecordedComfortable", "allRecordedUncomfortable" -> true
            else -> false
        }
        views.setTextViewText(R.id.widget_cta_icon, if (history) ">" else "+")
        views.setViewVisibility(R.id.widget_cta_label, View.VISIBLE)
        views.setViewVisibility(R.id.widget_cta_label_regular, View.GONE)
        if (showStory) {
            val d = context.resources.displayMetrics.density
            fun dp(v: Int) = (v * d).toInt()
            if (history) {
                views.setViewPadding(R.id.widget_cta, dp(10), dp(6), dp(6), dp(6))
            } else {
                views.setViewPadding(R.id.widget_cta, dp(14), dp(6), dp(8), dp(6))
            }
            val headline = prefs.getString("headline", "")
            setOptionalText(views, R.id.widget_headline, headline)
            if (!headline.isNullOrBlank() && headline.contains('\n')) {
                views.setInt(R.id.widget_headline, "setMaxLines", 2)
            } else {
                views.setInt(R.id.widget_headline, "setMaxLines", 1)
            }
            setOptionalText(views, R.id.widget_subtitle, prefs.getString("subtitle", ""))
            when (prefs.getString("turtle", "none")) {
                "happy" -> {
                    views.setImageViewResource(R.id.widget_turtle, R.drawable.widget_turtle_happy)
                    views.setViewVisibility(R.id.widget_turtle, View.VISIBLE)
                }
                "curious" -> {
                    views.setImageViewResource(R.id.widget_turtle, R.drawable.widget_turtle_curious)
                    views.setViewVisibility(R.id.widget_turtle, View.VISIBLE)
                }
                "frown" -> {
                    views.setImageViewResource(R.id.widget_turtle, R.drawable.widget_turtle_frown)
                    views.setViewVisibility(R.id.widget_turtle, View.VISIBLE)
                }
                else -> views.setViewVisibility(R.id.widget_turtle, View.GONE)
            }
        }

        val uri = Uri.parse(
            if (showStory) {
                prefs.getString("uri", "canieatit://widget/home")
                    ?: "canieatit://widget/home"
            } else {
                "canieatit://widget/meal-record"
            },
        )
        val launch = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            setData(uri)
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE
            } else {
                0
            }
        val pending = PendingIntent.getActivity(context, requestCode, launch, flags)
        views.setOnClickPendingIntent(R.id.widget_root, pending)
        views.setOnClickPendingIntent(R.id.widget_cta, pending)
    }

    private fun setOptionalText(views: RemoteViews, viewId: Int, value: String?) {
        if (value.isNullOrBlank()) {
            views.setViewVisibility(viewId, View.GONE)
        } else {
            views.setTextViewText(viewId, value)
            views.setViewVisibility(viewId, View.VISIBLE)
        }
    }
}
