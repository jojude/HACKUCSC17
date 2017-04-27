//
//  AnimationEngine.swift
//  Local
//
//  Created by Jude Joseph on 1/22/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import pop

class AnimationEngine{
    class var offScreenRightPosition: CGPoint{
        return CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.midY)
    }
    
    class var offScreenLeftPosition: CGPoint{
        return CGPoint(x: -(UIScreen.main.bounds.midX), y: UIScreen.main.bounds.midY)
    }
    
    class var screenCenterPosition: CGPoint{
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }
    
    let ANIM_DELAY: Int = 1
    var originalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]!
    
    init(constraints: [NSLayoutConstraint]) {
        
        for con in constraints{
            originalConstants.append(con.constant)
            con.constant = AnimationEngine.offScreenRightPosition.x
        }
        
        self.constraints = constraints
    }
    
    func animateOnScreen(_ delay: Int?) {
        
        let time = DispatchTime.now() + Double(Int64(Double(delay!) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time){
            var index = 0
            
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim?.toValue = self.originalConstants[index]
                moveAnim?.springBounciness = 12
                moveAnim?.springSpeed = 12
                
                if index > 0 {
                    moveAnim?.dynamicsFriction += 8 + CGFloat(index)
                }
                
                let con = self.constraints[index]
                con.pop_add(moveAnim, forKey: "moveOnScreen")
                
                index += 1
                
            } while (index < self.constraints.count)
        }
    }
}
