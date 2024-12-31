//
//  AnimalInfoView.swift
//  CatsDogs
//
//  Created by B-Arsekin on 30.12.2024.
//

import SwiftUI

struct AnimalInfoView: View {
    
    let model: AnimalInfoModel
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: model.url)) { image in
                image
                    .resizable()
                    .frame(width: 120, height: 120)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
                    .frame(width: 120, height: 120)
            }
            
            ForEach(model.breeds) { item in
                VStack {
                    Text(item.name)
                    Text(item.description)
                    Text(item.altNames)
                }
            }
        }
    }
}
//
//#Preview {
//    AnimalInfoView()
//}
