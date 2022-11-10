import
SwiftUI
import
AVKit
@main struct
macOSApp	: App {
	var
	body	: some Scene { WindowGroup { Window() } }
}

struct
Window		: View {

	@State var
	pos			= 0.0

	@State var
	editing		= false
	
	let
	player		= AVPlayer()

	var
	playing		: Bool { get { player.timeControlStatus == .playing } }
	
	var
	body		: some View {
		VStack {
			VideoPlayer( player: player )
			.onAppear {
				DispatchQueue.main.async {
					let
					op = NSOpenPanel()
					op.allowedContentTypes = [ UTType.audiovisualContent ]
					guard op.runModal() == .OK else { return }

					let
					asset = AVURLAsset( url : op.url! )
					let
					videoAssetTrack = asset.tracks(withMediaType: .video).first!
					print( "asset.duration", asset.duration )
					print( videoAssetTrack.naturalSize )

					let
					item = AVPlayerItem( url : op.url! )
					player.replaceCurrentItem( with: item )
					player.addPeriodicTimeObserver(
						forInterval	: CMTime( seconds: 0.1, preferredTimescale: asset.duration.timescale )	//	ここの timescale は asset からとる
					,	queue		: nil
					) {
						pos = $0.seconds / item.duration.seconds
					}
					player.play()
				}
			}
			.onDisappear { player.pause() }
			Button(
				action: {
					playing ? player.pause() : player.play()
				}
			) {
				Image( systemName: playing ? "pause" : "play" )
			}
			Slider( value: $pos ) {
				editing = $0
			}
		}
		.onChange( of: pos ) {
			if editing, let item = player.currentItem {
				let status = playing
				player.pause()
				player.seek(
					to: CMTime(
						seconds				: $0 * item.duration.seconds
					,	preferredTimescale	: item.duration.timescale
					)
				)
				if status { player.play() }
			}
		}
	}
}

