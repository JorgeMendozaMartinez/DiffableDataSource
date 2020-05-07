//
//  UIControl.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit

extension UIControl {
    
    func addTarget(for controlEvent: UIControl.Event, using closure: @escaping (UIControl) -> Void){
        let wrappedClosure = TargetClosure(closure)
        
        let closures = targetClosures.object(forKey: self) ?? []
        targetClosures.setObject(closures.adding(wrappedClosure) as NSArray, forKey: self)
        
        addTarget(wrappedClosure, action: #selector(TargetClosure.invoke(_:)), for: controlEvent)
    }
    
}

fileprivate let targetClosures = NSMapTable<UIControl, NSArray>.weakToStrongObjects()

fileprivate class TargetClosure: NSObject {
    let value: (UIControl) -> Void
    init(_ closure: @escaping (UIControl) -> Void) { value = closure }
    @objc func invoke(_ control: UIControl) { value(control) }
}

