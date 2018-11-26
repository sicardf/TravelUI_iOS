//
//  StackScrollView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol StackScrollViewProtocol {
    
    func addSubview(_ view: UIView, margin: UIEdgeInsets)
    func reloadStack()
}

class StackScrollView: UIScrollView, StackScrollViewProtocol {

    var stackSubviews = [(view: UIView, margin: UIEdgeInsets)]()
    
    func addSubview(_ view: UIView, margin: UIEdgeInsets) {
        view.frame.origin.y = getViewOriginY(index: stackSubviews.count, margin: margin)
        view.frame.origin.x = getViewOriginX(margin: margin)
        view.frame.size.width = getViewSizeWidth(margin: margin)
        
        stackSubviews.append((view, margin))
        addSubview(view)
        
        contentSize.height = getContentSizeHeight()
    }
    
    public func reloadStack() {
        for (index, subview) in stackSubviews.enumerated() {
            subview.view.frame.origin.y = getViewOriginY(index: index, margin: subview.margin)
            subview.view.frame.origin.x = getViewOriginX(margin: subview.margin)
            subview.view.frame.size.width = getViewSizeWidth(margin: subview.margin)
        }
        
        contentSize.height = getContentSizeHeight()
    }
    
    public func selectSubviews<T>(type: T) -> [T] {
        var subviewsSelected = [T]()
        
        for (subview, _) in stackSubviews {
            if let subview = subview as? T {
                subviewsSelected.append(subview)
            }
        }
        
        return subviewsSelected
    }
    
    // MARK: Frame
    
    private func getViewOriginY(index: Int, margin: UIEdgeInsets) -> CGFloat {
        if index == 0 {
            return margin.top
        }
        
        if (index > stackSubviews.count - 1) {
            if let lastSubview = stackSubviews.last {
                return lastSubview.view.frame.origin.y + lastSubview.view.frame.height + lastSubview.margin.bottom + margin.top
            }
        }
        
        let previousView = stackSubviews[index - 1]
        
        return previousView.view.frame.origin.y + previousView.view.frame.height + previousView.margin.bottom + margin.top
    }
    
    private func getViewOriginX(margin: UIEdgeInsets) -> CGFloat {
        return margin.left
    }
    
    private func getViewSizeWidth(margin: UIEdgeInsets) -> CGFloat {
        return frame.size.width - (margin.left + margin.right)
    }
    
    private func getContentSizeHeight() -> CGFloat {
        guard let lastSubview = stackSubviews.last else {
            return 0
        }
        
        return lastSubview.view.frame.origin.y + lastSubview.view.frame.height + lastSubview.margin.bottom
    }
}