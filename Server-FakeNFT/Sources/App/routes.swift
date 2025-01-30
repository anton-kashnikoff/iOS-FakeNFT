import Vapor

func routes(_ app: Application) throws {
    app.get("collections") { _ async -> [Collection] in
        readyCollections
    }
    
    app.get("collections", ":id") { request async throws -> Collection in
        let id = try request.parameters.require("id")
        guard let collection = readyCollections.first(where: { $0.id == id }) else {
            throw Abort(.notFound)
        }
        return collection
    }
    
    app.get("nft") { _ async throws -> [NFT] in
        nfts
    }
    
    app.get("nft", ":id") { request async throws -> NFT in
        let id = try request.parameters.require("id")
        guard let nft = nfts.first(where: { $0.id == id }) else {
            throw Abort(.notFound)
        }
        return nft
    }
    
    app.get("users") { _ async throws -> [User] in
        users
    }
    
    app.get("users", ":id") { request async throws -> User in
        let id = try request.parameters.require("id")
        guard let user = users.first(where: { $0.id == id }) else {
            throw Abort(.notFound)
        }
        return user
    }
    
    app.get("currencies") { _ async throws -> [Currency] in
        currencies
    }
    
    app.get("currencies", ":id") { request async throws -> Currency in
        let id = try request.parameters.require("id")
        guard let currency = currencies.first(where: { $0.id == id }) else {
            throw Abort(.notFound)
        }
        return currency
    }
    
    app.get("profile", ":id") { request async throws -> Profile in
        let id = try request.parameters.require("id")
        guard let profile = profiles.first(where: { $0.id == id }) else {
            throw Abort(.notFound)
        }
        return profile
    }
    
    app.put("profile", ":id") { request async throws -> Profile in
        let id = try request.parameters.require("id")
        let profile = try request.content.decode(Profile.self)
        
        guard let profileIndex = profiles.firstIndex(where: { $0.id == id }) else {
            throw Abort(.notFound)
        }
        
        profiles.remove(at: profileIndex)
        profiles.append(profile)
        
        guard let addedProfile = profiles.first(where: {
            $0.id == profile.id
        }) else {
            throw Abort(.internalServerError)
        }
        
        return addedProfile
    }
    
    app.group("orders") { group in
        group.get(":id") { request async throws -> Order in
            let id = try request.parameters.require("id")
            guard let order = orders.first(where: { $0.id == id }) else {
                throw Abort(.notFound)
            }
            return order
        }
        
        group.put(":id") { request async throws -> Order in
            let id = try request.parameters.require("id")
            let order = try request.content.decode(Order.self)
            
            guard let orderIndex = orders.firstIndex(where: { $0.id == id }) else {
                throw Abort(.notFound)
            }
            
            orders.remove(at: orderIndex)
            orders.append(order)
            
            guard let addedOrder = orders.first(where: {
                $0.id == order.id
            }) else {
                throw Abort(.internalServerError)
            }
            
            return addedOrder
        }
    }
    
    app.get("payment", ":paymentID") { request async throws -> OrderPaymentStatus in
        let paymentID = try request.parameters.require("paymentID")

        guard let payment = payments.first(where: {
            $0.id == paymentID
        }) else {
            throw Abort(.notFound, reason: "Payment with ID \(paymentID) not found.")
        }

        return payment
    }
}
