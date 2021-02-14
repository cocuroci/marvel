import XCTest
@testable import marvel

private final class ListViewControllerSpy: ListDisplaying {
    // MARK: - displayCharacters
    private(set) var displayCharactersCount = 0
    private(set) var characters: [Character]?
    
    func displayCharacters(_ characters: [Character]) {
        displayCharactersCount += 1
        self.characters = characters
    }
    
    // MARK: - displayLoader
    private(set) var displayLoaderCount = 0
    
    func displayLoader() {
        displayLoaderCount += 1
    }
    
    // MARK: - displayFeedbackView
    private(set) var displayFeedbackViewCount = 0
    private(set) var textFeedbackView: String?
    private(set) var imageNameFeedbackView: String?
    
    func displayFeedbackView(text: String, imageName: String) {
        displayFeedbackViewCount += 1
        textFeedbackView = text
        imageNameFeedbackView = imageName
    }
    
    // MARK: - removeFeedbackView
    private(set) var removeFeedbackViewCount = 0
    
    func removeFeedbackView() {
        removeFeedbackViewCount += 1
    }
    
    // MARK: - displayEmptyView
    private(set) var displayEmptyViewCount = 0
    private(set) var textDisplayEmptyView: String?
    private(set) var imageNameDisplayEmptyView: String?
    
    func displayEmptyView(text: String, imageName: String) {
        displayEmptyViewCount += 1
        textDisplayEmptyView = text
        imageNameDisplayEmptyView = imageName
    }
    
    // MARK: - hideLoader
    private(set) var hideLoaderCount = 0
    
    func hideLoader() {
        hideLoaderCount += 1
    }
}

final class ListCoordinatorSpy: ListCoordinating {
    var viewController: UIViewController?
    
    // MARK: - perform
    private(set) var performCount = 0
    private(set) var action: ListAction?
    
    func perform(action: ListAction) {
        performCount += 1
        self.action = action
    }
}

final class ListPresenterTests: XCTestCase {
    private let coordinatorSpy = ListCoordinatorSpy()
    private let viewControllerSpy = ListViewControllerSpy()
    
    private lazy var sut: ListPresenting = {
        let presenter = ListPresenter(coordinator: coordinatorSpy)
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func testPresentCharacters_ShouldDisplayCharacters() {
        let mocked = [Character(id: 1, name: "name", description: nil, thumbnail: nil)]
        
        sut.presentCharacters(mocked)
        
        XCTAssertEqual(viewControllerSpy.displayCharactersCount, 1)
        XCTAssertEqual(viewControllerSpy.characters?.count, 1)
    }
    
    func testPresentLoader_ShouldDisplayLoader() {
        sut.presentLoader()
        
        XCTAssertEqual(viewControllerSpy.displayLoaderCount, 1)
    }
    
    func testHideLoader_ShouldHideLoader() {
        sut.hideLoader()
        
        XCTAssertEqual(viewControllerSpy.hideLoaderCount, 1)
    }
    
    func testPresentNoInternetView_ShouldDisplayFeedbackView() {
        sut.presentNoInternetView()
        
        XCTAssertEqual(viewControllerSpy.displayFeedbackViewCount, 1)
        XCTAssertEqual(viewControllerSpy.textFeedbackView, "Sem conexão")
        XCTAssertEqual(viewControllerSpy.imageNameFeedbackView, "wifi.slash")
    }
    
    func testPresentErrorView_ShouldDisplayFeedbackView() {
        sut.presentErrorView()
        
        XCTAssertEqual(viewControllerSpy.displayFeedbackViewCount, 1)
        XCTAssertEqual(viewControllerSpy.textFeedbackView, "Ops! Falha na requisição")
        XCTAssertEqual(viewControllerSpy.imageNameFeedbackView, "exclamationmark.circle")
    }
    
    func testPresentEmptyResultView_ShouldDisplayEmptyView() {
        sut.presentEmptyResultView()
        
        XCTAssertEqual(viewControllerSpy.displayEmptyViewCount, 1)
        XCTAssertEqual(viewControllerSpy.textDisplayEmptyView, "Resultado não encontrado")
        XCTAssertEqual(viewControllerSpy.imageNameDisplayEmptyView, "exclamationmark.circle")
    }
    
    func testRemoveFeedbackView_ShouldRemoveFeedbackView() {
        sut.removeFeedbackView()
        
        XCTAssertEqual(viewControllerSpy.removeFeedbackViewCount, 1)
    }
    
    func testDidNextStep_ShouldPassActionToCoordinator() {
        let action: ListAction = .detail(character: Character(id: 1, name: "name", description: nil, thumbnail: nil), delegate: nil)
        sut.didNextStep(action: action)
        
        XCTAssertEqual(coordinatorSpy.performCount, 1)
        XCTAssertEqual(coordinatorSpy.action, action)
    }
}
