import XCTest
@testable import Strapi

class CreateRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurant"
		let parameterKey = "name"
		let parameterValue = "New Name"
		
		let request = CreateRequest(
			contentType: contentType,
			parameters: [parameterKey: parameterValue]
		)
		
		XCTAssertEqual(request.method, "POST")
		XCTAssertEqual(request.contentType, contentType + "s")
		XCTAssertNil(request.path)
		XCTAssertEqual(request.parameters.count, 1)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	// MARK: - Request
	
	func testUrlRequest() {
		let host = "localhost"
		let port = 1337
		let contentType = "restaurant"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let request = CreateRequest(
			contentType: contentType,
			parameters: [parameterKey: parameterValue]
		)
		
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "POST")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)s")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8"])
		XCTAssertEqual(urlRequest!.jsonString, "[\"\(parameterKey)\": \(parameterValue)]")
	}
}
