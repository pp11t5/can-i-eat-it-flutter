package com.canieatthis.can_i_eat_this1.network

import android.content.Context
import android.util.Log
import com.canieatthis.can_i_eat_this1.BuildConfig
import com.canieatthis.can_i_eat_this1.auth.AuthTokenStore
import com.canieatthis.can_i_eat_this1.push.RichPushDraft
import com.canieatthis.can_i_eat_this1.push.RichPushMapping
import org.json.JSONObject

internal class SymptomApiClient(context: Context) {
    private val store = AuthTokenStore(context)
    private val baseUrl = BuildConfig.API_BASE_URL.trimEnd('/')

    fun createSymptom(draft: RichPushDraft): Boolean {
        val access = store.readAccess()
        if (access.isNullOrBlank()) {
            Log.w(TAG, "createSymptom skipped: no access token")
            return false
        }
        val payload = RichPushMapping.symptomJson(draft)
        var (code, text) = HttpJson.post("$baseUrl/symptoms", payload, access)
        if (code == 401) {
            if (!refresh()) return false
            val retryAccess = store.readAccess() ?: return false
            val retry = HttpJson.post("$baseUrl/symptoms", payload, retryAccess)
            code = retry.first
            text = retry.second
        }
        if (code !in 200..299) {
            Log.w(TAG, "createSymptom http=$code")
            return false
        }
        return ApiEnvelope.parse(text).isSuccess
    }

    private fun refresh(): Boolean {
        val refreshToken = store.readRefresh()
        if (refreshToken.isNullOrBlank()) {
            store.clear()
            return false
        }
        val body = JSONObject().put("refreshToken", refreshToken).toString()
        return try {
            val (code, text) = HttpJson.post("$baseUrl/auth/refresh", body, null)
            if (code !in 200..299) {
                store.clear()
                return false
            }
            val envelope = ApiEnvelope.parse(text)
            val result = envelope.result
            val access = result?.optString("accessToken").orEmpty()
            val newRefresh = result?.optString("refreshToken").orEmpty()
            if (!envelope.isSuccess || access.isBlank() || newRefresh.isBlank()) {
                store.clear()
                return false
            }
            store.write(access, newRefresh)
            true
        } catch (e: Exception) {
            Log.w(TAG, "refresh failed: ${e.javaClass.simpleName}")
            false
        }
    }

    companion object {
        private const val TAG = "SymptomApi"
    }
}
