//
//  SharedCommon.swift
//  Soroban Account
//
//  Created by thierryH24 on 23/11/2017.
//  Copyright © 2017 thierryH24100. All rights reserved.
//

import AppKit


////////////////////////////////////////////////////////////////
//MARK:-
//MARK:Commun
//MARK:-
////////////////////////////////////////////////////////////////

class Commun
{
    static let shared = Commun()
    
    func addSubview(subView: NSView, toView parentView: NSView)
    {
        let myView = parentView.subviews
        if myView.count > 0
        {
            parentView.replaceSubview(myView[0], with: subView)
        }
        else
        {
            parentView.addSubview(subView)
        }
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

}

