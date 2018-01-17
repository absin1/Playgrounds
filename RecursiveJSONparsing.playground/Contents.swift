//: Playground - noun: a place where people can play

import UIKit


struct Foo {
    
    var name: String
    var kind: Kind
    
    enum Kind {
        case node([Foo])
        case leaf
    }
    
    init(name: String, kind: Kind) {
        self.name = name
        self.kind = kind
    }
}
extension Foo : Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case nodes
    }
    
    enum CodableError: Error {
        case decoding(String)
        case encoding(String)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        switch kind {
        case .node(let nodes):
            var array = container.nestedUnkeyedContainer(forKey: .nodes)
            try array.encode(contentsOf: nodes)
            break
        case .leaf:
            break
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Assumes name exists for all objects
        if let name = try? container.decode(String.self, forKey: .name) {
            self.name = name
            self.kind = .leaf
            if let array = try? container.decode([Foo].self, forKey: .nodes) {
                self.kind = .node(array)
            }
            return
        }
        throw CodableError.decoding("Decoding Error")
    }
}

extension Foo : CustomStringConvertible {
    
    var description: String {
        return stringDescription(self)
    }
    
    private func stringDescription(_ foo: Foo) -> String {
        var string = ""
        switch foo.kind {
        case .leaf:
            return foo.name
        case .node(let nodes):
            string += "\(foo.name): ("
            for i in nodes.indices {
                string += stringDescription(nodes[i])
                // Comma seperate all but the last
                if i < nodes.count - 1 { string += ", " }
            }
            string += ")"
        }
        return string
    }
}

let a = Foo(name: "A", kind: .leaf)
let b = Foo(name: "B", kind: .leaf)
let c = Foo(name: "C", kind: .leaf)
let d = Foo(name: "D", kind: .node([b, c]))
let root = Foo(name: "ROOT", kind: .node([a, d]))

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try! encoder.encode(root)
let json = String(data: jsonData, encoding: .utf8)!
print("Foo to JSON:")
print(json)

let decoder = JSONDecoder()
do {
    let foo = try decoder.decode(Foo.self, from: jsonData)
    print("JSON to Foo:")
    print(foo)
} catch {
    print(error)
}
