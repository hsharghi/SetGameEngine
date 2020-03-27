//
//  Card.swift
//  SetGame
//
//  Created by Hadi Sharghi on 3/22/20.
//  Copyright © 2020 Hadi Sharghi. All rights reserved.
//

import Foundation

public class Card {
    
    
    internal init(color: Card.Color, fill: Card.Fill, shape: Card.Shape, count: Int) {
        self.color = color
        self.fill = fill
        self.shape = shape
        self.count = count
    }
    
    var debugDescription: String {
        return self.description
    }

    public enum Color: Int, CaseIterable {
        case red, green, blue
    
        public static func < (a: Card.Color, b: Card.Color) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    public enum Fill: Int, CaseIterable {
        case empty, hatch, solid
    
        public static func < (a: Card.Fill, b: Card.Fill) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    public enum Shape: Int, CaseIterable {
        case capsule, eyebrow, rhombus

        public static func < (a: Card.Shape, b: Card.Shape) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    public enum Count: Int, CaseIterable {
        case one = 1
        case two = 2
        case tree = 3

        public static func < (a: Card.Count, b: Card.Count) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    public var color: Color
    public var fill: Fill
    public var shape: Shape
    public var count: Int
    
    
    
}
extension Card: Comparable {
    public static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.count < rhs.count { return true }
        if lhs.count == rhs.count {
            if lhs.fill < rhs.fill { return true }
            if lhs.fill == rhs.fill {
                if lhs.color < rhs.color { return true }
                if lhs.color == rhs.color {
                    if lhs.shape < rhs.shape { return true }
                    return false
                }
                return false
            }
            return false
        }
        return false
    }
    
    
}

extension Card: Equatable {
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color && lhs.count == rhs.count && lhs.fill == rhs.fill && lhs.shape == rhs.shape
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        return "\(self.count) - \(self.color) - \(self.fill) - \(self.shape)\n"
    }
}
