# frozen_string_literal: true

require "httparty"
require "sinatra"
require "sinatra/base"
require "sinatra/reloader" if development?

class WeatherRuby < Sinatra::Base
  get "/autocomplete" do
    query = params[:query]
    api_key = "test"
    url = "https://api.openweathermap.org/data/2.5/find?q=#{query}&type=like&mode=json&appid=#{api_key}"
    response = HTTParty.get(url)
    if response.code == 200
      cities = response.parsed_response["list"].map { |city| city["name"] }
      puts response.parsed_response
      { suggestions: cities }.to_json
    else
      { error: "Request failed with status code #{response.code}" }.to_json
    end
  end

  get "/" do
    api_key = "test"
    @location = params[:location] || "Bend"
    # Use the location to get the forecasted amount of snowfall
    # You can use an API like OpenWeatherMap to get this data
    # and parse the JSON response to extract the snowfall amount
    @forecast = get_weather_data(@location, api_key)

    erb :index
  end

  def get_weather_data(location, api_key)
    url = "https://api.openweathermap.org/data/2.5/forecast?q=#{location}&units=imperial&appid=#{api_key}"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end
end
