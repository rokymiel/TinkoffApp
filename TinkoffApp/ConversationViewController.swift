//
//  ConversationViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var messageBar: UIToolbar!
    @IBOutlet weak var chatView: UITableView!
    var conversation:ConversationCellModel!
    var messages=[Message(message: "Привет как дела?", type: .output),Message(message: "Как жизнь? Есть что нового? Вот у меня например за этот месяц столько всего произошло, что ты даже не поверишь", type: .output),Message(message: "Привет, все супер. Но при этом скучно и ничего нового", type: .input),Message(message: "Почему?", type: .output),Message(message: "Это плохо, я считаю", type: .output)]
    override func viewDidLoad() {
        super.viewDidLoad()
        title=conversation.name
        chatView.register(UINib(nibName: String(describing: ChatViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChatViewCell.self))
        chatView.dataSource=self
        setColors()
    }
    func setColors(){
        chatView.backgroundColor=ThemeManager.currentTheme().mainColor
        messageBar.barTintColor = ThemeManager.currentTheme().mainColor
    
    }
}
// MARK: - Table View Data
extension ConversationViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatViewCell.self), for: indexPath) as? ChatViewCell{
            cell.messageType=messages[indexPath.row].type
            cell.configure(with: .init(message: messages[indexPath.row].message))
            return cell
        }
        return UITableViewCell()
    }
    
    
}
