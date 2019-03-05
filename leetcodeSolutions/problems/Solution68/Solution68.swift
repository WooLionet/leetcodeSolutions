//
//  Solution68.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 25/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation
class Solution68 {
    func fullJustify(_ words: [String], _ maxWidth: Int) -> [String] {
        var ans: [String] = []
        var index = 0
        var startIndex = 0
        var lineWords: [String] = []
        var currentLength = 0
        while index < words.count {
            let word = words[index]
            if currentLength + index - startIndex + word.count <= maxWidth {
                lineWords.append(word)
                currentLength += word.count
                index += 1
            } else {
                currentLength = 0
                startIndex = index
                ans.append(fillSpaces(lineWords, maxWidth))
                lineWords = []
            }
        }
        ans.append(fillSpaces(lineWords, maxWidth, true))
        return ans
    }

    func fillSpaces( _ words: [String], _ maxWidth: Int, _ isLastLine: Bool = false) -> String {
        let spacesCount = isLastLine ? 1 : maxWidth - words.reduce(0, {$0 + $1.count})
        let intervalsCount = words.count - 1
        var str = ""
        for (index, word) in words.enumerated() {
            str.append(word)
            guard index != words.count - 1 else {
                break
            }
            let count = isLastLine ? 1 : spacesCount / intervalsCount + (index < spacesCount % intervalsCount ? 1 : 0)
            let spaces = String(repeating: " ", count: count)
            str.append(spaces)
        }
        if str.count < maxWidth {
            let spaces = String(repeating: " ", count: maxWidth - str.count )
            str += spaces
        }

        return str
    }
}
