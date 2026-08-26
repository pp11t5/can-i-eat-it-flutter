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

    fun intensityCaption(index: Int): String {
        val i = index.coerceIn(0, intensityLabels.lastIndex)
        return "${intensityLabels[i]} (강도 ${i + 1} / 5)"
    }

    /**
     * Figma: `13:24 점심 후 6시간 경과 · 된장찌개·잡곡밥`
     * 끼니 슬롯(아침/점심/저녁/야식)은 payload에 없어서 시각으로만 추정한다.
     */
    fun subtitleFromPayload(
        mealOccurredAt: String?,
        hoursElapsed: String?,
        foodNames: String?,
        fallbackBody: String?,
    ): String {
        val time = mealOccurredAt?.trim().orEmpty()
        val hours = hoursElapsed?.trim()?.toIntOrNull()
        val foods = foodNames
            ?.split(',')
            ?.map { it.trim() }
            ?.filter { it.isNotEmpty() }
            ?.joinToString("·")
            .orEmpty()
        val slot = mealSlotLabel(time)
        val context = mealContextLabel(time, slot, hours)
        return when {
            context.isNotEmpty() && foods.isNotEmpty() -> "$context · $foods"
            context.isNotEmpty() -> context
            foods.isNotEmpty() -> foods
            else -> fallbackBody?.trim().orEmpty()
        }
    }

    private fun mealSlotLabel(hhmm: String): String {
        val hour = hhmm.substringBefore(':').toIntOrNull() ?: return ""
        if (hour !in 0..23) return ""
        return when (hour) {
            in 5..10 -> "아침"
            in 11..16 -> "점심"
            in 17..21 -> "저녁"
            else -> "야식"
        }
    }

    private fun mealContextLabel(time: String, slot: String, hours: Int?): String {
        val prefix = listOf(time, slot).filter { it.isNotEmpty() }.joinToString(" ")
        return when {
            hours == null -> prefix
            hours <= 0 -> listOf(prefix, "직후").filter { it.isNotEmpty() }.joinToString(" ")
            prefix.isEmpty() -> "${hours}시간 경과"
            else -> "$prefix 후 ${hours}시간 경과"
        }
    }

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
