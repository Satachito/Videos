import SwiftUI
import AVKit

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
	pvs	= [ PlayerV(), PlayerV(), PlayerV(), PlayerV() ]

	func
	SetPlayerItem( _ playerV: PlayerV, _ url: URL ) {
		playerV.player.replaceCurrentItem( with: AVPlayerItem( asset: AVAsset( url: url ) ) )
		playerV.player.play()
	}
	
	func
	Open() {
		let op = NSOpenPanel()
		op.allowedFileTypes = [ kUTTypeMovie as String ]
		op.allowsMultipleSelection = true
		guard op.runModal() == .OK else { return }
		SetPlayerItem( pvs[ 0 ], op.urls[ 0 ] )
		if op.urls.count > 1 { SetPlayerItem( pvs[ 1 ], op.urls[ 1 ] ) }
		if op.urls.count > 2 { SetPlayerItem( pvs[ 2 ], op.urls[ 2 ] ) }
		if op.urls.count > 3 { SetPlayerItem( pvs[ 3 ], op.urls[ 3 ] ) }
	}
	
	var
	body: some View {
		VStack {
			HStack {
				VStack {
					pvs[ 0 ]
					pvs[ 1 ]
				}
				VStack {
					pvs[ 2 ]
					pvs[ 3 ]
				}
			}
			Button( action: Open ) { Text( "Open" ) }
		}
		.onAppear( perform: { DispatchQueue.main.async { Open() } } )
		.onDisappear {
			pvs[ 0 ].player.pause()
			pvs[ 1 ].player.pause()
			pvs[ 2 ].player.pause()
			pvs[ 3 ].player.pause()
		}
	}
}
