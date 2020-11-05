//
//  TableViewDataSource.swift
//  TinkoffApp
//
//  Created by Михаил on 03.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import CoreData
class TableViewDataSource<T: NSManagedObject>: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = fetchedResultsController.fetchedObjects else { return 0 }
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data()[indexPath.row]
        return configure(item, indexPath)
    }
    init(fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, configuerCell: @escaping (T, _ indexPath: IndexPath ) -> UITableViewCell) {
        self.fetchedResultsController = fetchedResultsController
        self.configure = configuerCell
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
    }
    private var configure: (T, _ indexPath: IndexPath ) -> UITableViewCell
    func data() -> [T] {
        return fetchedResultsController.fetchedObjects as? [T] ?? []
    }
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    public func getItem(by index: Int) -> T {
        return data()[index]
    }
}
