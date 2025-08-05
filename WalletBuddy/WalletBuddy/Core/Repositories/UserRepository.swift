//
//  UserRepository.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/23/25.
//
import CoreData

final class UserRepository {
    
    
    static let shared = UserRepository()
    private let context: NSManagedObjectContext

   private init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func createUser(from appUser: AppUser) {
//        let user = UserEntity(context: context)
//        user.id = appUser.id
//        user.email = appUser.email
//        user.isLoggedIn = appUser.isLoggedIn
        saveContext()
    }

    func fetchUser(byId id: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return try? context.fetch(request).first
    }

    func deleteUser(_ user: UserEntity) {
        context.delete(user)
        saveContext()
    }

    func updateLoginState(userId: String, isLoggedIn: Bool) {
        if let user = fetchUser(byId: userId) {
//            user.isLoggedIn = isLoggedIn
            saveContext()
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save failed: \(error)")
            }
        }
    }
}
