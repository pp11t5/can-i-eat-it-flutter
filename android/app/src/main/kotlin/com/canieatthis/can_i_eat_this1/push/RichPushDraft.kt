package com.canieatthis.can_i_eat_this1.push

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

internal data class RichPushDraft(
    val mealRecordId: String,
    val type: String,
    val title: String,
    val body: String,
    val intensityIndex: Int = RichPushMapping.DEFAULT_INTENSITY,
    val symptomTypes: Set<String> = emptySet(),
    val memo: String = "",
) {
    fun toJson(): String {
        val json = JSONObject()
        json.put("mealRecordId", mealRecordId)
        json.put("type", type)
        json.put("title", title)
        json.put("body", body)
        json.put("intensityIndex", intensityIndex)
        val types = JSONArray()
        symptomTypes.forEach { types.put(it) }
        json.put("symptomTypes", types)
        json.put("memo", memo)
        return json.toString()
    }

    companion object {
        fun fromJson(text: String): RichPushDraft? {
            return try {
                val json = JSONObject(text)
                val types = mutableSetOf<String>()
                val array = json.optJSONArray("symptomTypes")
                if (array != null) {
                    for (i in 0 until array.length()) {
                        types.add(array.getString(i))
                    }
                }
                RichPushDraft(
                    mealRecordId = json.getString("mealRecordId"),
                    type = json.optString("type", "post_meal"),
                    title = json.optString("title"),
                    body = json.optString("body"),
                    intensityIndex = json.optInt(
                        "intensityIndex",
                        RichPushMapping.DEFAULT_INTENSITY,
                    ),
                    symptomTypes = types,
                    memo = json.optString("memo"),
                )
            } catch (_: Exception) {
                null
            }
        }
    }
}

internal object RichPushDraftStore {
    private const val PREFS = "canieatit_rich_push_drafts"

    fun load(context: Context, mealRecordId: String): RichPushDraft? {
        val text = context.applicationContext
            .getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getString(mealRecordId, null) ?: return null
        return RichPushDraft.fromJson(text)
    }

    fun save(context: Context, draft: RichPushDraft) {
        context.applicationContext
            .getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(draft.mealRecordId, draft.toJson())
            .apply()
    }

    fun clear(context: Context, mealRecordId: String) {
        context.applicationContext
            .getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .remove(mealRecordId)
            .apply()
    }
}
