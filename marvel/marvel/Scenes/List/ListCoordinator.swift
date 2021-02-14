import UIKit

enum ListAction {
    case detail(character: Character, delegate: DetailInteractorDelegate?)
}

protocol ListCoordinating {
    var viewController: UIViewController? { get set }
    func perform(action: ListAction)
}

final class ListCoordinator {
    weak var viewController: UIViewController?
}

extension ListCoordinator: ListCoordinating {
    func perform(action: ListAction) {
        switch action {
        case .detail(let character, let delegate):
            let detailViewController = DetailFactory.make(with: character, delegate: delegate)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
