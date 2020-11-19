//
//  ImageCell.swift
//  TinkoffApp
//
//  Created by Михаил on 18.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell, ConfigurableView {
    func configure(with model: ImageCellModelProtocol) {
        currentImage = model.id
        switch model.image {
        case .loaded(let loadedImage):
            image.image = loadedImage
        case .placeholder:
            image.image = model.image.image
            model.loadImage { [weak self] in
                if let id = self?.currentImage, id == model.id {
                    self?.image.image = model.image.image
                }
                
            }
        }
    }
    var currentImage: Int?
    typealias ConfigurableType = ImageCellModelProtocol
    
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
