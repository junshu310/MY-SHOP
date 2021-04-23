//
//  EditDetailCategoryViewController.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/02/01.
//

import UIKit

class EditDetailCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var detailTableView: UITableView!
    
    var getCell: Int!
    
    var array = [String]()
    
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

        detailTableView.tableFooterView = UIView()
        
        // 選択されたジャンルによってセルの数を変える
        switch getCell {
        case 0:
            array = tops
        case 1:
            array = outer
        case 2:
            array = pants
        case 3:
            array = skirt
        case 4:
            array = dress
        case 5:
            array = suits
        case 6:
            array = shoes
        case 7:
            array = bag
        case 8:
            array = cap
        case 9:
            array = accessory
        case 10:
            array = item
        case 11:
            array = sports
        case 12:
            array = interior
        case 13:
            array = other
        default:
            break
        }
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
    }
    
    // TableViewセルの数と内容
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        // 選択されたジャンルによってセルの中身を変える
        
        cell.textLabel?.text = array[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // データを遷移下の画面に渡す
//        let perNC = self.navigationController!
        let perVC = self.presentingViewController?.presentingViewController as! EditClothesViewController

        // 値渡し
        perVC.selectedCategory = self.array[indexPath.row]
        // 閉じる(二つ前の画面に戻る)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
// ToDo トップスのクラスのカテゴリーの情報もデータとして保存したい。（検索などの時に使う。）
        
    }

    // 一つ前の画面に戻る
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
}
