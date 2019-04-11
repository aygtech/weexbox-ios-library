//
//  ViewController.swift
//  WeexBoxExample
//
//  Created by Mario on 2018/11/20.
//  Copyright © 2018 WeexBox. All rights reserved.
//

import UIKit
import WeexBox

class ViewController: WBWeexViewController {
    override func viewDidLoad() {
        router.url = "page/about.js"
        super.viewDidLoad()
    }
}

