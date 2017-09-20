import Foundation
import Render
import NavitiaSDK

class TimeComponent: ViewComponent {
    var dateTime: String?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "backgroundColor": UIColor.white,
                "flexGrow": 1,
                "alignItems": YGAlign.center,
                "justifyContent": YGJustify.center,
            ]
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "flexGrow": 1,
                ]
            }),
            ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                component.styles = [
                    "color": config.colors.darkText,
                    "fontSize": 12,
                    "numberOfLines": 1,
                    "lineBreakMode": NSLineBreakMode.byClipping,
                ]

                component.text = timeText(isoString: self.dateTime!)
            }),
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "flexGrow": 1,
                ]
            })
        ])
    }
}
