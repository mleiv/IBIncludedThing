//
//  SecondController.swift
//  IBIncludedStoryboardDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class SecondController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var sentValue: String = "None"

    @IBAction func openThirdPage(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("Push Third", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from First: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        findChildViewControllerType(ThirdController.self, inController: segue.destinationViewController) { controller in
            controller.sentValue = self.textField?.text ?? ""
        }
    }
    
}
