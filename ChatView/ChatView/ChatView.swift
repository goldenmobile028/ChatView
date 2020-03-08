//
//  ChatView.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/8/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit

class ChatView: UIView {

    fileprivate var scrollView: UIScrollView!
    fileprivate var brixView: BrixView!
    fileprivate var tempView: TempView!
    fileprivate var contentScrollView: UIScrollView!
    fileprivate var contentView: DrawView!
    
    fileprivate var isZoomed = false
    fileprivate var scale = 1.0
    
    fileprivate var BRIXVIEW_WIDTH = 40
    fileprivate var TEMPVIEW_WIDTH = 40
    
    fileprivate var curScale: CGFloat = 1.0
    fileprivate var minScale: CGFloat = 0.333
    fileprivate var maxScale: CGFloat = 2.0
    
    public var startDate = Date() {
        didSet {
            let min = samples.reduce(samples[0], {$0.date < $1.date ? $0 : $1})
            if min.date < startDate {
                startDate = min.date
            }
            if let _ = contentView {
                contentView.startDate = startDate
            }
            
            adjustContentView()
        }
    }
    
    public var endDate = Date() {
        didSet {
            let max = samples.reduce(samples[0], {$0.date > $1.date ? $0 : $1})
            if max.date > endDate {
                endDate = max.date
            }
            
            if let _ = contentView {
                contentView.endDate = endDate
            }
            
            adjustContentView()
        }
    }
    
    public var samples: [Sample] = [] {
        didSet {
            if let _ = contentScrollView {
                contentScrollView.contentSize = CGSize(width: CGFloat(samples.count) * fieldSpace * curScale, height: contentScrollView.bounds.height)
            }
            
            let min = samples.reduce(samples[0], {$0.date < $1.date ? $0 : $1})
            if min.date < startDate {
                startDate = min.date
            }
            
            let max = samples.reduce(samples[0], {$0.date > $1.date ? $0 : $1})
            if max.date > endDate {
                endDate = max.date
            }
            
            if let _ = contentView {
                contentView.samples = samples
                contentView.startDate = startDate
                contentView.endDate = endDate
                adjustContentView()
            }
        }
    }
    
    public var extraSpace: CGFloat = 40 {
        didSet {
            if let _ = contentView {
                contentView.extraSpace = extraSpace
                contentView.setNeedsDisplay()
            }
        }
    }
    public var fieldSpace: CGFloat = 60 {
        didSet {
            if let _ = contentView {
                contentView.fieldSpace = fieldSpace
                contentView.setNeedsDisplay()
            }
        }
    }
    public var brixWidth: CGFloat = 40
    public var tempWidth: CGFloat = 40
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        scrollView = UIScrollView()
        self.addSubview(scrollView)
        
        brixView = BrixView()
        brixView.backgroundColor = .white
        scrollView.addSubview(brixView)
        
        tempView = TempView()
        tempView.backgroundColor = .white
        scrollView.addSubview(tempView)
        
        contentScrollView = UIScrollView()
        contentScrollView.bounces = false
        scrollView.addSubview(contentScrollView)
        
        contentView = DrawView()
        contentView.backgroundColor = .white
        contentView.extraSpace = extraSpace
        contentScrollView.addSubview(contentView)
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    override var frame: CGRect {
        didSet {
            if let _ = scrollView {
                scrollView.frame = self.bounds
                scrollView.contentSize = CGSize(width: frame.width + 0.2, height: frame.height)
            }
            
            if let _ = brixView {
                brixView.frame = CGRect(x: 0, y: 0, width: brixWidth, height: bounds.height)
            }
            
            if let _ = tempView {
                tempView.frame = CGRect(x: bounds.width - tempWidth, y: 0, width: tempWidth, height: bounds.height)
            }
            
            adjustContentView()
        }
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        if let _ = contentView {
            contentView.setNeedsDisplay()
        }
        
        if let _ = brixView {
            brixView.setNeedsDisplay()
        }
        
        if let _ = tempView {
            tempView.setNeedsDisplay()
        }
    }
    
    @objc fileprivate func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        if let _ = contentView {
            curScale *= gesture.scale
            if curScale < minScale {
                curScale = minScale
            }
            if curScale > maxScale {
                curScale = maxScale
            }
            
            if contentView.curScale == curScale {
                return
            }
            
            contentView.curScale = curScale
            
            let days = endDate.days(since: startDate)
            contentScrollView.contentSize = CGSize(width: CGFloat(days) * fieldSpace * curScale, height: contentScrollView.bounds.height)
            contentView.frame = CGRect(x: 0, y: 0, width: contentScrollView.contentSize.width, height: contentScrollView.contentSize.height)
            var contentOffset = contentScrollView.contentOffset
            let offset = contentScrollView.frame.width * (1 - gesture.scale) / 2.0
            contentOffset = CGPoint(x: contentOffset.x * gesture.scale - offset, y: contentOffset.y * curScale)
            if contentOffset.x < 0 {
                contentOffset.x = 0
            }
            if contentOffset.x + contentScrollView.bounds.width > contentScrollView.contentSize.width {
                contentOffset.x = contentScrollView.contentSize.width - contentScrollView.bounds.width
            }
            contentScrollView.contentOffset = contentOffset
            
            gesture.scale = 1.0
        }
    }
    
    fileprivate func adjustContentView() {
        if let _ = contentScrollView {
            contentScrollView.frame = CGRect(x: brixWidth, y: 0, width: bounds.width - brixWidth - tempWidth, height: bounds.height)
            let days = endDate.days(since: startDate)
            contentScrollView.contentSize = CGSize(width: CGFloat(days) * fieldSpace * curScale, height: contentScrollView.bounds.height)
        }
        
        if let _ = contentView {
            contentView.frame = CGRect(x: 0, y: 0, width: contentScrollView.contentSize.width, height: contentScrollView.contentSize.height)
            contentView.setNeedsDisplay()
        }
    }
}
