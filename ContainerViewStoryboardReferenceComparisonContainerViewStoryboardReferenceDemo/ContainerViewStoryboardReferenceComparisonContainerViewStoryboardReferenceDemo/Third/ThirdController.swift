//
//  ThirdController.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class ThirdController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var sentValue: String = "None"

    @IBAction func openFourthPage(sender: UIButton) {
        (parentViewController as? Flow2Controller)?.sentValue = textField.text
        parentViewController?.performSegueWithIdentifier("Push Fourth", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.text = "Value sent from Second: \(!sentValue.isEmpty ? sentValue : "None")"
    }
    
}
