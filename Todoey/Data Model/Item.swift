//
//  Item.swift
//  Todoey
//
//  Created by Hannie Kim on 7/28/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
