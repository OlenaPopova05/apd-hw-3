# HW3 Student Plan

## Approach

I will use UIKit with MVC architecture and SnapKit for the layout. `Student` and
`StudentStore` will be the model, and the app delegate will keep one shared
`StudentStore`. All view controllers will use this store to get student data
instead of creating separate arrays.

First, I will create the main student list using `UITableView` and reusable
cells. Each cell will display the student's avatar, name, age, average grade,
and scholarship status. The students will be shown in the original store order.

When a user selects a student, the app will open a details screen with all
student information. I will use `UINavigationController` to move between screens
and allow users to go back. Each subject on the details screen will be clickable
and open another student list filtered using `store.students(matchingSubject:)`.
The filtering should match the exact subject name, including uppercase and
lowercase letters.

I will also add accessibility identifiers and labels, use Dynamic Type fonts
and multiline labels, and handle missing images without force unwraps. I will
complete the required functionality before working on any optional add, edit,
or delete features.

## Milestones

- [x] Student list and reusable cell
- [x] Detail screen and navigation
- [x] Subject-filtered list
- [x] Unit and UI tests
- [ ] Optional add/edit/delete bonus, if attempted
- [x] Local verification and CI review

## Verification plan

- Students must be displayed in the same order as in `StudentStore`. Check the
  main list and filtered results to make sure the order is preserved.
- Subject filtering must be exact and case-sensitive. Add tests to check that
  different capitalization does not produce the same result.
- Navigation between the main list, details, and filtered list must work
  correctly. Check that selecting a student or subject opens the correct screen
  and that the back button works.
- All required student information must be displayed correctly. Check the cells
  and details screen, including cases where an avatar image is missing.
- Accessibility identifiers must match the required names: `studentList`,
  `studentCell.<student-id>`, `studentDetails`, and `subjectButton.<subject>`.
  Check them in UI tests.
- The app must use one shared `StudentStore` and should not keep separate student
  arrays in controllers. Review the implementation to make sure the data comes
  from the store.
- Add at least six XCTest methods covering the model, store, filtering,
  navigation, and UI. Run all tests after adding them and record the results in
  `AGENT_WORKLOG.md`.
