package com.canieatthis.can_i_eat_this1.auth

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object AuthTokenChannel {
    const val NAME = "canieatit/auth_tokens"

    fun register(messenger: BinaryMessenger, context: Context) {
        val store = AuthTokenStore(context)
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "readAccessToken" -> result.success(store.readAccess())
                    "readRefreshToken" -> result.success(store.readRefresh())
                    "writeTokens" -> {
                        val access = call.argument<String>("access")
                        val refresh = call.argument<String>("refresh")
                        if (access.isNullOrBlank() || refresh.isNullOrBlank()) {
                            result.error("BAD_ARGS", "access and refresh required", null)
                            return@setMethodCallHandler
                        }
                        store.write(access, refresh)
                        result.success(null)
                    }
                    "clearTokens" -> {
                        store.clear()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("AUTH_STORE", e.message, null)
            }
        }
    }
}
