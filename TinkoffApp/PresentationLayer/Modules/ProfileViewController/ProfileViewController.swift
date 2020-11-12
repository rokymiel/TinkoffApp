//
//  ProfileViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 21.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var dataIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var gcdSaveButton: UIButton!
    
    @IBOutlet weak var operationsSaveButton: UIButton!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var operationManager: DataSaverProtocol!
    var gcdManager: DataSaverProtocol!
    var userName: String?
    var userDescription: String?
    var profileImage: UIImage?
    
    @IBAction func changePhotoClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "From library", style: .default) { _ in
            self.openLibrary()
        }
        alert.addAction(library)
        let camera = UIAlertAction(title: "From camera", style: .default) { _ in
            self.openCamera()
        }
        alert.addAction(camera)
        let clear = UIAlertAction(title: "Default", style: .default) { _ in
            if self.image.image != nil {
                self.saveButtonOn()
            }
            self.image.image = nil
            self.image.isHidden = true
        }
        alert.addAction(clear)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            image.image = pickedImage
            image.isHidden = false
            saveButtonOn()
        }
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logSaveButton()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        logSaveButton()
        descriptionView.delegate = self
        profileView.layer.cornerRadius = profileView.layer.bounds.height / 2
        image.layer.cornerRadius = image.layer.bounds.height / 2
        gcdSaveButton.layer.cornerRadius = (14 / 40) * gcdSaveButton.layer.bounds.height
        operationsSaveButton.layer.cornerRadius = (14 / 40) * operationsSaveButton.layer.bounds.height
        imagePicker.delegate = self
        setColors()
        gcdManager = GCDDataManager { [weak self] fault in
            DispatchQueue.main.async {
                if fault {
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                        self?.editButton.isEnabled = true
                        self?.saveButtonOn()
                    })
                    alert.addAction(UIAlertAction(title: "Повторить", style: .default) {_ in
                        self?.gcdSave("sender")
                    })
                    self?.present(alert, animated: true, completion: nil)
                    
                } else {
                    self?.showSaveDoneAlert()
                }
                
            }
            
        }
        operationManager = OperationDataManager { [weak self] fault in
            DispatchQueue.main.async {
                if fault {
                    OperationQueue.main.addOperation {
                        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self?.editButton.isEnabled = true
                            self?.saveButtonOn()
                        })
                        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
                            self?.operationsSave("sender")
                        })
                        self?.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self?.showSaveDoneAlert()
                }
                
            }
        }
        dataIndicator.startAnimating()
        gcdManager.read { [weak self] name, descr, profileImage in
            self?.userNameField.text = name
            self?.descriptionView.text = descr
            print(profileImage == nil)
            self?.image.image = profileImage
            if  self?.image.image != nil {
                self?.image.isHidden = false
                
            }
            self?.userName = name
            self?.userDescription = descr
            self?.profileImage = profileImage
            self?.dataIndicator.stopAnimating()
        }
        //        operationManager.read {
        //            [weak self] name,descr,profileImage in
        //            self?.userNameField.text=name
        //            self?.descriptionView.text=descr
        //            print(profileImage==nil)
        //            self?.image.image=profileImage
        //            if let _ = self?.image.image{
        //                self?.image.isHidden=false
        //
        //            }
        //            self?.userName=name
        //            self?.userDescription = descr
        //            self?.profileImage=profileImage
        //            self?.dataIndicator.stopAnimating()
        //        }
    }
    func showSaveDoneAlert() {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func editProfile(_ sender: Any) {
        userNameField.isEnabled = !userNameField.isEnabled
        descriptionView.isEditable = !descriptionView.isEditable
        if userNameField.isEnabled {
            userNameField.borderStyle = .roundedRect
        } else {
            userNameField.borderStyle = .none
        }
    }
    @IBAction func didEditUsername(_ sender: Any) {
        checkChanges()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        checkChanges()
    }
    func checkChanges() {
        if userNameField.text != userName || descriptionView.text != userDescription || image.image != profileImage {
            saveButtonOn()
        } else {
            saveButtonsOff()
        }
        
    }
    func setColors() {
        
        view.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        userNameField.textColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor
        userNameField.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        descriptionView.textColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor
        
    }
    
    func logSaveButton() {
        NSLog("\(gcdSaveButton.frame)")
    }
    func saveButtonsOff() {
        gcdSaveButton.isEnabled = false
        operationsSaveButton.isEnabled = false
    }
    func saveButtonOn() {
        gcdSaveButton.isEnabled = true
        operationsSaveButton.isEnabled = true
    }
    @IBAction func gcdSave(_ sender: Any) {
        startWriting()
        let saveName: String? = userNameField.text == userName ? nil : userNameField.text
        let saveDescription: String? = descriptionView.text == userDescription ? nil : descriptionView.text
        gcdManager.write(name: saveName, description: saveDescription, image: image.image)
        endWriting()
        
    }
    
    @IBAction func operationsSave(_ sender: Any) {
        startWriting()
        operationManager.write(name: userNameField.text ?? "", description: descriptionView.text ?? "", image: image.image)
        endWriting()
    }
    func startWriting() {
        editButton.isEnabled = false
        saveButtonsOff()
        userNameField.isEnabled = false
        descriptionView.isEditable = false
        dataIndicator.isHidden = false
        dataIndicator.startAnimating()
    }
    func endWriting() {
        dataIndicator.stopAnimating()
        dataIndicator.isHidden = true
        editButton.isEnabled = true
        userDescription = descriptionView.text
        userName = userNameField.text
        profileImage = image.image
    }
}
