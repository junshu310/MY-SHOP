//
//  ColorMenuViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/02/08.
//

import UIKit

// グローバル変数（全てで対応）
var isCheckKeyWordColor = false
var keyWordColor: String!

class ColorMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var colorTableView: UITableView!
    
    var colorArray = ["ホワイト系", "ブラック系","グレー系","ピンク系","レッド系","オレンジ系","ブラウン・ベージュ系","イエロー系", "グリーン系","ネイビー・ブルー系","パープル系","その他"]
    
    var backgroundColors = [UIColor.white, UIColor.black, UIColor.gray, UIColor.systemPink, UIColor.red, UIColor.orange, UIColor.brown, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.lightGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorTableView.delegate = self
        colorTableView.dataSource = self
        colorTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.backgroundColor = backgroundColors[indexPath.row]
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.backgroundColor = backgroundColors[indexPath.row]
        let cellLabel = cell.contentView.viewWithTag(2) as! UILabel
        cellLabel.text = colorArray[indexPath.row]
        
        return cell
    }
    // 押された時に検索
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isCheckKeyWordColor = true
        keyWordColor = colorArray[indexPath.row]
        print(keyWordColor)
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
