package com.canieatthis.can_i_eat_this1.network

import org.json.JSONObject

internal data class ApiEnvelope(
    val isSuccess: Boolean,
    val result: JSONObject?,
) {
    companion object {
        fun parse(text: String): ApiEnvelope {
            if (text.isBlank()) return ApiEnvelope(false, null)
            return try {
                val json = JSONObject(text)
                ApiEnvelope(
                    isSuccess = json.optBoolean("isSuccess", false),
                    result = json.optJSONObject("result"),
                )
            } catch (_: Exception) {
                ApiEnvelope(false, null)
            }
        }
    }
}
