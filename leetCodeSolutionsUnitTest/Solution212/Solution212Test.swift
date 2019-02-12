import XCTest

class Solution212Test: XCTestCase {

    var solution = Solution212()
    enum TestCases: String, Codable, CaseIterable {
        case bigCase
        case empty
        case circle
        case singleChar
        case wordBiggerThenBoard
        case general

        struct Errors {
            static func dataCorrupted() -> DecodingError {
                return DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "cant get case name from container"))
            }
            static func valueNotFound(_ value: String) -> DecodingError {
                return DecodingError.valueNotFound(TestCases.self,
                                                   .init(codingPath: [],
                                                   debugDescription: "can't decode string to enum value: \(value)"))
            }
        }

        init(from decoder: Decoder) throws {
            guard let string = try decoder.singleValueContainer().decode([String].self).first else {
                 throw Errors.dataCorrupted()
            }

            for value in TestCases.allCases where value.rawValue == string {
                    self = value
                    return
            }
            throw Errors.valueNotFound(string)
        }

        func  encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(self.rawValue)
        }
    }

    lazy var testData: [TestCases: Solution212TestDataUnit] = {
        let data: [TestCases: Solution212TestDataUnit] = loadTestData()
        return data
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

        self.measure {
            for dataUnit in testData.values {
                XCTAssert(solution.findWords(dataUnit.board, dataUnit.words).sorted() == dataUnit.expectedResult, dataUnit.description)
            }
        }
    }
}
