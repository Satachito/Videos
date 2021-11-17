import
SwiftUI
import
AVKit
@main struct
macOSApp	: App {
	var
	body	: some Scene {
		WindowGroup {
			Window()
		}
	}
}

class
Observed : ObservableObject {
	@Published var
	observation: NSKeyValueObservation?
}

struct
Window	: View {

	@ObservedObject var
	o	= Observed()
 
	@State var
	player	: AVPlayer?

	@State var
	playing	= false

	@State var
	seekPos = 0.0

	var
	body	: some View {
		VStack {
			if let p = player {
				PlayerV( p )
				.onDisappear { p.pause() }
				Button(
					action: {
						playing.toggle()
						playing ? p.play() : p.pause()
					}
				) {
					Image( systemName: playing ? "pause" : "play" )
				}
				Slider( value: $seekPos, in: 0...1 ) { editingStarted in
					if let item = p.currentItem {
						if editingStarted {
							if playing { p.pause() }
						} else {
							p.seek(
								to: CMTime(
									seconds				: seekPos * item.duration.seconds
								,	preferredTimescale	: 600
								)
							)
							if playing { p.play() }
						}
					}
				}
			}
		}
		.frame( width: 960, height: 540 )
		.onAppear(
			perform: {
				DispatchQueue.main.async {
					let op = NSOpenPanel()
					op.allowedContentTypes = [ UTType.audiovisualContent ]
					guard op.runModal() == .OK else { return }
					let
					item = AVPlayerItem( url: op.url! )
					let
					p = AVPlayer( playerItem: item )
					player = p
					o.observation = item.observe( \.duration ) { item, change in
						print( "Duration:", item.duration )
					}
					p.addPeriodicTimeObserver(
						forInterval	: CMTime( seconds: 0.5, preferredTimescale: 600 )
					,	queue		: nil
					) {
						seekPos = $0.seconds / item.duration.seconds
					}
					playing ? p.play() : p.pause()
				}
			}
		)
	}
}

