//
//  DetailClothesViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/26.
//

import UIKit
import RealmSwift

class DetailClothesViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var clothesCollectionView: UICollectionView!

    // timelineからの受け皿
    var receivedArray = [Item]()
//    var receivedIndexPath: Int!
    var receivedKeyword: String!
    var selectedId: Int!
    
    // 更新完了時に値を受け取る受け皿
    var updataImageArray = [UIImage]()
    var updataName: String!
    var updataPrice: Int!
    var updataCategory: String!
    var updataSize: String!
    var updataColor: String!
    var updataBrand: String!
    var updataComment: String!
    
    
    @IBOutlet var receivedNameLabel: UILabel!
    @IBOutlet var receivedPriceLabel: UILabel!
    @IBOutlet var receivedCategoryLabel: UILabel!
    @IBOutlet var receivedSizeLabel: UILabel!
    @IBOutlet var receivedColorLabel: UILabel!
    @IBOutlet var receivedBrandLabel: UILabel!
    @IBOutlet var receivedCommentTextView: UITextView!
    
    // imageArrayにimageをappendしたい
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // postImageCollectionViewのレイアウトを調整
        var layout = UICollectionViewFlowLayout()
        clothesCollectionView.collectionViewLayout = layout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = clothesCollectionView.bounds.height
        layout.minimumLineSpacing = 0

        
        receivedCommentTextView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        
        if updataImageArray != [] {
            for i in updataImageArray {
//                let image: UIImage = UIImage(data: i.imageData!)!
                imageArray.append(i)
            }
        } else {
            for i in receivedArray[0].images {
                let image: UIImage = UIImage(data: i.imageData)!
                imageArray.append(image)
            }
        }
        
        // 受け取った情報をラベルに表示させる
//        for i in receivedArray[0].images {
//            let image: UIImage = UIImage(data: i.imageData)!
//            imageArray.append(image)
//        }
        receivedNameLabel.text = receivedArray[0].name
        receivedPriceLabel.text = String(receivedArray[0].price)
        receivedCategoryLabel.text = receivedArray[0].category
        receivedSizeLabel.text = receivedArray[0].size
        receivedColorLabel.text = receivedArray[0].color
        receivedBrandLabel.text = receivedArray[0].brand
        receivedCommentTextView.text = receivedArray[0].comment
        cmNumber()
        
//        clothesCollectionView.delegate = self
//        clothesCollectionView.dataSource = self
        
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
        
        selectedId = receivedArray[0].number
        
        clothesCollectionView.delegate = self
        clothesCollectionView.dataSource = self
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let cellImageView = cell.contentView.viewWithTag(1) as! UIImageView
        // ここのimageViewに受け取った画像を入れたい
        cellImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    // collectionViewのセルの大きさを調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 0
        let cellSize : CGFloat = self.view.bounds.width / 1 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }

    func cmNumber() {
        // 通貨単位をつける
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ja_JP")
        // UILabelにセット
        receivedPriceLabel.text = formatter.string(from: NSNumber(value: Int(receivedPriceLabel.text!)!))
    }
    
    
    // 前の画面に値渡し（キーワード）
    @IBAction func back() {
        let preNC = self.presentingViewController as! UINavigationController
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! ViewController
        preVC.receivedArray = receivedKeyword
    }
    
    // 編集・削除のアラートコントローラー
    @IBAction func editmenu() {
        let alertController = UIAlertController(title: "メニュー", message: nil, preferredStyle: .actionSheet)
//
//        // 編集のアクション
        let editAction = UIAlertAction(title: "編集", style: .default) { (action) in
            // ToDo postと同じ画面を表示（登録したデータを継承した状態で or 画面を編集可能にする）
            // 編集へ画面遷移
            self.performSegue(withIdentifier: "toDetail", sender: nil)
        }
        let deleteAction = UIAlertAction(title: "削除", style: .default) { (action) in
            // ToDo 削除確認のアラートを出す
            let alert = UIAlertController(title: "確認", message: "一度削除するとデータを復元することはできません。\n本当に削除しますか？", preferredStyle: .alert)
            // ToDo（ここから始める）アラートアクション
            let okAction = UIAlertAction(title: "はい", style: .default) { [self] (action) in
                //　ToDo 登録したデータを削除
                // 登録したデータを取得
                let realm = try! Realm()
                let results = realm.objects(Item.self).filter("number == %@", selectedId!)
                // データの削除
                try! realm.write {
                    realm.delete(results[0])
                }
                // 画面を閉じる
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "いいえ", style: .cancel) { (action) in
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! EditClothesViewController

            
            detailVC.selectedArray = receivedArray
            
            detailVC.selectedData = selectedId
            
//            var priceString = ""
//
//            let priceText = receivedPriceLabel.text?.components(separatedBy: CharacterSet(charactersIn: "¥,"))
////            print(priceText)
//            for i in 1...priceText!.count - 1 {
//                priceString = priceString + priceText![i]
//            }
//
//            // 登録情報をeditに継承
//            detailVC.selectedIndexPath = receivedIndexPath
//            // imageArrayに受け取った画像が入ってて
//            detailVC.selectedImageArray = imageArray
//            detailVC.selectedName = receivedNameLabel.text
//            detailVC.selectedPrice = priceString
//            detailVC.selectedCategory = receivedCategoryLabel.text
//            detailVC.selectedColor = receivedColorLabel.text
//            detailVC.selectedSize = receivedSizeLabel.text
//            detailVC.selectedBrand = receivedBrandLabel.text
//            detailVC.selectedComment = receivedCommentTextView.text
        }
    }
}
