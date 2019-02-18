import XCTest

class Solution212Test: XCTestCase {

    var solution = Solution212()
    enum TestCases: String, CodableEnum {
        case bigCase
        case empty
        case circle
        case singleChar
        case wordBiggerThenBoard
        case general
    }

    lazy var testData: [TestCases: Solution212TestDataUnit] = {
        return loadTestData()
    }()

    func testEmptyState() {
        guard let dataUnit = testData[.empty] else {
            XCTAssertNotNil(testData[.empty])
            return
        }
        XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
    }

    func testCircleState() {
        guard let dataUnit = testData[.circle] else {
            XCTAssertNotNil(testData[.empty])
            return
        }
        XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
    }

    func testSingleCharState() {
        guard let dataUnit = testData[.singleChar] else {
            XCTAssertNotNil(testData[.empty])
            return
        }
        XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
    }

    func testGeneralState() {
        guard let dataUnit = testData[.general] else {
            XCTAssertNotNil(testData[.empty])
            return
        }
        XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
    }

    func testBigDataExample() {
        guard let dataUnit = testData[.bigCase] else {
            XCTAssertNotNil(testData[.empty])
            return
        }
        print(solution.findWords(dataUnit.board, dataUnit.words).sorted())
        XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
    }

    func testWordBiggerThenBoardExample() {
        guard let dataUnit = testData[.wordBiggerThenBoard] else {
            XCTAssertNotNil(testData[.empty])
            return
        }
        print(solution.findWords(dataUnit.board, dataUnit.words).sorted())
        XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
    }

    func testPerformanceExample() {
        for dataUnit in testData.values {
            XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
        }
    }
}
