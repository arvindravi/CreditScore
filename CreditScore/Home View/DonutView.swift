//
//  DonutView.swift
//  CreditScore
//
//  Created by Arvind Ravi on 08/07/2021.
//

import UIKit

final class DonutView: UIView {
    
    private let shapeLayer: CAShapeLayer = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        accessibilityIdentifier = "DonutView"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 100,
                                        startAngle: -.pi/2,
                                        endAngle: 2 * .pi,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
        
        animateAfterDelay()
    }
    
    // NB: Doesn't indicate progress at the moment and is a static animation.
    private func animateAfterDelay(delay: TimeInterval = 0.3) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.toValue = 1
            animation.duration = 1
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            self.shapeLayer.add(animation, forKey: "progressAnimation")
        }
    }
}
