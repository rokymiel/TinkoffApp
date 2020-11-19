//
//  ImagesViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
protocol ImageSelectedDelegate: NSObject {
    func selected(image: UIImage)
}
class ImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageList: UICollectionView!
    weak var delegate: ImageSelectedDelegate?
    var images = [ImageCellModelProtocol]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageList.register(UINib(nibName: String(describing: ImageCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCell.self))
        imageList.dataSource = self
        imageList.delegate = self
        setColors()
        RootAssembly.serviceAssembly.net.loadImageList { [weak self] model, error in
            if let message = error {
                NSLog(message)
                return
            }
            if let data = model {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    for image in data.hits {
                        if let url = URL(string: image.webformatURL) {
                            self?.images.append(Image(id: image.id, url: url, image: nil))
                        }
                    }
                    self?.imageList.reloadData()
                    print(data)
                    
                }
            }
            
        }
        
    }
    func setColors() {
        view.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        imageList.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
    }
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = imageList.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as? ImageCell {
            cell.configure(with: images[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageList.deselectItem(at: indexPath, animated: true)
        switch images[indexPath.row].image {
        case .placeholder:
            showImageSelectError()
        case .loaded(let loadedImage):
            delegate?.selected(image: loadedImage)
            closeView(self)
            
        }
    }
    func showImageSelectError() {
        let alert = UIAlertController(title: "Ошибка", message: "Выбранное изображение не загруженно", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.imageList.bounds.width - 20) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

//        let url = URL(string: "https://pixabay.com/api/?key=19151995-bbfacf4ace45de2b06c3a3dde&q=yellow+flowers&image_type=photo&pretty=true")!
//        let dataTask = URLSession.shared.dataTask(with: url ) { data, _, error in
//            guard let data = data else {return}
//            do {
//                let dataModel = try JSONDecoder().decode(ResponseModel.self, from: data)
//                print(dataModel)
//            } catch {
//                print("LOOOOSERRRR")
//            }
//
//        }
//        dataTask.resume()
