//
//  ImageCellModel.swift
//  TinkoffApp
//
//  Created by Михаил on 18.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
protocol ImageCellModelProtocol {
    var id: Int { get }
    //var image: UIImage { get set }
    var image: ImageType { get set }
    var imageURL: URL { get }
    func loadImage(completion: @escaping () -> Void)
    
}
enum ImageType {
    case placeholder
    case loaded(image: UIImage)
    var image: UIImage {
        switch self {
        case .placeholder:
            if let placeholder = UIImage(named: "ImagePlaceholder") {
                return placeholder
            }
            return UIImage()
        case .loaded(let image):
            return image
        }
    }
}
class Image: ImageCellModelProtocol {
    var imageURL: URL
    
    var id: Int
    var image: ImageType
    
    init(id: Int, url: URL, image: UIImage?) {
        self.id = id
        if let image = image {
            self.image = .loaded(image: image)
        } else {
            self.image = .placeholder
        }
        self.imageURL = url
    }
    
    func loadImage(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: self.imageURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = .loaded(image: image)
                        completion()
                    }
                } else {
                    // Отображение ихображения по умолчанию
                    DispatchQueue.main.async {
                        self.image = .placeholder
                        completion()
                    }
                }
            } else {
                // Отображение ихображения по умолчанию
                DispatchQueue.main.async {
                    self.image = .placeholder
                    completion()
                }
            }
        }
    }
}
