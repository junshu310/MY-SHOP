//
//  EditSizeViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/02/01.
//

import UIKit

class EditSizeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sizeArray = ["XXS以下","XS(SS)","S","M","L","XL","2XL(3L)","3XL(4L)","4XL(5L)以上","FREE SIZE"]
    
    @IBOutlet var sizeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sizeTableView.tableFooterView = UIView()
        
        sizeTableView.delegate = self
        sizeTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizeArray.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = sizeArray[indexPath.row]
            
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルが選択された時に前の画面に画面遷移
        // 呼び出し元のviewControllerを遷移履歴から取得しパラメータを渡す
        let perVC = self.presentingViewController as! EditClothesViewController
        // 値渡し
        perVC.selectedSize = self.sizeArray[indexPath.row]
        // 閉じる
        self.dismiss(animated: true, completion: nil)

    }
    
    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
