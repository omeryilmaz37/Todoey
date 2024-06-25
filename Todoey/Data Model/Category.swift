//
//  Category.swift
//
//  Todoey
//
//  Created by Ömer Yılmaz on 3.06.2024.

import Foundation   // Foundation framework'ünü içe aktarıyor
import RealmSwift   // RealmSwift framework'ünü içe aktarıyor

class Category: Object {  // 'Category' adında bir sınıf tanımlıyor, bu sınıf Realm'in 'Object' sınıfından türetiliyor
    @objc dynamic var name: String = ""  // 'name' adında bir string değişken tanımlıyor ve başlangıç değeri boş string
    @objc dynamic var colour: String = ""  // 'colour' adında bir string değişken tanımlıyor ve başlangıç değeri boş string
    let items = List<Item>()  // 'items' adında, 'Item' türünde öğeleri saklayan bir liste tanımlıyor
}
