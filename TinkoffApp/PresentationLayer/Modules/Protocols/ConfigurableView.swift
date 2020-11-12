//
//  ConfigurableView.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
protocol ConfigurableView {
    associatedtype ConfigurableType
    func configure(with model: ConfigurableType)
}
