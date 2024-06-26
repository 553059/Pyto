//
//  Divider.swift
//  InterfaceBuilder
//
//  Created by Emma on 16-09-22.
//

import UIKit

class StackViewDivider: UIView {}

/// A spacer in a Stack view.
public struct Divider: InterfaceBuilderView {
    
    public init() {}
    
    public var type: UIView.Type {
        return StackViewDivider.self
    }
    
    public func preview(view: UIView) {}
    
    public var previewColor: UIColor? {
        .secondaryLabel
    }
    
    public func configure(view: UIView, model: inout InterfaceModel) {
    }
    
    public var image: UIImage? {
        UIImage(systemName: "minus")
    }
    
    public func makeView() -> UIView {
        StackViewDivider(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
    }
}
