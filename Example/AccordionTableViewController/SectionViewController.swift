//
//  SectionViewController.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 7/6/15.
//  Copyright © 2015 Klevison Matias. All rights reserved.
//

import UIKit

protocol SectionViewControllerDelegate {
    
    func sectionViewControllerDidLayoutSubViews(size: CGSize)

}

class SectionViewController: UIViewController {
    
    var delegate: SectionViewControllerDelegate?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        delegate?.sectionViewControllerDidLayoutSubViews(self.view.bounds.size)
    }
}
