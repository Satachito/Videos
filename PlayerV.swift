import SwiftUI
import AVKit

struct
PlayerV: NSViewRepresentable {

	var
	player	: AVPlayer

	init( _ player: AVPlayer = AVPlayer() ) {
		self.player = player
	}

	func
	updateNSView( _ v: NSView, context: NSViewRepresentableContext<PlayerV> ) {}

	func
	makeNSView( context: Context ) -> NSView {
		let v = AVPlayerView()
		v.player = player
		return v
	}
}
