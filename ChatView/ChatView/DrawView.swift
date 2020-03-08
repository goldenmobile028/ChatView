//
//  DrawView.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/8/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit

class DrawView: UIView {

    fileprivate var tooltipView: TooltipView!
    fileprivate var lineImageView: UIImageView!
    
    public var extraSpace: CGFloat = 40
    public var fieldSpace: CGFloat = 60
    public var brixLineWidth: CGFloat = 2.0
    public var tempLineWidth: CGFloat = 2.0
    public var samples: [Sample] = [] {
        didSet {
            samples.sort { (sample1, sample2) -> Bool in
                return sample1.date < sample2.date
            }
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var maxBrix: Double = 40.0
    fileprivate var minBrix: Double = -5
    fileprivate var maxTemp: Double = 100
    fileprivate var minTemp: Double = 30
    
    public var curScale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    fileprivate var minScale: CGFloat = 0.333
    fileprivate var maxScale: CGFloat = 2.0
    
    fileprivate let topSpace: CGFloat = 40
    fileprivate let bottomSpace: CGFloat = 40
    
    public var brixColor = UIColor(red: 0.847, green: 0.450, blue: 0.0, alpha: 1.0)
    public var tempColor = UIColor(red: 0.09, green: 0.137, blue: 0.337, alpha: 1.0)
    
    public var startDate = Date() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var endDate = Date() {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
        lineImageView = UIImageView()
        lineImageView.backgroundColor = .red
        lineImageView.isHidden = true
        self.addSubview(lineImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(gesture)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Draw coordinates
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }
        
        let width = bounds.width
        let height = bounds.height - extraSpace * 2 - topSpace - bottomSpace
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1.0)
        context.addRect(CGRect(x: 0, y: extraSpace + topSpace, width: width, height: height))
        context.strokePath()
        
        var brixPoint = CGPoint.zero
        var tempPoint = CGPoint.zero
        let brixOffset = height / CGFloat(maxBrix - minBrix)
        let tempOffset = height / CGFloat(maxTemp - minTemp)
        let labelWidth: CGFloat = 80
        let labelHeight: CGFloat = 20
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle : paragraph
        ]
        
        let days = endDate.days(since: startDate)
        var started = false
        var isNoSample = false
        var step = 1
        if curScale == minScale {
            step = 3
        } else if curScale <= 0.5 {
            step = 2
        }
        
        // Draw bottom dates
        for i in stride(from: 0, to: days, by: step) {
            let ii = CGFloat(i)
            context.setLineDash(phase: 0.0, lengths: [])
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(1.0)
            context.move(to: CGPoint(x: ii * fieldSpace * curScale, y: extraSpace + topSpace))
            context.addLine(to: CGPoint(x: ii * fieldSpace * curScale, y: bounds.height - extraSpace - bottomSpace))
            context.strokePath()

            // Draw bottom date
            let date = startDate.addingDays(i)
            let attributedDate = NSAttributedString(string: formatter.string(from: date), attributes: attributes)
            let dateRect = CGRect(x: ii * fieldSpace * curScale - labelWidth / 2.0, y: bounds.height - extraSpace - bottomSpace, width: labelWidth, height:labelHeight)
            attributedDate.draw(in: dateRect)
        }
        
        // Draw bottom months
        let mparagraph = NSMutableParagraphStyle()
        mparagraph.alignment = .left
        let mattributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor : UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle : mparagraph
        ]
        let mformatter = DateFormatter()
        let mlabelWidth: CGFloat = 160
        mformatter.dateFormat = "MMMM yyyy"
        for i in 0..<days {
            let ii = CGFloat(i)
            let date = startDate.addingDays(i)
            if i == 0 || date.isFirstDay() {
                let attributedDate = NSAttributedString(string: mformatter.string(from: date), attributes: mattributes)
                let dateRect = CGRect(x: ii * fieldSpace * curScale, y: bounds.height - extraSpace - bottomSpace + labelHeight, width: mlabelWidth, height:labelHeight)
                attributedDate.draw(in: dateRect)
            }
        }
        
        // Draw brix and temp graph
        for i in 0..<days {
            let ii = CGFloat(i)
            let date = startDate.addingDays(i)
            let sample = samples.first { (sample) -> Bool in
                return sample.date.isSameDay(date: date)
            }
            if isNoSample {
                context.setLineDash(phase: 2.0, lengths: [8.0])
            } else {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            if let sample = sample {
                // Draw brix
                let bx = ii * fieldSpace * curScale - brixLineWidth
                let by = bounds.height - extraSpace - brixLineWidth - CGFloat(sample.brix - minBrix) * brixOffset - bottomSpace
                context.setStrokeColor(brixColor.cgColor)
                context.setLineWidth(brixLineWidth)
                context.strokePath()
                if started == true {
                    context.move(to: brixPoint)
                    context.addLine(to: CGPoint(x: bx + brixLineWidth, y: by + brixLineWidth))
                    context.strokePath()
                }
                brixPoint = CGPoint(x: bx + brixLineWidth, y: by + brixLineWidth)

                // Draw temp
                let tx = ii * fieldSpace * curScale - tempLineWidth
                let tempValue = CGFloat(sample.temp) - CGFloat(minTemp)
                let ty = bounds.height - extraSpace - tempLineWidth - tempValue * tempOffset - bottomSpace
                context.setStrokeColor(tempColor.cgColor)
                context.setLineWidth(tempLineWidth)
                context.setFillColor(tempColor.cgColor)
                context.addEllipse(in: CGRect(x: tx, y: ty, width: tempLineWidth * 2, height: tempLineWidth * 2))
                context.fillPath()
                if started == true {
                    context.move(to: tempPoint)
                    context.addLine(to: CGPoint(x: tx + tempLineWidth, y: ty + tempLineWidth))
                    context.strokePath()
                }
                tempPoint = CGPoint(x: tx + tempLineWidth, y: ty + tempLineWidth)
                started = true
                isNoSample = false
            } else {
                isNoSample = true
            }
        }
        
        // Draw temp circle
        for i in 0..<days {
            let date = startDate.addingDays(i)
            let sample = samples.first { (sample) -> Bool in
                return sample.date.isSameDay(date: date)
            }
            let ii = CGFloat(i)
            if let sample = sample {
                // Draw temp
                let bx = ii * fieldSpace * curScale - brixLineWidth
                let by = bounds.height - extraSpace - brixLineWidth - CGFloat(sample.brix - minBrix) * brixOffset - bottomSpace
                context.setFillColor(UIColor.white.cgColor)
                context.setLineWidth(brixLineWidth)
                context.addEllipse(in: CGRect(x: bx, y: by, width: brixLineWidth * 2, height: brixLineWidth * 2))
                context.fillPath()

                context.setStrokeColor(brixColor.cgColor)
                context.addEllipse(in: CGRect(x: bx, y: by, width: brixLineWidth * 2, height: brixLineWidth * 2))
                context.strokePath()
            }
        }
        
        // Draw last date
        let date = endDate.addingDays(1)
        let attributedDate = NSAttributedString(string: formatter.string(from: date), attributes: attributes)
        let dateRect = CGRect(x: CGFloat(days) * fieldSpace * curScale - labelWidth / 2.0, y: bounds.height - extraSpace - bottomSpace, width: labelWidth, height:labelHeight)
        attributedDate.draw(in: dateRect)
    }
    
    @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let index = Int((location.x + fieldSpace * curScale / 2.0) / (fieldSpace * curScale))
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        lineImageView.frame = CGRect(x: CGFloat(index) * fieldSpace * curScale - 1.0, y: extraSpace + topSpace, width: 2, height: bounds.height - extraSpace * 2.0 - topSpace - bottomSpace)
        lineImageView.isHidden = false
        perform(#selector(hideLineImageView), with: nil, afterDelay: 2.0)
        let date = startDate.addingDays(index)
        let sample = samples.first { (sample) -> Bool in
            return sample.date.isSameDay(date: date)
        }
        if let sample = sample {
            if let _ = tooltipView {
                hideTooltipView()
            }
            tooltipView = TooltipView.show(in: self, date: sample.date, brix: "\(sample.brix)", temp: "\(sample.temp)")
            tooltipView.frame = CGRect(origin: CGPoint(x: location.x, y: location.y), size: tooltipView.frame.size)
            adjustTooltipView()
            perform(#selector(hideTooltipView), with: nil, afterDelay: 2.0)
        }
    }
    
    @objc fileprivate func hideTooltipView() {
        if let _ = tooltipView {
            tooltipView.removeFromSuperview()
            tooltipView = nil
        }
    }
    
    @objc fileprivate func hideLineImageView() {
        lineImageView.isHidden = true
    }
    
    fileprivate func adjustTooltipView() {
        if let _ = tooltipView {
            let contentOffset = (self.superview as! UIScrollView).contentOffset
            var frame = tooltipView.frame
            frame.origin = CGPoint(x: frame.origin.x - contentOffset.x, y: frame.origin.y - contentOffset.y)
            let offset = isRectVisibleInView(rect: frame, inRect: CGRect(origin: .zero, size: self.superview!.frame.size))
            if offset != .zero {
                var frame = tooltipView.frame
                frame.origin = CGPoint(x: frame.origin.x - offset.x, y: frame.origin.y - offset.y)
                tooltipView.frame = frame
            }
        }
    }
    
    fileprivate func isRectVisibleInView(rect: CGRect, inRect: CGRect) -> CGPoint {
        var offset = CGPoint()

        if inRect.contains(rect) {
            return CGPoint(x: 0, y: 0)
        }

        if rect.origin.x < inRect.origin.x {
            // It's out to the left
            offset.x = inRect.origin.x - rect.origin.x
        } else if (rect.origin.x + rect.width) > (inRect.origin.x + inRect.width) {
            // It's out to the right
            offset.x = (rect.origin.x + rect.width) - (inRect.origin.x + inRect.width)
        }

        if rect.origin.y < inRect.origin.y {
            // It's out to the top
            offset.y = inRect.origin.y - rect.origin.y
        } else if rect.origin.y + rect.height > inRect.origin.y + inRect.height {
            // It's out to the bottom
            offset.y = (rect.origin.y + rect.height) - inRect.origin.y + inRect.height
        }

        return offset
    }
}
