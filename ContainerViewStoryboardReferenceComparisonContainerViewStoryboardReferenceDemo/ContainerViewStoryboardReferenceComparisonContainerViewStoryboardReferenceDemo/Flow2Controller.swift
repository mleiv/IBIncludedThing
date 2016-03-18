//
//  Flow2Controller.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class Flow2Controller: UIViewController {
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var sentValue: String?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // embed segues:
        if let controller = segue.destinationViewController as? ThirdController {
            controller.sentValue = sentValue ?? ""
        }
        if let controller = segue.destinationViewController as? FourthController {
            controller.sentValue = sentValue ?? ""
        }
        if let controller = segue.destinationViewController as? SeventhController {
            controller.sentValue = sentValue ?? ""
        }
        // existing flow segue
        if let flowController = segue.destinationViewController as? Flow2Controller {
            flowController.sentValue = sentValue
        }
    }
}