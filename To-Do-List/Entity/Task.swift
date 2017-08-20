//
//  Task.swift
//  To-Do-List
//
//  Created by Harshal on 8/20/17.
//  Copyright © 2017 Harshal. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    dynamic var text = ""
    dynamic var date: Date?
    dynamic var completed = false
}
