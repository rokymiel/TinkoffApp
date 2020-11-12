//
//  RootNavigationViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 11.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        RootAssembly.root = self
    }
}
