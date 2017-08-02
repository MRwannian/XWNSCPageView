//
//  XWNPageStyle.swift
//  XWNSCPageView
//
//  Created by Mr_Xu on 2017/7/19.
//  Copyright © 2017年 Mr_xc. All rights reserved.
//

import UIKit

class XWNPageStyle {
    
    var titleViewHeight : CGFloat = 44
    var titleFont : UIFont = UIFont.systemFont(ofSize: 15.0)
    ///标签是否可以滑动
    var isScrollEnable = false
    var titleMargin : CGFloat = 20
    
    var normalColor = UIColor(r: 255, g: 255, b: 255)
    var selectColor = UIColor(r: 255, g: 127, b: 0)
    //底部滑动标签
    var isShowBottomLine = false
    var bottomLineColor = UIColor.orange
    var bottomLineHeight : CGFloat = 2
    
    var isTitleScale = false
    var scaleRange : CGFloat = 1.2
    
    var isShowCoverView = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 25
}
