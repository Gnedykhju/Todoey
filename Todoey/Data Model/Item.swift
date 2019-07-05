//
//  Item.swift
//  Todoey
//
//  Created by User on 04/07/2019.
//  Copyright © 2019 Yulia Gnedykh. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

