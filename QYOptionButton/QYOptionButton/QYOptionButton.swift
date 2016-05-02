//
//  QNOptionButton.swift
//  OptionButton
//
//  Created by Joggy on 15/11/17.
//  Copyright © 2015年 NUPT. All rights reserved.
//

import UIKit

class QYOptionButton: UIButton {
    
    private let screenWidth = UIScreen.mainScreen().bounds.width
    private let screenHeight = UIScreen.mainScreen().bounds.height
    
    let itemsVerticalInsert: CGFloat = 100
    var itemsHorizontalInsert: CGFloat = 100
    
    var butFrame: CGRect!
    var tabbar: UITabBar!
    var butLocationIndex: Int!
    var delegate: QYOptionButtonDelegate!
    var items = [QYOptionItem]()
    var itemsLocation = [CGPoint]()
    var isOpen: Bool = false
    var blackView: UIVisualEffectView!
    var bound: CGRect!
    var panGesture: UITapGestureRecognizer!
    var openedButton: UIButton!
    var showImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(tabbar: UITabBar, forItemIndex index: Int, delegate: QYOptionButtonDelegate) {
        butFrame = CGRectMake(0, 0, 42,30)
        super.init(frame: butFrame)
        self.bound = UIScreen.mainScreen().bounds
        self.tabbar = tabbar
        self.delegate = delegate
        self.butLocationIndex = index
        self.center = buttonLocationForIndex(index)
        self.tabbar.items![index].enabled = false
        self.tabbar.addSubview(self)
        self.clipsToBounds = true
        setupItem()
        self.addTarget(self, action: #selector(QYOptionButton.showItems), forControlEvents: UIControlEvents.TouchUpInside)
        let normalImage = self.delegate.QYOptionNormalImage(self)
        self.frame.size.height = butFrame.width*(normalImage.size.height/normalImage.size.width)
        self.setImage(normalImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
    }
    
    func showItems() {
        self.addBlackView()
        for i in 0...items.count - 1 {
            items[i].layer.position = CGPointMake(itemsLocation[i].x, itemsLocation[i].y + 80)
            items[i].alpha = 0
            self.tabbar.superview?.insertSubview(items[i], aboveSubview: blackView)
            UIView.animateWithDuration(0.5, delay: 0.05*Double(i), usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.items[i].layer.position = self.itemsLocation[i]
                self.items[i].alpha = 1
                }, completion: nil)
        }
        isOpen = !isOpen
        addPanGesture()
        self.setImage(self.delegate.QYOptionSelectedImage(self).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
        var i = 0
        while butLocationIndex - i > 0 {
            i += 1
            self.tabbar.items![butLocationIndex - i].enabled = false
            self.tabbar.items![butLocationIndex + i].enabled = false
        }
        self.enabled = false
    }
    
    func hideItems() {
        self.removeBlackView()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            for i in 0...self.items.count - 1 {
                self.items[i].alpha = 0
            }
            }, completion: { (finish) -> Void in
                self.removeItems()
        })
        isOpen = !isOpen
        removePanGestrue()
        self.setImage(self.delegate.QYOptionNormalImage(self).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
        var i = 0
        while butLocationIndex - i > 0 {
            i += 1
            self.tabbar.items![butLocationIndex - i].enabled = true
            self.tabbar.items![butLocationIndex + i].enabled = true
        }
        self.enabled = true
    }
    
    func removeItems() {
        for i in 0...self.items.count - 1 {
            items[i].removeFromSuperview()
        }
    }
    
    func addPanGesture() {
        panGesture = UITapGestureRecognizer()
        panGesture.addTarget(self, action: #selector(QYOptionButton.hideItems))
        blackView.addGestureRecognizer(panGesture)
    }
    
    func removePanGestrue() {
        if (panGesture != nil) {
            blackView.removeGestureRecognizer(panGesture)
        }
    }
    
    func addBlackView() {
        blackView = UIVisualEffectView(frame: CGRectMake(0, 0, bound.width, bound.height))
        blackView.effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        blackView.alpha = 0
        self.tabbar.superview?.insertSubview(blackView, belowSubview: self)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.blackView.alpha = 1
        }
        openedButton = UIButton(frame: CGRectMake(0, 0, butFrame.width, self.frame.size.height))
        openedButton.layer.position = CGPointMake(screenWidth/2, screenHeight - 44 + 13)
        openedButton.setImage(delegate.QYOptionSelectedImage(self).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
        openedButton.addTarget(self, action: #selector(QYOptionButton.hideItems), forControlEvents: UIControlEvents.TouchUpInside)
        self.tabbar.superview?.insertSubview(openedButton, aboveSubview: blackView)
//        showImageView = UIImageView(frame: CGRectMake(0, 0, 215*proportion5s*0.7, 158*proportion5s*0.7))
//        showImageView.layer.position = CGPointMake(screenWidth/2, 151*proportion5s + 80)
//        showImageView.alpha = 0
//        showImageView.image = UIImage(named: "middle_img_show")
//        self.tabbar.superview?.insertSubview(showImageView, aboveSubview: blackView)
//        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            self.showImageView.alpha = 1
//            self.showImageView.layer.position.y = 151 * proportion5s
//            }, completion: nil)
    }
    
    func removeBlackView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.blackView.alpha = 0
            self.openedButton.alpha = 0
//            self.showImageView.alpha = 0
            }) { (finish) -> Void in
                self.blackView.removeFromSuperview()
                self.openedButton.removeFromSuperview()
//                self.showImageView.removeFromSuperview()
        }
    }
    
    func setupItem() {
        let itemsNum = self.delegate.QYOptionNumberOfOptionButtonItem(self)
        for i in 0...itemsNum - 1 {
            let item = self.delegate.QYOptionItemAtIndex(self, itemAtIndex: i)
            item.addTarget(self, action: #selector(QYOptionButton.selectedItem(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            items.append(item)
        }
        self.itemsLocation = distributeLocationForItem(items.count)
    }
    
    func selectedItem(button: QYOptionItem) {
        hideItems()
    }
    
    func distributeLocationForItem(num: Int) -> [CGPoint] {
        itemsHorizontalInsert = bound.width/10
        let lineOfItems: Int = (items.count - 1)/3
        var itemslo = [CGPoint]()
        for i in 0...num - 1 {
            let position = CGPointMake(itemsHorizontalInsert*CGFloat(2 + Int(i%3)*3), bound.height - itemsVerticalInsert*CGFloat(lineOfItems - Int(i/3)) - 180)
            itemslo.append(position)
        }
        return itemslo
    }
    
    func buttonLocationForIndex(index: Int) ->CGPoint {
        let item = self.tabbar.items![index]
        let view = item.valueForKey("view") as! UIView
        var point = view.center
        point.y += self.delegate.QYOptionAdjustUpAndDownForOptionButtonItem(self)
        return point
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol QYOptionButtonDelegate {
    func QYOptionNumberOfOptionButtonItem(optionButton: QYOptionButton) -> Int
    func QYOptionItemAtIndex(optionButton: QYOptionButton, itemAtIndex index: Int) -> QYOptionItem
    func QYOptionAdjustUpAndDownForOptionButtonItem(optionButton: QYOptionButton) -> CGFloat
    func QYOptionNormalImage(optionButton: QYOptionButton) -> UIImage
    func QYOptionSelectedImage(optionButton: QYOptionButton) -> UIImage
}



