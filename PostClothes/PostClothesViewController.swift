//
//  PostClothesViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/09.
//

import UIKit
import RealmSwift
import NYXImagesKit
import DKImagePickerController
import UITextView_Placeholder

class PostClothesViewController: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate,UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var resizedImage: UIImage!
    
    @IBOutlet var postImageCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()

    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var sizeTextField: UITextField!
    @IBOutlet var colorTextField: UITextField!
    @IBOutlet var brandTextField: UITextField!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var postButton: UIButton!
    
    var selectedCategory: String!
    
    var selectedSize: String!
    
    var selectedColor: String!
    
    var selectedBrand: String!
    
    // Realm用に配列の宣言
    var clothesArray = [Item]()
    var numberArray = [Int]()
    var maxNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        commentTextView.delegate = self
        nameTextField.delegate = self
        priceTextField.delegate = self
        categoryTextField.delegate = self
        sizeTextField.delegate = self
        colorTextField.delegate = self
        brandTextField.delegate = self
        
        // postImageCollectionViewのレイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        postImageCollectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal

        // キーボードを数字のみにする
        priceTextField.keyboardType = UIKeyboardType.numberPad
        
        commentTextView.placeholder = "（例） ○○年 ○月 ○日に購入\n　　　パンツ等のサイズ［W30／L32］"
        commentTextView.placeholderColor = UIColor.lightGray
        
        postButton.layer.cornerRadius = 10
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        
        loadNumber()
        
        categoryTextField.text = selectedCategory
        sizeTextField.text = selectedSize
        colorTextField.text = selectedColor
        brandTextField.text = selectedBrand
        
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
            textView.resignFirstResponder()
    }
    
    
    @IBAction func selectImage(_ sender: Any) {
        // "画像を選択" or "写真を撮る"のアラートコントローラーを出す
        let alertController = UIAlertController(title: "イメージを選択", message: nil, preferredStyle: .actionSheet)

        // 画像を選択のアクション
        let selectImageAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = DKImagePickerController()
                // 選択できる写真の最大枚数を指定
                picker.maxSelectableCount = 10
                // カメラモード、写真モードの選択
                picker.sourceType = .photo
                // キャンセルボタンの有効
                picker.showsCancelButton = true
                // UIのカスタマイズ
                picker.UIDelegate = CustomUIDelegate()
                
                // 選択された画像はassetsに入れて返却されるのでfetchして取り出す
        
                picker.didSelectAssets = {[unowned self] (assets: [DKAsset]) in
                    imageArray = []
                    for asset in assets {
                        asset.fetchFullScreenImage(completeBlock: { (image, info) in
                            // ここで取り出せる
                            resizedImage = image?.scale(byFactor: 0.7)
                            self.imageArray.append(resizedImage)
                            
                        })
                    }
                    // 画像が重くて読み込めないため、動作を遅延させる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.postImageCollectionView.reloadData()
                        
                    }
                    imageArray = []
                }
                
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種では使用できません")
            }
        }
        // 写真を撮るアクション
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種では使用できません")
            }
        }
        // キャンセルアクション
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(cameraAction)
        alertController.addAction(selectImageAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // postImageCollectionViewCellの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    // postImageCollectionVIewCellの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        // tagを使ってimageViewのインスタンス生成
        let photoImageView = cell.contentView.viewWithTag(1) as! UIImageView
        photoImageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    // collectionViewのセルの大きさを調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 4 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    // nameTextFieldの設定
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        
        return true
    }
    
    
    // priceTextFieldのキーボードの完了を押した時の処理
    @objc func priceDone(_sender: UIButton) {
    priceTextField.resignFirstResponder()

    }
    
    // textField, textViewの設定
    // 入力画面または、キーボード以外の場所を押したら、キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.commentTextView.isFirstResponder) {
            self.commentTextView.resignFirstResponder()
        }; if (self.priceTextField.isFirstResponder) {
            self.priceTextField.resignFirstResponder()
        }; if (self.nameTextField.isFirstResponder) {
            self.nameTextField.resignFirstResponder()
        }
    }
    
    // キャンセルボタン
    @IBAction func cancel() {
        let alert = UIAlertController(title: "確認", message: "登録が完了していません。\n入力中の情報は保存されません。よろしいですか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // データをrealmで保存して投稿
    @IBAction func postClothes() {
        // 入力情報が不十分の時、アラートを出す
        if imageArray.count == 0 || nameTextField.text == nil || nameTextField.text?.isEmpty == true ||  priceTextField.text == nil  || priceTextField.text?.isEmpty == true || categoryTextField.text == nil || sizeTextField.text == nil || colorTextField.text == nil || brandTextField.text == nil || brandTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "注意！", message: "入力情報が不十分です。\n'メモ・商品情報'欄以外は情報を入力して下さい。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // realmの宣言
            let realm = try! Realm()
            let clothes = Item()
            // imageArrayを１つずつ取り出す
            for i in imageArray {
                // 使うオブジェクトを宣言
                let image = Images()
                image.imageData = i.pngData()
                clothes.images.append(image)
            }
            
            
            // データを保存する
            clothes.name = nameTextField.text!
            clothes.price = Int(priceTextField.text!)!
            clothes.category = categoryTextField.text
            clothes.size = sizeTextField.text
            clothes.color = colorTextField.text
            clothes.brand = brandTextField.text
            // nillの時""が表示される
            clothes.comment = commentTextView.text ?? ""
            // 登録したものにnumberをつける（降順、昇順の並び替えのため）→ 登録されているnumberの最大値 + 1
            // numberを取り出して、配列に入れる → 配列の中から最大値を取り出す → それにプラス１する
            if numberArray == [] {
                maxNumber = 0
            } else {
                maxNumber = numberArray.max()
            }
            clothes.number = maxNumber + 1
            
            try! realm.write{
                // Itemにデータを追加（保存）します。
                realm.add(clothes)
                
            }
            
            loadTimeLine()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // Realm読み込み
    func loadTimeLine() {
        let realm = try! Realm()
        let results = realm.objects(Item.self)
        clothesArray = [Item]()
        for result in results {
            clothesArray.append(result)
        }
    }
    func loadNumber() {
        loadTimeLine()
        let realm = try! Realm()
        let number = realm.objects(Item.self).value(forKey: "number")
        numberArray = [Int]()
        numberArray = number as! [Int]
    }
}
