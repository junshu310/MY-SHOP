//
//  MenuViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/31.
//

import UIKit
import RealmSwift

var isCheckKeyWordBrand = false
var keyWordBrand: String!

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clothesArray = [Item]()
    var optionArray = ["カテゴリー", "カラー"]
    var brandArray = [String]()
    var orderSetsArray = [String]()
    var receivedKeyword: String!

    @IBOutlet var button: UIButton!
    @IBOutlet var button2: UIButton!
    
    var chosenCell: Int!
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var brandTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTimeLine()
        loadBrand()

        menuTableView.tableFooterView = UIView()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.rowHeight = 43.5
        menuTableView.isScrollEnabled = false
        
        brandTableView.tableFooterView = UIView()
        brandTableView.delegate = self
        brandTableView.dataSource = self
        brandTableView.rowHeight = 43.5
        
        // Realmに登録されたブランドを代入する（同じものを省く）
        orderSetsArray = brandArray
        let orderSets = NSOrderedSet(array: orderSetsArray)
        orderSetsArray = orderSets.array as! [String]
        
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0.5
        button2.layer.borderColor = UIColor.gray.cgColor
        button2.layer.borderWidth = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        // メニューの位置を取得する
        let menuPos = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = -self.menuView.frame.width
        // 表示字のアニメーションを作成
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { self.menuView.layer.position.x = menuPos.x}, completion: {bool in })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    // メニューエリア以外をタップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if receivedKeyword == "全てを表示" {
            isCheckKeyWordCategory = false
            isCheckKeyWordColor = false
            isCheckKeyWordBrand = false
        } else if receivedKeyword == keyWordCategory {
            isCheckKeyWordCategory = true
        } else if receivedKeyword == keyWordColor {
            isCheckKeyWordColor = true
        } else if receivedKeyword == keyWordBrand {
            isCheckKeyWordBrand = true
        }
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {self.menuView.layer.position.x = -self.menuView.frame.width}, completion: {bool in self.dismiss(animated: true, completion: nil)})
            }
        }
    }
    
    @IBAction func back() {
        if receivedKeyword == "全てを表示" {
            isCheckKeyWordCategory = false
            isCheckKeyWordColor = false
            isCheckKeyWordBrand = false
        } else if receivedKeyword == keyWordCategory {
            isCheckKeyWordCategory = true
        } else if receivedKeyword == keyWordColor {
            isCheckKeyWordColor = true
        } else if receivedKeyword == keyWordBrand {
            isCheckKeyWordBrand = true
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {self.menuView.layer.position.x = -self.menuView.frame.width}, completion: {bool in self.dismiss(animated: true, completion: nil)})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.menuTableView {
            return optionArray.count
        } else {
            return orderSetsArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.menuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = optionArray[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell")!
            cell.textLabel?.text = orderSetsArray[indexPath.row]
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.menuTableView {
            chosenCell = indexPath.row
            if chosenCell == 0 {
                performSegue(withIdentifier: "toCategory", sender: nil)
            }; if chosenCell == 1 {
                performSegue(withIdentifier: "toColor", sender: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            // ToDo 選択されたブランドに応じて検索
            
            isCheckKeyWordBrand = true
            keyWordBrand = orderSetsArray[indexPath.row]
            
            tableView.deselectRow(at: indexPath, animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategory" {
            let categoryVC = segue.destination as! CategoryMenuViewController
        }; if segue.identifier == "toColor" {
            let colorVC = segue.destination as! ColorMenuViewController
        }
    }
    
    // 全て表示のボタン
    @IBAction func allSelect() {
        isCheckKeyWordCategory = false
        isCheckKeyWordColor = false
        isCheckKeyWordBrand = false
        
        // 画面を閉じる
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {self.menuView.layer.position.x = -self.menuView.frame.width}, completion: {bool in self.dismiss(animated: true, completion: nil)})
    }
    
    // Realm読み込み
    func loadTimeLine() {
        // Realmを使用する宣言
        let realm = try! Realm()
        // どのオブジェクトを使用するかの宣言
        let results = realm.objects(Item.self)
        // 配列を初期化する（2回目以降二重で保存するのを防ぐため）
        clothesArray = [Item]()
        // For if文を使って、resultの内容をclothesArrayに入れる
        // 配列に入れることで使いやすくなる
        for result in results {
            clothesArray.append(result)
        }
    }
    func loadBrand() {
        let realm = try! Realm()
        let brand = realm.objects(Item.self).value(forKey: "brand")
        brandArray = [String]()
        brandArray = brand as! [String]
    }
}
