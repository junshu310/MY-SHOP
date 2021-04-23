//
//  EditBrandViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/02/01.
//

import UIKit
import RealmSwift

class EditBrandViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var brandTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var clothesArray = [Item]()
    var brandArray = [String]()
    var searchResult = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTimeLine()
        loadBrand()

        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchResult = brandArray
        let orderedSets = NSOrderedSet(array: searchResult)
        searchResult = orderedSets.array as! [String]
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        

        brandTableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = searchResult[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let perNC = self.navigationController!
        let perVC = self.presentingViewController as! EditClothesViewController
        // 値渡し
        perVC.selectedBrand = self.searchResult[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        // 閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        // 検索結果を空にする
        searchResult.removeAll()
        if searchBar.text == "" {
            searchResult = brandArray
        } else {
            for data in brandArray {
                if data.contains(searchBar.text!) {
                    searchResult.append(data)
                }
            }
        }
        brandTableView.reloadData()
    }


        
    // ブランドを登録して、前の画面に画面遷移
    @IBAction func registerBrand() {
        let perVC = self.presentingViewController as! EditClothesViewController
        // 値渡し
        perVC.selectedBrand = self.searchBar.text
        // 閉じる
        self.dismiss(animated: true, completion: nil)

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
    
    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
