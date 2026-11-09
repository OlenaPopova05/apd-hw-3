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
}
