//
//  ViewController.swift
//  WeexBoxExample
//
//  Created by Mario on 2018/11/20.
//  Copyright © 2018 WeexBox. All rights reserved.
//

import UIKit
import WeexBox
import Lottie
class ViewController: WBWeexViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func clickOntheBtn(_ sender: Any) {
        var route = Router()
        route.name = "fuck";
        route.params = ["test":"test"]
        route.open(from: self)
    }
}

