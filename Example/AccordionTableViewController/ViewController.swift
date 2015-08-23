//
//  ViewController.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 7/1/15.
//  Copyright (c) 2015 Klevison Matias. All rights reserved.
//

import UIKit

class ViewController: AccordionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneSectionAlwaysOpen = true
        sections =  getSectionArray()
        delegate = self
    }
    
    private func getSectionArray() -> [Section] {
        return [sectionOne(),sectionTwo(),sectionThree()]
    }
    
    func updateSectionOne() {
        let section = self.sections[0]
        section.view!.frame = CGRectMake(0, 0, self.view.frame.size.width, 400)
        self.reloadOpenedSection()
    }
    
    func updateSectionsOneAndTwo() {
        let section1 = self.sections[0]
        section1.view!.frame = CGRectMake(0, 0, self.view.frame.size.width, 100)
        
        let section2 = self.sections[1]
        section2.view!.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        
        self.reloadOpenedSection()
    }

    
    private func sectionOne() -> Section {
        
        let viewOfSection = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 300))
        viewOfSection.backgroundColor = UIColor.blueColor()
        let section = Section()
        section.view = viewOfSection
        section.title = "Facebook"
        section.backgroundColor = UIColor.redColor() // individual background color for a specific section, overrides the general color if set
        section.appearance.headerHeight = 100
        
        let overlayViewSection = UIImageView(frame: CGRectMake(0, 0, 50, 49))
        overlayViewSection.backgroundColor = UIColor.whiteColor()
        overlayViewSection.image = UIImage(named: "facebook")
        overlayViewSection.contentMode = .Center
        overlayViewSection.backgroundColor = UIColor.clearColor()
        section.overlayView = overlayViewSection
        
        let button = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        button.setTitle("Reload only this section", forState: .Normal)
        button.addTarget(self, action: "updateSectionOne", forControlEvents: .TouchUpInside)
        viewOfSection.addSubview(button)
        
        return section
    }
    
    private func sectionTwo() -> Section {
        
        let viewOfSection = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 300))
        viewOfSection.backgroundColor = UIColor.blueColor()
        let section = Section()
        section.view = viewOfSection
        section.title = "Twitter"
        section.backgroundColor = UIColor.blueColor() // individual background color for a specific section, overrides the general color if set
    
        let overlayViewSection = UIImageView(frame: CGRectMake(0, 0, 50, 49))
        overlayViewSection.backgroundColor = UIColor.whiteColor()
        overlayViewSection.image = UIImage(named: "twitter")
        overlayViewSection.contentMode = .Center
        overlayViewSection.backgroundColor = UIColor.clearColor()
        section.overlayView = overlayViewSection
        
        let button = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        button.setTitle("Reload sections one and two", forState: .Normal)
        button.addTarget(self, action: "updateSectionsOneAndTwo", forControlEvents: .TouchUpInside)
        viewOfSection.addSubview(button)
        
        return section
    }
    
    private func sectionThree() -> Section {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sectionViewController = storyboard.instantiateViewControllerWithIdentifier("SectionViewController") as UIViewController
        self.addChildViewController(sectionViewController)
        
        let section = Section()
        section.view = sectionViewController.view
        section.title = "ViewController"
        section.backgroundColor = UIColor.orangeColor() // individual background color for a specific section, overrides the general color if set
        
        return section
    }
}

extension ViewController: SectionViewControllerDelegate {
    
    func sectionViewControllerDidLayoutSubViews(size: CGSize) {
        let section = self.sections[2]
        section.view!.frame = CGRectMake(0, 0, size.width, size.height);
        
        if (openedSectionIndex == 2) {
            self.reloadOpenedSection()
        }
    }
    
}

extension ViewController: AccordionTableViewControllerDelegate {
    
    func accordionTableViewControllerSectionDidClose(section: Section) {
        print(__FUNCTION__)
    }
    
    func accordionTableViewControllerSectionDidOpen(section: Section) {
        print(__FUNCTION__)
    }

}