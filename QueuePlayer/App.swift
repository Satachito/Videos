import
SwiftUI

import
AVKit

@main struct
QueuePlayerApp: App {

	var
	body: some Scene {
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
		let	player	: AVPlayer
	}

	@State var
	players = [ Player ]()

	var
	body: some View {
		ScrollView {
			VStack( spacing: 0 ) {
				ForEach( players ) {
					PlayerV( $0.player )
					.frame( height: 256 )
				}
			}
			.padding( .trailing )
			.onAppear(
				perform: {
					DispatchQueue.main.async {
						let op = NSOpenPanel()
						op.canChooseDirectories = true
						op.canChooseFiles = false
						guard op.runModal() == .OK else { return }

						let
						queuePlayer = AVQueuePlayer()
						players.append( Player( player: queuePlayer ) )
						
						let
						dir = op.url!

//						let
//						moov = try! Data( contentsOf: dir.appendingPathComponent( "1.moov" ) )
//
//						try! FileManager.default.contentsOfDirectory( atPath: dir.path ).filter{
//							let components = $0.split( separator: "." )
//							return components[ 1 ] == "moof" && Int( components[ 0 ] ) != nil
//						}.map{
//							Int( $0.split( separator: "." )[ 0 ] )!
//						}.sorted().forEach {
//print( $0 )
//							var
//							mp4 = Data()
//							mp4.append( moov )
//							mp4.append( try! Data( contentsOf: dir.appendingPathComponent( String( $0 ) + ".moof" ) ) )
//							mp4.append( try! Data( contentsOf: dir.appendingPathComponent( String( $0 + 1 ) + ".mdat" ) ) )
//
//							let
//							url = URL( fileURLWithPath: NSTemporaryDirectory() ).appendingPathComponent( UUID().uuidString + ".mp4" )
//							try! mp4.write( to: url )
//							queuePlayer.insert( AVPlayerItem( url: url ), after: nil )
//							players.append( Player( player: AVPlayer( url: url ) ) )
//						}
						let
						moov = try! Data( contentsOf: dir.appendingPathComponent( "00.moov" ) )

						let
						num2RE = try! NSRegularExpression( pattern: "^[0-9][0-9]", options: [] )

						try! FileManager.default.contentsOfDirectory( atPath: dir.path ).filter{
							$0.hasSuffix( ".moof" ) && num2RE.numberOfMatches( in: $0, options: [], range: NSRange( 0 ..< $0.count ) ) > 0
						}.sorted().forEach {
							let
							numPart = $0.replacingOccurrences( of: ".moof", with: "." )
							var
							mp4 = Data()
							mp4.append( moov )
							mp4.append( try! Data( contentsOf: dir.appendingPathComponent( numPart + "moof" ) ) )
							mp4.append( try! Data( contentsOf: dir.appendingPathComponent( numPart + "mdat" ) ) )

							let
							url = URL( fileURLWithPath: NSTemporaryDirectory() ).appendingPathComponent( UUID().uuidString + ".mp4" )
							try! mp4.write( to: url )
							queuePlayer.insert( AVPlayerItem( url: url ), after: nil )
							players.append( Player( player: AVPlayer( url: url ) ) )
						}
					}
				}
			)
		}
	}
}
