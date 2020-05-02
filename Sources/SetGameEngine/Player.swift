//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 5/2/20.
//

import Foundation

public protocol SetPlayer: Equatable {

    init(id: PlayerID)
    
    associatedtype PlayerID
    var _ID: PlayerID { get set }
    var score: Int { get }
    mutating func addScoreCards(cards: [Card])
    mutating func removeFromScore(numberOfCards: Int) -> [Card]
}

