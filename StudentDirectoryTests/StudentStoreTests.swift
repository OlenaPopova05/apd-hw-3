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
}
