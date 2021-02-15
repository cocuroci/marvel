import UIKit

enum BookmarksAction {
    case detail(character: Character, delegate: UpdatedCharacterDelegate?)
}

protocol BookmarksCoordinating {
    var viewController: UIViewController? { get set }
    func perform(action: BookmarksAction)
}

final class BookmarksCoordinator {
    weak var viewController: UIViewController?
}

extension BookmarksCoordinator: BookmarksCoordinating {
    func perform(action: BookmarksAction) {
        switch action {
        case let .detail(character, delegate):
            let detailViewController = DetailFactory.make(with: character, delegate: delegate)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
