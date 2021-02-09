@module("./reportWebVitals") external reportWebVitals: unit => unit = "default"
@module("./serviceWorkerRegistration") external register: unit => unit = "register"

let rootQuery = ReactDOM.querySelector("#root")

switch rootQuery {
| None => ()
| Some(root) => ReactDOM.render(<App />, root)
}
register()

reportWebVitals()
