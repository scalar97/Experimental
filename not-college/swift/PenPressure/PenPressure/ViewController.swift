//
//  ViewController.swift
//  PenPressure
//
//  Created by Tatiana Zihindula on 21/05/2018.
//  Copyright © 2018 Tatiana Zihindula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.clearCanvas(animated:false)
    }
    
    // Shake to clear screen
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        canvasView.clearCanvas(animated: true)
    }
}
