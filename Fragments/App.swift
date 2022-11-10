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
				VideoPlayer( player: player! )
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
print( op.urls )
					var
					mp4 = Data()
					op.urls.forEach { mp4.append( try! Data( contentsOf: $0 ) ) }
					let
					url = URL( fileURLWithPath: NSTemporaryDirectory() ).appendingPathComponent(
						UUID().uuidString + ".mp4"
					)
					try! mp4.write( to: url )
					player = AVPlayer( url: url )
					player!.play()
				}
			}
		)
	}
}
