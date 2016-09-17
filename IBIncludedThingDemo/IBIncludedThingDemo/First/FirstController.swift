//
//  ViewController.swift
//  IBIncludedThingDemo
//
//  Created by Emily Ivie on 2/20/16.
//  Copyright © 2016 urdnot. All rights reserved.
//

import UIKit

class FirstController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    @IBAction func openSecondPage(_ sender: UIButton) {
        parent?.performSegue(withIdentifier: "Push Second", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.findChildViewControllerType(SecondController.self) { controller in
            controller.sentValue = self.textField?.text ?? ""
        }
    }
}

