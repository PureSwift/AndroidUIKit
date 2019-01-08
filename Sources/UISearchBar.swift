//
//  UISearchBar.swift
//  AndroidBluetooth
//
//  Created by Marco Estrella on 1/7/19.
//

import Foundation
import Android
import java_swift

/* UISearchBar provides a text field for entering text, a search button, a bookmark button, and a cancel button.
 * A search bar does not actually perform any searches. You use a delegate, an object conforming to the UISearchBarDelegate protocol,
 * to implement the actions when text is entered and buttons are clicked.
 */
public class UISearchBar: UIView {
    
    // MARK: Android
    
    internal private(set) lazy var  androidSearchViewId: Int = {
        return AndroidViewCompat.generateViewId()
    }()
    
    internal private(set) lazy var androidSearchView: AndroidSearchView = { [unowned self] in
        
        let searchView = AndroidSearchView(context: UIApplication.shared.androidActivity)
        searchView.setId(androidSearchViewId)
        searchView.layoutParams = AndroidFrameLayoutLayoutParams(width: AndroidFrameLayoutLayoutParams.WRAP_CONTENT, height: AndroidFrameLayoutLayoutParams.WRAP_CONTENT)
        
        let searchViewQueryListener = SearchViewQueryListener(self)
        searchView.setOnQueryTextListener(searchViewQueryListener)
        
        searchView.setOnCloseListener { [unowned self] in
            
            self.delegate?.searchBarCancelButtonClicked(self)
            
            return false
        }
        
        return searchView
        }()
    
    public func androidSearchViewExpand(){
        
        androidSearchView.onActionViewExpanded()
    }
    
    public func androidSearchViewCollapse(){
        
        androidSearchView.onActionViewCollapsed()
    }
    
    // MARK: Initializing the Search Bar
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        androidView.addView(androidSearchView)
        
        backgroundColor = UIColor.white
    }
    
    // MARK: Handling Search Bar Interactions
    
    /// A collection of optional methods that you implement to make a search bar control functional.
    public var delegate: UISearchBarDelegate?
    
    // MARK: Text Content
    
    /// The string that is displayed when there is no other text in the text field.
    public var placeholder: String? {
        
        get {
            return androidSearchView.getQueryHint()
        }
        
        set {
            androidSearchView.setQueryHint(newValue)
        }
    }
    
    /// A single line of text displayed at the top of the search bar.
    public var prompt: String?
    
    fileprivate var textWasSettedInternally = false
    /// The current or starting search text.
    public var text: String? {
        
        didSet {
            
            if !textWasSettedInternally {
                androidSearchView.setQuery(query: text, submit: false)
                textWasSettedInternally = false
            }
        }
    }
    
    // MARK: Display Attributes
    
    /// A bar style that specifies the search bar’s appearance.
    public var barStyle: UIBarStyle = .`default`
    
    /// The tint color to apply to the search bar background.
    public var barTintColor: UIColor?
    
    /// A search bar style that specifies the search bar’s appearance.
    public var searchBarStyle: UISearchBar.Style = .`default`
    
    /// A Boolean value that indicates whether the search bar is translucent (true) or not (false).
    public var isTranslucent: Bool = true
    
    // MARK: Button Configuration
    
    /// A Boolean value indicating whether the bookmark button is displayed.
    public var showsBookmarkButton: Bool = false
    
    /// A Boolean value indicating whether the cancel button is displayed.
    public var showsCancelButton: Bool = true
    
    /// Sets the display state of the cancel button optionally with animation.
    public func setShowsCancelButton(_ show: Bool, animated: Bool) {
        
        
    }
    
    /// A Boolean value indicating whether the search results button is displayed.
    public var showsSearchResultsButton: Bool = false
    
    /// A Boolean value indicating whether the search results button is selected.
    public var isSearchResultsButtonSelected: Bool = false
}

/// A collection of optional methods that you implement to make a search bar control functional.
public protocol UISearchBarDelegate {
    
    /// Tells the delegate that the user changed the search text.
    func searchBar(_ searchBar: UISearchBar, textDidChange: String)
    
    /// Ask the delegate if text in a specified range should be replaced with given text.
    //func searchBar(_ searchBar UISearchBar, shouldChangeTextIn: NSRange, replacementText: String) -> Bool
    
    /// Asks the delegate if editing should begin in the specified search bar.
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    
    /// Tells the delegate when the user begins editing the search text.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    
    /// Asks the delegate if editing should stop in the specified search bar.
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    
    /// Tells the delegate that the user finished editing the search text.
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    
    /// Tells the delegate that the bookmark button was tapped.
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar)
    
    /// Tells the delegate that the cancel button was tapped.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    
    /// Tells the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    
    /// Tells the delegate that the search results list button was tapped.
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar)
    
    /// Tells the delegate that the scope button selection changed.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange: Int)
}

extension UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) { }
    
    //func searchBar(_ searchBar UISearchBar, shouldChangeTextIn: NSRange, replacementText: String) -> Bool {}
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool { return true }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { return false }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { }
    
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) { }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) { }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange: Int) { }
}

public enum Icon : Int {
    
    /// Identifies the search icon.
    case search = 0
    
    /// Identifies the clear action icon.
    case clear = 1
    
    /// Identifies the bookmarks icon.
    case bookmark = 2
    
    /// Identifies the results list icon.
    case resultsList = 3
}

extension UISearchBar {
    
    public enum Style : UInt {
        
        /// The search bar has the default style.
        case `default` = 0
        
        /// The search bar has a translucent background, and the search field is opaque.
        case prominent = 1
        
        /// The search bar has no background, and the search field is translucent.
        case minimal = 2
    }
    
    public enum UIBarStyle : Int {
        
        case `default` = 0
        
        case black = 1
        
        /// var blackOpaque: UIBarStyle {  }
        
        case blackTranslucent = 2
        
        
    }
}

internal class SearchViewQueryListener: AndroidSearchViewOnQueryTextListener {
    
    private var searchBar: UISearchBar?
    private var isFirstTyping = true
    lazy var workItem = WorkItem()
    
    init(_ searchBar: UISearchBar) {
        
        super.init(javaObject: nil)
        self.bindNewJavaObject()
        
        self.searchBar = searchBar
    }
    
    required public init(javaObject: jobject?) {
        super.init(javaObject: javaObject)
    }
    
    override func onQueryTextChange(newText: String?) -> Bool {
        
        guard let searchBar = self.searchBar
            else { return false }
        
        searchBar.textWasSettedInternally = true
        searchBar.text = newText ?? ""
        
        searchBar.delegate?.searchBar(searchBar, textDidChange: newText ?? "")
        
        if(isFirstTyping) {
            
            searchBar.delegate?.searchBarTextDidBeginEditing(searchBar)
            isFirstTyping = false
        }
        
        workItem.perform(after: 0.5) { [weak self] in
            
            guard let searchBar = self?.searchBar
                else { return }
            
            searchBar.delegate?.searchBarTextDidEndEditing(searchBar)
            self?.isFirstTyping = true
        }
        return false
    }
    
    override func onQueryTextSubmit(query: String?) -> Bool {
        
        guard let searchBar = self.searchBar
            else { return false }
        
        searchBar.textWasSettedInternally = true
        searchBar.text = query
        
        searchBar.delegate?.searchBarSearchButtonClicked(searchBar)
        return false
    }
}

public class WorkItem {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func perform(after: TimeInterval, _ block: @escaping () -> () ) {
        
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem(block: block)
        
        pendingRequestWorkItem = requestWorkItem
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + after, execute: requestWorkItem)
    }
}
