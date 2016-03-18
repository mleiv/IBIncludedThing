//
//  SecondController.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class SecondController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var sentValue: String = "None"

    @IBAction func openThirdPage(sender: UIButton) {
        (parentViewController as? Flow1Controller)?.sentValue = textField.text
        parentViewController?.performSegueWithIdentifier("Push Third", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from First: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
}
