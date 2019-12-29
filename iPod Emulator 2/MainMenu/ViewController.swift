//
//  ViewController.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/20/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var clickWheel: ClickWheelView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var titleBarView: iPodNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContainerView.layer.cornerRadius = 6
        mainContainerView.layer.masksToBounds = true
    }
}


