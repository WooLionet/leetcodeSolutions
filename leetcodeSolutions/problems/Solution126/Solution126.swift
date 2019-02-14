//
//  Solution126.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 12/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation

class Solution126 {

    var adjacentList: [String: [String]] = [:]

    func addEdge(_ leftNode: String, _ rightNode: String) {
        adjacentList[leftNode, default: []].append(rightNode)
        adjacentList[rightNode, default: []].append(leftNode)
    }

    func buildGraph(_ wordList: Set<String>) {
        adjacentList = [:]
        var nodesMap: [String: [String]] = [:]
        for word in wordList {
            for index in 0..<word.count {
                var chars = Array(word)
                chars[index] = "."
                let commonWord = String(chars)
                for node in nodesMap[commonWord, default: []] {
                    addEdge(node, word)
                }
                nodesMap[commonWord, default: []].append(word)
            }
        }
    }

    func biderectionalBrethFirstSearch(_ beginWord: String, _ target: String) -> [[String]] {

        var leftVisited: Set<String> = [beginWord]
        var leftPathsToSearch = [[beginWord]]
        var leftNextToSearch: [[String]] = []
        var leftNewNodes = Set<String>()

        var rightVisited: Set<String> = [target]
        var rightPathsToSearch = [[target]]
        var rightNextToSearch: [[String]] = []
        var rightNewNodes = Set<String>()

        var intersection = Set<String>()
        while !leftPathsToSearch.isEmpty {
            for path in leftPathsToSearch {
                guard let node = path.last else {continue}
                for nextNode in adjacentList[node, default: []] where !leftVisited.contains(nextNode) {
                    leftNextToSearch.append(path + [nextNode])
                    leftNewNodes.insert(nextNode)
                }
            }
            leftVisited.formUnion(leftNewNodes)
            leftPathsToSearch = leftNextToSearch
            leftNextToSearch = []

            intersection = leftVisited.intersection(rightVisited)
            if !intersection.isEmpty {
                break
            }

            for path in rightPathsToSearch {
                guard let node = path.last else {continue}
                for nextNode in adjacentList[node, default: []] where !rightVisited.contains(nextNode) {
                    rightNextToSearch.append(path + [nextNode])
                    rightNewNodes.insert(nextNode)
                }
            }
            rightVisited.formUnion(rightNewNodes)
            rightPathsToSearch = rightNextToSearch
            rightNextToSearch = []

            intersection = leftVisited.intersection(rightVisited)
            if !intersection.isEmpty {
                break
            }
        }

        var foundPathes = [[String]]()
        for left in leftPathsToSearch {
            guard let last = left.last, intersection.contains(last) else {continue}
            for right in rightPathsToSearch {
                guard let rightLast = right.last, rightLast == last else {continue}
                foundPathes.append(left + right.dropLast().reversed())
            }
        }
        return foundPathes
    }

    func findLadders(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> [[String]] {
        buildGraph(Set(wordList + [beginWord]))
        return biderectionalBrethFirstSearch(beginWord, endWord)
    }
}
