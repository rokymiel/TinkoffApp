//
//  ConversationsListViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class ConversationsListViewController: UITableViewController, ThemesPickerDelegate, NSFetchedResultsControllerDelegate, ChatListDelegate {
    
    @IBOutlet var chatList: UITableView!
    @IBOutlet weak var profileView: UIView!
    var chatListModel: ChatListProtocol!
    lazy var tableViewDataSource: TableViewDataSource<Channel_db> = {
        let sort = NSSortDescriptor(key: "lastActivity", ascending: false)
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        request.sortDescriptors = [sort]
        let fetchedResultsController = RootAssembly.serviceAssembly.coreData.getFetchedResultsController(fetchRequest: request)
        fetchedResultsController.delegate = self
        let source = TableViewDataSource<Channel_db>(fetchedResultsController: fetchedResultsController) { [weak self] item, indexPath in
            if let cell = self?.tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationViewCell.self), for: indexPath) as? ConversationViewCell {
                cell.configure(with: item)
                cell.applyTheme()
                return cell
            }
            return UITableViewCell()
        }
        return source
    }()
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    var selectedChat: Channel_db!
    var channels=[Channel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListModel = ChatList(delegate: self)
        profileView.layer.cornerRadius = profileView.frame.height / 2
        chatList.register(UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationViewCell.self))
        
        chatList.dataSource = tableViewDataSource
        chatList.delegate = self
        setColors()
    }
    
    func applyTheme() {
        setColors()
        chatList.reloadData()
    }
    func setColors() {
        view.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        if #available(iOS 13.0, *) {
            let appearanceNavBar = UINavigationBarAppearance()
            appearanceNavBar.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
            appearanceNavBar.titleTextAttributes = [.foregroundColor: RootAssembly.serviceAssembly.theme.currentTheme().textColor]
            appearanceNavBar.largeTitleTextAttributes = [.foregroundColor: RootAssembly.serviceAssembly.theme.currentTheme().textColor]
            navigationController?.navigationBar.standardAppearance = appearanceNavBar
            
            navigationController?.navigationBar.scrollEdgeAppearance = appearanceNavBar
            
            navigationController?.navigationBar.compactAppearance = appearanceNavBar
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor
            navigationController?.navigationBar.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
        }
        
    }
    // MARK: - Channels

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
            chatListModel.createNewChennel(with: name)
            
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Введите название нового канала", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndex = newIndexPath {
                chatList.insertRows(at: [newIndex], with: .fade)
            }
        case .move:
            if let index = indexPath, let newIndex = newIndexPath {
                chatList.deleteRows(at: [index], with: .fade)
                chatList.insertRows(at: [newIndex], with: .fade)
            }
        case .update:
            if let index = indexPath {
                chatList.reloadRows(at: [index], with: .fade)
                
            }
        case .delete:
            if let index = indexPath {
                chatList.deleteRows(at: [index], with: .fade)
            }
            
        @unknown default:
            fatalError()
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.chatList.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.chatList.endUpdates()
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedChat = tableViewDataSource.getItem(by: indexPath.row)
        performSegue(withIdentifier: "toChat", sender: nil)
        
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            let commit = self.tableViewDataSource.fetchedResultsController.object(at: indexPath)
            
            RootAssembly.serviceAssembly.coreData.deleteChannel(commit)
            if let id = commit.identifier {
                self.reference.document(id).delete()
            }
            
            success(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
