//
//  UIContextualAction.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit

extension UIContextualAction {
    convenience init(style: UIContextualAction.Style, backgroundColor: UIColor? = nil, image: UIImage? = nil, title: String?, handler: @escaping UIContextualAction.Handler) {
        
        self.init(style: style, title: title, handler: handler)
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        }
        self.image = image
    }
}
