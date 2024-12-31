//
//  ContentView.swift
//  CatsDogs
//
//  Created by B-Arsekin on 30.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    enum Animal: String {
        case cat = "Cats"
        case dog = "Dogs"
    }
    
    @StateObject private var vm = CatsDogsVM()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $vm.navigation) {
            VStack {
                
                pickerView()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(vm.animals) { item in
                            animalView(urlString: item.url)
                                .onTapGesture {
                                    Task {
                                        try await vm.requestAnimalInformation(id: item.id)
                                    }
                                }
                                .onAppear {
                                    // pagination logic. trigger vm func with item displayed to check
                                    // if current item is the last one in array
                                }
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding()
            .navigationDestination(for: AnimalInfoModel.self) { item in
                AnimalInfoView(model: item)
                    .navigationTitle(vm.selection.rawValue)
            }
        }
    }
    
    private func animalView(urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { image in
            image
                .resizable()
                .frame(width: 120, height: 120)
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
                .frame(width: 120, height: 120)
        }
        
    }
    
    private func pickerView() -> some View {
        Picker("Animals", selection: $vm.selection) {
            Text(Animal.cat.rawValue)
                .tag(Animal.cat)
            Text(Animal.dog.rawValue)
                .tag(Animal.dog)
        }
        .pickerStyle(.palette)
    }
}

#Preview {
    ContentView()
}
