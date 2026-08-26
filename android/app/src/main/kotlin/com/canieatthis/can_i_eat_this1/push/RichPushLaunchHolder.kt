package com.canieatthis.can_i_eat_this1.push

import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object RichPushLaunchHolder {
    const val EXTRA_TYPE = "rich_push_type"
    const val EXTRA_TARGET_ID = "rich_push_target_id"
    const val EXTRA_INTENSITY_INDEX = "rich_push_intensity_index"
    const val EXTRA_SYMPTOM_TYPES = "rich_push_symptom_types"
    const val CHANNEL_NAME = "canieatit/rich_push_launch"

    @Volatile
    private var pending: Map<String, String>? = null

    @Volatile
    private var channel: MethodChannel? = null

    fun capture(context: Context, intent: Intent?) {
        if (intent == null) return
        val type = intent.getStringExtra(EXTRA_TYPE) ?: return
        val targetId = intent.getStringExtra(EXTRA_TARGET_ID)?.trim().orEmpty()
        if (targetId.isEmpty()) return
        val draft = RichPushDraftStore.load(context, targetId)
        RichPushNotificationBuilder.cancel(context, targetId)
        RichPushDraftStore.clear(context, targetId)
        val data = buildMap {
            put("type", type)
            put("targetId", targetId)
            val intensity = draft?.intensityIndex?.toString()
                ?: intent.getStringExtra(EXTRA_INTENSITY_INDEX)
            intensity?.takeIf { it.isNotBlank() }?.let { put("intensityIndex", it) }
            val types = draft?.symptomTypes?.takeIf { it.isNotEmpty() }?.joinToString(",")
                ?: intent.getStringExtra(EXTRA_SYMPTOM_TYPES)
            types?.takeIf { it.isNotBlank() }?.let { put("symptomTypes", it) }
        }
        val ch = channel
        if (ch != null) {
            ch.invokeMethod("onLaunch", data)
            pending = null
        } else {
            pending = data
        }
    }

    fun register(messenger: BinaryMessenger) {
        val methodChannel = MethodChannel(messenger, CHANNEL_NAME)
        channel = methodChannel
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "takePendingLaunch") {
                val data = pending
                pending = null
                result.success(data)
            } else {
                result.notImplemented()
            }
        }
    }

    internal fun detailIntent(context: Context, draft: RichPushDraft): Intent {
        return Intent(context, com.canieatthis.can_i_eat_this1.MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(EXTRA_TYPE, draft.type)
            putExtra(EXTRA_TARGET_ID, draft.mealRecordId)
            putExtra(EXTRA_INTENSITY_INDEX, draft.intensityIndex.toString())
            if (draft.symptomTypes.isNotEmpty()) {
                putExtra(EXTRA_SYMPTOM_TYPES, draft.symptomTypes.joinToString(","))
            }
        }
    }
}
