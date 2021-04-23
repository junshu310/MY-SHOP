//
//  CategoryMenuViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/31.
//

import UIKit

class CategoryMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var detailTableView: UITableView!

    var category = ["トップス", "ジャケット/アウター","パンツ","スカート","ワンピース/ドレス","スーツ","シューズ","バッグ","キャップ", "アクセサリー","小物/ファッション雑貨","スポーツ関連","家具/インテリア","その他"]
    
    
    var chosenCell: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTableView.tableFooterView = UIView()
        
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        // 選択されたセルによって中身を変える
        cell.textLabel?.text = category[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移
        chosenCell = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secVC: Category2MenuViewController = (segue.destination as? Category2MenuViewController)!
        secVC.categoryGetCell = chosenCell
    }
    
    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
