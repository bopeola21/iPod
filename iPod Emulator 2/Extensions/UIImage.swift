//
//  UIImage.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/21/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  // Creates an image with the original image as a template and the specified color as the tint
  func withColor(_ color : UIColor) -> UIImage? {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
    imageView.image = self.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = color
    
    let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
    return renderer.image { (context) in
      imageView.layer.render(in: context.cgContext)
    }
  }
}
