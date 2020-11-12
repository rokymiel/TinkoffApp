//
//  ConversationViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class ConversationViewController: UIViewController, NSFetchedResultsControllerDelegate, ChatDelegate {
    
    @IBOutlet weak var messageBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var newMessageField: UITextField!
    @IBOutlet weak var messageBar: UIToolbar!
    @IBOutlet weak var chatView: UITableView!
    var conversation: Channel_db!
    lazy var db = Firestore.firestore()
    var reference: CollectionReference!
    var chatModel: ChatProtocol!
    lazy var tableViewDataSource: TableViewDataSource<Message_db> = {
        let sort = NSSortDescriptor(key: "created", ascending: true)
        var predicate: NSPredicate?
        if let id = conversation.identifier {
            predicate = NSPredicate(format: "channelID == %@", id)
        }
        let request: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        request.sortDescriptors = [sort]
        request.predicate = predicate
        let fetchedResultsController = RootAssembly.serviceAssembly.coreData.getFetchedResultsController(fetchRequest: request)
        fetchedResultsController.delegate = self
        let source = TableViewDataSource<Message_db>(fetchedResultsController: fetchedResultsController) { [weak self] item, indexPath in
            if let cell = self?.chatView.dequeueReusableCell(withIdentifier: String(describing: ChatViewCell.self), for: indexPath) as? ChatViewCell {
                cell.userID = RootAssembly.serviceAssembly.userID.userId
                cell.configure(with: item)
                return cell
            }
            return UITableViewCell()
        }
        return source
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        chatModel = Chat(id: conversation.identifier ?? "", delegate: self) { [weak self] in
            if let messageCount = self?.tableViewDataSource.data().count, messageCount > 0 {
                let indexPath = IndexPath(row: messageCount - 1, section: 0)
                self?.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
            
        }
        title = conversation.name
        chatView.register(UINib(nibName: String(describing: ChatViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChatViewCell.self))
        chatView.dataSource = tableViewDataSource
        setColors()
    }
    
    func setColors() {
        chatView.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        messageBar.barTintColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        newMessageField.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().textFieldColor
        
    }
    
    // MARK: - Keyboard animation
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.messageBarBottomConstraint?.constant = -keyboardFrame.height
        }
    }
    
    @objc
    dynamic func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { _ in
            self.messageBarBottomConstraint?.constant = 0
        }
        
    }
    @IBAction func sendNewMessage(_ sender: Any) {
        if let message = newMessageField.text, !message.isEmpty {
            newMessageField.text = nil
            chatModel.send(new: message)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndex = newIndexPath {
                chatView.insertRows(at: [newIndex], with: .fade)
            }
        case .move:
            if let index = indexPath, let newIndex = newIndexPath {
                chatView.deleteRows(at: [index], with: .fade)
                chatView.insertRows(at: [newIndex], with: .fade)
                
            }
        case .update:
            if let index = indexPath {
                chatView.reloadRows(at: [index], with: .fade)
                
            }
        case .delete:
            if let index = indexPath {
                chatView.deleteRows(at: [index], with: .fade)
            }
            
        @unknown default:
            fatalError()
        }
        
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.chatView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.chatView.endUpdates()
    }
}

// MARK: - Animate with keyboard
extension ConversationViewController {
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        if let duration = notification.userInfo![durationKey] as? Double,
            let keyboardFrameValue = notification.userInfo![frameKey] as? NSValue,
            let curveValue = notification.userInfo![curveKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue) {
            
            let animator = UIViewPropertyAnimator( duration: duration, curve: curve) {
                animations?(keyboardFrameValue.cgRectValue)
                self.view?.layoutIfNeeded()
                
            }
            animator.startAnimation()
        }
        
    }
}
