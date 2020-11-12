//
//  ChatModel.swift
//  TinkoffApp
//
//  Created by Михаил on 12.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase
import CoreData
protocol ChatProtocol {
    func send(new message: String)
    func messages(_ documents: [DocumentChange])
}
protocol ChatDelegate: NSObject {
    var tableViewDataSource: TableViewDataSource<Message_db> { get }
}
class Chat: ChatProtocol {
    weak var delegate: ChatDelegate?
    var conversationId: String
    var db = Firestore.firestore()
    var reference: CollectionReference
    init(id: String, delegate: ChatDelegate, updateTable: @escaping () -> Void) {
        conversationId = id
        self.delegate = delegate
        reference = db.collection("channels/\(id)/messages")
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let shot = snapshot {
                self?.messages(shot.documentChanges)
                
                updateTable()
                
            }
        }
    }
    func send(new message: String) {
        let userId = RootAssembly.serviceAssembly.userID.userId
        //newMessageField.text = nil
        DispatchQueue.global().async {
            var name = DataManager(nil).read(path: DataManager.usernamePath)
            if name.isEmpty {
                name = "no name"
            }
            let date = Timestamp(date: Date())
            self.reference.addDocument(data: ["senderName": name, "created": date,
                                              "content": message, "senderId": userId])
        }
        
    }
    func messages(_ documents: [DocumentChange]) {
        var messagesToSave=[MessageCellModel]()
        for changeDocument in documents {
            switch changeDocument.type {
            case .added, .modified:
                if let chat = delegate {
                    if !chat.tableViewDataSource.data().contains(where: {$0.messageId == changeDocument.document.documentID}) {
                    let data = changeDocument.document.data()
                    if let senderName = data["senderName"] as? String,
                        let created = data["created"] as? Timestamp,
                        let content = data["content"] as? String,
                        let senderId = data["senderId"] as? String,
                        !content.isEmpty {
                        messagesToSave.append(Message(messageId: changeDocument.document.documentID,
                                                      content: content,
                                                      created: created.dateValue(),
                                                      senderId: senderId, senderName: senderName,
                                                      channelID: conversationId))
                    }
                    
                    }
                    
                }
            default : break
            }
            
        }
         RootAssembly.serviceAssembly.coreData.save(messages: messagesToSave)
        
    }
}
