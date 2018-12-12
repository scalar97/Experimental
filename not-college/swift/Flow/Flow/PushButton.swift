//
//  PushButton.swift
//  Flow
//
//  Created by Tatiana Zihindula on 20/05/2018.
//  Copyright © 2018 Tatiana Zihindula. All rights reserved.
//

import UIKit

@IBDesignable
class PushButton: UIButton {
    // set defaults
    private struct Constants {
        static let plusLineWidth:   CGFloat = 3.0 // the lineWidth of the path symbol
        static let plusButtonScale: CGFloat = 0.5 // take 50% of the circle
        static let halfPointShift:  CGFloat = 0.5
    }
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    @IBInspectable var isAddButton: Bool = true
    @IBInspectable var fillColor: UIColor = UIColor.lightGray
    @IBInspectable var strokeColor: UIColor = UIColor.white
    
    // draw the custom plus or minus button
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        // draw circles buttons
        drawCircleButtons()
        
    }
    private func drawCircleButtons() {
        // make the width take 50% of minimum bound value
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let plusPath: UIBezierPath = UIBezierPath()  // the path of the plus symbol
        plusPath.lineWidth = Constants.plusLineWidth // set to the default lineWidth for plus
        
        // draw the horizontal line
        // move the horizontal line start of the path
        plusPath.move(to:    CGPoint(x: halfWidth - (plusWidth/2), y: halfHeight))
        // add a straight line to the other end of plusPath
        plusPath.addLine(to: CGPoint(x: halfWidth + (plusWidth/2), y: halfHeight))
        
        // draw the vertical line
        if isAddButton {
            // move the horizontal line start of the path
            plusPath.move(to: CGPoint(x: halfWidth, y: halfHeight - (plusWidth/2) ))
            // add a straight line to the other end of plusPath
            plusPath.addLine(to: CGPoint(x: halfWidth, y: halfHeight + (plusWidth/2) ))
        }
        strokeColor.setStroke()
        plusPath.stroke()
    }
}
