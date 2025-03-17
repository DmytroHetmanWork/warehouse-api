import Fluent

struct CreateWarehouse: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("warehouses")
            .id()
            .field("name", .string, .required)
            .field("location", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("warehouses").delete()
    }
}
