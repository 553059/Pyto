//
//  PyButtonItem.swift
//  Pyto
//
//  Created by Emma Labbé on 20-07-19.
//  Copyright © 2018-2021 Emma Labbé. All rights reserved.
//

import UIKit

@available(iOS 13.0, *) @objc public class PyButtonItem: PyWrapper {

    var barButtonItem: UIBarButtonItem {
        return managed as! UIBarButtonItem
    }
    
    @objc public var action: PyValue?
    
    @objc public var managedValue: PyValue?
    
    @objc public func callAction() {
        action?.call(parameter: managedValue)
    }
    
    var __customView: PyView?
    
    @objc public var _customView: PyView? {
        return get {
            if self.__customView != nil {
                return self.__customView
            } else if let view = self.barButtonItem.customView {
                self.__customView = PyView.values[view] ?? PyButton(managed: view)
                return self.__customView
            } else {
                return nil
            }
        }
    }
    
    @objc public var title: String? {
        get {
            return get {
                if let button = self.barButtonItem.customView as? UIButton {
                    if #available(iOS 15.0, *) {
                        return button.configuration?.title
                    } else {
                        return nil
                    }
                } else {
                    return self.barButtonItem.title
                }
            }
        }
        
        set {
            set {
                if let button = self.barButtonItem.customView as? UIButton {
                    if #available(iOS 15.0, *) {
                        let attrString = NSMutableAttributedString(string: newValue ?? "")
                        let attrs = button.attributedTitle(for: .normal)?.attributes(at: 0, effectiveRange: nil)
                        attrString.addAttributes(attrs ?? [:], range: NSRange(location: 0, length: (newValue as? NSString)?.length ?? 0))
                        button.setAttributedTitle(attrString, for: .normal)
                    }
                } else {
                    self.barButtonItem.title = newValue
                }
            }
        }
    }
    
    @objc public var image: UIImage? {
        get {
            return get {
                if let button = self.barButtonItem.customView as? UIButton {
                    if #available(iOS 15.0, *) {
                        return button.configuration?.image
                    } else {
                        return nil
                    }
                } else {
                    return self.barButtonItem.image
                }
            }
        }
        
        set {
            set {
                if let button = self.barButtonItem.customView as? UIButton {
                    if #available(iOS 15.0, *) {
                        button.configuration?.image = newValue
                    }
                } else {
                    self.barButtonItem.image = newValue
                }
            }
        }
    }
    
    @objc public var style: UIBarButtonItem.Style {
        get {
            return get {
                return self.barButtonItem.style
            }
        }
        
        set {
            set {
                self.barButtonItem.style = newValue
            }
        }
    }
    
    @objc public var enabled: Bool {
        get {
            return get {
                return self.barButtonItem.isEnabled
            }
        }
        
        set {
            set {
                self.barButtonItem.isEnabled = newValue
            }
        }
    }
    
    public override init(managed: NSObject! = NSObject()) {
        super.init(managed: managed)
    }
    
    @objc public init(style: UIBarButtonItem.Style) {
        super.init(managed: PyWrapper.get {
            return UIBarButtonItem(title: nil, style: style, target: nil, action: nil)
        })
        
        set {
            self.barButtonItem.target = self
            self.barButtonItem.action = #selector(self.callAction)
        }
    }
    
    @objc public init(systemItem: UIBarButtonItem.SystemItem) {
        super.init(managed: PyWrapper.get {
            return UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        })
        
        set {
            self.barButtonItem.target = self
            self.barButtonItem.action = #selector(self.callAction)
        }
    }
    
    @objc var references = 0
    
    @objc func releaseReference() {
        references -= 1
        
        if references == 0 {
            if Thread.current.isMainThread {
                for (key, views) in UIView.Holder.leftButtonItems {
                    if let i = views.firstIndex(of: barButtonItem) {
                        UIView.Holder.leftButtonItems[key]?.remove(at: i)
                    }
                }
                
                for (key, views) in UIView.Holder.rightButtonItems {
                    if let i = views.firstIndex(of: barButtonItem) {
                        UIView.Holder.rightButtonItems[key]?.remove(at: i)
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    
                    guard let barButtonItem = self?.barButtonItem else {
                        return
                    }
                    
                    for (key, views) in UIView.Holder.leftButtonItems {
                        if let i = views.firstIndex(of: barButtonItem) {
                            UIView.Holder.leftButtonItems[key]?.remove(at: i)
                        }
                    }
                    
                    for (key, views) in UIView.Holder.rightButtonItems {
                        if let i = views.firstIndex(of: barButtonItem) {
                            UIView.Holder.rightButtonItems[key]?.remove(at: i)
                        }
                    }
                }
            }
        }
    }
    
    @objc func retainReference() {
        references += 1
    }
    
    @objc public static let StylePlain = UIBarButtonItem.Style.plain
    
    @objc public static let StyleDone = UIBarButtonItem.Style.done
    
    
    @objc public static let SystemItemAction = UIBarButtonItem.SystemItem.action
    
    @objc public static let SystemItemAdd = UIBarButtonItem.SystemItem.add
    
    @objc public static let SystemItemBookmarks = UIBarButtonItem.SystemItem.bookmarks
    
    @objc public static let SystemItemCamera = UIBarButtonItem.SystemItem.camera
    
    @objc public static let SystemItemCancel = UIBarButtonItem.SystemItem.cancel
    
    @objc public static let SystemItemCompose = UIBarButtonItem.SystemItem.compose
    
    @objc public static let SystemItemDone = UIBarButtonItem.SystemItem.done
    
    @objc public static let SystemItemEdit = UIBarButtonItem.SystemItem.edit
    
    @objc public static let SystemItemFastForward = UIBarButtonItem.SystemItem.fastForward
    
    @objc public static let SystemItemFixedSpace = UIBarButtonItem.SystemItem.fixedSpace
    
    @objc public static let SystemItemFlexibleSpace = UIBarButtonItem.SystemItem.flexibleSpace
    
    @objc public static let SystemItemOrganize = UIBarButtonItem.SystemItem.organize
    
    @objc public static let SystemItemPause = UIBarButtonItem.SystemItem.pause
    
    @objc public static let SystemItemPlay = UIBarButtonItem.SystemItem.play
    
    @objc public static let SystemItemRedo = UIBarButtonItem.SystemItem.redo
    
    @objc public static let SystemItemRefresh = UIBarButtonItem.SystemItem.refresh
    
    @objc public static let SystemItemReply = UIBarButtonItem.SystemItem.reply
    
    @objc public static let SystemItemRewind = UIBarButtonItem.SystemItem.rewind
    
    @objc public static let SystemItemSave = UIBarButtonItem.SystemItem.save
    
    @objc public static let SystemItemSearch = UIBarButtonItem.SystemItem.search
    
    @objc public static let SystemItemStop = UIBarButtonItem.SystemItem.stop
    
    @objc public static let SystemItemTrash = UIBarButtonItem.SystemItem.trash
    
    @objc public static let SystemItemUndo = UIBarButtonItem.SystemItem.undo
}
