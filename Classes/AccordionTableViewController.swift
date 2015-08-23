//
//  AccordionTableViewController.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 7/1/15.
//  Copyright (c) 2015 Klevison Matias. All rights reserved.
//

import UIKit

protocol AccordionTableViewControllerDelegate {

    func accordionTableViewControllerSectionDidOpen(section: Section)
    func accordionTableViewControllerSectionDidClose(section: Section)

}

class AccordionTableViewController: UITableViewController {
    
    private var openAnimation = UITableViewRowAnimation.Fade
    private var closeAnimation = UITableViewRowAnimation.Fade
    var openedSectionIndex = NSNotFound
    var sections = [Section]()
    var oneSectionAlwaysOpen = false
    var delegate: AccordionTableViewControllerDelegate?
    
    private let SectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    private let SectionCellID = "CellIdentifier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        tableView.registerNib(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)
        tableView.bounces = false
        tableView.separatorStyle = .None
    }
    
    private func sectionAtIndex(index: Int) -> Section? {
        
        if sections.count >= index + 1 {
            return sections[index]
        }
    
        return nil
    }
    
    private func configureSectionsCell(section: Section) {
        let cellIdentifier = "\(SectionCellID)\(section.sectionIndex!)"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func getOpenedSection() -> Section? {
        
        for section in sections where section.open == true {
            return section
        }

        return nil
    }
    
    func reloadOpenedSection() {
        if let openedSection = getOpenedSection() {
            let indexPath = NSIndexPath(forRow: 0, inSection: openedSection.sectionIndex!)
            let cellToReloadArray = [indexPath]
            tableView.reloadRowsAtIndexPaths(cellToReloadArray, withRowAnimation: openAnimation)
        }
    }
    
    private func sectionHeaderViewOpenedAtIndex(index: Int) {
        
        let section = sections[index]
        section.open = true
        
        var indexPathsToInsert = [NSIndexPath]()
        var indexPathsToDelete = [NSIndexPath]()
        indexPathsToInsert.append(NSIndexPath(forRow: 0, inSection: index))
        
        if openedSectionIndex != NSNotFound {
            let previousOpenSection = sections[openedSectionIndex]
            let praviousSectionHeaderView = tableView.headerViewForSection(openedSectionIndex) as! SectionHeaderView
            praviousSectionHeaderView.disclosureButton.selected = false
            previousOpenSection.open = false
            indexPathsToDelete.append(NSIndexPath(forRow: 0, inSection: openedSectionIndex))
            delegate?.accordionTableViewControllerSectionDidClose(previousOpenSection)
        }
       
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation: openAnimation)
        tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: closeAnimation)
        tableView.endUpdates()
       
        let sectionRect = tableView.rectForSection(index)
        tableView.scrollRectToVisible(sectionRect, animated: true)
        
        openedSectionIndex = index
        
        delegate?.accordionTableViewControllerSectionDidOpen(section)
            

    }
    
    func sectionHeaderViewClosedAtIndex(index: Int) {
        
        let currentSection = sections[index]
        currentSection.open = false
        let countOfRowsToDelete = tableView.numberOfRowsInSection(index)
        
        if (countOfRowsToDelete > 0) {
            var indexPathsToDelete = [NSIndexPath]()
            indexPathsToDelete.append(NSIndexPath(forRow: 0, inSection: index))
            tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: closeAnimation)
        }
        
        openedSectionIndex = NSNotFound;
        delegate?.accordionTableViewControllerSectionDidClose(currentSection)
        
    }

}


extension AccordionTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sections[section].open {
            return 1
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        configureSectionsCell(section)

        let cellIdentifier = "CellIdentifier\(indexPath.section)"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        
        cell.contentView.addSubview(section.view!)
        cell.contentView.autoresizesSubviews = false
        cell.contentView.frame = section.view!.frame
        
        return cell
    }
    
}

extension AccordionTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].view?.frame.size.height ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].appearance.headerHeight ?? 0
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeaderViewIdentifier) as! SectionHeaderView
        
        let currentSection = sections[section]
        
        if currentSection.backgroundColor != nil {
            currentSection.appearance.headerColor = currentSection.backgroundColor!
        }
        
        currentSection.sectionIndex = section
        currentSection.headerView = sectionHeaderView
        sectionHeaderView.headerSectionAppearence = currentSection.appearance
        sectionHeaderView.titleLabel.text = currentSection.title
        sectionHeaderView.section = section
        sectionHeaderView.delegate = self
        sectionHeaderView.disclosureButton.selected = currentSection.open
        
        //TODO: refact it
        
        if let overlayView = currentSection.overlayView {
            sectionHeaderView.addOverHeaderSubView(overlayView)
        }
        
        if oneSectionAlwaysOpen && section == 0 && openedSectionIndex == NSNotFound {
            sectionHeaderViewOpenedAtIndex(0)
        }

        return sectionHeaderView
    }
    
}

extension AccordionTableViewController: SectionHeaderViewDelegate {
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, selectedAtIndex index: Int) {
        
        let section = sections[index]
            
        if !section.open {
            sectionHeaderViewOpenedAtIndex(index)
        } else if (!oneSectionAlwaysOpen) {
            sectionHeaderViewClosedAtIndex(index)
        }
        
    }
    
}
