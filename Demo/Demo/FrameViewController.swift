//
//  FrameViewController.swift
//  AndroidUIKitDemo
//
//  Created by Carlos Duclos on 7/12/18.
//

import UIKit

class FrameViewController: UIViewController {
    
    // MARK: - Life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let redSquare = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        redSquare.backgroundColor = .blue
        view.addSubview(redSquare)
        
        let blueSquare = UIView(frame: CGRect(x: 200, y: 100, width: 100, height: 100))
        blueSquare.backgroundColor = .red
        view.addSubview(blueSquare)
    }
    
}
