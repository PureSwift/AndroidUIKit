//
//  UIControl.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 9/17/18.
//

import Foundation

open class UIControl {
    
    var state: UIControlState = []
    
    public var isEnabled: Bool = true
    
    public var _actions = [UIControlEvent : [UInt: () -> ()]]()
    
    public var lastActionIdentifier: UInt = 0
    
    func addTarget(action: @escaping () -> (), for event: UIControlEvent) {
        
        let identifier = lastActionIdentifier + 1
        var actionsForEvent = _actions[event] ?? [:]
        actionsForEvent[identifier] = action
        _actions[event] = actionsForEvent
        lastActionIdentifier = identifier
        
        targetAdded(action: action, for: event)
    }
    
    func removeTarget(actionId: UInt, for event: UIControlEvent) {
        
        guard var actionsForEvent = _actions[event]
            else { return }
        
        if actionsForEvent.count == 1 {
            
            _actions.removeValue(forKey: event)
        } else {
            
            actionsForEvent.removeValue(forKey: actionId)
            _actions[event] = actionsForEvent
        }
        
        targetRemoved(for: event)
    }
    
    open func targetAdded(action: @escaping () -> (), for event: UIControlEvent){}
    
    open func targetRemoved(for event: UIControlEvent){}
}

/// Constants describing the state of a control.
///
/// A control can have more than one state at a time.
/// Controls can be configured differently based on their state.
/// For example, a `UIButton` object can be configured to display one image
/// when it is in its normal state and a different image when it is highlighted.
public struct UIControlState: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int = 0) {
        
        self.rawValue = rawValue
    }
    
    /// The normal, or default state of a control—that is, enabled but neither selected nor highlighted.
    public static let normal = UIControlState(rawValue: 0)
    
    public static let highlighted = UIControlState(rawValue: 1 << 0)
    
    public static let disabled = UIControlState(rawValue: 1 << 1)
    
    public static let selected = UIControlState(rawValue: 1 << 2)
    
    public static let focused = UIControlState(rawValue: 1 << 3)
    
    public static let application = UIControlState(rawValue: 0x00FF0000)
}

public struct UIControlEvent: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int = 0) {
        
        self.rawValue = rawValue
    }
    
    public static let touchDown = UIControlEvent(rawValue: 1 << 0)
    public static let touchDownRepeat = UIControlEvent(rawValue: 1 << 1)
    public static let touchDragInside = UIControlEvent(rawValue: 1 << 2)
    public static let touchDragOutside = UIControlEvent(rawValue: 1 << 3)
    public static let touchDragEnter = UIControlEvent(rawValue: 1 << 4)
    public static let touchDragExit = UIControlEvent(rawValue: 1 << 5)
    public static let touchUpInside = UIControlEvent(rawValue: 1 << 6)
    public static let touchUpOutside = UIControlEvent(rawValue: 1 << 7)
    public static let touchCancel = UIControlEvent(rawValue: 1 << 8)
    public static let valueChanged = UIControlEvent(rawValue: 1 << 12)
    public static let primaryActionTriggered = UIControlEvent(rawValue: 1 << 13)
    public static let editingDidBegin = UIControlEvent(rawValue: 1 << 16)
    public static let editingChanged = UIControlEvent(rawValue: 1 << 17)
    public static let editingDidEnd = UIControlEvent(rawValue: 1 << 18)
    public static let editingDidEndOnExit = UIControlEvent(rawValue: 1 << 19)
    public static let allTouchEvents = UIControlEvent(rawValue: 0x00000FFF)
    public static let allEditingEvents = UIControlEvent(rawValue: 0x000F0000)
    public static let applicationReserved = UIControlEvent(rawValue: 0x0F000000)
    //public static let systemReserved = UIControlEvent(rawValue: 0xF0000000)
    //public static let allEvents = UIControlEvent(rawValue: 0xFFFFFFFF)
}

extension UIControlEvent: Hashable {
    
    public var hashValue: Int {
        return rawValue
    }
}
