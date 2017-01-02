//
//  BoardRaterCheckMateOpportunity.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 02/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

/*
 Rates for check mates opportunities.

 Iterates over all possible moves, makes them, and checks if the resulting state is check mate
 */

class BoardRaterCheckMateOpportunity : BoardRater {
    
    override func ratingfor(board: Board, color: Color) -> Double {
        
        let value = Double(20)
        var rating = Double(0)
        
        for (index, square) in board.squares.enumerated() {
        
            guard let piece = square.piece else{
                continue
            }
            
            for location in BoardLocation.all {
                
                let sourceLocation = BoardLocation(index: index)
                
                if piece.movement.canPieceMove(fromLocation: sourceLocation, toLocation: location, board: board) {
                    
                    var movedBoard = board
                    movedBoard.movePiece(fromLocation: sourceLocation, toLocation: location)
                    
                    if piece.color == color && movedBoard.isColorInCheckMate(color: color.opposite()){
                        rating += value
                    }
                    else if piece.color == color.opposite() && movedBoard.isColorInCheckMate(color: color){
                        rating -= value
                    }
                }
            }
        }
        
        return rating
    }

}
