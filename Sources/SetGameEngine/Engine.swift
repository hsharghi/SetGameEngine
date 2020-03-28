//
//  GameEngine.swift
//  SetGame
//
//  Created by Hadi Sharghi on 3/22/20.
//  Copyright © 2020 Hadi Sharghi. All rights reserved.
//

import Foundation

public class Engine {
    private var cardStock: [Card]
    private var cardsOnTable: [Card]
    private var players: Int = 1
    
    public init(players: Int) {
        
        var cards = [Card]()
        
        for shape in Card.Shape.allCases {
            for color in Card.Color.allCases {
                for fill in Card.Fill.allCases {
                    for count in Card.Count.allCases {
                        cards.append(Card(color: color, fill: fill, shape: shape, count: count.rawValue))
                    }
                }
            }
        }
        self.cardStock = cards
        self.cardsOnTable = []
        self.players = players
    }
    
    public var pileOfCards: [Card] {
        return cardStock
    }
    
    public var playingCards: [Card] {
        return cardsOnTable
    }
    
    public func draw() -> [Card] {
        guard cardsOnTable.count < 12 else { return playingCards }
        let newCards = Array(cardStock.shuffled().prefix(through: 12 - cardsOnTable.count - 1))
        cardStock.remove(objects: newCards)
        cardsOnTable += newCards
        
        return newCards
    }
    
    public func addCards() -> [Card] {
        guard cardsOnTable.count < 15 else { return playingCards }
        let newCards = Array(cardStock.shuffled().prefix(through: 15 - cardsOnTable.count - 1))
        cardStock.remove(objects: newCards)
        cardsOnTable += newCards
        
        return playingCards
    }
    
    public func setFound(set: [Card]) -> [Card] {
        cardsOnTable.remove(objects: set)
        return playingCards
    }
    
    public func findSet(in cards: [Card], except: [Card]? = nil) -> [Card]? {
        let combinations = self.combinations(source: cards, takenBy: 3).shuffled()
        
        for setOfCards in combinations {
            if isSet(of: setOfCards) {
                if except != nil && combinations.count > 1 {
                    if except!.sorted() == setOfCards.sorted() {
                        print("existing set\n")
                        continue
                    }
                }
                return setOfCards
            }
        }
        
        return nil
    }
    
    public func findAllSets(in cards: [Card]) -> [[Card]] {
        var sets = [[Card]]()
        let combinations = self.combinations(source: cards, takenBy: 3).shuffled()
        for setOfCards in combinations {
            if isSet(of: setOfCards) {
                sets.append(setOfCards)
            }
        }
        
        return sets
    }
    
    public func removeFromTable(cards: [Card]) {
        cardsOnTable.remove(objects: cards)
    }
    
    private func getCardsFromStock(count: Int) -> [Card] {
        guard count > 0 else { return [] }
        let cards = Array(cardStock.shuffled().prefix(through: count - 1))
        cards.forEach{ cardStock.remove(object: $0) }
        return cards
    }
    
    public func isSet(of cards: [Card]) -> Bool {
        
        guard cards.count == 3 else {
            return false
        }
        
        return setOfFill(fills: cards.compactMap{$0.fill}) &&
            setOfShape(shapes: cards.compactMap{$0.shape}) &&
            setOfColor(colors: cards.compactMap{$0.color}) &&
            setOfCount(counts: cards.compactMap{$0.count})
    }
    
    private func setOfShape(shapes: [Card.Shape]) -> Bool {
        return (shapes[0] != shapes[1] && shapes[0] != shapes[2] && shapes[1] != shapes[2]) ||
            (shapes[0] == shapes[1] && shapes[0] == shapes[2] && shapes[1] == shapes[2])
    }
    
    private func setOfColor(colors: [Card.Color]) -> Bool {
        return (colors[0] != colors[1] && colors[0] != colors[2] && colors[1] != colors[2]) ||
            (colors[0] == colors[1] && colors[0] == colors[2] && colors[1] == colors[2])
    }
    
    private func setOfFill(fills: [Card.Fill]) -> Bool {
        return (fills[0] != fills[1] && fills[0] != fills[2] && fills[1] != fills[2]) ||
            (fills[0] == fills[1] && fills[0] == fills[2] && fills[1] == fills[2])
    }
    
    private func setOfCount(counts: [Int]) -> Bool {
        return (counts[0] != counts[1] && counts[0] != counts[2] && counts[1] != counts[2]) ||
            (counts[0] == counts[1] && counts[0] == counts[2] && counts[1] == counts[2])
    }
    
    func combinations<T>(source: [T], takenBy : Int) -> [[T]] {
        if(source.count == takenBy) {
            return [source]
        }
        
        if(source.isEmpty) {
            return []
        }
        
        if(takenBy == 0) {
            return []
        }
        
        if(takenBy == 1) {
            return source.map { [$0] }
        }
        
        var result : [[T]] = []
        
        let rest = Array(source.suffix(from: 1))
        let subCombos = combinations(source: rest, takenBy: takenBy - 1)
        result += subCombos.map { [source[0]] + $0 }
        result += combinations(source: rest, takenBy: takenBy)
        return result
    }
}
