//
//  Presenter.swift
//  ViperOrnekBilgeAdam
//
//  Created by Dilan Öztürk on 1.04.2023.
//

import Foundation

enum NetworkError : Error { // enum kullanılması numaralandırma vermek içindir. enum olmasaydı her bir veri için değişken oluşturmak gerekecekti
    case neetworkFailed // eğer networkle ilgili bir sıkıntı yaşarsak networkFailed hatası vericek
    case parsingFailed // eğer parsingle ilgili bir sıkıntı yaşarsak networkFailed hatası vericek
}

protocol AnyPresenter { // AnyPresenter ın içinde, presenter view den sorumlu olucak, interactorden verileri alacak, router la da hangi view e yönlendireceğinin bilgilerini tutabileceğimiz bir protocol tanımladık
    
    var view : AnyView? {get set} // presenter view la ilişkili
    var interactor : AnyInteractor? {get set} // presenter interactor le de ilişkili
    var router : AnyRouter? {get set}
    func interactorDidDownloadCrypto(result : Result<[Crypto], Error>) // interactor deki download işlemi bittiğinde, biter bitmez view ı güncelleyecek bir fonksiyon. ios uygulamalarında result diye bir tipimiz var. result class ı işlem başarılıysa başarılı olduğunda ilgili -bu bir dizi ya da nesne olabilir- kullanacağı data burada. cryptol lar başarıyla çekildiyse bunlar bir diziye aktarılacak. yani başarılıysa içine Crypto tipinde veri alan bir dizimiz var ve başarısızsa hata yazdır
    
}

class CryptoPresenter : AnyPresenter {
    
    var view: AnyView?
    var interactor: AnyInteractor? { // interactor le ilgili bir işlem olduğunda willSet didSet dediğimiz yapılar var. bir değişken değeri alır almaz çalışmasını istediğimiz yapılarda didSet (property observers diye geçiyor. didSet ler property lerin sürekli gözlemliyolar ve gözlemledikleri değer değiştiği anda tetikleniyor ve çalışıyorlar) kullanılır. interactorle ilgili bir işlem olduğunda devreye girmesini istediğim bir şey varsa didSet le yapılabilir
        didSet {
            interactor?.downloadCrypto() // downloadCrypto fonksiyonu veri geldiğinde presenter a işlemin bittiğini bildiriyor. downloadCrypto ya bir değer geldiğinde "var interactor" etkilenir yani değeri değişir.
        }
         // willSet ler de ilgili değer kaydedilmeden önce çalışır. willSet ve didSet property lerdeki değişiklikleri gözlemlerler
            
    }
    
    var router: AnyRouter?
    
    func interactorDidDownloadCrypto(result: Result<[Crypto], Error>) {
        
        switch result {
        case .success(let cryptos) : // download işlemi bittiğinde işlem başarılıysa, interactor den gelen verileri [Crypto] yerine (let cryptos) objesinin içinde tutarız. [Crypto] = (let cryptos)
            // view güncellenecek
            view?.guncelle(with: cryptos) // view in güncelle fonksiyonunu let cryptos u verirsek bu çalışacak. interactorle network tarafından çekmiş olduğumuz veriyi buradan da view e taşırız
        case .failure(_) : // işlem başarısızsa hata yazdıracak
            print("hata oldu")
        }
        
        
        
        
    }
}
