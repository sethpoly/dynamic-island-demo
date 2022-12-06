//
//  ContentView.swift
//  DynamicIslandDemo
//
//  Created by Seth Polyniak on 12/5/22.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTimestamp = 0.0
    let song = Song(name: "All Star", artist: "Smash Mouth", length: 120.0)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            DynamicIsland(
                currentTimestamp: $currentTimestamp,
                song: song
            )
            .padding()
            .onReceive(timer) { input in
                if currentTimestamp >= song.length {
                    return
                }
                currentTimestamp += 1.0
            }
        }
    }
}

private struct DynamicIsland: View {
    @Binding var currentTimestamp: Double
    @State private var isCollapsed = true
    let song: Song
    var backgroundColor: Color = .black
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundColor
            if isCollapsed {
                HStack {
                    // MARK: Album image
                    Image("smash_mouth_album")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .cornerRadius(100)
                    
                    Spacer()
                    AudioVisualizer()
                }
                .frame(width: 200)
                .padding()
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleDisplay()
                }
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        // MARK: Album image
                        Image("smash_mouth_album")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading) {
                            // MARK: Song name
                            Text(song.name)
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            // MARK: Artist
                            Text(song.artist)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // MARK: Audio display
                        AudioVisualizer()
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: Scrubber
                    HStack {
                        Text("\(currentTimestamp.minutes)")
                        Scrubber(value: $currentTimestamp, maxValue: song.length)
                        Text("\(song.length.minutes)")
                    }
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 16)
                    
                    // MARK: RW/PLAY/FF
                    HStack(spacing: 32) {
                        MediaButton(mediaAction: .rewind)
                            .frame(width: 32)
                        MediaButton(mediaAction: .pause)
                            .frame(width: 32)
                        MediaButton(mediaAction: .fastForward)
                            .frame(width: 32)

                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .padding(.vertical, 16)
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleDisplay()
                }
            }
        }
        .cornerRadius(48)
        .fixedSize(horizontal: isCollapsed, vertical: true)
    }
    
    func toggleDisplay() {
        withAnimation(.linear(duration: 0.2)) {
            isCollapsed.toggle()
        }
    }
}

struct Scrubber: View {
    @Binding var value: Double
    let maxValue: Double
    
    var body: some View {
        UISliderView(
            value: $value,
            minValue: 0.0,
            maxValue: maxValue,
            thumbColor: .clear,
            minTrackColor: .white, maxTrackColor: .gray
        )
    }
}

struct AudioVisualizer: View {
    @State private var drawingHeight = true
    var color: Color = .green
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0...7, id: \.self) { _ in
                bar(low: Double.random(in: 0.3...0.7))
                    .animation(animation.speed(Double.random(in: 1.2...1.7)), value: drawingHeight)
            }
        }
        .onAppear{
            drawingHeight.toggle()
        }
    }
    
    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(color)
            .frame(height: (drawingHeight ? high : low) * 24)
            .frame(height: 24, alignment: .center)
            .frame(width: 4)
    }
    
    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
}

struct MediaButton: View {
    let mediaAction: MediaAction
    var onClick: () -> Void = {}
    
    var body: some View {
        Button(action: onClick) {
            Image(systemName: mediaAction.image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
