# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Agrinomicon.Repo.insert!(%Agrinomicon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Agrinomicon.Repo.insert!(%Agrinomicon.Taxonomy.Classification{
  kingdom: :plantae,
  genus: "Vitis",
  species: "Vinifera",
  binomial_name: "Vitis vinifera",
  aliases: [],
  common_names: ["table grape"]
})

Agrinomicon.Repo.insert!(%Agrinomicon.Taxonomy.Classification{
  kingdom: :plantae,
  genus: "Citrus",
  species: "C. × sinensis",
  binomial_name: "Citrus × sinensis",
  aliases: ["Citrus sinensis"],
  common_names: ["orange"]
})

Agrinomicon.Repo.insert!(%Agrinomicon.Taxonomy.Classification{
  kingdom: :plantae,
  genus: "Prunus",
  species: "Avium",
  binomial_name: "Prunus avium",
  aliases: [],
  common_names: ["cherry"]
})

Agrinomicon.Repo.insert!(%Agrinomicon.Taxonomy.Classification{
  kingdom: :plantae,
  genus: "Prunus",
  species: "Cerasus",
  binomial_name: "Prunus cerasus",
  aliases: [],
  common_names: ["cherry"]
})

Agrinomicon.Repo.insert!(%Agrinomicon.Taxonomy.Classification{
  kingdom: :plantae,
  genus: "Prunus",
  species: "Dulcis",
  binomial_name: "Prunus dulcis",
  aliases: [],
  common_names: ["almond"]
})

organization =
  Agrinomicon.Repo.insert!(%Agrinomicon.Agency.Organization{
    name: "ACME Growers, Inc."
  })

{:ok, decoded} =
  Geo.JSON.decode(
    Jason.decode!("""
    {"coordinates":[[[[-119.07133410619113,35.25979009901073],[-119.07159194687551,35.257840562970145],[-119.07298044082413,35.2556211922862],[-119.07433189226789,35.25454087974788],[-119.07433758661057,35.25269059751966],[-119.05676164980764,35.252678020044144],[-119.05673210738334,35.2597945238097],[-119.07133410619113,35.25979009901073]]],[[[-119.07423596819675,35.25985994111015],[-119.07420601101413,35.25496752727169],[-119.07291785216731,35.25623958327992],[-119.07189930796248,35.25800085864094],[-119.07153982177263,35.259786557084425],[-119.07423596819675,35.25985994111015]]]],"type":"MultiPolygon"}
    """)
  )

{[geometry | _], _} = decoded |> Map.pop(:geometries)

feature =
  Agrinomicon.Repo.insert!(%Agrinomicon.Gis.Feature{
    geometry: geometry
  })

Agrinomicon.Repo.insert!(%Agrinomicon.Agency.Block{
  name: "ACME #1",
  feature_id: feature.id,
  organization_id: organization.id
})
