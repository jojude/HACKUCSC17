//
//  CustomBusinessTitleView.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit

@IBDesignable
class CustomBusinessTitleView: UIView {

    func setupView(){
        let bottomBorder = CALayer()
        
        bottomBorder.frame = CGRect(x: 0.0, y: 43.0, width: self.frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        
        self.layer.addSublayer(bottomBorder)
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
    }

}
