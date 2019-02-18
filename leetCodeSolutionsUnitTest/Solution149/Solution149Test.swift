import XCTest

class Solution149Test: XCTestCase {

    var solution = Solution149()
    enum TestCases: String, CodableEnum {
        case threePointsOneLine
        case threePointsOneLineNegative
        case onePointSeveralTimes
        case bigCase
        case onePoint
        case emptyCase
    }

    lazy var testData: [TestCases: Solution149TestDataUnit] = {
        return loadTestData()
    }()

    func testAllExamples() {
        for dataUnit in testData.values {
            XCTAssert(solution.maxPoints(dataUnit.points) == dataUnit.expectedResult, dataUnit.description)
        }
    }
}
