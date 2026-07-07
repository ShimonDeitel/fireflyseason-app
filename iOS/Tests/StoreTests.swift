import XCTest
@testable import Fireflyseason

final class StoreTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(LogEntry(location: "Test", intensity: "Value", notes: "Note"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testNewestEntryInsertedFirst() {
        store.add(LogEntry(location: "First", intensity: "A", notes: ""))
        store.add(LogEntry(location: "Second", intensity: "B", notes: ""))
        XCTAssertEqual(store.entries.first?.location, "Second")
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtFreeLimit() {
        for i in 0..<Store.freeTierLimit {
            store.add(LogEntry(location: "Item \(i)", intensity: "V", notes: ""))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBeyondLimitIsNoOp() {
        for i in 0..<Store.freeTierLimit {
            store.add(LogEntry(location: "Item \(i)", intensity: "V", notes: ""))
        }
        let countAtLimit = store.entries.count
        store.add(LogEntry(location: "Overflow", intensity: "V", notes: ""))
        XCTAssertEqual(store.entries.count, countAtLimit)
    }

    func testDeleteAtOffsetsRemovesEntry() {
        store.add(LogEntry(location: "ToDelete", intensity: "V", notes: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntryModifiesExisting() {
        store.add(LogEntry(location: "Original", intensity: "V", notes: ""))
        var entry = store.entries[0]
        entry.location = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries[0].location, "Updated")
    }

    func testFreeTierLimitExceedsSeedCount() {
        XCTAssertGreaterThan(Store.freeTierLimit, 3)
    }
}
