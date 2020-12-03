//
//  ProfileViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 21.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate, ImageSelectedDelegate {
    
    @IBOutlet weak var dataIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var profileEditButton: UIButton!
    
    @IBOutlet weak var operationsSaveButton: UIButton!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var operationManager: DataSaverProtocol!
    var gcdManager: DataSaverProtocol!
    var userName: String?
    var userDescription: String?
    var profileImage: UIImage?
    var startSave = false
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
        let load = UIAlertAction(title: "Download", style: .default) { _ in
            self.performSegue(withIdentifier: "toImagesView", sender: nil)
        }
        alert.addAction(load)
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
            set(newImage: pickedImage)
        }
        
    }
    func set(newImage: UIImage) {
        image.image = newImage
        image.isHidden = false
        saveButtonOn()
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
        userNameField.accessibilityIdentifier = "profileUserNameField"
        descriptionView.accessibilityIdentifier = "profileDescriptionView"
        logSaveButton()
        descriptionView.delegate = self
        profileView.layer.cornerRadius = profileView.layer.bounds.height / 2
        image.layer.cornerRadius = image.layer.bounds.height / 2
        gcdSaveButton.layer.cornerRadius = (14 / 40) * gcdSaveButton.layer.bounds.height
        operationsSaveButton.layer.cornerRadius = (14 / 40) * operationsSaveButton.layer.bounds.height
        imagePicker.delegate = self
        setColors()
        profileEditButton.layer.cornerRadius = 5
        profileEditButton.layer.borderWidth = 1
        gcdManager = GCDDataManager(dataManager: DataManager { [weak self] fault in
            DispatchQueue.main.async {
                if fault {
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
//                        self?.editButton.isEnabled = true
//                        self?.saveButtonOn()
                        self?.endWriting()
                    })
                    alert.addAction(UIAlertAction(title: "Повторить", style: .default) {_ in
                        self?.gcdSave("sender")
                    })
                    self?.present(alert, animated: true, completion: nil)
                    
                } else {
                    self?.showSaveDoneAlert()
                }
                
            }
            
        })
        operationManager = OperationDataManager { [weak self] fault in
            DispatchQueue.main.async {
                if fault {
                    OperationQueue.main.addOperation {
                        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                            self?.editButton.isEnabled = true
//                            self?.saveButtonOn()
                            self?.endWriting()
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
        endWriting()
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func selected(image: UIImage) {
        set(newImage: image)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImagesViewController {
            destination.delegate = self
        }
    }
    var edited = false
    @IBAction func editProfile(_ sender: Any) {
        let x = profileEditButton.layer.position.x
        let y = profileEditButton.layer.position.y
        userNameField.isEnabled = !userNameField.isEnabled
        descriptionView.isEditable = !descriptionView.isEditable
        if userNameField.isEnabled {
            userNameField.borderStyle = .roundedRect
        } else {
            userNameField.borderStyle = .none
        }
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.repeat, .allowUserInteraction], animations: {
            if !self.edited {
                self.edited = true
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 0.2) {
                                    self.profileEditButton.layer.position.x = x + 5
                                    self.profileEditButton.layer.position.y = y + 5
                                    self.profileEditButton.transform = CGAffineTransform(rotationAngle: 18 * (CGFloat.pi / 180))
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2,
                                   relativeDuration: 0.2) {
                                    self.profileEditButton.layer.position.y = y - 5
                                    //self.button.layer.position.y=y+5;
                                    
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4,
                                   relativeDuration: 0.2) {
                                    self.profileEditButton.layer.position.y = y - 5
                                    self.profileEditButton.layer.position.x = x - 5
                                    self.profileEditButton.transform = CGAffineTransform(rotationAngle: -18 * (CGFloat.pi / 180))
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6,
                                   relativeDuration: 0.2) {
                                    self.profileEditButton.layer.position.y = y + 5
                }
                UIView.addKeyframe(withRelativeStartTime: 0.8,
                                   relativeDuration: 0.2) {
                                    self.profileEditButton.layer.position.y = y
                                    self.profileEditButton.layer.position.x = x
                                    self.profileEditButton.transform = CGAffineTransform(rotationAngle: 0)
                }
                
            } else {
                
                self.edited = false
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 1) {
                                    self.profileEditButton.layer.removeAllAnimations()
                                    self.profileEditButton.layer.position.y = y
                                    self.profileEditButton.layer.position.x = x
                                    self.profileEditButton.transform = CGAffineTransform(rotationAngle: 0)
                }
                
            }
            
        }, completion: nil)
    }
    @IBAction func didEditUsername(_ sender: Any) {
        checkChanges()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        checkChanges()
    }
    func checkChanges() {
        if (userNameField.text != userName || descriptionView.text != userDescription || image.image != profileImage) && !startSave {
            saveButtonOn()
        } else {
            saveButtonsOff()
        }
        
    }
    func setColors() {
        profileEditButton.layer.borderColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor.cgColor
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
        //endWriting()
        
    }
    
    @IBAction func operationsSave(_ sender: Any) {
        startWriting()
        operationManager.write(name: userNameField.text ?? "", description: descriptionView.text ?? "", image: image.image)
        //endWriting()
    }
    func startWriting() {
        startSave = true
        saveButtonsOff()
        edited = false
        profileEditButton.layer.removeAllAnimations()
        profileEditButton.isEnabled = false
        userNameField.isEnabled = false
        descriptionView.isEditable = false
        dataIndicator.isHidden = false
        dataIndicator.startAnimating()
    }
    func endWriting() {
        startSave = false
        dataIndicator.stopAnimating()
        dataIndicator.isHidden = true
        profileEditButton.isEnabled = true
        userDescription = descriptionView.text
        userName = userNameField.text
        profileImage = image.image
    }
    
}
