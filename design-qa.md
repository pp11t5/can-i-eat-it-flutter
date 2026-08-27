# iOS Home Widget Design QA

- Source visual truth: `/Users/hojun/Downloads/위젯 최종.png`
- Source dimensions: 2311 × 2066 px
- Pre-fix implementation screenshot: `/Users/hojun/Pictures/Photos Library.photoslibrary/resources/derivatives/masters/0/0E69D661-5E3F-4354-879C-540194B56A97_4_5005_c.jpeg`
- Pre-fix screenshot dimensions: 359 × 782 px
- Current implementation screenshot: unavailable
- Viewport: iOS Home Screen, `systemSmall` and `systemMedium`
- State: small `recordMeal`, medium `promptSymptom`
- Density normalization: component measurements were converted to relative widget coordinates; no post-fix raster comparison was possible.

## Full-view comparison evidence

The source and pre-fix device capture were opened together. The pre-fix medium widget used an oversized left column, wrapped the prompt headline, clipped the CTA, and placed the turtle over the action area. The pre-fix small widget used an intrinsic-width CTA instead of the near-full-width CTA in the source.

## Focused region comparison evidence

- Source medium status pills measure approximately 76 × 26 pt when normalized to a 329 pt system-medium width.
- Source medium CTA measures approximately 103 × 28 pt.
- Source medium turtle occupies approximately 90 × 108 pt and is clipped against the bottom-right edge.
- Source small status tiles normalize to approximately 38 × 50 pt, with a near-full-width CTA.

## Comparison history

### Iteration 1

- Earlier findings: duplicated system/content margins, oversized medium status column, wrapped prompt headline, CTA/turtle collision, and undersized small CTA.
- Fixes made: disabled WidgetKit content margins; introduced explicit source-derived padding; resized status components; restored the large bottom-right turtle treatment; forced the symptom prompt to one line with scaling; made the small CTA full width.
- Post-fix evidence: Swift compilation and `TodayMealWidget` simulator-target build passed. A rendered post-fix screenshot is unavailable because no iOS Simulator is currently booted.

## Findings

- [P1] Post-fix visual evidence unavailable
  - Location: `TodayMealWidget`, system-small and system-medium.
  - Evidence: no booted simulator was available to capture the latest compiled widget.
  - Impact: typography, clipping, and exact optical alignment cannot receive a final visual pass.
  - Fix: boot an iOS Simulator, install the dev app, add both widget sizes, and capture the same states for side-by-side comparison.

## Required fidelity surfaces

- Fonts and typography: source-derived sizes applied; post-fix wrapping and optical weight require visual confirmation.
- Spacing and layout rhythm: source-derived component ratios applied; post-fix screenshot required.
- Colors and visual tokens: existing semantic palette retained and visually consistent with the source.
- Image quality and asset fidelity: supplied turtle assets retained; updated crop and scale require visual confirmation.
- Copy and content: source copy and state-specific CTA labels retained.

## Implementation checklist

- Boot an iOS Simulator.
- Run the dev app and add both widget families.
- Capture `recordMeal` and `promptSymptom` states.
- Compare the new capture with the source and resolve remaining P1/P2 differences.

final result: blocked
