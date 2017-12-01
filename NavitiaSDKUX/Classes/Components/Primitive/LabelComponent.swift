//
//  LabelComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

open class LabelComponent: StylizedComponent<NilState> {
    var text: String = ""
    var sharedFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    open override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
            component.styles = self.styles
        }).add(children:[
             Node<UILabel>() { view, layout, _ in
                view.text = self.text
                self.applyLabelStyles(view: view, layout: layout)
             }
        ])
    }
    
    public func applyLabelStyles(view: UILabel, layout: YGLayout) {
        super.applyStyles(view: view, layout: layout)
        view.font = UIFont.systemFont(ofSize: 14)
        for (prop, value) in styles {
            switch prop {
            case "color": view.textColor = value as! UIColor; break
            case "numberOfLines": view.numberOfLines = value as! Int; break
            case "lineBreakMode": view.lineBreakMode = value as! NSLineBreakMode; break
            case "fontSize": setFontSize(size: value as! Int); view.font = self.sharedFont; break
            case "fontWeight": setFontWeight(weight: value as! String); view.font = self.sharedFont; break
            case "fontFamily": setFontFamily(name: value as! String); view.font = self.sharedFont; break
            default: break
            }
        }
    }
    
    func setFontSize(size: Int) {
        self.sharedFont = self.sharedFont.withSize(CGFloat(size))
    }
    
    func setFontWeight(weight: String) {
        switch weight {
        case "bold": self.sharedFont = UIFont.systemFont(ofSize: self.sharedFont.pointSize, weight: UIFontWeightBold)
        default: self.sharedFont = UIFont.systemFont(ofSize: self.sharedFont.pointSize, weight: UIFontWeightRegular)
        }
    }
    
    func setFontFamily(name: String) {
        self.sharedFont = UIFont.iconFontOfSize(name: name, size: self.sharedFont.pointSize)
    }
}
