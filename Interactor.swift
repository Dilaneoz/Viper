//
//  Interactor.swift
//  ViperOrnekBilgeAdam
//
//  Created by Dilan Öztürk on 1.04.2023.
//

import Foundation

// interactor restapi servisimizle haberleşecek olan katmandır

protocol AnyInteractor {
    
    var presenter : AnyPresenter? {get set} // web servisten aldığı dataları bir presenterla ilişkilendirecek. get metoduyla ondan dataları alabilir ve set ile ona data ayrışımı yapabilir
    
    func downloadCrypto()
    
}

class CryptoInteractor : AnyInteractor {
    
    var presenter: AnyPresenter?
    
    func downloadCrypto() {
        guard let url = URL(string: "https://raw.githubusercontent.com/ibrahimgokyar/androidkitap/master/crypto.json")
        else {return} // guard let yaptıysak else ile yönetmek gerekir. bu url e ulaşamazsa downloadCrypto daki diğer kodları yazdırmamış olucaz
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in // data, response, error in bu kısım arka plandaki işlemleri içeriyor. bu arka plandaki işlemlerin görünürlüğü ram de devam edeceği için bunlarla ilgili iş bittiğinde bunların ramdan temizlenmesi için [weak self] yapısı kullanılır
            if let error = error { // eğer error hatası boş değilse
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.neetworkFailed)) // networkle ilgili bir hata ver
                return // hata alırsa return sayesinde aşağı gitmesi engellenecek
            }
            guard let data = data else {return} // eğer hata yoksa
            do {
                let gelenCryptos = try JSONDecoder().decode([Crypto].self, from: data) // json dan bir array gelicek ve içinde cryptolar olucak. json olarak gelen datayı al içine crypto tipinde veri alan bir arraya dönüştürüyor. içinde artık cryptolar var
                self?.presenter?.interactorDidDownloadCrypto(result: .success(gelenCryptos)) // data geldiyse presenter a yollıycaz. result burada gelen datayı göstericek
            }
            catch {
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.parsingFailed)) // eğer yukarıdaki datayı işlemeyle ilgili bir sorun varsa bu kod dönücek
            }
            
        }
        task.resume() // task ın çalışması için bu kod yazılır

    }
    
    
    
}
