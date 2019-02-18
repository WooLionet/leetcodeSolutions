//
//  Solution%64.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 18/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation

class Solution564 {
    func nearestPalindromic(_ numStr: String) -> String {
        guard !numStr.isEmpty else {
            return numStr
        }
        guard numStr != "0" else {
            return "1"
        }

        let num = self.conertToArray(numStr)
        let palindrome = self.getPlaindrome(for: num)

        return convertToString(palindrome)
    }

    private func getPlaindrome(for num: [Int]) -> [Int] {
        var mirror = num
        var low = num
        var high = num

        var lowExtra = -1
        var highExtra = 1
        for index in (0..<(num.count / 2 + num.count % 2)).reversed() {
            let rightIndex = num.count - 1 - index
            mirror[rightIndex] = num[index]
            if lowExtra != 0 {
                let number = num[index] - 1
                if number < 0 {
                    lowExtra = -1
                    low[rightIndex] = 9
                    low[index] = low[rightIndex]
                } else {
                    lowExtra = 0
                    low[rightIndex] = number
                    low[index] = number
                }
            } else {
                let number = num[index]
                low[rightIndex] = number
                low[index] = low[rightIndex]
            }

            if highExtra != 0 {
                let number = num[index] + 1
                if number == 10 {
                    highExtra = 1
                    high[rightIndex] = number % 10
                    high[index] = high[rightIndex]
                } else {
                    highExtra = 0
                    high[rightIndex] = number
                    high[index] = number
                }
            } else {
                let number = num[index]
                high[rightIndex] = number
                high[index] = high[rightIndex]
            }

        }

        if highExtra != 0 {
            high.insert(1, at: 0)
            high[high.endIndex - 1] = 1
        }

        if low.count > 1, low.first == 0 {
            low[low.endIndex - 1] = 9
        }

        var lowestDiff = Int.max
        var palindrome = low
        let num = numFromArray(num)
        let mirrorDiff = abs(numFromArray(mirror) - num)
        let lowDiff = num - numFromArray(low)
        let highDiff = numFromArray(high) - num

        if lowestDiff > lowDiff {
            palindrome = low
            lowestDiff = lowDiff
        }

        if mirrorDiff != 0, lowestDiff > mirrorDiff {
            palindrome = mirror
            lowestDiff = mirrorDiff
        }

        if lowestDiff > highDiff {
            palindrome = high
            lowestDiff = highDiff
        }
        return palindrome
    }

    private func numFromArray( _ array: [Int]) -> Int {
        return array.reduce(0, {$0 * 10 + $1})
    }

}
extension Solution564 {
    private enum Errors: Error {
        case charToIntConversionError
    }

    private func conertToArray(_ numStr: String) -> [Int] {

        var array = [Int]()
        do {
            array = try numStr.map({ (char) -> Int in
                switch char {
                case "0":
                    return 0
                case "1":
                    return 1
                case "2":
                    return 2
                case "3":
                    return 3
                case "4":
                    return 4
                case "5":
                    return 5
                case "6":
                    return 6
                case "7":
                    return 7
                case "8":
                    return 8
                case "9":
                    return 9
                default :
                    throw Errors.charToIntConversionError
                }
            })
        } catch {
            return []
        }
        return array
    }

    private func dropFirstIfZero( _ array: [Int]) -> ArraySlice<Int> {
        if array.count > 1, array.first == 0 {
            return array.dropFirst()
        }
        return ArraySlice(array)
    }

    private func convertToString( _ array: [Int]) -> String {
        return dropFirstIfZero(array).map({String($0)}).joined()
    }

}
