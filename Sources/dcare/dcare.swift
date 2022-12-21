import Foundation
import ArgumentParser

@main
struct dcare: ParsableCommand {

    @Flag var trump = false

    public func run() throws {
        
        let url: URL
        let indexKey: String
        
        if(trump){
            url = URL(string: "https://tronalddump.io/random/quote")!
            indexKey = "value"
        }else{
            url = URL(string: "https://uselessfacts.jsph.pl/random.json?language=en")!
            indexKey = "text"
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

                    if let json = jsonSerialized, let fact = json[indexKey] {
                        print(fact)
                        dcare.exit(withError: 0 as? Error)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }

        task.resume()

        RunLoop.main.run()
    }
}
