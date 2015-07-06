//
//  Appearence.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 7/1/15.
//  Copyright (c) 2015 Klevison Matias. All rights reserved.
//

import UIKit

final class Appearance: NSObject {
    
    var headerHeight = CGFloat(50)
    var headerFont = UIFont.systemFontOfSize(15)
    var headerTitleColor = UIColor.blackColor()
    var headerColor = UIColor.whiteColor()
    var headerSeparatorColor = UIColor.blackColor()
    var headerArrowImageOpened = UIImage(named: "carat-open")
    var headerArrowImageClosed = UIImage(named: "carat")
    
    override init() {}
   
}
