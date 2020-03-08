//
//  TempView.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/8/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit

class TempView: UIView {

    public var offsetX: CGFloat = 0
    public var offsetY: CGFloat = 40
    public var tempColor = UIColor(red: 0.09, green: 0.137, blue: 0.337, alpha: 1.0)
    
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
            NSAttributedString.Key.foregroundColor : tempColor,
            NSAttributedString.Key.paragraphStyle : paragraph
        ]
        
        let temp = NSAttributedString(string: "Temp", attributes: attributes)
        temp.draw(in: CGRect(x: 0, y: topSpace, width: bounds.width, height: 20))
        
        let temps = 8
        let labelHeight: CGFloat = 20
        let height = bounds.height - offsetY * 2 - topSpace - bottomSpace
        let tempHeight = height / CGFloat(temps - 1)
        context.setStrokeColor(tempColor.cgColor)
        for i in 0..<temps {
            let ii = CGFloat(i)
            let brix = NSAttributedString(string: "\((i + 3) * 10)", attributes: attributes)
            let stringRect = CGRect(x: 0, y: bounds.height - offsetY - labelHeight / 2.0 - ii * tempHeight - bottomSpace, width: bounds.width, height: labelHeight)
            brix.draw(in: stringRect)
        }
    }
}
