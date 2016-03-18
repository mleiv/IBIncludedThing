//
//  Flow1Controller.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class Flow1Controller: UIViewController {
    // do things in here that happen in the flow rather than the scene, like closing navigation stacks.
    
    var sentValue: String?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // embed segues
        if let controller = segue.destinationViewController as? FirstController {
            // nothing passed here
        }
        if let controller = segue.destinationViewController as? SecondController {
            controller.sentValue = sentValue ?? ""
        }
        // existing flow segue
        if let flowController = segue.destinationViewController as? Flow1Controller {
            flowController.sentValue = sentValue
        }
        // new flow segue
        if let navController = segue.destinationViewController as? UINavigationController {
            if let flowController = navController.visibleViewController as? Flow2Controller {
                flowController.sentValue = sentValue
            }
        }
    }
}