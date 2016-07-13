import Foundation
import Quick
import Nimble
import PiedPiper

var kCurrentQueue = 0

func getMutablePointer (_ object: AnyObject) -> UnsafeMutablePointer<Void> {
  return UnsafeMutablePointer<Void>(bitPattern: Int(UInt(ObjectIdentifier(object))))!
}

func currentQueueSpecific() -> UnsafeMutablePointer<Void> {
  return DispatchQueue.getSpecific(&kCurrentQueue)
}

//FIXME: Tests checking the queueSpecific don't work properly?
class GCDTests: QuickSpec {
  override func spec() {
    describe("GCD") {
      var queueSpecific: UnsafeMutablePointer<Void>!
      
      context("when running some code on the main queue") {
        beforeEach {
          GCD.main {
            queueSpecific = currentQueueSpecific()
          }
        }
        
        xit("should run the block on the main queue") {
          expect(queueSpecific).toEventually(equal(getMutablePointer(DispatchQueue.main)))
        }
      }
      
      context("when running some code on a background queue") {
        beforeEach {
          GCD.background {
            queueSpecific = currentQueueSpecific()
          }
        }
        
        xit("should run the block on the background queue") {
          expect(queueSpecific).toEventually(equal(getMutablePointer(DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault))))
        }
      }
      
      context("when creating a serial queue") {
        var reference: GCDQueue!
        
        beforeEach {
          reference = GCD.serial("test")
        }
        
        context("when executing two blocks of code") {
          var timestamp1: TimeInterval!
          var timestamp2: TimeInterval!
          
          beforeEach {
            reference.async {
              timestamp1 = Date().timeIntervalSince1970
            }
            
            reference.async {
              timestamp2 = Date().timeIntervalSince1970
            }
          }
          
          it("should execute the first block before the second") {
            expect(timestamp2).toEventually(beGreaterThan(timestamp1))
          }
        }
      }
      
      context("when initialized with a custom queue") {
        var queue: DispatchQueue!
        var reference: GCDQueue!
        
        beforeEach {
          queue = DispatchQueue(label: "custom", attributes: DispatchQueueAttributes.concurrent)
          reference = GCD(queue: queue)
        }
        
        context("when executing some code on it") {
          beforeEach {
            reference.async {
              queueSpecific = currentQueueSpecific()
            }
          }
          
          xit("should run the code on the right queue") {
            expect(queueSpecific).toEventually(equal(getMutablePointer(queue)))
          }
        }
      }
    }
  }
}
