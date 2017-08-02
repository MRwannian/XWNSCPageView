//
//  XWNContentView.swift
//  XWNSCPageView
//
//  Created by Mr_Xu on 2017/7/19.
//  Copyright © 2017年 Mr_xc. All rights reserved.
//
//下面的内容视图

import UIKit

private let kContentCellID = "kContentCellID"

protocol XWNContentViewDelegate: class {
    func contentViewScroll(contentView: XWNContentView, endtIndex: Int)
    func contentViewScroll(contentView: XWNContentView, targetIndex: Int, progress: CGFloat)
}

class XWNContentView: UIView {
    
    //MARK: - Properties
    var childViews: [UIViewController]
    var currentOffsetX: CGFloat = 0.0
    var parentVC: UIViewController
    weak var contentViewDelegate: XWNContentViewDelegate?
    var isTitleClick = false
    
    lazy var pageCollectView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collecView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collecView.dataSource = self
        collecView.delegate = self
        collecView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collecView.isPagingEnabled = true
        collecView.scrollsToTop = false
        collecView.showsHorizontalScrollIndicator = false
        collecView.bounces = false
        return collecView
    }()
    
    init(frame: CGRect, childViews: [UIViewController], parentVC: UIViewController) {
        self.childViews = childViews
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI
extension XWNContentView {
    fileprivate func setupUI() {
        for vc in childViews {
            parentVC.addChildViewController(vc)
        }
        addSubview(pageCollectView)
    }
}

extension XWNContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let vc = childViews[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        vc.view.backgroundColor = UIColor.radomColor()
        cell.contentView.addSubview(vc.view)
        return cell
    }
}

extension XWNContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //记录当前的 OffsetX
        currentOffsetX = scrollView.contentOffset.x
        isTitleClick = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == currentOffsetX || isTitleClick { return }
        
        //如果x增加，则说明向左滑动，contentOffset.x在增大相关tag为现在的及加1
        //如果x减少，则说明向右滑动，contentOffset.x在减小相关tag为现在的及-1
        let index = Int(currentOffsetX / pageCollectView.bounds.width)
        var target = 0
        var progress:CGFloat = 0.0
        if currentOffsetX > scrollView.contentOffset.x {
            target = index - 1
            progress = CGFloat((currentOffsetX - scrollView.contentOffset.x) / pageCollectView.bounds.width)
        }else {
            target = index + 1
            progress = CGFloat((scrollView.contentOffset.x - currentOffsetX) / pageCollectView.bounds.width)
        }
        contentViewDelegate?.contentViewScroll(contentView: self, targetIndex: target, progress: progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endChangeContent(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endChangeContent(scrollView)
    }
    
    private func endChangeContent(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / pageCollectView.bounds.width
        contentViewDelegate?.contentViewScroll(contentView: self, endtIndex: Int(index))
    }
}

//MARK: - XWNTitleViewDelegate(头视图的代理方法)
extension XWNContentView: XWNTitleViewDelegate{
    func tileViewClickChange(titleView: XWNTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: targetIndex, section: 0)
        isTitleClick = true
        pageCollectView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

