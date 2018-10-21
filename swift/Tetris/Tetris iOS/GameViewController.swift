//
//  GameViewController.swift
//  Tetris iOS
//
//  Created by Tatiana Zihindula on 16/02/2018.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene : GameScene! // create a non-optional game Scene object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // as! downcasts the skView variable from UIView to SKView
        // the SKView class inherit from the ui view. this allows to have SKView
        // specific methods.
        let skView = view as! SKView
        
        // indicates if the view receives multiple touches at a time
        skView.isMultipleTouchEnabled = false
        
        /*
         bounds: specifies the size and height and weight
         size: specifies the height and width of the rectangle
        */
        scene = GameScene(size: skView.bounds.size)
        /*
         scaleMode: tells how the scene is mapped to the view that presents it.
         aspectFill :scale factor at which all axis of the view are scaled by
        */
        scene.scaleMode = .aspectFill
        
        // presents, replaces the current scene if it exists.
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
