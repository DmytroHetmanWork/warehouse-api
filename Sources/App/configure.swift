import Vapor
import Fluent
import FluentPostgresDriver
import FluentSQL

public func configure(_ app: Application) throws {
    // Configure PostgreSQL database
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor",
        password: Environment.get("DATABASE_PASSWORD") ?? "password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    // Add migrations
    app.migrations.add(CreateWarehouse())

    // Run migrations
    try app.autoMigrate().wait()

    // Register routes
    try routes(app)
}
