import UIKit

protocol GithubuserListStoreProtocol {
  func getData(page: Int, _ completion: @escaping (Result<[GithubUser]>) -> Void)
}

class GithubuserListWorker {

  var store: GithubuserListStoreProtocol

  init(store: GithubuserListStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func getGithubUsers(page: Int, _ completion: @escaping (Result<[GithubUser]>) -> Void) {
    store.getData(page: page) {
      completion($0)
    }
  }
}
