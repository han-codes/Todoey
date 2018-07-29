//
//  Category.swift
//  Todoey
//
//  Created by Hannie Kim on 7/28/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // make a relationship. Array of Items
    let items = List<Item>()
}
