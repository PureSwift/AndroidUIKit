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
    
    open func dismiss(animated: Bool, completion: (() -> ())?){
        
        delegate?.willDismissSearchController(self)
        
        //FIXME: do something
        
        delegate?.didDismissSearchController(self)
    }
}

extension UISearchController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        
        searchResultsUpdater?.updateSearchResults(for: self)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isActive = false
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isActive = false
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isActive = true
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isActive = false
    }
}

/// A set of delegate methods for search controller objects.
public protocol UISearchControllerDelegate {
    
    /// Called when the search controller has been automatically dismissed.
    func didDismissSearchController(_ searchController: UISearchController)
    
    /// Called when the search controller has been automatically presented.
    func didPresentSearchController(_ searchController: UISearchController)
    
    /// Presents the designated search controller.
    func presentSearchController(_ searchController: UISearchController)
    
    /// Called when the search controller is to be automatically dismissed.
    func willDismissSearchController(_ searchController: UISearchController)
    
    /// Called when the search controller is to be automatically displayed.
    func willPresentSearchController(_ searchController: UISearchController)
}

/// A set of methods that let you update search results based on information the user enters into the search bar.
public protocol UISearchResultsUpdating {
    
    /// Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
    func updateSearchResults(for searchController: UISearchController)
}
