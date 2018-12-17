//
//  UIDocumentPickerViewController.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 12/13/18.
//

import Foundation
import Android
import java_swift
import java_lang
import java_util

/// A view controller that provides access to documents or destinations outside your app’s sandbox.
public class UIDocumentPickerViewController {
    
    public weak var delegate: UIDocumentPickerDelegate?
    public var allowsMultipleSelection: Bool = false
    
    fileprivate var documentPickerMode: UIDocumentPickerMode
    fileprivate var documentTypes: [String]?
    fileprivate var urls = [URL]()
    
    /// Initializes and returns a document picker that can import or open the given file types.
    public init(documentTypes: [String], in documentPickerMode: UIDocumentPickerMode){
        
        self.documentTypes = documentTypes
        self.documentPickerMode = documentPickerMode
    }
    
    /// Initializes and returns a document picker that can export or move the given document.
    public init(url: URL, in documentPickerMode: UIDocumentPickerMode){
        
        self.urls.append(url)
        self.documentPickerMode = documentPickerMode
    }
    
    /// Initializes and returns a document picker that can export or move the given documents.
    public init(urls: [URL], in documentPickerMode: UIDocumentPickerMode){
        
        self.urls = urls
        self.documentPickerMode = documentPickerMode
    }
}

// Mark: - UIDocumentPickerDelegate

/// A set of methods that you implement to track when the user selects a document or destination, or to track when the operation is canceled.
public protocol UIDocumentPickerDelegate: class {
    
    /// Tells the delegate that the user has selected one or more documents.
    /// Parameters
    /// controller: The document picker that called this method.
    // urls: The URLs of the selected documents.
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL])
    
    /// Tells the delegate that the user canceled the document picker.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
}

public extension UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) { }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) { }
}

// Mark: - UIDocumentPickerMode

/// Modes that define the type of file transfer operation used by the document picker.
public enum UIDocumentPickerMode: UInt {
    
    /// The document picker imports a file from outside the app’s sandbox.
    case `import` = 0
    
    /// The document picker opens an external file located outside the app’s sandbox.
    case open = 1
    
    /// The document picker exports a local file to a destination outside the app’s sandbox.
    case exportToService = 2
    
    /// The document picker moves a local file outside the app’s sandbox and provides access to it as an external file.
    case moveToService = 3
}

public extension UIViewController {
    
    public func present(_ documentPickerVC: UIDocumentPickerViewController, animated: Bool, completion: (() -> ())? = nil){
        
        self.androidFileManager = AndroidFileManager(documentPickerVC)
        self.androidFileManager?.show()
    }
}

internal class AndroidFileManager {
    
    private var documentPickerVC: UIDocumentPickerViewController!
    private var context: SwiftSupportAppCompatActivity!
    private var dialog: AndroidDialog!
    private var adapter: ItemAdapter!
    private var view: AndroidView!
    private var tvCurrentFolder: Android.Widget.TextView!
    private var rvItems: Android.Widget.RecyclerView!
    private var ivAddFolder: Android.Widget.ImageView!
    private var ivBack: Android.Widget.ImageView!
    private var btnCancel: Android.Widget.Button!
    private var btnOk: Android.Widget.Button!
    
    private var selectedFile: Item?
    private var currentFolder = ""
    private var navigation = [Navigation]()
    
    public init(_ documentPickerVC: UIDocumentPickerViewController) {
        
        self.context = UIApplication.shared.androidActivity
        
        self.documentPickerVC = documentPickerVC
        
        let viewId = context.getIdentifier(name: "file_manager_layout", type: "layout")
        
        view = AndroidLayoutInflater.from(context: context).inflate(resource: Android.R.Layout(rawValue: viewId), root: nil)
        
        dialog = AndroidDialog(context: context)
        dialog.requestWindowFeature(featureId: AndroidWindow.FEATURE_NO_TITLE)
        dialog.setContentView(view: view)
        
        let rvItemsId = context.getIdentifier(name: "rvItems", type: "id")
        let tvFolderNameId = context.getIdentifier(name: "tvFolderName", type: "id")
        let ivBackId = context.getIdentifier(name: "ivBack", type: "id")
        let ivAddFolderId = context.getIdentifier(name: "ivAddFolder", type: "id")
        let btnCancelId = context.getIdentifier(name: "btnCancel", type: "id")
        let btnOkId = context.getIdentifier(name: "btnOk", type: "id")
        
        tvCurrentFolder = Android.Widget.TextView(casting: view.findViewById(tvFolderNameId)!)
        rvItems = Android.Widget.RecyclerView(casting: view.findViewById(rvItemsId)!)
        ivAddFolder = Android.Widget.ImageView(casting: view.findViewById(ivAddFolderId)!)
        ivBack = Android.Widget.ImageView(casting: view.findViewById(ivBackId)!)
        btnCancel = Android.Widget.Button(casting: view.findViewById(btnCancelId)!)
        btnOk = Android.Widget.Button(casting: view.findViewById(btnOkId)!)
        
        adapter = ItemAdapter(documentPickerVC)
        rvItems.adapter = adapter
        
        settingsAdapter()
        
        let storages = getStorages()
        navigation.append(Navigation(folderName: currentFolder, path: "/", files: storages))
        
        currentFolder = "Storages list"
        tvCurrentFolder?.text = currentFolder
        adapter.addItems(items: storages)
        
        settingsBackButton()
        settingsAddFolderButton()
        
        btnCancel?.setOnClickListener {
            
            self.dialog.dismiss()
        }
        
        btnOk?.setOnClickListener {
            
            var urls : [URL] = []
            
            if documentPickerVC.allowsMultipleSelection {
                
                guard self.adapter.checkedItems.count > 0 else {
                    
                    self.documentPickerVC.delegate?.documentPicker(documentPickerVC, didPickDocumentsAt: [])
                    
                    return
                }
                
                self.adapter.checkedItems.forEach {item in
                    
                    urls.append(URL(fileURLWithPath: item.path))
                }
            } else {
                
                let path: String
                
                if let selectedFile = self.selectedFile {
                    
                    path = selectedFile.path
                } else {
                    
                    guard let lastNavigation = self.navigation.last
                        else { return }
                    
                    path = lastNavigation.path
                }
                
                urls.append(URL(fileURLWithPath: path))
            }
            
            self.documentPickerVC.delegate?.documentPicker(documentPickerVC, didPickDocumentsAt: urls)
            
            self.dismiss()
        }
    }
    
    private func settingsAddFolderButton() {
        
        ivAddFolder?.setVisibility(visibility: AndroidView.AndroidViewVisibility.invisible.rawValue)
        
        ivAddFolder?.setOnClickListener {
            
            let density = self.context.density
            
            let dp3 = Int(3 * density)
            let dp24 = Int(24 * density)
            
            let llParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.MATCH_PARENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
            
            let linearLayout = AndroidLinearLayout.init(context: self.context)
            linearLayout.layoutParams = llParams
            linearLayout.setPadding(left: dp24, top: dp3, right: dp24, bottom: dp3)
            linearLayout.orientation = AndroidLinearLayout.VERTICAL
            
            let editTextLayoutParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.MATCH_PARENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
            editTextLayoutParams.setMargins(left: 0, top: 0, right: 0, bottom: 0)
            
            let editText = AndroidEditText(context: self.context)
            editText.layoutParams = editTextLayoutParams
            editText.hint = "Enter name"
            
            linearLayout.addView(editText)
            
            let alertDialog = AndroidAlertDialog.Builder(context: self.context)
                .setTitle(title: "New Folder")
                .setView(view: linearLayout)
                .setNegativeButton(text: "Cancel", {dialog,_ in
                    
                    dialog?.dismiss()
                })
                .setPositiveButton(text: "Ok", { dialog,_ in
                    
                    guard let newFolderName = editText.getText()?.toString(), !newFolderName.isEmpty  else {
                        AndroidToast.makeText(context: self.context, text: "Folder Name is required", duration: AndroidToast.Dutation.short).show()
                        return
                    }
                    
                    guard let currentNavigation = self.navigation.last else {
                        AndroidToast.makeText(context: self.context, text: "Couldn't create the folder", duration: AndroidToast.Dutation.short).show()
                        return
                    }
                    
                    let currentFile = JavaFile(pathname: currentNavigation.path)
                    
                    if currentFile.isDirectory() {
                        
                        if JavaFile(pathname: "\(currentNavigation.path)/\(newFolderName)").mkdir() {
                            
                            let itemChildren = self.getItemsFromPath(path: currentNavigation.path)
                            
                            currentNavigation.files = itemChildren
                            
                            self.adapter.addItems(items: itemChildren)
                        } else {
                            
                            AndroidToast.makeText(context: self.context, text: "Couldn't create the folder", duration: AndroidToast.Dutation.short).show()
                        }
                    }
                    
                    dialog?.dismiss()
                })
                .create()
            
            alertDialog.show()
        }
    }
    
    private func settingsBackButton() {
        
        ivBack?.setVisibility(visibility: AndroidView.AndroidViewVisibility.invisible.rawValue)
        
        ivBack?.setOnClickListener {
            
            guard self.navigation.count > 1
                else {  return }
            
            self.navigation.removeLast()
            
            let navLastFolder = self.navigation.last
            
            guard let lastFolder = navLastFolder
                else { return }
            
            if self.navigation.count == 1 {
                
                self.ivBack?.setVisibility(visibility: AndroidView.AndroidViewVisibility.invisible.rawValue)
                self.ivAddFolder?.setVisibility(visibility: AndroidView.AndroidViewVisibility.invisible.rawValue)
                self.currentFolder = "Storages list"
                
                self.btnOk?.setEnabled(enabled: false)
                self.btnOk?.text = "SELECT FOLDER"
            } else {
                self.currentFolder = lastFolder.folderName
            }
            
            self.tvCurrentFolder?.text = self.currentFolder
            self.adapter.addItems(items: lastFolder.files)
        }
    }
    
    private func settingsAdapter(){
        
        adapter.multiSelectCheckItems = { isThereItems in
            
            if(isThereItems){
                
                self.btnOk?.text = "SELECT FILES"
            } else {
                
                self.btnOk?.text = "SELECT FOLDER"
            }
        }
        
        adapter.singleSelectCheckItem = { isChecked, item in
            
            NSLog("Checkbox checked \(isChecked): \(item.name).")
            
            if isChecked {
                
                self.selectedFile = item
                self.btnOk?.text = "SELECT FILE"
            } else {
                
                self.selectedFile = nil
                self.btnOk?.text = "SELECT FOLDER"
            }
        }
        
        adapter.itemClick = { item in
            
            NSLog("path: \(item.path)")
            self.btnOk?.text = "SELECT FOLDER"
            self.btnOk?.setEnabled(enabled: true)
            
            let itemChildren = self.getItemsFromPath(path: item.path)
            
            self.currentFolder = "/\(item.name)/"
            self.navigation.append(Navigation(folderName: self.currentFolder, path: item.path, files: itemChildren))
            
            self.tvCurrentFolder?.text = self.currentFolder
            self.adapter.addItems(items: itemChildren)
            
            self.ivBack?.setVisibility(visibility: AndroidView.AndroidViewVisibility.visible.rawValue)
            
            if self.documentPickerVC.documentPickerMode == .exportToService || self.documentPickerVC.documentPickerMode == .moveToService {
                
                self.ivAddFolder?.setVisibility(visibility: AndroidView.AndroidViewVisibility.visible.rawValue)
            }
        }
    }
    
    public func dismiss() {
        
        dialog.dismiss()
    }
    
    public func show() {
        
        dialog.show()
        
        let layoutParams = AndroidWindowManagerLayoutParams()
        
        guard let dialogLayuotparams = dialog.window.attributes
            else { return }
        
        layoutParams.copyFrom(dialogLayuotparams)
        
        layoutParams.width = AndroidWindowManagerLayoutParams.MATCH_PARENT
        layoutParams.height = AndroidWindowManagerLayoutParams.MATCH_PARENT
        
        dialog.window.attributes = layoutParams
    }
    
    private func getStorages() -> [Item] {
        
        var storages = [Item]()
        
        if(AndroidEnvironment.getExternalStorageDirectory() != nil){
            
            guard let internalStorage = AndroidEnvironment.getExternalStorageDirectory()
                else { return [] }
            
            let path = internalStorage.getPath()
            
            storages.append(Item(type: ItemType.storage, path: path, name: "Internal storage"))
        }
        
        guard var extStorages = context.getExternalFilesDirs(type: nil) else {
            NSLog("Not Ext Storages")
            return storages
        }
        
        extStorages.remove(at: 0)
        
        let secondaryStoragePath = System.getenv("SECONDARY_STORAGE") ?? ""
        
        extStorages.forEach { storage in
            
            let path = storage.getPath().components(separatedBy: "Android/")[0]
            
            if( AndroidEnvironment.isExternalStorageRemovable(path: storage) || secondaryStoragePath.contains(path)){
                
                storages.append(Item(type: ItemType.storage, path: path, name: "SD Card"))
                NSLog("SD Card: \(path)")
            }
        }
        
        return storages
    }
    
    private func getItemsFromPath(path: String) -> [Item] {
        
        let selectedFile = JavaFile(pathname: path)
        
        let children = selectedFile.listFiles()
        
        guard let files = children else {
            
            AndroidToast.makeText(context: context, text: "It does'nt content any file.", duration: AndroidToast.Dutation.short).show()
            return []
        }
        
        var itemChildren: [Item] = [Item]()
        
        files.forEach { file in
            
            let type = file.isDirectory() ? ItemType.folder : ItemType.file
            itemChildren.append(Item(type: type, path: file.getPath(), name: file.getName()))
        }
        
        itemChildren.sort { (lhs, rhs) in
            
            return rhs.type != ItemType.folder
        }
        
        return itemChildren
    }
}

fileprivate enum ItemType: Int {
    case storage
    case folder
    case file
}

fileprivate class Navigation {
    
    public let folderName: String
    public let path: String
    public var files: [Item]
    
    init(folderName: String, path: String, files: [Item]) {
        
        self.folderName = folderName
        self.path = path
        self.files = files
    }
}

fileprivate class Item {
    
    public let type: ItemType
    public var path: String
    public let name: String
    public var selected: Bool
    
    init(type: ItemType, path: String, name: String) {
        self.type = type
        self.path = path
        self.name = name
        self.selected = false
    }
}

fileprivate class ItemAdapter: Android.Widget.RecyclerView.Adapter {
    
    private var items = [Item]()
    public var itemClick: ((Item) -> ())?
    public var singleSelectCheckItem: ((Bool, Item) -> ())?
    public var multiSelectCheckItems: ((Bool) -> ())?
    public var checkedItems : [Item] = []
    
    private var lastCheckedPosition = -1
    
    private var documentPickerVC: UIDocumentPickerViewController!
    
    public required init(javaObject: jobject?) {
        super.init(javaObject: javaObject)
    }
    
    convenience init(_ documentPickerVC: UIDocumentPickerViewController) {
        
        NSLog("\(type(of: self)) \(#function)")
        
        self.init(javaObject: nil)
        bindNewJavaObject()
        
        self.documentPickerVC = documentPickerVC
    }
    
    public func addItems(items: [Item]){
        
        self.checkedItems.removeAll()
        self.items.removeAll()
        
        self.items = items
        
        notifyDataSetChanged()
    }
    
    override func getItemCount() -> Int {
        return items.count
    }
    
    override func onCreateViewHolder(parent: Android.View.ViewGroup, viewType: Int?) -> AndroidWidgetRecyclerView.ViewHolder {
        
        NSLog("\(type(of: self)) \(#function)")
        
        let cbSelectId = AndroidViewCompat.generateViewId()
        let ivItemTypeId = AndroidViewCompat.generateViewId()
        let tvItemNameId = AndroidViewCompat.generateViewId()
        
        let density = UIApplication.shared.androidActivity.density
        
        let dp4 = Int(4 * density)
        let dp6 = Int(6 * density)
        
        let llParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.MATCH_PARENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
        
        let linearLayout = AndroidLinearLayout(context: UIApplication.shared.androidActivity)
        linearLayout.layoutParams = llParams
        linearLayout.setPadding(left: dp4, top: dp4, right: dp4, bottom: dp4)
        linearLayout.orientation = AndroidLinearLayout.HORIZONTAL
        
        let cbSelect = AndroidCheckBox(context: UIApplication.shared.androidActivity)
        cbSelect.setId(cbSelectId)
        cbSelect.layoutParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.WRAP_CONTENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
        
        let ivItemType = AndroidImageView(context: UIApplication.shared.androidActivity)
        ivItemType.setId(ivItemTypeId)
        let ivItemTypeParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.WRAP_CONTENT, height: AndroidLinearLayoutLayoutParams.MATCH_PARENT)
        ivItemTypeParams.marginStart = dp4
        ivItemType.layoutParams = ivItemTypeParams
        
        let tvItemName = AndroidTextView(context: UIApplication.shared.androidActivity)
        tvItemName.setId(tvItemNameId)
        let tvItemNameParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.MATCH_PARENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
        tvItemNameParams.marginStart = dp6
        tvItemName.layoutParams = tvItemNameParams
        tvItemName.setTextSize(size: 16)
        tvItemName.setMaxLines(maxLines: 1)
        tvItemName.setHorizontallyScrolling(true)
        tvItemName.setEllipsize(where: AndroidTextUtilsTruncateAt.END)
        
        linearLayout.addView(cbSelect)
        linearLayout.addView(ivItemType)
        linearLayout.addView(tvItemName)
        
        return ItemViewHolder(itemView: linearLayout, documentPickerVC: documentPickerVC, ids: [cbSelectId, ivItemTypeId, tvItemNameId])
    }
    
    override func onBindViewHolder(holder: AndroidWidgetRecyclerView.ViewHolder, position: Int) {
        
        let itemViewHolder = holder as! ItemViewHolder
        
        let item = items[position]
        itemViewHolder.bind(item)
        
        itemViewHolder.cbSelect?.setOnCheckedChangeListener { buttonView, isChecked in
            
            item.selected = isChecked
            
            if self.documentPickerVC.allowsMultipleSelection {
                
                self.notifyItemChanged(position: self.lastCheckedPosition)
                
                if isChecked {
                    
                    self.checkedItems.append(item)
                } else {
                    
                    if let index = self.checkedItems.index(where: { $0.path == item.path}) {
                        
                        self.checkedItems.remove(at: index)
                    }
                }
                
                self.multiSelectCheckItems?(self.checkedItems.count > 0)
                
                return
            }
            
            self.singleSelectCheckItem?(isChecked, item)
            
            if self.lastCheckedPosition != -1 && self.lastCheckedPosition != position {
                
                self.items[self.lastCheckedPosition].selected = false
                self.notifyItemChanged(position: self.lastCheckedPosition)
            }
            
            self.lastCheckedPosition = position
        }
        
        if item.type == ItemType.file {
            
            itemViewHolder.tvItemName?.setOnClickListener(nil)
            return
        }
        
        itemViewHolder.tvItemName?.setOnClickListener {
            self.itemClick?(item)
        }
    }
    
    class ItemViewHolder: Android.Widget.RecyclerView.ViewHolder {
        
        fileprivate var itemView: Android.View.View?
        fileprivate var tvItemName: Android.Widget.TextView?
        fileprivate var cbSelect: Android.Widget.CheckBox?
        fileprivate var ivItemType: Android.Widget.ImageView?
        fileprivate var documentPickerVC: UIDocumentPickerViewController!
        
        convenience init(itemView: Android.View.View, documentPickerVC: UIDocumentPickerViewController!, ids: [Int]) {
            NSLog("\(type(of: self)) \(#function)")
            
            self.init(javaObject: nil)
            
            self.documentPickerVC = documentPickerVC
            
            bindNewJavaObject(itemView: itemView)
            
            guard let cbSelectObject = itemView.findViewById(ids[0])
                else { fatalError("No view for cbSelect: \(ids[0])") }
            
            guard let ivItemTypeObject = itemView.findViewById(ids[1])
                else { fatalError("No view for ivItemType: \(ids[1])") }
            
            guard let tvItemNameObject = itemView.findViewById(ids[2])
                else { fatalError("No view for tvItemName: \(ids[2])") }
            
            self.itemView = itemView
            
            self.cbSelect = Android.Widget.CheckBox(casting: cbSelectObject)
            self.ivItemType = Android.Widget.ImageView(casting: ivItemTypeObject)
            self.tvItemName = Android.Widget.TextView(casting: tvItemNameObject)
        }
        
        public required init(javaObject: jobject?) {
            super.init(javaObject: javaObject)
        }
        
        deinit {
            NSLog("\(type(of: self)) \(#function)")
        }
        
        public func bind(_ item: Item) {
            
            self.tvItemName?.text = item.name
            
            var imageId = 0
            
            switch item.type {
            case .storage:
                
                self.cbSelect?.setVisibility(visibility: AndroidView.AndroidViewVisibility.gone.rawValue)
                imageId = UIApplication.shared.androidActivity.getIdentifier(name: "ic_sd_storage", type: "drawable")
            case .folder:
                
                self.cbSelect?.setVisibility(visibility: AndroidView.AndroidViewVisibility.gone.rawValue)
                imageId = UIApplication.shared.androidActivity.getIdentifier(name: "ic_folder", type: "drawable")
            case .file:
                
                imageId = UIApplication.shared.androidActivity.getIdentifier(name: "ic_file", type: "drawable")
            }
            
            if imageId != 0 {
                
                self.ivItemType?.setImageResource(imageId)
            }
            
            if item.type == .file {
                
                guard let extensions = documentPickerVC.documentTypes else {
                    
                    self.cbSelect?.setVisibility(visibility: AndroidView.AndroidViewVisibility.visible.rawValue)
                    self.cbSelect?.setChecked(item.selected)
                    
                    return
                }
                
                guard extensions.count > 0 else {
                    
                    self.cbSelect?.setVisibility(visibility: AndroidView.AndroidViewVisibility.visible.rawValue)
                    self.cbSelect?.setChecked(item.selected)
                    
                    return
                }
                
                let fileExtension = item.path.split(separator: ".")[1].lowercased()
                
                let itemIsAllowsToBeSelected = extensions.contains { element in element.lowercased() == fileExtension }
                
                if itemIsAllowsToBeSelected {
                    
                    self.cbSelect?.setVisibility(visibility: AndroidView.AndroidViewVisibility.visible.rawValue)
                    self.cbSelect?.setChecked(item.selected)
                    
                } else {
                    
                    self.cbSelect?.setVisibility(visibility: AndroidView.AndroidViewVisibility.gone.rawValue)
                }
            }
        }
    }
    
    deinit {
        NSLog("\(type(of: self)) \(#function)")
    }
}
