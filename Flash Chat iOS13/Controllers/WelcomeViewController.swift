//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    // viewWillAppear/Disappear methods hidde the navigation controller bar from this view (WelcomeViewController)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
//        titleLabel.text = ""
//       let title = "⚡️FlashChat"
//       var chartIndex = 0.0
        
//        for eachLetter in title{
//            Timer.scheduledTimer(withTimeInterval: 0.1 * chartIndex, repeats: false) { (timer) in
//                self.titleLabel.text?.append(eachLetter)
//            }
//            chartIndex += 1
//        }
    }
    
    
    
}
