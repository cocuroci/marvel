import UIKit

enum ListFactory {
    static func make() -> UIViewController {
        ListViewController(interactor: ListInteractor())
    }
}
