//
//  Shape.swift
//  Tetris iOS
//
//  Created by Tatiana Zihindula on 25/03/2018.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, CustomStringConvertible {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
            case .Zero  : return "0"
            case .Ninety: return "90"
            case .OneEighty : return "180"
            case .TwoSeventy: return "270"
        }
    }
    
    // return a random choice from the enum value
    static func random() -> Orientation {
        return Orientation(rawValue:Int(arc4random_uniform(NumOrientations)))!
    }
    
    static func rotate(orientation: Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}


// method to return orientation
let NumShapeTypes: UInt32 = 7

// Shape Indexes
let FirstBlockIdx   : Int = 0
let SecondBlockIdx  : Int = 1
let ThirdBlockIdx   : Int = 2
let FourthBlockIdx  : Int = 3

class Shape: Hashable, CustomStringConvertible {
    
    // the color of the shape
    let color: BlockColor
    // Blocks that make up the shape
    var blocks = Array<Block>()
    // The current orientation of the shape
    var orientation: Orientation
    // The column and the row representing the shape's anchor point
    var column, row: Int
    
    var bottomBlocksOrientations:[Orientation: Array<Block>] {
        return [:]
    }
    
    var bottonBlocks: Array<Block> {
        guard let bottomBlocks = bottomBlocksOrientations[orientation] else {
            return []
        }
        return bottomBlocks
    }
    
    var hashValue: Int {
        return blocks.reduce(0) {
            $0.hashValue ^ $1.hashValue
        }
    }
    
    var description: String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]),\(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]),\(blocks[FourthBlockIdx])"
    }
    
    init(column: Int, row:Int, color:BlockColor, orientation:Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlock()
    }
    
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }
    
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}











































