//
//  ViewController.swift
//  QYOptionButton
//
//  Created by Joggy on 16/5/1.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = ViewController1()
        let view1Item = UITabBarItem()
        view1Item.title = "item1"
        view1.tabBarItem = view1Item
        let view2 = ViewController2()
        let view2Item = UITabBarItem()
        view2Item.title = "item2"
        view2.tabBarItem = view2Item
        let view3 = ViewController3()
        let view3Item = UITabBarItem()
        view3Item.title = "item3"
        view3.tabBarItem = view3Item
        let view4 = ViewController4()
        let view4Item = UITabBarItem()
        view4Item.title = "item4"
        view4.tabBarItem = view4Item
        let view5 = ViewController5()
        let view5Item = UITabBarItem()
        view5Item.title = "item5"
        view5.tabBarItem = view5Item
        self.viewControllers = [view1, view2, view3, view4, view5]
        
        _ = QYOptionButton(tabbar: self.tabBar, forItemIndex: 2, delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: QYOptionButtonDelegate {
    
    func QYOptionNumberOfOptionButtonItem(optionButton: QYOptionButton) -> Int {
        return 7
    }
    
    func QYOptionItemAtIndex(optionButton: QYOptionButton, itemAtIndex index: Int) -> QYOptionItem {
        let optionItem = QYOptionItem(frame: CGRectMake(0, 0, 64, 64))
        optionItem.setImage(UIImage(named: "icon_holder"), forState: UIControlState.Normal)
        //为该按钮添加事件
//        optionItem.addTarget(self, action: #selector(anAction), forControlEvents: UIControlEvents.TouchUpInside)
        return optionItem
    }
    //调整OptionButton上下的位置
    func QYOptionAdjustUpAndDownForOptionButtonItem(optionButton: QYOptionButton) -> CGFloat {
        return 0
    }
    
    func QYOptionNormalImage(optionButton: QYOptionButton) -> UIImage {
        return UIImage(named: "middle_selected")!
    }
    
    func QYOptionSelectedImage(optionButton: QYOptionButton) -> UIImage {
        return UIImage(named: "middle_selected")!
    }
    
}

