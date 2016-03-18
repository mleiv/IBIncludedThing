//
//  ViewController.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class FirstController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    @IBAction func openSecondPage(sender: UIButton) {
        (parentViewController as? Flow1Controller)?.sentValue = textField.text
        parentViewController?.performSegueWithIdentifier("Push Second", sender: sender)
    }
    
    
}

