//
//  JourneySolutionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class JourneySolutionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationCenterContraint: NSLayoutConstraint!
    @IBOutlet weak var friezeView: FriezeView!
    @IBOutlet weak var durationWalkerLabel: UILabel!

    var disruptions: [Disruption]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        UINib(nibName: "JourneySolutionView", bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        addShadow()
    }

    func setData(duration: Int32, friezeSection: [FriezePresenter.FriezeSection]) {
        aboutLabel.isHidden = true
        durationCenterContraint.constant = 0
        
        formattedDuration(duration)
        friezeView.addSection(sectionsClean: friezeSection)
    }
    
    func setRidesharingData(duration: Int32, friezeSection: [FriezePresenter.FriezeSection]) {
        aboutLabel.isHidden = false
        durationCenterContraint.constant = 7
        
        aboutLabel.attributedText = NSMutableAttributedString()
            .semiBold("about".localized(withComment: "about", bundle: NavitiaSDKUI.shared.bundle), color: Configuration.Color.main)
        formattedDuration(duration)
        
        friezeView.addSection(sectionsClean: friezeSection)
        if durationWalkerLabel != nil {
            durationWalkerLabel.isHidden = true
        }
    }
    
    private func formattedDuration(prefix: String = "", _ duration: Int32) {
        let formattedStringDuration = NSMutableAttributedString()
            .semiBold(prefix, color: Configuration.Color.main)
        formattedStringDuration.append(duration.toAttributedStringTime(sizeBold: 14, sizeNormal: 10.5))
        self.duration = formattedStringDuration
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension JourneySolutionView {
    
    var duration: NSAttributedString? {
        get {
            return durationLabel.attributedText
        }
        set {
            durationLabel.attributedText = newValue
        }
    }
    
}
