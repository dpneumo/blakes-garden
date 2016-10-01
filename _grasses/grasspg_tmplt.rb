require 'yaml'

grasses = [ 'inland_sea_oats_data.yml',
            'eastern_gamagrass.yml'
]

grasses.each do |grass_data|
  data = YAML.load_file('data/'+grass_data)

  title = data['title']
  name = data['name']
  symbol = data['symbol']
  remote_name = data['remote_name']
  remote_url = data['remote_url']
  image_data = data['image_data']

  grasspage = <<-HEREDOC
---
layout: default
title: #{title}
name: #{name}
symbol: #{symbol}
---
## #{title}

[#{remote_name} - {{ page.title }} ](#{remote_url}/plants/result.php?id_plant={{ page.symbol }})

  HEREDOC

  builder = {display: '', local_image: '', remote_image: ''}
  image_data.each do |image|
    builder[:display] += "[![#{image[:local_img_key]}]][#{image[:remote_img_key]}]\n"
    builder[:local_image] += "[#{image[:local_img_key]}]: {{ site.baseurl }}/images/grasses/{{ page.name }}/#{image[:img_name]}\n"
    builder[:remote_image] += "[#{image[:remote_img_key]}]: #{remote_url}/gallery/result.php?id_image=#{image[:remote_img_id] } \"#{image[:photographer]}, #{remote_name}\"\n"
  end

  grasspage << builder[:display] << "\n" << builder[:local_image] << "\n" << builder[:remote_image]

  File.open(name+'.md', 'w') {|f| f.write grasspage }
end
