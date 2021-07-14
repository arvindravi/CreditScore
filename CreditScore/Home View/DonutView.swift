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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
    }
    
    private func setup() {
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 100,
                                        startAngle: -.pi/2,
                                        endAngle: 2 * .pi,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(shapeLayer)
        
        animateAfterDelay()
    }
    
    private func animateAfterDelay(delay: TimeInterval = 2) {
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
