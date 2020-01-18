import Foundation
import Alamofire

class GithubuserListStore: GithubuserListStoreProtocol {
  
  private func getHeaders() -> [String: String] {
      let userName = Credential.username.rawValue
      let password = Credential.token.rawValue
      let credentialData = "\(userName):\(password)".data(using: .utf8)
      guard let cred = credentialData else { return ["" : ""] }
      let base64Credentials = cred.base64EncodedData(options: [])
      guard let base64Date = Data(base64Encoded: base64Credentials) else { return ["" : ""] }
      return ["Authorization": "Basic \(base64Date.base64EncodedString())"]
  }
  
  func getData(page:Int, _ completion: @escaping (Result<[GithubUser]>) -> Void) {
    
    let urlString = "\(API.users.rawValue)?page=\(page)&per_page=10"
    Alamofire.request(urlString, headers: getHeaders())
    .response { response in
        guard let data = response.data else {
          completion(Result.failure)
          return
        }

        do {
            let decoder = JSONDecoder()
            let githubUser = try decoder.decode([GithubUser].self, from: data)
          completion(Result.success(githubUser))
        } catch {
          print(error)
          completion(Result.failure)
        }
    }
  }
}
