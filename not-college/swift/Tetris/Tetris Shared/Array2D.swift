//
//  Array2D.swift
//  Tetris iOS
//
//  Created by Tatiana Zihindula on 25/02/2018.
//  This file manages the tiles's movement using an array
//

// the array will have 20 rows and 10 columns 

//generic array in swift are of type struct not classes
//these are to store any type of data
class Array2D<T> {
    // rows and coluns constant variables
    let cols: Int
    let rows: Int
    
    // this array will be the underlying data structure of this Tetris game.
    // the optional types indicate that null values may be stored.
    // In this game, values that are nil will refer to empty spots
    // where no blocks are presents.
    
    var array: Array<T?>
    
    // constructor which will alow passing variables..
    init(cols: Int, rows: Int){
        self.cols = cols
        self.rows = rows
        // the internal array is instantiated with the size of rowsXcols
        // this will hold the 20 x 10 size of our aray..
        // repeating: nil, will initialise evey empty slot in the array with nil
        array = Array<T?>(repeating: nil, count: rows * cols)
    }
    // subscript allow easy access to Array object's elements.
    // this Array2D gives an illusion of a 2D array but it is a 1D array
    // this subscript will allow annotation such as anArray[rowIndex, colIndex]
    
    // TODO: perform bound checks
    subscript(column: Int, row: Int) -> T? {
        
        get{
            // given the row and column  index, this returns the appropriate elm
            return array[(row * self.cols) + column]
        }
        set(value){
            // the set function uses the same index Algorithm above.
            array[(row * self.cols) + column] = value
        }
    }
}
