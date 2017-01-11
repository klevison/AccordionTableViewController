//
//  SectionViewController.swift
//  AccordionExample
//
//  Created by Klevison Matias on 1/11/17.
//  Copyright © 2017 worQ. All rights reserved.
//

import UIKit

protocol SectionViewControllerDelegate: class {
    func sectionViewControllerDidLayoutSubViews(size: CGSize)
}

final class SectionViewController: UIViewController {
    
    weak var delegate: SectionViewControllerDelegate?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        delegate?.sectionViewControllerDidLayoutSubViews(size: view.bounds.size)
    }
}

