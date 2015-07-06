//
//  SectionHeaderView.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 7/1/15.
//  Copyright (c) 2015 Klevison Matias. All rights reserved.
//

import UIKit

protocol SectionHeaderViewDelegate {
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, selectedAtIndex index: NSInteger)
    
}

class SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var headerSeparatorView: UIView!
    @IBOutlet weak var backgroundHeaderView: UIView!
    @IBOutlet weak var overHeaderView: UIView!
    
    var delegate: SectionHeaderViewDelegate?
    var section: NSInteger?
    var headerSectionAppearence: Appearance? {
        didSet {
            headerSeparatorView.backgroundColor = headerSectionAppearence!.headerSeparatorColor
            backgroundHeaderView.backgroundColor = headerSectionAppearence!.headerColor
            titleLabel.font = headerSectionAppearence!.headerFont
            titleLabel.textColor = headerSectionAppearence!.headerTitleColor
            disclosureButton.setImage(headerSectionAppearence!.headerArrowImageOpened, forState: .Normal)
            disclosureButton.setImage(headerSectionAppearence!.headerArrowImageClosed, forState: .Selected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "toggleOpen:")
        self.addGestureRecognizer(tapGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        overHeaderView.subviews.map { $0.removeFromSuperview() }
    }
    
    func addOverHeaderSubView(view: UIView) {
        self.overHeaderView.addSubview(view)
    }
    
    @IBAction func toggleOpen(sender: AnyObject) {
        disclosureButton.selected = !self.disclosureButton.selected
        delegate?.sectionHeaderView(self, selectedAtIndex: section!)
    }
    
}
