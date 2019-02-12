//
//  Solution212.BoardIndex.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 12/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation

extension Solution212 {

    struct Size {
        let rowCount: Int
        let columnCount: Int
    }

    struct BoardIndex: Equatable, Hashable {
        let row: Int
        let column: Int

        static func isReachable<T: Collection>(_ start: BoardIndex, _ end: BoardIndex, _ word: T) -> Bool {
            let distance = abs(start.row - end.row) + abs(start.column - end.column)

            return distance <= word.count && distance % 2 == (word.count - 1) % 2
        }
        
        func neighbors(_ boardSize: Size) -> [BoardIndex] {
            var array = [BoardIndex]()
            if self.row > 0 {
                array.append(BoardIndex(row: self.row - 1, column: self.column))
            }
            if self.row < boardSize.rowCount - 1 {
                array.append(BoardIndex(row: self.row + 1, column: self.column))
            }
            if self.column > 0 {
                array.append(BoardIndex(row: self.row, column: self.column - 1))
            }
            if self.column < boardSize.columnCount - 1 {
                array.append(BoardIndex(row: self.row, column: self.column + 1))
            }
            return array
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(row)
            hasher.combine(column)
        }
    }

    struct Path {
        let start: BoardIndex
        let end: BoardIndex
        let visited: [[Bool]]
    }

    struct PathIndex: Equatable, Hashable {
        let start: BoardIndex
        let end: BoardIndex
        let string: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(start)
            hasher.combine(end)
            hasher.combine(string)
        }
    }
}
