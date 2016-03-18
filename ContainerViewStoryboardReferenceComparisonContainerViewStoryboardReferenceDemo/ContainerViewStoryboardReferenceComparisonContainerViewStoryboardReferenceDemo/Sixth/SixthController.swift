//
//  SixthController.swift
//  ContainerViewStoryboardReferenceDemo
//
//  Created by Emily Ivie on 3/18/16.
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
}
