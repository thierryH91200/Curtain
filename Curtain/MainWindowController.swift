//
//  MainWindowController.swift
//  Curtain
//
//  Created by thierryH24 on 08/11/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import Cocoa

protocol mainDelegate {
    func removeCurtain()
}

class MainWindowController: NSWindowController, mainDelegate {
    func removeCurtain() {
        (curtainViewController?.view)!.removeFromSuperview()
    }
    
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var viewCurtain: NSView!
    
    var delegate:curtainDelegate?
    var curtainViewController : CurtainViewController?
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name( "MainWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        curtainViewController =  CurtainViewController()
        curtainViewController?.delegate = self
        _ = curtainViewController?.view
        delegate = curtainViewController
        
    }
    
    @IBAction func open(_ sender: Any) {
        viewCurtain.addSubview((curtainViewController?.view)! )
        setUpLayoutConstraints(item: (curtainViewController?.view)!, toItem: viewCurtain)
        delegate?.openCurtain()
    }
    
    func setUpLayoutConstraints(item: NSView, toItem: NSView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0)
    {
        item.translatesAutoresizingMaskIntoConstraints = false
        let sourceListLayoutConstraints = [
            NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: toItem, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: item, attribute: .right, relatedBy: .equal, toItem: toItem, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1, constant: 0)]
        NSLayoutConstraint.activate(sourceListLayoutConstraints)
    }

    @IBAction func close(_ sender: Any) {
        let view = (curtainViewController?.view)!
        viewCurtain.addSubview(view )
        setUpLayoutConstraints(item: view, toItem: viewCurtain)
        delegate?.closeCurtain()
    }

}
