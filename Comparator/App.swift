import SwiftUI
import AVKit

@main struct
ComparatorApp: App {
	var
	body	: some Scene {
		WindowGroup {
			Window()
		}
	}
}

struct
Window	: View {

	struct
	Player : Identifiable {
		let	id		= UUID()
		let	url		: URL
		let	player	: AVPlayer
	}
	@State var
	players = [ Player ]()

	var
	body: some View {
		ScrollView {
			VStack( spacing: 0 ) {
				ForEach( players ) { player in
					Text( player.url.path )
					PlayerV( player.player )
					.onDisappear { player.player.pause() }
					.frame( width: 640, height: 480 )
				}
				Button(
					action: {
						players.forEach{ $0.player.play() }
					}
				) {
					Text( "Play" )
				}
			}
			.padding( .trailing )
		}
		.onAppear(
			perform: {
				DispatchQueue.main.async {
					let op = NSOpenPanel()
					op.allowedContentTypes = [ UTType.audiovisualContent ]
					op.allowsMultipleSelection = true
					guard op.runModal() == .OK else { return }
					op.urls.forEach{ players.append( Player( url: $0, player: AVPlayer( url: $0 ) ) ) }
				}
			}
		)
	}
}

