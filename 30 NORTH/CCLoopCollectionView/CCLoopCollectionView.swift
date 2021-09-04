//
//  LoopCollectionView.swift
//  TestLoopCollectionView
//
//  Created by cuicc on 2018/3/5.
//  Copyright © 2018年 cuicc. All rights reserved.
//

import UIKit
import SDWebImage

public class CCLoopCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var mCollectionView: UICollectionView!
    private var loopPageControl: UIPageControl!
    
    private var currentFrame: CGRect!
    private var currentIndex = 0
    private var scrollTimer: Timer!

    /// 内容数组，可以是图片、本地路径或者网络路径
    public var contentAry = [AnyObject]() {
        didSet {
//            if contentAry.count > 1 {
//                contentAry.insert(contentAry.last!, at: 0)
//                contentAry.append(contentAry[1])
//            }
            if mCollectionView != nil {
                loopPageControl.frame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y+currentFrame.size.height-37.0, width: currentFrame.size.width, height: 37.0)
                loopPageControl.numberOfPages = contentAry.count
                
                mCollectionView.reloadData()
                
                //iOS 14 checkd added due to collection view scroll issue in iOS 14 only.
                //https://stackoverflow.com/questions/41884645/uicollectionview-scroll-to-item-not-working-with-horizontal-direction
                if #available(iOS 14, *) {
                    self.mCollectionView.isPagingEnabled = false
                }
                mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
                if #available(iOS 14, *) {
                    self.mCollectionView.isPagingEnabled = true
                }
            }
        }
    }
    /// 是否开始自动循环
    public var enableAutoScroll = false {
        didSet {
            if  mCollectionView != nil && enableAutoScroll == true {
                configAutoScroll()
            }
        }
    }
    /// 循环间隔时间
    public var timeInterval = 1.0 {
        didSet {
            if mCollectionView != nil && enableAutoScroll == true {
                configAutoScroll()
            }
        }
    }
    public var currentPageControlColor: UIColor? {
        didSet {
            if mCollectionView != nil {
                loopPageControl.currentPageIndicatorTintColor = currentPageControlColor
            }
        }
    }
    public var pageControlTintColor: UIColor? {
        didSet {
            if mCollectionView != nil {
                loopPageControl.pageIndicatorTintColor = pageControlTintColor
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        currentFrame = frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func didMoveToSuperview() {
        if currentFrame == nil {
            currentFrame = frame
        }
        initAllViews(frame: currentFrame)
    }

    func initAllViews(frame: CGRect) {
        // 图片循环UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        mCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.register(LoopCollectionViewCell.self, forCellWithReuseIdentifier: "LoopCollectionViewCellIdentifier")
        //
		mCollectionView.translatesAutoresizingMaskIntoConstraints = true
        mCollectionView.backgroundColor = UIColor.clear
        mCollectionView.isPagingEnabled = true
        mCollectionView.showsHorizontalScrollIndicator = false
        self.superview?.addSubview(mCollectionView)
        /*if mCollectionView.numberOfItems(inSection: 0) > 0 {
            mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }*/
        
        //loopPageControl
        loopPageControl = UIPageControl(frame: CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y+currentFrame.size.height-37.0, width: currentFrame.size.width, height: 37.0))
        loopPageControl.numberOfPages = contentAry.count
        loopPageControl.currentPageIndicatorTintColor = currentPageControlColor
        loopPageControl.pageIndicatorTintColor = pageControlTintColor
        self.superview?.addSubview(loopPageControl)
        
        // 是否开启自动循环
        if enableAutoScroll == true {
            configAutoScroll()
        }
    }
    

    //MARK: -  UICollectionView
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentAry.count
    }

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
		return CGSize(width: currentFrame.width, height: currentFrame.height)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoopCollectionViewCellIdentifier", for: indexPath) as? LoopCollectionViewCell
        if cell == nil {
            cell = LoopCollectionViewCell()
        }
		guard let content = contentAry[indexPath.item] as? NewsFeedModel else {
			return cell!
		}

		let imageURL = configs.imageUrl + content.newsFeedImage
		cell?.contentImageView?.sd_setImage(with: URL(string: imageURL), placeholderImage: nil)
		cell?.clipsToBounds = true
        //let rewardDesc = content.newsFeedDesc
        //cell.rewardDesc.text = rewardDesc
        //cell.rewardDesc.addTrailing(with: "... ", moreText: "Readmore")
        if content.newsType == "1" {
            if content.hasDetail == "1" {
				cell?.moreButton?.setTitle("MORE", for: .normal)
				cell?.moreButton?.isHidden = false
            }else{
                cell?.moreButton?.isHidden = true
            }
        } else if content.newsType == "2"{
            cell?.moreButton?.setTitle("Order", for: .normal)
        } else if content.newsType == "3"{
            cell?.moreButton?.setTitle("Listen", for: .normal)
        } else {
            cell?.moreButton?.setTitle("Watch", for: .normal)
        }
		cell?.moreButton?.tag = indexPath.item
		cell?.moreButton?.addTarget(self, action: #selector(moreButtonAction(_:)), for: .touchUpInside)
		cell!.backgroundColor = .clear
        return cell!
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

	@objc func moreButtonAction(_ sender:UIButton) {
		print("More Tapped")
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MoreButtonAction"), object: nil, userInfo: ["sender": sender])
	}

    //MARK: -  UIScrollViewDelegate
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        
       /*let index = Int(scrollView.contentOffset.x / currentFrame.size.width)
        currentIndex = index
        if index == contentAry.count-1 {
            mCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)
            currentIndex = 1
        }
        
        if index == 0 && contentAry.count > 1 {
            mCollectionView.scrollToItem(at: IndexPath(item: contentAry.count-2, section: 0), at: .left, animated: false)
            currentIndex = contentAry.count-2
        }
        //更新loopPageControl
        loopPageControl?.currentPage = currentIndex - 1*/
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //scrollView.isUserInteractionEnabled = true
        
        /*let index = Int(scrollView.contentOffset.x / currentFrame.width)
        if index == contentAry.count-1 {
            mCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            currentIndex = 1
        }
        
        if index == 0 && contentAry.count > 1 {
            mCollectionView.scrollToItem(at: IndexPath(item: contentAry.count-2, section: 0), at: .left, animated: false)
            currentIndex = contentAry.count-2
        }*/
        //更新loopPageControl
        loopPageControl?.currentPage = currentIndex
    }

	public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

		targetContentOffset.pointee = scrollView.contentOffset
		var indexes = self.mCollectionView.indexPathsForVisibleItems
		indexes.sort()
		var index = indexes.first!
		if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x < 0 {
			index.item = index.item + 1
		}
    
		currentIndex = index.item
        //iOS 14 checkd added due to collection view scroll issue in iOS 14 only.
        //https://stackoverflow.com/questions/41884645/uicollectionview-scroll-to-item-not-working-with-horizontal-direction
        if #available(iOS 14, *) {
        self.mCollectionView.isPagingEnabled = false
        }
		self.mCollectionView.scrollToItem(at: index, at: .left, animated: true )
        if #available(iOS 14, *) {
        self.mCollectionView.isPagingEnabled = true
        }

        loopPageControl?.currentPage = currentIndex
        
	}

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //scrollView.isUserInteractionEnabled = false
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    //MARK: -  Custom
    
    func configAutoScroll() {
        //设置定时器
        if scrollTimer != nil {
            scrollTimer.invalidate()
            scrollTimer = nil
        }
        scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollAction(timer: Timer) {
        if self.window != nil {
            currentIndex += 1
            if currentIndex >= contentAry.count {
                currentIndex = currentIndex % contentAry.count
            }
            //iOS 14 checkd added due to collection view scroll issue in iOS 14 only.
            //https://stackoverflow.com/questions/41884645/uicollectionview-scroll-to-item-not-working-with-horizontal-direction
            if #available(iOS 14, *) {
                self.mCollectionView.isPagingEnabled = false
            }
            mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
            if #available(iOS 14, *) {
                self.mCollectionView.isPagingEnabled = true
            }
        }
    }
}

class LoopCollectionViewCell: UICollectionViewCell {
    var contentImageView: UIImageView?
	var moreButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentImageView = UIImageView(frame: CGRect(x: 0, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
		contentImageView?.contentMode = .scaleAspectFill
		contentImageView?.layer.cornerRadius = 3.0
		contentImageView?.layer.borderColor = UIColor.darkGray.cgColor
		contentImageView?.layer.borderWidth = 0.5
        self.addSubview(contentImageView!)

		moreButton = UIButton(type: .custom)
		moreButton?.frame = CGRect(x: frame.width - 100, y: frame.height - 90, width: 80, height: 40)
		moreButton?.backgroundColor = UIColor.gold
		moreButton?.setTitleColor(.white, for: .normal)
		moreButton?.setTitle("MORE", for: .normal)
		self.addSubview(moreButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
