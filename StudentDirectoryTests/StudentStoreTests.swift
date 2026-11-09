import XCTest
@testable import StudentDirectory

final class StudentStoreTests: XCTestCase {
    func testAlgorithmsFilterPreservesStoreOrder() {
        let names = StudentStore().students(matchingSubject: "Algorithms").map(\.name)

        XCTAssertEqual(names, [
            "Ada Lovelace",
            "Alan Turing",
            "Grace Hopper",
            "Edsger Dijkstra",
            "Donald Knuth"
        ])
    }

    func testSubjectFilterIsCaseSensitive() {
        let store = StudentStore()

        XCTAssertFalse(store.students(matchingSubject: "Math").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "math").isEmpty)
    }

    func testStoreUsesInjectedStudentsInsteadOfSeedData() {
        let ada = StudentSeedData.students[0]
        let katherine = StudentSeedData.students[3]
        let store = StudentStore(students: [katherine, ada])

        let studentIDs = store.students.map(\.id)
        let filteredIDs = store.students(matchingSubject: "Algorithms").map(\.id)
        XCTAssertEqual(studentIDs, [katherine.id, ada.id])
        XCTAssertEqual(filteredIDs, [ada.id])
    }

    func testAddStudentAppendsRequiredDefaults() throws {
        let store = StudentStore(students: [])

        try store.addStudent(name: "New Student", age: 21)

        XCTAssertEqual(store.students.count, 1)
        let student = store.students[0]
        XCTAssertEqual(student.name, "New Student")
        XCTAssertEqual(student.age, 21)
        XCTAssertEqual(student.averageGrade, 0)
        XCTAssertFalse(student.isScholarshipHolder)
        XCTAssertTrue(student.subjects.isEmpty)
        XCTAssertEqual(student.avatarName, "avatar-default")
    }

    func testAddStudentRejectsInvalidInputWithoutChangingStore() {
        let store = StudentStore()
        let originalIDs = store.students.map(\.id)

        XCTAssertThrowsError(try store.addStudent(name: "  \n", age: 20)) { error in
            guard case StudentStoreError.blankName = error else {
                return XCTFail("Expected blankName")
            }
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid", age: 0)) { error in
            guard case StudentStoreError.nonPositiveAge = error else {
                return XCTFail("Expected nonPositiveAge")
            }
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid", age: -1))
        XCTAssertEqual(store.students.map(\.id), originalIDs)
    }

    func testUpdateStudentChangesOnlyNameAndAge() throws {
        let store = StudentStore()
        let original = store.students[0]

        try store.updateStudent(id: original.id, name: "Augusta Ada King", age: 21)

        let updated = store.students[0]
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.name, "Augusta Ada King")
        XCTAssertEqual(updated.age, 21)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
    }

    func testUpdateStudentRejectsInvalidInputAndUnknownIDWithoutMutation() {
        let store = StudentStore()
        let originalNames = store.students.map(\.name)
        let originalAges = store.students.map(\.age)
        let id = store.students[0].id

        XCTAssertThrowsError(try store.updateStudent(id: id, name: " ", age: 21))
        XCTAssertThrowsError(try store.updateStudent(id: id, name: "Valid", age: 0))
        XCTAssertThrowsError(
            try store.updateStudent(id: unknownID, name: "Valid", age: 21)
        ) { error in
            guard case StudentStoreError.unknownID = error else {
                return XCTFail("Expected unknownID")
            }
        }
        XCTAssertEqual(store.students.map(\.name), originalNames)
        XCTAssertEqual(store.students.map(\.age), originalAges)
    }

    func testDeleteStudentRemovesOnlyMatchingIDAndRejectsUnknownID() throws {
        let store = StudentStore()
        let originalIDs = store.students.map(\.id)

        try store.deleteStudent(id: originalIDs[0])

        XCTAssertEqual(store.students.map(\.id), Array(originalIDs.dropFirst()))
        XCTAssertThrowsError(try store.deleteStudent(id: unknownID)) { error in
            guard case StudentStoreError.unknownID = error else {
                return XCTFail("Expected unknownID")
            }
        }
        XCTAssertEqual(store.students.map(\.id), Array(originalIDs.dropFirst()))
    }

    private var unknownID: UUID {
        UUID(uuid: (255, 255, 255, 255, 255, 255, 255, 255,
                    255, 255, 255, 255, 255, 255, 255, 255))
    }
}
