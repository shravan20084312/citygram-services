require 'spy_glass/registry'

opts = {
  path: '/komunalne-prijave-data-1',
  cache: SpyGlass::Cache::Memory.new(expires_in: 2400),
  source: 'http://clips.dunavnet.eu/api/ComunalPolice/getmessage?id=100/2015'
}

features = []

SpyGlass::Registry << SpyGlass::Client::JSON.new(opts) do |item|
  title = <<-TITLE.oneline
      Sample Komunalne-prijave data
  TITLE

  features <<  {
      'id' => "1",
      'type' => 'Feature',
      'geometry' => {
          'type' => 'Point',
          'coordinates' => [
              item['GPSY'].to_f,
              item['GPSX'].to_f
          ]
      },
      'properties' => item.merge('title' => title)
  }

  
  {'type' => 'FeatureCollection', 'features' => features}
end




