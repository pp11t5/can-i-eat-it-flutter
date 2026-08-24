package com.canieatthis.can_i_eat_this1.push

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.canieatthis.can_i_eat_this1.network.SymptomApiClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class RichPushSubmitWorker(
    context: Context,
    params: WorkerParameters,
) : CoroutineWorker(context, params) {
    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val mealId = inputData.getString(KEY_MEAL_ID)?.trim().orEmpty()
        if (mealId.isEmpty()) return@withContext Result.failure()

        val draft = RichPushDraftStore.load(applicationContext, mealId)
            ?: return@withContext Result.failure()
        val memoOverride = inputData.getString(KEY_MEMO)
        val toPost = if (memoOverride.isNullOrBlank()) {
            draft
        } else {
            draft.copy(memo = memoOverride)
        }

        return@withContext try {
            val ok = SymptomApiClient(applicationContext).createSymptom(toPost)
            if (ok) {
                RichPushNotificationBuilder.cancel(applicationContext, mealId)
                RichPushDraftStore.clear(applicationContext, mealId)
                Result.success()
            } else {
                Log.w(TAG, "createSymptom returned false")
                Result.retry()
            }
        } catch (e: Exception) {
            Log.w(TAG, "createSymptom failed: ${e.javaClass.simpleName}")
            Result.retry()
        }
    }

    companion object {
        const val KEY_MEAL_ID = "mealRecordId"
        const val KEY_MEMO = "memo"
        private const val TAG = "RichPushSubmit"
    }
}
