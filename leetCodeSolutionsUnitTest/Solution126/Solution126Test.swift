import XCTest

class Solution126Test: XCTestCase {

    var solution = Solution126()
    enum TestCases: String, Codable, CaseIterable {
        case zeroPathes
        case onePath
        case twoPathes
        case severalPathesWithIntersection
        case bigCase

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

    lazy var testData: [TestCases: Solution126TestDataUnit] = {
        let data: [TestCases: Solution126TestDataUnit] = loadTestData()
        return data
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
