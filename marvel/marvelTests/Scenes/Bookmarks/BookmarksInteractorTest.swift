import XCTest
@testable import marvel

private final class BookmarksPresenterSpy: BookmarksPresenting {
    var viewController: BookmarksDisplaying?
    
    // MARK: - presentCharacters
    private(set) var presentCharactersCount = 0
    
    func presentCharacters(_ characters: [Character]) {
        presentCharactersCount += 1
    }
    
    // MARK: - presentEmptyView
    private(set) var presentEmptyViewCount = 0
    
    func presentEmptyView() {
        presentEmptyViewCount += 1
    }
    
    // MARK: - clearList
    private(set) var clearListCount = 0
    
    func clearList() {
        clearListCount += 1
    }
}

final class BookmarksInteractorTest: XCTestCase {
    private let presenterSpy = BookmarksPresenterSpy()
    private let characters = [
        Character(id: 1, name: "name", description: "description", thumbnail: nil, isFavorite: true),
        Character(id: 2, name: "name", description: "description", thumbnail: nil, isFavorite: true)
    ]
    
    private func setupSut(with storage: BookmarksStorageProtocol) -> BookmarksInteracting {
        let interactor = BookmarksInteractor(presenter: presenterSpy, storage: storage)
        return interactor
    }
    
    func setupStorage(with characters: [Character] = []) -> BookmarksSpy {
        BookmarksSpy(characters: characters)
    }
    
    func testFetchList_WhenBookmarksIsEmpty_ShouldPresentEmptyView() {
        let storageSpy = setupStorage()
        let sut = setupSut(with: storageSpy)
        
        sut.fetchList()
        
        XCTAssertEqual(presenterSpy.presentEmptyViewCount, 1)
        XCTAssertEqual(storageSpy.getCharactersCount, 1)
    }
    
    func testFetchList_WhenBookmarksIsNotEmpty_ShouldPresentCharacters() {
        let storageSpy = setupStorage(with: characters)
        let sut = setupSut(with: storageSpy)
        
        sut.fetchList()
        
        XCTAssertEqual(presenterSpy.presentCharactersCount, 1)
        XCTAssertEqual(storageSpy.getCharactersCount, 1)
    }
    
    func testRemoveFromBookmarks_WhenTheNumberOfBookmarksIGreaterThan1_ShouldRemoveCharacterFromStorageAndUpdateList() throws {
        let storageSpy = setupStorage(with: characters)
        let sut = setupSut(with: storageSpy)
        let firstCharacter = try XCTUnwrap(characters.first)
        sut.fetchList()
        
        sut.removeFromBookmarks(character: firstCharacter)
        
        XCTAssertEqual(storageSpy.removeCount, 1)
        XCTAssertEqual(storageSpy.removedCharacter, firstCharacter)
        XCTAssertEqual(presenterSpy.presentCharactersCount, 2)
    }
    
    func testRemoveFromBookmarks_WhenTheNumberOfBookmarksIEqual1_ShouldRemoveCharacterFromStorageAndUpdateList() throws {
        let firstCharacter = try XCTUnwrap(characters.first)
        let storageSpy = setupStorage(with: [firstCharacter])
        let sut = setupSut(with: storageSpy)
        sut.fetchList()
        
        sut.removeFromBookmarks(character: firstCharacter)
        
        XCTAssertEqual(storageSpy.removeCount, 1)
        XCTAssertEqual(storageSpy.removedCharacter, firstCharacter)
        XCTAssertEqual(presenterSpy.presentCharactersCount, 1)
        XCTAssertEqual(presenterSpy.presentEmptyViewCount, 1)
        XCTAssertEqual(presenterSpy.clearListCount, 1)
    }
}
