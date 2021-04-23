//
//  EditClothesViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/31.
//

import UIKit
import RealmSwift
import NYXImagesKit
import DKImagePickerController
import UITextView_Placeholder

class EditClothesViewController: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate,UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var resizedImage: UIImage!
    
    @IBOutlet var postImageCollectionView: UICollectionView!
    
//    var postImageView: UIImageView!
    var selectedImageArray = [UIImage]()
    var imageArray = [UIImage]()
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var sizeTextField: UITextField!
    @IBOutlet var colorTextField: UITextField!
    @IBOutlet var brandTextField: UITextField!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var updataButton: UIButton!
    
    var selectedData: Int!
//    var selectedIndexPath: Int!
    var selectedName: String!
    var selectedPrice: String!
    var selectedCategory: String!
    var selectedSize: String!
    var selectedColor: String!
    var selectedBrand: String!
    var selectedComment: String!
    
    // 前の画面から受け取った情報
    var selectedArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プレイスホルダーを入れる       postImageView.image =
        commentTextView.delegate = self
        nameTextField.delegate = self
        priceTextField.delegate = self
        categoryTextField.delegate = self
        sizeTextField.delegate = self
        colorTextField.delegate = self
        brandTextField.delegate = self
        postImageCollectionView.delegate = self
        postImageCollectionView.dataSource = self
        
        // postImageCollectionViewのレイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        postImageCollectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        
        // priceTextFieldのキーボードを数字のみにする
        priceTextField.keyboardType = UIKeyboardType.numberPad
        // priceTextFieldのツールバーの読み込み
//        priceToolBar()
//        commentToolBar()
        
        commentTextView.placeholder = "（例） ○○年 ○月 ○日に購入\n　　　パンツ等のサイズ［W30／L32］"
        commentTextView.placeholderColor = UIColor.lightGray
        
        updataButton.layer.cornerRadius = 10
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        checknill()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        
        if selectedCategory != nil {
            categoryTextField.text = selectedCategory
        } else {
            categoryTextField.text = selectedArray[0].category
        }
        if selectedSize != nil {
            sizeTextField.text = selectedSize
        } else {
            sizeTextField.text = selectedArray[0].size
        }
        if selectedColor != nil {
            colorTextField.text = selectedColor
        } else {
            colorTextField.text = selectedArray[0].color
        }
        if selectedBrand != nil {
            brandTextField.text = selectedBrand
        } else {
            brandTextField.text = selectedArray[0].brand
        }
        if selectedComment != nil {
            commentTextView.text = selectedComment
        } else {
            commentTextView.text = selectedArray[0].comment
        }
        
        // 受け取った情報をラベルに表示させる
        for i in selectedArray[0].images {
            let image: UIImage = UIImage(data: i.imageData)!
            selectedImageArray.append(image)
        }
        nameTextField.text = selectedArray[0].name
        priceTextField.text = String(selectedArray[0].price)
//        categoryTextField.text = selectedArray[0].category
//        sizeTextField.text = selectedArray[0].size
//        colorTextField.text = selectedArray[0].color
//        brandTextField.text = selectedArray[0].brand
//        commentTextView.text = selectedArray[0].comment
        
        
//        self.configureObserver()
        
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
    
    // 編集が終わってtextviewを閉じる
    func textViewDidEndEditing(_ textView: UITextView) {
            textView.resignFirstResponder()
    }

    
//    // 画像を複数選択
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//
//        resizedImage = selectedImage.scale(byFactor: 0.7)
//        self.postImageView.image = resizedImage
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    
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
                    // 画像の重複を避けるためimageArrayを空にする
                    selectedImageArray = []
                    for asset in assets {
                        asset.fetchFullScreenImage(completeBlock: { (image, info) in
                            // ここで取り出せる
                            resizedImage = image?.scale(byFactor: 0.7)
                            self.selectedImageArray.append(image!)
                        })
                    }
                    // 画像が重くて読み込めないため、動作を遅延させる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.postImageCollectionView.reloadData()
                    }
                }
                
//                picker.assetType = .allPhotos
                
                
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
//        nill(check)
        return selectedImageArray.count
    }
    
    // postImageCollectionVIewCellの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            // tagを使ってimageViewのインスタンス生成
            let photoImageView = cell.contentView.viewWithTag(1) as! UIImageView
            photoImageView.image = selectedImageArray[indexPath.row]
            
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
        // キーボードを閉じる
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
            
        return true
        
    }
    
    // priceTextFieldのキーボードの完了を押した時の処理
    @objc func priceDone(_sender: UIButton) {
        priceTextField.resignFirstResponder()
    }
    
    
    // textViewの設定
    // 入力画面または、キーボード以外の場所を押したら、キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.commentTextView.isFirstResponder) {
            self.commentTextView.resignFirstResponder()
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
    
    
    @objc func commentDone(_sender: UIButton) {
        commentTextView.resignFirstResponder()
    }
    
    @IBAction func updata() {
        
        if selectedImageArray.count == 0 || nameTextField.text == nil || nameTextField.text?.isEmpty == true ||  priceTextField.text == nil  || priceTextField.text?.isEmpty == true || categoryTextField.text == nil || sizeTextField.text == nil || colorTextField.text == nil || brandTextField.text == nil || brandTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "注意！", message: "入力情報が不十分です。\n'メモ・商品情報'欄以外は情報を入力して下さい。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let realm = try! Realm()
            // どのオブジェクトを使うのかを宣言
            let results = realm.objects(Item.self).filter("number == %@", selectedData!)
            
            try! realm.write {
                
                results[0].images.removeAll()
                
            for i in selectedImageArray {
                let image = Images()
                image.imageData = i.pngData()
                results[0].images.append(image)
    //            results[selectedIndexPath].images.append(image)
            }
            
                // 更新するデータが持っているnumberのデータを編集する
                results[0].name = nameTextField.text!
                results[0].price = Int(priceTextField.text!)!
                results[0].category = categoryTextField.text
                results[0].size = sizeTextField.text
                results[0].color = colorTextField.text
                results[0].brand = brandTextField.text
                results[0].comment = commentTextView.text ?? ""
    //        results[selectedIndexPath].number = results[selectedIndexPath].number
            
            }
                    
            // データの更新が完了した場合、前の画面へ値を渡す
            
            // 前の画面に入力された内容を渡す
            let preNC = self.presentingViewController as! UINavigationController
            let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! DetailClothesViewController
            
            preVC.updataImageArray = selectedImageArray
            preVC.updataName = nameTextField.text!
            preVC.updataPrice = Int(priceTextField.text!)!
            preVC.updataCategory = categoryTextField.text!
            preVC.updataSize = sizeTextField.text!
            preVC.updataColor = colorTextField.text!
            preVC.updataBrand = brandTextField.text!
            preVC.updataComment = commentTextView.text!
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}
