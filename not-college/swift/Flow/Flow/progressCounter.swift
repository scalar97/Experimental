//
//  progressCounter.swift
//  Flow
//
//  Created by Tatiana Zihindula on 20/05/2018.
//  Copyright © 2018 Tatiana Zihindula. All rights reserved.
//

import UIKit
protocol drinkBeverageDelegate {
    func didDrink()
    func didLie()
}

@IBDesignable
class progressCounter: UIView, drinkBeverageDelegate {
    
    private struct Constants {
        static var glassesPerDay: Int = 8 // recomended to drink 8 glasses per day
        static var lineWidth: CGFloat = 2.0
        static let arcWidth: CGFloat = 76.0
        
        static var halfLineWidth: CGFloat {
            return lineWidth / 2
        }
        
        func setNewGlassAmount(amount: Int) {
           if amount > 0 {
               progressCounter.Constants.glassesPerDay = amount
           }
        }
    }
    private var glassesConsumed: Int  = 0 // glasses drunk so far, initialised to 0
    
    @IBInspectable var strokeColor: UIColor = UIColor.cyan
    @IBInspectable var fillColor: UIColor  = UIColor.lightGray.withAlphaComponent(0.1)
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = ( max(bounds.width, bounds.height) / 2 ) - Constants.arcWidth / 2
        let startAngle: CGFloat = .pi
        let endAngle: CGFloat = 0
     
        // create the base arc
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = Constants.arcWidth
        fillColor.setStroke()
        path.stroke()
        
        // create the evolving arc
        let angleDifferene: CGFloat = (2 * .pi) - startAngle + endAngle
        let oneGlassWidth = angleDifferene / CGFloat(Constants.glassesPerDay)
        let glassesDrunkEnd = (oneGlassWidth * CGFloat(glassesConsumed)) + startAngle
       
        let outlineArc = UIBezierPath(arcCenter: center,
                                      radius: bounds.width/2 - Constants.halfLineWidth,
                                      startAngle: startAngle, endAngle: glassesDrunkEnd, clockwise: true)
        
        outlineArc.addArc(withCenter: center, radius: bounds.width/2 - Constants.arcWidth + Constants.halfLineWidth,
                          startAngle: glassesDrunkEnd, endAngle: startAngle, clockwise: false)
        
        outlineArc.lineWidth = Constants.lineWidth
        strokeColor.setFill()
        strokeColor.setStroke()
        outlineArc.fill()
        outlineArc.stroke()
    }
    func didDrink() {
        guard self.glassesConsumed < 8 else {
            return
        }
        Constants.lineWidth = 5.0
        self.glassesConsumed += 1
        setNeedsDisplay()
    }
    
    func didLie() {
        self.glassesConsumed -= 1
        if self.glassesConsumed <= 0 {
            self.glassesConsumed = 0
            Constants.lineWidth = 2.0
        }
        setNeedsDisplay()
    }
    func getGlassesDrunk() -> Int {
        return self.glassesConsumed
    }
}
