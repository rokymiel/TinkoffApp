//
//  ProfileViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 21.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    @IBAction func changePhotoClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "From library", style: .default) {
            UIAlertAction in
            self.openLibrary()
        }
        alert.addAction(library)
        let camera = UIAlertAction(title: "From camera", style: .default) {
            UIAlertAction in
            self.openCamera()
        }
        alert.addAction(camera)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            // It will dismiss action sheet
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage{
            image.image = pickedImage
            image.isHidden=false
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //logSaveButton()
        // При вызове метода выбрасывается исключение Unexpectedly found nil while implicitly unwrapping an Optional value
        // Это связано с тем, что на момент исполнения инициализатора еще не был создан экземпляр кнопки. Поэтому при обращении к кнопке мы наткнулись на nil из-за чего и произошла ошибка
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logSaveButton()
        // фреймы развные. Это связано с тем, что на момент выполнения viewDidLoad subviews еще не были добавлены, а значет не был произведен рачет их фреймов. При этом после появления view пользователю все было посчитано и при вызове viewDidAppear отображаются актуальные и реальные для устроства данные о frame
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        logSaveButton()
        profileView.layer.cornerRadius=profileView.layer.bounds.height/2
        image.layer.cornerRadius=image.layer.bounds.height/2
        saveButton.layer.cornerRadius=(14/40)*saveButton.layer.bounds.height
        imagePicker.delegate = self
        
        
    }
    func logSaveButton()  {
        NSLog("\(saveButton.frame)")
    }
}
