import XCTest

final class StudentDirectoryFlowUITests: XCTestCase {
    func testListShowsTitleAndFirstStudent() {
        let app = XCUIApplication()
        app.launch()

        let list = app.tables["studentList"]
        XCTAssertTrue(list.exists)
        XCTAssertTrue(app.navigationBars["Students"].exists)

        let firstStudent = list.cells["studentCell.00000000-0000-0000-0000-000000000001"]
        XCTAssertTrue(firstStudent.exists)
        XCTAssertTrue(firstStudent.label.contains("Ada Lovelace"))
        XCTAssertTrue(firstStudent.label.contains("Age: 20"))
        XCTAssertTrue(firstStudent.label.contains("Average grade: 97.5"))
        XCTAssertTrue(firstStudent.label.contains("Scholarship: Yes"))
    }

    func testSelectingStudentShowsEveryFieldAndBackReturnsToList() {
        let app = XCUIApplication()
        app.launch()

        let list = app.tables["studentList"]
        let ada = list.cells["studentCell.00000000-0000-0000-0000-000000000001"]
        XCTAssertTrue(ada.exists)
        ada.tap()

        XCTAssertTrue(app.scrollViews["studentDetails"].exists)
        XCTAssertTrue(app.navigationBars["Ada Lovelace"].exists)
        XCTAssertTrue(app.staticTexts["ID: 00000000-0000-0000-0000-000000000001"].exists)
        XCTAssertTrue(app.staticTexts["Name: Ada Lovelace"].exists)
        XCTAssertTrue(app.staticTexts["Age: 20"].exists)
        XCTAssertTrue(app.staticTexts["Average grade: 97.5"].exists)
        XCTAssertTrue(app.staticTexts["Scholarship: Yes"].exists)
        XCTAssertTrue(app.staticTexts["Subjects:"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Algorithms"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Math"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Design"].exists)
        XCTAssertTrue(app.staticTexts["Avatar asset: avatar-01"].exists)

        app.navigationBars["Ada Lovelace"].buttons["Students"].tap()
        XCTAssertTrue(list.exists)
    }

    func testSubjectButtonOpensFilteredListAndBackReturnsToDetails() {
        let app = XCUIApplication()
        app.launch()

        app.tables["studentList"]
            .cells["studentCell.00000000-0000-0000-0000-000000000001"]
            .tap()

        let algorithmsButton = app.buttons["subjectButton.Algorithms"]
        XCTAssertTrue(algorithmsButton.exists)
        algorithmsButton.tap()

        let filteredList = app.tables["studentList"]
        XCTAssertTrue(app.navigationBars["Algorithms"].exists)
        XCTAssertTrue(filteredList.exists)
        XCTAssertTrue(filteredList.cells["studentCell.00000000-0000-0000-0000-000000000001"].exists)
        XCTAssertTrue(filteredList.cells["studentCell.00000000-0000-0000-0000-000000000002"].exists)
        XCTAssertFalse(filteredList.cells["studentCell.00000000-0000-0000-0000-000000000004"].exists)

        app.navigationBars["Algorithms"].buttons["Ada Lovelace"].tap()
        XCTAssertTrue(app.scrollViews["studentDetails"].exists)
    }

    func testAddStudentShowsDefaultsInListAndDetails() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["addStudentButton"].tap()
        XCTAssertTrue(app.navigationBars["Add Student"].exists)
        app.textFields["studentNameField"].tap()
        app.textFields["studentNameField"].typeText("New Student")
        app.textFields["studentAgeField"].tap()
        app.textFields["studentAgeField"].typeText("21")
        app.buttons["saveStudentButton"].tap()

        let list = app.tables["studentList"]
        XCTAssertTrue(app.navigationBars["Students"].exists)
        for _ in 0..<4 { list.swipeUp() }
        let newStudent = list.cells.matching(
            NSPredicate(format: "label CONTAINS %@", "New Student")
        ).firstMatch
        XCTAssertTrue(newStudent.exists)
        XCTAssertTrue(newStudent.label.contains("Age: 21"))
        XCTAssertTrue(newStudent.label.contains("Average grade: 0"))
        XCTAssertTrue(newStudent.label.contains("Scholarship: No"))

        newStudent.tap()
        XCTAssertTrue(app.staticTexts["Subjects:"].exists)
        XCTAssertTrue(app.staticTexts["None"].exists)
        XCTAssertTrue(app.staticTexts["Avatar asset: avatar-default"].exists)
    }

    func testEditStudentRefreshesDetailsAndList() {
        let app = XCUIApplication()
        app.launch()

        let ada = app.tables["studentList"]
            .cells["studentCell.00000000-0000-0000-0000-000000000001"]
        ada.tap()
        app.buttons["editStudentButton"].tap()

        XCTAssertTrue(app.navigationBars["Edit Student"].exists)
        replaceText(in: app.textFields["studentNameField"], with: "Augusta Ada King")
        replaceText(in: app.textFields["studentAgeField"], with: "21")
        app.buttons["saveStudentButton"].tap()

        XCTAssertTrue(app.navigationBars["Augusta Ada King"].exists)
        XCTAssertTrue(app.staticTexts["Name: Augusta Ada King"].exists)
        XCTAssertTrue(app.staticTexts["Age: 21"].exists)
        XCTAssertTrue(app.staticTexts["Average grade: 97.5"].exists)
        app.navigationBars["Augusta Ada King"].buttons["Students"].tap()
        XCTAssertTrue(ada.label.contains("Augusta Ada King"))
        XCTAssertTrue(ada.label.contains("Age: 21"))
    }

    func testSwipeToDeleteRemovesStudentFromList() {
        let app = XCUIApplication()
        app.launch()

        let list = app.tables["studentList"]
        let ada = list.cells["studentCell.00000000-0000-0000-0000-000000000001"]
        XCTAssertTrue(ada.exists)
        ada.swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertFalse(ada.exists)
        XCTAssertTrue(list.cells["studentCell.00000000-0000-0000-0000-000000000002"].exists)
    }

    func testFormRejectsBlankNameAndNonPositiveAge() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["addStudentButton"].tap()
        app.textFields["studentAgeField"].tap()
        app.textFields["studentAgeField"].typeText("0")
        app.buttons["saveStudentButton"].tap()
        XCTAssertTrue(app.staticTexts["Name cannot be blank."].exists)

        app.textFields["studentNameField"].tap()
        app.textFields["studentNameField"].typeText("Valid Name")
        app.buttons["saveStudentButton"].tap()
        XCTAssertTrue(app.staticTexts["Age must be greater than zero."].exists)
        XCTAssertTrue(app.navigationBars["Add Student"].exists)
    }

    private func replaceText(in field: XCUIElement, with replacement: String) {
        field.tap()
        let current = field.value as? String ?? ""
        field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        field.typeText(replacement)
    }
}
