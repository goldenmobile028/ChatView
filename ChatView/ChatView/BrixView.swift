//
//  BrixView.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/8/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit

class BrixView: UIView {

    //public var maxBrix: Int = 45
    //public var minBrix: Int = -5
    public var offsetX: CGFloat = 0
    public var offsetY: CGFloat = 40
    public var brixColor = UIColor(red: 0.847, green: 0.450, blue: 0.0, alpha: 1.0)
    
    fileprivate let topSpace: CGFloat = 40
    fileprivate let bottomSpace: CGFloat = 40
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Draw coordinates
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor : brixColor,
            NSAttributedString.Key.paragraphStyle : paragraph
        ]
        
        let brix = NSAttributedString(string: "Brix", attributes: attributes)
        brix.draw(in: CGRect(x: 0, y: topSpace, width: bounds.width, height: 20))
        
        let brixs = 10
        let labelHeight: CGFloat = 20
        let height = bounds.height - offsetY * 2 - topSpace - bottomSpace
        let brixHeight = height / CGFloat(brixs - 1)
        context.setStrokeColor(brixColor.cgColor)
        for i in 0..<brixs {
            let ii = CGFloat(i)
            let brix = NSAttributedString(string: "\((i - 1) * 5)", attributes: attributes)
            let stringRect = CGRect(x: 0, y: bounds.height - offsetY - labelHeight / 2.0 - ii * brixHeight - bottomSpace, width: bounds.width, height: labelHeight)
            brix.draw(in: stringRect)
        }
    }
}
