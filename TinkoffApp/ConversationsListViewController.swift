//
//  ConversationsListViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase
class ConversationsListViewController: UITableViewController, ThemesPickerDelegate {
    
    @IBOutlet var chatList: UITableView!
    
    @IBOutlet weak var profileView: UIView!
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    var selectedChat: Channel!
    var channels=[Channel]()
    override func viewDidLoad() {
        //createMessages()
        
        super.viewDidLoad()
        reference.addSnapshotListener {[weak self] snapchot, _ in
            if let shot = snapchot {
                self?.getMessages(shot.documents)
                self?.chatList.reloadData()
            }
        }
        profileView.layer.cornerRadius = profileView.frame.height / 2
        chatList.register(UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationViewCell.self))
        
        chatList.dataSource = self
        chatList.delegate = self
        setColors()
    }
    
    func applyTheme() {
        setColors()
        chatList.reloadData()
    }
    func setColors() {
        view.backgroundColor = ThemeManager.currentTheme().mainColor
        if #available(iOS 13.0, *) {
            let appearanceNavBar = UINavigationBarAppearance()
            appearanceNavBar.backgroundColor = ThemeManager.currentTheme().mainColor
            appearanceNavBar.titleTextAttributes = [.foregroundColor: ThemeManager.currentTheme().textColor]
            appearanceNavBar.largeTitleTextAttributes = [.foregroundColor: ThemeManager.currentTheme().textColor]
            navigationController?.navigationBar.standardAppearance = appearanceNavBar
            
            navigationController?.navigationBar.scrollEdgeAppearance = appearanceNavBar
            
            navigationController?.navigationBar.compactAppearance = appearanceNavBar
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().textColor
            navigationController?.navigationBar.backgroundColor = ThemeManager.currentTheme().mainColor
        }
        
    }
    // MARK: - Channels
    func getMessages(_ documents: [QueryDocumentSnapshot]) {
        channels=[Channel]()
        for document in documents {
            let data = document.data()
            if let name = data["name"] as? String {
                let lastMessage = data["lastMessage"] as? String
                let lastActivity = (data["lastActivity"] as? Timestamp)?.dateValue()
                channels.append(Channel(identifier: document.documentID, name: name, lastMessage: lastMessage, lastActivity: lastActivity))
            }
        }
        CoreDataManager.save(channels: channels)
        
    }
    var coreDataStack = CoreDataStack()
    @IBAction func addNewChennel(_ sender: Any) {
        let alert = UIAlertController(title: "Новый канал", message: "Введите название нового канала", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Создать", style: .default) {[weak alert]_ in
            
            self.createNewChennel(with: alert?.textFields?[0].text)
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) {_ in
            
        })
        present(alert, animated: true, completion: nil)
    }
    func createNewChennel(with newChennelName: String?) {
        if let name = newChennelName, !name.isEmpty {
            reference.addDocument(data: ["name": name])
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Введите название нового канала", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = channels[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationViewCell.self), for: indexPath) as? ConversationViewCell {
            cell.configure(with: item)
            cell.applyTheme()
            return cell
        }
        return UITableViewCell()
        
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedChat = channels[indexPath.row]
        performSegue(withIdentifier: "toChat", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConversationViewController {
            destination.conversation = selectedChat
        }
        if let destination = segue.destination as? ThemesViewController {
            destination.themeDelegate = self
            destination.themeHandler = {
                [weak self] in
                self?.setColors()
                self?.chatList.reloadData()
                
            }
        }
    }
}
// MARK: - Date extension
extension Date {
    init(_ dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: date)
    }
}
