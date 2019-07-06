//
//  Category.swift
//  Todoey
//
//  Created by User on 04/07/2019.
//  Copyright © 2019 Yulia Gnedykh. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
}
