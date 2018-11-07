require 'roda'
require 'slim'

module ServiceMap
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # Get /
      routing.root do
        view 'home'
      end

      routing.on 'place' do
        routing.is do
          #Post /place/
          routing.post do
            search_place = routing.params['search_place']
            routing.redirect "place/#{search_place}"
          end
        end

        routing.on String do |search_place|
          routing.get do
            place = GoogleMap::PointMapper
              .new(GM_KEY)
              .find(search_place)
            #  place_id = place.origin_id
            view 'place', locals: { place: place} #??
          end
        end
      end
    end
  end
end
