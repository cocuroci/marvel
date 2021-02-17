import XCTest
@testable import marvel

private final class SearchPresenterSpy: SearchPresenting {
    var viewController: SearchDisplaying?
    
    // MARK: - presentCharacters
    private(set) var presentCharactersCount = 0
    private(set) var characters: [Character]?
    
    func presentCharacters(_ characters: [Character]) {
        presentCharactersCount += 1
        self.characters = characters
    }
    
    // MARK: - presentLoader
    private(set) var presentLoaderCount = 0
    
    func presentLoader() {
        presentLoaderCount += 1
    }
    
    // MARK: - hideLoader
    private(set) var hideLoaderCount = 0
    
    func hideLoader() {
        hideLoaderCount += 1
    }
    
    // MARK: - presentEmptyResultView
    private(set) var presentEmptyResultViewCount = 0
    
    func presentEmptyResultView() {
        presentEmptyResultViewCount += 1
    }
    
    // MARK: - presentNoInternetView
    private(set) var presentNoInternetViewCount = 0
    
    func presentNoInternetView() {
        presentNoInternetViewCount += 1
    }
    
    // MARK: - presentErrorView
    private(set) var presentErrorViewCount = 0
    
    func presentErrorView() {
        presentErrorViewCount += 1
    }
    
    // MARK: - resetView
    private(set) var resetViewCount = 0
    
    func resetView() {
        resetViewCount += 1
    }
}

private final class SearchDelegateSpy: SearchDelegate {
    // MARK: - didSelectedCharacter
    private(set) var didSelectedCharacterCount = 0
    private(set) var character: Character?
    
    func didSelectedCharacter(_ character: Character) {
        didSelectedCharacterCount += 1
        self.character = character
    }
}

final class SearchInteractorTests: XCTestCase {
    private let presenterSpy = SearchPresenterSpy()
    private let serviceMock = MarvelServiceMock()
    private let delegateSpy = SearchDelegateSpy()
    
    private lazy var sut: SearchInteracting = {
        let interactor = SearchInteractor(presenter: presenterSpy, service: serviceMock)
        interactor.delegate = delegateSpy
        return interactor
    }()
    
    func testSearch_WhenNameIsEmpty_ShouldDoNothing() {
        serviceMock.searchResult = .success([])
        
        sut.search(with: nil)
        
        XCTAssertEqual(presenterSpy.presentCharactersCount, 0)
        XCTAssertNil(presenterSpy.characters)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 0)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 0)
    }
    
    func testSearch_WhenNameIsNotEmptyAndSuccessResult_ShouldPresenterCharacters() {
        serviceMock.searchResult = .success([Character(id: 1, name: "Spider", description: "description", thumbnail: nil)])
        
        sut.search(with: "spider")
        
        XCTAssertEqual(presenterSpy.presentCharactersCount, 1)
        XCTAssertEqual(presenterSpy.characters?.count, 1)
        XCTAssertEqual(presenterSpy.characters?.first?.name, "Spider")
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testSearch_WhenNameIsNotEmptyAndSuccessResultAndResultIsEmpty_ShouldPresenterEmptyResultView() {
        serviceMock.searchResult = .success([])
        
        sut.search(with: "spider")
        
        XCTAssertEqual(presenterSpy.presentEmptyResultViewCount, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testSearch_WhenFailureResponseAndErrorIsNoInternetConnection_ShouldPresentNoInternetView() {
        serviceMock.searchResult = .failure(.internetFailure)
        
        sut.search(with: "spider")
        
        XCTAssertEqual(presenterSpy.presentNoInternetViewCount, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testSearch_WhenFailureResponse_ShouldPresentErrorView() {
        serviceMock.searchResult = .failure(.generic)
        
        sut.search(with: "spider")
        
        XCTAssertEqual(presenterSpy.presentErrorViewCount, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testDidDismissSearch_ShouldResetView() {
        sut.didDismissSearch()
        
        XCTAssertEqual(presenterSpy.resetViewCount, 1)
    }
    
    func testDidSelectCharacter_WhenListIsEmpty_ShouldDoNothing() {
        serviceMock.searchResult = .success([])
        sut.search(with: "spider")
        
        sut.didSelectCharacter(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(delegateSpy.didSelectedCharacterCount, 0)
        XCTAssertNil(delegateSpy.character)
    }
    
    func testDidSelectCharacter_ShouldCallDelegate() {
        let character = Character(id: 1, name: "Spider", description: "description", thumbnail: nil)
        serviceMock.searchResult = .success([character])
        sut.search(with: "spider")
        
        sut.didSelectCharacter(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(delegateSpy.didSelectedCharacterCount, 1)
        XCTAssertEqual(delegateSpy.character, character)
    }
}
