//
//  Solution992.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 25/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation
class Solution992 {
    func findJudge(_ peoplesCount: Int, _ trust: [[Int]]) -> Int {
        guard peoplesCount != 1 else {
            return 1
        }
        var trustToCounters = Array(repeating: 0, count: peoplesCount)
        var trustByCounters = Array(repeating: 0, count: peoplesCount)
        for edge in trust {
            guard let person = edge.first, let trustedPerson = edge.last else {
                fatalError()
            }
            trustToCounters[person - 1] += 1
            trustByCounters[trustedPerson - 1] += 1
        }
        var ans = -2
        var matchCounter = 0
        for (index, trustToCounter) in trustToCounters.enumerated() where trustToCounter == 0 && trustByCounters[index] == peoplesCount - 1 {
            guard matchCounter < 1 else {
                return -1
            }
            matchCounter += 1
            ans = index
        }
        return ans + 1
    }
}
