//
//  ContentView.swift
//  Mappin
//
//  Created by changgyo seo on 2023/05/03.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct ContentView: View {
    
    @ObservedObject var viewStore: ViewStoreOf<PinMusicReducer>
    @State var temp: Double = 100
    @State var action: MapView.Action = .none
    
    init(viewStore: ViewStoreOf<PinMusicReducer>) {
        self.viewStore = viewStore
    }

    
    var body: some View {
        MapView(action: .constant(.none), store: viewStore, userTrackingMode: .follow)
            .ignoresSafeArea()
            .opacity(Double(action.yame))
            
    }
    
}

extension ContentView {
    static func build() -> Self {
        let viewStore = ViewStore(Store(
            initialState: PinMusicReducer.State(),
            reducer: PinMusicReducer.build()
        ))
        return ContentView(viewStore: viewStore)
    }
}

extension UUID: Identifiable {
    public var id: String { self.uuidString }
}
