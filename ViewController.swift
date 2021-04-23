//
//  ViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/07.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet var clothesCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var button: UIButton!
    @IBOutlet var searchLabel: UILabel!
    var receivedArray: String!
    
    var selectedImage: UIImage?
    var clothesArray = [Item]()
    var anotherResults: Results<Item>!
    var newResults: Results<Item>!
    var nameArray = [String]()
    var isCheckSearchResult = false
    var searchResult = [Item]()
    var selectedId: Int!
    
    @IBOutlet var selectTextField: UITextField!
    var pickerView: UIPickerView = UIPickerView()
    var list = ["新着順", "登録が古い順", "価格が高い順", "価格が低い順"]
    var colorArray = [String]()
    var colors = ["ホワイト系", "ブラック系","グレー系","ピンク系","レッド系","オレンジ系","ブラウン・ベージュ系","イエロー系", "グリーン系","ネイビー・ブルー系","パープル系","その他"]
    
    var selectedIndex: Int!
    
    var checkList: String!
    var checkKeyword: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCheckKeyWordCategory = false
        isCheckKeyWordColor = false
        isCheckKeyWordBrand = false
        
        // collectionViewのレイアウトを調整
        let layout = UICollectionViewFlowLayout()
        clothesCollectionView.collectionViewLayout = layout
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 15, right: 15)
        
        selectTextField.delegate = self
       
        createPicker()
        
        setRefreshControl()
        
        // searchBarの設定
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.enablesReturnKeyAutomatically = false
        searchResult = clothesArray
        
        // テキストフィールドの設定
        selectTextField.layer.borderWidth = 0.8
        selectTextField.layer.borderColor = UIColor.black.cgColor
        selectTextField.layer.cornerRadius = 5.0
        
        // ボタンの設定
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        // ボタンを押した感の設定
        button.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadName()
        
        checkList = selectTextField.text
        
        if isCheckKeyWordCategory == true || isCheckKeyWordColor == true || isCheckKeyWordColor == true {
            selectTextField.text = "登録が古い順"
        }
        
        
        // ある処理が行われた時にだけ呼ばれるようにしたい
        loadTimeLine()
        
        // カテゴリーが選択されている時は、並び替えの値に反応しないようにする
        // パーカーの状態からカテゴリー選択をするとloadTimeLine()が呼ばれない。
        // "全てを表示"以外の文字が入っている時は、loadTimeline()
        
        
        if receivedArray != nil {
            searchLabel.text = receivedArray
        } else {
            searchLabel.text = "全てを表示"
        }
        
        clothesCollectionView.delegate = self
        clothesCollectionView.dataSource = self
        isCheckSearchResult = false
    }
    
    func createPicker() {
        // ピッカー設定
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem,spaceItem, doneItem], animated: true)
        
        // インプットビュー設定
        selectTextField.inputView = pickerView
        selectTextField.inputAccessoryView = toolbar
        
    }
    
    // 並び替えの決定押下
    @objc func done() {
        isCheckSearchResult = false
        selectTextField.endEditing(true)
        selectTextField.text = "\(list[pickerView.selectedRow(inComponent: 0)])"
        checkList = selectTextField.text
        
        loadTimeLine()
        
        
        // まず、キーワードを取り出す
        receivedArray = searchLabel.text
        // 今、clothesArrayには新着順を全て表示したものがある
        if searchLabel.text != "全てを表示" {
            clothesArray = [Item]()
            let realm = try! Realm()
            // キーワードがカテゴリーならカテゴリーで検索をかける
            if receivedArray == keyWordCategory {
                newResults = anotherResults.filter("category == %@", receivedArray!)
            } else if receivedArray == keyWordColor {
                // キーワードがカラーならカラーで検索をかける
                newResults = anotherResults.filter("color == %@", receivedArray!)
            } else if receivedArray == keyWordBrand {
                print(keyWordBrand)
                // キーワードがブランドならブランドで検索をかける
                newResults = anotherResults.filter("brand == %@", receivedArray!)
            }
            
            for newResult in newResults {
                clothesArray.append(newResult)
            }
            clothesCollectionView.reloadData()
        }
        // 重複を避けるために、完了後は空に
        anotherResults = nil
        newResults = nil
        receivedArray = nil


    }
    @objc func cancel() {
        selectTextField.endEditing(true)
    }
    
    // 表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCheckSearchResult == true {
            return searchResult.count
        } else {
            return clothesArray.count
        }
    }
        
    // 表示するセルの内容（登録した情報をセル上に表示）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isCheckSearchResult == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            let cellImageView = cell.contentView.viewWithTag(1) as! UIImageView
            let cellLabel = cell.contentView.viewWithTag(2) as! UILabel
            let cellLabel2 = cell.contentView.viewWithTag(3) as! UILabel
            let cellLabel3 = cell.contentView.viewWithTag(4) as! UILabel
            
            cellImageView.image = UIImage(data: searchResult[indexPath.row].images[0].imageData)
            cellLabel.text = searchResult[indexPath.row].name
            cellLabel2.text = searchResult[indexPath.row].brand
            cellLabel3.text = String(searchResult[indexPath.row].price)
            
            // 通貨単位をつける
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "ja_JP")
            // UILabelにセット
            cellLabel3.text = formatter.string(from: NSNumber(value: searchResult[indexPath.row].price))
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            let cellImageView = cell.contentView.viewWithTag(1) as! UIImageView
            let cellLabel = cell.contentView.viewWithTag(2) as! UILabel
            let cellLabel2 = cell.contentView.viewWithTag(3) as! UILabel
            let cellLabel3 = cell.contentView.viewWithTag(4) as! UILabel
    
            cellImageView.image = UIImage(data: clothesArray[indexPath.row].images[0].imageData)
            cellLabel.text = clothesArray[indexPath.row].name
            cellLabel2.text = clothesArray[indexPath.row].brand
            cellLabel3.text = String(clothesArray[indexPath.row].price)
            
            // 通貨単位をつける
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "ja_JP")
            // UILabelにセット
            cellLabel3.text = formatter.string(from: NSNumber(value: clothesArray[indexPath.row].price))
            
            return cell
        }
    }
    
    // セルを選択したときに情報の詳細へ画面遷移
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let realm = try! Realm()
        
        // 何番目が選択されたか
        selectedIndex = indexPath.row
        
        // 画面遷移
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        // 選択状態が継続されたままになるのを防ぐ
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    @IBAction func toMenu() {
        self.performSegue(withIdentifier: "toMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailClothesViewController

            // 選択したセルのナンバーを読み取って、それを次の画面に渡す
            
            detailVC.receivedArray = [Item]()
            detailVC.receivedArray.append(clothesArray[selectedIndex])
            
            // Labelの文字を渡す
            detailVC.receivedKeyword = searchLabel.text
            
        }
        if segue.identifier == "toMenu" {
            let detailVC = segue.destination as! MenuViewController
            // Labelの文字を渡す
            detailVC.receivedKeyword = searchLabel.text
        }
    }
    
    // collectionViewのセルの大きさを調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + 57)
    }
    
    // searchBarの設定
    // 検索ボタンをクリック時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isCheckSearchResult = true
        searchBar.endEditing(true)
        // 検索結果を空にする
        searchResult.removeAll()
        if searchBar.text == "" {
            searchResult = clothesArray
        } else {
            for data in clothesArray {
                if data.name.contains(searchBar.text!) {
                    searchResult.append(data)
                }
            }
        }
        // ここまでで完了した作業は、検索ボタンを押したら、検索のテキスト含む name をsearchResult(配列)に入れた
        clothesCollectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // ボタンの押した感の設定
    @objc func pushButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    @objc func separateButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
             sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
             sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    func loadTimeLine() {
        // Realmを使用する宣言
        let realm = try! Realm()
        var results: Results<Item>!
        
       if checkList == "新着順" {
            results = realm.objects(Item.self).sorted(byKeyPath: "number", ascending: false)
            anotherResults = results
            // 新着順の時
            if isCheckKeyWordCategory == false && isCheckKeyWordColor == false && isCheckKeyWordBrand == false {
                receivedArray = nil
        } else if isCheckKeyWordCategory == true {
                print(keyWordCategory)
            // ↓ キーワードを古い順で呼んでいる
                results = realm.objects(Item.self).filter("category == %@", keyWordCategory!)
                receivedArray = keyWordCategory
                isCheckKeyWordCategory = false
            }
            else if isCheckKeyWordColor == true {
                results = realm.objects(Item.self).filter("color == %@", keyWordColor!)
                receivedArray = keyWordColor
                isCheckKeyWordColor = false
            }
            else if isCheckKeyWordBrand == true {
                results = realm.objects(Item.self).filter("brand == %@", keyWordBrand!)
                receivedArray = keyWordBrand
                isCheckKeyWordBrand = false
            }

        } else if checkList == "登録が古い順" {
            results = realm.objects(Item.self).sorted(byKeyPath: "number", ascending: true)
            anotherResults = results
            // 登録が古いの時
            if isCheckKeyWordCategory == false && isCheckKeyWordColor == false && isCheckKeyWordBrand == false {
                receivedArray = nil
            }
            else if isCheckKeyWordCategory == true {
                results = realm.objects(Item.self).filter("category == %@", keyWordCategory!)
                receivedArray = keyWordCategory
                isCheckKeyWordCategory = false
            }
            else if isCheckKeyWordColor == true {
                results = realm.objects(Item.self).filter("color == %@", keyWordColor!)
                receivedArray = keyWordColor
                isCheckKeyWordColor = false
            }
            else if isCheckKeyWordBrand == true {
                results = realm.objects(Item.self).filter("brand == %@", keyWordBrand!)
                receivedArray = keyWordBrand
                isCheckKeyWordBrand = false
            }
            
        } else if checkList == "価格が高い順" {
            results = realm.objects(Item.self).sorted(byKeyPath: "price", ascending: false)
            anotherResults = results
            // 価格が高い順の時
            // 全て表示の場合　→  そのまま価格（降順）で表示
            if isCheckKeyWordCategory == false && isCheckKeyWordColor == false && isCheckKeyWordBrand == false {
                receivedArray = nil
            }
            // カテゴリーが選択されている時
            else if isCheckKeyWordCategory == true {
                results = realm.objects(Item.self).filter("category == %@", keyWordCategory!)
                receivedArray = keyWordCategory
                isCheckKeyWordCategory = false
            }
            else if isCheckKeyWordColor == true {
                results = realm.objects(Item.self).filter("color == %@", keyWordColor!)
                receivedArray = keyWordColor
                isCheckKeyWordColor = false
            }
            else if isCheckKeyWordBrand == true {
                results = realm.objects(Item.self).filter("brand == %@", keyWordBrand!)
                receivedArray = keyWordBrand
                isCheckKeyWordBrand = false
            }
            
        } else if checkList == "価格が低い順" {
            results = realm.objects(Item.self).sorted(byKeyPath: "price", ascending: true)
            anotherResults = results
            // 価格が低い順の時
            if isCheckKeyWordCategory == false && isCheckKeyWordColor == false && isCheckKeyWordBrand == false {
                receivedArray = nil
            }
            else if isCheckKeyWordCategory == true {
                results = realm.objects(Item.self).filter("category == %@", keyWordCategory!)
                receivedArray = keyWordCategory
                isCheckKeyWordCategory = false
            }
            else if isCheckKeyWordColor == true {
                results = realm.objects(Item.self).filter("color == %@", keyWordColor!)
                receivedArray = keyWordColor
                isCheckKeyWordColor = false
            }
            else if isCheckKeyWordBrand == true {
                results = realm.objects(Item.self).filter("brand == %@", keyWordBrand!)
                receivedArray = keyWordBrand
                isCheckKeyWordBrand = false
            }
        }
        
        // 配列を初期化する（2回目以降二重で保存するのを防ぐため）
        clothesArray = [Item]()
        
        // For if文を使って、resultの内容をclothesArrayに入れる（配列に入れることで使いやすくなる）
        for result in results {
            clothesArray.append(result)
        }
        clothesCollectionView.reloadData()
        
    }
    
    func loadName() {
        let realm = try! Realm()
        let name = realm.objects(Item.self).value(forKey: "name")
        nameArray = [String]()
        nameArray = name as! [String]
    }
    
    // 下にスクロールしたら更新
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        clothesCollectionView.addSubview(refreshControl)
    }
    
    // 更新してから２秒遅延させてタイムラグを作る
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
}
