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
class ConversationViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var messageBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var newMessageField: UITextField!
    @IBOutlet weak var messageBar: UIToolbar!
    @IBOutlet weak var chatView: UITableView!
    var conversation: Channel_db!
    lazy var db = Firestore.firestore()
    var reference: CollectionReference!
    
    lazy var tableViewDataSource: TableViewDataSource<Message_db> = {
        let sort = NSSortDescriptor(key: "created", ascending: true)
        var predicate: NSPredicate?
        if let id = conversation.identifier {
            predicate = NSPredicate(format: "channelID == %@", id)
        }
        let request: NSFetchRequest<NSFetchRequestResult> = Message_db.fetchRequest()
        request.sortDescriptors = [sort]
        request.predicate = predicate
        let fetchedResultsController = CoreDataManager.getFetchedResultsController(fetchRequest: request)
        fetchedResultsController.delegate = self
        let source = TableViewDataSource<Message_db>(fetchedResultsController: fetchedResultsController) { [weak self] item, indexPath in
            if let cell = self?.chatView.dequeueReusableCell(withIdentifier: String(describing: ChatViewCell.self), for: indexPath) as? ChatViewCell {
                cell.userID = UserIDManager.userId
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
        reference = db.collection("channels/\(conversation.identifier ?? "")/messages")
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let shot = snapshot {
                self?.messages(shot.documentChanges)
                if let messageCount = self?.tableViewDataSource.data().count, messageCount > 0 {
                    let indexPath = IndexPath(row: messageCount - 1, section: 0)
                    self?.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                
            }
        }
        title = conversation.name
        chatView.register(UINib(nibName: String(describing: ChatViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChatViewCell.self))
        chatView.dataSource = tableViewDataSource
        setColors()
    }
    
    func setColors() {
        chatView.backgroundColor = ThemeManager.currentTheme().mainColor
        messageBar.barTintColor = ThemeManager.currentTheme().mainColor
        newMessageField.backgroundColor = ThemeManager.currentTheme().textFieldColor
        
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
    // MARK: - Messages
    func messages(_ documents: [DocumentChange]) {
        var messagesToSave=[Message]()
        for changeDocument in documents {
            switch changeDocument.type {
            case .added, .modified:
                if !tableViewDataSource.data().contains(where: {$0.messageId == changeDocument.document.documentID}) {
                    let data = changeDocument.document.data()
                    if let senderName = data["senderName"] as? String,
                        let created = data["created"] as? Timestamp,
                        let content = data["content"] as? String,
                        let senderId = data["senderId"] as? String,
                        let channelID = conversation.identifier,
                        !content.isEmpty {
                        messagesToSave.append(.init(messageId: changeDocument.document.documentID,
                                                    content: content,
                                                    created: created.dateValue(),
                                                    senderId: senderId, senderName: senderName,
                                                    channelID: channelID))
                    }
                    
                }
            default : break
            }
            
        }
        CoreDataManager.save(messages: messagesToSave)
        
    }
    @IBAction func sendNewMessage(_ sender: Any) {
        if let message = newMessageField.text, !message.isEmpty, let userId = UserIDManager.userId {
            newMessageField.text = nil
            DispatchQueue.global().async {
                var name = DataManager().read(path: DataManager.usernamePath)
                if name.isEmpty {
                    name = "no name"
                }
                let date = Timestamp(date: Date())
                self.reference.addDocument(data: ["senderName": name, "created": date,
                                                  "content": message, "senderId": userId])
            }
            
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
