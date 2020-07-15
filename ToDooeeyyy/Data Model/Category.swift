//
//  Category.swift
//  ToDooeeyyy
//
//  Created by Jinisha Savani on 8/21/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = " "
    @objc dynamic var colour : String = " "
    let items = List<Item>()
}
