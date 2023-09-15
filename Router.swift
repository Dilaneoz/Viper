//
//  Router.swift
//  ViperOrnekBilgeAdam
//
//  Created by Dilan Öztürk on 1.04.2023.
//

import Foundation
import UIKit

// router presenter dan da bilgi sahibi olmak zorunda interactor u ve view i de yönetmek zorunda. bir yönlendirme gelecek ve bunu hangi view a göndereceği router ile yapılıyor

typealias EntryPoint = AnyView & UIViewController // bu bir view ve UIViewController dır. normalde de bizim storyboard da bir view ımız ve onunla ilişkili de bir controller ımız vardı. typealias ile dedik ki EntryPoint gördüğün her yerde bu EntryPoint in içinde bir view vardır ve aynı zamanda bir UIViewController dır (maindeki entrypoint)

protocol AnyRouter { // AnyRouter ın içinde bir giriş noktamız olucak
    
    static func startExecution() -> AnyRouter // closure. bu router uygulama ayağa kalktığında bi uiviewcontroller gösterecek(o view la ilgili bir controller).
    var entry : EntryPoint? {get} // bunun içinde de bir giriş noktası olması gerek. get demek bir değişkenin değerini okumamızı sağlar.
}

class CryptoRouter : AnyRouter {
    
    var entry : EntryPoint?
    static func startExecution() -> AnyRouter {
        let router = CryptoRouter()
        
        var view : AnyView = CryptoViewController()// bunun içinde view la ilişkili bir controller a da ihtiyaç olucak (mainde bir viewcontroller i bir class a bağlama)
        var presenter : AnyPresenter = CryptoPresenter() // AnyPresenter protocolunu kullanmıştır ve bunun class ı da CryptoPresenter
        var interactor : AnyInteractor = CryptoInteractor() // router interactor le haberleşecek
        
        // birbirleri arasındaki bağlantıyı kuruyoruz
        view.presenter = presenter // view la presenter ın bağlantısını kuruyoruz
        presenter.view = view // presenter üzerinden view i bağlıyoruz
        presenter.router = router // presenter ın hangi route üzerinden işlemi yapacağını yazıyoruz
        interactor.presenter = presenter
        router.entry = view as? EntryPoint // içinde hem view ın hem de view controller ın olduğu bir obje dönücez
        presenter.interactor = interactor
        return router
        
    }
}
