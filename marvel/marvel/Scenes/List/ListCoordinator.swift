import UIKit

enum ListAction {
    case detail(character: Character, delegate: UpdatedCharacterDelegate?)
    case bookmarks(delegate: UpdatedCharacterDelegate?)
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
        case let .detail(character, delegate):
            let detailViewController = DetailFactory.make(with: character, delegate: delegate)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        case .bookmarks(let delegate):
            let bookmarksViewController = BookmarksFactory.make(delegate: delegate)
            viewController?.navigationController?.pushViewController(bookmarksViewController, animated: true)
        }
    }
}
