//
//  ConversationsListViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController, ThemesPickerDelegate {
    
    @IBOutlet var chatList: UITableView!
    
    @IBOutlet weak var profileView: UIView!
    var messages=[ConversationCellModel]()
    var groupedMessages=[(status:"Online",messages:[ConversationCellModel]()),(status:"History",messages:[ConversationCellModel]())]
    override func viewDidLoad() {
        createMessages()
        super.viewDidLoad()
        profileView.layer.cornerRadius=profileView.frame.height/2
        chatList.register(UINib(nibName: String(describing:ConversationViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing:ConversationViewCell.self))
        
        chatList.dataSource=self
        chatList.delegate=self
        setColors()
    }
    func applyTheme() {
        setColors()
        chatList.reloadData()
    }
    func setColors(){
        view.backgroundColor = ThemeManager.currentTheme().mainColor
        if #available(iOS 13.0, *) {
            let appearanceNavBar = UINavigationBarAppearance()
            appearanceNavBar.backgroundColor = ThemeManager.currentTheme().mainColor
            appearanceNavBar.titleTextAttributes = [.foregroundColor:ThemeManager.currentTheme().textColor]
            appearanceNavBar.largeTitleTextAttributes = [.foregroundColor:ThemeManager.currentTheme().textColor]
            navigationController?.navigationBar.standardAppearance = appearanceNavBar
            
            navigationController?.navigationBar.scrollEdgeAppearance = appearanceNavBar
            
            navigationController?.navigationBar.compactAppearance = appearanceNavBar
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().textColor
            navigationController?.navigationBar.backgroundColor = ThemeManager.currentTheme().mainColor
        }
        
    }
    
    // MARK: - Messages
    func createMessages(){
        
        messages.append(contentsOf: [
            ConversationCellModel(name: "Ben Afflec", message: "Привет как поживаешь бро?", date: Date(), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Огурчик Рик", message: "Я огурчик РИИИИК", date: Date.init("2020-07-06-16-22"), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Anna Kugels", message: "Я не очень поняла их идею", date: Date.init("2014-06-06-23-12"), isOnline: true, hasUnreadMessages: true),
            ConversationCellModel(name: "Соня Волчица" , message: "Отстань! Бесят уже мемы с волками", date: Date.init("2020-09-09-18-56"), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Гарик Мартирасян", message: "Сложноооо", date: Date.init("2020-09-16-10-13"), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Андрей Мостаченко", message: "Все вы знаете кто я. У меня даже твиттер есть", date: Date(), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Иван Корн", message: "", date: Date.init("2014-06-19-14-12"), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Катя Голикова", message: "Смотри какой мем нашла!", date: Date.init("2020-07-11-11-12"), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Борис Лялин", message: "Привет, тут есть одна идея для бизнесса", date: Date.init("2020-09-20-23-23"), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Тим Повар", message: "Вышла новая Кастрюля XS MAX PRO SE!!!", date: Date.init("2019-12-12-15-12"), isOnline: true, hasUnreadMessages: true),
            ConversationCellModel(name: "Олег Тинькофф", message: "Позвони мне, меня тут покупают!!", date: Date.init("2014-06-06-10-10"), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Рина Бан", message: "Тополь М не заказывали?", date: Date.init("2020-06-06-11-12"), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Полина Полина", message: "Кошки кошки кошки кооошки", date: Date.init("2019-09-22-22-22"), isOnline: true, hasUnreadMessages: true),
            ConversationCellModel(name: "Саня Соннов", message: "Стало скучно", date: Date.init("2020-09-20-13-33"), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Иван Иванов", message: "", date: Date.init("2020-07-07-22-22"), isOnline: true, hasUnreadMessages: false),
            ConversationCellModel(name: "Женя Егоров", message: "", date: Date.init("2020-06-06-11-12"), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Андрей Шан", message: "Привет, там учебка опять умерла", date: Date.init("2020-06-06-17-20"), isOnline: false, hasUnreadMessages: true),
            ConversationCellModel(name: "Тимур Омутов" , message: "Это сложно объяснить", date: Date.init("2020-09-05-13-12"), isOnline: false, hasUnreadMessages: false),
            ConversationCellModel(name: "Тимати Тимонов" , message: "ЕЕЕЕЕУУУУУУУ", date: Date.init("2014-06-06-23-12"), isOnline: true, hasUnreadMessages: true),
            ConversationCellModel(name: "Андрей Гарин" , message: "Устал", date: Date(), isOnline: true, hasUnreadMessages: true)])
        for item in messages{
            if item.isOnline{
                groupedMessages[0].messages.append(item)
            }else{
                if(!item.message.isEmpty){
                    groupedMessages[1].messages.append(item)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessages[section].messages.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        return groupedMessages[section].status
    }
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let item = groupedMessages[indexPath.section].messages[indexPath.row]
    //        if !item.isOnline&&item.message.isEmpty{
    //            return 0.0
    //        }
    //
    //        return super.tableView(tableView, heightForRowAt: indexPath)
    //    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = groupedMessages[indexPath.section].messages[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:ConversationViewCell.self), for: indexPath) as? ConversationViewCell{
            cell.configure(with: item)
            //            if !item.isOnline&&item.message.isEmpty{
            //                cell.isHidden = true
            //            } else{
            //                cell.isHidden=false
            //            }
            cell.applyTheme()
            return cell
        }
        return UITableViewCell()
        
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedChat = groupedMessages[indexPath.section].messages[indexPath.row]
        performSegue(withIdentifier: "toChat", sender: nil)
        
    }
    var selectedChat:ConversationCellModel!
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
extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
