//
//  SelectColorViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/09.
//

import UIKit

class SelectColorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var colorArray = ["ホワイト系", "ブラック系","グレー系","ピンク系","レッド系","オレンジ系","ブラウン・ベージュ系","イエロー系", "グリーン系","ネイビー・ブルー系","パープル系","その他"]
    
    var backgroundColors = [UIColor.white, UIColor.black, UIColor.gray, UIColor.systemPink, UIColor.red, UIColor.orange, UIColor.brown, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.lightGray]
    
    @IBOutlet var colorTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        colorTableView.delegate = self
        colorTableView.dataSource = self
        colorTableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.backgroundColor = backgroundColors[indexPath.row]
        let cellLabel = cell.contentView.viewWithTag(2) as! UILabel
        cellLabel.text = colorArray[indexPath.row]
        
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 前の画面へ値渡し
        let perNC = self.navigationController!
        let perVC = perNC.viewControllers[perNC.viewControllers.count - 2] as! PostClothesViewController
        // 値渡し
        perVC.selectedColor = colorArray[indexPath.row]
        // 閉じる
        self.navigationController?.popViewController(animated: true)
                
    }
    
}
