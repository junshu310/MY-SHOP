//
//  SelectCategoryViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/10.
//

import UIKit

class SelectCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
        performSegue(withIdentifier: "toDetailCategory", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先の画面を取得
        let secVC: ToDetailCategoryViewController = (segue.destination as? ToDetailCategoryViewController)!
        
        secVC.getCell = chosenCell
    }

}
