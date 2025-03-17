import Vapor

struct Warehouse: Content, @unchecked Sendable {
    let id: Int
    var name: String
    var location: String
}

struct Product: Content {
    let id: UUID
    let name: String
    let quantity: Int
}
