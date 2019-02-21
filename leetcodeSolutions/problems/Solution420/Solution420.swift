//
//  Solution420.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 18/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation
class Solution420 {
    func strongPasswordChecker( _ str: String) -> Int {
        let lengthOperation = self.lengthOperations(for: str)
        var charactersRuleSatisfied = Array(repeating: false, count: 3)
        var currentChar: UnicodeScalar?
        var currentRepeatCount = 0
        var intervals: [Int] = []
        for scalar in str.unicodeScalars {
            if !charactersRuleSatisfied[0] {
                charactersRuleSatisfied[0] = CharacterSet.lowercaseLetters.contains(scalar)
            }
            if !charactersRuleSatisfied[1] {
                charactersRuleSatisfied[1] = CharacterSet.uppercaseLetters.contains(scalar)
            }
            if !charactersRuleSatisfied[2] {
                charactersRuleSatisfied[2] = CharacterSet.decimalDigits.contains(scalar)
            }
            if currentChar == scalar {
                currentRepeatCount += 1
            } else {
                if currentRepeatCount > 2 {
                    intervals.append(currentRepeatCount)
                }
                currentRepeatCount = 1
                currentChar = scalar
            }
        }
        if currentRepeatCount > 2 {
            intervals.append(currentRepeatCount)
        }
        let charactersRuleSatisfiedCount = charactersRuleSatisfied.reduce(0, {$1 ? $0 + 1 : $0})
        let characterOperation: Operation = charactersRuleSatisfiedCount == 3 ? .none : .insertOrReplace(3 - charactersRuleSatisfiedCount)

        switch lengthOperation {
        case .delete:
            var deleteCount = lengthOperation.count()
            intervals.sort()

            intervals = intervals.map { (intervalLength) -> Int in
                guard deleteCount != 0 else {
                    return intervalLength
                }

                if intervalLength % 3 == 0 {
                    deleteCount -= 1
                    return intervalLength - 1
                }
                return intervalLength
            }

            intervals = intervals.map { (intervalLength) -> Int in
                guard deleteCount != 0, intervalLength > 5 else {
                    return intervalLength
                }

                let intervalDiff = intervalLength - deleteCount

                if  intervalDiff >= 5 {
                    deleteCount = 0
                    return intervalDiff
                } else {
                    deleteCount -= intervalLength - 5
                    return 5
                }
            }

            intervals = intervals.map { (intervalLength) -> Int in
                guard deleteCount != 0 else {
                    return intervalLength
                }

                let intervalDiff = intervalLength - deleteCount

                if  intervalDiff >= 2 {
                    deleteCount = 0
                    return intervalDiff
                } else {
                    deleteCount -= intervalLength - 2
                    return 2
                }
            }

            return max(characterOperation.count(),
                       intervals.reduce(0, {$0 + numberOfInserts(for: $1)})) + lengthOperation.count()
        case .insertOrReplace, .none:
            return max(lengthOperation.count(),
                       characterOperation.count(),
                       intervals.reduce(0, {$0 + numberOfInserts(for: $1)}))
        }
    }

    private func numberOfInserts(for repeatCount: Int) -> Int {
        return repeatCount / 3
    }

    private func lengthOperations( _ minLength: Int = 6, _ maxLength: Int = 20, for str: String) -> Operation {
        if str.count < minLength {
            return .insertOrReplace(minLength - str.count)
        } else if str.count > maxLength {
            return .delete(str.count - maxLength)
        }
        return Operation.none
    }
}

extension Solution420 {
    enum Operation: Equatable {

        case delete(Int)
        case insertOrReplace(Int)
        case none

        func count() -> Int {
            switch self {
            case .delete(let count), .insertOrReplace(let count):
                return count
            case .none:
                return 0
            }
        }
    }
}
