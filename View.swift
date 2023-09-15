//
//  View.swift
//  ViperOrnekBilgeAdam
//
//  Created by Dilan Öztürk on 1.04.2023.
//

// solda arama çubuğunu main yazıp INFOPLIST_KEY_UIMainStoryboardFile = Main a tıklamak gerek. ordan "uikit main storyboard file base name" deki main i siliyoruz. burada uygulama açılırken CryptoViewController ın devreye girmesini söyledik

import Foundation
import UIKit

// bu view presenter la ilişkili

// swift protocol odaklı bir yazılım dilidir. her şeyde bir protocol tanımlıyoruz o protocol tipinde delegate ler yapıyoruz (mülakatta sorarlarsa)

protocol AnyView {
    
    var presenter : AnyPresenter? {get set} // bu ilgili protocol e özgü bir presenter
    func guncelle(with cryptos : [Crypto]) // içine Crypto tipinde bir veri alan bir array verildiğinde güncelle
    func guncelle(with error : String) // bir hata varsa -güncelleyemediği bir durum- onu yazacak
}

class DetailViewController : UIViewController {
    
    var presenter : AnyPresenter? // görünümle alakalı bir şey olduğu için presenter ın haberdar olması gerek. bu detayı gösterecek. detay da o anki kriptonun currency sini gösterecek
    var currency : String = ""
    var price : String = ""
    
    private let currencyLabel : UILabel = {
        
        let label = UILabel()
        label.isHidden = true
        label.text = "Currency Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel : UILabel = {
        
        let label = UILabel()
        label.isHidden = true
        label.text = "Price Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(currencyLabel)
        view.addSubview(priceLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        currencyLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
        priceLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 50, width: 200, height: 50)
        currencyLabel.text = currency
        priceLabel.text = price
        currencyLabel.isHidden = false
        priceLabel.isHidden = false

    }
}

class CryptoViewController : UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource {
    
    func guncelle(with cryptos: [Crypto]) {
        DispatchQueue.main.async { // view kendisine gelen güncellede Crypto arrayini işleyecek
            self.cryptos = cryptos
            self.tableView.isHidden = false // veriler geldiyse tableview de görünür olur
            self.messageLabel.isHidden = true // messageLabel true yapılırsa "veriler yükleniyor" yazısını göstermez
            self.tableView.reloadData()
        }
    }
    
    func guncelle(with error: String) {
        DispatchQueue.main.async {
            self.cryptos = [] // eğer bir hata varsa array in içini temizle
            self.tableView.isHidden = true // tableview i gösterme
            self.messageLabel.text = error // messageLabel ın textine oluşan hatayı yaz
            self.messageLabel.isHidden = false // messageLabel ı görünür hale getir
        }
    }
    
    var presenter : AnyPresenter? // bu da CryptoViewController e özgü bir presenter
    var cryptos : [Crypto] = []
    
    private let messageLabel : UILabel = { // kodla bir label oluşturduk
        
        let label = UILabel ( ) // UILabel tipinde bir nesne oluşturduk
        label.text = "Veriler Yükleniyor" // label a Veriler Yükleniyor yazılacak
        label.font = UIFont.systemFont(ofSize: 20) // font size ı 20 olucak
        label.textColor = .black // text in rengi siyah olucak
        label.textAlignment = .center // ortalanacak
        return label
    } ()
    
    private let tableView : UITableView = { // tableview ı oluşturuyoruz
        
        let table = UITableView() // UITableView sınıfından bir nesne oluştur
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")  // bunun içinde bir cell oluşturuyoruz. cell e de cell adını verdik
        table.isHidden = true // restapi den veriler gelmiyorsa label gözükecek geliyorsa tableview gözükecek
        return table
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad() // türediği sınıfın viewdidload fonksiyonunu başlangıçta çağırıyoruz
        
        view.backgroundColor = .red // uygulama çalıştığında scenedelegate e gelecek. background u kırmızı yapıcak
        view.addSubview(messageLabel) // sayfa yüklenirken bu view i oluştur
        view.addSubview(tableView)
        tableView.delegate = self // bunu diyerek CryptoViewController ile tableview ın ilişkisini kurarız. yani tableview a bir veri geldiğinde senin de haberin olsun diyoruz
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2, width: 200 , height: 50) // bu class ın dikdörtgen şeklinde bir nesne oluşturacağını söylüyoruz. nerede gösterileceğini söylüyoruz
        tableView.frame = view.bounds // tüm ekranı kapla
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration() // kendi oluşturduğum bu cell in configurasyonunu ayarlıyorum
        content.text = cryptos[indexPath.row].currency // indexpath in row uncu elemanında currency i yazıcak
        content.secondaryText = cryptos[indexPath.row].price
        cell.contentConfiguration = content
        cell.backgroundColor = .yellow
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detayViewController = DetailViewController()
        detayViewController.currency = cryptos[indexPath.row].currency
        detayViewController.price = cryptos[indexPath.row].price
        self.present(detayViewController, animated: true,completion: nil)
    }
}
