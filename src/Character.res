module Int = Belt.Int
module Float = Belt.Float

exception RequestError

let getRandomId = () => {
  let minId = 1.0
  let maxId = 826.0

  (Js.Math.random() *. (maxId -. minId))->Js.Math.floor + minId->Float.toInt
}

let getAndDecode = (url, decode) => {
  open Promise

  Fetch.fetch(
    url,
    {
      "method": "GET",
    },
  )
  ->then(Fetch.Response.json)
  ->then(json => json->decode->resolve)
  ->catch(_ => reject(RequestError))
}

let getRandomCharacter = (): Promise.t<Character_t.character> => {
  getAndDecode(
    `https://rickandmortyapi.com/api/character/${getRandomId()->Int.toString}`,
    Atdgen_codec_runtime.Decode.decode(Character_bs.read_character),
  )
}

module Styles = {
  let container = ReactDOMStyle.make(~display="flex", ~flexDirection="column", ())
  let image = ReactDOMStyle.make(~width="100px", ~height="100px", ~margin="10px 0", ())
}

@react.component
let make = (~name, ~image, ~status, ~species, ~location) => {
  <div style=Styles.container>
    <h1> {name->React.string} </h1>
    <img style=Styles.image src=image alt=name />
    <span> {`Status: ${status}`->React.string} </span>
    <span> {`Species: ${species}`->React.string} </span>
    <span> {`Location: ${location}`->React.string} </span>
  </div>
}
