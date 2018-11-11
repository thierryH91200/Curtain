//
//  MainWindowController.swift
//  Curtain
//
//  Created by thierryH24 on 08/11/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import AppKit

final class MainWindowController: NSWindowController {
    
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var viewCurtain: NSView!
    @IBOutlet weak var myTableView:NSTableView!

    var delegate:CurtainDelegate?
    var curtainViewController : CurtainViewController?
    var secondaryView : NSView!
    
    let tableViewData = [["firstName":"John","lastName":"Doe","emailId":"john.doe@doe.com"],
                         ["firstName":"Jane","lastName":"Doe","emailId":"jane.doe@doe.com"],
                         ["firstName":"Peter","lastName":"Joe","emailId":"peter.joe@doe.com"]]

    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name( "MainWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        curtainViewController =  CurtainViewController()
        
        // load view
        secondaryView = curtainViewController?.view
        delegate = curtainViewController
        
//        self.myTableView.reloadData()

    }
    
    @IBAction func open(_ sender: Any) {
        Commun.shared.addSubview(subView: secondaryView, toView: viewCurtain )
        Commun.shared.setUpLayoutConstraints(item: secondaryView, toItem: viewCurtain)
        let totalTime = delegate?.openCurtain()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime!) {
            
            self.secondaryView.removeFromSuperview()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        Commun.shared.addSubview(subView: secondaryView, toView: viewCurtain )
        Commun.shared.setUpLayoutConstraints(item: secondaryView, toItem: viewCurtain)
        let _ = delegate?.closeCurtain()
    }
    
}

extension MainWindowController:NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{

        let result  = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        let id = (tableColumn?.identifier.rawValue)!
        result.textField?.stringValue = tableViewData[row][id]!
        return result
    }
    
}

