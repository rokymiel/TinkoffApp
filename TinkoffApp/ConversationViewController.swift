//
//  ConversationViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase
class ConversationViewController: UIViewController {
    
    @IBOutlet weak var messageBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var newMessageField: UITextField!
    @IBOutlet weak var messageBar: UIToolbar!
    @IBOutlet weak var chatView: UITableView!
    var conversation: Channel!
    lazy var db = Firestore.firestore()
    var reference: CollectionReference!
    var messages = [Message]()
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
        reference = db.collection("channels/\(conversation.identifier)/messages")
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let shot = snapshot {
                self?.getMessages(shot.documents)
                self?.chatView.reloadData()
                if let messageCount = self?.messages.count, messageCount > 0 {
                    let indexPath = IndexPath(row: messageCount - 1, section: 0)
                    self?.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                
            }
        }
        title = conversation.name
        chatView.register(UINib(nibName: String(describing: ChatViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChatViewCell.self))
        chatView.dataSource = self
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
    func getMessages(_ documents: [QueryDocumentSnapshot]) {
        messages = [Message]()
        for document in documents {
            let data = document.data()
            if let senderName = data["senderName"] as? String,
                let created = data["created"] as? Timestamp,
                let content = data["content"] as? String,
                let senderId = data["senderId"] as? String, !content.isEmpty {
                
                messages.append(.init(content: content, created: created.dateValue(), senderId: senderId, senderName: senderName))
            }
            messages.sort(by: {$0.created.compare($1.created) == .orderedAscending})
            
        }
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
}
// MARK: - Table View Data
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatViewCell.self), for: indexPath) as? ChatViewCell {
            cell.userID = UserIDManager.userId
            cell.configure(with: messages[indexPath.row])
            return cell
        }
        return UITableViewCell()
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
