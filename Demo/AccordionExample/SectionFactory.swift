//
//  SectionFactory.swift
//  AccordionExample
//
//  Created by Klevison Matias on 1/11/17.
//  Copyright © 2017 worQ. All rights reserved.
//

import UIKit

extension Section {

    static func sectionOne(view: UIView) -> Section {
        let viewOfSection = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        viewOfSection.backgroundColor = UIColor.blue
        let section = Section()
        section.view = viewOfSection
        section.title = "Facebook"
        // individual background color for a specific section, overrides the general color if set
        section.backgroundColor = UIColor.red
        section.appearance.headerHeight = 100
        
        let overlayViewSection = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49))
        overlayViewSection.backgroundColor = UIColor.white
        //overlayViewSection.image = UIImage(named: "facebook")
        overlayViewSection.contentMode = .center
        overlayViewSection.backgroundColor = UIColor.clear
        section.overlayView = overlayViewSection
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        button.setTitle("Reload only this section", for: .normal)
        viewOfSection.addSubview(button)
        
        return section
    }
    
    static func sectionTwo(view: UIView) -> Section {
        let viewOfSection = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        viewOfSection.backgroundColor = UIColor.blue
        let section = Section()
        section.view = viewOfSection
        section.title = "Twitter"
        // individual background color for a specific section, overrides the general color if set
        section.backgroundColor = UIColor.blue
        
        let overlayViewSection = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 49))
        overlayViewSection.backgroundColor = UIColor.white
        overlayViewSection.image = UIImage(named: "twitter")
        overlayViewSection.contentMode = .center
        overlayViewSection.backgroundColor = UIColor.clear
        section.overlayView = overlayViewSection
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        button.setTitle("Reload sections one and two", for: .normal)
        viewOfSection.addSubview(button)
        
        return section
    }
    
    static func sectionThree(vc viewController: UIViewController) -> Section {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sectionViewController = storyboard.instantiateViewController(withIdentifier: "SectionViewController") as UIViewController
        viewController.addChildViewController(sectionViewController)
        
        let section = Section()
        section.view = sectionViewController.view
        section.title = "ViewController"
        // individual background color for a specific section, overrides the general color if set
        section.backgroundColor = UIColor.orange
        
        return section
    }
    
}
