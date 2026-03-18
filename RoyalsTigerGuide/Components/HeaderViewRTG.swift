import SwiftUI

struct HeaderViewRTG: View {
    let title: String
    var showBack: Bool = false
    var backAction: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .overlay(
                    Image("header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                )
                .clipped()
                .ignoresSafeArea(edges: .top)

            HStack {
                if showBack {
                    Button(action: { backAction?() }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.4))
                                .frame(width: adaptyW(40), height: adaptyW(40))

                            Image(systemName: "chevron.left")
                                .font(.system(size: adaptyW(16), weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                }

                Spacer()

                Text(title)
                    .font(.system(size: adaptyW(20), weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Capsule())
                    
                Spacer()

                if showBack {
                    Color.clear
                        .frame(width: adaptyW(40), height: adaptyW(40))
                }
            }
            .padding(.horizontal, adaptyW(16))
            .padding(.bottom, adaptyH(12))
        }
        .frame(height: adaptyH(40))
    }
}

