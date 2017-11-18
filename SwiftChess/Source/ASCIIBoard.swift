//
//  File.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 08/10/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

func transformASCIIBoardInput(_ input: String) -> String {
    
    let boardArt = input.replacingOccurrences(of: " ", with: "")
    
    var transformedArt = String()
    
    for y in  (0...7).reversed() {
        for x in 0...7 {
            
            let index = y*8 + x
            transformedArt.append(boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: index)])
        }
    }
    
    return transformedArt
    
}

public struct ASCIIBoard {
    
    let artString: String
    var stringContainsColors: Bool!
    
    public init(pieces artString: String) {

        var artString = artString
        
        // Transform
        artString = transformASCIIBoardInput(artString)
        
        // Check string format
        assert(artString.characters.count == 64, "ASCII board art must be 128 characters long")
        
        self.artString = artString
        self.stringContainsColors = false
        
    }
    
    public init(colors artString: String) {
        
        self.init(pieces: artString)
        self.stringContainsColors = true
    }
    
    public var board: Board {
        
        var boardArt = artString
        
        // We only care about colours, not piece types, so just make pawns
        if stringContainsColors == true {
            boardArt = boardArt.replacingOccurrences(of: "B", with: "p")
            boardArt = boardArt.replacingOccurrences(of: "W", with: "P")
        }
        
        var board = Board(state: .empty)
        
        // Clear all pieces on the board
        BoardLocation.all.forEach {
            board.removePiece(atLocation: $0)
        }
        
        // Setup pieces from ascii art
        (0..<64).forEach {
            let character = boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: $0)]
            
            if let piece = pieceFromCharacter(character) {
                board.setPiece(piece, at: BoardLocation(index: $0))
            }
        }
        
        return board
    }

    func pieceFromCharacter(_ character: Character) -> Piece? {
        
        var piece: Piece?
        
        switch character {
        case "R":
            piece = Piece(type: .rook, color: .white)
        case "K":
            piece = Piece(type: .knight, color: .white)
        case "B":
            piece = Piece(type: .bishop, color: .white)
        case "Q":
            piece = Piece(type: .queen, color: .white)
        case "G":
            piece = Piece(type: .king, color: .white)
        case "P":
            piece = Piece(type: .pawn, color: .white)
        case "r":
            piece = Piece(type: .rook, color: .black)
        case "k":
            piece = Piece(type: .knight, color: .black)
        case "b":
            piece = Piece(type: .bishop, color: .black)
        case "q":
            piece = Piece(type: .queen, color: .black)
        case "g":
            piece = Piece(type: .king, color: .black)
        case "p":
            piece = Piece(type: .pawn, color: .black)
        default:
            piece = nil
        }
        
        return piece
    }
    
    public func indexOfCharacter(_ character: Character) -> Int {
        
        var index: Int?
        
        if let idx = artString.characters.index(of: character) {
            index = artString.characters.distance(from: artString.startIndex, to: idx)
        }
        
        assert(index != nil, "Unable to find index of character: \(character)")
        return index!
    }
    
    public func locationOfCharacter(_ character: Character) -> BoardLocation {
        
        let index = indexOfCharacter(character)
        return BoardLocation(index: index)
    }
    
    public func indexesWithCharacter(_ character: Character) -> [Int] {
        
        var indexes = [Int]()
        
        (0..<64).forEach {
            let aCharacter = artString[artString.characters.index(artString.startIndex, offsetBy: $0)]
            if character == aCharacter {
                indexes.append($0)
            }
        }
        
        return indexes
    }

    public func locationsWithCharacter(_ character: Character) -> [BoardLocation] {
        
        let indexes = indexesWithCharacter(character)
        
        var locations = [BoardLocation]()
        
        indexes.forEach {
            let location = BoardLocation(index: $0)
            locations.append(location)
        }
        
        return locations
    }

}
