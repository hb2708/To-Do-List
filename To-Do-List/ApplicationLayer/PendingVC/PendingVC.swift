//
//  PendingVC.swift
//  To-Do-List
//
//  Created by Harshal on 8/19/17.
//  Copyright © 2017 Harshal. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class PendingVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // MARK:- IBOutlet Declaration
    
    @IBOutlet var tableView: UITableView!
    
    // MARK:- Variable Declaration
    
    let realm = try! Realm()
    let pendingTasks = try! Realm().objects(Task.self).filter("completed == false")
    var notificationToken: NotificationToken?
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationToken = pendingTasks.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.tableFooterView = UIView ()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.visibleViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddToDo))
        self.navigationController?.visibleViewController?.navigationItem.title = "Pending"
    }
    
    // MARK:- UITableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingCell")
        let lblTaskText = cell?.viewWithTag(1) as! UILabel
        let lblTaskDate = cell?.viewWithTag(2) as! UILabel
        lblTaskText.text = pendingTasks[indexPath.row].text
        lblTaskDate.text = pendingTasks[indexPath.row].date!.timeAgoSinceDate(numericDates: true)
        cell?.separatorInset = .zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = pendingTasks[indexPath.row]
        try! realm.write {
            task.completed = true
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let task = pendingTasks[indexPath.row]
            try! realm.write {
                realm.delete(task)
            }
        }
    }
    
    // MARK:- DZNEmpty Delegate and DataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let strTitle = "No Pending tasks"
        
        let attributes = [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular" , size: 16.0)! ]
        
        let attributetTitle = NSAttributedString(string: strTitle, attributes: attributes)
        
        return attributetTitle
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let strTitle = "Please add some tasks by tapping (+) from top right corner"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        
        let attributes = [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular" , size: 12.0)!,NSParagraphStyleAttributeName:paragraph ]
        
        let attributetTitle = NSAttributedString(string: strTitle, attributes: attributes)
        
        return attributetTitle
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -20
    }
    
    // MARK:- User Defined Functions

    func showAddToDo() {
        //show add ToDo Popup
        self.performSegue(withIdentifier: "addToDo", sender: self)
    }
}
