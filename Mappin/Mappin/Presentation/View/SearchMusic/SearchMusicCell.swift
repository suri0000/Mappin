//
//  MusicListCell.swift
//  Mappin
//
//  Created by 한지석 on 2023/05/09.
//

import SwiftUI

struct SearchMusicCell: View {
    
    var music: Music
    var isSelected: Bool // State로 선언할 경우 다른 곳을 참조할 수 있음.
//    var noSelection: Bool
    
    var body: some View {
        Rectangle()
            .frame(height: 55)
            .foregroundColor(.white)
            .overlay {
                HStack(spacing: 0) {
                    Text("")
                        .frame(width: 0, height: 0)
                        .padding(.leading, 15)
                    Rectangle()
                        .frame(width: 55, height: 55)
                        .foregroundColor(Color(uiColor: .systemGray4))
                        .overlay {
                            if let existingArtwork = music.artwork {
                                AsyncImage(url: existingArtwork) { image in
                                    image
                                        .resizable()
                                        .frame(width: 55, height: 55)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 55, height: 55)
                                }
                            }
                        }
                        .cornerRadius(8)
                        .padding(.trailing, 10)
                    
                    
                    VStack(alignment: .leading) {
                        Text(music.title)
                            .font(.system(size: 17, weight: .regular))
                            .lineLimit(1)
                            .foregroundColor(.primary)
                            .padding(.bottom, -5)
                        if !music.artist.isEmpty {
                            Text(music.artist)
                                .font(.system(size: 15, weight: .regular))
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .opacity(!isSelected ? 1.0 : 0.5)
        }
    }
}
