//
//  GameEngine.swift
//  SetGame
//
//  Created by Hadi Sharghi on 3/22/20.
//  Copyright © 2020 Hadi Sharghi. All rights reserved.
//

import Foundation

public protocol GameEngineDelegate: class {
    func noSetFound()
    func noMoreCards()
    func gameEnded()
}

public class Engine<T: SetPlayer> {
    
    public weak var delegate: GameEngineDelegate?
    
    private var cardStock: [Card] {
        didSet {
            if cardStock.count == 0 {
                checkForGameEnd()
                delegate?.noMoreCards()
            }
        }
    }
    
    private var cardsOnTable: [Card] {
        didSet {
            if !isSetExists() {
                delegate?.noSetFound()
            }
        }
    }
    
    private func checkForGameEnd() {
        if !isSetExists() {
            delegate?.gameEnded()
        }
    }
    
    private func isSetExists() -> Bool {
        return findAllSets(in: cardsOnTable).count > 0
    }
    
    private var _players: [T]
    
    public var players: [T] {
        get {
            return _players
        }
    }
    
    public init(players: [T]) {
        
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
        self._players = players
    }
    
    public var pileOfCards: [Card] {
        return cardStock
    }
    
    public var playingCards: [Card] {
        return cardsOnTable
    }
    
    public func draw() -> [Card] {
        guard cardsOnTable.count < 12 else { return playingCards }
        guard cardStock.count > 0 else { return [] }
        
        let slice = min(cardStock.count, 12 - cardsOnTable.count)
        let newCards = Array(cardStock.shuffled().prefix(through: slice - 1))
        
        cardStock.remove(objects: newCards)
        cardsOnTable += newCards
        
        return newCards
    }
    
    public func redraw() -> [Card] {
        cardStock += cardsOnTable
        return draw()
    }
    
    public func addCards() -> [Card] {
        guard cardsOnTable.count < 15 else { return playingCards }
        let newCards = Array(cardStock.shuffled().prefix(through: 15 - cardsOnTable.count - 1))
        cardStock.remove(objects: newCards)
        cardsOnTable += newCards
        
        return playingCards
    }
    
    public func addScore(of cards: [Card], to player: inout T) {
        player.addScoreCards(cards: cards)
    }
    
    public func removeScore(count: Int, from player: inout T) -> [Card] {
        return player.removeFromScore(numberOfCards: count)
    }
    
    public func setFound(set: [Card], for player: inout T) -> [Card] {
        guard isSet(of: set) else { return playingCards }
        
        cardsOnTable.remove(objects: set)
        addScore(of: set, to: &player)
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
