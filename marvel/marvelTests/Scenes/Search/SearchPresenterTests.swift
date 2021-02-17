import XCTest
@testable import marvel

private final class SearchViewControllerSpy: SearchDisplaying {
    // MARK: - displayCharacters
    private(set) var displayCharactersCount = 0
    private(set) var characters: [Character]?
    
    func displayCharacters(_ characters: [Character]) {
        displayCharactersCount += 1
        self.characters = characters
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
    
    // MARK: - displayLoader
    private(set) var displayLoaderCount = 0
    
    func displayLoader() {
        displayLoaderCount += 1
    }
    
    // MARK: - displayFeedbackView
    private(set) var displayFeedbackViewCount = 0
    private(set) var textFeedbackView: String?
    private(set) var imageNameFeedbackView: String?
    private(set) var hideActionButtonFeedbackView: Bool?
    
    func displayFeedbackView(text: String, imageName: String, hideActionButton: Bool) {
        displayFeedbackViewCount += 1
        textFeedbackView = text
        imageNameFeedbackView = imageName
        hideActionButtonFeedbackView = hideActionButton
    }
    
    // MARK: - hideLoader
    private(set) var hideLoaderCount = 0
    
    func hideLoader() {
        hideLoaderCount += 1
    }
    
    // MARK: - resetView
    private(set) var resetViewCount = 0
    
    func resetView() {
        resetViewCount += 1
    }
}

final class SearchPresenterTests: XCTestCase {
    private let viewControllerSpy = SearchViewControllerSpy()
    
    private lazy var sut: SearchPresenting = {
        let presenter = SearchPresenter()
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func testPresentCharacters_ShouldDisplayCharacters() {
        let characters = [Character(id: 1, name: "name", description: "description", thumbnail: nil)]
        
        sut.presentCharacters(characters)
        
        XCTAssertEqual(viewControllerSpy.displayCharactersCount, 1)
        XCTAssertEqual(viewControllerSpy.characters, characters)
    }
    
    func testPresentLoader_ShouldDisplayLoader() {
        sut.presentLoader()
        
        XCTAssertEqual(viewControllerSpy.displayLoaderCount, 1)
    }
    
    func testHideLoader_ShouldHideLoader() {
        sut.hideLoader()
        
        XCTAssertEqual(viewControllerSpy.hideLoaderCount, 1)
    }
    
    func testPresentEmptyResultView_ShouldDisplayEmptyResultView() {
        sut.presentEmptyResultView()
        
        XCTAssertEqual(viewControllerSpy.displayEmptyViewCount, 1)
        XCTAssertEqual(viewControllerSpy.textDisplayEmptyView, "Busca não encontrada")
        XCTAssertEqual(viewControllerSpy.imageNameDisplayEmptyView, "exclamationmark.circle")
    }
    
    func testPresentNoInternetView_ShouldDisplayFeedbackView() {
        sut.presentNoInternetView()
        
        XCTAssertEqual(viewControllerSpy.displayFeedbackViewCount, 1)
        XCTAssertEqual(viewControllerSpy.textFeedbackView, "Sem conexão")
        XCTAssertEqual(viewControllerSpy.imageNameFeedbackView, "wifi.slash")
        XCTAssertEqual(viewControllerSpy.hideActionButtonFeedbackView, true)
    }
    
    func testPresentErrorView_ShouldDisplayFeedbackView() {
        sut.presentErrorView()
        
        XCTAssertEqual(viewControllerSpy.displayFeedbackViewCount, 1)
        XCTAssertEqual(viewControllerSpy.textFeedbackView, "Ops! Falha na requisição")
        XCTAssertEqual(viewControllerSpy.imageNameFeedbackView, "exclamationmark.circle")
        XCTAssertEqual(viewControllerSpy.hideActionButtonFeedbackView, true)
    }
    
    func testResetView_ShouldResetView() {
        sut.resetView()
        
        XCTAssertEqual(viewControllerSpy.resetViewCount, 1)
    }
}
