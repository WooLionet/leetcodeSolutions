//
//  Solution149.swift
//  leetcodeSolutions
//
//  Created by  Pavel Himach on 15/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import Foundation

class Solution149 {
    func maxPoints(_ points: [Point]) -> Int {
        guard points.count > 1 else {
            return points.count
        }
        var points = points
        points.sort { (left, right) -> Bool in
            return left.x < right.x
        }
        var pointsOnLine = [Line: Int]()
        var pointsSets = [Set<Point>]()
        var max = 0
        for leftIndex in 0..<(points.count - 1) {
            let  leftPoint = points[leftIndex]
            for rightIndex in (leftIndex + 1)..<points.count {
                let  rightPoint = points[rightIndex]
                let line = Line(leftPoint, rightPoint.x - leftPoint.x, rightPoint.y - leftPoint.y)
                var index = pointsOnLine[line, default: -1]
                if index < 0 {
                    pointsSets.append(Set([leftPoint, rightPoint]))
                    index = pointsSets.count - 1
                    pointsOnLine[line] = index
                } else {
                    pointsSets[index].insert(leftPoint)
                    pointsSets[index].insert(rightPoint)
                }
                if pointsSets[index].count > max {max = pointsSets[index].count}
            }
        }

        return max
    }

    public class Line: Hashable {

        enum LineType: Int {
            case point, vertical, horizontal, ordinary
        }

        let type: LineType
        let start: Point
        let diffx: Int
        let diffy: Int

        init( _ start: Point, _ diffx: Int, _ diffy: Int) {
            self.start = start
            self.diffx = diffx
            self.diffy = diffy
            switch (diffx, diffy) {
            case (0, 0):
                self.type = .point
            case (0, _):
                self.type = .vertical
            case (_, 0):
                self.type = .horizontal
            default:
                self.type = .ordinary
            }
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(type)
            switch type {
            case .point:
                hasher.combine(start)
            case .vertical:
                hasher.combine(start.x)
            case .horizontal:
                hasher.combine(start.y)
            case .ordinary:
                hasher.combine(diffx/diffy)
            }
        }

        public static func == (lhs: Line, rhs: Line) -> Bool {

            guard lhs.type == rhs.type else {
                return false
            }
            let sameStart = lhs.start.x == rhs.start.x && lhs.start.y == rhs.start.y
            switch lhs.type {
            case .point:
                return sameStart
            case .horizontal:
                return lhs.start.y == rhs.start.y
            case .vertical:
                return lhs.start.x == rhs.start.x
            case .ordinary:
                var lTan = lhs.diffy * rhs.diffx
                var rTan = rhs.diffy * lhs.diffx

                guard lTan == rTan else {
                    return false
                }

                if sameStart {return true}

                guard lhs.start.x != rhs.start.x else {
                    return false
                }
                let startDiffx = lhs.start.x - rhs.start.x
                let startDiffy = lhs.start.y - rhs.start.y
                lTan = startDiffy * rhs.diffx
                rTan = rhs.diffy * startDiffx
                return lTan == rTan
            }
        }
    }
}

extension Solution149 {
    public class Point: Hashable, Decodable {
        public var x: Int
        public var y: Int
        public init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        public static func == (lhs: Solution149.Point, rhs: Solution149.Point) -> Bool {
            return lhs === rhs
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }

    }

}
