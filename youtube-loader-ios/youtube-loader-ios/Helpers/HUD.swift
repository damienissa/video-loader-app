//
//  ActivityIndicator.swift
//  Aqssar
//
//  Created by Dima Virych on 9/25/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

class HUD: UIActivityIndicatorView {

    // MARK: - Properties
    
    private var container: UIView!
    

    // MARK: - Lifecycle
    
    static func show(on view: UIView, with style: UIActivityIndicatorView.Style = .large) -> HUD {
        
        let activity = HUD(style: style)
        
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.add(on: view)
        
        return activity
    }
    
    func hide() {
        
        stopAnimating()
        container?.removeFromSuperview()
        container = nil
    }
    
    private func add(bgColor color: UIColor = .lightGray, on view: UIView) {
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        container.layer.cornerRadius = 8
        container.backgroundColor = color
        container.center = view.center
        center = CGPoint(x: 40, y: 40)
        container.addSubview(self)
        view.addSubview(container)
    }
}
