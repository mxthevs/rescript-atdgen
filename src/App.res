type status =
  | Loading
  | Loaded(Character_t.character)
  | Error

@react.component
let make = () => {
  let (data, setData) = React.useState(_ => Loading)

  React.useEffect0(() => {
    Character.getRandomCharacter()
    ->Promise.thenResolve(character => setData(_ => Loaded(character)))
    ->Promise.catch(_ => setData(_ => Error)->Promise.resolve)
    ->ignore

    None
  })

  <div>
    {switch data {
    | Loading => `Loading...`->React.string
    | Loaded(char) =>
      <Character
        name=char.name
        image=char.image
        status=char.status
        species=char.species
        location=char.location.name
      />
    | Error => j`Oops! 😅`->React.string
    }}
  </div>
}
