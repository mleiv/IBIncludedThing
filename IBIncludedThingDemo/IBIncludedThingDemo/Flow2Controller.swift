//
//  Flow2Controller.swift
//  IBIncludedThingDemo
//
//  Created by Emily Ivie on 2/21/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import Foundation

class Flow2Controller: IBIncludedThing {
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}