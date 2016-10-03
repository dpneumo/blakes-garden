require 'yaml'

class Grasses
  def self.list
    [
      'inland_sea_oats.yml',
      'eastern_gamagrass.yml'
    ]
  end
end

class GrassBuilder
  attr_reader :grass_list,
  def initialize(grasses: Grasses)
    @grasses = grasses
    @grass_list = @grasses.list
  end

  def run
    grass_list.each do |grass|
      load(grass)
      builder = {display: '', local_image: '', remote_image: ''}
      image_data.each do |image|
        builder[:display] += display(image)
        builder[:local_image] += local_image(image)
        builder[:remote_image] += remote_image(image)
      end
      grasspage = ''
      grasspage << frontmatter << header << builder[:display] << "\n" <<
                   builder[:local_image] << "\n" << builder[:remote_image]

      File.open(name+'_test.md', 'w') {|f| f.write grasspage }
    end
  end

  private
  attr_reader :title, :name, :symbol, :remote_name, :remote_url, :image_data
  def load(grass)
    data = YAML.load_file('data/'+grass)
    @title, @name, @symbol = data['title'], data['name'], data['symbol']
    @remote_name, @remote_url = data['remote_name'], data['remote_url']
    @image_data = data['image_data']
  end

  def front_matter
    <<-HEREDOC
---
layout: default
title: #{title}
name: #{name}
symbol: #{symbol}
---
    HEREDOC
  end

  def header
    <<-HEREDOC
## #{title}

[#{remote_name} - {{ page.title }} ](#{remote_url}/plants/result.php?id_plant={{ page.symbol }})

    HEREDOC
  end

  def display(image)
    local_key  = "[![#{image[:local_img_key]}]]"
    remote_key = "[#{image[:remote_img_key]}]\n"
  end

  def local_image(image)
    key = "[#{image[:local_img_key]}]: "
    url = "{{ site.baseurl }}/images/grasses/{{ page.name }}/#{image[:img_name]}\n"
    key + url
  end

  def remote_image(image)
    key = "[#{image[:remote_img_key]}]: "
    url = "#{remote_url}/gallery/result.php?id_image=#{image[:remote_img_id] } "
    attrib = "\"#{image[:photographer]}, #{remote_name}\"\n"
    key + url + attrib
  end
end



