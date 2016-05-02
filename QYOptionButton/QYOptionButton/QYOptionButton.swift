//
//  QNOptionButton.swift
//  OptionButton
//
//  Created by Joggy on 15/11/17.
//  Copyright © 2015年 NUPT. All rights reserved.
//

import UIKit

class QYOptionButton: UIButton {
    
    let itemsVerticalInsert: CGFloat = 100
    var itemsHorizontalInsert: CGFloat = 100
    
    var butFrame: CGRect!
    var tabbar: UITabBar!
    var butLocationIndex: Int!
    var delegate: QYOptionButtonDelegate!
    var items = [QYOptionItem]()
    var itemsLocation = [CGPoint]()
    var isOpen: Bool = false
    var blackView: UIView!
    var bound: CGRect!
    var panGesture: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(tabbar: UITabBar, forItemIndex index: Int, delegate: QYOptionButtonDelegate) {
        butFrame = CGRectMake(0, 0, 60,60)
        super.init(frame: butFrame)
        self.bound = UIScreen.mainScreen().bounds
        self.tabbar = tabbar
        self.delegate = delegate
        self.center = buttonLocationForIndex(index)
        self.tabbar.items![index].enabled = false
        self.tabbar.addSubview(self)
        self.clipsToBounds = true
        setupItem()
        self.addTarget(self, action: "pressed", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func pressed() {
        if !isOpen {
            showItems()
        }
        else {
            hideItems()
        }
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
    }
    
    func removeItems() {
        for i in 0...self.items.count - 1 {
            items[i].removeFromSuperview()
        }
    }
    
    func addPanGesture() {
        panGesture = UITapGestureRecognizer()
        panGesture.addTarget(self, action: "hideItems")
        blackView.addGestureRecognizer(panGesture)
    }
    
    func removePanGestrue() {
        if (panGesture != nil) {
            blackView.removeGestureRecognizer(panGesture)
        }
    }
    
    func addBlackView() {
        blackView = UIView(frame: CGRectMake(0, 0, bound.width, bound.height))
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0
        self.tabbar.superview?.insertSubview(blackView, belowSubview: self.tabbar)
        self.enabled = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.blackView.alpha = 0.6
            }) { (finish) -> Void in
                self.enabled = true
        }
    }
    
    func removeBlackView() {
        if (blackView != nil) {
            self.enabled = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.blackView.alpha = 0
                }, completion: { (finish) -> Void in
                    self.enabled = true
                    self.blackView.removeFromSuperview()
            })
        }
    }
    
    func setupItem() {
        let itemsNum = self.delegate.QYOptionNumberOfOptionButtonItem(self)
        for i in 0...itemsNum - 1 {
            let item = self.delegate.QYOptionItemAtIndex(self, itemAtIndex: i)
            item.addTarget(self, action: "selectedItem:", forControlEvents: UIControlEvents.TouchUpInside)
            items.append(item)
        }
        self.itemsLocation = distributeLocationForItem(items.count)
    }
    
    func selectedItem(button: QYOptionItem) {
        hideItems()
    }
    
    func distributeLocationForItem(num: Int) -> [CGPoint] {
        itemsHorizontalInsert = bound.width/3
        let lineOfItems: Int = (items.count - 1)/3
        var itemslo = [CGPoint]()
        for i in 0...num - 1 {
            let position = CGPointMake(itemsHorizontalInsert/2 + itemsHorizontalInsert*CGFloat(Int(i%3)), bound.height - itemsVerticalInsert*CGFloat(lineOfItems - Int(i/3)) - 180)
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
}



