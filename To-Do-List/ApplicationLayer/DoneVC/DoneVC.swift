//
//  DoneVC.swift
//  To-Do-List
//
//  Created by Harshal on 8/19/17.
//  Copyright © 2017 Harshal. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class DoneVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // MARK:- IBOutlet Declaration
    
    @IBOutlet var tableView: UITableView!
    
    // MARK:- Variable Declaration
    
    let realm = try! Realm()
    let doneTasks = try! Realm().objects(Task.self).filter("completed == true")
    var notificationToken: NotificationToken?
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.notificationToken = doneTasks.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let err):
                fatalError("\(err)")
            }
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.tableFooterView = UIView ()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.visibleViewController?.navigationItem.rightBarButtonItem = nil
        self.navigationController?.visibleViewController?.navigationItem.title = "Done"
    }
    
    // MARK:- UITableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell")
        let lblTaskText = cell?.viewWithTag(1) as! UILabel
        let lblTaskDate = cell?.viewWithTag(2) as! UILabel
        lblTaskText.text = doneTasks[indexPath.row].text
        lblTaskDate.text = doneTasks[indexPath.row].date?.timeAgoSinceDate(numericDates: true)
        cell?.separatorInset = .zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = doneTasks[indexPath.row]
        try! realm.write {
            task.completed = false
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let task = doneTasks[indexPath.row]
            try! realm.write {
                realm.delete(task)
            }
        }
    }
    
    // MARK:- DZNEmpty Delegate and DataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let strTitle = "No Completed tasks"
        
        let attributes = [NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular" , size: 16.0)! ]
        
        let attributetTitle = NSAttributedString(string: strTitle, attributes: attributes)
        
        return attributetTitle
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let strTitle = "Please complete some tasks from the Pending Tab"
        
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
}
