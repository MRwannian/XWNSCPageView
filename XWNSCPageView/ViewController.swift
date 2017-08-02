//
//  ViewController.swift
//  XWNSCPageView
//
//  Created by Mr_Xu on 2017/7/19.
//  Copyright © 2017年 Mr_xc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
//        let titles = ["美女", "视频", "排行", "其他"]
        let titles = ["美女", "视频频", "排行排行", "其他其他其他", "其他", "其他"]
        let style = XWNPageStyle()
        style.isScrollEnable = true
        var childViews = [UIViewController]()
        for _ in titles {
            let vc = UIViewController()
            childViews.append(vc)
            vc.view.backgroundColor = UIColor.radomColor()
        }
        
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        let pageView = XWNContainView(frame: pageViewFrame, titles: titles, childViews: childViews, parent: self, style: style)
        view.addSubview(pageView!)
    }
}




