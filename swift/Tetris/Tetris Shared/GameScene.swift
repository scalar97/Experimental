import SpriteKit

// 600 is the slowest milliseconds at which every tile will be falling
// i.e every 600/1000 second, evert 6/10th second, a tile will descend down.
// the higher this numbe the slower the speed because it gets closer to 1 second.
let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene{
 
    // tick is a closure, a variable that holds a funtion's address.
    // a bit like a lambda funtion in Python
    // this closure takes no parameter and returns nohing.
    var tick:( () -> () )?
    
    // if not fast forwaded, descent at normal speed
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoder not supported")
    }
    
    override init(size:CGSize){
        super.init(size: size)
        anchorPoint = CGPoint(x:0, y:1.0)
        // adding the background image
        let background = SKSpriteNode(imageNamed : "background")
        // backgound position
        background.position = CGPoint(x: 0, y: 0)
        // background's anchor point inital value
        background.anchorPoint = CGPoint(x:0, y:0)
        
        addChild(background)
    }
    
    // find out the meaning beyond that _
    override func update(_ currentTime: CFTimeInterval){
        // called before each frame is rendered
        
        // if the last tick did not happen then the game is paused
        guard let lastTick = lastTick else{
            return
        }
        // get the difference between the last Tick and now
        // multiply by -1000 to get a positif value of millisecond
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        if timePassed > tickLengthMillis {
            self.lastTick = NSDate()
            // check first if the tick function is set, execute it with no parameters
            // this notation is a chortcut to
            // if tick != nil {
            //    tick!()
            // }
            tick?()
        }
    }
    // public accessorts
    func startTicking() {
        lastTick = NSDate()
    }
    func stopTicking() {
        lastTick = nil
    }
}
