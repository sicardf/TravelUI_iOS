//
//  FriezeView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class FriezeView: UIView {

    private var friezeSectionsView = [FriezeSectionView]()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal func addSection(friezeSections: [FriezePresenter.FriezeSection]) {
        releaseUnusedSectionView(sectionsCount: friezeSections.count)
        parseFriezeSectionView(friezeSections: friezeSections)
        updatePositionFriezeSectionView()
    }
    
    private func releaseUnusedSectionView(sectionsCount: Int) {
        if friezeSectionsView.count > sectionsCount {
            while friezeSectionsView.count > sectionsCount {
                friezeSectionsView[sectionsCount].removeFromSuperview()
                friezeSectionsView.remove(at: sectionsCount)
            }
        }
    }
    
    private func parseFriezeSectionView(friezeSections: [FriezePresenter.FriezeSection]) {
        for (index, section) in friezeSections.enumerated() {
            if index < friezeSectionsView.count {
                let friezeSectionView = friezeSectionsView[index]
                
                reuseFriezeSectionView(index: index, friezeSection: section, friezeSectionView: friezeSectionView)
            } else {
                let friezeSectionView = FriezeSectionView()
                
                reuseFriezeSectionView(index: index, friezeSection: section, friezeSectionView: friezeSectionView)
                friezeSectionsView.append(friezeSectionView)
                addSubview(friezeSectionView)
            }
        }
    }

    private func reuseFriezeSectionView(index: Int, friezeSection: FriezePresenter.FriezeSection, friezeSectionView: FriezeSectionView) {
        friezeSectionView.color = friezeSection.color
        friezeSectionView.name = friezeSection.name
        friezeSectionView.icon = friezeSection.icon
        friezeSectionView.displayDisruption(friezeSection.disruptionIcon, color: friezeSection.disruptionColor)
        
        friezeSectionView.separator = index == 0 ? false : true
    }
    
    internal func updatePositionFriezeSectionView() {
        let padding = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        var position = CGPoint(x: 0, y: 0)

        for friezeSectionView in friezeSectionsView {
            if position.x + CGFloat(friezeSectionView.frame.size.width) > frame.size.width {
                position.x = 0
                position.y = position.y + friezeSectionView.frame.size.height + padding.top
                frame.size.height = frame.size.height + friezeSectionView.frame.size.height + padding.top
            }
            
            friezeSectionView.frame.origin = position
            position.x = position.x + CGFloat(friezeSectionView.frame.size.width) + padding.right
        }
    }
}
