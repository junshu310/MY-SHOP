//
//  EditCategoryViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/02/01.
//

import UIKit

class EditCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var category = ["トップス", "ジャケット/アウター","パンツ","スカート","ワンピース/ドレス","スーツ","シューズ","バッグ","キャップ", "アクセサリー","小物/ファッション雑貨","スポーツ関連","家具/インテリア","その他"]
    
    // 選択されたセルの番号を記憶
    var chosenCell: Int!
    
    @IBOutlet var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
    categoryTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = category[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // タップした後に選択状態が継続されないようにする
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 選択した項目に合わせて画面遷移
        chosenCell = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先の画面を取得
        let secVC: EditDetailCategoryViewController = (segue.destination as? EditDetailCategoryViewController)!
        
        secVC.getCell = chosenCell
    }
    
    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
