import XCTest
@testable import marvel

private final class ListPresenterSpy: ListPresenting {
    var viewController: ListDisplaying?
    
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
    
    // MARK: - presentEmptyResultView
    private(set) var presentEmptyResultViewCount = 0
    
    func presentEmptyResultView() {
        presentEmptyResultViewCount += 1
    }
    
    // MARK: - removeFeedbackView
    private(set) var removeFeedbackViewCount = 0
    
    func removeFeedbackView() {
        removeFeedbackViewCount += 1
    }
    
    // MARK: - didNextStep
    private(set) var didNextStepCount = 0
    private(set) var action: ListAction?
    
    func didNextStep(action: ListAction) {
        didNextStepCount += 1
        self.action = action
    }
}

private final class MarvelServiceMock: MarvelServicing {
    var listResult: Result<[Character], ApiError>?
    
    func list(completion: @escaping (Result<[Character], ApiError>) -> Void) {
        guard let result = listResult else {
            XCTFail("Mocked listResult for list method is nil")
            return
        }
        
        completion(result)
    }
    
    var searchResult: Result<[Character], ApiError>?
    
    func search(by name: String, completion: @escaping (Result<[Character], ApiError>) -> Void) {
        guard let result = searchResult else {
            XCTFail("Mocked searchResult for search method is nil")
            return
        }
        
        completion(result)
    }
}

final class ListInteractorTests: XCTestCase {
    private let presenterSpy = ListPresenterSpy()
    private let serviceMock = MarvelServiceMock()
    
    private lazy var sut: ListInteracting = {
        let interactor = ListInteractor(presenter: presenterSpy, service: serviceMock)
        return interactor
    }()
    
    func testFetchList_WhenSuccessResponse_ShouldPresentCharacters() {
        let mocked = [Character(id: 1, name: "name", description: nil, thumbnail: nil)]
        serviceMock.listResult = .success(mocked)
        
        sut.fetchList()
        
        XCTAssertEqual(presenterSpy.presentCharactersCount, 1)
        XCTAssertEqual(presenterSpy.characters?.count, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testFetchList_WhenSuccessResponseAndResponseIsEmpty_ShouldPresentEmptyResultView() {
        let mocked = [Character]()
        serviceMock.listResult = .success(mocked)
        
        sut.fetchList()
        
        XCTAssertEqual(presenterSpy.presentEmptyResultViewCount, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testFetchList_WhenFailureResponseAndErrorIsNoInternetConnection_ShouldPresentNoInternetView() {
        serviceMock.listResult = .failure(.internetFailure)
        
        sut.fetchList()
        
        XCTAssertEqual(presenterSpy.presentNoInternetViewCount, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testFetchList_WhenFailureResponse_ShouldPresentErrorView() {
        serviceMock.listResult = .failure(.generic)
        
        sut.fetchList()
        
        XCTAssertEqual(presenterSpy.presentErrorViewCount, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testTryAgain_WhenSuccessResponse_ShouldPresentCharactersAndRemoveFeedbackView() {
        let mocked = [Character(id: 1, name: "name", description: nil, thumbnail: nil)]
        serviceMock.listResult = .success(mocked)
        
        sut.tryAgain()
        
        XCTAssertEqual(presenterSpy.removeFeedbackViewCount, 1)
        XCTAssertEqual(presenterSpy.presentCharactersCount, 1)
        XCTAssertEqual(presenterSpy.characters?.count, 1)
        XCTAssertEqual(presenterSpy.presentLoaderCount, 1)
        XCTAssertEqual(presenterSpy.hideLoaderCount, 1)
    }
    
    func testDidSelectCharacter_WhenListHaveResult_ShouldDidNextStep() {
        let character = Character(id: 1, name: "name", description: nil, thumbnail: nil)
        serviceMock.listResult = .success([character])
        sut.fetchList()
        
        sut.didSelectCharacter(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(presenterSpy.didNextStepCount, 1)
        XCTAssertEqual(presenterSpy.action, .detail(character: character))
    }
    
    func testDidSelectCharacter_WhenListIsEmpty_ShouldDoNothing() {
        sut.didSelectCharacter(with: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(presenterSpy.didNextStepCount, 0)
        XCTAssertEqual(presenterSpy.action, nil)
    }
}

extension ListAction: Equatable {
    public static func == (lhs: ListAction, rhs: ListAction) -> Bool {
        switch (lhs, rhs) {
        case (.detail(let characterLhs), .detail(let characterRhs)):
            return characterLhs.id == characterRhs.id
        }
    }
}
