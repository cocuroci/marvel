import Foundation
import UIKit

protocol DetailPresenting {
    var viewController: DetailDisplaying? { get set }
    func presentName(_ name: String?)
    func presentImage(url: URL?)
    func presentDescription(_ description: String?)
    func presentCharacterIsFavorite()
    func presentCharacterIsNotFavorite()
}

final class DetailPresenter {
    weak var viewController: DetailDisplaying?
}

extension DetailPresenter: DetailPresenting {
    func presentName(_ name: String?) {
        viewController?.displayName(name)
    }
    
    func presentImage(url: URL?) {
        viewController?.displayImage(url: url)
    }
    
    func presentDescription(_ description: String?) {
        viewController?.displayDescription(description)
    }
    
    func presentCharacterIsFavorite() {
        viewController?.displayStarImage(UIImage(systemName: "star.fill"))
    }
    
    func presentCharacterIsNotFavorite() {
        viewController?.displayStarImage(UIImage(systemName: "star"))
    }
}
