//
//  UISearchController.swift
//  AndroidBluetooth
//
//  Created by Marco Estrella on 1/7/19.
//

import Foundation

/* A view controller that manages the display of search results based on interactions with a search bar.
 */
public class UISearchController {
    
    /// The search controller’s delegate.
    public var delegate: UISearchControllerDelegate?
    
    /// Initializes and returns a search controller with the specified view controller for displaying the results.
    public init(searchResultsController: UIViewController?) {
        
        self.searchResultsController = searchResultsController
        
        searchBar = UISearchBar()
        searchBar.delegate = self
    }
    
    // MARK: Managing the Search Results
    
    /// The search bar to install in your interface.
    public var searchBar: UISearchBar!
    
    public var searchResultsUpdater: UISearchResultsUpdating?
    
    /// The view controller that displays the results of the search.
    public var searchResultsController: UIViewController?
    
    /// The presented state of the search interface.
    public var isActive: Bool = false
    
    // MARK: Configuring the Search Interface
    
    public var obscuresBackgroundDuringPresentation: Bool = true
    
    public var dimsBackgroundDuringPresentation: Bool = true
    
    public var hidesNavigationBarDuringPresentation: Bool = true
}

extension UISearchController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

public protocol UISearchControllerDelegate {
    
    
}

public protocol UISearchResultsUpdating {
    
    /// Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
    func updateSearchResults(for: UISearchController)
}
