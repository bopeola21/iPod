//
//  ProgressView.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/24/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit

private let animationSpeed: Double = 10

@IBDesignable
class ProgressView: UIView {
    
    let shapeLayer = CAShapeLayer()
    //var trackLayer = CAShapeLayer()
    var basicAnimation: CABasicAnimation?
    var lastValue: CGFloat?


    override func draw(_ rect: CGRect) {
        setupView()
    }
    
    func setupView() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        path.close()
        
//        trackLayer.path = path.cgPath
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.strokeColor = UIColor.lightGray.cgColor
//        trackLayer.lineWidth = bounds.height
//        trackLayer.strokeEnd = 1.0
//        layer.addSublayer(trackLayer)
        
        
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red:0.32, green:0.70, blue:0.90, alpha:1.0).cgColor
        shapeLayer.lineWidth = bounds.height
        shapeLayer.strokeEnd = 0
        layer.addSublayer(shapeLayer)
        
        basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation?.fromValue = 0
        basicAnimation?.toValue = 0
        basicAnimation?.duration = 1
        
        basicAnimation?.fillMode = CAMediaTimingFillMode.forwards
//        basicAnimation?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        basicAnimation?.isRemovedOnCompletion = false
    }
    
    func animateToPosition(_ toValue: CGFloat, animate: Bool) {
        
        basicAnimation?.fromValue = lastValue ?? 0.0
        let newValue = toValue
        basicAnimation?.toValue = newValue
        lastValue = newValue

        self.shapeLayer.add(self.basicAnimation!, forKey: "customAnimation")
    }
    
    func reset() {
        lastValue = 0
        animateToPosition(lastValue!, animate: true)
    }
}
