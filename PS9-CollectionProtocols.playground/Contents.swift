/*:
 # CS 190 Problem Set #9&mdash;Collection Protocols
 
 [Course Home Page]( http://physics.stmarys-ca.edu/classes/CS190_S16/index.html )
 
 Due: Tuesday, May 3rd, 2016.
 
 ## Material that is Related to this Week's Lecture and this Problem Set
 
 To review the material we did in Lecture on April 26th, you could work through the playground called 3_4-CollectionProtocols in the [Intermediate Swift repo]( https://github.com/brianhill/intermediate-swift ).
 
 ## Directions Specific to this Problem Set
 
 1. (5 pts) In the LocationTrack struct below, you will find a computed property called totalLength. That's the property you computed in the last problem set. This week, you'll re-do the computation using generators. Definitely don't change the part that says "for segment in segmentSequence". If you understand why this for loop works, then you understand generators. Most of the tests will still be broken until you finish the next part.
 
 2. (5 pts) In the SegmentGenerator class below you will find a function called next(). It needs to be fixed to return segments until it runs out of segments to return. Only once it runs out should it return nil.
 
 Please do not change code outside of the two functions you were directed to change. Thanks!
 
 ## General Directions for all Problem Sets
 
 1. Fork this repository to create a repository in your own Github account. Then clone your fork to whatever machine you are working on.
 
 2. These problem sets are created with the latest version of Xcode and Mac OS X: Xcode 7.3 and OS X 10.11.4. I haven't tested how well this problem set will work under Xcode 7.2.1. Please go into Galileo 205, 206 or 208 and test your work rather than relying on the Xcode 7.2.1 machines in Garaventa.
 
 3. Under no circumstances copy-and-paste any part of a solution from another student in the class. Also, under no circumstances ask outsiders on Stack Exchange or other programmers' forums to help you create your solution. It is however fine&mdash;especially when you are truly stuck&mdash;to ask others to help you with your solution, provided you do all of the typing. They should only be looking over your shoulder and commenting. It is of course also fine to peruse StackExchange and whatever other resources you find helfpul.
 
 4. Your solution should be clean and exhibit good style. At minimum, Xcode should not flag warnings of any kind. Your style should match Apple's as shown by their examples and declarations. Use the same indentation and spacing around operators as Apple uses. Use their capitalization conventions. Use parts of speech and grammatical number the same way as Apple does. Use descriptive names for variables. Avoid acronyms or abbreviations. I am still coming up to speed on good Swift style. When there appears to be conflict my style and Apple's, copy Apple's, not mine.
 
 5. When completed, before the class the problem set is due, commit your changes to your fork of the repository. I should be able to simply clone your fork, build it and execute it in my environment without encountering any warnings, adding any dependencies or making any modifications.
 
 */

import CoreLocation

struct LocationTrack {
    
    let locations: [CLLocation]
    
    // This function returns the total length of the track by summing up the length
    // of each segment.
    var totalLength: CLLocationDistance {
        // This function is completely broken. It always returns 0. Do the right
        // calculation by uncommenting the next four lines and doint the right summation
        // in the body of the for loop. Then return the result of the summation instead of 0.
        var result: CLLocationDistance = 0
        let segmentSequence = SegmentSequence(locationTrack: self)
        for segment in segmentSequence {
            result += segment.start.distanceFromLocation(segment.end)
        }
        return result
    }
    
    // Just so you have an example to peruse, here is a function that returns an array
    // of the segment lengths. It will work properly once the next() function works properly.
    var segmentLengths: [CLLocationDistance] {
        var result: [CLLocationDistance] = []
        let segmentSequence = SegmentSequence(locationTrack: self)
        for segment in segmentSequence {
            result.append(segment.start.distanceFromLocation(segment.end))
        }
        return result
    }
}

typealias Segment = (start: CLLocation, end: CLLocation)

class SegmentGenerator: GeneratorType {
    
    let locationTrack: LocationTrack
    var index: Int = 0
    
    init(locationTrack: LocationTrack) {
        self.locationTrack = locationTrack
    }
    
    // This function returns each segment. E.g., (locations[0], locations[1]),
    // then (locations[1], locations[2]), (locations[2], locations[3]), et cetera.
    // Each pair is another segment. See the definition of Segment. It's just a named tuple.
    func next() -> Segment? {
        // The generator is completely broken. It always returns nil. Fix it.
        // Don't change anything else! There are of course plenty of ways to get the
        // right result. The point of this problem set is get the results using generators.
        index += 1
        if( index < locationTrack.locations.count) {return (locationTrack.locations[index - 1], locationTrack.locations[index])}
        else {return nil}
    }

}

struct SegmentSequence: SequenceType {
    let locationTrack: LocationTrack
    
    func generate() -> SegmentGenerator {
        return SegmentGenerator(locationTrack: locationTrack)
    }
}


import XCTest

let hmb = CLLocation(latitude: 37.4636, longitude: 122.4286)
let pacifica = CLLocation(latitude: 37.6138, longitude: 122.4869)
let sf = CLLocation(latitude: 37.7749, longitude: 122.4194)
let oakland = CLLocation(latitude: 37.8044, longitude: 122.2711)
let moraga = CLLocation(latitude: 37.8349, longitude: 122.1297)

class LocationTrackTestSuite: XCTestCase {
    
    func testTotalLengthOfTrackWithNoPoints() {
        let noPointsTrack = LocationTrack(locations: [])
        let expectedResult: CLLocationDistance = 0
        XCTAssertEqual(expectedResult, noPointsTrack.totalLength, "Zero point track should have zero length.")
    }
    
    func testTotalLengthOfTrackWithOnePoint() {
        let onePointTrack = LocationTrack(locations: [oakland])
        let expectedResult: CLLocationDistance = 0
        XCTAssertEqual(expectedResult, onePointTrack.totalLength, "Single point track should have zero length.")
    }
    
    func testTotalLengthWithThreePoints() {
        let threePointTrack = LocationTrack(locations: [sf, oakland, moraga])
        let minExpectedResult: CLLocationDistance = 20000
        let maxExpectedResult: CLLocationDistance = 30000
        let result = threePointTrack.totalLength
        XCTAssertTrue(result > minExpectedResult, "This track should be longer than than 20km.")
        XCTAssertTrue(result < maxExpectedResult, "This track should be shorter than 30km.")
    }
    
    func testSegmentLengthsForTrackWithFourPoints() {
        let fourPointTrack = LocationTrack(locations: [pacifica, sf, oakland, moraga])
        let segmentLengths = fourPointTrack.segmentLengths
        XCTAssertEqual(3, segmentLengths.count, "There should be three segment lengths for a track with four points.")
        // All three of the segment lengths are more than 10km and less than 20km.
        let minExpectedResult: CLLocationDistance = 10000
        let maxExpectedResult: CLLocationDistance = 20000
        for segmentLength in segmentLengths {
            XCTAssertTrue(segmentLength > minExpectedResult, "This segment should be longer than than 10km.")
            XCTAssertTrue(segmentLength < maxExpectedResult, "This segment should be shorter than 20km.")
        }
    }
    
    func testTotalLengthOfTrackWithFivePoints() {
        let fivePointTrack = LocationTrack(locations: [hmb, pacifica, sf, oakland, moraga])
        let minExpectedResult: CLLocationDistance = 50000
        let maxExpectedResult: CLLocationDistance = 75000
        let result = fivePointTrack.totalLength
        XCTAssertTrue(result > minExpectedResult, "This track should be longer than 50km.")
        XCTAssertTrue(result < maxExpectedResult, "This track should be shorter than 75km.")
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
