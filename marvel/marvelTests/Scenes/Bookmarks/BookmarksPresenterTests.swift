import XCTest
@testable import marvel

private final class BookmarksViewControllerSpy: BookmarksDisplaying {
    // MARK: - displayCharacters
    private(set) var displayCharactersCount = 0
    private(set) var characters = [Character]()
    
    func displayCharacters(_ characters: [Character]) {
        displayCharactersCount += 1
        self.characters = characters
    }
    
    // MARK: - displayEmptyView
    private(set) var displayEmptyViewCount = 0
    private(set) var text: String?
    private(set) var imageName: String?
    
    func displayEmptyView(text: String, imageName: String) {
        displayEmptyViewCount += 1
        self.text = text
        self.imageName = imageName
    }
    
    // MARK: - clearList
    private(set) var clearListCount = 0
    
    func clearList() {
        clearListCount += 1
    }
}

private final class BookmarksCoordinatorSpy: BookmarksCoordinating {
    var viewController: UIViewController?
    
    // MARK: - perform
    private(set) var performCount = 0
    private(set) var action: BookmarksAction?
    
    func perform(action: BookmarksAction) {
        performCount += 1
        self.action = action
    }
}

final class BookmarksPresenterTests: XCTestCase {
    private let viewControllerSpy = BookmarksViewControllerSpy()
    private let coordinatorSpy = BookmarksCoordinatorSpy()
    
    private lazy var sut: BookmarksPresenting = {
        let presenter = BookmarksPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func testPresentCharacters_ShouldDisplayCharacters() {
        let character = Character(id: 1, name: "name", description: "description", thumbnail: nil)
        
        sut.presentCharacters([character])
        
        XCTAssertEqual(viewControllerSpy.displayCharactersCount, 1)
        XCTAssertEqual(viewControllerSpy.characters.count, 1)
    }
    
    func testPresentCharacters_ShouldDisplayEmptyView() {
        sut.presentEmptyView()
        
        XCTAssertEqual(viewControllerSpy.displayEmptyViewCount, 1)
        XCTAssertEqual(viewControllerSpy.text, "Nenhum personagem favoritado")
        XCTAssertEqual(viewControllerSpy.imageName, "star")
    }
    
    func testClearList_ShouldClearList() {
        sut.clearList()
        
        XCTAssertEqual(viewControllerSpy.clearListCount, 1)
    }
    
    func testDidNextStep_ShouldPassActionToCoordinator() {
        let action: BookmarksAction = .detail(character: Character(id: 1, name: "name", description: nil, thumbnail: nil), delegate: nil)
        
        sut.didNextStep(action: action)
        
        XCTAssertEqual(coordinatorSpy.performCount, 1)
        XCTAssertEqual(coordinatorSpy.action, action)
    }
}
