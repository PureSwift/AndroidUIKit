//
//  UITableView.swift
//  Android
//
//  Created by Marco Estrella on 7/23/18.
//

import Foundation
import Android
import java_swift

final public class UITableView: UIView {
    
    // MARK: - Properties
    
    /// The object that acts as the data source of the table view.
    public weak var dataSource: UITableViewDataSource? {
        didSet { loadAdapter() }
    }
    
    /// The object that acts as the delegate of the table view.
    public weak var delegate: UITableViewDelegate?
    
    public private(set) var style: UITableViewStyle = .plain
    
    /// The height of each row (that is, table cell) in the table view.
    public var rowHeight: CGFloat = UITableView.defaultRowHeight
    
    /// The estimated height of rows in the table view.
    public var estimatedRowHeight: CGFloat = 0.0
    
    /// The estimated height of section headers in the table view.
    public var estimatedSectionHeaderHeight: CGFloat = 0.0
    
    /// The estimated height of section footers in the table view.
    public var estimatedSectionFooterHeight: CGFloat = 0.0
    
    /// The style for table cells used as separators.
    public var separatorStyle: UITableViewCellSeparatorStyle = .singleLine
    
    /// The color of separator rows in the table view.
    //public var separatorColor: UIColor? = UITableView.defaultSeparatorColor
    
    /// Specifies the default inset of cell separators.
    //public var separatorInset: UIEdgeInsets = UITableView.defaultSeparatorInset
    
    /// The number of sections in the table view.
    public var numberOfSections: Int {
        
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    /// The table cells that are visible in the table view.
    ///
    /// The value of this property is an array containing `UITableViewCell` objects,
    /// each representing a visible cell in the table view.
    public var visibleCells: [UITableViewCell] {
        
        guard let cells = adapter?.visibleCells.values
            else { return [] }
        
        return Array(cells)
    }
    
    /// An array of index paths each identifying a visible row in the table view.
    public var indexPathsForVisibleRows: [IndexPath]? {
        
        guard let indexPaths = adapter?.visibleCells.keys
            else { return nil }
        
        return Array(indexPaths)
    }
    
    // MARK: - Private Properties
    
    internal static let defaultRowHeight: CGFloat = 44
    
    internal private(set) var registeredCells = [String: UITableViewCell.Type]()
    
    // can be reloaded
    fileprivate var adapter: UITableViewRecyclerViewAdapter?
    
    // only assigned once
    public var recyclerView: AndroidWidgetRecyclerView!
    
    internal var recyclerViewDivider: AndroidDividerItemDecoration!
    
    // MARK: - Initialization
    
    private var reduceHeigthRecyclerViewCounter = 0
    
    /// Initializes and returns a table view object having the given frame and style.
    public required init(frame: CGRect, style: UITableViewStyle = .plain) {
        
        super.init(frame: frame)
        
        // UITableView properties
        self.style = style
        
        // setup Android view
        guard let context = AndroidContext(casting: UIScreen.main.activity)
            else { fatalError("Missing context") }
        
        recyclerView = AndroidWidgetRecyclerView(context: context)
        
        guard let recyclerView = recyclerView
            else { fatalError("Missing Android RecyclerView") }
        
        recyclerViewDivider = AndroidDividerItemDecoration(context: context, orientation: AndroidDividerItemDecoration.VERTICAL)
        
        recyclerView.layoutManager = AndroidWidgetRecyclerViewLinearLayoutManager(context: context)
        recyclerView.addItemDecoration(recyclerViewDivider)
        updateRecyclerViewFrame()
        
        androidView.addView(recyclerView)
        
        UIApplication.shared.androidActivity.reduceHeigthRecyclerView = {
            
            if( self.reduceHeigthRecyclerViewCounter == 0 ){
                self.reduceHeigthRecyclerViewCounter += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9){
                    
                    UIApplication.shared.androidActivity.runOnMainThread {
                        
                        self.reduceRecyclerViewSize()
                    }
                }
            } else {
                
                self.reduceRecyclerViewSize()
            }
        }
        
        UIApplication.shared.androidActivity.enlargeRecyclerView = {
            
            if self.recyclerView.isShown() {
                
                if self.recyclerViewHeight > 0 && self.recyclerViewWidth > 0 {
                    
                    NSLog("rv:: enlargeRecyclerView h: \(self.recyclerViewHeight) - w: \(self.recyclerViewWidth)")
                    self.recyclerView?.layoutParams = AndroidFrameLayoutLayoutParams(width: self.recyclerViewWidth, height: self.recyclerViewHeight)
                    
                    self.adapter?.selectedEditText?.clearFocus()
                }
            }
        }
        
        UIApplication.shared.androidActivity.keyBoardHeightGotten = { keyBoardHeight in
            
            NSLog("rv:: kb h: \(keyBoardHeight)")
            self.keyBoardHeight = keyBoardHeight
        }
        
        let adapter = UITableViewRecyclerViewAdapter(tableView: self)
        
        self.adapter = adapter
        self.recyclerView?.adapter = adapter
        
        self.backgroundColor = .white
    }
    
    
    
    private func reduceRecyclerViewSize(){
        
        let newHeight = recyclerViewHeight - keyBoardHeight
        NSLog("rv:: reduceRecyclerViewSize kh= \(keyBoardHeight), rv= \(recyclerViewHeight) and nh: \(newHeight)")
        recyclerView.layoutParams = AndroidFrameLayoutLayoutParams(width: recyclerViewWidth, height: newHeight)
    }
    
    // MARK: - Methods
    
    override func updateAndroidViewSize() {
        super.updateAndroidViewSize()
        
        updateRecyclerViewFrame()
    }
    
    fileprivate var counter = 0
    fileprivate var recyclerViewHeight = 0
    fileprivate var recyclerViewWidth = 0
    fileprivate var keyBoardHeight = 0
    
    private func updateRecyclerViewFrame() {
        
        guard let recyclerView = self.recyclerView
            else { return }
        
        let frameDp = bounds.applyingDP()
        let frDp = frame.applyingDP()
        
        NSLog("rv:: updateRecyclerViewFrame bounds h: \(frameDp.height) - w: \(frameDp.width)")
        NSLog("rv:: updateRecyclerViewFrame  frame h: \(frDp.height) - w: \(frDp.width)")
        
        // set origin
        recyclerView.setX(x: Float(frameDp.minX))
        recyclerView.setY(y: Float(frameDp.minY))
        
        // set size
        recyclerView.layoutParams = Android.Widget.FrameLayout.FLayoutParams(width: Int(frameDp.width), height: Int(frameDp.height))
        
        let rvw = recyclerView.layoutParams!.width
        let rvh = recyclerView.layoutParams!.height
        
        if rvw > recyclerViewWidth && rvh > recyclerViewHeight {
            
            recyclerViewHeight = rvh
            recyclerViewWidth = rvw
            NSLog("rv:: updateRecyclerViewFrame h: \(recyclerViewHeight) - w: \(recyclerViewWidth)")
            counter += 1
        }
    }
    
    public func reloadData() {
        
        self.loadAdapter()
    }
    
    /// Registers a class for use in creating new table cells.
    public func register(_ cellClass: UITableViewCell.Type?,
                         forCellReuseIdentifier identifier: String) {
        
        assert(identifier.isEmpty == false, "Identifier must not be an empty string")
        
        registeredCells[identifier] = cellClass
    }
    
    public func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        
        // get cell from reusable cell pool
        guard let (_, reusableCell) = adapter?.reusableCell,
            reusableCell.reuseIdentifier == identifier
            else { return nil }
        
        return reusableCell
    }
    
    public func dequeueReusableCell(withIdentifier identifier: String,
                                    for indexPath: IndexPath) -> UITableViewCell {
        
        guard let adapter = self.adapter
            else { fatalError("No adapter configured") }
        
        guard let cellType = registeredCells[identifier]
            else { fatalError("Unregistered cell identifier: \(identifier)") }
        
        // get cell from reusable cell pool
        if let (indexPath, reusableCell) = adapter.reusableCell,
            reusableCell.reuseIdentifier == identifier,
            indexPath == indexPath {
            
            assert(type(of: reusableCell) == cellType)
            
            // return cell for reuse
            return reusableCell
            
        } else {
            
            let cell = cellType.init(reuseIdentifier: identifier)
            return cell
        }
    }
    
    /// Returns the table cell at the specified index path.
    ///
    /// - Parameter indexPath: The index path locating the row in the table view.
    ///
    /// - Returns: An object representing a cell of the table,
    /// or `nil` if the cell is not visible or `indexPath` is out of range.
    public func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return adapter?.visibleCells[indexPath]
    }
    
    /// Returns an index path representing the row and section of a given table-view cell.
    ///
    /// - Returns: An index path representing the row and section of the cell, or nil if the index path is invalid.
    public func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return adapter?.visibleCells.first(where: { $0.value === cell })?.key
    }
    
    // MARK: - Private Methods
    
    private func loadAdapter() {
        
        self.adapter?.notifyDataSetChanged()
    }
    
    public func removeAndroidRecyclerViewDivider() {
        
        recyclerView.removeItemDecoration(recyclerViewDivider)
    }
}

// MARK: - Supporting Types

public protocol UITableViewDataSource: class {
    
    // MARK: Configuring a Table View
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String?
    
    func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String?
}

public extension UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? { return nil }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String? { return nil }
}

// MARK: - Android

internal class UITableViewRecyclerViewAdapter: AndroidWidgetRecyclerViewAdapter {
    
    internal let headerIndex = -1
    
    internal private(set) weak var tableView: UITableView?
    
    /// Cells ready for reuse
    internal private(set) var reusableCell: (indexPath: IndexPath, cell: UITableViewCell)?
    
    internal private(set) var visibleCells = [IndexPath: UITableViewCell]()
    
    internal private(set) var indexPaths = [Int: IndexPath]()
    
    internal var selectedEditText: AndroidEditText?
    
    convenience init(tableView: UITableView) {
        self.init(javaObject: nil)
        bindNewJavaObject()
        
        self.tableView = tableView
    }
    
    required init(javaObject: jobject?) {
        super.init(javaObject: javaObject)
    }
    
    override func onCreateViewHolder(parent: Android.View.ViewGroup, viewType: Int?) -> AndroidWidgetRecyclerView.ViewHolder {
        
        return UITableView.ViewHolder()
    }
    
    override func onBindViewHolder(holder: AndroidWidgetRecyclerView.ViewHolder, position: Int) {
        
        guard let viewHolder = holder as? UITableView.ViewHolder
            else { fatalError("Invalid view holder \(holder)") }
        
        // configure cell
        guard let tableView = self.tableView
            else { assertionFailure("Missing table view"); return }
        
        guard let dataSource = tableView.dataSource
            else { assertionFailure("Missing data source"); return }
        
        guard let delegate = tableView.delegate
            else { assertionFailure("Missing delegate"); return }
        
        guard let indexPath = indexPaths[position]
            else { assertionFailure("Missing IndexPath in the postion: \(position)"); return }
        
        // add cell to reusable queue
        if let reusableCell = viewHolder.cell {
            self.reusableCell = (indexPath, reusableCell)
        }
        
        defer { self.reusableCell = nil }
        
        if indexPath.row == headerIndex {
            
            if let headerView = delegate.tableView(tableView, viewForHeaderInSection: indexPath.section)?.androidView {
                
                viewHolder.addChildView(headerView)
                
            } else {
                
                let title = dataSource.tableView(tableView, titleForHeaderInSection: indexPath.section)
                
                let sections = dataSource.numberOfSections(in: tableView)
                
                if sections > 1 {
                    
                    viewHolder.addChildView(generateDefaultHeader(title: title))
                } else {
                    
                    if title != nil {
                        
                        viewHolder.addChildView(generateDefaultHeader(title: title))
                    } else {
                        
                        viewHolder.contentView.androidView.removeAllViews()
                        viewHolder.contentView.androidView.layoutParams = Android.Widget.FrameLayout.FLayoutParams(width: Android.Widget.FrameLayout.FLayoutParams.MATCH_PARENT, height: 0)
                    }
                }
            }
            
        } else {
            
            viewHolder.contentView.androidView.setOnClickListener { [weak viewHolder] in
                
                guard let viewHolder = viewHolder
                    else { assertionFailure("View Holder released"); return }
                
                guard let tableView = self.tableView
                    else { assertionFailure("Missing table view"); return }
                
                guard let delegate = tableView.delegate
                    else { assertionFailure("Missing delegate"); return }
                
                guard let indexPath = self.indexPaths[viewHolder.adapterPosition]
                    else { assertionFailure("Missing indexpath"); return  }
                
                delegate.tableView(tableView, didSelectRowAt: indexPath)
            }
            // data source should use `dequeueCell` to get an existing cell
            let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
            
            //if cell !== viewHolder.cell {
            
            viewHolder.cell = cell
            findEdittexts(cell.androidView)
            viewHolder.addChildView(cell.androidView)
            //}
            
            // mark as visible
            self.visibleCells = self.visibleCells.filter({ $0.value !== cell })
            self.visibleCells[indexPath] = cell
        }
    }
    
    let viewGroupTypes = ["FrameLayout", "LinearLayout", "RelativeLayout", "ViewGroup"]
    let edittextTypes = ["EditText", "AppCompatEditText"]
    
    private func findEdittexts(_ itemView: AndroidView) {
        
        let itemViewName = itemView.getClass().getSimpleName()!
        
        if viewGroupTypes.contains(itemViewName) {
            
            guard let viewGroup = AndroidViewGroup(casting: itemView)
                else { return }
            
            let childrenCount = viewGroup.getChildCount()
            
            for index in 0..<childrenCount {
                
                let view = viewGroup.getChildAt(index: index)
                findEdittexts(view)
            }
            
        } else {
            
            if edittextTypes.contains(itemViewName) {
                
                if let editText = AndroidEditText(casting: itemView) {
                    
                    setListenerToEdittext(editText)
                }
            }
        }
    }
    
    private func setListenerToEdittext(_ editText: AndroidEditText){
        
        editText.setShowSoftInputOnFocus(false)
        editText.setOnFocusChangeListener{ view, hasFocus in
            
            guard let view = view
                else { return }
            
            if hasFocus {
                
                self.selectedEditText = editText
                UIApplication.shared.androidActivity.reduceHeigthRecyclerView?()
                UIApplication.shared.androidActivity.showKeyboard(view)
            }
        }
    }
    
    override func getItemCount() -> Int {
        
        guard let tableView = tableView else {
            return 0
        }
        
        guard let dataSource = tableView.dataSource else {
            return 0
        }
        
        var count = 0
        
        let sections = dataSource.numberOfSections(in: tableView)
        
        for section in 0 ..< sections {
            
            indexPaths[count] = IndexPath(row: headerIndex, in: section)
            count = count + 1
            
            for row in 0 ..< dataSource.tableView(tableView, numberOfRowsInSection: section) {
                
                indexPaths[count] = IndexPath(row: row, in: section)
                count = count + 1
            }
        }
        
        return count
    }
    
    private func generateDefaultHeader(title: String?) -> AndroidView {
        
        let layoutName = title != nil ? "cell_header" : "cell_header_space"
        
        let peripheralViewLayoutId = UIApplication.shared.androidActivity.getIdentifier(name: layoutName, type: "layout")
        
        let layoutInflarer = Android.View.LayoutInflater.from(context: UIApplication.shared.androidActivity)
        
        let itemView = layoutInflarer.inflate(resource: Android.R.Layout(rawValue: peripheralViewLayoutId), root: nil, attachToRoot: false)
        
        if let title = title {
            
            let tvHeaderId = UIApplication.shared.androidActivity.getIdentifier(name: "text_label", type: "id")
            
            guard let tvHeaderObject = itemView.findViewById(tvHeaderId)
                else { fatalError("No view for \(tvHeaderId)") }
            
            let tvHeader = Android.Widget.TextView(casting: tvHeaderObject)
            
            tvHeader?.text = title
        }
        
        itemView.layoutParams = Android.Widget.FrameLayout.FLayoutParams(width: Android.Widget.FrameLayout.FLayoutParams.MATCH_PARENT, height: Android.Widget.FrameLayout.FLayoutParams.WRAP_CONTENT)
        
        return itemView
    }
}

internal extension UITableView {
    
    internal class ViewHolder: Android.Widget.RecyclerView.ViewHolder {
        
        public lazy var contentView: UIView = UIView(frame: CGRect(origin: .zero, size: UITableViewCell.defaultSize))
        
        /// Reference to cell (used for configuration)
        var cell: UITableViewCell?
        
        public init() {
            
            super.init(javaObject: nil)
            self.bindNewJavaObject(itemView: self.contentView.androidView)
        }
        
        required init(javaObject: jobject?) {
            super.init(javaObject: javaObject)
        }
        
        /// Add Android child view.
        public func addChildView(_ view: AndroidView) {
            NSLog("ClimateConfig: \(type(of: self)) - \(#function)")
            contentView.androidView.removeAllViews()
            contentView.androidView.layoutParams = view.layoutParams
            contentView.androidView.addView(view)
            
            
        }
    }
}



// MARK: - Supporting Types

/// The style of the table view.
public enum UITableViewStyle: Int {
    
    case plain
    case grouped
}

/// The position in the table view (top, middle, bottom) to which a given row is scrolled.
public enum UITableViewScrollPosition: Int {
    
    case none
    case top
    case middle
    case bottom
}

/// The type of animation when rows are inserted or deleted.
public enum UITableViewRowAnimation: Int {
    
    case fade
    case right
    case left
    case top
    case bottom
    case none
    case middle
    
    case automatic = 100
}

/// Requests icon to be shown in the section index of a table view.
///
/// If the data source includes this constant string in the array of strings it returns
/// in `sectionIndexTitles(for:)`, the section index displays a magnifying glass icon at
/// the corresponding index location. This location should generally be the first title in the index.
// http://stackoverflow.com/questions/235120/whats-the-uitableview-index-magnifying-glass-character
public let UITableViewIndexSearch: String = "{search}"

/// The default value for a given dimension.
///
/// Requests that UITableView use the default value for a given dimension.
public let UITableViewAutomaticDimension: CGFloat = -1.0

open class UITableViewRowAction {
    
}

public protocol UITableViewDelegate: class /* UIScrollViewDelegate */ {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    //func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    
    //func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
}

public extension UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) { }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) { }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) { }
    
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) { }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return tableView.rowHeight }
    
    //func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return tableView.sectionHeaderHeight }
    
    //func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return tableView.sectionFooterHeight }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return tableView.estimatedRowHeight }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { return tableView.estimatedSectionHeaderHeight }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat { return tableView.estimatedSectionFooterHeight }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return nil }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?  { return nil }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool  { return true }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?  { return indexPath }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? { return indexPath }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle { return .delete }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? { return nil }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { return nil }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return true }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) { }
    
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        return proposedDestinationIndexPath
    }
}
