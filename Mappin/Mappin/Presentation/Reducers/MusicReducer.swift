//
//  SearchMusicReducer.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/05.
//

import UIKit

import ComposableArchitecture
import Combine


struct MusicReducer: ReducerProtocol {
    
    //    let searchMusicUseCase = DefaultSearchMusicUseCase(musicRepository: RequestMusicRepository())
    //    let musicChartUseCase = DefaultMusicChartUseCase(musicRepository: RequestMusicRepository())
    let searchMusicUseCase: SearchMusicUseCase
    let musicChartUseCase: MusicChartUseCase
    let debounceId = "Kozi"
    
    init(
        searchMusicUseCase: SearchMusicUseCase = DefaultSearchMusicUseCase(),
        musicChartUseCase: MusicChartUseCase = DefaultMusicChartUseCase()
    ) {
        self.searchMusicUseCase = searchMusicUseCase
        self.musicChartUseCase = musicChartUseCase
    }
    
    struct State: Equatable {
        var searchTerm: String = ""
        var searchMusic: [Music] = []
        var musicChart: [Music] = []
        var selectedMusicIndex: String = ""
    }
    
    enum Action {
        case resetSearchTerm
        case searchTermChanged(searchTerm: String)
        case requestMusicChart
        case applyMusicChart([Music])
        case applySearchMusic([Music])
        case resetSearchMusic
        case openAppleMusic(url: URL?)
        case appleMusicError
        case musicSelected(String)
        case uploadMusic
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .resetSearchTerm:
            state.searchTerm = ""
            return .none
            
        case .searchTermChanged(let searchTerm):
            state.searchTerm = searchTerm
            return .task {
                return try await .applySearchMusic(searchMusicUseCase.execute(searchTerm: searchTerm))
            } catch: { Error in
                print(Error)
                return .resetSearchMusic
            }
            .debounce(id: debounceId, for: 0.2, scheduler: DispatchQueue.main)
            .eraseToEffect()

        case .requestMusicChart:
            return .task {
                return .applyMusicChart(try await musicChartUseCase.execute())
            } catch: { error in
                print(error)
                return .appleMusicError
            }
            
        case .applyMusicChart(let music):
            state.selectedMusicIndex = ""
            state.musicChart = music
            return .none
            
        case .applySearchMusic(let music):
            state.selectedMusicIndex = ""
            state.searchMusic = music
            print("@LOG \(music.count)")
            return .none
            
        case .resetSearchMusic:
            state.selectedMusicIndex = ""
            state.searchMusic = []
            return .none
            
        case .openAppleMusic(let url):
            openAppleMusic(url: url)
            return .none
            
        case .appleMusicError:
            return .none
            
        case .musicSelected(let index):
            state.selectedMusicIndex = index
            return .none
            
        case .uploadMusic:
            print("upload music to server")
            return .none
        }
    }
    
}

extension MusicReducer {
    /// 유저가 애플 뮤직에서 음악을 재생할 수 있도록 이동합니다.
    /// return: void
    func openAppleMusic(url: URL?) {
        guard let appleMusicUrl = url,
              UIApplication.shared.canOpenURL(appleMusicUrl)
        else {
            print("URL이 없는 음악이거나, URL을 열 수 없음.")
            return
        }
        UIApplication.shared.open(appleMusicUrl)
    }
}

//            .run { action in
//                try await action.send(.applySearchMusic(searchMusicUseCase.execute(searchTerm: searchTerm)))
//            }
//            .debounce(id: id, for: 0.5, scheduler: DispatchQueue.main)
//            .eraseToEffect()
