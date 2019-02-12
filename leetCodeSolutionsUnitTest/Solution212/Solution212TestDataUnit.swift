import Foundation
class Solution212TestDataUnit {

    let board: [[Character]]
    let words: [String]
    let expectedResult: [String]
    let description: String
    init(board: [[Character]], words: [String], expectedResult: [String], description: String ) {
        assert(expectedResult.count >= words.count, "can't expect more words then provide")
        self.board = board
        self.words = words.sorted()
        self.expectedResult = expectedResult.sorted()
        self.description = description
    }

    enum Errors: Error {
        case unexpectedStringInBoard
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        words = try values.decode([String].self, forKey: .words).sorted()
        expectedResult = try values.decode([String].self, forKey: .expectedResult).sorted()
        description = try values.decode(String.self, forKey: .description)
        let stringBoard = try values.decode([[String]].self, forKey: .board)
        board = try stringBoard.map({try $0.map({(str) -> Character in
            guard str.count == 1, let char = str.first else {
                throw Errors.unexpectedStringInBoard
            }
            return char
            })
        })
    }
}

extension Solution212TestDataUnit: Codable {

    enum CodingKeys: String, CodingKey {
        case board
        case words
        case expectedResult
        case description
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let stringBoard = board.map({$0.map({String($0)})})
        try container.encode(stringBoard, forKey: .board)
        try container.encode(words, forKey: .words)
        try container.encode(expectedResult, forKey: .expectedResult)
        try container.encode(description, forKey: .description)

    }
}
