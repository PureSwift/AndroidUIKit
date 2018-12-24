//
//  UIRefreshControl.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 9/17/18.
//

import Foundation
import Android

open class UIRefreshControl: UIControl {
    
    internal lazy var androidSwipeRefreshLayout: AndroidSwipeRefreshLayout = {
        
        let swipeRefreshLayout = AndroidSwipeRefreshLayout(context: UIScreen.main.activity)
        
        swipeRefreshLayout.layoutParams = AndroidFrameLayoutLayoutParams(width: AndroidFrameLayoutLayoutParams.WRAP_CONTENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
        
        let refreshControlColor = UIScreen.main.activity.getIdentifier(name: "refreshControlColor", type: "color")
        
        if(refreshControlColor != 0) {
            
            swipeRefreshLayout.setColorSchemeResources(colors: refreshControlColor)
        }
        
        return swipeRefreshLayout
    }()
    
    //public var tintColor: UIColor!
    
    public var isRefreshing: Bool {
        get {
            return androidSwipeRefreshLayout.isRefreshing
        }
        
        set {
            androidSwipeRefreshLayout.isRefreshing = newValue
        }
    }
    
    public var frame: CGRect = .zero {
        
        didSet {
            updateSwipeRefreshLayoutFrame()
        }
    }
    
    public init(frame: CGRect = .zero) {
        super.init()
        
        self.frame = frame
        self.updateSwipeRefreshLayoutFrame()
    }
    
    private func updateSwipeRefreshLayoutFrame() {
        
        let frameDp = frame.applyingDP()
        
        // set origin
        androidSwipeRefreshLayout.setX(x: Float(frameDp.minX))
        androidSwipeRefreshLayout.setY(y: Float(frameDp.minY))
        
        // set size
        let widthDp = Int(frameDp.width)
        let heightDp = Int(frameDp.height)
        NSLog("\(type(of: self)) \(#function) widthDp: \(widthDp) - heightDp: \(heightDp)")
        androidSwipeRefreshLayout.layoutParams = AndroidFrameLayoutLayoutParams(width: widthDp, height: heightDp)
    }
    
    open override func targetAdded(action: @escaping () -> (), for event: UIControlEvents) {
        
        androidSwipeRefreshLayout.setOnRefreshListener {
            action()
        }
    }
    
    open override func targetRemoved(for event: UIControlEvents) {
        
        androidSwipeRefreshLayout.setOnRefreshListener(listener: nil)
    }
    
    public func beginRefreshing() {
        
        androidSwipeRefreshLayout.isRefreshing = true
    }
    
    public func endRefreshing() {
        
        androidSwipeRefreshLayout.isRefreshing = false
    }
}
