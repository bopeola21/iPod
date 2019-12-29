//
//  MainCell.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/21/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView()
        selectedView.frame = bounds
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let color1 = UIColor(red:0.31, green:0.67, blue:0.99, alpha:1.0)
        let color2 = UIColor(red:0.03, green:0.45, blue:0.82, alpha:1.0)
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.shouldRasterize = true
        selectedView.layer.addSublayer(gradient)

        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            titleLabel.textColor = .white
            arrowImageView.image = arrowImageView.image?.withColor(.white)
            
            return
        }
        
//        titleLabel.textColor = .iPodTextColor
//        arrowImageView.image = arrowImageView.image?.withColor(.iPodTextColor)
        titleLabel.textColor = UIColor.darkGray
        arrowImageView.image = arrowImageView.image?.withColor(UIColor.darkGray)
    }

}
