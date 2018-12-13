//
//  UITableViewCell.swift
//  Android
//
//  Created by Marco Estrella on 7/23/18.
//

import Foundation
import Android
import java_swift

/// A cell in a table view.
///
/// This class includes properties and methods for setting and managing cell content
/// and background (including text, images, and custom views), managing the cell
/// selection and highlight state, managing accessory views, and initiating the
/// editing of the cell contents.
open class UITableViewCell: UIView {
    
    /// A string used to identify a cell that is reusable.
    public let reuseIdentifier: String?
    
    public let style: UITableViewCellStyle
    
    public private(set) var textLabel: UILabel!
    
    /// Android Layout name
    public private(set) var layoutName: String?
        
    // MARK: - Private
    
    internal static let defaultSize = CGSize(width: 320, height: UITableView.defaultRowHeight)
    
    // MARK: - Initializing a `UITableViewCell` Object
    
    /// Initializes a table cell with a style and a reuse identifier and returns it to the caller.
    public required init(style: UITableViewCellStyle = .default, reuseIdentifier: String?) {
        
        self.style = style
        self.reuseIdentifier = reuseIdentifier
        
        // while `UIView.init()` creates a view with an empty frame,
        // UIKit creates a {0,0, 320, 44} cell with this initializer
        let frame = CGRect(origin: .zero, size: UITableViewCell.defaultSize)
        
        super.init(frame: frame)
        
        self.textLabel = UILabel(frame: frame)
        
        addSubview(self.textLabel)
    }
    
    /// Inflate Android layout.
    public func inflateAndroidLayout(_ layoutName: String) {
        
        androidView.removeAllViews()
        
        androidView.layoutParams = AndroidFrameLayoutLayoutParams(width: AndroidFrameLayoutLayoutParams.WRAP_CONTENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
        
        let peripheralViewLayoutId = UIApplication.shared.androidActivity.getIdentifier(name: layoutName, type: "layout")
        
        let layoutInflater = Android.View.LayoutInflater.from(context: UIApplication.shared.androidActivity)
        
        let itemView = layoutInflater.inflate(resource: Android.R.Layout(rawValue: peripheralViewLayoutId),
                                              root: nil,
                                              attachToRoot: false)
        
        self.layoutName = layoutName
        
        androidView.addView(itemView)
    }
    
    /// Add Android child view.
    public func addChildView(view: AndroidView) {
        
        self.layoutName = nil
        
        androidView.removeAllViews()
        
        androidView.layoutParams = view.layoutParams
        
        androidView.addView(view)
    }
}

// MARK: - Supporting Types

public enum UITableViewCellSeparatorStyle: Int {
    
    case none
    case singleLine
    case singleLineEtched
}

public enum UITableViewCellStyle: Int {
    
    case `default`
    case value1
    case value2
    case subtitle
}

public enum UITableViewCellSelectionStyle: Int {
    
    case none
    case blue
    case gray
}

public enum UITableViewCellEditingStyle: Int {
    
    case none
    case delete
    case insert
}
