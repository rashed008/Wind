//
//  Utils.swift
//  Wind App
//
//  Created by RASHED on 7/14/24.
//

import UIKit

//MARK- ScrollView Contentsize
enum ScrollDirection {
    case Top
    case Right
    case Bottom
    case Left
    
    func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
        var contentOffset = CGPoint.zero
        switch self {
        case .Top:
            contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
        case .Right:
            contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
        case .Bottom:
            contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        case .Left:
            contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
        }
        return contentOffset
    }
}
//MARK- UIScrollView content size
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
        //Added extra height for scrollview
        contentSize.height += 37
    }
    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        if self.contentSize.height > UIScreen.main.bounds.height{
            self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
        }
    }
}
