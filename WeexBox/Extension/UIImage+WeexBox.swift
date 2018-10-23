//
//  UIImage+WeexBox.swift
//  WeexBox
//
//  Created by Mario on 2018/10/23.
//  Copyright © 2018 Ayg. All rights reserved.
//

import Foundation

public extension UIImage {
    
    func changeSize(_ size: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
