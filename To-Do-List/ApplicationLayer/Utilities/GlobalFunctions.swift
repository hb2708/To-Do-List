//
//  GlobalFunctions.swift
//  To-Do-List
//
//  Created by Harshal on 8/20/17.
//  Copyright © 2017 Harshal. All rights reserved.
//

import Foundation

func setupTabBar() {
    //Code to customize UITabBar
    UITabBar.appearance().tintColor = themeColor
    
    let colorNormal:UIColor = .black
    let colorSelected:UIColor = themeColor
    let titleFontAll = UIFont(name: "ChalkboardSE-Regular", size: 10.0)!
    
    let attributesNormal = [
        NSForegroundColorAttributeName : colorNormal,
        NSFontAttributeName : titleFontAll
    ]
    
    let attributesSelected = [
        NSForegroundColorAttributeName : colorSelected,
        NSFontAttributeName : titleFontAll
    ]
    
    UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
    UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
}
