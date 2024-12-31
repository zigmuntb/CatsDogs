//
//  CatsDogsVM.swift
//  CatsDogs
//
//  Created by B-Arsekin on 30.12.2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class CatsDogsVM: ObservableObject {
    @Published private var cats: [AnimalModel] = []
    @Published private var dogs: [AnimalModel] = []
    
    @Published var animals: [AnimalModel] = []
    
    @Published var selection: ContentView.Animal = .cat

    @Published var navigation: NavigationPath = .init()
    
    private var bag = Set<AnyCancellable>()
    
    private let networkManager: NetworkManaging
        
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
        observeSelection()
    }
    
    //MARK: - Public
    func requestAnimalInformation(id: String) async throws {
        
        do {
            guard let catUrl = URL(string: "https://api.thecatapi.com/v1/images/\(id)") else {
                throw NetworkManager.NetworkError.invalidURL
            }
            let model: AnimalInfoModel = try await networkManager.get(url: catUrl)
            
            navigation.append(model)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    //MARK: - Private
    private func observeSelection() {
        $selection.sink { [weak self] selected in
            guard let self = self else { return }
            switch selected {
                case .cat:
                    self.animals = cats
                    if self.cats.isEmpty {
                        Task {
                            await self.makeRequest()
                        }
                    }
                case .dog:
                    self.animals = dogs
                    if self.dogs.isEmpty {
                        Task {
                            await self.makeRequest()
                        }
                    }
            }
            
        }
        .store(in: &bag)
    }
    
    private func makeRequest() async {
        switch selection {
            case .cat:
                await requestCats()
            case .dog:
                await requestDogs()
        }
    }
    
    private func requestCats() async {
        do {
            guard let catUrl = URL(string: "https://api.thecatapi.com/v1/images/search?limit=20") else { return }
            let models: [AnimalModel] = try await networkManager.get(url: catUrl)
            
            cats = models
            animals = cats
        } catch {
            
        }
    }
    
    private func requestDogs() async {
        do {
            guard let catUrl = URL(string: "https://api.thedogapi.com/v1/images/search?limit=20") else { return }
            let models: [AnimalModel] = try await networkManager.get(url: catUrl)
            
            dogs = models
            animals = dogs
        } catch {
            
        }
    }
}
