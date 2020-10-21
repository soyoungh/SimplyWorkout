//
//  ProgressBar.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 21/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    
    private var bgLayer: CAShapeLayer!
    private var fgLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    private var endColor: CGColor!
    public var progress: Float = 0
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        let lineWidth = 0.2 * min(width, height)
        
        bgLayer = setCircularLayer(rect: rect, strokeColor: Theme.currentTheme.baseProgressColor.cgColor, fillColor: Theme.currentTheme.backgroundColor.cgColor, lineWidth: lineWidth)
        fgLayer = setCircularLayer(rect: rect, strokeColor: Theme.currentTheme.baseProgressColor.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        fgLayer.strokeEnd = CGFloat(progress)
        
        gradientLayer = setGradientLayer(rect: rect, startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        
        gradientLayer.mask = fgLayer
        
        layer.addSublayer(bgLayer)
        layer.addSublayer(gradientLayer)
      
       self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func drawProgress(selectedType: String) {
        if selectedType == "Very Light" {
            progress = 0.1
        }
        else if selectedType == "Light" {
            progress = 0.2
        }
        else if selectedType == "Moderate" {
            progress = 0.4
        }
        else if selectedType == "Vigorous" {
            progress = 0.6
        }
        else if selectedType == "Hard" {
            progress = 0.8
        }
        else {
            progress = 1.0
        }
        setNeedsDisplay()
    }
    
    // MARK: - Tap gesture Setting
    @objc func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.fromValue = 0
        basicAnimation.toValue = CGFloat(progress)
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        fgLayer.add(basicAnimation, forKey: "basic")
    }
    
    
    // MARK: - Creates a circular layer
    private func setCircularLayer (rect: CGRect, strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        
        let width = rect.width
        let height = rect.height
        let lineWidth = 0.2 * min(width, height)
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    // MARK: - Gradient Layer
    private func setGradientLayer (rect: CGRect, startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        let startColor = Theme.currentTheme.startColorOfProgress.cgColor
        
        gradientLayer.type = .conic
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        
        gradientLayer.colors = [
            startColor,
            UIColor.applyColor(AssetsColor.barrierReef)!.cgColor, UIColor.applyColor(AssetsColor.turquoise)!.cgColor, UIColor.applyColor(AssetsColor.sulphurSpring)!.cgColor, UIColor.applyColor(AssetsColor.citrusSol)!.cgColor, UIColor.applyColor(AssetsColor.oriole)!.cgColor,
            UIColor.applyColor(AssetsColor.raspberries)!.cgColor,
            startColor]
        
        gradientLayer.frame = rect
        
        return gradientLayer
    }
    
        
    
}
