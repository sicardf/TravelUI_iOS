//
//  FriezeSectionView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

class FriezeSectionView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var separatorImage: UIImageView!
    @IBOutlet var separatorTransportConstraint: NSLayoutConstraint!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var tagTransportView: UIView!
    @IBOutlet weak var tagTransportLabel: UILabel!
    @IBOutlet weak var disruptionImage: UIImageView!
    
    var height: CGFloat = 27
    
    var separator: Bool = true {
        didSet {
            separatorImage.isHidden = !separator
            separatorTransportConstraint.isActive = separator
            updateWitdh()
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        UINib(nibName: FriezeSectionView.identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        frame.size.height = height
        
        setupDisruption()
        setupTag()
        
        updateWitdh()
    }
    
    private func setupTag() {
        tagTransportView.isHidden = true
        tagTransportLabel.isHidden = true
    }
    
    private func setupDisruption() {
        disruptionImage.isHidden = true
        updateWitdh()
    }
    
    func displayDisruption(_ iconName: String?, color: String?) {
        guard let name = iconName, let image = Disruption().levelImage(name: name) else {
            disruptionImage.isHidden = true
            
            return
        }

        disruptionImage.isHidden = false
        disruptionImage.image = image
        updateWitdh()
    }
    
}

extension FriezeSectionView {
    
    var color: UIColor? {
        get {
            return tagTransportView.backgroundColor
        }
        set {
            tagTransportView.backgroundColor = newValue
            updateWitdh()
        }
    }
    
    var name: String? {
        get {
            return tagTransportLabel.text
        }
        set {
            if let newValue = newValue {
                let tagBackgroundColor = tagTransportView.backgroundColor ?? .black
                
                tagTransportView.isHidden = false
                tagTransportLabel.isHidden = false
                tagTransportLabel.attributedText = NSMutableAttributedString()
                    .bold(newValue, color: tagBackgroundColor.contrastColor(), size: 9)
                updateWitdh()
            } else {
                tagTransportView.isHidden = true
                tagTransportLabel.isHidden = true
                updateWitdh()
            }
        }
    }
    
    var icon: String? {
        get {
            return transportLabel.text
        }
        set {
            if let newValue = newValue {
                transportLabel.attributedText = NSMutableAttributedString()
                    .icon(newValue, size: 20)
                updateWitdh()
            }
        }
    }
    
    func updateWitdh() {
        let marginSeparator = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        let marginTransportTag = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let paddingTransportTag = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        let widthDisruption: CGFloat = 6
        var width: CGFloat = 25
        
        if !separatorImage.isHidden {
            width = width + separatorImage.frame.size.width + marginSeparator.right
        }
        
        if !tagTransportView.isHidden {
            if let widthPart = tagTransportLabel.attributedText?.boundingRect(with: CGSize(width: 0, height: 0), options: .usesLineFragmentOrigin, context: nil).width {
                width = width + marginTransportTag.left + marginTransportTag.right + widthPart + paddingTransportTag.right
            }
            
            if !disruptionImage.isHidden {
                width = width + widthDisruption
            }
        }
        
        frame.size.width = width
    }
}

