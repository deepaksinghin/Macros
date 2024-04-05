import Team
import ObjectiveC

@EnumTitleSupport
enum ChatType {
    case ai
    case system
    case agent
}

@EnumTitleSupport
enum Genre {
    case horror
    case comedy
    case kids
    case action
}

let test = ChatType.agent
print(test.title)

@DebugLogger
class Demo {
    
    init() {
        log(issue: "Demo class initialised")
    }
}

@PrintDeinit
class Demo2: NSObject {

    deinit {
        print("Demo2 deallocated")
    }
}

var obj2 = Demo2()
