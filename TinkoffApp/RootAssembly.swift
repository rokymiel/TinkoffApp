//
//  RootAssembly.swift
//  TinkoffApp
//
//  Created by Михаил on 11.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class RootAssembly {
    public static weak var root: UINavigationController?
    private(set) static var coreAssembly: ICoreAssembly = CoreAssembly()
    private(set) static var serviceAssembly: IServicesAssembly = ServicesAssembly()
}
