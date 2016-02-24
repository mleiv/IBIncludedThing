//
//  ViewController.swift
//  IBIncludedStoryboardDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class FirstController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    @IBAction func openSecondPage(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("Push Second", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.findChildViewControllerType(SecondController.self) { controller in
            controller.sentValue = self.textField?.text ?? ""
        }
    }
}

