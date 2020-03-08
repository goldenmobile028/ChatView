//
//  TooltipView.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/9/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit

class TooltipView: UIView {

    fileprivate var dateLabel: UILabel!
    fileprivate var separateLabel: UILabel!
    fileprivate var brixLabel: UILabel!
    fileprivate var tempLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    fileprivate func commonInit() {
        self.backgroundColor = .white
        
        dateLabel = UILabel()
        dateLabel.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
        dateLabel.textAlignment = .center
        self.addSubview(dateLabel)
        
        separateLabel = UILabel()
        separateLabel.frame = CGRect(x: 0, y: 40, width: 160, height: 1)
        separateLabel.backgroundColor = .lightGray
        self.addSubview(separateLabel)
        
        brixLabel = UILabel()
        brixLabel.frame = CGRect(x: 12, y: 49, width: 136, height: 22)
        self.addSubview(brixLabel)
        
        tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 12, y: 71, width: 136, height: 22)
        self.addSubview(tempLabel)
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.frame = CGRect(x: 0, y: 0, width: 160, height: 101)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: frame.height))
        }
    }
    
    public static func show(in view: UIView, date: Date, brix: String, temp: String) -> TooltipView {
        let tview = TooltipView()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, M/d"
        tview.dateLabel.text = formatter.string(from: date)
        tview.brixLabel.text = "Brix: \(brix)"
        tview.tempLabel.text = "Temp: \(temp)"
        view.addSubview(tview)
        return tview
    }
}
