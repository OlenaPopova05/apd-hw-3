# Agent Worklog

I used ChatGPT (Codex) to help me understand the HW3 requirements, debug the
starter app, implement the student screens, and write XCTest tests. I asked
questions about UIKit, table views, navigation, and SnapKit, and reviewed the
suggested code so I could understand and adjust it.

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-07 | ChatGPT (Codex) helped me investigate the black screen and understand the app and scene delegates. | I checked the breakpoints, configured the scene in Xcode, and confirmed that the starter screen appeared in the simulator. | `StudentDirectory/SceneDelegate.swift`; visible `HW3 Starter` screen |
| 2026-11-07 to 2026-11-09 | ChatGPT (Codex) helped implement the student list and reusable cell and explained the table data source, delegate, cell reuse, and layout. | I reviewed both files, asked how their methods work, and removed an unnecessary list reload and avatar reset. | `StudentDirectory/StudentsViewController.swift`; `StudentDirectory/StudentTableViewCell.swift`; list UI test |
| 2026-11-09 | ChatGPT (Codex) helped add the detail screen and navigation and explained the new controller. | I reviewed the displayed fields and layout, asked about avatar sizing, and checked the navigation behavior. | `StudentDirectory/StudentDetailsViewController.swift`; details UI test |
| 2026-11-09 | ChatGPT (Codex) helped add subject buttons and exact subject filtering. | I reviewed the filtering code and button settings. After considering an inline layout, I decided to keep the subjects in a column. | `StudentDirectory/StudentStore.swift`; `StudentDirectory/StudentDetailsViewController.swift`; filter tests |
| 2026-11-09 | ChatGPT (Codex) helped organize and explain the added unit and UI tests. | I reviewed what each test checks. | `StudentDirectoryTests/StudentStoreTests.swift`; `StudentDirectoryUITests/StudentDirectoryFlowUITests.swift` |
| 2026-11-09 | ChatGPT (Codex) helped implement the optional add, edit, and delete features and added tests. | I reviewed the code and tests, and ran the tests on iPhone 17 Pro. | `StudentDirectory/StudentFormViewController.swift`; 19 local tests passed on iPhone 17 Pro, 0 failed, 0 skipped |

## Final review

- Agent/tool disclosure: I used ChatGPT (Codex) for debugging, planning, implementation, explanations, and tests. I reviewed the suggested code and asked follow-up questions to understand it.
- Accepted and rejected/revised recommendations: I accepted the shared-store approach, but moved the store from the scene delegate to the app delegate. I removed an unnecessary list reload and avatar reset, chose a column instead of an inline subject layout, and removed an extra student-copy test.
- Local test result: All 19 tests passed in Xcode on iPhone 17 Pro; 0 failed and 0 skipped.
- CI URL/status: [GitHub Actions run](https://github.com/OlenaPopova05/apd-hw-3/actions/runs/42688102191) completed successfully on 2026-11-09.
- Known limitation or remaining risk: No known issues with the required functionality.
