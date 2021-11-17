import
SwiftUI

import
AVKit

@main struct
FragmentsApp: App {
	var
	body: some Scene {
		WindowGroup {
			Window()
		}
	}
}

struct
Window	: View {
	@State var
	player	: AVPlayer?
	@State var
	alert	: Bool = false
	var
	body	: some View {
		VStack {
			if player != nil {
				PlayerV( player! )
			}
		}.alert( isPresented: $alert ) {
			Alert( title: Text( "Specify 'moov', 'moof', 'mdat'" ) )
		}
		.frame( width: 640, height: 480 )
		.onAppear(
			perform: {
				DispatchQueue.main.async {
					let op = NSOpenPanel()
					op.allowsMultipleSelection = true
					guard op.runModal() == .OK else { return }
					let	moov = op.urls.filter{ $0.path.hasSuffix( ".moov" ) }
					let	moof = op.urls.filter{ $0.path.hasSuffix( ".moof" ) }
					let	mdat = op.urls.filter{ $0.path.hasSuffix( ".mdat" ) }
					guard moov.count == 1 && moof.count == 1 && mdat.count == 1 else { alert = true; return }
					var
					mp4 = Data()
					mp4.append( try! Data( contentsOf: moov[ 0 ] ) )
					mp4.append( try! Data( contentsOf: moof[ 0 ] ) )
					mp4.append( try! Data( contentsOf: mdat[ 0 ] ) )
					let
					url = URL( fileURLWithPath: NSTemporaryDirectory() ).appendingPathComponent( UUID().uuidString + ".mp4" )
					try! mp4.write( to: url )
					player = AVPlayer( url: url )
					player!.play()
				}
			}
		)
	}
}
