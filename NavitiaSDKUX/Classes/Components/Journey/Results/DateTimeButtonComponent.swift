//
//  DateTimeButtonComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Results {
    class DateTimeButtonComponent: ButtonComponent {
        var datetime: Date?
        var datetimeRepresents: JourneysRequestBuilder.DatetimeRepresents?
        
        override func render() -> NodeType {
            let computedStyles: [String: Any] = mergeDictionaries(dict1: listRowStyles, dict2: self.styles)
            return ComponentNode(ButtonComponent(), in: self, props: {(component, _) in
                component.styles = computedStyles
            }).add(children: [
                ComponentNode(TextComponent(), in: self, props: {(component, _) in
                    let datetimeRepresentsText = NSLocalizedString(
                        String(format: "%@_with_colon", self.datetimeRepresents!.rawValue),
                        bundle: self.bundle,
                        comment: "Datetime represent label"
                    )
                    component.text = String(format: "%@ %@", datetimeRepresentsText, longDateText(datetime: self.datetime!))
                    component.styles = self.textStyles
                })
            ])
        }
        
        let listRowStyles: [String: Any] = [
            "paddingTop": config.metrics.marginL,
            "paddingBottom": config.metrics.margin,
            "flexDirection": YGFlexDirection.row,
        ]
        let textStyles: [String: Any] = [
            "color": config.colors.tertiaryText,
            "fontWeight": "bold",
        ]
        let viewStyles: [String: Any] = [
            "alignItems": YGAlign.flexEnd,
            "flexGrow": 1,
        ]
        let iconStyles: [String: Any] = [
            "color": config.colors.tertiaryText,
            "fontSize": 16,
        ]
    }
}