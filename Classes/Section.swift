//
//  Section.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 7/1/15.
//  Copyright (c) 2015 Klevison Matias. All rights reserved.
//

import UIKit

final class Section: NSObject {
    
    var open = false
    var view: UIView?
    var overlayView: UIView?
    var headerView: SectionHeaderView?
    var title: String?
    var backgroundColor: UIColor?
    var sectionIndex: Int?
    var appearance = Appearance()

    
    override init() {}
   
}
