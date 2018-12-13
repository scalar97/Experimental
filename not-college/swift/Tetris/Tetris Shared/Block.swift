//
//  Block.swift
//  Tetris iOS
//
//  Created by Tatiana Zihindula on 25/03/2018.
//

import SpriteKit

// Tetris supports 6 different colors
let NumberOfColors: UInt32 = 6

// LOOK-UP : enum

// declaring an enum of type Int, that implements the CustomStringConvertible
// this enable the use of human readable strings to replace integers
// usefull for debugging and console logging
// block color is the name of the enum variable
enum BlockColor : Int, CustomStringConvertible {
    case Blue = 0 , Orange, Purple, Red, Teal, Yellow
    
    // LOOK-UP : computed property
    // this a variable whose value get generated everytime the variable is used
    var spriteName: String {
        // the spriteName returns the correct filename for each color
        switch self {
            case .Blue  : return "blue"
            case .Orange: return "orange"
            case .Purple: return "purple"
            case .Red   : return "red"
            case .Teal  : return "teal"
            case .Yellow: return "yellow"
        }
    }
    
    // the description is also another computed property that will return the
    // spriteName computed above
    var description: String {
        return self.spriteName
    }
    
    // return a random choice between 0 and the NumberOfColors=5
    // this is done using the rawValue Initialiser
    // LOOK-UP: rawValue
    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
}

// Hashable will allow to store the blocks in a 2D array
class Block: Hashable, CustomStringConvertible {
    // this creates an enum that has 6 colors as shown above
    // this color is a constant as it will not change through the game once set
    let color: BlockColor
    
    // row and column will be the positions of the block on the board game
    var column: Int
    var row: Int
    // the sprite node will represent the visual element of the Block, which GameScene
    // will use to render and animate each block = 0
    var sprite: SKSpriteNode?

    // initialiser
    init(column: Int, row:Int, color:BlockColor) {
        self.column = column
        self.row    = row
        self.color  = color
    }
    
    // return one of the defined color files in the enum above
    // this is simply a shortcut to accessing the spriteName property from the color
    var spriteName: String {
        return color.spriteName
    }

     // XORs the column and the row to get the hash value.
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // return the color name and the current block's index
    var description: String {
        return "\(color): [\(row), \(column)]"
    }
    // creating a custom operator == like __eq__ in python
    // return true if both blocks are at the same place and have the same colors
    static func == (lhs: Block, rhs: Block) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
    }
}
