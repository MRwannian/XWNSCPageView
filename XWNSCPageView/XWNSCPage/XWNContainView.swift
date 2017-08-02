//
//  XWNContainView.swift
//  XWNSCPageView
//
//  Created by Mr_Xu on 2017/7/19.
//  Copyright © 2017年 Mr_xc. All rights reserved.
//
//整个容器视图

import UIKit

class XWNContainView: UIView {

    //MARK: - Properties
    var titles: [String]?
    var childViews: [UIViewController]
    var parentVC: UIViewController
    var style: XWNPageStyle
    var titleView: XWNTitleView!
    
    init?(frame: CGRect, titles: [String]?, childViews: [UIViewController], parent: UIViewController, style: XWNPageStyle) {
        guard let titleArr = titles else {
            return nil
        }
        self.titles = titleArr
        self.parentVC = parent
        self.childViews = childViews
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 布局UI
extension XWNContainView {
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
    }
    
    //MARK: -添加头部视图
    private func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleViewHeight)
        let titleView = XWNTitleView(frame: titleFrame, titles:titles!, style: style)
        titleView.backgroundColor = UIColor.radomColor()
        self.titleView = titleView
        addSubview(titleView)
    }
    
    //MARK: -添加内容视图
    private func setupContentView() {
        let contentFrame = CGRect(x: 0, y: style.titleViewHeight, width: bounds.width, height: bounds.height - style.titleViewHeight)
        let contentView = XWNContentView(frame: contentFrame, childViews: childViews, parentVC: parentVC)
        addSubview(contentView)
        contentView.contentViewDelegate = titleView
        titleView.titleViewDelegate = contentView
    }
    
}






