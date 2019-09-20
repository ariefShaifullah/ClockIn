//
//  Extensions.swift
//  ClockIn
//
//  Created by Arief Shaifullah Akbar on 17/09/19.
//  Copyright © 2019 Arief Shaifullah Akbar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setAnchor(centerY: NSLayoutYAxisAnchor? = nil, centerX: NSLayoutXAxisAnchor? = nil, top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil ) {
        
        // this is required to make programmatic constraints works
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: 0).isActive=true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: 0).isActive=true
        }
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom!).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight!).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}
