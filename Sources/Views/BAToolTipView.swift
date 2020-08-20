//
//  BATipView.swift
//  BinartSwiftInputBar
//
//  Created by Seven on 2020/8/20.
//

import Foundation


//================================================
// MARK: Extensions
//================================================

private extension NSAttributedString {
    func sizeToFit(_ maxSize: CGSize) -> CGSize {
        return boundingRect(with: maxSize, options:(NSStringDrawingOptions.usesLineFragmentOrigin), context:nil).size
    }
}

private extension Int {
    var radians : CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
    }
}

private extension UIColor {
    func darkerColor() -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        return UIColor()
    }
}

//================================================
// MARK: ToolTip
//================================================

private class BAToolTipView : CAShapeLayer, CAAnimationDelegate {
    
    fileprivate weak var recordButton : BARecordButton?
    fileprivate let defaultMargin : CGFloat = 5.0
    fileprivate let defaultArrowSize : CGFloat = 5.0
    fileprivate let defaultCornerRadius : CGFloat = 5.0
    fileprivate var textLayer : CATextLayer!
    
    init(title: String, foregroundColor: UIColor, backgroundColor: UIColor, font: UIFont, recordButton: BARecordButton) {
        super.init()
        commonInit(title, foregroundColor: foregroundColor, backgroundColor: backgroundColor, font: font, recordButton: recordButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func commonInit(_ title: String, foregroundColor: UIColor, backgroundColor: UIColor, font: UIFont, recordButton: BARecordButton) {
        self.recordButton = recordButton
        
        let rect = recordButton.bounds
        let text = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : foregroundColor])
        
        // TextLayer
        textLayer = CATextLayer()
        textLayer.string = text
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        
        // ShapeLayer
        let screenSize = UIScreen.main.bounds.size
        let basePoint = CGPoint(x: rect.origin.x + (rect.size.width / 2), y: rect.origin.y - (defaultMargin * 2))
        let baseSize = text.sizeToFit(screenSize)
        
        let x       = basePoint.x - (baseSize.width / 2) - (defaultMargin * 2)
        let y       = basePoint.y - baseSize.height - (defaultMargin * 2) - defaultArrowSize
        let width   = baseSize.width + (defaultMargin * 4)
        let height  = baseSize.height + (defaultMargin * 2) + defaultArrowSize
        frame = CGRect(x: x, y: y, width: width, height: height)
        
        path = toolTipPath(bounds, arrowSize: defaultArrowSize, radius: defaultCornerRadius).cgPath
        fillColor = backgroundColor.cgColor
        addSublayer(textLayer)
    }
    
    fileprivate func toolTipPath(_ frame: CGRect, arrowSize: CGFloat, radius: CGFloat) -> UIBezierPath {
        let mid = frame.midX
        let width = frame.maxX
        let height = frame.maxY
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: mid, y: height))
        path.addLine(to: CGPoint(x: mid - arrowSize, y: height - arrowSize))
        path.addLine(to: CGPoint(x: radius, y: height - arrowSize))
        path.addArc(withCenter: CGPoint(x: radius, y: height - arrowSize - radius), radius: radius, startAngle: 90.radians, endAngle: 180.radians, clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 180.radians, endAngle: 270.radians, clockwise: true)
        path.addLine(to: CGPoint(x: width - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: 270.radians, endAngle: 0.radians, clockwise: true)
        path.addLine(to: CGPoint(x: width, y: height - arrowSize - radius))
        path.addArc(withCenter: CGPoint(x: width - radius, y: height - arrowSize - radius), radius: radius, startAngle: 0.radians, endAngle: 90.radians, clockwise: true)
        path.addLine(to: CGPoint(x: mid + arrowSize, y: height - arrowSize))
        path.addLine(to: CGPoint(x: mid, y: height))
        path.close()
        return path
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        textLayer.frame = CGRect(x: defaultMargin, y: defaultMargin, width: bounds.size.width-(defaultMargin*2), height: bounds.size.height-(defaultMargin*2))
    }
    
    fileprivate func animation(_ fromTransform: CATransform3D, toTransform: CATransform3D) -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: "transform")
        animation.damping = 15
        animation.initialVelocity = 10
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.fromValue = NSValue(caTransform3D: fromTransform)
        animation.toValue = NSValue(caTransform3D: toTransform)
        animation.duration = animation.settlingDuration
        animation.delegate = self
        animation.autoreverses = true
        return animation
    }
    
    func show() {
        recordButton?.layer.addSublayer(self)
        let show = animation(CATransform3DMakeScale(0, 0, 1), toTransform: CATransform3DIdentity)
        add(show, forKey: "show")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        removeFromSuperlayer()
    }
}
