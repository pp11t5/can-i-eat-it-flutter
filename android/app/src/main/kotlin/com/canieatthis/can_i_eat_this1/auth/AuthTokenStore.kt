package com.canieatthis.can_i_eat_this1.auth

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKeys

/**
 * Flutter TokenStore와 공유하는 Android 토큰 저장소.
 *
 * AES256 EncryptedSharedPreferences. 알림 Worker가 같은 파일을 읽는다.
 */
class AuthTokenStore(context: Context) {
    private val prefs: SharedPreferences = createPrefs(context.applicationContext)

    fun readAccess(): String? = prefs.getString(KEY_ACCESS, null)?.takeIf { it.isNotEmpty() }

    fun readRefresh(): String? = prefs.getString(KEY_REFRESH, null)?.takeIf { it.isNotEmpty() }

    fun write(access: String, refresh: String) {
        prefs.edit()
            .putString(KEY_ACCESS, access)
            .putString(KEY_REFRESH, refresh)
            .apply()
    }

    fun clear() {
        prefs.edit()
            .remove(KEY_ACCESS)
            .remove(KEY_REFRESH)
            .apply()
    }

    companion object {
        const val PREFS_NAME = "canieatit_auth"
        const val KEY_ACCESS = "auth.access_token"
        const val KEY_REFRESH = "auth.refresh_token"

        @Suppress("DEPRECATION")
        private fun createPrefs(context: Context): SharedPreferences {
            val masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC)
            return EncryptedSharedPreferences.create(
                PREFS_NAME,
                masterKeyAlias,
                context,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
            )
        }
    }
}
