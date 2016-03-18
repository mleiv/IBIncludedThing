//
//  SixthController.swift
//  IBIncludedThingDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class SixthController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!

    var sentValue: String = "None" {
        didSet {
            label?.text = "Value shared from Fourth: \(!sentValue.isEmpty ? sentValue : "None")"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.findChildViewControllerType(SeventhController.self) { controller in
            controller.sentValue = self.textField?.text ?? ""
        }
    }

    // Unfortunately, due to the late stage that these embedded views are included in the parent scene, they cannot use prepareForSegue. You can, however, use the sharing method demonstrated here between 4th and 6th to ferry data  from the scene loaded before prepareForSegue down to the view loaded later.
}
