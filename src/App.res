%%raw(`import './App.css';`)

@module("./logo.svg") external logo: string = "default"

@react.component
let make = () => {
  let (db, setDb) = React.useState(() => None)
  React.useEffect1(() => {
    let dbPromise = Db.make()->Promise.map(db => {
      setDb(_ => Some(db))
      db
    })

    Some(
      () => {
        let _ = dbPromise->Promise.then(db => db->Db.destroy)
      },
    )
  }, [setDb])

  Js.log2("db is", db)

  <div className="App">
    <header className="App-header">
      <img src={logo} className="App-logo" alt="logo" />
      <p>
        {React.string("Edit ")}
        <code> {React.string("src/App.js")} </code>
        {React.string(" and save to reload.")}
      </p>
      <a className="App-link" href="https://reactjs.org" target="_blank" rel="noopener noreferrer">
        {React.string("Learn React")}
      </a>
    </header>
  </div>
}
