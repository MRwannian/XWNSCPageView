//
//  XWNTitleView.swift
//  XWNSCPageView
//
//  Created by Mr_Xu on 2017/7/19.
//  Copyright © 2017年 Mr_xc. All rights reserved.
//
//顶部的头部视图
import UIKit

protocol XWNTitleViewDelegate: class {
    ///传递页面切换的方法
    func tileViewClickChange(titleView: XWNTitleView, targetIndex: Int)
    
}

class XWNTitleView: UIView {
    
    //MARK: - Properties
    fileprivate var titles: [String]
    fileprivate var style: XWNPageStyle
    fileprivate var titleLables = [UILabel]()
    fileprivate lazy var currentIndex : Int = 0
    weak var titleViewDelegate: XWNTitleViewDelegate?
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomTipView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = self.style.bottomLineColor
        view.frame.size.height = self.style.bottomLineHeight
        return view
    }()
    
    
    init(frame: CGRect, titles: [String], style: XWNPageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 初始化UI
extension XWNTitleView {
    fileprivate func setupUI() {
        //添加底部scroll
        addSubview(scrollView)
        //添加标签lable
        setupTipLable()
        setupTipLableFrame()
        setupBottomTip()
    }
    
    private func setupTipLable() {
        for (index, title) in titles.enumerated() {
            let lable = UILabel()
            lable.text = title
            lable.tag = index
            lable.font = style.titleFont
            lable.textColor = index == 0 ? style.selectColor : style.normalColor
            lable.textAlignment = .center
            
            //添加到scroll中
            scrollView.addSubview(lable)
            titleLables.append(lable)
            
            //添加点击手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLableClicked(_:)))
            lable.addGestureRecognizer(tap)
            lable.isUserInteractionEnabled = true
        }
    }
    
    private func setupTipLableFrame() {
        let count = titles.count
        var x = 0.0
        let y = 0.0
        var w = 0.0
        let h = bounds.height
        
        for (index, lable) in titleLables.enumerated() {
            //如果不能滚动，则平分屏幕宽度
            if !style.isScrollEnable {
                w = Double(bounds.width / CGFloat(count))
                x = w * Double(index)
            }else {
                //计算每个lable的宽度
                w = Double((titles[index] as NSString).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 0) , options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width)
                if index == 0 {
                    x = Double(style.titleMargin) * 0.5
                } else {
                    let preLabel = titleLables[index - 1]
                    x = Double(preLabel.frame.maxX) + Double(style.titleMargin)
                }
            }
            lable.frame = CGRect(x: x, y: y, width: w, height: Double(h))
        }
        
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLables.last!.frame.maxX + style.titleMargin * 0.5
        }
        
    }
    
    private func setupBottomTip() {
        scrollView.addSubview(bottomTipView)
        let x: CGFloat = titleLables[currentIndex].frame.origin.x
        let y = frame.size.height - style.bottomLineHeight
        var w: CGFloat = 0.0
        
        guard !style.isShowBottomLine else { return }
        if style.isScrollEnable {
            w = titleLables[currentIndex].frame.size.width
        }else {
            w = frame.size.width / CGFloat(titles.count)
        }
    
        bottomTipView.frame.origin.x = x
        bottomTipView.frame.origin.y = y
        bottomTipView.frame.size.width = w
    }
}

//MARK: - 事件方法
extension XWNTitleView {
    //MARK: -标题的点击事件
    @objc fileprivate func titleLableClicked(_ tapGes : UITapGestureRecognizer) {
        //取出点击的view
        guard let tapNewLable = tapGes.view as? UILabel else { return }
        //改变原lable及新lable的颜色
        let oldLable = titleLables[currentIndex]
        oldLable.textColor = style.normalColor
        tapNewLable.textColor = style.selectColor
        bottomTipView.frame.origin.x = tapNewLable.frame.origin.x
        bottomTipView.frame.size.width = tapNewLable.frame.size.width
        currentIndex = tapNewLable.tag
        //滚动标签
        adjustPosition(tapNewLable)
        
        //代理通知切换内容视图
        titleViewDelegate?.tileViewClickChange(titleView: self, targetIndex: currentIndex)
    }
    
    fileprivate func adjustPosition(_ newLabel : UILabel) {
        guard style.isScrollEnable else { return }
        var offsetX = newLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK: - XWNContentViewDelegate
extension XWNTitleView: XWNContentViewDelegate {
    func contentViewScroll(contentView: XWNContentView, targetIndex: Int, progress: CGFloat) {
        print("progress:\(progress)")
        //取出当下lable和目标lable
        let currentLable = titleLables[currentIndex]
        let targetLable = titleLables[targetIndex]
        
        //渐变文字颜色
        let selectRGB = getGRBValue(style.selectColor)
        let normalRGB = getGRBValue(style.normalColor)
        let deltaRGB = (selectRGB.0 - normalRGB.0, selectRGB.1 - normalRGB.1, selectRGB.2 - normalRGB.2)
        
        currentLable.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        targetLable.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        //渐变bottomLine
        //取得目标及现在的x,w差值
        let delW = currentLable.frame.size.width - targetLable.frame.size.width
        let delX = currentLable.frame.origin.x - targetLable.frame.origin.x
        bottomTipView.frame.origin.x = currentLable.frame.origin.x - delX * progress
        bottomTipView.frame.size.width = currentLable.frame.size.width - delW * progress
    }
    
    
    func contentViewScroll(contentView: XWNContentView, endtIndex: Int) {
        //改变原lable及新lable的颜色
        let tapNewLable = titleLables[endtIndex]
        let oldLable = titleLables[currentIndex]
        oldLable.textColor = style.normalColor
        tapNewLable.textColor = style.selectColor
        currentIndex = tapNewLable.tag
        //滚动标签
        adjustPosition(tapNewLable)
    }
    
    private func getGRBValue(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard  let components = color.cgColor.components else {
            fatalError("文字颜色请按照RGB方式设置")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
    
}



