//
//  UIDocumentPickerViewController.swift
//  AndroidUIKit
//
//  Created by Marco Estrella on 12/13/18.
//

import Foundation
import Android

/// A view controller that provides access to documents or destinations outside your app’s sandbox.
public class UIDocumentPickerViewController {
    
    public var delegate: UIDocumentPickerDelegate?
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
public protocol UIDocumentPickerDelegate {}

public extension UIDocumentPickerDelegate {
    
    /// Tells the delegate that the user has selected one or more documents.
    /// Parameters
    /// controller: The document picker that called this method.
    // urls: The URLs of the selected documents.
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) {}
    
    /// Tells the delegate that the user canceled the document picker.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){}
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
        
        var mode: AndroidFileManager.Mode
        
        if documentPickerVC.documentPickerMode == .import || documentPickerVC.documentPickerMode == .open {
            
            mode = AndroidFileManager.Mode.import
        } else {
            
            mode = AndroidFileManager.Mode.export
        }
        
        self.androidFileManager = AndroidFileManager(context: UIApplication.shared.androidActivity, mode: mode)
        self.androidFileManager?.isMultipleSelection = documentPickerVC.allowsMultipleSelection
        self.androidFileManager?.listener = { path in
            
            documentPickerVC.delegate?.documentPicker(documentPickerVC, didPickDocumentsAt: [URL(fileURLWithPath: path)])
        }
        self.androidFileManager?.show()
    }
}
