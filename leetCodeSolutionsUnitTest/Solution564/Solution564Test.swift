import XCTest

class Solution564Test: XCTestCase {

    var solution = Solution564()
    enum TestCases: String, CodableEnum {
        case zero
        case one
        case nine
        case ten
        case oneThousand
        case bigNumber
    }

    lazy var testData: [TestCases: Solution564TestDataUnit] = {
        return loadTestData()
    }()

    func testAllExamples() {
        for dataUnit in testData.values {
            XCTAssert(solution.nearestPalindromic(dataUnit.number) == dataUnit.expectedResult, dataUnit.description)
        }
    }
}
