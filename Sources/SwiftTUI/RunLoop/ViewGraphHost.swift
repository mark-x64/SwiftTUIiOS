import Foundation

protocol ViewGraphHost: AnyObject {
    func invalidateNode(_ node: Node)
    func scheduleUpdate()
}
