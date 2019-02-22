//
//  Solution862.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 21/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation

class Solution862 {
    func shortestSubarray(_ array: [Int], _ targertSum: Int) -> Int {
        var sums = Array(repeating: 0, count: array.count + 1)
        for index in 0..<array.count {
            sums[index + 1] = sums[index] + array[index]
        }
        var ans = array.count + 1;
        var possibleStart: [Int] = []
        for index in 0...array.count {

            while let last = possibleStart.last, sums[index] <= sums[last] {
                possibleStart.removeLast()
            }
            while let first = possibleStart.first, sums[index] >= sums[first] + targertSum {
                ans = min(ans, index - possibleStart.removeFirst())
            }
            possibleStart.append(index)
        }

        return ans < array.count + 1 ? ans : -1
    }
}
