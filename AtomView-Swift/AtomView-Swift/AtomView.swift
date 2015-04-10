//
//  AtomView.swift
//  AtomView-Swift
//
//  Created by Richard McDuffey on 3/23/15.
//  Copyright (c) 2015 Richard McDuffey. All rights reserved.
//

import Foundation
import UIKit
import CoreText

class AtomView : UIView
{
    private let circleSize : CGFloat = 10.0
    
    private var inner : UIView!
    private var outer : UIView!
    private var centerCircle : UIView!
    private var rightCircle : UIView!
    private var leftCircle : UIView!
    private var centerPathLayer : CAShapeLayer!
    private var leftPathLayer : CAShapeLayer!
    private var rightPathLayer : CAShapeLayer!
    
    private func createPathRotatedAroundBoundingBoxCenter(path aPath: CGPathRef!, radians rads: CGFloat) -> CGPathRef {
        let bounds : CGRect = CGPathGetBoundingBox(aPath)
        let center : CGPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        var transform : CGAffineTransform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, center.x, center.y)
        transform = CGAffineTransformRotate(transform, rads)
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y)
        return CGPathCreateCopyByTransformingPath(aPath, &transform)
    }
    
    convenience init() {
        self.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.blackColor()
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
      fatalError("NScoding isn't supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func commonInit() {
        
        let colors : NSArray = NSArray.ae_RandomColors()
        let index =  Int(arc4random_uniform(UInt32(colors.count)))
        let color  = colors.objectAtIndex(Int(index)) as! UIColor
       
        let desired : CGFloat = floor(UIScreen.mainScreen().bounds.size.width / 3)
        
        
        inner = UIView(frame: CGRectMake(CGRectGetMidX(self.bounds) - desired / 2, CGRectGetMidY(self.bounds) -
            desired / 2, desired, desired))
        inner.layer.cornerRadius = desired / 2
        inner.backgroundColor = color.colorWithAlphaComponent(0.8)
        inner.layer.borderWidth = 2.0;
        inner.layer.borderColor = color.CGColor
        self.addSubview(inner)
        
        outer = UIView(frame: CGRectInset(inner.frame, -10, -10))
        outer.layer.cornerRadius = CGRectGetHeight(outer.frame) / 2
        outer.backgroundColor = UIColor.clearColor()
        outer.layer.borderColor = color.colorWithAlphaComponent(0.5).CGColor
        outer.layer.borderWidth = 2.0
        self.addSubview(outer)
        

        
        let image : UIImageView = UIImageView(image: UIImage(named: "character.png"))
        image.contentMode = UIViewContentMode.ScaleAspectFill
        image.center = inner.center;
        self.addSubview(image)
        
        centerCircle = createCircle()
        self.addSubview(centerCircle)
        
        rightCircle = createCircle()
        self.addSubview(rightCircle)
        
        leftCircle = createCircle()
        self.addSubview(leftCircle)

        let rect : CGRect = CGRectMake(outer.center.x - desired, outer.center.y - desired / 4, desired * 2, desired / 2)
        
        let center : UIBezierPath = UIBezierPath(ovalInRect: rect)
        centerPathLayer = CAShapeLayer()
        centerPathLayer.path = center.CGPath
        centerPathLayer.strokeColor = UIColor.lightTextColor().colorWithAlphaComponent(0.5).CGColor
        centerPathLayer.lineWidth = 2.0
        centerPathLayer.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(centerPathLayer)
        
        let rightPath : UIBezierPath = UIBezierPath(ovalInRect: rect)
        rightPathLayer = CAShapeLayer()
        rightPathLayer.path = createPathRotatedAroundBoundingBoxCenter(path: rightPath.CGPath, radians: -45)
        rightPathLayer.strokeColor = UIColor.lightTextColor().colorWithAlphaComponent(0.5).CGColor
        rightPathLayer.lineWidth = 2.0
        rightPathLayer.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(rightPathLayer)
        
        let leftPath : UIBezierPath = UIBezierPath(ovalInRect: rect)
        leftPathLayer = CAShapeLayer()
        leftPathLayer.path = createPathRotatedAroundBoundingBoxCenter(path: rightPath.CGPath, radians: 45)
        leftPathLayer.strokeColor = UIColor.lightTextColor().colorWithAlphaComponent(0.5).CGColor
        leftPathLayer.lineWidth = 2.0
        leftPathLayer.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(leftPathLayer)
     
    }
    
    private func createCircle() -> UIView {
        let circle : UIView = UIView(frame: CGRectMake(0, 0, circleSize, circleSize))
        circle.layer.cornerRadius = circleSize / 2
        circle.layer.position = CGPointMake(0.5, 0.5)
        circle.backgroundColor = UIColor(red: 246/255.0, green: 71/255.0, blue: 71/255.0, alpha: 0.8)
        return circle
    }
    
    private func loadAnimationForCircle(circle aCircle: UIView!, layer aLayer: CAShapeLayer!, beginTime theTime: CFTimeInterval) {
        let orbit : CAKeyframeAnimation = CAKeyframeAnimation()
        orbit.keyPath = "position"
        orbit.path = aLayer.path
        orbit.duration = 2.0
        orbit.additive = true
        orbit.repeatCount = HUGE
        orbit.calculationMode = kCAAnimationPaced
        orbit.rotationMode = kCAAnimationRotateAuto
        orbit.removedOnCompletion = false
        orbit.beginTime = theTime
        aCircle.layer.addAnimation(orbit, forKey: nil)
    }
    
    private func startAnimation() {
        loadAnimationForCircle(circle: centerCircle, layer: centerPathLayer, beginTime: 0)
        loadAnimationForCircle(circle: rightCircle, layer: rightPathLayer, beginTime: 1.4)
        loadAnimationForCircle(circle: leftCircle, layer: leftPathLayer, beginTime: 3.5)
        
        let firstTransform = CATransform3DMakeScale(1.05, 1.05, 1)
        let secondTransform = CATransform3DMakeScale(0.7, 0.7, 1)
        
        UIView.animateKeyframesWithDuration(2.2, delay: 1.0, options: UIViewKeyframeAnimationOptions.Repeat, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                self.inner.layer.transform = firstTransform
                self.outer.layer.transform = firstTransform
                self.centerCircle.layer.transform = secondTransform
                self.rightCircle.layer.transform = secondTransform
                self.leftCircle.layer.transform = secondTransform
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                self.inner.layer.transform = CATransform3DIdentity
                self.outer.layer.transform = CATransform3DIdentity
                self.centerCircle.layer.transform = CATransform3DIdentity
                self.rightCircle.layer.transform = CATransform3DIdentity
                self.leftCircle.layer.transform = CATransform3DIdentity
            })
            
        }) { (_) -> Void in
            
        }
    }
    
    func show() {
        UIApplication.sharedApplication().delegate?.window??.rootViewController?.view .addSubview(self)
        startAnimation()
        inner.layer.MB_setCurrentAnimationsPersistent()
        outer.layer.MB_setCurrentAnimationsPersistent()
        centerCircle.layer.MB_setCurrentAnimationsPersistent()
        rightCircle.layer.MB_setCurrentAnimationsPersistent()
        leftCircle.layer.MB_setCurrentAnimationsPersistent()
    }
    
}

