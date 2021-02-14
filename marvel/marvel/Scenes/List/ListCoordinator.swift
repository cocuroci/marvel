import UIKit

enum ListAction {
    case detail(character: Character)
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
        case .detail(let character):
            let detailViewController = DetailFactory.make(with: character)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
