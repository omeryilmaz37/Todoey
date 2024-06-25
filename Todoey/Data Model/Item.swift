//
//  Item.swift
//
//  Todoey
//
//  Created by Ömer Yılmaz on 1.06.2024.
//

import Foundation   // Foundation framework'ünü içe aktarıyor
import RealmSwift   // RealmSwift framework'ünü içe aktarıyor

class Item: Object {  // 'Item' adında bir sınıf tanımlıyor, bu sınıf Realm'in 'Object' sınıfından türetiliyor
    @objc dynamic var title: String = ""  // 'title' adında bir string değişken tanımlıyor ve başlangıç değeri boş string
    @objc dynamic var done: Bool = false  // 'done' adında bir boolean değişken tanımlıyor ve başlangıç değeri false
    @objc dynamic var dateCreated: Date?  // 'dateCreated' adında opsiyonel bir tarih değişkeni tanımlıyor
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  // 'parentCategory' adında, bu öğenin hangi kategoriye ait olduğunu belirten bir ilişki tanımlıyor
}
