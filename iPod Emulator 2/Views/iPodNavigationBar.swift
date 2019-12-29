//
//  iPodNavigationBar.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/21/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit

private let _shared: iPodNavigationBar = iPodNavigationBar()

@IBDesignable
class iPodNavigationBar: UIView {
    
    public class var shared: iPodNavigationBar {
      return _shared
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    var gradient = CAGradientLayer()
    var navTitleLabel = UILabel()
    
    override func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        let color1 = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        let color2 = UIColor(red:0.61, green:0.63, blue:0.61, alpha:1.0)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        self.layer.addSublayer(gradient)
        
        addSubview(iPodNavigationBar.shared.navTitleLabel)
        iPodNavigationBar.shared.navTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iPodNavigationBar.shared.navTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iPodNavigationBar.shared.navTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        iPodNavigationBar.shared.navTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        iPodNavigationBar.shared.navTitleLabel.text = "iPod"
        iPodNavigationBar.shared.navTitleLabel.font = UIFont(name: "Helvetica-Bold", size: 17)
//        iPodNavigationBar.shared.navTitleLabel.textColor = .iPodTextColor
        
        iPodNavigationBar.shared.navTitleLabel.textColor = UIColor.darkGray

   }
}
