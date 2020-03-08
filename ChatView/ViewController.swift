//
//  ViewController.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/8/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit
import BusinessChat

class ViewController: UIViewController {

    fileprivate var chatView: ChatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        let samples = [Sample(temp: 32, brix: 10, date: Date().subtractingDays(15)),
                       Sample(temp: 48, brix: 20, date: Date().subtractingDays(1)),
                       Sample(temp: 50, brix: 25, date: Date().subtractingDays(2)),
                       Sample(temp: 38, brix: 30, date: Date().subtractingDays(3)),
                       Sample(temp: 52, brix: 15, date: Date().subtractingDays(4)),
                       Sample(temp: 70, brix: 20, date: Date().subtractingDays(6)),
                       Sample(temp: 44, brix: 40, date: Date().subtractingDays(8)),
                       Sample(temp: 36, brix: 36, date: Date().subtractingDays(10)),
                       Sample(temp: 48, brix: 34, date: Date().subtractingDays(11)),
                       Sample(temp: 40, brix: 32, date: Date().subtractingDays(12)),
                       Sample(temp: 38, brix: 36, date: Date().subtractingDays(13)),
                       Sample(temp: 30, brix: 30, date: Date()),
                       Sample(temp: 48, brix: 20, date: Date().addingDays(1)),
                       Sample(temp: 50, brix: 32, date: Date().addingDays(2)),
                       Sample(temp: 35, brix: 36, date: Date().addingDays(3)),
                       Sample(temp: 62, brix: 8, date: Date().addingDays(4)),
                       Sample(temp: 80, brix: 25, date: Date().addingDays(6)),
                       Sample(temp: 40, brix: 5, date: Date().addingDays(8)),
                       Sample(temp: 36, brix: 30, date: Date().addingDays(10)),
                       Sample(temp: 58, brix: 20, date: Date().addingDays(11)),
                       Sample(temp: 50, brix: 22, date: Date().addingDays(12)),
                       Sample(temp: 35, brix: 16, date: Date().addingDays(13)),
                       Sample(temp: 62, brix: 28, date: Date().addingDays(14)),
                       Sample(temp: 60, brix: 25, date: Date().addingDays(16)),
                       Sample(temp: 50, brix: 15, date: Date().addingDays(18))]
        chatView = ChatView()
        chatView.samples = samples
        chatView.startDate = Date().subtractingDays(20)
        chatView.endDate = Date().addingDays(20)
        self.view.addSubview(chatView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        chatView.frame = self.view.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.chatView.setNeedsDisplay()
        }) { (context) in
            
        }
    }
}
