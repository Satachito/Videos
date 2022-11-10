import
SwiftUI

import
AVKit

@main struct
NHKApp: App {
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
	player		: AVPlayer?

	var
	body: some View {
		VStack {
			if let p = player {
				VideoPlayer( player: p )
				.frame( width: 960, height: 540 )
			}
			Text( "eh?" )
		}
		.onAppear(
			perform: {
				DispatchQueue.main.async {
					let op = NSOpenPanel()
					op.canChooseDirectories = true
					op.canChooseFiles = false
					guard op.runModal() == .OK else { return }

					let
					dir = op.url!

					let
					FM = FileManager.default
					
					let
					max = try! FM.contentsOfDirectory( atPath: dir.path ).filter{
						let components = $0.split( separator: "." )
						return components[ 1 ] == "moof" && Int( components[ 0 ] ) != nil
					}.map{
						Int( $0.split( separator: "." )[ 0 ] )!
					}.max()!
					
					let
					path = NSTemporaryDirectory() + UUID().uuidString + ".mp4"
print( path )
					guard !FM.fileExists( atPath: path ) else { return }
					
					FM.createFile( atPath: path, contents: nil, attributes: nil )

					guard let fileHandle = FileHandle( forWritingAtPath: path ) else { return }
					defer { fileHandle.closeFile() }
					fileHandle.write( try! Data( contentsOf: dir.appendingPathComponent( "1.moov" ) ) )
					
					for i in stride( from: 2, to: max, by: 4 ) {
						fileHandle.write( try! Data( contentsOf: dir.appendingPathComponent( String( i ) + ".moof" ) ) )
						fileHandle.write( try! Data( contentsOf: dir.appendingPathComponent( String( i + 1 ) + ".mdat" ) ) )
//						fileHandle.write( try! Data( contentsOf: dir.appendingPathComponent( String( i + 2 ) + ".moof" ) ) )
//						fileHandle.write( try! Data( contentsOf: dir.appendingPathComponent( String( i + 3 ) + ".mdat" ) ) )
					}
					
					player = AVPlayer( url: URL( fileURLWithPath: path ) )
				}
			}
		)
	}
}
