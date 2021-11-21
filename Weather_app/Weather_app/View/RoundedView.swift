//
//  RoundedView.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

@IBDesignable class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
}

@IBDesignable class CircleView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.width / 2
    }
}
