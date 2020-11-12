//
//  ChatListModel.swift
//  TinkoffApp
//
//  Created by Михаил on 12.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase
protocol ChatListProtocol {
    func createNewChennel(with newChennelName: String)
    func channels(_ documents: [DocumentChange])
}
protocol ChatListDelegate: NSObject {
    var tableViewDataSource: TableViewDataSource<Channel_db> { get }
}
class ChatList: ChatListProtocol {
    weak var delegate: ChatListDelegate?
    var db = Firestore.firestore()
    var reference: CollectionReference
    init(delegate: ChatListDelegate) {
        self.delegate = delegate
        reference = db.collection("channels")
        reference.addSnapshotListener {[weak self] snapchot, _ in
            if let shot = snapchot {
                self?.channels(shot.documentChanges)
            }
        }
    }
    func createNewChennel(with newChennelName: String) {
        reference.addDocument(data: ["name": newChennelName])
    }
    func channels(_ documents: [DocumentChange]) {
        var channelsToSave=[ConversationCellModel]()
        for changeDocument in documents {
            switch changeDocument.type {
            case .added:
                if let chatList = delegate {
                    if chatList.tableViewDataSource.data().contains(where: {$0.identifier == changeDocument.document.documentID}) {
                        update(changeDocument)
                    } else {
                        let data = changeDocument.document.data()
                        if let name = data["name"] as? String {
                            let lastMessage = data["lastMessage"] as? String
                            let lastActivity = (data["lastActivity"] as? Timestamp)?.dateValue()
                            channelsToSave.append(Channel(identifier: changeDocument.document.documentID, name: name, lastMessage: lastMessage, lastActivity: lastActivity))
                        }
                        
                    }
                    
                }
                
            case .modified:
                let data = changeDocument.document.data()
                if let name = data["name"] as? String {
                    let lastMessage = data["lastMessage"] as? String
                    let lastActivity = (data["lastActivity"] as? Timestamp)?.dateValue()
                    RootAssembly.serviceAssembly.coreData.updateChannel(
                        Channel(identifier: changeDocument.document.documentID,
                                name: name, lastMessage: lastMessage, lastActivity: lastActivity))
                    
                }
            case .removed:
                RootAssembly.serviceAssembly.coreData.deleteChannel(with: changeDocument.document.documentID)
                
            }
        }
        RootAssembly.serviceAssembly.coreData.save(channels: channelsToSave)
        
    }
    private func update(_ changeDocument: DocumentChange) {
        let data = changeDocument.document.data()
        if let name = data["name"] as? String {
            let lastMessage = data["lastMessage"] as? String
            let lastActivity = (data["lastActivity"] as? Timestamp)?.dateValue()
            RootAssembly.serviceAssembly.coreData.updateChannel(
                Channel(identifier: changeDocument.document.documentID,
                        name: name, lastMessage: lastMessage, lastActivity: lastActivity))
        }
        
    }
}
