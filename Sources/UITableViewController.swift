//
//  UITableViewController.swift
//  AndroidUIKit
//
//  Created by Alsey Coleman Miller on 9/7/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import Foundation
import Android

open class UITableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public private(set) var style: UITableViewStyle = .plain
    
    public var clearsSelectionOnViewWillAppear: Bool = true
    
    public var refreshControl: UIRefreshControl? {
        
        willSet {
            
            guard newValue == nil
                else { return }
            
            guard let refreshControl = refreshControl
                else { return }
            
            refreshControl.endRefreshing()
            
            let recyclerViewIndex = refreshControl.androidSwipeRefreshLayout.indexOfChild(child: tableView.recyclerView)
            if(recyclerViewIndex >= 0){
                
                refreshControl.androidSwipeRefreshLayout.removeViewAt(index: recyclerViewIndex)
            }
            
            let swipeRefreshLayoutIndex = tableView.androidView.indexOfChild(child: refreshControl.androidSwipeRefreshLayout)
            if(swipeRefreshLayoutIndex >= 0){
                
                tableView.androidView.removeViewAt(index: swipeRefreshLayoutIndex)
            }
            
            tableView.androidView.addView(tableView.recyclerView)
        }
        
        didSet {
            
            guard let refreshControl = refreshControl
                else { return }
            
            refreshControl.frame = tableView.frame
            
            tableView.androidView.addView(refreshControl.androidSwipeRefreshLayout)
            
            let recyclerViewIndex = tableView.androidView.indexOfChild(child: tableView.recyclerView)
            
            if(recyclerViewIndex >= 0){
                tableView.androidView.removeViewAt(index: recyclerViewIndex)
            }
            
            refreshControl.androidSwipeRefreshLayout.addView(tableView.recyclerView)
        }
    }
    
    public var tableView: UITableView! {
        
        return self.view as? UITableView
    }
    
    open override func loadView() {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: style)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view = tableView
    }
    
    open override func viewDidLayoutSubviews() {
        
        refreshControl?.frame = view.bounds
    }
    
    public init(style: UITableViewStyle) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.style = style
    }
    
    public init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    open override var description: String {
        
        let className = NSStringFromClass(type(of: self))
        let pointer = Unmanaged<UITableViewController>.passUnretained(self).toOpaque().debugDescription
        let tableView = self.tableView.description
        
        return String("<\(className): \(pointer); tableView = \(tableView)>")
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        fatalError("\(#function) not implemented")
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) { }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) { }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) { }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) { }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return tableView.rowHeight }
    
    //open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return tableView.sectionHeaderHeight }
    
    //open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return tableView.sectionFooterHeight }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return tableView.estimatedRowHeight }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { return tableView.estimatedSectionHeaderHeight }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat { return tableView.estimatedSectionFooterHeight }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return nil }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?  { return nil }
    
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool  { return true }
    
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?  { return indexPath }
    
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? { return indexPath }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle { return .delete }
    
    open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? { return nil }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { return nil }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return true }
    
    open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) { }
    
    open func tableView(_ tableView: UITableView,
                        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                        toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        return proposedDestinationIndexPath
    }
}
