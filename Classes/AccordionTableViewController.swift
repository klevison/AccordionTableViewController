//
//  Accordion.swift
//  AccordionTableViewController
//
//  Created by Klevison Matias on 1/6/17.
//  Copyright © 2017 Klevison. All rights reserved.
//

import UIKit

//MARK: AccordionTableViewController

protocol AccordionTableViewControllerDelegate: class {
    func accordionTableViewControllerSectionDidOpen(section: Section)
    func accordionTableViewControllerSectionDidClose(section: Section)
}

class AccordionTableViewController: UITableViewController {

    var openAnimation: UITableViewRowAnimation = .fade
    var closeAnimation: UITableViewRowAnimation = .fade
    var sections = [Section]()
    var oneSectionAlwaysOpen = false
    weak var delegate: AccordionTableViewControllerDelegate?
    fileprivate let sectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    fileprivate let sectionCellID = "CellIdentifier"
    var openedSection: Section? {
        return sections
            .filter { $0.open == true }
            .first
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {
        let sectionHeaderNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: sectionHeaderViewIdentifier)
        tableView.bounces = false
        tableView.separatorStyle = .none
    }

    func reloadOpenedSection() {
        openedSection
            .flatMap { [IndexPath(row: 0, section: $0.sectionIndex!)] }
            .map { tableView.reloadRows(at: $0, with: openAnimation) }
    }

    private func indexPathsToDelete() -> [IndexPath] {
        if let previousOpenSection = openedSection, let previousOpenSectionIndex = previousOpenSection.sectionIndex {
            return [IndexPath(row: 0, section: previousOpenSectionIndex)]
        }

        return [IndexPath]()
    }

    private func updateTable(insert indexPathsToInsert: [IndexPath], delete indexPathsToDelete: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPathsToInsert, with: openAnimation)
        tableView.deleteRows(at: indexPathsToDelete, with: closeAnimation)
        tableView.endUpdates()

        let sectionRect = tableView.rect(forSection: indexPathsToInsert[0].section)
        tableView.scrollRectToVisible(sectionRect, animated: true)

        if let index = indexPathsToInsert.first?.section {
            delegate?.accordionTableViewControllerSectionDidOpen(section: sections[index])
        }
        if let index = indexPathsToDelete.first?.section {
            delegate?.accordionTableViewControllerSectionDidClose(section: sections[index])
        }

    }

    func openSection(at index: Int) {
        let indexPathsToInsert = [IndexPath(row: 0, section: index)]
        let indexPathsToDelete = self.indexPathsToDelete()

        if let previousOpenSection = openedSection, let previousOpenSectionIndex = previousOpenSection.sectionIndex {
            previousOpenSection.open = false
            guard let praviousSectionHeaderView = tableView.headerView(forSection: previousOpenSectionIndex) as? SectionHeaderView else {
                return
            }
            praviousSectionHeaderView.disclosureButton.isSelected = false
            delegate?.accordionTableViewControllerSectionDidClose(section: previousOpenSection)
        }
        sections[index].open = true
        updateTable(insert: indexPathsToInsert, delete: indexPathsToDelete)
    }

    func closeSection(at index: Int) {
        let currentSection = sections[index]
        currentSection.open = false
        if tableView.numberOfRows(inSection: index) > 0 {
            var indexPathsToDelete = [IndexPath]()
            indexPathsToDelete.append(IndexPath(row: 0, section: index))
            tableView.deleteRows(at: indexPathsToDelete, with: closeAnimation)
        }
        delegate?.accordionTableViewControllerSectionDidClose(section: currentSection)
    }

}

extension AccordionTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].open {
            return 1
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cellIdentifier = "\(sectionCellID)\(section.sectionIndex!)"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        cell.contentView.addSubview(section.view!)
        cell.contentView.autoresizesSubviews = false
        cell.contentView.frame = section.view!.frame

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].view?.frame.size.height ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].appearance.headerHeight
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderViewIdentifier) as? SectionHeaderView else {
            return nil
        }
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
        sectionHeaderView.disclosureButton.isSelected = currentSection.open

        //TODO: refact it
        if let overlayView = currentSection.overlayView {
            sectionHeaderView.addOverHeaderSubView(view: overlayView)
        }

        if oneSectionAlwaysOpen && section == 0 && openedSection == nil{
            openSection(at: section)
            sectionHeaderView.disclosureButton.isSelected = true
        }

        return sectionHeaderView
    }

}

extension AccordionTableViewController: SectionHeaderViewDelegate {

    func sectionHeaderView(sectionHeaderView: SectionHeaderView, selectedAtIndex index: Int) {
        let section = sections[index]
        if !section.open {
            openSection(at: index)
            sectionHeaderView.disclosureButton.isSelected = true
        } else if !oneSectionAlwaysOpen {
            closeSection(at: index)
            sectionHeaderView.disclosureButton.isSelected = oneSectionAlwaysOpen && openedSection?.sectionIndex == index
        }
    }

}

//MARK: Section

final class Section {

    var open = false
    var view: UIView?
    var overlayView: UIView?
    var headerView: SectionHeaderView?
    var title: String?
    var backgroundColor: UIColor?
    var sectionIndex: Int?
    var appearance = Appearance()

}

//MARK: Appearance

final class Appearance {

    var headerHeight = CGFloat(50)
    var headerFont = UIFont.systemFont(ofSize: 15)
    var headerTitleColor = UIColor.black
    var headerColor = UIColor.white
    var headerSeparatorColor = UIColor.black
    var headerArrowImageOpened = #imageLiteral(resourceName: "carat")
    var headerArrowImageClosed = #imageLiteral(resourceName: "carat-open")

}

//MARK: SectionHeaderView

protocol SectionHeaderViewDelegate: class {
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, selectedAtIndex index: NSInteger)
}

final class SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var headerSeparatorView: UIView!
    @IBOutlet weak var backgroundHeaderView: UIView!
    @IBOutlet weak var overHeaderView: UIView!

    weak var delegate: SectionHeaderViewDelegate?
    var section: NSInteger?
    var headerSectionAppearence: Appearance? {
        didSet {
            headerSeparatorView.backgroundColor = headerSectionAppearence!.headerSeparatorColor
            backgroundHeaderView.backgroundColor = headerSectionAppearence!.headerColor
            titleLabel.font = headerSectionAppearence!.headerFont
            titleLabel.textColor = headerSectionAppearence!.headerTitleColor
            disclosureButton.setImage(headerSectionAppearence!.headerArrowImageOpened, for: .normal)
            disclosureButton.setImage(headerSectionAppearence!.headerArrowImageClosed, for: .selected)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SectionHeaderView.toggleOpen(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        overHeaderView.subviews.forEach { $0.removeFromSuperview() }
    }

    func addOverHeaderSubView(view: UIView) {
        self.overHeaderView.addSubview(view)
    }

    @IBAction func toggleOpen(_ sender: AnyObject) {
        delegate?.sectionHeaderView(sectionHeaderView: self, selectedAtIndex: section!)
    }

}
