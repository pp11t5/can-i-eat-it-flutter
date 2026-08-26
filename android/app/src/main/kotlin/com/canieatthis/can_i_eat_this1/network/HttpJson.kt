package com.canieatthis.can_i_eat_this1.network

import java.net.HttpURLConnection
import java.net.URL

internal object HttpJson {
    fun post(url: String, body: String, bearer: String?): Pair<Int, String> {
        val conn = (URL(url).openConnection() as HttpURLConnection)
        try {
            conn.connectTimeout = 15_000
            conn.readTimeout = 15_000
            conn.requestMethod = "POST"
            conn.doOutput = true
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8")
            conn.setRequestProperty("Accept", "application/json")
            if (!bearer.isNullOrBlank()) {
                conn.setRequestProperty("Authorization", "Bearer $bearer")
            }
            conn.outputStream.use { it.write(body.toByteArray(Charsets.UTF_8)) }
            val code = conn.responseCode
            val stream = if (code in 200..299) conn.inputStream else conn.errorStream
            val text = stream?.bufferedReader(Charsets.UTF_8)?.readText().orEmpty()
            return code to text
        } finally {
            conn.disconnect()
        }
    }
}
