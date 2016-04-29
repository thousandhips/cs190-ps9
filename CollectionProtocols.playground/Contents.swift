/*:
 # CS 190 Problem Set #9&mdash;CollectionProtocols
 
 [Course Home Page]( http://physics.stmarys-ca.edu/classes/CS190_S16/index.html )
 
 Due: Tuesday, May 3rd, 2016.
 
 ## Material that is Related to this Week's Lectures and this Problem Set
 
 To review the material we did in Lecture on April 26th, you could work through the [playground on Collection Protocols]( https://github.com/brianhill/intermediate-swift/tree/master/3_4-CollectionProtocols.playground ).
 
 ## Directions Specific to this Problem Set
 
 THIS PROBLEM SET ISN'T DONE YET. I JUST INITIALIZED THE REPO WITH THE SOLUTION TO THE PREVIOUS PROBLEM SET. YOU WILL BE BUILDING ON THAT.
 
 ## General Directions for all Problem Sets
 
 1. Fork this repository to create a repository in your own Github account. Then clone your fork to whatever machine you are working on.
 
 2. These problem sets are created with the latest version of Xcode and Mac OS X: Xcode 7.3 and OS X 10.11.4. I haven't tested how well this problem set will work under Xcode 7.2.1. Please go into Galileo 205, 206 or 208 and test your work rather than relying on the Xcode 7.2.1 machines in Garaventa.
 
 3. Under no circumstances copy-and-paste any part of a solution from another student in the class. Also, under no circumstances ask outsiders on Stack Exchange or other programmers' forums to help you create your solution. It is however fine&mdash;especially when you are truly stuck&mdash;to ask others to help you with your solution, provided you do all of the typing. They should only be looking over your shoulder and commenting. It is of course also fine to peruse StackExchange and whatever other resources you find helfpul.
 
 4. Your solution should be clean and exhibit good style. At minimum, Xcode should not flag warnings of any kind. Your style should match Apple's as shown by their examples and declarations. Use the same indentation and spacing around operators as Apple uses. Use their capitalization conventions. Use parts of speech and grammatical number the same way as Apple does. Use descriptive names for variables. Avoid acronyms or abbreviations. I am still coming up to speed on good Swift style. When there appears to be conflict my style and Apple's, copy Apple's, not mine.
 
 5. When completed, before the class the problem set is due, commit your changes to your fork of the repository. I should be able to simply clone your fork, build it and execute it in my environment without encountering any warnings, adding any dependencies or making any modifications.
 
 */

import CoreLocation

struct LocationTrack {
    
    var locations: [CLLocation]
    
    var length: CLLocationDistance {
        // this function should sum up all the distances between the locations in the track
        let segmentCount = locations.count - 1 > 0 ? locations.count - 1 : 0
        var trackLength: CLLocationDistance = 0
        for i in 0..<segmentCount {
            trackLength += locations[i].distanceFromLocation(locations[i + 1])
        }
        return trackLength
    }
    
}


import XCTest

class LocationTrackTestSuite: XCTestCase {
    
    func testLengthOfTrackWithNoPoints() {
        let noPointsTrack = LocationTrack(locations: [])
        let expectedResult: CLLocationDistance = 0
        XCTAssertEqual(expectedResult, noPointsTrack.length, "Zero point track should have zero length.")
    }
    
    func testLengthOfTrackWithOnePoint() {
        let oakland = CLLocation(latitude: 37.8044, longitude: 122.2711)
        let onePointTrack = LocationTrack(locations: [oakland])
        let expectedResult: CLLocationDistance = 0
        XCTAssertEqual(expectedResult, onePointTrack.length, "Single point track should have zero length.")
    }
    
    func testLengthOfTrackWithThreePoints() {
        let sf = CLLocation(latitude: 37.7749, longitude: 122.4194)
        let oakland = CLLocation(latitude: 37.8044, longitude: 122.2711)
        let moraga = CLLocation(latitude: 37.8349, longitude: 122.1297)
        let threePointTrack = LocationTrack(locations: [sf, oakland, moraga])
        let minExpectedResult: CLLocationDistance = 20000
        let maxExpectedResult: CLLocationDistance = 40000
        XCTAssertTrue(threePointTrack.length > minExpectedResult, "Hmmm. I really doubt this track is shorter than 20km.")
        XCTAssertTrue(threePointTrack.length < maxExpectedResult, "Hmmm. I really doubt this track is longer than 40km.")
    }
    
    
}
/*:
 The last bit of arcana is necessary to support the execution of unit tests in a playground, but isn't documented in [Apple's XCTest Library]( https://github.com/apple/swift-corelibs-xctest ). I gratefully acknowledge Stuart Sharpe for sharing it in his blog post, [TDD in Swift Playgrounds]( http://initwithstyle.net/2015/11/tdd-in-swift-playgrounds/ ). */
class PlaygroundTestObserver : NSObject, XCTestObservation {
    @objc func testCase(testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: UInt) {
        print("Test failed on line \(lineNumber): \(description)")
    }
}

XCTestObservationCenter.sharedTestObservationCenter().addTestObserver(PlaygroundTestObserver())

LocationTrackTestSuite.defaultTestSuite().runTest()
