import SwiftUI
import AVKit

//	https://qiita.com/croquette0212/items/eb97e970d1dcfa2932fd

struct
PlayerV: NSViewRepresentable {

	var
	player	= AVPlayer()

	func
	updateNSView( _ v: NSView, context: NSViewRepresentableContext<PlayerV> ) {}

	func
	makeNSView( context: Context ) -> NSView {
		let v = AVPlayerView()
		v.player = player
		return v
	}
}

struct
ContentV: View {

	let
	playerV	= PlayerV()

	func
	Open() {
		let op = NSOpenPanel()
		op.allowedFileTypes = [ kUTTypeMovie as String ]
		guard op.runModal() == .OK else { return }
		playerV.player.replaceCurrentItem( with: AVPlayerItem( asset: AVAsset( url: op.url! ) ) )
		playerV.player.play()
	}
	var
	body: some View {
		VStack {
			playerV
			.onAppear( perform: { DispatchQueue.main.async { Open() } } )
			.onDisappear { playerV.player.pause() }
			Button( action: Open ) { Text( "Open" ) }
		}
	}
}
