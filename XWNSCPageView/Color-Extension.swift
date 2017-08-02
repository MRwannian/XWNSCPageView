//
//  Color-Extension.swift
//  XWNShow
//
//  Created by Mr_Xu on 2017/7/19.
//  Copyright © 2017年 Mr_xc. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init?(hexString: String, alphal: CGFloat = 1) {
        guard hexString.characters.count >= 6 else {
            return nil
        }
        var uperHexStr = hexString.uppercased()

        if uperHexStr.hasPrefix("0x") || uperHexStr.hasPrefix("##") {
            let index = uperHexStr.characters.index(uperHexStr.startIndex, offsetBy: 2)
            uperHexStr = uperHexStr.substring(from: index)
        }else if uperHexStr.hasPrefix("#") {
            let index = uperHexStr.index(uperHexStr.startIndex, offsetBy: 1)
            uperHexStr = uperHexStr.substring(from: index)
        }
        
        //前两位的字符串
        var range = uperHexStr.startIndex ..< uperHexStr.characters.index(uperHexStr.startIndex, offsetBy: 2)
        let rHex = uperHexStr.substring(with: range)
        //三四位的字符串
        range = uperHexStr.characters.index(uperHexStr.startIndex, offsetBy: 2) ..< uperHexStr.characters.index(uperHexStr.startIndex, offsetBy: 4)
        let gHex = uperHexStr.substring(with: range)
        //最后两位的字符串
        range = uperHexStr.characters.index(uperHexStr.endIndex, offsetBy: -2) ..< uperHexStr.endIndex
        let bHex = uperHexStr.substring(with: range)
        // 将十六进制转成数字
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        self.init(r : CGFloat(r), g : CGFloat(g), b : CGFloat(b))
    }
    
    
    ///创建随机颜色
    class func radomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)), alpha: CGFloat(arc4random_uniform(256)))
    }
    
}
