@module("./reportWebVitals") external reportWebVitals: unit => unit = "default"
@module("./serviceWorkerRegistration") external register: unit => unit = "register"

{
  let maxwidth = 40.0
  open CssJs
  global(.
    "body",
    [
      fontFamily(#custom("Garamond")),
      maxWidth(maxwidth->#rem),
      border(1->px, #solid, lightgrey),
      margin(2.0->#rem),
    ],
  )
  global(.
    "h1, h2, h3",
    [
      color("656565"->hex),
      borderBottom(1->px, #dashed, lightgrey),
      maxWidth((maxwidth /. 2.0)->#rem),
    ],
  )
}

let rootQuery = ReactDOM.querySelector("#root")

switch rootQuery {
| None => ()
| Some(root) => ReactDOM.render(<App />, root)
}
register()

reportWebVitals()
