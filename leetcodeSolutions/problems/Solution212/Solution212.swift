//
//  solution212.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 01/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

class Solution212 {
    var charMap: [Character: [BoardIndex]] = [Character: [BoardIndex]]()
    var pathesCahce: [PathIndex: [Path]] = [PathIndex: [Path]]()
    var boardSize: Size = Size(rowCount: 0, columnCount: 0)
    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {

        guard !words.isEmpty, !board.isEmpty else {
            return []
        }

        self.charMap = mapCharacters(board)
        self.boardSize = board.size()

        var ans = Set<String>()

        for word in words {
            guard !word.isEmpty else {
                continue
            }
            guard !ans.contains(word) else {
                continue
            }
            guard let firstChar = word.first, let lastChar = word.last,
                let possibleStarts = charMap[firstChar], let possibleEnds = charMap[lastChar] else {
                    continue
            }
            if possibleStarts.first(where: { (start) -> Bool in
                return possibleEnds.first(where: { (end) -> Bool in
                    return BoardIndex.isReachable(start, end, word) &&
                           !findPath(board, start, end, word).isEmpty
                }) != nil
            }) != nil {
                ans.insert(word)
            }

        }
        self.charMap = [Character: [BoardIndex]]()
        self.pathesCahce = [PathIndex: [Path]]()
        return ans.map({$0})
    }
}

extension Solution212 {

    func mapCharacters(_ board: [[Character]]) -> [Character: [BoardIndex]] {

        var charMap = [Character: [BoardIndex]]()

        for (rowIndex, row) in board.enumerated() {

            for (columnIndex, char) in row.enumerated() {

                let boardIndex = BoardIndex(row: rowIndex, column: columnIndex)

                if var indexes = charMap[char] {
                    indexes.append(boardIndex)
                    charMap[char] = indexes
                } else {
                    charMap[char] = [boardIndex]
                }
            }
        }
        return charMap
    }

    func findPath(_ board: [[Character]], _ start: BoardIndex, _ end: BoardIndex, _ word: [Character]) -> [Path] {
        return self.findPath(board, start, end, ArraySlice(word))
    }

    func findPath(_ board: [[Character]], _ start: BoardIndex, _ end: BoardIndex, _ word: String) -> [Path] {
        return self.findPath(board, start, end, ArraySlice(word))
    }

    func findPath(_ board: [[Character]], _ start: BoardIndex, _ end: BoardIndex, _ word: ArraySlice<Character>) -> [Path] {
        switch word.count {
        case 1:
            var visitedMap = Array(repeating: Array(repeating: false, count: boardSize.columnCount), count: boardSize.rowCount)
            visitedMap[start.row][start.column] = true
            return [Path(start: start, end: end, visited: visitedMap)]

        case 2:
            var visitedMap = Array(repeating: Array(repeating: false, count: boardSize.columnCount), count: boardSize.rowCount)
            visitedMap[start.row][start.column] = true
            visitedMap[end.row][end.column] = true
            return [Path(start: start, end: end, visited: visitedMap)]

        default:
            guard start != end else {
                return []
            }
            let pathIndex = PathIndex(start: start, end: end, string: String(word))
            if let pathes = pathesCahce[pathIndex] {
                return pathes
            } else {
                var pathes = [Path]()
                let leftNeighbors = start.neighbors(self.boardSize)
                let rightNeighbors = end.neighbors(self.boardSize)
                let subString = word.dropFirst().dropLast()
                for leftNeighbor in leftNeighbors {
                    for rightNeighbor in rightNeighbors {
                        if BoardIndex.isReachable(leftNeighbor, rightNeighbor, subString),
                            board[leftNeighbor.row][leftNeighbor.column] == subString.first,
                            board[rightNeighbor.row][rightNeighbor.column] == subString.last {
                            for path in findPath(board, leftNeighbor, rightNeighbor, subString) {
                                var visited = path.visited
                                if !visited[start.row][start.column],
                                    !visited[end.row][end.column] {
                                    visited[start.row][start.column] = true
                                    visited[end.row][end.column] = true
                                    pathes.append(Path(start: start, end: end, visited: visited))
                                }
                            }
                        }
                    }
                }
                pathesCahce[pathIndex] = pathes
                return pathes
            }
        }
    }
}

extension Array where Element == [Character] {

    func size() -> Solution212.Size {
        guard let row = self.first else {
            return Solution212.Size(rowCount: 0, columnCount: 0)
        }
        return Solution212.Size(rowCount: self.count, columnCount: row.count)
    }

    subscript(index: Solution212.BoardIndex) -> Character {
        return self[index.row][index.column]
    }
}
