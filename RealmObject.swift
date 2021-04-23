//
//  RealmObject.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/09.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // 服の名前
    @objc dynamic var name : String = ""
    // 服の価格
    @objc dynamic var price : Int = 0
    // カテゴリー
    @objc dynamic var category : String!
    // サイズ
    @objc dynamic var size : String!
    // カラー
    @objc dynamic var color : String!
    // ブランド
    @objc dynamic var brand : String!
    // 詳細・コメント
    @objc dynamic var comment : String!
    // 登録ナンバー
    @objc dynamic var number: Int = 0
    
    var images = List<Images>()
    
}

class Images: Object {
    
    @objc dynamic var imageData : Data!
}
