require 'spy_glass/registry'

opts = {
  path: '/uk-street-crime',
  cache: SpyGlass::Cache::Memory.new(expires_in: 2400),
  source: 'http://data.police.uk/api/crimes-street/all-crime?lat=52.629729&lng=-1.131592&date=2011-08'
}


SpyGlass::Registry << SpyGlass::Client::JSON.new(opts) do |collection|
  features = collection.map do |item|
    title = <<-TITLE.oneline
      The UK Police Dept responded to #{item["category"]} #{item["location"]["street"]["name"]} by month #{item["month"]}
    TITLE
    {
      'id' => "#{item['id']}",
      'type' => 'Feature',
      'geometry' => {
        'type' => 'Point',
        'coordinates' => [
          item['location']['longitude'].to_f,
          item['location']['latitude'].to_f
        ]
      },
      'properties' => item.merge('title' => title)
    }
  end
  
  {'type' => 'FeatureCollection', 'features' => features}
end




