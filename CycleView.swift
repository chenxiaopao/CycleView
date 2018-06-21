//
//  CycleView.swift
//  CycleImage
//
//  Created by 陈思斌 on 2018/6/20.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import UIKit
//无线轮播代理
protocol CycleViewDelegate:class {
    func CycleViewItemClick(_ collectionView:UICollectionView,selectedItem item:Int)
}
//无限轮播的封装
class CycleView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView!
    var width:CGFloat!
    var height:CGFloat!
    var imageNames:[String]!
    var timer:Timer?
    var startContentOffsetX:CGFloat = 0
    var item:Int = 0
    var pageControl : UIPageControl?
    weak var delegate:CycleViewDelegate?
    var timeInterval:Double?
    /// frame：collectionView 的frame
    /// iamgeNames：图片名
    /// timeInterval：自动滚动的时间间隔
    /// pageControl：默认设置居中
    
    init(frame: CGRect,imageNames:[String],timeInterval:Double=2,pageControl:UIPageControl?=nil) {
        super.init(frame: frame)
        self.imageNames = imageNames
        self.pageControl = pageControl
        self.timeInterval = timeInterval
        self.width = frame.width
        self.height = frame.height
        setupCollectionView()
        setupTimer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //设置定时器
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: timeInterval!, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    //自动播放下一页
    @objc func nextPage(){
        //获取当前indexpath
        let currentIndexPath = collectionView.indexPathsForVisibleItems.last
        //滚动到中间的section
        let middleIndexPath = IndexPath(item: (currentIndexPath?.item)!, section: 1)
        //滚动到中间section
        collectionView.scrollToItem(at: middleIndexPath, at: .left, animated: false)
        //滚动到目标页面
        var nextItem = middleIndexPath.item + 1
        var nextSection = middleIndexPath.section
        if nextItem == imageNames.count {
            nextItem = 0
            nextSection += 1
        }
        collectionView.scrollToItem(at: IndexPath(item: nextItem, section: nextSection), at: .left, animated: true)
    }
    //设置collectionView
    func  setupCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = self.bounds.size
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.contentSize = CGSize(width: width*CGFloat(imageNames.count), height: height)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identify")
        self.addSubview(collectionView)
        //设置pageControl
        if pageControl == nil{
            setupPageControl()
        }else{
            addSubview(pageControl!)
        }
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: false)
    }
    //设置pageControl
    func setupPageControl(){
        let rect = CGRect(x: Int(width/2-50), y: Int(height-30), width: 100, height: 20)
        pageControl = UIPageControl(frame: rect)
        pageControl?.numberOfPages = imageNames.count
        pageControl?.currentPageIndicatorTintColor = UIColor.red
        pageControl?.isUserInteractionEnabled = false
        addSubview(pageControl!)
    }
    //重置定时器
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        
    }
    // 默认三个section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    //每个section的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    //返回cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identify", for: indexPath)
        for view:UIView in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.image = UIImage(named: imageNames[indexPath.row])
        cell.contentView.addSubview(imageView)
        return cell
    }
    //选中item处理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.CycleViewItemClick(collectionView, selectedItem: indexPath.item)
    }
    //完成滚动时，设置pageControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x+width*0.5)/width)
        let currentPage = page%imageNames.count
        pageControl?.currentPage = currentPage
    }
    //开始拖动，移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetTimer()
    }
    //完成拖动,重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.setupTimer()
    }
    //手动滑动处理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.scrollToItem(at: IndexPath(item: (pageControl?.currentPage)!, section: 1), at: .left, animated: false)
    }
}
