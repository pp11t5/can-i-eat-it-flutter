package com.canieatthis.can_i_eat_this1.push

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.RemoteInput
import androidx.work.Constraints
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.workDataOf

class RichPushActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val mealId = intent.getStringExtra(RichPushNotificationBuilder.EXTRA_MEAL_ID)
            ?.trim()
            .orEmpty()
        if (mealId.isEmpty()) return

        when (intent.action) {
            RichPushNotificationBuilder.ACTION_INTENSITY -> {
                val index = intent.getStringExtra(RichPushNotificationBuilder.EXTRA_INTENSITY)
                    ?.toIntOrNull() ?: return
                val draft = RichPushDraftStore.load(context, mealId) ?: return
                val updated = draft.copy(
                    intensityIndex = index.coerceIn(0, RichPushMapping.states.lastIndex),
                )
                RichPushDraftStore.save(context, updated)
                RichPushNotificationBuilder.post(context, updated)
            }
            RichPushNotificationBuilder.ACTION_CHIP -> {
                val chip = intent.getStringExtra(RichPushNotificationBuilder.EXTRA_CHIP) ?: return
                val draft = RichPushDraftStore.load(context, mealId) ?: return
                val updated = draft.copy(
                    symptomTypes = RichPushMapping.toggleChip(draft.symptomTypes, chip),
                )
                RichPushDraftStore.save(context, updated)
                RichPushNotificationBuilder.post(context, updated)
            }
            RichPushNotificationBuilder.ACTION_DISMISS -> {
                RichPushNotificationBuilder.cancel(context, mealId)
                RichPushDraftStore.clear(context, mealId)
            }
            RichPushNotificationBuilder.ACTION_COMPLETE -> {
                val remoteMemo = RemoteInput.getResultsFromIntent(intent)
                    ?.getCharSequence(RichPushNotificationBuilder.REMOTE_INPUT_MEMO)
                    ?.toString()
                    ?.trim()
                val draft = RichPushDraftStore.load(context, mealId)
                if (draft != null && !remoteMemo.isNullOrBlank()) {
                    RichPushDraftStore.save(context, draft.copy(memo = remoteMemo))
                }
                enqueueSubmit(context, mealId, remoteMemo)
            }
        }
    }

    private fun enqueueSubmit(context: Context, mealId: String, memo: String?) {
        val data = if (memo.isNullOrBlank()) {
            workDataOf(RichPushSubmitWorker.KEY_MEAL_ID to mealId)
        } else {
            workDataOf(
                RichPushSubmitWorker.KEY_MEAL_ID to mealId,
                RichPushSubmitWorker.KEY_MEMO to memo,
            )
        }
        val request = OneTimeWorkRequestBuilder<RichPushSubmitWorker>()
            .setInputData(data)
            .setConstraints(
                Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.CONNECTED)
                    .build(),
            )
            .build()
        WorkManager.getInstance(context).enqueueUniqueWork(
            "rich-push-submit-$mealId",
            ExistingWorkPolicy.KEEP,
            request,
        )
    }
}
