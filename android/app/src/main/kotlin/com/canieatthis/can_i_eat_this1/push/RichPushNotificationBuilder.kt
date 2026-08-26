package com.canieatthis.can_i_eat_this1.push

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.RemoteInput
import com.canieatthis.can_i_eat_this1.R

internal object RichPushNotificationBuilder {
    // FCM 기본 채널과 동일 — 새 채널이면 사용자 설정/권한 때문에 안 보일 수 있다.
    const val CHANNEL_ID = "default_high_importance"
    const val ACTION_INTENSITY = "com.canieatthis.RICH_PUSH_INTENSITY"
    const val ACTION_CHIP = "com.canieatthis.RICH_PUSH_CHIP"
    const val ACTION_DISMISS = "com.canieatthis.RICH_PUSH_DISMISS"
    const val ACTION_COMPLETE = "com.canieatthis.RICH_PUSH_COMPLETE"
    const val EXTRA_MEAL_ID = "mealRecordId"
    const val EXTRA_INTENSITY = "intensity"
    const val EXTRA_CHIP = "chip"
    const val REMOTE_INPUT_MEMO = "rich_push_memo"

    fun showFromMessage(context: Context, data: Map<String, String>) {
        val mealId = data["targetId"]?.trim().orEmpty().ifEmpty { "unknown" }
        val type = data["type"] ?: "post_meal"
        val title = firstNonBlank(
            data["title"],
            data["gcm.n.title"],
            data["gcm.notification.title"],
        ) ?: "지금 속은 어때요?"
        val fallbackBody = firstNonBlank(
            data["body"],
            data["gcm.n.body"],
            data["gcm.notification.body"],
            data["mealName"],
        )
        val body = RichPushMapping.subtitleFromPayload(
            mealOccurredAt = data["mealOccurredAt"],
            hoursElapsed = data["hoursElapsed"],
            foodNames = data["foodNames"],
            fallbackBody = fallbackBody,
        )
        val existing = RichPushDraftStore.load(context, mealId)
        val draft = existing?.copy(type = type, title = title, body = body)
            ?: RichPushDraft(
                mealRecordId = mealId,
                type = type,
                title = title,
                body = body,
            )
        RichPushDraftStore.save(context, draft)
        post(context, draft)
    }

    fun post(context: Context, draft: RichPushDraft) {
        ensureChannel(context)
        try {
            postRich(context, draft)
        } catch (e: Exception) {
            Log.e(TAG, "custom rich notification failed, using simple fallback", e)
            postSimple(context, draft)
        }
    }

    private fun postRich(context: Context, draft: RichPushDraft) {
        val collapsed = buildCollapsedViews(context, draft)
        val expanded = buildExpandedViews(context, draft)
        notify(
            context,
            draft,
            baseBuilder(context, draft)
                .setCustomContentView(collapsed)
                .setCustomBigContentView(expanded)
                .setStyle(NotificationCompat.DecoratedCustomViewStyle())
                .setAutoCancel(true)
                .addAction(dismissAction(context, draft.mealRecordId))
                .addAction(detailAction(context, draft))
                .addAction(completeAction(context, draft.mealRecordId)),
        )
    }

    private fun postSimple(context: Context, draft: RichPushDraft) {
        notify(
            context,
            draft,
            baseBuilder(context, draft)
                .setAutoCancel(true)
                .addAction(dismissAction(context, draft.mealRecordId))
                .addAction(detailAction(context, draft)),
        )
    }

    private fun baseBuilder(context: Context, draft: RichPushDraft): NotificationCompat.Builder {
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(draft.title)
            .setContentText(draft.body)
            .setContentIntent(detailPending(context, draft))
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
    }

    private fun buildCollapsedViews(context: Context, draft: RichPushDraft): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.notification_rich_post_meal_collapsed)
        views.setTextViewText(R.id.rich_push_collapsed_title, draft.title)
        bindOptionalText(views, R.id.rich_push_collapsed_body, draft.body)
        return views
    }

    private fun notify(
        context: Context,
        draft: RichPushDraft,
        builder: NotificationCompat.Builder,
    ) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(notificationId(draft.mealRecordId), builder.build())
    }

    private fun firstNonBlank(vararg values: String?): String? =
        values.firstOrNull { !it.isNullOrBlank() }

    private fun bindOptionalText(views: RemoteViews, viewId: Int, text: String) {
        views.setTextViewText(viewId, text)
        views.setViewVisibility(
            viewId,
            if (text.isBlank()) android.view.View.GONE else android.view.View.VISIBLE,
        )
    }

    fun cancel(context: Context, mealRecordId: String) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(notificationId(mealRecordId))
    }

    fun notificationId(mealRecordId: String): Int = mealRecordId.hashCode() and 0x7FFFFFFF

    private fun buildExpandedViews(context: Context, draft: RichPushDraft): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.notification_rich_post_meal)
        views.setTextViewText(R.id.rich_push_title, draft.title)
        bindOptionalText(views, R.id.rich_push_body, draft.body)
        views.setTextViewText(
            R.id.rich_push_intensity_caption,
            RichPushMapping.intensityCaption(draft.intensityIndex),
        )
        views.setTextColor(R.id.rich_push_intensity_caption, 0xFF6B5CFF.toInt())

        val intensityIds = intArrayOf(
            R.id.intensity_0,
            R.id.intensity_1,
            R.id.intensity_2,
            R.id.intensity_3,
            R.id.intensity_4,
        )
        val thumbIds = intArrayOf(
            R.id.intensity_thumb_0,
            R.id.intensity_thumb_1,
            R.id.intensity_thumb_2,
            R.id.intensity_thumb_3,
            R.id.intensity_thumb_4,
        )
        val numIds = intArrayOf(
            R.id.intensity_num_0,
            R.id.intensity_num_1,
            R.id.intensity_num_2,
            R.id.intensity_num_3,
            R.id.intensity_num_4,
        )
        val selectedIndex = draft.intensityIndex.coerceIn(0, intensityIds.lastIndex)
        views.setProgressBar(R.id.intensity_progress, 10, selectedIndex * 2 + 1, false)
        for (i in intensityIds.indices) {
            views.setViewVisibility(
                thumbIds[i],
                if (i == selectedIndex) android.view.View.VISIBLE else android.view.View.GONE,
            )
            views.setTextColor(
                numIds[i],
                if (i == selectedIndex) 0xFF6B5CFF.toInt() else 0xFFA6A6B3.toInt(),
            )
            views.setOnClickPendingIntent(
                intensityIds[i],
                broadcast(
                    context,
                    ACTION_INTENSITY,
                    draft.mealRecordId,
                    salt = 10 + i,
                    extra = EXTRA_INTENSITY to i.toString(),
                    mutable = false,
                ),
            )
        }

        val chipIds = intArrayOf(
            R.id.chip_none,
            R.id.chip_throat,
            R.id.chip_reflux,
            R.id.chip_cough,
            R.id.chip_chest,
        )
        RichPushMapping.chips.forEachIndexed { index, chip ->
            val selected = if (chip.key == RichPushMapping.NONE) {
                draft.symptomTypes.isEmpty()
            } else {
                draft.symptomTypes.contains(chip.key)
            }
            views.setTextViewText(chipIds[index], chip.label)
            views.setInt(
                chipIds[index],
                "setBackgroundResource",
                if (selected) R.drawable.bg_chip_on else R.drawable.bg_chip_off,
            )
            views.setOnClickPendingIntent(
                chipIds[index],
                broadcast(
                    context,
                    ACTION_CHIP,
                    draft.mealRecordId,
                    salt = 20 + index,
                    extra = EXTRA_CHIP to chip.key,
                    mutable = false,
                ),
            )
        }
        return views
    }

    private fun dismissAction(context: Context, mealId: String): NotificationCompat.Action {
        return NotificationCompat.Action.Builder(
            0,
            "나중에",
            broadcast(context, ACTION_DISMISS, mealId, salt = 1, mutable = false),
        ).build()
    }

    private fun detailAction(context: Context, draft: RichPushDraft): NotificationCompat.Action {
        return NotificationCompat.Action.Builder(
            0,
            "자세히",
            detailPending(context, draft),
        ).build()
    }

    private fun completeAction(context: Context, mealId: String): NotificationCompat.Action {
        val remoteInput = RemoteInput.Builder(REMOTE_INPUT_MEMO)
            .setLabel("메모 추가...")
            .build()
        return NotificationCompat.Action.Builder(
            0,
            "기록 완료",
            broadcast(context, ACTION_COMPLETE, mealId, salt = 3, mutable = true),
        ).addRemoteInput(remoteInput).build()
    }

    private fun detailPending(context: Context, draft: RichPushDraft): PendingIntent {
        val intent = RichPushLaunchHolder.detailIntent(context, draft)
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag()
        return PendingIntent.getActivity(
            context,
            requestCode(draft.mealRecordId, 2),
            intent,
            flags,
        )
    }

    private fun broadcast(
        context: Context,
        action: String,
        mealId: String,
        salt: Int,
        extra: Pair<String, String>? = null,
        mutable: Boolean,
    ): PendingIntent {
        val intent = Intent(context, RichPushActionReceiver::class.java).apply {
            this.action = action
            setPackage(context.packageName)
            putExtra(EXTRA_MEAL_ID, mealId)
            if (extra != null) putExtra(extra.first, extra.second)
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (mutable) mutableFlag() else immutableFlag()
        return PendingIntent.getBroadcast(
            context,
            requestCode(mealId, salt),
            intent,
            flags,
        )
    }

    private fun requestCode(mealId: String, salt: Int): Int =
        (mealId.hashCode() xor salt) and 0x7FFFFFFF

    private fun immutableFlag(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0

    private fun mutableFlag(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0

    fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(
            CHANNEL_ID,
            "일반 알림",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "식사 후 증상 기록 등 앱 알림"
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            enableVibration(true)
            setShowBadge(true)
        }
        manager.createNotificationChannel(channel)
    }

    private const val TAG = "RichPush"
}
