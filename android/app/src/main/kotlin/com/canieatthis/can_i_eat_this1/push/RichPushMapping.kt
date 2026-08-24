package com.canieatthis.can_i_eat_this1.push

import org.json.JSONArray
import org.json.JSONObject

internal object RichPushMapping {
    const val NONE = "none"
    const val DEFAULT_INTENSITY = 2

    val states = arrayOf(
        "comfortable",
        "good",
        "normal",
        "uncomfortable",
        "severe",
    )

    val intensityLabels = arrayOf("편안", "양호", "보통", "불편", "심각")

    data class Chip(val key: String, val label: String)

    val chips = listOf(
        Chip(NONE, "없음"),
        Chip("throat_foreign_body", "목 이물감"),
        Chip("acid_reflux", "신물"),
        Chip("cough", "기침"),
        Chip("chest_tightness", "가슴 답답"),
    )

    fun intensityToState(index: Int): String =
        states[index.coerceIn(0, states.lastIndex)]

    fun toggleChip(current: Set<String>, chip: String): Set<String> {
        if (chip == NONE) return emptySet()
        return if (current.contains(chip)) current - chip else current + chip
    }

    fun symptomJson(draft: RichPushDraft): String {
        val json = JSONObject()
        json.put("symptomState", intensityToState(draft.intensityIndex))
        val types = JSONArray()
        draft.symptomTypes.sorted().forEach { types.put(it) }
        json.put("symptomTypes", types)
        json.put("mealRecordId", draft.mealRecordId)
        val memo = draft.memo.trim()
        if (memo.isNotEmpty()) json.put("memo", memo)
        return json.toString()
    }
}
