//
//  UIAlertController.swift
//  androiduikittarget
//
//  Created by Marco Estrella on 9/11/18.
//

import Foundation
import Android

public class UIAlertController {
    
    public weak var presentingViewController: UIViewController?
    
    public var title: String?
    public var message: String?
    public var preferredStyle: UIAlertControllerStyle = UIAlertControllerStyle.alert
    
    /// The actions that the user can take in response to the alert or action sheet.
    public var actions = [UIAlertAction]()
    
    public var textFields: [UITextField]?
    
    /// The preferred action for the user to take from an alert.
    var preferredAction: UIAlertAction?
    
    public init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle){
        
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
    }
    
    /// Attaches an action object to the alert or action sheet.
    public func addAction(_ action: UIAlertAction){
        actions.append(action)
    }
    
    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil){
        
        if textFields == nil {
            textFields = [UITextField]()
        }
        
        let newTextField = UITextField.init()
        configurationHandler?(newTextField)
        textFields?.append(newTextField)
    }
}

/// An action that can be taken when the user taps a button in an alert.
public class UIAlertAction {
    
    /// The title of the action’s button.
    public var title: String?
    
    /// The style that is applied to the action’s button.
    public var style: UIAlertActionStyle = UIAlertActionStyle.default
    
    /// A Boolean value indicating whether the action is currently enabled.
    public var isEnabled: Bool = true
    
    fileprivate var handler: ((UIAlertAction) -> Void)?
    
    /// Create and return an action with the specified title and behavior.
    public init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)? = nil){
        
        self.title = title
        self.style = style
        self.handler = handler
    }
}

/// Constants indicating the type of alert to display.
public enum UIAlertControllerStyle {
    
    /// An alert displayed modally for the app.
    case alert
    
    /// An action sheet displayed in the context of the view controller that presented it.
    case actionSheet
}

/// Styles to apply to action buttons in an alert.
public enum UIAlertActionStyle {
    
    /// Apply the default style to the action’s button.
    case `default`
    
    /// Apply a style that indicates the action cancels the operation and leaves things unchanged.
    case cancel
    
    /// Apply a style that indicates the action might change or delete data.
    case destructive
}

public extension UIViewController {
    
    public func present(_ alertController: UIAlertController, animated: Bool, completion: (() -> ())? = nil){
        alertController.presentingViewController = self
        
        //let themeAlertDialogDefaultId = UIScreen.main.activity.getIdentifier(name: "AlertDialogTheme", type: "style")
        
        let androidAlertDialogBuilder = AndroidAlertDialog.Builder(context: UIScreen.main.activity)
        androidAlertDialogBuilder.setCancelable(cancelable: false)
        
        if(alertController.title != nil){
            androidAlertDialogBuilder.setTitle(title: alertController.title!)
        }
        
        if(alertController.actions.count > 2){
            createCustomAlertDialog(alertController, androidAlertDialogBuilder)
        }else{
            createNormalAlertDialog(alertController, androidAlertDialogBuilder)
        }
    }
    
    private func createNormalAlertDialog(_ alertController: UIAlertController, _ androidAlertDialogBuilder: AndroidAlertDialog.Builder){
        
        let alertActions = alertController.actions.filter { alertAction in
            return alertAction.style != .cancel
        }
        
        let cancelAlertActions = alertController.actions.filter { alertAction in
            return alertAction.style == .cancel
        }
        
        guard cancelAlertActions.count < 2
            else { fatalError("There should only be 1 cancel alert action.") }
        
        if(cancelAlertActions.count > 0){
            let cancelAlertAction = cancelAlertActions[0]
            androidAlertDialogBuilder.setNegativeButton(text: cancelAlertAction.title ?? ""){ dialog, which in
                cancelAlertAction.handler?(cancelAlertAction)
                dialog?.dismiss()
                self.androidAlertDialog = nil
            }
        }
        
        if(alertActions.count > 0){
            let alertAction = alertActions[0]
            
            androidAlertDialogBuilder.setPositiveButton(text: alertAction.title ?? ""){ dialog, which in
                alertAction.handler?(alertAction)
                dialog?.dismiss()
                self.androidAlertDialog = nil
            }
        }
        
        if(alertActions.count > 1){
            let alertAction = alertActions[1]
            
            androidAlertDialogBuilder.setNeutralButton(text: alertAction.title ?? ""){ dialog, which in
                alertAction.handler?(alertAction)
                dialog?.dismiss()
                self.androidAlertDialog = nil
            }
        }
        
        guard let textFields = alertController.textFields else {
            
            if(alertController.message != nil){
                androidAlertDialogBuilder.setMessage(message: alertController.message!)
            }
            self.androidAlertDialog = androidAlertDialogBuilder.show()
            return
        }
        
        if textFields.count > 0 {
            
            androidAlertDialogBuilder.setView(view: inflateTextFields(alertController))
        } else {
            
            if(alertController.message != nil){
                androidAlertDialogBuilder.setMessage(message: alertController.message!)
            }
        }
        
        self.androidAlertDialog = androidAlertDialogBuilder.show()
    }
    
    private func inflateTextFields(_ alertController: UIAlertController) -> AndroidView {
        
        let density = UIScreen.main.activity.density
        
        let dp3 = Int(3 * density)
        let dp24 = Int(24 * density)
        let dp12 = Int(12 * density)
        let dp6 = Int(6 * density)
        
        let llParams = AndroidLinearLayoutLayoutParams(width: AndroidLinearLayoutLayoutParams.MATCH_PARENT, height: AndroidLinearLayoutLayoutParams.WRAP_CONTENT)
        
        let linearLayout = AndroidLinearLayout.init(context: UIScreen.main.activity)
        linearLayout.layoutParams = llParams
        linearLayout.setPadding(left: dp24, top: dp3, right: dp24, bottom: dp3)
        linearLayout.orientation = AndroidLinearLayout.VERTICAL
        
        if(alertController.message != nil && (alertController.message?.count)! > 0){
            
            let textViewMessage = AndroidTextView.init(context: UIScreen.main.activity)
            textViewMessage.layoutParams = AndroidViewGroupLayoutParams.init(width: AndroidViewGroupLayoutParams.MATCH_PARENT, height: AndroidViewGroupLayoutParams.WRAP_CONTENT)
            textViewMessage.setPadding(left: 0, top: dp12, right: 0, bottom: dp6)
            textViewMessage.setTextSize(size: 16.0)
            textViewMessage.color = AndroidGraphicsColor.BLACK
            
            textViewMessage.text = alertController.message
            linearLayout.addView(textViewMessage)
        }
        
        guard let textFields = alertController.textFields else {
            
            return linearLayout
        }
        
        textFields.forEach { uITextField in
            
            linearLayout.addView(uITextField.androidEditText)
        }
        
        return linearLayout
    }
    
    private func createCustomAlertDialog(_ alertController: UIAlertController, _ androidAlertDialogBuilder: AndroidAlertDialog.Builder){
        
        let alertActions = alertController.actions.filter { alertAction in
            return alertAction.style != .cancel
        }
        
        let cancelAlertActions = alertController.actions.filter { alertAction in
            return alertAction.style == .cancel
        }
        
        guard cancelAlertActions.count < 2
            else { fatalError("There should only be 1 cancel alert action.") }
        
        let density = UIScreen.main.activity.density
        
        let llPadding = Int(3 * density)
        
        let linearLayout = AndroidLinearLayout.init(context: UIScreen.main.activity)
        linearLayout.layoutParams = AndroidViewGroupLayoutParams.init(width: AndroidViewGroupLayoutParams.MATCH_PARENT, height: AndroidViewGroupLayoutParams.WRAP_CONTENT)
        linearLayout.orientation = AndroidLinearLayout.VERTICAL
        linearLayout.setPadding(left: 0, top: llPadding, right: llPadding, bottom: llPadding)
        
        let tvPaddingLeft = Int(24 * density)
        let tvPaddingTop = Int(12 * density)
        let tvPaddingRight = Int(24 * density)
        let tvPaddingBottom = Int(6 * density)
        
        if(alertController.message != nil && (alertController.message?.count)! > 0){
            
            let textViewMessage = AndroidTextView.init(context: UIScreen.main.activity)
            textViewMessage.layoutParams = AndroidViewGroupLayoutParams.init(width: AndroidViewGroupLayoutParams.MATCH_PARENT, height: AndroidViewGroupLayoutParams.WRAP_CONTENT)
            textViewMessage.setPadding(left: tvPaddingLeft, top: tvPaddingTop, right: tvPaddingRight, bottom: tvPaddingBottom)
            textViewMessage.setTextSize(size: 16.0)
            textViewMessage.color = AndroidGraphicsColor.BLACK
            
            textViewMessage.text = alertController.message
            linearLayout.addView(textViewMessage)
        }
        
        guard alertController.actions.count > 0
            else { androidAlertDialogBuilder.setView(view: linearLayout); return }
        
        var alertActionForShowing = [UIAlertAction]()
        
        alertActions.forEach { alertAction in
            alertActionForShowing.append(alertAction)
        }
        
        cancelAlertActions.forEach { alertAction in
            alertActionForShowing.append(alertAction)
        }
        
        let options = alertActionForShowing.map { alertAction in
            return alertAction.title ?? ""
        }
        
        let adapter = AndroidArrayAdapter<String>(activity: UIScreen.main.activity, items: options)
        
        let recyclerView = AndroidWidgetRecyclerView.init(context: UIScreen.main.activity)
        recyclerView.layoutParams = AndroidViewGroupLayoutParams.init(width: AndroidViewGroupLayoutParams.MATCH_PARENT, height: AndroidViewGroupLayoutParams.WRAP_CONTENT)
        recyclerView.layoutManager = AndroidWidgetRecyclerViewLinearLayoutManager.init(context: UIScreen.main.activity)
        recyclerView.adapter = adapter
        
        linearLayout.addView(recyclerView)
        
        androidAlertDialogBuilder.setView(view: linearLayout)
        
        self.androidAlertDialog = androidAlertDialogBuilder.show()
        
        adapter.onClickBlock = { position in
            
            let alertAction = alertActionForShowing[position]
            
            alertAction.handler?(alertAction)
            
            self.androidAlertDialog?.dismiss()
            self.androidAlertDialog = nil
        }
    }
}



