//
//  Category.swift
//  
//
//  Todoey
//
//  Created by Ömer Yılmaz on 3.06.2024.

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
