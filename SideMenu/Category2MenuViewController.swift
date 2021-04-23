//
//  CategoryMenuViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/01/31.
//

import UIKit

var isCheckKeyWordCategory = false
var keyWordCategory: String!

class Category2MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var categoryTableView: UITableView!
    var categoryGetCell: Int!
    var swithArray = [String]()
    
    var tops = ["Tシャツ/カットソー(半袖)","Tシャツ/カットソー(長袖)","シャツ","ポロシャツ","ニット/セーター","カーディガン","パーカー","スウェット/トレーナー","ベスト","ジャージ","タンクトップ","その他トップス"]
    
    var outer = ["テーラードジャケット","ノーカラージャケット","デニムジャケット","ダウンジャケット","ダウンベスト","レザージャケット","ライダースジャケット","ミリタリージャケット","ブルゾン","チェスターコート","ピーコート","ステンカラーコート","トレンチコート","ダッフルコート","モッズコート","ムートンコート","ナイロンジャケット","マウンテンパーカー","スタジャン","スカジャン","ポンチョ","その他ジャケット/アウター"]
    
    var pants = ["デニム/ジーンズ","ワークパンツ/カーゴパンツ","チノパンツ","スラックス","スウェットパンツ","ショートパンツ","サロペット/オーバーオール","その他パンツ"]
    
    var skirt = ["スカート","その他スカート"]
    
    var dress = ["ワンピース","チュニック",
                 "ドレス","パンツドレス","その他ワンピース/ドレス"]
    
    var suits = ["スーツジャケット","スーツベスト","スーツパンツ","スーツスカート"]
    
    var shoes = ["スニーカー","スリッポン","ハイヒール/パンプス","ブーツ","ローファー","モカシン/デッキシューズ","ドレス・ビジネスシューズ","サンダル","レインシューズ","その他シューズ"]
    
    var bag = ["ショルダーバッグ","トートバッグ","リュック/バックパック","ボストンバッグ","ボディバッグ/ウエストポーチ","ハンドバッグ","クラッチバッグ","メッセンジャーバッグ","ドラムバッグ","ビジネスバッグ","トラベルバッグ","その他バッグ"]
    
    var cap = ["キャップ","ハット","ニットキャップ/ビーニー","ハンチング/ベレー帽","キャスケット","サンバイザー","その他キャップ"]
    
    var accessory = ["ネックレス","リング","ピアス","イヤリング","バングル/リストバンド","ブレスレッド","アンクレット","チョーカー","その他アクセサリー"]
    
    var item = ["腕時計","ベルト","サングラス/メガネ","スカーフ/バンダナ","ストール/ショール","マフラー","ネックウォーマー","手袋","イヤーマフ","財布","コインケース","キーケース","パスケース/カードケース","ネクタイ","ネクタイピン","モバイルケース/カバー","その他ファッション雑貨"]
    
    var sports = ["ゴルフ","野球","サッカー/フットサル","バスケットボール","テニス","トレーニング/エクササイズ","スノーボード","スキー","その他スポーツ関連"]
    
    var interior = ["家具","インテリア","その他家具/インテリア"]
    
    var other = ["その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.tableFooterView = UIView()

        // 選択されたジャンルによってセルの数を変える
        switch categoryGetCell {
        case 0:
            swithArray = tops
        case 1:
            swithArray = outer
        case 2:
            swithArray = pants
        case 3:
            swithArray = skirt
        case 4:
            swithArray = dress
        case 5:
            swithArray = suits
        case 6:
            swithArray = shoes
        case 7:
            swithArray = bag
        case 8:
            swithArray = cap
        case 9:
            swithArray = accessory
        case 10:
            swithArray = item
        case 11:
            swithArray = sports
        case 12:
            swithArray = interior
        case 13:
            swithArray = other
        default:
            break
        }
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
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
        swithArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = swithArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ToDo 画面を閉じて検索
        isCheckKeyWordCategory = true
        // 最後に選択された情報をここに入れる
        keyWordCategory = swithArray[indexPath.row]

        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
