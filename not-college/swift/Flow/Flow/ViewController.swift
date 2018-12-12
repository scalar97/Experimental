//
//  ViewController.swift
//  Flow
//
//  Created by Tatiana Zihindula on 20/05/2018.
//  Copyright © 2018 Tatiana Zihindula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var drinkProgress: progressCounter!
    @IBOutlet weak var drunkCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func drinkActions(_ sender: PushButton) {
        if sender.isAddButton {
            drinkProgress.didDrink()
        } else {
            drinkProgress.didLie()
        }
        drunkCount.text = "\(drinkProgress.getGlassesDrunk())"
    }
}

