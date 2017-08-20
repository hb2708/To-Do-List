//
//  AddToDoVC.swift
//  To-Do-List
//
//  Created by Harshal on 8/20/17.
//  Copyright © 2017 Harshal. All rights reserved.
//

import UIKit
import RealmSwift

class AddToDoVC: UIViewController {

    // MARK:- IBOutlet Declaration
    
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var toDoTextView: UITextView!
    
    // MARK:- IBAction Declaration
    
    @IBAction func addTouched(_ sender: Any) {
        if !toDoTextView.text.isEmpty {
            let task = Task()
            task.date = Date()
            task.text = toDoTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            try! realm.write {
                realm.add(task)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Ooops!!!", message: "Please enter text to save task", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Variable Declaration
    
    let realm = try! Realm()
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Code to setup the popup appearence
        popupContainer.layer.cornerRadius = 5
        popupContainer.layer.masksToBounds = true
        popupContainer.layer.borderColor = themeColor.cgColor
        popupContainer.layer.borderWidth = 2.0
    
    }
}
