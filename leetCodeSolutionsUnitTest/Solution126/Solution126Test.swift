import XCTest

class Solution126Test: XCTestCase {

    var solution = Solution126()
    enum TestCases: String, CodableEnum {
        case zeroPathes
        case onePath
        case twoPathes
        case severalPathesWithIntersection
        case bigCase
    }

    lazy var testData: [TestCases: Solution126TestDataUnit] = {
        return loadTestData()
    }()

    func testAllExamples() {

        for dataUnit in testData.values {
            XCTAssert(
                isEqual(solution.findLadders(dataUnit.beginWord,
                                             dataUnit.endWord,
                                             dataUnit.words),
                        dataUnit.expectedResult), dataUnit.description)
        }
    }

    func isEqual( _ lPathes: [[String]], _ rPathes: [[String]]) -> Bool {
        guard rPathes.count == lPathes.count else {
            return false
        }
        var matchCount = 0
        for lPath in lPathes {
            for rPath in rPathes {
                let lSet = Set(lPath)
                let rSet = Set(rPath)
                if lSet == rSet {
                    matchCount += 1
                    continue
                }
            }
        }
        return matchCount == lPathes.count
    }
}
