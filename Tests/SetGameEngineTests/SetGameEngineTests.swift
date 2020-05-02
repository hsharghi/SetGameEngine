import XCTest
@testable import SetGameEngine

class Player: SetPlayer {
    var cardsWon = [Card]()
    var _ID: Int
    typealias PlayerID = Int
    
    required init(id: Int) {
        self._ID = id
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs._ID == rhs._ID
    }
    
    var score: Int {
        return cardsWon.count
    }
    
    func addScoreCards(cards: [Card]) {
        cardsWon.append(contentsOf: cards)
    }
    
    func removeFromScore(numberOfCards: Int) -> [Card] {
        var removedCards = [Card]()
        guard numberOfCards < cardsWon.count else {
            removedCards = cardsWon
            cardsWon.removeAll()
            return removedCards
        }
        
        for index in 0..<numberOfCards {
            removedCards.append(cardsWon.shuffled()[index])
        }
        
        cardsWon.remove(objects: removedCards)
        return removedCards
    }
    
    
}

final class SetGameEngineTests: XCTestCase {
    
    private func createGame(for numberOfPlayers: Int) -> Engine<Player> {
        var players = [Player]()
        for index in 0..<numberOfPlayers {
            players.append(Player(id: index))
        }
        return Engine<Player>(players: players)
    }
    
    func testPlayerCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let game = createGame(for: 1)
        XCTAssertEqual(game.players.count, 1)
        
        //        XCTAssertEqual(SetGameEngine.text, "Hello, World!")
    }
    
    func testPlayer_score() {
        let game = createGame(for: 1)
        var player = game.players.first!
        XCTAssertEqual(player.score, 0)
        
        game.addScore(of: [
            Card(color: .blue, fill: .empty, shape: .capsule, count: 1),
            Card(color: .red, fill: .empty, shape: .capsule, count: 1),
            Card(color: .green, fill: .empty, shape: .capsule, count: 1)],
                      to: &player)
        
        XCTAssertEqual(player.score, 3)
        
        _ = game.removeScore(count: 1, from: &player)
        
        XCTAssertEqual(player.score, 2)
        
        _ = game.removeScore(count: 10, from: &player)
        
        XCTAssertEqual(player.score, 0)

    }
    static var allTests = [
        ("testPlayerCount", testPlayerCount),
        ("testPlayer_score", testPlayer_score),
    ]
}
