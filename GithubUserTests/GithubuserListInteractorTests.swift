@testable import GithubUser
import XCTest

class GithubuserListInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var sut: GithubuserListInteractor!
  var presenterSpy: GithubuserListPresenterSpy!
  var workerSpy: GithubuserListWorkerSpy!

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupGithubuserListInteractor()
  }

  override func tearDown() {
    sut = nil
    presenterSpy = nil
    workerSpy = nil
    super.tearDown()
  }

  // MARK: - Test setup

  func setupGithubuserListInteractor() {
    sut = GithubuserListInteractor()
    presenterSpy = GithubuserListPresenterSpy()
    sut.presenter = presenterSpy
    
    workerSpy = GithubuserListWorkerSpy(store: GithubuserListStore())
    sut.worker = workerSpy
  }

  class GithubuserListPresenterSpy: GithubuserListPresenterInterface {
    var presentGithubUsersLoadingCalled = false
    var presentGithubUsersCalled = false
    var presentFavouriteUsersCalled = false

    func presentGithubUsersLoading() {
      presentGithubUsersLoadingCalled = true
    }
    
    func presentGithubUsers(response: GithubuserList.GetUser.Response) {
      presentGithubUsersCalled = true
    }
    
    func presentFavouriteUsers(response: GithubuserList.FavouriteUser.Response) {
      presentFavouriteUsersCalled = true
    }
  }
  
  class GithubuserListWorkerSpy: GithubuserListWorker {
    override func getGithubUsers(page: Int, _ completion: @escaping (Result<[GithubUser]>) -> Void) {
      let githubUser = GithubUser.init(
        login: "",
        avatarURL: "",
        htmlURL: "",
        type: "",
        siteAdmin: true,
        isFavourite: false)
      completion(.success([githubUser]))
    }
  }

  // MARK: - Tests

  func testGetGithubUsersShouldCallPresentGithubUsersLoading() {
    // When
    sut.getGithubUsers(request: GithubuserList.GetUser.Request(type: .refresh))
    
    // Then
    XCTAssertTrue(presenterSpy.presentGithubUsersLoadingCalled)
  }
  
  func testGetGithubUsersShouldCallPresentGithubUsers() {
    // When
    sut.getGithubUsers(request: GithubuserList.GetUser.Request(type: .refresh))
    
    // Then
    XCTAssertTrue(presenterSpy.presentGithubUsersCalled)
  }
  
  func testGetGithubUsersShouldCallPresentFavouriteUsers() {
    // When
    sut.getGithubUsers(request: GithubuserList.GetUser.Request(type: .refresh))
    sut.favouriteUsers(request: GithubuserList.FavouriteUser.Request(index: 0))
    
    // Then
    XCTAssertTrue(presenterSpy.presentFavouriteUsersCalled)
  }
}
